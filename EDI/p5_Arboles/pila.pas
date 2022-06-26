{********************************************************************************
*										*
* Módulo: pila.pas								*
* Tipo: Programa() Interfaz-Implementación TAD (+) Otros() 			*
* Autor/es: Eduardo de Diego Lucas						*
* Fecha de actualización: 23/10/2010						*
* Descripción: Interfaz e implementacion del TAD pila dinámica para arboles	*
*										*
*********************************************************************************}
UNIT PILA;

INTERFACE
	
	USES ARBOL;
		
	TYPE
		TPila = ^TNodo;
		TNodo = RECORD
			info:TArbolBin;
			ant:TPila;
		END;
	
	{METODOS PROPIOS DEL TAD}
	PROCEDURE CrearPilaVacia(VAR pila:TPila);
	FUNCTION EsPilaVacia(pila:TPila):boolean;
	PROCEDURE Apilar(VAR pila:TPila; e:TArbolBin);
	PROCEDURE Cima(pila:TPila; VAR e:TArbolBin);
	PROCEDURE Desapilar(VAR pila:TPila);
	
	{METODOS NO PROPIOS DEL TAD}
	PROCEDURE Mostrar(pila:TPila);
		
IMPLEMENTATION

	{METODOS PROPIOS DEL TAD}

	PROCEDURE CrearPilaVacia(VAR pila:TPila);
	BEGIN
		pila:=NIL;
	END;
	
	FUNCTION EsPilaVacia(pila:TPila):boolean;
	BEGIN
		EsPilaVacia:=(pila = NIL);
	END;
	
	PROCEDURE Apilar(VAR pila:TPila; e:TArbolBin);
	VAR
		aux:TPila;
	BEGIN
		new(aux);
		aux^.info:=e;
		aux^.ant:=pila;
		pila:=aux;
	END;
	
	PROCEDURE Cima(pila:TPila; VAR e:TArbolBin);
	BEGIN
		IF NOT EsPilaVacia(pila) THEN BEGIN
			e:=pila^.info;
		END
		ELSE
			WRITELN('No hay nada en la cima, la PILA esta vacia!');
	END;
	
	PROCEDURE Desapilar(VAR pila:TPila);
	VAR
		aux:TPila;
	BEGIN
		aux:=pila;
		IF NOT EsPilaVacia(aux) THEN BEGIN
			aux:=aux^.ant;
			pila:=aux;
		END
		ELSE
			WRITELN('No se puede desapilar nada!');
	END;

	{METODOS NO PROPIOS DEL TAD}
	
	PROCEDURE Mostrar(pila:TPila);
	VAR
		aux:TPila;
		c:integer;
	BEGIN
		WRITELN;
		IF NOT(EsPilaVacia(pila)) THEN BEGIN
			c:=1;
			aux:=pila;
			WHILE(NOT(EsPilaVacia(aux))) DO BEGIN
				ARBOL.Mostrar(aux^.info);
				c:=c+1;	
				aux:=aux^.ant;
			END;
		END
		ELSE
			WRITELN('No hay nada que mostrar, la PILA esta vacia!');
		WRITELN;
	END;

END.
