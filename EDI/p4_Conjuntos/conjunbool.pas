{********************************************************************************
*										*
* Módulo: conjunbool.pas							*
* Tipo: Programa() Interfaz-Implementación TAD (+) Otros() 			*
* Autor/es: Eduardo de Diego Lucas						*
* Fecha de actualización: 23/10/2010						*
* Descripción: Interfaz TAD conjunto mediante un array de booleanos		*
*										*
*********************************************************************************}
UNIT CONJUNBOOL;

INTERFACE

	USES ELEMTAD;
	
	CONST
		N = 50;

	TYPE
		TConjunto = ARRAY[1..N] of boolean;
		
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
			c[i]:=FALSE;
	END;
	
	PROCEDURE Poner(VAR c:TConjunto;e:TElemento);
	VAR
		i:TElemento;
	BEGIN
		FOR i:=1 TO N DO
			IF(Igual(i,e)) THEN
				c[i]:=TRUE;
	END;
	
	FUNCTION EsConjuntoVacio(c:TConjunto):boolean;
	VAR
		i:integer;
		lleno:boolean;
	BEGIN
		i:=1;
		lleno:=FALSE;
		WHILE(NOT(lleno) AND (i<> N+1)) DO BEGIN
			IF(c[i] = TRUE) THEN
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
			IF(i = e) THEN
				IF(c[i] = TRUE) THEN
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
			IF(c[i] = TRUE) THEN
				n:=n+1;
		Cardinal:=n;
	END;
	
	PROCEDURE Quitar(VAR c:TConjunto;e:TElemento);
	VAR
		i:integer;
	BEGIN
		i:=1;
		WHILE(i<>e) DO
			i:=i+1;
		c[i]:=FALSE;
	END;
	
	PROCEDURE Union(c1:TConjunto;VAR c2:TConjunto);
	VAR
		i:integer;
	BEGIN
		FOR i:=1 TO N DO
			IF(c1[i] <> c2[i]) THEN
				c2[i]:=TRUE;
	END;
	
	PROCEDURE Interseccion(c1:TConjunto;VAR c2:TConjunto);
	VAR
		i:integer;
	BEGIN
		FOR i:=1 TO N DO
			IF((c1[i] = c2[i]) AND (c1[i] = TRUE)) THEN
				c2[i]:=TRUE;
	END;
	
	PROCEDURE Diferencia(c1:TConjunto;VAR c2:TConjunto);
	VAR
		i:integer;
	BEGIN
		FOR i:=1 TO N DO
			IF((c1[i] = TRUE) AND (c2[i] = FALSE)) THEN
				c2[i]:=TRUE;
	
	END;

	{METODOS NO PROPIOS DEL TAD}
	
	PROCEDURE Mostrar(c:TConjunto);
	VAR
		i:integer;
	BEGIN
		FOR i:=1 TO N DO
			IF(c[i] = TRUE) THEN
				WRITELN('=>[',i,']'); 
	END;
	
END.
	
