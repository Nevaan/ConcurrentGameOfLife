%% @author Pawel Losek

-module(cell).
-export([init/1, start/1]).


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
	Ctrl ! {self(), State},
	receive
		{shutdown} ->
			io:format("~p: Otrzymano wiadomosc -  exit ~n", [self()]),
			exit(self(),shutDown),
			ok
		after 1500 ->
			cell(Ctrl,Next,Neighbours)
	end.

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
			"0";
		Alive == 2 ->
			State;
		Alive == 3 ->
			"1";
		Alive > 3 ->
			"0"
	end.

alive(Neighbours) ->
	lists:foldl(fun(X,Count) -> if X == "1" -> Count + 1; X == "0" -> Count end end ,0,Neighbours).
