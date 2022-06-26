{********************************************************************************
*										*
* Módulo: viajes.pas								*
* Tipo: Programa(+) Interfaz-Implementación TAD () Otros() 			*
* Autor/es: Eduardo de Diego Lucas						*
* Fecha de actualización: 13/11/2010						*
* Descripción: Programa principal para realizar el grafo viajes			*
*										*
*********************************************************************************}

PROGRAM VIAJES;

USES GRAFO;

VAR
	mapa:TGrafo;
	
BEGIN
	
	WRITELN;
	WRITELN('*************************************************************');
	WRITELN('*                                                           *');
	WRITELN('*               PROGRAMA DE CONSULTAS DE VIAJES             *');
	WRITELN('*                 CREADO A PARTIR DE GRAFOS                 *');
	WRITELN('*                                                           *');
	WRITELN('*           Creado por Eduardo de Diego Lucas               *');
	WRITELN('*                                                           *');
	WRITELN('*************************************************************');
	WRITELN;
	WRITELN;
	
	
	CrearGrafoVacio(mapa);
	InsertarNodo(mapa,'Londres');
	InsertarNodo(mapa,'Madrid');
	InsertarNodo(mapa,'Paris');
	InsertarNodo(mapa,'Valencia');
	InsertarNodo(mapa,'Cagliari');
	
	READLN;
	WRITELN('Ciudades del mapa');
	WRITELN;
	Mostrar(mapa);
	
	READLN;
	
	
	WRITELN('Insertando los viajes...');
	WRITELN;
	READLN;
	
	InsertarDestino(mapa,'Londres','Paris', 2.0);
	InsertarDestino(mapa,'Londres','Madrid', 2.0);
	InsertarDestino(mapa,'Londres','Cagliari', 4.0);
	InsertarDestino(mapa,'Paris','Madrid', 2.0);
	InsertarDestino(mapa,'Paris','Cagliari', 2.0);
	InsertarDestino(mapa,'Madrid','Valencia', 2.0);
	
	Mostrar(mapa);

	READLN;
	
END.
