{********************************************************************************
*										*
* Módulo: main.pas								*
* Tipo: Programa(+) Interfaz-Implementación TAD () Otros() 			*
* Autor/es: Eduardo de Diego Lucas						*
* Fecha de actualización: 30/10/2010						*
* Descripción: Programa principal para AVL's					*
*										*
*********************************************************************************}

PROGRAM MAIN;

	USES ARBOLAVL, ELEMTAD;

	VAR
		arbol:TAvl;

BEGIN
	WRITELN;
	WRITELN('***********************************');
	WRITELN('*                                 *');
	WRITELN('*      PROGRAMA DE AVLs           *');
	WRITELN('*Creado por Eduardo de Diego Lucas*');
	WRITELN('*                                 *');
	WRITELN('***********************************');
	WRITELN;
	WRITELN('1.Creamos arbol AVL a partir de la secuencia: 5-9-7-15-20-17-19-23');
	CrearAVLVacio(arbol);
	InsertarEnAVL(arbol,5);
	InsertarEnAVL(arbol,9);
	InsertarEnAVL(arbol,7);
	InsertarEnAVL(arbol,15);
	InsertarEnAVL(arbol,20);
	InsertarEnAVL(arbol,17);
	InsertarEnAVL(arbol,19);
	InsertarEnAVL(arbol,23);
	READLN;
	WRITELN('Resultado:');
	WRITELN;
	Mostrar(arbol);
END.
