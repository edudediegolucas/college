# STR (Sistemas en Tiempo Real) - 2010

This is the final assignment for STR subject in 2010. It was based on Real-time systems, simulating a robot that walks through a maze finding a given location (x and y coordinates).

It is writing in C language. In order to remain the _old times_, I've decided to maintain the Spanish sentences and comments inside the code.

## How to build and run it

Make sure you have ```gcc``` installed. Build it by doing:

```
gcc -Wall -lpthread -lncurses -o edulucas_p5 edulucas_p5.c
```

Run it via the exec file created. As argument, you have to pass the filename of a the map:

```
./edulucas_p5 [map]
```

I have placed here two maps, ```map1``` and ```map2```, but any map is welcome!

## Program captures

Start program:

```
V XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

                                                 X
                      X                          X
X                                                X
X                                                X
X     X                                          X
X                                                X
X                             X                  X
X        X                                       X
X                                                X
X                              X                 X
X           X                                    X
X                                                X
X              X                   X             X
X                  X                             X
X                                                X
X                                                X
X                                                X
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

*******************
[Posicion x] =>
```

Robot moving:

```
  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

                                                 X
   >                  X                          X
X                                                X
X     #                                          X
X     X                                          X
X                                                X
X                             X                  X
X        X                                       X
X                                                X
X                              X                 X
X           X                                    X
X                                                X
X              X                   X             X
X                  X                             X
X                                                X
X                                                X
X                                                X
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

*******************
[Posicion x] => 5
[Posicion y] => 6
*******************
```

Robot has arrived to the given location (end program):

```
  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

                                                 X
                      X                          X
X                                                X
X     V                                          X
X     X                                          X
X    ****************************************    X
X    ****EL ROBOT HA LLEGADO AL DESTINO******    X
X    ****************************************    X
X                                                X
X                              X                 X
X           X                                    X
X                                                X
X              X                   X             X
X                  X                             X
X                                                X
X                                                X
X                                                X
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

*******************
[Posicion x] => 5
[Posicion y] => 6
*******************
```