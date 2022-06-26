{********************************************************************************
* 										*
* Módulo: main.pas 								*
* Tipo: Programa(+) Interfaz-Implementación TAD () Otros()			*
* Autor/es: Eduardo de Diego Lucas						*
* Fecha de actualización: 14/3/2011						*
* Descripción: Interfaz e implementacion del algoritmo de Kruskal		*
*										*
*********************************************************************************}

PROGRAM MAIN;

USES 
	CONJUNDN,CONJUNDA,GRAFO,KRUSKAL;

VAR
	g:TGrafo;
	cSolucion:TConjuntoA;
	exito:boolean;
BEGIN

	WRITELN;
	WRITELN('*************************************************************');
	WRITELN('*                                                           *');
	WRITELN('*                  ALGORITMO DE KRUSKAL                     *');
	WRITELN('*                                                           *');
	WRITELN('*           Creado por Eduardo de Diego Lucas               *');
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
	InsertarArista(g,1,3,4);
	InsertarArista(g,2,3,1);
	InsertarArista(g,2,4,2);
	InsertarArista(g,2,5,4);
	InsertarArista(g,3,4,3);
	InsertarArista(g,4,5,5);

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

	WRITELN('Aplicacion algoritmo de Kruskal. Conjunto Aristas solucion:');
	AlgoritmoKruskal(g,cSolucion,exito);
	IF(exito) THEN
		CONJUNDA.Mostrar(cSolucion);
END.
