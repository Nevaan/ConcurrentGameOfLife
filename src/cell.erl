-module(cell).
-compile(export_all).
-include_lib("wx/include/wx.hrl").


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

%% 5.4

all(M) ->
	{Grid,All} = state(M),
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

bench(N,M) ->
	All = all(M),
	Start = erlang:system_time(micro_seconds),
	init(N,self(),All),
	benchCollect(All),
	Stop = erlang:system_time(micro_seconds),
	Time = Stop - Start,
	io:format("~w generations of size ~w computed in ~w us~n",[N,M,Time]).

init(N,Pid,All) ->
	lists:foreach(fun(Proc)-> Proc ! {go,N,Pid} end, All).

benchCollect(All) ->
	lists:map(fun(Pid) -> 
		receive
			{done,Pid} ->
				Pid
		end
	end,
	All).

%% GUI

%gui() ->
	 %
	 %My_wx_dir = code:lib_dir(wx),
	 %rr(My_wx_dir ++ "/include/wx.hrl"),
	 %rr(My_wx_dir ++ "/src/wxe.hrl").
	
	
