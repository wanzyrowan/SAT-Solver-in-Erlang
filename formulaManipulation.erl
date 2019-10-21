%@author -> Evaldas Karpys 10.12.2017
-module(formulaManipulation).
-export([clauseRemover/3, literalRemover/3]).

%%-> clauseRemover([NewFormula], [UnitToRemove], [Formula])
     % takes a list of literals and removes all clauses from Formula containing those lits 
     % REMOVE PROCESS:
     % take clause and check if it contains lit to remove
     % IF TRUE then just move to next clause, not adding checked clause to NewFormula
     % IF FALSE add current clause to NewFormula
     % WHEN checking last clause move to next item in UnitToRemove with NewFormula
     %UnitToRemove = [LIST OF LITERALS] 
     %[A|As] = Initial formula that we start removing clauses from = [[clause1],..,[clauseN]]

%If new formula and formula empty then terminate with empty list
%because cannot remove anything from empty formula == FORMULA_SAT
clauseRemover([],_,[]) ->
    [];
clauseRemover (New_Formula, [], []) ->
   io:fwrite("Clause Remover Returned ~p ~n", [New_Formula]), New_Formula;

%when UnitToRemove list has 1 item and we are on the last clause of our formula
%just deal with current clause and indicate termination with empty lists
clauseRemover (New_Formula, [UnitToRemove], [A]) ->
    case lists:member(UnitToRemove, A) of
	true ->
	    io:fwrite("Clause Remover ~p Removed ~n", [A]),
	    clauseRemover(New_Formula, [], []);
	false ->
	    clauseRemover([A|New_Formula], [], []) end;

%pretty much as above, just if we have more clauses to look at move recursively
clauseRemover (New_Formula, [UnitToRemove], [A|As]) ->
    case lists:member(UnitToRemove, A) of
	true ->
	    io:fwrite("Clause Remover ~p Removed ~n", [A]),
	    clauseRemover(New_Formula,[UnitToRemove], As);
	false ->
	    clauseRemover([A|New_Formula], [UnitToRemove], As) end;

%if there are more items in removeUnit list and we reach last clause of current formula
%recall with empty list for new formula, so we start building new formula
%and use the new formula we've built as our base formula for next item to remove
clauseRemover(New_Formula, [UnitToRemove|Us], [A]) ->
    case lists:member(UnitToRemove, A) of
	true ->
	    io:fwrite("Clause Remover ~p Removed ~n", [A]),
	    clauseRemover([], Us, New_Formula);
	false ->
	    clauseRemover([], Us, [A|New_Formula]) end;

%usually it will start here, until we have < 1 clauses to look at this will be executed
%dont call on Us, because then we move to next item to remove without looking at all clauses
clauseRemover (New_Formula, [UnitToRemove|Us], [A|As]) -> 
    case lists:member(UnitToRemove, A) of
	true ->
	    io:fwrite("Clause Remover ~p Removed ~n", [A]),
	    clauseRemover(New_Formula, [UnitToRemove|Us], As);
	false ->
	    clauseRemover([A|New_Formula], [UnitToRemove|Us], As) end.



%-> literalRemover(Formula, Literal_To_Remove, New_Formula)
      % takes a formula and removes Literal_To_Remove from all clauses
      % REMOVE PROCESS:
      % take clause and check if Literal_To_Remove is a member of it
      % IF TRUE delete literal from clause, check if clause is not empty after removal
      % IF EMPTY don't add clause to new formula, else add clause and move to next clause
      % IF FALSE add clause to new formula and move to next clause
      % i.e. -> [{lit,m}, {lit,g}, {neg,r}], {neg,r}, [] -> [{lit,m}, {lit,g}]

%If formula and newFormula empty return empty list = FORMULA_SAT
literalRemover([], _, []) ->
    [];

%terminate here return new_Formula
literalRemover ([], [], New_Formula) ->
   io:fwrite("Literal Remover Returned ~p ~n", [New_Formula]), New_Formula;

%Iterating last item in the formula next item is empty list so just indicate termination
%by calling self with [] for formula and Lit_To_Remove adding changed or unchanged clause to new_Formula
literalRemover ([A], Literal_To_Remove, New_Formula) ->
    case lists:member(Literal_To_Remove, A) of
	true ->
	    Changed_Cl = lists:delete(Literal_To_Remove, A),
	    case length(Changed_Cl) == 0 of
		true ->
		    literalRemover([], [], New_Formula);
		false ->
		    literalRemover([], [], [Changed_Cl|New_Formula]) end;
	false ->
	    literalRemover([], [], [A|New_Formula]) end;

%Usual start pattern
literalRemover ([A|As], Literal_To_Remove, New_Formula) ->
    case lists:member(Literal_To_Remove, A) of
	true ->
	    Changed_Cl = lists:delete(Literal_To_Remove, A),
	    case length(Changed_Cl) == 0 of
		true ->
		    literalRemover(As, Literal_To_Remove, New_Formula);
		false->
		    literalRemover(As, Literal_To_Remove, [Changed_Cl|New_Formula]) end;
	false ->
	    literalRemover(As, Literal_To_Remove, [A|New_Formula]) end.
