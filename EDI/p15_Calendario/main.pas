{********************************************************************************
* 										*
* Módulo: main.pas								*
* Tipo: Programa(+) Interfaz-Implementación TAD () Otros()			*
* Autor/es: Eduardo de Diego Lucas						*
* Fecha de actualización: 25/3/2011						*
* Descripción: Programa principal calendario Divide y Venceras			*
*										*
*********************************************************************************}

PROGRAM MAIN;

USES TABLA,CALENDARIODV;

VAR
	t:TTabla;
BEGIN

	WRITELN;
	WRITELN('*************************************************************');
	WRITELN('*                                                           *');
	WRITELN('*             ALGORITMO DIVIDE Y VENCERAS                   *');
	WRITELN('*             Calendario de un campeonato                   *');
	WRITELN('*                                                           *');
	WRITELN('*           Creado por Eduardo de Diego Lucas               *');
	WRITELN('*                                                           *');
	WRITELN('*************************************************************');
	WRITELN;
	WRITELN;

	CrearTablaVacia(t);
	MostrarTabla(t);
	READLN;
	Calendario(t);
	WRITELN('***SOLUCION FINAL***');
	MostrarTabla(t);
	
END.
