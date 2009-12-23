%% Author: jamesa
%% Created: Dec 23, 2009
%% Description: TODO: Prints list of Temps in Celcius, and lists Min/Max, in recursion.
-module(test).

%%
%% Include files
%%

%%
%% Exported Functions
%%
-export([format_templist/1]).

%%
%% API Functions
%%
format_templist(List) ->
	format_temps(List).

format_temps([City | Rest]) ->
	TempCity = convert_to_c(City),
	{TempMin, TempMax} = test_minmax(TempCity, TempCity, TempCity),
	print_temp(TempCity),
	format_tempsfind(Rest, TempMin, TempMax).

format_tempsfind([City | Rest], Min, Max) ->
	TempCity = convert_to_c(City),
	{TempMin, TempMax} = test_minmax(TempCity, Min, Max),
	print_temp(TempCity),
	format_tempsfind(Rest, TempMin, TempMax);
format_tempsfind([], Min, Max) ->
	print_minmax(Min, Max),
	ok.
%%
%% Local Functions
%%

print_minmax({Min_Name, {c, Min_Temp}}, {Max_Name, {c, Max_Temp}}) ->
	io:format("Max temperature was ~w c in ~w~n", [Max_Temp, Max_Name]),
	io:format("Min temperature was ~w c in ~w~n", [Min_Temp, Min_Name]).

print_temp({Name, {Type, Temp}}) ->
	io:format("~-15w ~w ~w~n", [Name, Temp, Type]).


convert_to_c({Name, {f, Temp}}) ->
	{Name, {c, (Temp -32)* 5 / 9}};
convert_to_c(City) ->
	City.

test_minmax({Compare_Name, {Compare_Type, Compare_Temp}}, {Min_Name, {Min_Type, Min_Temp}}, {Max_Name, {Max_Type, Max_Temp}}) ->
	if 
		Compare_Name == Min_Name;
		Compare_Temp < Min_Temp ->
			TempMin = {Compare_Name, {Compare_Type, Compare_Temp}};
		true ->
			TempMin = {Min_Name, {Min_Type, Min_Temp}}
	end,
	if 
		Compare_Name == Max_Name;
		Compare_Temp > Max_Temp ->
			TempMax = {Compare_Name, {Compare_Type, Compare_Temp}};
		true ->
			TempMax = {Max_Name, {Max_Type, Max_Temp}}
	end,
	{TempMin, TempMax}.
	