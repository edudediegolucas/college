{********************************************************************************
*										*
* Módulo: arbol.pas								*
* Tipo: Programa() Interfaz-Implementación TAD (+) Otros() 			*
* Autor/es: Eduardo de Diego Lucas						*
* Fecha de actualización: 23/10/2010						*
* Descripción: Interfaz TAD arbol en memoria dinámica				*
*										*
*********************************************************************************}
UNIT ARBOL;

INTERFACE

	USES ELEMTAD;
	
	TYPE
		TArbolBin = ^TNodo;
		TNodo = RECORD
			r:TElemento;
			izq,der:TArbolBin;
		END;
	
	{METODOS PROPIOS DEL TAD}
	PROCEDURE CrearArbolVacio(VAR a:TArbolBin);
	FUNCTION EsArbolVacio(a:TArbolBin):boolean;
	PROCEDURE Insertar(VAR a:TArbolBin; e:TElemento; izq, der :TArbolBin);
	PROCEDURE Raiz(a:TArbolBin; VAR r:TElemento);
	PROCEDURE Izquierdo(a:TArbolBin; VAR izq:TArbolBin);
	PROCEDURE Derecho(a:TArbolBin;VAR der:TArbolBin);

	{METODOS NO PROPIOS DEL TAD}
	PROCEDURE Mostrar(VAR a:TArbolBin);
	
IMPLEMENTATION

	{METODOS PROPIOS DEL TAD}

	PROCEDURE CrearArbolVacio(VAR a:TArbolBin);
	BEGIN
		a:=NIL;
	END;
	
	FUNCTION EsArbolVacio(a:TArbolBin):boolean;
	BEGIN
		EsArbolVacio:=( a = NIL);
	END;
	
	PROCEDURE Insertar(VAR a:TArbolBin; e:TElemento; izq, der :TArbolBin);
	BEGIN
		new(a);
		a^.r:=e;
		a^.izq:=izq;
		a^.der:=der;
	END;
	
	PROCEDURE Raiz(a:TArbolBin; VAR r:TElemento);
	BEGIN
		r:=a^.r;
	END;
	
	PROCEDURE Izquierdo(a:TArbolBin; VAR izq:TArbolBin);
	BEGIN
		izq:=a^.izq;
	END;
	
	PROCEDURE Derecho(a:TArbolBin;VAR der:TArbolBin);
	BEGIN
		der:=a^.der;
	END;
	
	{METODOS NO PROPIOS DEL TAD}

	PROCEDURE Mostrar(VAR a:TArbolBin);
	VAR
		i,d:TArbolBin;
		r:TElemento;
	BEGIN
		Raiz(a,r);
		IF NOT EsArbolVacio(a) THEN BEGIN
			WRITELN('RAIZ [',r,']');
			Izquierdo(a,i);
			Derecho(a,d);
			IF NOT EsArbolVacio(i) THEN BEGIN
				WRITELN('	hijo izq. de ', r); 
				Mostrar(i);
			END;
			IF NOT EsArbolVacio(d) THEN BEGIN
				WRITELN('	hijo der. de ', r);
				Mostrar(d);
			END;
		END;
	END;
END.
