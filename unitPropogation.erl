-module(unitPropogation).
-export([unitProp/2, testas/0]).

%-> Takes in Fromula twice:
      % recursively looks for unit clause in the first formula
       
      % IF UNIT CLAUSE FOUND:
      % remove all clauses containing unit + unit clause itself from the formula
      % remove opposite of unit clause from all clauses in the formula
testas()->
    Formula = cnf_parser:parse("unif-k3-r4.267-v3200-c13654-S2409522417937001450.cnf"),
    unitProp(Formula, Formula).

unitProp([], Formula) -> 
    io:fwrite("Unit Prop: No unit clauses found ~n"),Formula;

unitProp ([A|As], Formula) ->
    case length(A) == 1 of 
    %if Unit Clause found remove all clauses containing Unit in the Formula
	true ->
	    io:fwrite("~n RUNS INTO UNIT PROP CLAUSE LENGTH == 1 ~n"),
	    After_Removing_Clauses = formulaManipulation:clauseRemover([], A, Formula),
	    case length(After_Removing_Clauses) == 0 of %if after removing clauses we get empty list formula is SAT
		true->
		    io:fwrite("UNIT PROP LENGHT 0 ~n"),
		    unitProp([], After_Removing_Clauses); %skips the remove clause call because formula is [] and it would fail
		false ->
		    io:fwrite("RUNS INTO UNIT PROP AFTER REMOVING CLAUSES LENGTH NOT 0 ~n"),
		    [Tuple|_] = A, %A is unit clause here we get literal alone
		    case element(1,Tuple) == lit of
			true ->
			    Neg_Unit =  {neg,element(2,Tuple)}, %remove negated literal from clauses
			    After_Removing_Neg_Lit = formulaManipulation:literalRemover(After_Removing_Clauses, Neg_Unit, []),
			    unitProp(After_Removing_Neg_Lit, After_Removing_Neg_Lit); %repeat procedure with new formula
			false -> 
			    Lit_Unit =  {lit,element(2,Tuple)}, %remove negated literal from clauses
			    After_Removing_Lit = formulaManipulation:literalRemover(After_Removing_Clauses, Lit_Unit, []),
			    unitProp(After_Removing_Lit, After_Removing_Lit)end end; %repeat procedure with new formula

	false ->
	    io:fwrite("UnitProp Not A Unit Clause ~n "), unitProp(As, Formula)end.
