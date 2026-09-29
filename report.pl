line_width(76).

print_report :-
    nl, rule_line('='),
    writeln('  PERSONAL DATA PROTECTION READINESS REPORT'),
    writeln('  Personal Data Protection Act, No. 9 of 2022 (Sri Lanka),'),
    writeln('  as amended by Act, No. 22 of 2025'),
    rule_line('='),
    forall(module(M, Title), print_module(M, Title)),
    print_summary,
    print_disclaimer.

print_module(M, Title) :-
    (   module_status(M, Status)
    ->  nl, upcase_atom(M, ML), format('~w  ~w~n', [ML, Title]),
        rule_line('-'),
        print_module_body(M, Status)
    ;   true
    ).

print_module_body(_, skipped(Reason)) :- !,
    wrap_print(['Not evaluated: ', Reason, '.'], 2).
print_module_body(M, evaluated) :-
    findall(R, ( rule(R, M, _, _, _, _), fired(R) ), Rules),
    forall(member(R, Rules), print_fired_rule(R)),
    module_conclusion(M, Rules).

print_fired_rule(R) :-
    rule(R, _, _, Kind, Message, Section),
    rule_label(R, Label),
    kind_label(Kind, KindLabel),
    format(atom(Head), '[~w] ~w: ', [Label, KindLabel]),
    wrap_print([Head, Message], 2),
    format(atom(Src), 'Source: ~w', [Section]),
    wrap_print([Src], 4).

kind_label(applies,     'APPLIES').
kind_label(not_applies, 'NOT APPLICABLE').
kind_label(basis,       'OK').
kind_label(finding,     'NOTE').
kind_label(condition,   'OK').
kind_label(issue,       'ISSUE').
kind_label(required,    'REQUIRED').
kind_label(may_require, 'MAY APPLY').

module_conclusion(M, Rules) :-
    (   module_note(M, Rules, Text)
    ->  (   M == m1
        ->  wrap_print(['=> ', Text], 2)
        ;   wrap_print([Text], 2)
        )
    ;   true
    ).

module_note(m1, _, Text) :-
    outcome(Outcome),
    outcome_text(Outcome, Text).
module_note(m3, [], 'No special categories of personal data identified.').
module_note(m4, [], 'All Schedule III conditions for valid consent are met.').
module_note(m5, [], 'No Data Protection Officer requirement identified.').
module_note(m6, [], 'No impact assessment requirement identified.').

outcome_text(applies,
    'The Act applies to this processing. The remaining modules were evaluated.').
outcome_text(excluded,
    'The Act does not apply to this processing. The consultation stops here.').
outcome_text(not_applicable,
    'None of R1-R5 fired: the Act does not apply to this processing (s.2(1)). The consultation stops here.').

print_summary :-
    nl, rule_line('='),
    writeln('  SUMMARY'),
    rule_line('='),
    (   outcome(applies)
    ->  count_kind(issue, Issues),
        count_kind(required, Required),
        count_kind(may_require, May),
        format('  Compliance issues found      : ~w~n', [Issues]),
        format('  Obligations that apply       : ~w~n', [Required]),
        format('  Obligations that may apply   : ~w~n', [May]),
        (   Issues =:= 0
        ->  wrap_print(['No compliance issues were identified for the answers given.'], 2)
        ;   wrap_print(['The issues marked ISSUE above must be addressed before the Act comes into operation.'], 2)
        )
    ;   wrap_print(['The Act does not apply; no obligations were evaluated.'], 2)
    ).

count_kind(Kind, N) :-
    aggregate_all(count, ( rule(R, _, _, Kind, _, _), fired(R) ), N).

print_disclaimer :-
    nl,
    disclaimer_text(Text),
    wrap_print([Text], 0),
    rule_line('='),
    writeln('Type why(r15). (any rule id) to see why a rule fired or did not fire.').

