%% @author Pawel Losek

-module(main).
-export([start/0, stop/0]).

start() ->
	register(gameOfLifeNode,spawn_link(gameOfLife,gameOfLifeNode,[])).

stop() -> 
	gameOfLifeNode ! {abort}.