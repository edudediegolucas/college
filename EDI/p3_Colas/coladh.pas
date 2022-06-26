{********************************************************************************
*										*
* Módulo: coladh.pas								*
* Tipo: Programa() Interfaz-Implementación TAD (+) Otros()			*
* Autor/es: Eduardo de Diego Lucas						*
* Fecha de actualización: 23/10/2010						*
* Descripción: Interfaz TAD cola dinamica circular				*
*										*
*********************************************************************************}

UNIT COLADH;

INTERFACE

	USES PACIENTE;
	
	TYPE
		TCola = ^TNodo;
		TNodo = RECORD
			n:integer;
			p:TPaciente;
			next:TCola;
		END;

	{METODOS PROPIOS DEL TAD}
	PROCEDURE CrearColaVacia(VAR c:TCola);
	FUNCTION EsColaVacia(c:TCola):boolean;
	PROCEDURE Insertar(VAR c:TCola; p:TPaciente);
	PROCEDURE PrimeroCola(c:TCola; VAR p:TPaciente);
	FUNCTION IgualCola(c1,c2:TCola):boolean;
	PROCEDURE CopiarCola(c1:TCola;VAR c2:TCola);
	PROCEDURE Eliminar(VAR c:TCola; p:TPaciente);
	FUNCTION Longitud(c:TCola):integer;
	
	{METODOS NO PROPIOS DEL TAD}
	PROCEDURE Mostrar(c:TCola);
	
IMPLEMENTATION

	PROCEDURE CrearColaVacia(VAR c:TCola);
	BEGIN
		c:= NIL;
	END;
	
	FUNCTION EsColaVacia(c:TCola):boolean;
	BEGIN
		EsColaVacia:=(c = NIL);
	END;
	
	PROCEDURE Insertar(VAR c:TCola; p:TPaciente);
	VAR
		aux, aux1:TCola;
	BEGIN
		new(aux);
		Asignar(aux^.p,p);
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
	
	PROCEDURE PrimeroCola(c:TCola; VAR p:TPaciente);
	BEGIN
		IF(NOT(EsColaVacia(c))) THEN BEGIN
			Asignar(p,c^.p);
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
					IF(NOT(PacientesIgual(aux1^.p,aux2^.p))) THEN
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
				Insertar(c2, aux^.p);
				aux:=aux^.next;
				i:=i+1;
			END;
		END;
	END;
	
	PROCEDURE Eliminar(VAR c:TCola);
	VAR
		aux, aux1:TCola;
		i:integer;
	BEGIN
		IF(NOT(EsColaVacia(c))) THEN BEGIN
			aux:=c;
			aux1:=c;
			aux:=aux^.next;
			c:=aux;
			dispose(aux1);
			aux:=c;
			WHILE(aux^.next <> c) DO BEGIN
				aux:=aux^.next;
		END
		ELSE
			WRITELN('Cola vacia: nada que eliminar!');
	END;
	
	PROCEDURE Mostrar(c:TCola);
	VAR
		aux:TCola;
	BEGIN
		IF(NOT(EsColaVacia(c))) THEN BEGIN		
			aux:=c;
			WHILE(aux^.n <> Longitud(c)) DO BEGIN
				WRITE(aux^.n,') ');
				MostrarPaciente(aux^.p);
				aux:=aux^.next;
			END;
		END
		ELSE
			WRITELN('Cola vacia. No hay elementos que mostrar!');
	END;

END.
