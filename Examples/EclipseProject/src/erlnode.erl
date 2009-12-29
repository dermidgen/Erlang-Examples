%% Author: dgraham
%% Created: Dec 28, 2009
%% Description: TODO: Add description to erlnode
-module(erlnode).

%%
%% Include files
%%

%%
%% Exported Functions
%%
-export([start/0, echo/0, test/0]).

%%
%% API Functions
%%

echo() ->
	receive
		quit -> ok;
		{echo, PID, What} -> 
			io:fwrite("Got a message from the server ~p", [PID]),
			PID ! {echo, self(), What},
			echo();
		X ->
			io:fwrite("Got ~p.~n", [X])
	end.

test() ->
	erlnode ! {echo, self(), "TESTING"},
	receive
		{echo, PID, What} ->
			io:fwrite("Test received a reply from erlnode")
	end.

%%
%% Local Functions
%%

start() ->
	Mypid = spawn( erlnode, echo, []),
	register( erlnode, Mypid).