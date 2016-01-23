%% @author Pawel Losek

-module(inputFormat).
-export([createRows/1]).


%% funkcje konwertujace liste przedstawiajaca automat komorkowy w "standartowej" formie do postaci listy wykorzystywanej przez program 
createRows(List) ->
	N = length(List),
	CellList = createColums(N,List),
	[H|_] = CellList,
	{[lists:last(CellList)] ++ CellList ++ [H], lists:flatten(List)}.

createColums(0,_) ->
	 [];
	
createColums(N, List) ->
	[H|T] = List,
	[H2|_] = H,
	First = [lists:last(H)] ++ H ++ [H2],
	Rest = createColums(N-1,T),
	[First] ++ Rest.

