{********************************************************************************
* 										*
* Módulo: main.pas 								*
* Tipo: Programa(+) Interfaz-Implementación TAD () Otros()			*
* Autor/es: Eduardo de Diego Lucas						*
* Fecha de actualización: 19/3/2011						*
* Descripción: Programa que recorre un laberinto con RyP			*
*										*
*********************************************************************************}

PROGRAM MAIN;

USES LABERINTO,TADSOLUCION,RYP;

VAR
	l:TLaberinto;
	sol:TSolucion;
BEGIN

	WRITELN;
	WRITELN('*************************************************************');
	WRITELN('*                                                           *');
	WRITELN('*                      ALGORITMO RyP                        *');
	WRITELN('*           Encontrar la salida de un laberinto             *');
	WRITELN('*                                                           *');
	WRITELN('*           Creado por Eduardo de Diego Lucas               *');
	WRITELN('*                                                           *');
	WRITELN('*************************************************************');
	WRITELN;
	WRITELN;

	CrearLaberintoEjemplo(l);
	MostrarLaberinto(l);

	READLN;
	LaberintoRyP(sol,l);
	MostrarSolucion(sol);
END.
