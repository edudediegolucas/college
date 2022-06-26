{********************************************************************************
*										*
* Módulo: tadnodo.pas								*
* Tipo: Programa() Interfaz-Implementación TAD (+) Otros() 			*
* Autor/es: Eduardo de Diego Lucas						*
* Fecha de actualización: 18/2/2011						*
* Descripción: Interfaz TAD nodo, un entero					*
*										*
*********************************************************************************}

UNIT TADNODO;

INTERFACE
	
	TYPE
		TNodo = integer;

	PROCEDURE Asignar(VAR n1:TNodo;n2:TNodo);
	FUNCTION IgualNodo(n1,n2:TNodo):boolean;	
	

IMPLEMENTATION

	FUNCTION IgualNodo(n1,n2:TNodo):boolean;
	BEGIN
		IF (n1 = n2) THEN
			IgualNodo:=TRUE
		ELSE
			IgualNodo:=FALSE
	END;
	
	PROCEDURE Asignar(VAR n1:TNodo;n2:TNodo);
	BEGIN
		n1:=n2;
	END;

END.
