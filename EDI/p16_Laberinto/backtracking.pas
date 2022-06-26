{********************************************************************************
* 										*
* Módulo: backtracking.pas							*
* Tipo: Programa() Interfaz-Implementación TAD (+) Otros()			*
* Autor/es: Eduardo de Diego Lucas						*
* Fecha de actualización: 15/3/2011						*
* Descripción: Interfaz e implementacion de un algoritmo Backtracking		*
*										*
*********************************************************************************}

UNIT BACKTRACKING;

INTERFACE

	USES LABERINTO;

	PROCEDURE VueltaAtras(VAR l:TLaberinto;x,y:integer;paso:integer;VAR exito:boolean);

IMPLEMENTATION

	FUNCTION EsFactible(l:TLaberinto;x,y:integer):boolean;
	VAR
		e:integer;	
	BEGIN
		IF ((1 <= x) AND (x <= MAX) AND (1 <= y) AND (y <= MAX)) THEN BEGIN
			DameCasilla(l,x,y,e);
			EsFactible:=(e=0);
		END
		ELSE
			EsFactible:= FALSE;
	END;

	FUNCTION EsSolucion(x,y:integer):boolean;	
	BEGIN
		IF((x=MAX) AND (y=MAX)) THEN
			EsSolucion:=TRUE
		ELSE
			EsSolucion:=FALSE;
	END;

	PROCEDURE VueltaAtras(VAR l:TLaberinto;x,y:integer;paso:integer;VAR exito:boolean);
	BEGIN
		PonerCasilla(l,x,y,paso);
		IF(EsSolucion(x,y)) THEN
			exito:=TRUE
		ELSE
		BEGIN
			{miramos abajo}
			IF((EsFactible(l,x,y+1)) AND NOT(exito)) THEN
				VueltaAtras(l,x,y+1,paso+1,exito);
			{miramos a la derecha}
			IF((EsFactible(l,x+1,y)) AND NOT(exito)) THEN
				VueltaAtras(l,x+1,y,paso+1,exito);
			{miramos hacia arriba}
			IF((EsFactible(l,x,y-1)) AND NOT(exito)) THEN
				VueltaAtras(l,x,y-1,paso+1,exito);
			{miramos hacia la izquierda}
			IF((EsFactible(l,x-1,y)) AND NOT(exito)) THEN
				VueltaAtras(l,x-1,y,paso+1,exito);
		END;
		IF(NOT(exito)) THEN
			PonerCasilla(l,x,y,0);
	END;
END.
