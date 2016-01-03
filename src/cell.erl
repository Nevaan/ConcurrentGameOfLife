-module(cell).
-compile(export_all).

start(State) ->
	spawn_link(fun() -> init(State) end).

init(State) ->
	receive
		{init,Neighbours} ->
			receive
				{go,N,Ctrl} ->
					cell(N,Ctrl,State,Neighbours)
			end
	end.

cell(0,Ctrl,_State,_Neighbours) ->
	Ctrl ! {done,self()};
cell(N,Ctrl,State,Neighbors) ->
	multicast(State,Neighbors),
	All = collect(Neighbors),
	Next=rule(All,State),
	cell(N-1,Ctrl,Next,Neighbors).


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


%% next module?

row(M) ->
	First = start(flip()),
	{Rows,Last, Pid} = row(M,2,First),
	{[Last,First|Rows], [First] ++ Pid}.

row(M,M,First) ->
	Last = start(flip()),
	{[Last,First],Last,[Last]};
row(M,R,First) ->
	Cell = start(flip()),
	{Cells,Last,Pid} = row(M,R+1, First),
	{[Cell|Cells], Last,[Cell]++Pid}.

state(M) ->
	{First,A} = row(M),
	{Rows,Last, Msg} = state(M,2,First),
	{[Last,First|Rows],A ++ Msg}.

state(M,M,First) ->
	{Last,A} = row(M),
	{[Last,First],Last,A};
state(M,R,First) ->
	{Row,A} = row(M),
	{Rows,Last,Msg} = state(M,R+1,First),
	{[Row|Rows],Last,A++Msg}.
flip() ->
	Flip = random:uniform(4),
	if
		Flip == 1 ->
			alive;
		true ->
			dead
	end.
