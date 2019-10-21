%Author -> Evaldas Karpys
-module(tests).
-compile(export_all).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% UNIT PROPOGATION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% set unit propogation test
unitprop_Test()->
    Test_Formula = [[{lit,b}, {neg,g}, {lit,a}], [{lit,g}], [{lit,g},{lit,a}], [{lit,m}, {lit,a}, {neg,b}], [{lit,g}, {lit,a}], [{lit,k}, {lit,v}], [{lit,v}, {neg,k}], [{lit,p}, {neg,k}], [{neg,p}, {lit,k}]],
    Test_Answer = [[{lit,b},{lit,a}],
 [{lit,m},{lit,a},{neg,b}],
 [{lit,k},{lit,v}],
 [{lit,v},{neg,k}],
 [{lit,p},{neg,k}],
 [{neg,p},{lit,k}]],

    case unitPropogation:unitProp(Test_Formula, Test_Formula) == Test_Answer  of
	true ->
	    io:fwrite("SUCCESS ~p ~n", [Test_Answer]);
	false ->
	    io:fwrite("FAIL ~p ~n", [Test_Answer])end.
