%Author -> Evaldas Karpys
-module(parser).
-export([prepString/1, parse/4]).


%%input -> in format "(B or C or G) and (not C or G or not B) and not G"
 %replace and -> |
 %replace not -> -
 %remove brackets
 %remove and 
 %remove spaces
 %make formula lowercase
%%output -> in format "bcg|-cg-b|-g" -> clause1|clause2|clause3

prepString(String)->
    AndReplaced = re:replace(String, "and", "+", [global, {return, list}]),
    NotReplaced = re:replace(AndReplaced, "not", "-", [global, {return, list}]),
    OrReplaced = re:replace(NotReplaced, "or", "|", [global, {return, list}]),
    BracketsRemoved = string:lexemes(OrReplaced, "$($)"),
    OrRemoved = string:lexemes(BracketsRemoved, "or"),
    SpacesRemoved = string:lexemes(OrRemoved, " "),
    string:lowercase(SpacesRemoved).


%%-> Takes in modified formula, NegFlag, Clause, Parsed

    %  - Modified formula (from prepString()):
    %   all lowercase, no spaces, no ors, no brackets, and == |, not == -
       
    %  - Neg Flag:
    %   Negation Flag: when - (not) is encountered set flag to 'yes'
    %   IF flag == yes literal is negated

    %  - Clause & Parsed:
    %   Current clause and Parsed formula:
    %   when | (and) is encountered begin new clause adding current to Parsed
    %   ON last item add current clause to Parsed

parse([],_,_,Parsed) ->
    Parsed;
parse([E], NegFlag, Clause, Parsed) ->
 %add variable parse until or | and then add it to clause
    case NegFlag == yes of
	true ->
	    LastClause = [{neg,binary_to_atom(<<E>>, unicode)}|Clause],
	    parse([], no, [], [LastClause|Parsed]);
    	false -> 
	    LastClause = [{lit,binary_to_atom(<<E>>, unicode)}|Clause],
	    parse([], no, [], [LastClause|Parsed]) end;

parse([E|Es], NegFlag, Clause, Parsed) ->
    case E == $- of
	true ->
	    parse(Es, yes, Clause, Parsed);
	false -> 
	    case E == $+ of
		true-> 
		    parse(Es, no, [], [Clause|Parsed]);
		false ->
			    case NegFlag == yes of
				true ->
				    parse(Es, no,[{neg,binary_to_atom(<<E>>, unicode)}|Clause], Parsed);
				false -> 
				    parse(Es, no,[{lit,binary_to_atom(<<E>>, unicode)}|Clause], Parsed) end end end.
    
    
