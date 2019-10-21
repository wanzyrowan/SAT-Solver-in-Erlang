%Author -> Evaldas Karpys
-module(dpll).
-export([dpll/1]).

% 1. DPLL:

% 1.1 -> User passes formula in format  "(B or C or G) and (not C or G or not B) and not G"
  %   -> IF formula is empty dpll("") pattern matches empty list -> FORMULA_SAT

% 1.2 -> IF formula is not empty then parse from/to format:
  %     (A or B or notA) and (A or notB) ->[[{lit,a}, {lit,b}, {neg,a}], [{lit,a}, {neg,b}]]
  %     IF parsed formula empty -> FORMULA_SAT

% 1.3 -> Unit Propogate formula
  %      IF after Unit Propogation formula is empty -> FORMULA_SAT

% 1.4 -> Pure Literal
  %      IF after Unit Propogation formula is empty -> FORMULA_SAT

% 1.5 -> Case Split

dpll ([]) -> io:fwrite("HITS FORMULA SAT IN DPLL "), formula_satisfiable;
dpll (Formula) -> 
    FormulaParsed = cnf_parser:parse(Formula),
    io:fwrite("PARSED FORMULA ~p ~n", [FormulaParsed]),
    case length(FormulaParsed) == 0 of
	true ->
	   io:fwrite("DPLL PARSED FORMULA IS EMPTY ~n"), dpll([]);
	false ->
    Formula_After_UnitProp = unitPropogation:unitProp(FormulaParsed, FormulaParsed),
    io:fwrite("AFTER UNIT PROP FORMULA ~p ~n)", [Formula_After_UnitProp]),
    case length(Formula_After_UnitProp) == 0 of
	true ->
	   io:fwrite("DPLL FORMULA AFTER UNITPROP IS EMPTY ~n"), dpll([]);
	false ->
	    Formula_After_Purelit = pureLiteral:pureLit(Formula_After_UnitProp),
	    io:fwrite("AFTER PURE LIT FORMULA ~p ~n", [Formula_After_Purelit]),
	    case length(Formula_After_Purelit) == 0 of
		true ->
		    io:fwrite("DPLL FORMULA AFTER PURELIT IS EMPTY ~n"), dpll([]);
		false ->
		    caseSplit:main(Formula_After_Purelit,pureLiteral:uniqueLiteralsListBuilder_Formula(Formula_After_Purelit,[]), {null,null}) end end end.
