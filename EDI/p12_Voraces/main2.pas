{********************************************************************************
* 										*
* Módulo: main2.pas 								*
* Tipo: Programa(+) Interfaz-Implementación TAD () Otros()			*
* Autor/es: Eduardo de Diego Lucas						*
* Fecha de actualización: 14/2/2011						*
* Descripción: Interfaz e implementacion de problema del cambio			*
*										*
*********************************************************************************}

PROGRAM MAIN2;

	USES CONJUND2, MOCHILA;

VAR
	cSol,cCand:TConjunto;
	exito1,exito2,exito3,exito4,exito5,exito6:boolean;

BEGIN

	WRITELN;
	WRITELN('*************************************************************');
	WRITELN('*                                                           *');
	WRITELN('*                 El problema de la mochila                 *');
	WRITELN('*                     ALGORITMO VORAZ                       *');
	WRITELN('*                                                           *');
	WRITELN('*           Creado por Eduardo de Diego Lucas               *');
	WRITELN('*                                                           *');
	WRITELN('*************************************************************');
	WRITELN;
	WRITELN;	

	WRITELN('MOCHILA MAYOR VALOR. Con n=5 W=100.');
	MochilaValor5(cSol,cCand,100,exito1);
	IF(exito1) THEN BEGIN
		WRITELN('SOLUCION:');
		Mostrar(cSol);
	END;
	WRITELN;

	WRITELN;
	WRITELN('MOCHILA MENOR PESO. Con n=5 W=100.');
	MochilaPeso5(cSol,cCand,100,exito2);
	IF(exito2) THEN BEGIN
		WRITELN('SOLUCION:');
		Mostrar(cSol);
	END;
	WRITELN;

	WRITELN;
	WRITELN('MOCHILA MAYOR VALOR POR PESO. Con n=5 W=100.');
	MochilaValorPeso5(cSol,cCand,100,exito3);
	IF(exito3) THEN BEGIN
		WRITELN('SOLUCION:');
		Mostrar(cSol);
	END;
	WRITELN;

	WRITELN;
	WRITELN('MOCHILA MAYOR VALOR. Con n=3 W=6.');
	MochilaValor3(cSol,cCand,6,exito4);
	IF(exito4) THEN BEGIN
		WRITELN('SOLUCION:');
		Mostrar(cSol);
	END;
	WRITELN;

	WRITELN;
	WRITELN('MOCHILA MENOR PESO. Con n=3 W=6.');
	MochilaPeso3(cSol,cCand,6,exito5);
	IF(exito5) THEN BEGIN
		WRITELN('SOLUCION:');
		Mostrar(cSol);
	END;
	WRITELN;

	WRITELN;
	WRITELN('MOCHILA MAYOR VALOR POR PESO. Con n=3 W=6.');
	MochilaValorPeso3(cSol,cCand,6,exito6);
	IF(exito6) THEN BEGIN
		WRITELN('SOLUCION:');
		Mostrar(cSol);
	END;
	WRITELN;
END.
