iPhone Development CIS 195
Project 1
Sebastian Schloesser


APP INSTRUCTIONS

Guide to use calculator app.

Buttons:
left arrow - decoration

right arrow - decoration

orange alt button - alt option

clear - backspace, clears all when alt is selected

+/- - if there is only one number on the screen, it will invert its sign

X - variable x

STR - computes whatever is on the screen and stores it as variable X

pi - insert pi constant, e constant when alt is selected

ENTER - compute expression on screen


Everything else is self explanatory.


INITIAL PLAN

This project will consist of creating an iOS calculator. In order to follow a 
proper MVC structure, I will place all the computation methods in a model class. 
The view will be all held in the storyboard and its respective controller will 
be in the ViewController class. After I finish designing a UI that satisfies all
the project requirements, such the arithmetic operations, a number pad, a 
decimal point, etc. I will wire all the buttons to the controller. Buttons will
place a string on the calculator's "screen". Rather than operating like most
calculators, where one can only do one operation at a time, I plan on allowing
the user to create a string of operations on the string that will then be
executed, just like in scientific/graphing calculators. This means that when the
user hits enter, an NSString will be sent to the model for parsing. Then, I will
need to determine the order of operations and place the operands and operators
in data structures in the right order. Finally, they will be executed in an RPN
fashion and then the result will be sent back to the screen. If the string
does not make sense or contains a division by zero, an error message can be sent
to the screen. All numbers will be contained in floats. 

The model would contain a method called compute, which takes a string and 
returns a float. This method would then call a method that parses the string and
returns a data structure with all the operators and another one with all the 
operands in order. Then I will iterate through the operators looking for them
in the proper order. For example, if I had the string "1+3*7", I would get 
operators = [+, *] and operands = [1, 3, 7]. I would first look for 
multiplications, so I would get that operators(1) is a multiplication so I would
perform the operation operands(1)*operands(2), delete both those entries from 
the structure and put the result back at operands(1). This process could
continue to complete the operation of the entire string. 

In the future, I could add exponent and parenthesis capabilities by improving
the parsing system. I could write another method that gets the string first and
separates each parenthesis into a string of its own that gets computed and then 
placed back on the original one so that the same methods described above can
solve the entire thing. 

To ensure that the string is valid, intelligence needs to be added to the 
ViewController. This means that the user won't be able to place two operators
next to each other and other things that don't make sense, such as just placing
a decimal point for an operand, etc. 

