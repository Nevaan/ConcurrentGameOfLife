-module(cell).
-compile(export_all).


start(State) ->
	spawn_link(fun() -> init(State) end).

init(State) ->
	receive
		{init,Neighbours} ->
			receive
				{go,Ctrl} ->
					cell(Ctrl,State,Neighbours)
			end
	end.

cell(Ctrl,State,Neighbours) ->
	multicast(State,Neighbours),
	All = collect(Neighbours),
	Next = rule(All,State),
	Ctrl ! {self(), Next},
	timer:sleep(10000), %10 sekund
	cell(Ctrl,Next,Neighbours).


multicast(State,Neighbors) ->
	Self = self(),
	lists:foreach(fun(Pid)->Pid ! {state,Self,State} end, Neighbors).

collect(Neighbors) ->
	lists:map(fun(Pid) -> 
		receive
			{state,Pid,State} ->
				State
		end
	end,
	Neighbors).

rule(Neighbours,State) ->
	Alive = alive(Neighbours),
	if
		Alive < 2 ->
			dead;
		Alive == 2 ->
			State;
		Alive == 3 ->
			alive;
		Alive > 3 ->
			dead
	end.

alive(Neighbours) ->
	lists:foldl(fun(X,Count) -> if X == alive -> Count + 1; X == dead -> Count end end ,0,Neighbours).


% next module?

dostosujRzedy(List) ->
	N = length(List),
	NowaLista = dostosujKolumny(N,List),
	[H|_] = NowaLista,
	{[lists:last(NowaLista)] ++ NowaLista ++ [H], lists:flatten(List)}.

dostosujKolumny(0,_) ->
	 [];
	
dostosujKolumny(N, List) ->
	[H|T] = List,
	[H2|_] = H,
	First = [lists:last(H)] ++ H ++ [H2],
	Rest = dostosujKolumny(N-1,T),
	[First] ++ Rest.


testGrid() ->
	[[start(dead), start(dead), start(dead), start(alive),  start(dead) ] ,
	 [start(dead), start(dead), start(dead), start(alive),  start(dead) ],
	 [start(alive), start(alive), start(dead), start(dead), start(alive)],
	 [start(dead), start(alive), start(alive), start(dead), start(dead) ] ,
	 [start(alive), start(dead),start(alive),start(dead),   start(alive)]
	 ].


%% 5.4

all() ->
	{Grid,All} = dostosujRzedy(testGrid()),
	connect(Grid),
	All.

connect([R,Rm,R1]) ->
	connect(R,Rm,R1);
connect([R1,R2,R3|Rest]) ->
	connect(R1,R2,R3),
	connect([R2,R3|Rest]).

connect([NE,N,NW],[E,This,W],[SE,S,SW]) ->
	This ! {init,[NE,N,NW,E,W,SE,S,SW]};
connect([NE,N,NW|Nr],[E,This,W|Tr],[SE,S,SW|Sr]) ->
	This ! {init,[NE,N,NW,E,W,SE,S,SW]},
	connect([N,NW|Nr],[This,W|Tr],[S,SW|Sr]).

%%bench

loop() ->
	All = all(),
	init(self(),All),
	outputLoop(All).

init(Pid,All) ->
	lists:foreach(fun(Proc)-> Proc ! {go,Pid} end, All).

listen(X) ->
	receive
		{X,State} -> atom_to_list(State)
	end.


formatOutput(List) ->
	L2 = lists:map(fun([_,B]) -> B end, List),
	L3 = splitIn5(L2),
	Ready = lists:flatten(lists:map(fun(X) -> lists:concat([lists:map(fun(Y) -> lists:concat([Y,", "]) end,X), "~n"]) end, L3)),
	io:format(Ready),
	io:format("-------------------- gen end ---------------------- ~n").
	
splitIn5(List) -> splitIn5(List,length(List)).

splitIn5(List,L) when L=<5 -> [List];
				
splitIn5(List,_) ->
	{A,B} = lists:split(5,List),
	[A] ++ splitIn5(B,length(B)).

actual(All) ->
	lists:map(fun(X) -> [X, listen(X)] end, All).

outputLoop(All) ->
	formatOutput(actual(All)), outputLoop(All).
