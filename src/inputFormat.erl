%% @author Pawel Losek

-module(inputFormat).
-export([createRows/0]).
-import(cell, [start/1]).


%% funkcje konwertujace liste przedstawiajaca automat komorkowy w "standartowej" formie do postaci listy wykorzystywanej przez program 
createRows() ->
	List = readGrid("startGrid.txt"),
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

%% Funkcje wczytujace schemat automatu z pliku
readGrid(Filename) ->
	{ok, IoDevice} = file:open(Filename, [read]),
    InputGrid = read_text(IoDevice),
    file:close(IoDevice),
	Input = re:split(InputGrid, "\n",[{return,list}]),
	function(Input).

read_text(IoDevice) ->
    case file:read_line(IoDevice) of
        {ok, Line} ->
                      Line ++ read_text(IoDevice);
        eof        -> []
    end.

%% Funkcja tworzaca procesy komorek na podstawie wczytanego pliku
function(List) ->
	lists:map(fun(X) -> lists:map(fun(Y) -> start(Y) end,string:tokens(X, " ")) end,List).