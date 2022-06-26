{********************************************************************************
* 										*
* Módulo: main.pas 								*
* Tipo: Programa(+) Interfaz-Implementación TAD () Otros()			*
* Autor/es: Eduardo de Diego Lucas						*
* Fecha de actualización: 4/4/2011						*
* Descripción: Programa que asigna tareas optimas con RyP			*
*										*
*********************************************************************************}
PROGRAM MAIN;

	USES TADATOS,TADSOLUCION,LISTADIN,TAREAS;

VAR
	datos:TDatos;
	sol:TSolucion;
BEGIN
	WRITELN;
	WRITELN('*************************************************************');
	WRITELN('*                                                           *');
	WRITELN('*                      ALGORITMO RyP                        *');
	WRITELN('*             Planificacion optima de tareas                *');
	WRITELN('*                                                           *');
	WRITELN('*           Creado por Eduardo de Diego Lucas               *');
	WRITELN('*                                                           *');
	WRITELN('*************************************************************');
	WRITELN;
	WRITELN;
	
	WRITELN('Inicializacion de los datos ejemplo...');
	READLN;
	InicializarDatos(datos);
	MostrarDatos(datos);
	READLN;
	AsignacionTareasRyP(sol,datos);
	MostrarSolucion(sol);
	
END.
