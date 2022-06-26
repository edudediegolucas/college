{********************************************************************************
* 										*
* Módulo: mochila.pas 								*
* Tipo: Programa() Interfaz-Implementación TAD (+) Otros()			*
* Autor/es: Eduardo de Diego Lucas						*
* Fecha de actualización: 16/2/2011						*
* Descripción: Interfaz e implementacion de problema del cambio			*
*										*
*********************************************************************************}

UNIT MOCHILA;

INTERFACE

	USES ELEMTAD2,CONJUND2;

	PROCEDURE MochilaValor5(VAR cSolucion:TConjunto; cCandidato:TConjunto; pesomax:integer; VAR exito:boolean);
	PROCEDURE MochilaPeso5(VAR cSolucion:TConjunto; cCandidato:TConjunto; pesomax:integer; VAR exito:boolean);
	PROCEDURE MochilaValorPeso5(VAR cSolucion:TConjunto; cCandidato:TConjunto; pesomax:integer; VAR exito:boolean);
	PROCEDURE MochilaValor3(VAR cSolucion:TConjunto; cCandidato:TConjunto; pesomax:integer; VAR exito:boolean);
	PROCEDURE MochilaPeso3(VAR cSolucion:TConjunto; cCandidato:TConjunto; pesomax:integer; VAR exito:boolean);
	PROCEDURE MochilaValorPeso3(VAR cSolucion:TConjunto; cCandidato:TConjunto; pesomax:integer; VAR exito:boolean);

