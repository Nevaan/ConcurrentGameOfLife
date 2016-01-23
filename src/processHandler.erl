%% @author Pawel Losek

-module(processHandler).
-export([all/0]).
-import(inputFormat, [createRows/0]).



%% tworzy siatke komorek z listy procesow i laczy je ze soba
all() ->
	{Grid,All} = createRows(),
	connect(Grid),
	All.

%% funkcja rozsylajaca identyfikatory procesow - sasiadow 
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
