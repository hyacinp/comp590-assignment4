% Team members: Kibby Hyacinth Pangilinan
-module(send_recv).
-export([start/0, serv1/1, serv2/1, serv3/1]).

% serv1

serv1(Serv2) ->
    receive
        {add, X, Y} ->
            io:format("(serv1) ~p + ~p = ~p~n", [X, Y, X + Y]),
            serv1(Serv2);
        {sub, X, Y} ->
            io:format("(serv1) ~p - ~p = ~p~n", [X, Y, X - Y]),
            serv1(Serv2);
        {mult, X, Y} ->
            io:format("(serv1) ~p * ~p = ~p~n", [X, Y, X * Y]),
            serv1(Serv2);
        {divide, X, Y} when Y =/= 0 ->
            io:format("(serv1) ~p / ~p = ~p~n", [X, Y, X / Y]),
            serv1(Serv2);
        {neg, X} ->
            io:format("(serv1) neg(~p) = ~p~n", [X, -X]),
            serv1(Serv2);
        {sqrt, X} when X >= 0 ->
            io:format("(serv1) sqrt(~p) = ~p~n", [X, math:sqrt(X)]),
            serv1(Serv2);
        L when is_list(L) ->
            Serv2 ! L,
            serv1(Serv2);
        halt -> 
            io:format("(serv1) Halting.~n"),
            Serv2 ! halt;
        _Other -> 
            io:format("(serv1) Unknown message: ~p~n", [_Other]),
            Serv2 ! _Other,  
            serv1(Serv2)
    end.

% serv2
serv2(Serv3) ->
     receive
        [H | T] when is_number(H) ->
            case is_integer(H) of
                true -> 
                    Sum = lists:sum([X || X <- [H | T], is_number(X)]),
                    io:format("(serv2) Sum = ~p~n", [Sum]);
                false -> 
                    Product = lists:foldl(fun(X, Acc) -> if is_number(X) -> X * Acc; true -> Acc end end, 1, [H | T]),
                    io:format("(serv2) Product = ~p~n", [Product])
            end,
            serv2(Serv3);
        halt ->
            Serv3 ! halt,
            io:format("(serv2) Halting.~n");
        Msg ->
            Serv3 ! Msg,
            serv2(Serv3)
    end.

% serv3
serv3(Count) ->
     receive
        {error, Msg} ->
            io:format("(serv3) Error: ~p~n", [Msg]),
            serv3(Count);
        halt ->
            io:format("(serv3) Halting. Unhandled message count: ~p~n", [Count]);
        Msg ->
            io:format("(serv3) Not handled: ~p~n", [Msg]),
            serv3(Count + 1)
    end.

% main function
start() ->
    Serv3 = spawn(fun() -> serv3(0) end),
    Serv2 = spawn(fun() -> serv2(Serv3) end),
    Serv1 = spawn(fun() -> serv1(Serv2) end),
    loop(Serv1).


loop(Serv1) ->
    case io:read("Enter a message (or type 'all_done' to exit): ") of
        {ok, all_done} ->
            Serv1 ! halt,
            io:format("Exiting main function.~n"),
            ok;
        {ok, Msg} ->
            Serv1 ! Msg,
            loop(Serv1);
        {error, Reason} ->
            io:format("Error reading input: ~p~n", [Reason]),
            loop(Serv1)
    end.

