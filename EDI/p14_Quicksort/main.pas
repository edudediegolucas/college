{********************************************************************************
* 										*
* Módulo: main.pas 								*
* Tipo: Programa(+) Interfaz-Implementación TAD () Otros()			*
* Autor/es: Eduardo de Diego Lucas						*
* Fecha de actualización: 15/3/2011						*
* Descripción: Interfaz e implementacion del algoritmo Quicksort		*
*										*
*********************************************************************************}

PROGRAM MAIN;

USES 
	VECTOR,QUICKSORT;

VAR
	v1,v2:TVector;
BEGIN

	WRITELN;
	WRITELN('*************************************************************');
	WRITELN('*                                                           *');
	WRITELN('*                  ALGORITMO QUICKSORT                      *');
	WRITELN('*                                                           *');
	WRITELN('*           Creado por Eduardo de Diego Lucas               *');
	WRITELN('*                                                           *');
	WRITELN('*************************************************************');
	WRITELN;
	WRITELN;	
	
	READLN;

	InicializarVector(v1);
	AsignarVector(v2,v1);
	WRITELN('Vector inicial:');
	Mostrar(v1);
	WRITELN('QUICKSORT!');
	QUICKSORT.Quicksort(v1,1,MAX);
	WRITELN('Vector antes de algoritmo QuickSort:');
	Mostrar(v2);
	WRITELN('Vector despues de algoritmo QuickSort:');
	Mostrar(v1);

END.
