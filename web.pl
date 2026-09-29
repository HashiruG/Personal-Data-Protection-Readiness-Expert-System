:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_json)).
:- use_module(library(http/http_files)).

:- ensure_loaded(rules).
:- ensure_loaded(questions).
:- ensure_loaded(engine).
:- ensure_loaded(report).

:- dynamic web_dir/1.

:- prolog_load_context(directory, Dir),
   atom_concat(Dir, '/web', WebDir),
   retractall(web_dir(_)),
   assertz(web_dir(WebDir)).

:- http_handler(root(api/step), api_step, [method(post)]).
:- http_handler(root(api/why), api_why, [method(post)]).
:- http_handler(root(.), serve_static, [prefix]).

server :-
    server(8080).

server(Port) :-
    http_server(http_dispatch, [port(localhost:Port)]),
    format('~nWeb interface running at http://localhost:~w~n', [Port]),
    format('Open this address in a web browser. Type stop_server. to stop it.~n~n').

stop_server :-
    stop_server(8080).

stop_server(Port) :-
    http_stop_server(localhost:Port, []).

serve_static(Request) :-
    web_dir(Dir),
    http_reply_from_files(Dir, [indexes(['index.html'])], Request).
serve_static(Request) :-
    http_404([], Request).

api_step(Request) :-
    http_read_json_dict(Request, In),
    load_answers(In),
    catch(( consult_system, Result = done ),
          need(Fact, Rule),
          Result = need(Fact, Rule)),
    step_reply(Result, Reply),
    reply_json_dict(Reply).

api_why(Request) :-
    http_read_json_dict(Request, In),
    load_answers(In),
    catch(consult_system, need(_, _), true),
    atom_string(Rule, In.rule),
    (   rule(Rule, _, _, _, _, _)
    ->  why_json(Rule, Reply),
        reply_json_dict(Reply)
    ;   reply_json_dict(_{error: "Unknown rule"}, [status(404)])
    ).

load_answers(In) :-
    reset_session,
    retractall(ask_hook(_)),
    assertz(ask_hook(web_need)),
    (   get_dict(answers, In, Answers), is_dict(Answers)
    ->  forall(( get_dict(Fact, Answers, Value),
                 question(Fact, _, _),
                 atom_string(Answer, Value),
                 memberchk(Answer, [yes, no]) ),
               assertz(known(Fact, Answer)))
    ;   true
    ).

web_need(Fact, _) :-
    current_rule(Rule),
    throw(need(Fact, Rule)).

step_reply(need(Fact, Rule), _{type: "question", question: Q}) :-
    question_json(Fact, Rule, Q).
step_reply(done, _{type: "report", report: R}) :-
    report_json(R).

question_json(Fact, Rule, _{fact: Fact, text: Text, source: QSection,
                            example: Example, legal: Legal,
                            number: N, module: Module, module_title: MTitle,
                            rule: RuleJ}) :-
    question(Fact, Text, QSection),
    question_help(Fact, Example, Legal),
    rule(Rule, Module, _, _, _, _),
    module(Module, MTitle),
    aggregate_all(count, known(_, _), Asked),
    N is Asked + 1,
    rule_json(Rule, RuleJ).

rule_json(Rule, _{id: Rule, label: Label, module: M, kind: Kind,
                  kind_label: KindLabel, message: Message, section: Section}) :-
    rule(Rule, M, _, Kind, Message, Section),
    rule_label(Rule, Label),
    kind_label(Kind, KindLabel).

report_json(_{outcome: Outcome, outcome_text: OutcomeText, modules: Modules,
              summary: Summary, disclaimer: Disclaimer, fired: FiredLabels}) :-
    outcome(Outcome),
    outcome_text(Outcome, OutcomeText),
    findall(MJ, ( module(M, Title), module_json(M, Title, MJ) ), Modules),
    count_kind(issue, Issues),
    count_kind(required, Required),
    count_kind(may_require, May),
    Summary = _{issues: Issues, required: Required, may_require: May},
    disclaimer_text(Disclaimer),
    fired_rules(Fired),
    maplist(rule_label, Fired, FiredLabels).

module_json(M, Title, _{id: M, title: Title, status: Status, reason: Reason,
                        rules: Rules, note: Note}) :-
    module_status(M, S),
    findall(R, ( rule(R, M, _, _, _, _), fired(R) ), Fired),
    maplist(rule_json, Fired, Rules),
    (   S = skipped(Why)
    ->  Status = "skipped", Reason = Why, Note = ""
    ;   Status = "evaluated", Reason = "",
        (   module_note(M, Fired, N) -> Note = N ; Note = "" )
    ).

why_json(Rule, _{rule: RuleJ, status: Status, conditions: Conditions}) :-
    rule(Rule, _, Conds, _, _, _),
    rule_json(Rule, RuleJ),
    rule_status(Rule, Status),
    maplist(condition_json, Conds, Conditions).

condition_json(no(Fact), _{type: "fact", text: Text, required: "no", answer: A}) :- !,
    question(Fact, Text, _),
    answer_text(Fact, A).
condition_json(fired(Rule), _{type: "rule", label: Label, message: Message, status: Status}) :- !,
    rule(Rule, _, _, _, Message, _),
    rule_label(Rule, Label),
    rule_status(Rule, Status).
condition_json(any(Cs), _{type: "any", items: Items}) :- !,
    maplist(condition_json, Cs, Items).
condition_json(none_fired(Rules), _{type: "none_fired", labels: Labels, fired: FiredLabels}) :- !,
    maplist(rule_label, Rules, Labels),
    findall(L, ( member(R, Rules), fired(R), rule_label(R, L) ), FiredLabels).
condition_json(Fact, _{type: "fact", text: Text, required: "yes", answer: A}) :-
    question(Fact, Text, _),
    answer_text(Fact, A).
