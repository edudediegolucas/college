{********************************************************************************
* 										*
* Módulo: main.pas 								*
* Tipo: Programa(+) Interfaz-Implementación TAD () Otros()			*
* Autor/es: Eduardo de Diego Lucas						*
* Fecha de actualización: 14/2/2011						*
* Descripción: Interfaz e implementacion de problema del cambio			*
*										*
*********************************************************************************}

PROGRAM MAIN;

	USES CONJUND, CAMBIO;

VAR
	cSol,cCand:TConjunto;
	change,m1,m2,m3,m4:integer;
	exito1,exito2,exito3:boolean;

BEGIN

	WRITELN;
	WRITELN('*************************************************************');
	WRITELN('*                                                           *');
	WRITELN('*                  El problema del cambio                   *');
	WRITELN('*                     ALGORITMO VORAZ                       *');
	WRITELN('*                                                           *');
	WRITELN('*           Creado por Eduardo de Diego Lucas               *');
	WRITELN('*                                                           *');
	WRITELN('*************************************************************');
	WRITELN;
	WRITELN;	

	WRITELN('CAMBIO ILIMITADO. Valores de las monedas: 50, 25, 5, 1');
	WRITE('Introduzca cambio: ');
	READLN(change);
	CambioIlimitado50(cSol,cCand,change,exito1);
	WRITELN;
	IF(exito1) THEN
		Mostrar(cSol);
	WRITELN;

	WRITELN('CAMBIO ILIMITADO. Valores de las monedas: 11, 5, 1');
	WRITE('Introduzca cambio: ');
	READLN(change);
	CambioIlimitado11(cSol,cCand,change,exito2);
	WRITELN;
	IF(exito2) THEN
		Mostrar(cSol);
	WRITELN;

	{*** El esquema voraz no es correcto para este conjunto de monedas. Un caso es cuando hay que devolver 15 ***}
	{*** Obtiene una solucion valida con el esquema de 50,25,5 y 1. Pero si quitamos la moneda 1, muchos casos no se pueden resolver ***}

	WRITELN('CAMBIO LIMITADO. Valores de las monedas: 50, 25, 5, 1');
	WRITELN('Introduzca cambio y a continucacion la cantidad de monedas: ');
	WRITE('[CAMBIO]');READLN(change);
	WRITE('[50]');READLN(m1);
	WRITE('[25]');READLN(m2);
	WRITE('[5]');READLN(m3);
	WRITE('[1]');READLN(m4);
	CambioLimitado(cSol,cCand,change,m1,m2,m3,m4,exito3);
	WRITELN;
	IF(exito3) THEN
		Mostrar(cSol);
	WRITELN;

	{*** El cambio que se tiene que hacer es que cada vez que se comprueba si EsFactible el candidato, quitarlo del conjunto inmediatamente ***}
	
END.
