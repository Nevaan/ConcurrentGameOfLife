%% @author Pawel Losek

-module(gameOfLife).
-export([gameOfLifeNode/0]).
-import(processHandler,[all/0]).
-import(outputFormat,[formatOutput/1]).

% funkcja nawiazujaca polaczenie z GUI i inicjalizująca działanie programu
gameOfLifeNode() ->
	io:format("Waiting for GUI node... ~n"),
	receive
		{Pid, gui} ->
			io:format("Connected with guiNode")
	end,
	All = all(),
	init(self(),All),
	outputLoop(All, Pid).

% funkcja mapujaca funkcje listen na PIDy wszystkich komorek
actual(All) ->
	lists:map(fun(X) -> [X, listen(X)] end, All).

% petla wysylajaca string ze stanem automatu do GUI
outputLoop(All, Pid) ->
	Output = formatOutput(actual(All)),
	Pid ! Output,
	outputLoop(All, Pid).

% wysyłanie wiadomosci 
init(Pid,All) ->
	lists:foreach(fun(Proc)-> Proc ! {go,Pid} end, All).

% zbieranie krotki {PID, stan} zmapowane na wszystkie procesy-komorki
listen(X) ->
	receive
		{X,State} -> State
	end.
