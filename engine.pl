:- dynamic known/2, evaluated/2, module_status/2, outcome/1, ask_hook/1.

reset_session :-
    retractall(known(_, _)),
    reset_inference.

reset_inference :-
    retractall(evaluated(_, _)),
    retractall(module_status(_, _)),
    retractall(outcome(_)),
    nb_setval(current_rule, none).

ask(Fact, Answer) :-
    (   known(Fact, Value)
    ->  true
    ;   question(Fact, _, _)
    ->  ask_hook(Hook),
        call(Hook, Fact, Value),
        assertz(known(Fact, Value))
    ;   throw(error(existence_error(question, Fact), ask/2))
    ),
    Answer = Value.

current_rule(Rule) :-
    nb_getval(current_rule, Rule).

fires(Rule) :-
    (   evaluated(Rule, Result)
    ->  true
    ;   rule(Rule, _, Conditions, _, _, _),
        current_rule(Previous),
        nb_setval(current_rule, Rule),
        (   prove_all(Conditions) -> Result = true ; Result = false ),
        nb_setval(current_rule, Previous),
        assertz(evaluated(Rule, Result))
    ),
    Result == true.

prove_all([]).
prove_all([Condition|Rest]) :-
    prove(Condition), !,
    prove_all(Rest).

prove(no(Fact)) :- !,
    ask(Fact, no).
prove(fired(Rule)) :- !,
    current_rule(Current),
    (   fires(Rule)
    ->  nb_setval(current_rule, Current)
    ;   nb_setval(current_rule, Current), fail
    ).
prove(any(Conditions)) :- !,
    member(Condition, Conditions),
    prove(Condition), !.
prove(none_fired(Rules)) :- !,
    forall(member(Rule, Rules), \+ fires(Rule)).
prove(Fact) :-
    atom(Fact),
    ask(Fact, yes).

evaluate_all(Rules) :-
    forall(member(Rule, Rules), ( fires(Rule) -> true ; true )).

fired(Rule) :- evaluated(Rule, true).

consult_system :-
    reset_inference,
    m1_application(Outcome),
    assertz(outcome(Outcome)),
    (   Outcome == applies
    ->  m2_lawful_basis,
        m3_special_categories,
        m4_consent,
        m5_dpo,
        m6_dpia
    ;   true
    ).

m1_application(Outcome) :-
    assertz(module_status(m1, evaluated)),
    (   ( fires(r6) ; fires(r7) )
    ->  Outcome = excluded
    ;   member(Rule, [r1, r2, r3, r4, r5]), fires(Rule)
    ->  Outcome = applies
    ;   Outcome = not_applicable
    ).

m2_lawful_basis :-
    assertz(module_status(m2, evaluated)),
    evaluate_all([r8, r9, r10, r11, r12, r13, r14]).

m3_special_categories :-
    assertz(module_status(m3, evaluated)),
    (   fires(r15)
    ->  evaluate_all([r16, r17, r18, r19, r20, r21, r22, r23, r24])
    ;   true
    ).

m4_consent :-
    (   ( fired(r8) ; fired(r16) )
    ->  assertz(module_status(m4, evaluated)),
        evaluate_all([r25, r26, r27, r28])
    ;   assertz(module_status(m4, skipped('consent is not relied on as a lawful basis')))
    ).

m5_dpo :-
    assertz(module_status(m5, evaluated)),
    evaluate_all([r29, r30, r31, r32]).

m6_dpia :-
    assertz(module_status(m6, evaluated)),
    evaluate_all([r33, r34]).

rule_status(Rule, Status) :-
    (   evaluated(Rule, true)  -> Status = fired
    ;   evaluated(Rule, false) -> Status = not_fired
    ;   Status = not_evaluated
    ).

fired_rules(Rules) :-
    findall(R, ( rule(R, _, _, _, _, _), evaluated(R, true) ), Rules).

rule_label(Rule, Label) :-
    upcase_atom(Rule, Label).
