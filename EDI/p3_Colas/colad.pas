{********************************************************************************
*										*
* Módulo: colad.pas								*
* Tipo: Programa() Interfaz-Implementación TAD (+) Otros()			*
* Autor/es: Eduardo de Diego Lucas						*
* Fecha de actualización: 23/10/2010						*
* Descripción: Interfaz TAD cola dinamica circular				*
*										*
*********************************************************************************}

UNIT COLAD;

INTERFACE

	USES ELEMTAD;
	
	TYPE
		TCola = ^TNodo;
		TNodo = RECORD
			n:integer;
			e:TElemento;
			next:TCola;
		END;

	{METODOS PROPIOS DEL TAD}
	PROCEDURE CrearColaVacia(VAR c:TCola);
	FUNCTION EsColaVacia(c:TCola):boolean;
	PROCEDURE Insertar(VAR c:TCola; e:TElemento);
	PROCEDURE PrimeroCola(c:TCola; VAR e:TElemento);
	FUNCTION IgualCola(c1,c2:TCola):boolean;
	PROCEDURE CopiarCola(c1:TCola;VAR c2:TCola);
	PROCEDURE Eliminar(VAR c:TCola; e:TElemento);
	FUNCTION Longitud(c:TCola):integer;
	
	{METODOS NO PROPIOS DEL TAD}
	PROCEDURE Mostrar(c:TCola);
	
IMPLEMENTATION

	{METODOS PROPIOS DEL TAD}

	PROCEDURE CrearColaVacia(VAR c:TCola);
	BEGIN
		c:= NIL;
	END;
	
	FUNCTION EsColaVacia(c:TCola):boolean;
	BEGIN
		EsColaVacia:=(c = NIL);
	END;
	
	PROCEDURE Insertar(VAR c:TCola; e:TElemento);
	VAR
		aux, aux1:TCola;
	BEGIN
		new(aux);
		Asignar(aux^.e,e);
		IF(EsColaVacia(c)) THEN BEGIN
			aux^.next:=aux;						
			aux^.n:=1;
			c:= aux;
		END
		ELSE BEGIN
			aux1:=c;
			WHILE(NOT(aux1^.next^.n = 1)) DO
				aux1:=aux1^.next;
			aux1^.next:=aux;			
			aux^.n:=aux1^.n + 1;
			aux^.next:=c;
		END;
	END;
	
	PROCEDURE PrimeroCola(c:TCola; VAR e:integer);
	BEGIN
		IF(NOT(EsColaVacia(c))) THEN BEGIN
			Asignar(e,c^.e);
		END
		ELSE
			WRITELN('Cola vacia!');
	END;
	
	FUNCTION Longitud(c:TCola):integer;
	VAR
		aux:TCola;	
	BEGIN
		IF(NOT(EsColaVacia(c))) THEN BEGIN
			aux:=c;
			WHILE(NOT(aux^.next^.n = 1)) DO
				aux:=aux^.next;
			Longitud:= aux^.n;
		END
		ELSE
			Longitud:=0;
	END;
	
	FUNCTION IgualCola(c1,c2:TCola):boolean;
	VAR
		aux1,aux2:TCola;
		distinto:boolean;
	BEGIN
		distinto:=FALSE;
		IF(NOT(EsColaVacia(c1)) AND NOT(EsColaVacia(c2))) THEN BEGIN
			IF(Longitud(c1) = Longitud(c2)) THEN BEGIN
				aux1:=c1;
				aux2:=c2;
				WHILE((aux1^.n <> Longitud(c1)+1)AND (NOT(distinto))) DO BEGIN
					IF(NOT(Igual(aux1^.e,aux2^.e))) THEN
						distinto:=TRUE
					ELSE BEGIN
						aux1:=aux1^.next;
						aux2:=aux2^.next;
					END;
				END;
			END
			ELSE
				distinto:=TRUE;
			
		END
		ELSE
			distinto:=FALSE;
		IgualCola:=NOT(distinto);
	END;
	
	PROCEDURE CopiarCola(c1:TCola;VAR c2:TCola);
	VAR
		aux:TCola;
		i:integer;
	BEGIN
		i:=0;
		IF(NOT(EsColaVacia(c1))) THEN BEGIN
			CrearColaVacia(c2);
			aux:=c1;
			WHILE(i <> Longitud(c1)+1) DO BEGIN
				Insertar(c2, aux^.e);
				aux:=aux^.next;
				i:=i+1;
			END;
		END;
	END;
	
	PROCEDURE Eliminar(VAR c:TCola; e:TElemento);
	VAR
		aux1,aux2:TCola;
		encontrado:boolean;
		i:integer;
	BEGIN
		i:=0;
		encontrado:=FALSE;
		IF(NOT(EsColaVacia(c))) THEN BEGIN
			aux1:=c;
			aux2:=c;
			WHILE((i <> Longitud(c)+1) AND NOT(encontrado)) DO BEGIN
				IF(i<>0) THEN
					aux2:=aux2^.next;
				IF(Igual(aux1^.e, e)) THEN BEGIN
					encontrado:=TRUE;
					aux2^.next:=aux1^.next;
					dispose(aux1);
					aux1:=NIL;
				END
				ELSE BEGIN
					aux1:=aux1^.next;
					i:=i+1;
				END;
			END;
		END
		ELSE
			WRITELN('Cola vacia: nada que eliminar!');
	END;

	{METODOS NO PROPIOS DEL TAD}
	
	PROCEDURE Mostrar(c:TCola);
	VAR
		aux:TCola;
	BEGIN
		IF(NOT(EsColaVacia(c))) THEN BEGIN		
			aux:=c;
			WHILE(aux^.n <> Longitud(c)) DO BEGIN
				WRITELN(aux^.n,') ', aux^.e);
				aux:=aux^.next;
			END;
		END
		ELSE
			WRITELN('Cola vacia. No hay elementos que mostrar!');
	END;

END.
