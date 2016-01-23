%% @author Pawel Losek

-module(outputFormat).
-export([formatOutput/1]).

%% Modul formatujacy String wysylany do GUI, plus formatowanie do czytelnej postaci na potrzeby wyswietlania w konsoli

formatOutput(List) ->
	L2 = lists:map(fun([_,B]) -> B end, List),
	L3 = splitIn5(L2),
	lists:flatten(lists:map(fun(X) -> lists:concat([lists:map(fun(Y) -> Y  end,X), "\n"]) end, L3)).

splitIn5(List) -> splitIn5(List,length(List)).

splitIn5(List,L) when L=<5 -> [List];
				
splitIn5(List,_) ->
	{A,B} = lists:split(5,List),
	[A] ++ splitIn5(B,length(B)).
