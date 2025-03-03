# Assignment 4 Erlang Processes Program

## Team Members: Kibby Hyacinth Pangilinan

### Running the Erlang program
1) Within the root directory of your project, start up Erlang:
``` erl ```

2) Compile and run the serv_recv module:
```
c(serv_recv). 
serv_recv:start().
```
**Test all three servers to check that they are working how they are supposed to**

3) serv1 possible input examples:
```
{add, 1, 2}.
{divide, 20, 5}.
{sqrt, 16}.
```

4) serv2 possible input examples:
```
[1,2].
[1.0,2.0].

```

5) serv3 possible input examples (unhandled inputs):
```
hello.
```

6) Halting server processes: 
```halt.```

7) Stopping execution of main function:
```all_done.```

8) Exit Erlang by pressing Ctrl + G followed by a 'q' and enter.

