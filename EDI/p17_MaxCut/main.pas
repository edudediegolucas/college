{********************************************************************************
* 										*
* Módulo: main.pas 								*
* Tipo: Programa(+) Interfaz-Implementación TAD () Otros()			*
* Autor/es: Eduardo de Diego Lucas						*
* Fecha de actualización: 19/3/2011						*
* Descripción: Interfaz e implementacion del algoritmo de Max Cut		*
*										*
*********************************************************************************}

PROGRAM MAIN;

USES 
	CONJUNDN,CONJUNDA,GRAFO,TADSOLUCION,MAXCUT;

VAR
	g:TGrafo;
	solucion1,solucion2:TSolucion;
	nodos:TConjuntoN;
	aristas:TConjuntoA;
BEGIN

	WRITELN;
	WRITELN('*************************************************************');
	WRITELN('*                                                           *');
	WRITELN('*                  PROBLEMA DE MAX CUT                      *');
	WRITELN('*            Usando un algoritmo de BackTracking            *');
	WRITELN('*                                                           *');
	WRITELN('*             Creado por Eduardo de Diego Lucas             *');
	WRITELN('*                                                           *');
	WRITELN('*************************************************************');
	WRITELN;
	WRITELN;	

	READLN;
	
	CrearGrafoVacio(g);
	
	{*** GRAFO EJEMPLO 1 ***}	
	InsertarNodo(g,5);
	InsertarNodo(g,4);
	InsertarNodo(g,3);
	InsertarNodo(g,2);
	InsertarNodo(g,1);

	InsertarArista(g,1,2,2);
	InsertarArista(g,1,3,3);
	InsertarArista(g,1,4,5);
	InsertarArista(g,1,5,4);
	InsertarArista(g,2,4,6);
	InsertarArista(g,3,5,7);
	InsertarArista(g,4,5,8);

	{*** GRAFO EJEMPLO 2 ***}
{
	InsertarNodo(g,6);
	InsertarNodo(g,5);
	InsertarNodo(g,4);
	InsertarNodo(g,3);
	InsertarNodo(g,2);
	InsertarNodo(g,1);

	InsertarArista(g,1,2,1);
	InsertarArista(g,1,3,2);
	InsertarArista(g,2,3,3);
	InsertarArista(g,3,4,1);
	InsertarArista(g,3,5,5);
	InsertarArista(g,4,6,2);
	InsertarArista(g,5,6,2);
}

	WRITELN('Estructura del grafo...');
	Mostrar(g);
	READLN;
	InicializarBT(solucion1,solucion2,nodos,aristas,g);
	WRITELN('Aplicacion algoritmo MaxCut con Backtracking. Conjunto Nodos solucion:');
	MaxCutBT(solucion1,solucion2,nodos,aristas);
	MostrarSolucion(solucion2)
	
END.
