%% @author Pawel Losek

-module(cell).
-export([init/1, start/1]).

%% Modul pojedynczego procesu - komorki

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

%% petla procesu
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


%% rozsylanie wlasnego stanu do sasiadujacych komorek
multicast(State,Neighbors) ->
	Self = self(),
	lists:foreach(fun(Pid)->Pid ! {state,Self,State} end, Neighbors).

%% zbieranie stanu komorek sasiadujacych
collect(Neighbors) ->
	lists:map(fun(Pid) -> 
		receive
			{state,Pid,State} ->
				State
		end
	end,
	Neighbors).

%% regula automatu
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

%% funkcja liczaca ilosc zywych, sasiadujacych komorek
alive(Neighbours) ->
	lists:foldl(fun(X,Count) -> if X == "1" -> Count + 1; X == "0" -> Count end end ,0,Neighbours).
