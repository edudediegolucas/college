{********************************************************************************
*										*
* Módulo: colad2h.pas								*
* Tipo: Programa() Interfaz-Implementación TAD (+) Otros()			*
* Autor/es: Eduardo de Diego Lucas						*
* Fecha de actualización: 23/10/2010						*
* Descripción: Interfaz TAD cola puntero cabecera y fin				*
*										*
*********************************************************************************}

UNIT COLAD2H;

INTERFACE

	USES PACIENTE;
	
	TYPE
		TNodoCola = ^TNodo;
		TNodo = RECORD
			p:TPaciente;
			next:TNodoCola;
		END;
		TCola = RECORD
			inicio,fin:TNodoCola;
		END;
		
	{METODOS PROPIOS DEL TAD}
	PROCEDURE CrearColaVacia(VAR c:TCola);
	FUNCTION EsColaVacia(c:TCola):boolean;
	PROCEDURE Insertar(VAR c:TCola; p:TPaciente);
	PROCEDURE PrimeroCola(c:TCola; VAR p:TPaciente);
	FUNCTION IgualCola(c1,c2:TCola):boolean;
	PROCEDURE CopiarCola(c1:TCola;VAR c2:TCola);
	PROCEDURE Eliminar(VAR c:TCola);
	FUNCTION Longitud(c:TCola):integer;

	{METODOS NO PROPIOS DEL TAD}
	PROCEDURE Siguiente(VAR c:TCola);

IMPLEMENTATION
	
	{METODOS PROPIOS DEL TAD}

	PROCEDURE CrearColaVacia(VAR c:TCola);
	BEGIN
		c.inicio:=NIL;
		c.fin:=NIL;
	END;
	
	FUNCTION EsColaVacia(c:TCola):boolean;
	BEGIN
		EsColaVacia:=(c.inicio = NIL);
	END;
	
	PROCEDURE Insertar(VAR c:TCola; p:TPaciente);
	VAR
		aux:TNodoCola;
	BEGIN
		new(aux);
		Asignar(aux^.p,p);
		aux^.next:=NIL;
		IF(EsColaVacia(c)) THEN
			c.inicio:=aux
		ELSE
			c.fin^.next:=aux;
		c.fin:=aux;
	END;

	PROCEDURE PrimeroCola(c:TCola; VAR p:TPaciente);
	BEGIN
		IF(NOT(EsColaVacia(c))) THEN BEGIN
			Asignar(p,c.inicio^.p);
		END
		ELSE
			WRITELN('Cola vacia!');
	END;

	{METODOS NO PROPIOS DEL TAD}

	PROCEDURE Siguiente(VAR c:TCola);
	BEGIN
		c.inicio:=c.inicio^.next;
	END;

	{METODOS PROPIOS DEL TAD}

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
					IF(NOT(PacientesIgual(aux1^.p,aux2^.p))) THEN
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
				Insertar(c2, aux^.p);
				aux:=aux^.next;
				i:=i+1;
			END;
		END;
	END;
	
	PROCEDURE Eliminar(VAR c:TCola);
	VAR
		aux:TNodoCola;
	BEGIN
		IF(NOT(EsColaVacia(c))) THEN BEGIN
			aux:=c.inicio;
			c.inicio:=aux^.next;
			aux^.next:=NIL;
			dispose(aux);
		END
		ELSE
			WRITELN('Cola vacia: nada que eliminar!');
	END;
END.
