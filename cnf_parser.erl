-module(cnf_parser).
-compile(export_all).



parse(FileName)->
    case file:read_file(FileName) of
	{ok, Data} ->  formula_builder(binary:split(Data, [<<"\n">>], [global]), []);
	{error, Reason} -> Reason end.



formula_builder([], Formula_Parsed) -> Formula_Parsed;
formula_builder([L|List], Formula_Parsed) ->
    Clause_Parsed = clause_builder(binary_to_list(L), no, "", []),
    case length(Clause_Parsed) == 0 of
	true ->
	    formula_builder(List, Formula_Parsed);
	false ->
	    formula_builder(List, [Clause_Parsed|Formula_Parsed]) end.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


clause_builder([], _, _, Clause_Parsed) -> Clause_Parsed;
clause_builder([C|Clause], NegFlag, Variable, Clause_Parsed) when C == $c ->
    %io:fwrite("HITS c ~n "),
    Clause_Parsed;
clause_builder([C|Clause], NegFlag, Variable, Clause_Parsed) when C == $p ->
    %io:fwrite("HITS p ~n "),
    Clause_Parsed;
clause_builder([C|Clause], NegFlag, Variable, Clause_Parsed) when C == $0 andalso length(Clause) == 0 ->
    %io:fwrite("HITS sdfsf ~n "),
    Clause_Parsed;
clause_builder([C|Clause], NegFlag, Variable, Clause_Parsed)->
    case C == $- of
	true -> 
           % io:fwrite("HITS NEG FLAG TRUE ~n "),
	    clause_builder(Clause, yes, Variable, Clause_Parsed);
	false ->
	    %io:fwrite("HITS NEG FLAG FALSE ~n "),
	    case C == $ of
		true ->
		    %io:fwrite("HITS EMPTY ~n"),
		    case NegFlag == yes of
			true ->
			    clause_builder(Clause, no, "", [{neg,list_to_atom(Variable)}|Clause_Parsed]);
			false ->
			    clause_builder(Clause, no, "", [{lit,list_to_atom(Variable)}|Clause_Parsed]) end;
		false -> 
		   case NegFlag == yes of
		       true ->
			  % io:fwrite("VARIABLE ++ ~p ~n", [binary_to_list(<<C>>)]),
			   clause_builder(Clause, yes, Variable++binary_to_list(<<C>>), Clause_Parsed);
		       false ->
			   %io:fwrite("VARIABLE ++ 2 ~p ~n", [binary_to_list(<<C>>)]),
			   clause_builder(Clause, no, Variable++binary_to_list(<<C>>), Clause_Parsed) end end end.
				    
	    
