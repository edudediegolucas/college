{********************************************************************************
*										*
* Módulo: conjune.pas								*
* Tipo: Programa() Interfaz-Implementación TAD (+) Otros()			*
* Autor/es: Eduardo de Diego Lucas						*
* Fecha de actualización: 23/10/2010						*
* Descripción: Interfaz TAD conjunto mediante un array de enteros		*
*										*
*********************************************************************************}
UNIT CONJUNE;

INTERFACE

	USES ELEMTAD;
	
	CONST
		N = 50;

	TYPE
		TConjunto = ARRAY[1..N] of TElemento;
		
	{METODOS PROPIOS DEL TAD}	
	PROCEDURE CrearConjuntoVacio(VAR c:TConjunto);
	PROCEDURE Poner(VAR c:TConjunto;e:TElemento);
	FUNCTION EsConjuntoVacio(c:TConjunto):boolean;
	FUNCTION Pertenece(c:TConjunto;e:TElemento):boolean;
	FUNCTION EsSubconjunto(c1,c2:TConjunto):boolean;
	FUNCTION Cardinal(c:TConjunto):integer;
	PROCEDURE Quitar(VAR c:TConjunto;e:TElemento);
	PROCEDURE Union(c1:TConjunto;VAR c2:TConjunto);
	PROCEDURE Interseccion(c1:TConjunto;VAR c2:TConjunto);
	PROCEDURE Diferencia(c1:TConjunto;VAR c2:TConjunto);

	{METODOS NO PROPIOS DEL TAD}
	PROCEDURE Mostrar(c:TConjunto);
	
IMPLEMENTATION

	{METODOS PROPIOS DEL TAD}

	PROCEDURE CrearConjuntoVacio(VAR c:TConjunto);
	VAR
		i:integer;
	BEGIN
		FOR i:=1 TO N DO
			Asignar(c[i],0);
	END;
	
	PROCEDURE Poner(VAR c:TConjunto;e:TElemento);
	VAR
		i:integer;
	BEGIN
		FOR i:=1 TO N DO
			IF(Igual(i,e)) THEN
				Asignar(c[i],e);
	END;
	
	FUNCTION EsConjuntoVacio(c:TConjunto):boolean;
	VAR
		i:integer;
		lleno:boolean;
	BEGIN
		i:=1;
		lleno:=FALSE;
		WHILE(NOT(lleno) AND (i<> N+1)) DO BEGIN
			IF(c[i] <> 0) THEN
				lleno:=TRUE;
			i:=i+1;
		END;
		EsConjuntoVacio:=NOT(lleno);
	END;
	
	FUNCTION Pertenece(c:TConjunto;e:TElemento):boolean;
	VAR
		i:integer;
		esta:boolean;
	BEGIN
		i:=1;
		esta:=FALSE;
		WHILE(NOT(esta) AND (i<>N+1)) DO BEGIN
			IF(Igual(c[i],e)) THEN
				esta:=TRUE;
			i:=i+1;
		END;
		Pertenece:=esta;
	END;
	
	FUNCTION EsSubconjunto(c1,c2:TConjunto):boolean;
	VAR
		i,j:integer;
	BEGIN
		FOR i:=1 TO N DO
			FOR j:=1 TO N DO
				
	END;
	
	FUNCTION Cardinal(c:TConjunto):integer;
	VAR
		i,n:integer;
	BEGIN
		n:=0;
		FOR i:=1 TO N DO
			IF(NOT(Igual(c[i],0))) THEN
				n:=n+1;
		Cardinal:=n;
	END;
	
	PROCEDURE Quitar(VAR c:TConjunto;e:TElemento);
	VAR
		i:integer;
	BEGIN
		i:=1;
		WHILE(NOT(Igual(i,e))) DO
			i:=i+1;
		Asignar(c[i],0);
	END;
	
	PROCEDURE Union(c1:TConjunto;VAR c2:TConjunto);
	VAR
		i:integer;
	BEGIN
		FOR i:=1 TO N DO
			IF(NOT(Igual(c1[i],c2[i]))) THEN
				Asignar(c2[i],c1[i]);
	END;
	
	PROCEDURE Interseccion(c1:TConjunto;VAR c2:TConjunto);
	VAR
		i:integer;
	BEGIN
		FOR i:=1 TO N DO
			IF((Igual(c1[i],c2[i])) AND (NOT(Igual(c1[i],0)))) THEN
				Asignar(c2[i],c2[i]);
	END;
	
	PROCEDURE Diferencia(c1:TConjunto;VAR c2:TConjunto);
	VAR
		i:integer;
	BEGIN
		FOR i:=1 TO N DO
			IF((Igual(c1[i],0)) AND (Igual(c2[i],0))) THEN
				c2[i]:=c1[i];
	
	END;

	{METODOS NO PROPIOS DEL TAD}
	
	PROCEDURE Mostrar(c:TConjunto);
	VAR
		i:integer;
	BEGIN
		FOR i:=1 TO N DO
			IF(NOT(Igual(c[i],0))) THEN
				WRITELN('=>[',i,']'); 
	END;
	
END.
