(function () {
  "use strict";

  var STORE_KEY = "pdp-readiness-answers";
  var MODULES = [
    ["m1", "M1", "Application"],
    ["m2", "M2", "Lawful basis"],
    ["m3", "M3", "Special categories"],
    ["m4", "M4", "Consent"],
    ["m5", "M5", "Data Protection Officer"],
    ["m6", "M6", "Impact assessment"],
    ["report", "", "Report"]
  ];

  var answers = [];
  var current = null;
  var busy = false;

  function $(id) { return document.getElementById(id); }

  function el(tag, attrs) {
    var node = document.createElement(tag);
    if (attrs) {
      Object.keys(attrs).forEach(function (k) {
        if (k === "text") node.textContent = attrs[k];
        else if (k === "cls") node.className = attrs[k];
        else node.setAttribute(k, attrs[k]);
      });
    }
    for (var i = 2; i < arguments.length; i++) {
      var child = arguments[i];
      if (child == null) continue;
      node.appendChild(typeof child === "string" ? document.createTextNode(child) : child);
    }
    return node;
  }

  function save() {
    try { localStorage.setItem(STORE_KEY, JSON.stringify(answers)); } catch (e) {}
  }

  function load() {
    try {
      var raw = localStorage.getItem(STORE_KEY);
      var parsed = raw ? JSON.parse(raw) : [];
      return Array.isArray(parsed) ? parsed : [];
    } catch (e) {
      return [];
    }
  }

  function answerMap() {
    var map = {};
    answers.forEach(function (a) { map[a.fact] = a.answer; });
    return map;
  }

  function post(url, body) {
    return fetch(url, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(body)
    }).then(function (res) {
      if (!res.ok) throw new Error("HTTP " + res.status);
      return res.json();
    });
  }

  function showError(message) {
    var box = $("error");
    box.textContent = message;
    box.hidden = false;
  }

  function show(id) {
    ["intro", "question", "report"].forEach(function (s) { $(s).hidden = s !== id; });
    $("history").hidden = answers.length === 0;
  }

  function setBusy(value) {
    busy = value;
    ["yes", "no", "back"].forEach(function (id) { $(id).disabled = value; });
  }

  function step() {
    setBusy(true);
    $("error").hidden = true;
    return post("api/step", { answers: answerMap() })
      .then(function (data) {
        setBusy(false);
        if (data.type === "question") renderQuestion(data.question);
        else renderReport(data.report);
        renderHistory();
      })
      .catch(function () {
        setBusy(false);
        showError("The Prolog server could not be reached. Start it with: swipl main.pl, then type server. at the prompt, and reload this page.");
      });
  }

  function renderSteps(activeId, statuses) {
    var list = $("steps");
    list.textContent = "";
    var activeIndex = MODULES.findIndex(function (m) { return m[0] === activeId; });
    MODULES.forEach(function (m, i) {
      var cls = "";
      if (statuses) {
        if (m[0] === "report") cls = "current";
        else if (statuses[m[0]] === "evaluated") cls = "done";
        else if (statuses[m[0]] === "skipped") cls = "skipped";
      } else if (i < activeIndex) {
        cls = "done";
      } else if (i === activeIndex) {
        cls = "current";
      }
      var li = el("li", { cls: cls }, el("b", { text: m[1] || m[2] }), m[1] ? m[2] : "");
      if (cls === "current") li.setAttribute("aria-current", "step");
      list.appendChild(li);
    });
  }

  function renderQuestion(q) {
    current = q;
    show("question");
    renderSteps(q.module);
    $("q-number").textContent = "Question " + q.number;
    $("q-module").textContent = q.module.toUpperCase() + " · " + q.module_title;
    $("q-rule").textContent = q.rule.label;
    $("q-section").textContent = "(" + q.rule.section + ")";
    $("q-text").textContent = q.text;
    $("back").hidden = answers.length === 0;
    var why = $("why");
    why.hidden = true;
    why.textContent = "";
    why.appendChild(el("p", null, "This answer is needed to decide rule ", el("strong", { text: q.rule.label }), " (" + q.rule.section + "):"));
    why.appendChild(el("p", null, "IF the conditions hold THEN ", el("strong", { text: q.rule.kind_label }), ": " + q.rule.message));
    why.appendChild(el("p", { text: "Source of this question in the Act: " + q.source }));
    $("why-toggle").setAttribute("aria-expanded", "false");
    $("yes").focus();
  }

  function renderHistory() {
    var list = $("history-list");
    list.textContent = "";
    answers.forEach(function (a) {
      list.appendChild(el("li", null, a.text + " ", el("b", { text: a.answer }), " (" + a.rule + ")"));
    });
    $("history-count").textContent = answers.length;
    $("history").hidden = answers.length === 0;
  }

  function answer(value) {
    if (busy || !current) return;
    answers.push({ fact: current.fact, answer: value, text: current.text, rule: current.rule.label });
    save();
    step();
  }

  function back() {
    if (busy || answers.length === 0) return;
    answers.pop();
    save();
    step();
  }

  function restart() {
    answers = [];
    current = null;
    save();
    renderSteps("m1");
    show("intro");
    renderHistory();
  }

  function toggleWhy() {
    var why = $("why");
    why.hidden = !why.hidden;
    $("why-toggle").setAttribute("aria-expanded", String(!why.hidden));
  }

  function renderReport(r) {
    current = null;
    var statuses = {};
    r.modules.forEach(function (m) { statuses[m.id] = m.status; });
    renderSteps("report", statuses);

    var root = $("report");
    root.textContent = "";
    root.appendChild(el("div", { cls: "outcome", text: r.outcome_text }));

    if (r.outcome === "applies") {
      root.appendChild(el("div", { cls: "summary" },
        tile(r.summary.issues, "Compliance issues found"),
        tile(r.summary.required, "Obligations that apply"),
        tile(r.summary.may_require, "Obligations that may apply")));
    }

    r.modules.forEach(function (m) {
      var box = el("section", { cls: "module" },
        el("h3", null, el("span", { text: m.id.toUpperCase() }), m.title));
      m.rules.forEach(function (rule) { box.appendChild(firedRule(rule)); });
      if (m.status === "skipped") box.appendChild(el("p", { cls: "skipped", text: "Not evaluated: " + m.reason + "." }));
      else if (m.note && m.id !== "m1") box.appendChild(el("p", { cls: "note", text: m.note }));
      root.appendChild(box);
    });

    root.appendChild(el("div", { cls: "disclaimer", text: r.disclaimer }));

    var printBtn = el("button", { cls: "btn", text: "Print report" });
    printBtn.addEventListener("click", function () { window.print(); });
    var backBtn = el("button", { cls: "btn", text: "Change last answer" });
    backBtn.addEventListener("click", back);
    var newBtn = el("button", { cls: "btn primary", text: "New consultation" });
    newBtn.addEventListener("click", restart);
    root.appendChild(el("div", { cls: "actions" }, newBtn, backBtn, printBtn));
    show("report");
  }

  function tile(num, label) {
    return el("div", { cls: "tile" }, el("span", { cls: "num", text: String(num) }), el("span", { cls: "lbl", text: label }));
  }

  function firedRule(rule) {
    var whyBtn = el("button", { cls: "link", text: "Why?", "aria-expanded": "false" });
    var panel = el("div", { cls: "explain" });
    panel.hidden = true;
    var box = el("div", { cls: "fired" },
      el("div", { cls: "fired-head" },
        el("span", { cls: "badge " + rule.kind, text: rule.kind_label }),
        el("span", { cls: "id", text: rule.label }),
        el("span", { cls: "src", text: "Source: " + rule.section }),
        whyBtn),
      el("p", { text: rule.message }),
      panel);
    whyBtn.addEventListener("click", function () {
      if (!panel.hidden) {
        panel.hidden = true;
        whyBtn.setAttribute("aria-expanded", "false");
        return;
      }
      post("api/why", { answers: answerMap(), rule: rule.id }).then(function (w) {
        panel.textContent = "";
        panel.appendChild(el("p", null, el("strong", { text: w.rule.label + " fired" }), " because all of these conditions hold:"));
        panel.appendChild(conditionList(w.conditions));
        panel.hidden = false;
        whyBtn.setAttribute("aria-expanded", "true");
      }).catch(function () {
        showError("The explanation could not be loaded from the Prolog server.");
      });
    });
    return box;
  }

  function conditionMet(c) {
    if (c.type === "fact") return c.answer === c.required;
    if (c.type === "rule") return c.status === "fired";
    if (c.type === "none_fired") return c.fired.length === 0;
    if (c.type === "any") return c.items.some(conditionMet);
    return false;
  }

  function conditionList(conditions) {
    var ul = el("ul");
    conditions.forEach(function (c) {
      var li = el("li", { cls: conditionMet(c) ? "met" : "unmet" });
      if (c.type === "fact") {
        li.appendChild(document.createTextNode(c.text + " "));
        li.appendChild(el("span", { cls: "ans", text: "(required: " + c.required + "; answer: " + c.answer + ")" }));
      } else if (c.type === "rule") {
        li.appendChild(document.createTextNode("Rule " + c.label + " fires: " + c.message + " "));
        li.appendChild(el("span", { cls: "ans", text: "(" + c.status.replace("_", " ") + ")" }));
      } else if (c.type === "none_fired") {
        li.appendChild(document.createTextNode("None of these rules fire: " + c.labels.join(", ") + " "));
        li.appendChild(el("span", { cls: "ans", text: c.fired.length ? "(fired: " + c.fired.join(", ") + ")" : "(none fired)" }));
      } else if (c.type === "any") {
        li.appendChild(document.createTextNode("At least one of:"));
        li.appendChild(conditionList(c.items));
      }
      ul.appendChild(li);
    });
    return ul;
  }

  document.addEventListener("keydown", function (e) {
    if (e.ctrlKey || e.metaKey || e.altKey) return;
    var key = e.key.toLowerCase();
    if (!$("question").hidden) {
      if (key === "y") answer("yes");
      else if (key === "n") answer("no");
      else if (key === "w") toggleWhy();
      else if (key === "b" || key === "backspace") back();
    } else if (!$("intro").hidden && key === "enter") {
      $("begin").click();
    }
  });

  $("begin").addEventListener("click", step);
  $("yes").addEventListener("click", function () { answer("yes"); });
  $("no").addEventListener("click", function () { answer("no"); });
  $("back").addEventListener("click", back);
  $("restart").addEventListener("click", restart);
  $("why-toggle").addEventListener("click", toggleWhy);

  answers = load();
  if (answers.length) {
    step();
  } else {
    renderSteps("m1");
    show("intro");
  }
})();
