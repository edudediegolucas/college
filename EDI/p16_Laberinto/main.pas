{********************************************************************************
* 										*
* Módulo: main.pas 								*
* Tipo: Programa(+) Interfaz-Implementación TAD () Otros()			*
* Autor/es: Eduardo de Diego Lucas						*
* Fecha de actualización: 16/3/2011						*
* Descripción: Programa que recorre un laberinto con Backtracking		*
*										*
*********************************************************************************}

PROGRAM MAIN;

USES LABERINTO,BACKTRACKING;

VAR
	l:TLaberinto;
	exito:boolean;
BEGIN

	WRITELN;
	WRITELN('*************************************************************');
	WRITELN('*                                                           *');
	WRITELN('*                  ALGORITMO BACKTRACKING                   *');
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
	exito:=FALSE;
	VueltaAtras(l,1,1,1,exito);

	IF(exito) THEN
		MostrarLaberinto(l)
	ELSE
		WRITELN('Laberinto no conseguido :( ');
END.
