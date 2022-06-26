{********************************************************************************
*										*
* Módulo: tadarista.pas								*
* Tipo: Programa() Interfaz-Implementación TAD (+) Otros() 			*
* Autor/es: Eduardo de Diego Lucas						*
* Fecha de actualización: 19/3/2011						*
* Descripción: Interfaz TAD arista						*
*										*
*********************************************************************************}

UNIT TADARISTA;

INTERFACE
	
	USES TADNODO;
	
	TYPE
		TArista = RECORD
			origen:TNodo;
			destino:TNodo;
			peso:integer;
		END;

	PROCEDURE CrearArista(VAR a:TArista; origen,destino:TNodo; peso:integer);
	PROCEDURE Asignar(VAR a1:TArista;a2:TArista);
	FUNCTION IgualArista(a1,a2:TArista):boolean;	
	PROCEDURE DameNodoOrigen(a:TArista;VAR n:TNodo);
	PROCEDURE DameNodoDestino(a:TArista;VAR n:TNodo);
	PROCEDURE DamePeso(a:TArista;VAR peso:integer);

IMPLEMENTATION

	PROCEDURE CrearArista(VAR a:TArista; origen,destino:TNodo; peso:integer);
	BEGIN
		TADNODO.Asignar(a.origen,origen);
		TADNODO.Asignar(a.destino,destino);
		a.peso:=peso;
	END;

	PROCEDURE Asignar(VAR a1:TArista;a2:TArista);
	BEGIN
		a1:=a2;
	END;
	
	FUNCTION IgualArista(a1,a2:TArista):boolean;
	BEGIN
		IF (((IgualNodo(a1.origen,a2.origen) AND (a1.peso = a2.peso) AND (a1.destino = a2.destino)))
			OR ((IgualNodo(a1.origen,a2.destino) AND (a1.peso = a2.peso) AND (a1.destino = a2.origen)))) THEN
			IgualArista:=TRUE
		ELSE
			IgualArista:=FALSE
	END;

	PROCEDURE DameNodoOrigen(a:TArista;VAR n:TNodo);
	BEGIN
		TADNODO.Asignar(n,a.origen);
	END;

	PROCEDURE DameNodoDestino(a:TArista;VAR n:TNodo);
	BEGIN
		TADNODO.Asignar(n,a.destino);
	END;

	PROCEDURE DamePeso(a:TArista;VAR peso:integer);
	BEGIN
		peso:=a.peso;
	END;
	

END.