IMPLEMENTATION

	PROCEDURE RellenarConjunto5(VAR cCandidato:TConjunto); {Restriccion W = 100}
	VAR
		e1,e2,e3,e4,e5:TElemento;	
	BEGIN
		CrearConjuntoVacio(cCandidato);
		CrearElemento(e1,10,20);
		Poner(cCandidato,e1);
		CrearElemento(e2,20,30);
		Poner(cCandidato,e2);
		CrearElemento(e3,30,66);
		Poner(cCandidato,e3);
		CrearElemento(e4,40,40);
		Poner(cCandidato,e4);
		CrearElemento(e5,50,60);
		Poner(cCandidato,e5);
		
	END;

	PROCEDURE RellenarConjunto3(VAR cCandidato:TConjunto); {Restriccion W = 6}
	VAR
		e1,e2,e3:TElemento;	
	BEGIN
		CrearConjuntoVacio(cCandidato);
		CrearElemento(e1,5,11);
		Poner(cCandidato,e1);
		CrearElemento(e2,3,6);
		Poner(cCandidato,e2);
		CrearElemento(e3,3,6);
		Poner(cCandidato,e3);
	END;

	FUNCTION EsFactible(cSolucion:TConjunto;e:TElemento; pesomax:integer):boolean;
	VAR
		suma,diferencia,peso:integer;	
	BEGIN
		EsFactible:=FALSE;
		SumarPeso(cSolucion,suma);
		diferencia:=pesomax-suma;
		DamePeso(e,peso);
		IF(diferencia>=peso) THEN
			EsFactible:=TRUE
		ELSE
			EsFactible:=FALSE;
	END;

	{*** Restriccion W=100 ***}

	PROCEDURE MochilaValor5(VAR cSolucion:TConjunto; cCandidato:TConjunto; pesomax:integer; VAR exito:boolean);
	VAR
		e:TElemento;
		solucion:boolean;
		suma:integer;
	BEGIN
		CrearConjuntoVacio(cSolucion);
		RellenarConjunto5(cCandidato);
		solucion:=FALSE;
		exito:=FALSE;
		WHILE((NOT(EsConjuntoVacio(cCandidato))) AND NOT(solucion)) DO BEGIN
			ElegirMaxValor(cCandidato,e);
			WHILE((EsFactible(cSolucion,e,pesomax)) AND (Pertenece(cCandidato,e))) DO BEGIN
				Poner(cSolucion,e);
				Quitar(cCandidato,e);
			END;
			WHILE(Pertenece(cCandidato,e)) DO
				Quitar(cCandidato,e);
			SumarPeso(cSolucion,suma);
			IF(suma = pesomax) THEN
				solucion:=TRUE;
		END;
		IF(NOT(solucion)) THEN
			WRITELN('No hay posible combinacion!')
		ELSE
			exito:=TRUE;	
	END;

	PROCEDURE MochilaPeso5(VAR cSolucion:TConjunto; cCandidato:TConjunto; pesomax:integer; VAR exito:boolean);
	VAR
		e:TElemento;
		solucion:boolean;
		suma:integer;
	BEGIN
		CrearConjuntoVacio(cSolucion);
		RellenarConjunto5(cCandidato);
		solucion:=FALSE;
		exito:=FALSE;
		WHILE((NOT(EsConjuntoVacio(cCandidato))) AND NOT(solucion)) DO BEGIN
			ElegirMenorPeso(cCandidato,e);
			WHILE((EsFactible(cSolucion,e,pesomax)) AND (Pertenece(cCandidato,e))) DO BEGIN
				Poner(cSolucion,e);
				Quitar(cCandidato,e);
			END;
			WHILE(Pertenece(cCandidato,e)) DO
				Quitar(cCandidato,e);
			SumarPeso(cSolucion,suma);
			IF(suma = pesomax) THEN
				solucion:=TRUE;
		END;
		IF(NOT(solucion)) THEN
			WRITELN('No hay posible combinacion!')
		ELSE
			exito:=TRUE;	
	END;

	PROCEDURE MochilaValorPeso5(VAR cSolucion:TConjunto; cCandidato:TConjunto; pesomax:integer; VAR exito:boolean);
	VAR
		e:TElemento;
		solucion:boolean;
		suma:integer;
	BEGIN
		CrearConjuntoVacio(cSolucion);
		RellenarConjunto5(cCandidato);
		solucion:=FALSE;
		exito:=FALSE;
		WHILE((NOT(EsConjuntoVacio(cCandidato))) AND NOT(solucion)) DO BEGIN
			ElegirMayorValorPorPeso(cCandidato,e);
			WHILE((EsFactible(cSolucion,e,pesomax)) AND (Pertenece(cCandidato,e))) DO BEGIN
				Poner(cSolucion,e);
				Quitar(cCandidato,e);
			END;
			WHILE(Pertenece(cCandidato,e)) DO
				Quitar(cCandidato,e);
			SumarPeso(cSolucion,suma);
			IF(suma = pesomax) THEN
				solucion:=TRUE;
		END;
		IF(NOT(solucion)) THEN
			WRITELN('No hay posible combinacion!')
		ELSE
			exito:=TRUE;	
	END;

	{*** Restriccion W=6 ***}

	PROCEDURE MochilaValor3(VAR cSolucion:TConjunto; cCandidato:TConjunto; pesomax:integer; VAR exito:boolean);
	VAR
		e:TElemento;
		solucion:boolean;
		suma:integer;
	BEGIN
		CrearConjuntoVacio(cSolucion);
		RellenarConjunto3(cCandidato);
		solucion:=FALSE;
		exito:=FALSE;
		WHILE((NOT(EsConjuntoVacio(cCandidato))) AND NOT(solucion)) DO BEGIN
			ElegirMaxValor(cCandidato,e);
			WHILE((EsFactible(cSolucion,e,pesomax)) AND (Pertenece(cCandidato,e))) DO BEGIN
				Poner(cSolucion,e);
				Quitar(cCandidato,e);
			END;
			WHILE(Pertenece(cCandidato,e)) DO
				Quitar(cCandidato,e);
			SumarPeso(cSolucion,suma);
			IF(suma <= pesomax) THEN
				solucion:=TRUE;
		END;
		IF(NOT(solucion)) THEN
			WRITELN('No hay posible combinacion!')
		ELSE
			exito:=TRUE;	
	END;

	PROCEDURE MochilaPeso3(VAR cSolucion:TConjunto; cCandidato:TConjunto; pesomax:integer; VAR exito:boolean);
	VAR
		e:TElemento;
		solucion:boolean;
		suma:integer;
	BEGIN
		CrearConjuntoVacio(cSolucion);
		RellenarConjunto3(cCandidato);
		solucion:=FALSE;
		exito:=FALSE;
		WHILE((NOT(EsConjuntoVacio(cCandidato))) AND NOT(solucion)) DO BEGIN
			ElegirMenorPeso(cCandidato,e);
			WHILE((EsFactible(cSolucion,e,pesomax)) AND (Pertenece(cCandidato,e))) DO BEGIN
				Poner(cSolucion,e);
				Quitar(cCandidato,e);
			END;
			WHILE(Pertenece(cCandidato,e)) DO
				Quitar(cCandidato,e);
			SumarPeso(cSolucion,suma);
			IF(suma = pesomax) THEN
				solucion:=TRUE;
		END;
		IF(NOT(solucion)) THEN
			WRITELN('No hay posible combinacion!')
		ELSE
			exito:=TRUE;	
	END;

	PROCEDURE MochilaValorPeso3(VAR cSolucion:TConjunto; cCandidato:TConjunto; pesomax:integer; VAR exito:boolean);
	VAR
		e:TElemento;
		solucion:boolean;
		suma:integer;
	BEGIN
		CrearConjuntoVacio(cSolucion);
		RellenarConjunto3(cCandidato);
		solucion:=FALSE;
		exito:=FALSE;
		WHILE((NOT(EsConjuntoVacio(cCandidato))) AND NOT(solucion)) DO BEGIN
			ElegirMayorValorPorPeso(cCandidato,e);
			WHILE((EsFactible(cSolucion,e,pesomax)) AND (Pertenece(cCandidato,e))) DO BEGIN
				Poner(cSolucion,e);
				Quitar(cCandidato,e);
			END;
			WHILE(Pertenece(cCandidato,e)) DO
				Quitar(cCandidato,e);
			SumarPeso(cSolucion,suma);
			IF(suma <= pesomax) THEN
				solucion:=TRUE;
		END;
		IF(NOT(solucion)) THEN
			WRITELN('No hay posible combinacion!')
		ELSE
			exito:=TRUE;	
	END;
END.
