%@author -> Evaldas Karpys 10.12.2017
-module(pureLiteral).
-export([pureLit/1, pureLiteralsListBuilder/2, uniqueLiteralsListBuilder_Formula/2, uniqueLiteralsListBuilder_Clause/2, testas/0]).

%-> pureLit(Formula)
    %   takes in formula
    %   gets all unique literals and negations in the formula
    %   gets all pure literals in the formula
    %   removes clauses containing pure literals
testas()->
    Formula = cnf_parser:parse("unif-k3-r4.267-v3200-c13654-S2409522417937001450.cnf"),
    pureLit(Formula).

pureLit(Formula) ->
    Unique_Lits_In_Formula = uniqueLiteralsListBuilder_Formula(Formula, []),
    Lits_To_Remove = pureLiteralsListBuilder(Unique_Lits_In_Formula, []), %list of all pure literals in the formula
    io:fwrite("PURE LIT LITERALS TO REMOVE ~p ~n", [Lits_To_Remove]),
    case length(Lits_To_Remove) == 0 of %if no literals to remove return Formula as it is
	true ->
	   io:fwrite("NO PURE LITERALS RETURN FORMULA ~p ~n", [Formula]), Formula;
	false->
	    After_Purelit_Formula = formulaManipulation:clauseRemover([], Lits_To_Remove, Formula),io:fwrite("PURE LIT FORMULA AFTER REMOVING PURELITS ~p ~n ", [After_Purelit_Formula]), pureLit(After_Purelit_Formula) end.


%-> pureLiteralsListBuilder(Unique_Literals_List, Pure_Literals_List)
      % takes final Unique_Literals_List and []
      % IF LITERAL makes negated variable of it, vice versa (Opposite)
      % CHECK IF Opposite is in the Unique_Literals_List
      % IF TRUE then its not a pure literal, delete opposite and move to next
      % *because Unique_Literals_List contains all negations and literals in formula
      % ELSE add a to Pure_Literals_List and move to next
      % *current literal will not appear in the list anymore after moving to next
      % *because they're not repeating in Unique_Literals_List
      % *there can be only be 1 of literal and 1 of negated literal in the list

pureLiteralsListBuilder ([], Pure_Literals_List) ->
    Pure_Literals_List;
pureLiteralsListBuilder ([A], Pure_Literals_List) ->
    pureLiteralsListBuilder([], [A|Pure_Literals_List]);
pureLiteralsListBuilder ([A|As], Pure_Literals_List) ->
    if 
	element(1,A) == lit ->
	    Opposite = {neg,element(2,A)},
	    case lists:member(Opposite, As) of
		true ->
		    No_Opposite = lists:delete(Opposite, As),
		    pureLiteralsListBuilder(No_Opposite, Pure_Literals_List);
		false ->
		    pureLiteralsListBuilder(As, [A|Pure_Literals_List]) end;
	element(1,A) == neg ->
	    Opposite = {lit,element(2,A)},
	    case lists:member(Opposite, As) of
		true ->
		    No_Opposite = lists:delete(Opposite, As),
		    pureLiteralsListBuilder(No_Opposite, Pure_Literals_List);
		false ->
		    pureLiteralsListBuilder(As, [A|Pure_Literals_List]) end end.
    

%Recursively feeds clauses to uniqueLiteralsListBuilder_Clause 
%Keeps Unique_Literals_List updated, by starting with previous list
%so no repeating Unique literals appear
uniqueLiteralsListBuilder_Formula([], Unique_Literals_List) ->
    Unique_Literals_List;
uniqueLiteralsListBuilder_Formula([A], Unique_Literals_List) ->
    uniqueLiteralsListBuilder_Formula([],uniqueLiteralsListBuilder_Clause(A, Unique_Literals_List));
uniqueLiteralsListBuilder_Formula([A|As], Unique_Literals_List) ->
    uniqueLiteralsListBuilder_Formula(As,uniqueLiteralsListBuilder_Clause(A, Unique_Literals_List)).


%puts all literals that are not in Unique_Literals_List into Unique_Literals_List
%-> uniqueLiteralsListBuilder_Clause(Clause, Unique_Literals_List)
      % takes in a clause and empty Unique_Literals_List
      % IF Unique_Literals_List empty then add literal to list, no check
      % ELSE check if current literal appears in Unique_Literals_List
      % IF TRUE skip adding and go to next literal
      % IF FALSE add literal to Unique_Literals_List and go to next literal

%terminates here when clause is empty
uniqueLiteralsListBuilder_Clause([], Unique_Literals_List) ->
    Unique_Literals_List;

%on last item do same check as at the start indicate termination with [] formula call
uniqueLiteralsListBuilder_Clause([A], Unique_Literals_List) ->
    case lists:member(A, Unique_Literals_List) of
	true ->
	    uniqueLiteralsListBuilder_Clause([], Unique_Literals_List);
	false ->
	    uniqueLiteralsListBuilder_Clause([], [A|Unique_Literals_List]) end;

%Usual start pattern
uniqueLiteralsListBuilder_Clause([A|As], Unique_Literals_List) ->
    if 
	length(Unique_Literals_List) == 0 -> %if empty no need to check literal will be unique
	    uniqueLiteralsListBuilder_Clause(As, [A|Unique_Literals_List]);
	true ->
	    case lists:member(A, Unique_Literals_List) of
		true ->
		    uniqueLiteralsListBuilder_Clause(As, Unique_Literals_List);
		false ->
		    uniqueLiteralsListBuilder_Clause(As, [A|Unique_Literals_List]) end end.