disclaimer_text('DISCLAIMER: This is an educational tool and not legal advice. Except for the provisions already in operation, the Act comes into operation on a date appointed by the Minister by Order published in the Gazette (s.1(3), as amended). Thresholds "as may be prescribed" have not yet been prescribed; results marked MAY APPLY depend on them.').

why(Rule) :-
    (   rule(Rule, M, Conditions, Kind, Message, Section)
    ->  rule_label(Rule, Label),
        upcase_atom(M, ML),
        rule_status(Rule, Status),
        status_text(Status, StatusText),
        nl,
        format('Rule ~w (module ~w, ~w)~n', [Label, ML, Section]),
        kind_label(Kind, KindLabel),
        wrap_print(['THEN ', KindLabel, ': ', Message], 2),
        format('  Status: ~w~n', [StatusText]),
        writeln('  IF all of:'),
        forall(member(C, Conditions), explain_condition(C, 4))
    ;   format('Unknown rule: ~w (rules are r1 .. r34)~n', [Rule])
    ).

status_text(fired,         'FIRED').
status_text(not_fired,     'DID NOT FIRE').
status_text(not_evaluated, 'NOT EVALUATED in this consultation').

explain_condition(no(Fact), Indent) :- !,
    question(Fact, Text, _),
    answer_text(Fact, Answer),
    wrap_print(['- ', Text, ' (required: no; answer: ', Answer, ')'], Indent).
explain_condition(fired(Rule), Indent) :- !,
    rule(Rule, _, _, _, Message, _),
    rule_label(Rule, Label),
    rule_status(Rule, Status),
    status_text(Status, StatusText),
    wrap_print(['- Rule ', Label, ' fires: ', Message, ' (', StatusText, ')'], Indent).
explain_condition(any(Conditions), Indent) :- !,
    wrap_print(['- at least one of:'], Indent),
    Indent2 is Indent + 2,
    forall(member(C, Conditions), explain_condition(C, Indent2)).
explain_condition(none_fired(Rules), Indent) :- !,
    maplist(rule_label, Rules, Labels),
    atomic_list_concat(Labels, ', ', LabelText),
    findall(L, ( member(R, Rules), fired(R), rule_label(R, L) ), FiredLabels),
    (   FiredLabels == []
    ->  Result = 'none fired'
    ;   atomic_list_concat(FiredLabels, ', ', F),
        atom_concat('fired: ', F, Result)
    ),
    wrap_print(['- none of these rules fire: ', LabelText, ' (', Result, ')'], Indent).
explain_condition(Fact, Indent) :-
    question(Fact, Text, _),
    answer_text(Fact, Answer),
    wrap_print(['- ', Text, ' (required: yes; answer: ', Answer, ')'], Indent).

answer_text(Fact, Answer) :-
    (   known(Fact, A) -> Answer = A ; Answer = 'not asked' ).

rule_line(Char) :-
    line_width(W),
    forall(between(1, W, _), write(Char)),
    nl.

wrap_print(Parts, Indent) :-
    atomic_list_concat(Parts, Text),
    split_string(Text, " ", "", Words),
    line_width(W),
    Max is W - Indent - 2,
    wrap_words(Words, Max, [First|Rest]),
    tab(Indent), writeln(First),
    Hang is Indent + 2,
    forall(member(Line, Rest), ( tab(Hang), writeln(Line) )).

wrap_words([], _, []).
wrap_words([Word|Words], Max, [Line|Lines]) :-
    take_line(Words, Max, Word, Line, Rest),
    wrap_words(Rest, Max, Lines).

take_line([], _, Line, Line, []).
take_line([Word|Words], Max, Acc, Line, Rest) :-
    string_length(Acc, LA),
    string_length(Word, LW),
    (   LA + 1 + LW =< Max
    ->  string_concat(Acc, " ", Acc1),
        string_concat(Acc1, Word, Acc2),
        take_line(Words, Max, Acc2, Line, Rest)
    ;   Line = Acc,
        Rest = [Word|Words]
    ).
