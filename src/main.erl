%% @author pawel
%% @doc @todo Add description to main.

-module(main).
-export([start/0]).

start() ->
	register(gameOfLifeNode,spawn_link(gameOfLife,gameOfLifeNode,[])).

