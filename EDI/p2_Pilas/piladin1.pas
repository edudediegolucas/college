{********************************************************************************
*										*
* Módulo: piladin1.pas								*
* Tipo: Programa() Interfaz-Implementación TAD (+) Otros() 			*
* Autor/es: Eduardo de Diego Lucas						*
* Fecha de actualización: 6/10/2010						*
* Descripción: Interfaz e implementacion del TAD pila dinámica			*
*										*
*********************************************************************************}
UNIT PILADIN1;

INTERFACE
	
	USES ELEMTAD;
		
	TYPE
		TPila = ^TNodo;
		TNodo = RECORD
			info:TElemento;
			ant:TPila;
		END;
	
		{METODOS PROPIOS DEL TAD}
		PROCEDURE CrearPilaVacia(VAR pila:TPila);
		FUNCTION EsPilaVacia(pila:TPila):boolean;
		PROCEDURE Apilar(VAR pila:TPila; e:TElemento);
		PROCEDURE Cima(VAR pila:TPila; VAR e:TElemento);
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
	
	PROCEDURE Apilar(VAR pila:TPila; e:TElemento);
	VAR
		aux:TPila;
	BEGIN
		new(aux);
		Asignar(aux^.info,e);
		aux^.ant:=pila;
		pila:=aux;
	END;
	
	PROCEDURE Cima(VAR pila:TPila; VAR e:TElemento);
	BEGIN
		IF NOT EsPilaVacia(pila) THEN BEGIN
			Asignar(e,pila^.info);
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
			WHILE(aux^.ant <> NIL) DO BEGIN
				WRITELN(c, ' => ' , aux^.info);
				c:=c+1;	
				aux:=aux^.ant;
			END;
			WRITELN(c, ' => ' , aux^.info);
		END
		ELSE
			WRITELN('No hay nada que mostrar, la PILA esta vacia!');
		WRITELN;
	END;

END.
