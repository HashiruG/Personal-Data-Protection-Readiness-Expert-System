:- ensure_loaded(rules).
:- ensure_loaded(questions).
:- ensure_loaded(engine).
:- ensure_loaded(report).

:- dynamic scenario_yes/1.

scenario(1, 'Individual keeping family contacts',
    [household_purpose],
    [r6]).

scenario(2, 'FitZone gym, Colombo (members aged 14-15)',
    [personal_data, processing_in_sl, consent_given,
     biometric_data, health_data, child_data, special_consent,
     can_demonstrate_consent, consent_in_written_declaration,
     consent_bundled, core_special_category],
    [r1, r8, r15, r24, r26, r27, r28, r31]).

scenario(3, 'Online shop (contract, no special data, no profiling)',
    [personal_data, processing_in_sl, contract_necessary],
    [r1, r9]).

scenario(4, 'Government department',
    [personal_data, processing_in_sl, legal_obligation,
     public_interest_task, ministry_or_department],
    [r1, r10, r12, r29]).

scenario(5, 'Overseas lender profiling for credit decisions',
    [personal_data, monitors_sl, legitimate_interests, extensive_evaluation],
    [r5, r13, r33]).

scenario(6, 'Public corporation (no DPO under s.20(1)(a) as amended)',
    [personal_data, processing_in_sl, established_in_sl, legal_obligation],
    [r1, r10]).

scenario(7, 'Anonymous statistics only (no personal data)',
    [],
    [r7]).

scenario(8, 'Marketing list with no lawful basis',
    [personal_data, processing_in_sl],
    [r1, r14]).

scenario(9, 'Private hospital with CCTV covering a public road',
    [personal_data, processing_in_sl, contract_necessary, health_data,
     health_professional, core_special_category, public_monitoring],
    [r1, r9, r15, r22, r31, r34]).

test_answer(Fact, Answer) :-
    (   scenario_yes(Fact) -> Answer = yes ; Answer = no ).

run_scenario(Yes, Fired, Asked) :-
    reset_session,
    retractall(scenario_yes(_)),
    forall(member(F, Yes), assertz(scenario_yes(F))),
    retractall(ask_hook(_)),
    assertz(ask_hook(test_answer)),
    consult_system,
    fired_rules(Fired),
    aggregate_all(count, known(_, _), Asked).

run_all_tests :-
    nl,
    format('~w~t~4|~w~t~62|~w~n', ['#', 'Scenario', 'Result']),
    rule_line('-'),
    findall(Ok, run_one(Ok), Results),
    rule_line('-'),
    include(==(pass), Results, Passed),
    length(Results, Total),
    length(Passed, NPassed),
    format('~w of ~w scenarios passed.~n', [NPassed, Total]),
    rule_coverage,
    rule_unit_tests(UnitOk),
    retractall(ask_hook(_)),
    NPassed =:= Total,
    UnitOk == true.

run_one(Ok) :-
    scenario(N, Name, Yes, Expected),
    run_scenario(Yes, Fired, Asked),
    (   Fired == Expected -> Ok = pass, Result = 'PASS' ; Ok = fail, Result = 'FAIL' ),
    format('~w~t~4|~w~t~62|~w~n', [N, Name, Result]),
    labels(Expected, E),
    labels(Fired, A),
    ( Asked =:= 1 -> Q = question ; Q = questions ),
    format('    expected: ~w~n    actual:   ~w   (~w ~w asked)~n', [E, A, Asked, Q]).

labels(Rules, Text) :-
    maplist(rule_label, Rules, Labels),
    atomic_list_concat(Labels, ', ', Text).

rule_coverage :-
    findall(R, ( scenario(_, _, _, Expected), member(R, Expected) ), Rs),
    sort(Rs, Covered),
    length(Covered, NC),
    aggregate_all(count, rule(_, _, _, _, _, _), NR),
    format('Rules fired in at least one scenario: ~w of ~w.~n', [NC, NR]).

rule_unit_tests(AllOk) :-
    findall(R-Ok, ( rule(R, _, _, _, _, _), unit_test(R, Ok) ), Results),
    findall(L, ( member(R-fail, Results), rule_label(R, L) ), Failed),
    length(Results, Total),
    length(Failed, NFailed),
    NOk is Total - NFailed,
    format('Rule unit tests: ~w of ~w rules fire when their conditions hold.~n',
           [NOk, Total]),
    (   Failed == []
    ->  AllOk = true
    ;   atomic_list_concat(Failed, ', ', F),
        format('Rules that failed: ~w~n', [F]),
        AllOk = false
    ).

unit_test(Rule, Ok) :-
    rule(Rule, _, Conditions, _, _, _),
    satisfying_facts(Conditions, Yes),
    reset_session,
    retractall(scenario_yes(_)),
    forall(member(F, Yes), assertz(scenario_yes(F))),
    retractall(ask_hook(_)),
    assertz(ask_hook(test_answer)),
    (   fires(Rule) -> Ok = pass ; Ok = fail ).

satisfying_facts(Conditions, Yes) :-
    foldl(satisfy, Conditions, [], Yes).

satisfy(no(_), Acc, Acc) :- !.
satisfy(none_fired(_), Acc, Acc) :- !.
satisfy(fired(Rule), Acc0, Acc) :- !,
    rule(Rule, _, Conditions, _, _, _),
    foldl(satisfy, Conditions, Acc0, Acc).
satisfy(any([First|_]), Acc0, Acc) :- !,
    satisfy(First, Acc0, Acc).
satisfy(Fact, Acc, [Fact|Acc]).
