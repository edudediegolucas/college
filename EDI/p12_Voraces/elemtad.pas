{********************************************************************************
*										*
* Módulo: elemtad.pas								*
* Tipo: Programa() Interfaz-Implementación TAD (+) Otros() 			*
* Autor/es: Eduardo de Diego Lucas						*
* Fecha de actualización: 14/2/2011						*
* Descripción: Interfaz TAD elemento, es un entero				*
*										*
*********************************************************************************}

UNIT ELEMTAD;

INTERFACE
	
	TYPE
		TElemento = integer;
	
	FUNCTION Igual(e1,e2:TElemento):boolean;
	PROCEDURE Asignar(VAR e1:TElemento;e2:TElemento);

IMPLEMENTATION
	
	FUNCTION Igual(e1,e2:TElemento):boolean;
	BEGIN
		IF (e1 = e2) THEN
			Igual:=TRUE
		ELSE
			Igual:=FALSE
	END;

	PROCEDURE Asignar(VAR e1:TElemento;e2:TElemento);
	BEGIN
		e1:=e2;
	END;

END.
