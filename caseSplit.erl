%@author -> Evaldas Karpys
-module(caseSplit).
-compile(export_all).


testas(Formula) ->
    caseSplit:main(Formula,pureLiteral:uniqueLiteralsListBuilder_Formula(Formula,[]), {null,null}).

main(Original_Formula_Prev, [], Prev_Split_Lit) ->
    casesplit_sat;
main(Original_Formula_Prev, [L|Lits_To_Split], Prev_Split_Lit) ->
    case element(2,L) == element(2,Prev_Split_Lit) of
	true-> %opposite check
	    New_Formula = Original_Formula_Prev++[[L]],
	    Formula_After_UnitProp = unitPropogation:unitProp(New_Formula, New_Formula),
	    case length(Formula_After_UnitProp) == 0 of
		true ->
		   unsat; 
		false ->
		    Formula_After_Purelit = pureLiteral:pureLit(Formula_After_UnitProp),
		    case length(Formula_After_Purelit) == 0 of
			true ->
			    unsat;
			false ->
			    sat end end; 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	false ->
	    New_Formula = Original_Formula_Prev++[[L]],
	    Formula_After_UnitProp = unitPropogation:unitProp(New_Formula, New_Formula),
	    io:fwrite("AFTER UNIT PROP FORMULA ~p ~n)", [Formula_After_UnitProp]),
	    case length(Formula_After_UnitProp) == 0 of
		true ->
		   case element(1,L) == lit of %call with oposite in lits and self in prev lit
		       true ->
			  main(Original_Formula_Prev, [{neg,element(2,L)}|Lits_To_Split], L); 
		       false -> 
			   main(Original_Formula_Prev, [{lit,element(2,L)}|Lits_To_Split], L) end; 
		false ->
		    Formula_After_Purelit = pureLiteral:pureLit(Formula_After_UnitProp),
		    case length(Formula_After_Purelit) == 0 of
			true ->
			    case element(1,L) == lit of %call with oposite in lits and self in prev lit
				true ->
				    main(Original_Formula_Prev, [{neg,element(2,L)}|Lits_To_Split], L); 
				false -> 
				    main(Original_Formula_Prev, [{lit,element(2,L)}|Lits_To_Split], L) end; 
			false ->
			    io:fwrite("***************CASE SPLIT DONE ON ~p ~n", [Original_Formula_Prev]),
			    main(Formula_After_Purelit, Lits_To_Split, {null,null}) end end end. %else prev dont matter move to next split




    
