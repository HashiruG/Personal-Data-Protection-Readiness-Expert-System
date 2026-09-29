:- ensure_loaded(rules).
:- ensure_loaded(questions).
:- ensure_loaded(engine).
:- ensure_loaded(report).
:- ensure_loaded(tests).
:- ensure_loaded(web).

:- initialization(welcome).

welcome :-
    nl,
    writeln('Personal Data Protection Act Readiness Checker'),
    writeln('A rule-based expert system for the Personal Data Protection Act,'),
    writeln('No. 9 of 2022 (Sri Lanka), as amended by Act, No. 22 of 2025.'),
    nl,
    writeln('  server.          start the web interface at http://localhost:8080'),
    writeln('  start.           begin a consultation in this terminal'),
    writeln('  why(r15).        explain a rule after a consultation'),
    writeln('  run_all_tests.   run the test scenarios and rule unit tests'),
    writeln('  halt.            exit'),
    nl.

start :-
    reset_session,
    retractall(ask_hook(_)),
    assertz(ask_hook(cli_ask)),
    nl,
    writeln('Answer each question about the organisation''s processing of personal data.'),
    writeln('Type yes or no (y / n), "why" to see the rule being checked, or "quit" to stop.'),
    catch(( consult_system, print_report ),
          quit,
          writeln('Consultation stopped.')).

cli_ask(Fact, Answer) :-
    question(Fact, Text, _),
    current_rule(Rule),
    rule(Rule, Module, _, _, _, _),
    upcase_atom(Module, ML),
    rule_label(Rule, RL),
    aggregate_all(count, known(_, _), Asked),
    N is Asked + 1,
    nl,
    format(atom(Head), 'Q~w [~w, ~w] ', [N, ML, RL]),
    wrap_print([Head, Text], 0),
    read_answer(Fact, Answer).

read_answer(Fact, Answer) :-
    write('  (yes / no / why) > '),
    flush_output,
    read_line_to_string(user_input, Line),
    (   Line == end_of_file
    ->  throw(quit)
    ;   normalise(Line, Input),
        (   input_answer(Input, Answer0)
        ->  Answer = Answer0
        ;   Input == "why"
        ->  explain_question(Fact),
            read_answer(Fact, Answer)
        ;   member(Input, ["quit", "q", "exit"])
        ->  throw(quit)
        ;   writeln('  Please answer yes or no (or why / quit).'),
            read_answer(Fact, Answer)
        )
    ).

normalise(Line, Input) :-
    string_lower(Line, Lower),
    split_string(Lower, "", " \t.", [Input]).

input_answer("yes", yes).
input_answer("y",   yes).
input_answer("no",  no).
input_answer("n",   no).

explain_question(Fact) :-
    current_rule(Rule),
    rule(Rule, _, _, Kind, Message, Section),
    question(Fact, _, QSection),
    rule_label(Rule, Label),
    kind_label(Kind, KindLabel),
    wrap_print(['This answer is needed to decide rule ', Label, ' (', Section, '):'], 2),
    wrap_print(['IF the conditions hold THEN ', KindLabel, ': ', Message], 4),
    wrap_print(['Source of this question in the Act: ', QSection], 2).
