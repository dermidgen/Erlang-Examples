%%% -------------------------------------------------------------------
%%% Author  : dgraham
%%% Description :
%%%
%%% Created : Dec 22, 2009
%%% -------------------------------------------------------------------
-module(ls_server).

-behaviour(gen_server).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------

%% --------------------------------------------------------------------
%% External exports
-export([start_link/0,stop/0,store_location/3,fetch_location/2,alert_to_change/2]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-record(state, {}).

%% --------------------------------------------------------------------
%% Macros
%% --------------------------------------------------------------------
-define(SERVER, ?MODULE).

%% ====================================================================
%% External functions
%% ====================================================================

start_link() ->
	gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

stop() ->
	gen_server:cast(?SERVER, stop).

store_location(Node, Id, Location) when is_atom(Id), is_list(Location) ->
	gen_server:cast({?SERVER, Node}, {store_location, {Id, Location}}).

fetch_location(Node, Id) ->
	gen_server:call({?SERVER, Node}, {fetch_location, Id}).

alert_to_change(Node, Id) ->
	gen_server:call({?SERVER, Node}, {alert_to_change, {Id, self()}}).

%% ====================================================================
%% Server functions
%% ====================================================================

%% --------------------------------------------------------------------
%% Function: init/1
%% Description: Initiates the server
%% Returns: {ok, State}          |
%%          {ok, State, Timeout} |
%%          ignore               |
%%          {stop, Reason}
%% --------------------------------------------------------------------
init([]) ->
	error_logger:info_msg("ls_server:init/1 startin~n", []),
    {ok, dict:new()}.

%% --------------------------------------------------------------------
%% Function: handle_call/3
%% Description: Handling call messages
%% Returns: {reply, Reply, State}          |
%%          {reply, Reply, State, Timeout} |
%%          {noreply, State}               |
%%          {noreply, State, Timeout}      |
%%          {stop, Reason, Reply, State}   | (terminate/2 is called)
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------
handle_call({fetch_location, Id}, From, State) ->
    case dict:find(Id, State) of
		{ok, {Location, ListOfSubscribers}} -> {reply, {ok, Location}, State };
		error	-> {reply, {error, no_such_id}, State }
	end;

handle_call({alert_to_change, {Id, Subscriber}}, From, State) ->
	case dict:find(Id, State) of
		{ok, {Location, ListOfSubscribers}} ->
			NewListOfSubscribers = [Subscriber|lists:delete(Subscriber, ListOfSubscribers)],
			NewState = dict:store(Id, {Location, NewListOfSubscribers}, State),
			{reply, true, NewState};
		error ->
			{reply, false, State}
	end.


%% --------------------------------------------------------------------
%% Function: handle_cast/2
%% Description: Handling cast messages
%% Returns: {noreply, State}          |
%%          {noreply, State, Timeout} |
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------
handle_cast(Msg, State) ->
    {noreply, State}.

%% --------------------------------------------------------------------
%% Function: handle_info/2
%% Description: Handling all non call/cast messages
%% Returns: {noreply, State}          |
%%          {noreply, State, Timeout} |
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------
handle_info(Info, State) ->
    {noreply, State}.

%% --------------------------------------------------------------------
%% Function: terminate/2
%% Description: Shutdown the server
%% Returns: any (ignored by gen_server)
%% --------------------------------------------------------------------
terminate(Reason, State) ->
    ok.

%% --------------------------------------------------------------------
%% Func: code_change/3
%% Purpose: Convert process state when code is changed
%% Returns: {ok, NewState}
%% --------------------------------------------------------------------
code_change(OldVsn, State, Extra) ->
    {ok, State}.

%% --------------------------------------------------------------------
%%% Internal functions
%% --------------------------------------------------------------------

