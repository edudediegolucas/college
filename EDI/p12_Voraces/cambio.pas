{********************************************************************************
* 										*
* Módulo: cambio.pas 								*
* Tipo: Programa() Interfaz-Implementación TAD (+) Otros()			*
* Autor/es: Eduardo de Diego Lucas						*
* Fecha de actualización: 14/2/2011						*
* Descripción: Interfaz e implementacion de problema del cambio			*
*										*
*********************************************************************************}

UNIT CAMBIO;

INTERFACE

	USES ELEMTAD,CONJUND;

	PROCEDURE CambioIlimitado50(VAR cSolucion:TConjunto; cCandidato:TConjunto; cambio:integer; VAR exito:boolean);
	PROCEDURE CambioIlimitado11(VAR cSolucion:TConjunto; cCandidato:TConjunto; cambio:integer; VAR exito:boolean);
	PROCEDURE CambioLimitado(VAR cSolucion:TConjunto; cCandidato:TConjunto; cambio,monedas1,monedas2,monedas3,monedas4:integer; VAR exito:boolean);

IMPLEMENTATION

	PROCEDURE RellenarConjunto50(VAR cCandidato:TConjunto);
	BEGIN
		CrearConjuntoVacio(cCandidato);
		Poner(cCandidato,50);
		Poner(cCandidato,25);
		Poner(cCandidato,5);
		Poner(cCandidato,1);
	END;

	PROCEDURE RellenarConjunto11(VAR cCandidato:TConjunto);
	BEGIN
		CrearConjuntoVacio(cCandidato);
		Poner(cCandidato,11);
		Poner(cCandidato,5);
		Poner(cCandidato,1);
	END;

	PROCEDURE RellenarConjunto50Limitado(VAR cCandidato:TConjunto; monedas1,monedas2,monedas3,monedas4:integer);
	VAR
		i:integer;	
	BEGIN
		CrearConjuntoVacio(cCandidato);
		FOR i:=1 TO monedas1 DO
			Poner(cCandidato,50);
		FOR i:=1 TO monedas2 DO
			Poner(cCandidato,25);
		FOR i:=1 TO monedas3 DO
			Poner(cCandidato,5);
		FOR i:=1 TO monedas4 DO
			Poner(cCandidato,1);
	END;

	FUNCTION EsFactible(cSolucion:TConjunto;e:TElemento; cambio:integer):boolean;
	VAR
		suma,diferencia:integer;	
	BEGIN
		EsFactible:=FALSE;
		SumarConjunto(cSolucion,suma);
		diferencia:=cambio-suma;
		IF(diferencia>=e) THEN
			EsFactible:=TRUE
		ELSE
			EsFactible:=FALSE;
	END;

	{*** MONEDAS 50,25,5 y 1 ***}
	PROCEDURE CambioIlimitado50(VAR cSolucion:TConjunto; cCandidato:TConjunto; cambio:integer; VAR exito:boolean);
	VAR
		e:TElemento;
		solucion:boolean;
		suma,monedas:integer;
	BEGIN
		CrearConjuntoVacio(cSolucion);
		RellenarConjunto50(cCandidato);
		solucion:=FALSE;
		exito:=FALSE;
		monedas:=0;
		WHILE((NOT(EsConjuntoVacio(cCandidato))) AND NOT(solucion)) DO BEGIN
			Elegir(cCandidato,e);
			WHILE(EsFactible(cSolucion,e,cambio)) DO BEGIN
				Poner(cSolucion,e);
				monedas:=monedas + 1;
			END;
			WRITELN('*',monedas,' monedas de ', e);
			Quitar(cCandidato,e);
			monedas:=0;
			SumarConjunto(cSolucion,suma);
			IF(suma = cambio) THEN
				solucion:=TRUE;
		END;
		IF(NOT(solucion)) THEN
			WRITELN('No hay posible cambio!')
		ELSE
			exito:=TRUE;	
	END;

	{*** MONEDAS 11,5 y 1 ***}
	PROCEDURE CambioIlimitado11(VAR cSolucion:TConjunto; cCandidato:TConjunto; cambio:integer; VAR exito:boolean);
	VAR
		e:TElemento;
		solucion:boolean;
		suma,monedas:integer;
	BEGIN
		CrearConjuntoVacio(cSolucion);
		RellenarConjunto11(cCandidato);
		solucion:=FALSE;
		exito:=FALSE;
		monedas:=0;
		WHILE((NOT(EsConjuntoVacio(cCandidato))) AND NOT(solucion)) DO BEGIN
			Elegir(cCandidato,e);
			WHILE(EsFactible(cSolucion,e,cambio)) DO BEGIN
				Poner(cSolucion,e);
				monedas:=monedas + 1;
			END;
			WRITELN('*',monedas,' monedas de ', e);
			Quitar(cCandidato,e);
			monedas:=0;
			SumarConjunto(cSolucion,suma);
			IF(suma = cambio) THEN
				solucion:=TRUE;
		END;
		IF(NOT(solucion)) THEN
			WRITELN('No hay posible cambio!')
		ELSE
			exito:=TRUE;	
	END;

	{*** PARTE OPTATIVA. Cambio limitado ***}

	PROCEDURE CambioLimitado(VAR cSolucion:TConjunto; cCandidato:TConjunto; cambio,monedas1,monedas2,monedas3,monedas4:integer; VAR exito:boolean);
	VAR
		e:TElemento;
		solucion:boolean;
		suma,monedas:integer;	
	BEGIN
		CrearConjuntoVacio(cSolucion);
		RellenarConjunto50Limitado(cCandidato,monedas1,monedas2,monedas3,monedas4);
		solucion:=FALSE;
		exito:=FALSE;
		monedas:=0;
		WHILE((NOT(EsConjuntoVacio(cCandidato))) AND NOT(solucion)) DO BEGIN
			Elegir(cCandidato,e);
			WHILE((EsFactible(cSolucion,e,cambio)) AND (Pertenece(cCandidato,e))) DO BEGIN
				Poner(cSolucion,e);
				Quitar(cCandidato,e);
				monedas:=monedas + 1;
			END;
			WRITELN('*',monedas,' monedas de ', e);
			WHILE(Pertenece(cCandidato,e)) DO
				Quitar(cCandidato,e);
			monedas:=0;
			SumarConjunto(cSolucion,suma);
			IF(suma = cambio) THEN
				solucion:=TRUE;
		END;
		IF(NOT(solucion)) THEN
			WRITELN('No hay posible cambio!')
		ELSE
			exito:=TRUE;
	
	END;

END.


