{********************************************************************************
*										*
* Módulo: colad2.pas								*
* Tipo: Programa() Interfaz-Implementación TAD (+) Otros()			*
* Autor/es: Eduardo de Diego Lucas						*
* Fecha de actualización: 23/10/2010						*
* Descripción: Interfaz TAD cola puntero cabecera y fin				*
*										*
*********************************************************************************}

UNIT COLAD2;

INTERFACE

	USES ELEMTAD;
	
	TYPE
		TNodoCola = ^TNodo;
		TNodo = RECORD
			e:TElemento;
			next:TNodoCola;
		END;
		TCola = RECORD
			inicio,fin:TNodoCola;
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
		c.inicio:=NIL;
		c.fin:=NIL;
	END;
	
	FUNCTION EsColaVacia(c:TCola):boolean;
	BEGIN
		EsColaVacia:=((c.inicio = NIL) AND (c.fin = NIL));
	END;
	
	PROCEDURE Insertar(VAR c:TCola; e:TElemento);
	VAR
		aux:TNodoCola;
	BEGIN
		new(aux);
		aux^.e:=e;
		aux^.next:=NIL;
		IF(EsColaVacia(c)) THEN
			c.inicio:=aux
		ELSE
			c.fin^.next:=aux;
		c.fin:=aux;
	END;

	PROCEDURE PrimeroCola(c:TCola; VAR e:TElemento);
	BEGIN
		IF(NOT(EsColaVacia(c))) THEN BEGIN
			Asignar(e,c.inicio^.e);
		END
		ELSE
			WRITELN('Cola vacia!');
	END;

	FUNCTION Longitud(c:TCola):integer;
	VAR
		i:integer;
		aux:TNodoCola;	
	BEGIN
		i:=1;
		IF(NOT(EsColaVacia(c))) THEN BEGIN
			aux:=c.inicio;
			WHILE(aux <> c.fin) DO BEGIN
				aux:=aux^.next;
				i:=i+1;
			END;
			Longitud:= i;
		END
		ELSE
			Longitud:=0;
	END;

	FUNCTION IgualCola(c1,c2:TCola):boolean;
	VAR
		aux1,aux2:TNodoCola;
		distinto:boolean;
		i:integer;
	BEGIN
		i:=1;
		distinto:=FALSE;
		IF(NOT(EsColaVacia(c1)) AND NOT(EsColaVacia(c2))) THEN BEGIN
			IF(Longitud(c1) = Longitud(c2)) THEN BEGIN
				aux1:=c1.inicio;
				aux2:=c2.inicio;
				WHILE((i <> Longitud(c1)+1)AND (NOT(distinto))) DO BEGIN
					IF(NOT(Igual(aux1^.e,aux2^.e))) THEN
						distinto:=TRUE
					ELSE BEGIN
						aux1:=aux1^.next;
						aux2:=aux2^.next;
						i:=i+1;
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
		aux:TNodoCola;
		i:integer;
	BEGIN
		i:=1;
		IF(NOT(EsColaVacia(c1))) THEN BEGIN
			CrearColaVacia(c2);
			aux:=c1.inicio;
			WHILE(i <> Longitud(c1)+1) DO BEGIN
				Insertar(c2, aux^.e);
				aux:=aux^.next;
				i:=i+1;
			END;
		END;
	END;
	
	PROCEDURE Eliminar(VAR c:TCola; e:TElemento);
	VAR
		aux1,aux2:TNodoCola;
		encontrado:boolean;
		i:integer;
	BEGIN
		i:=1;
		encontrado:=FALSE;
		IF(NOT(EsColaVacia(c))) THEN BEGIN
			aux1:=c.inicio;
			aux2:=c.inicio;
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
		aux:TNodoCola;
		i:integer;
	BEGIN
		IF(NOT(EsColaVacia(c))) THEN BEGIN
			i:=1;
			aux:=c.inicio;
			WHILE(NOT(aux<>NIL)) DO BEGIN
				WRITELN(i,')    ', aux^.e);
				i:=i+1;
				aux:=aux^.next;
			END;
		END
		ELSE
			WRITELN('No hay nada que mostrar. La cola esta vacia!');
	END;
END.
