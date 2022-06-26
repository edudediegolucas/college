{********************************************************************************
*										*
* Módulo: grafo.pas								*
* Tipo: Programa() Interfaz-Implementación TAD (+) Otros() 			*
* Autor/es: Eduardo de Diego Lucas						*
* Fecha de actualización: 13/11/2010						*
* Descripción: Interfaz TAD grafo						*
*										*
*********************************************************************************}

UNIT GRAFO;

INTERFACE

	USES ELEMTAD;
	
	TYPE
		TOrigen= ^TNodoOrigen;
		TDestino = ^TNodoDestino;
		
		TNodoOrigen = RECORD
			c:TCiudad;
			next:TOrigen;
			destino:TDestino;
		END;
		
		TNodoDestino = RECORD
			c:TCiudad;
			d:TDuracion;
			next:TDestino;
			origen:TOrigen;
		END;
		
		TGrafo = TOrigen;
		
		{Metodos propios del TAD}
		PROCEDURE CrearGrafoVacio(VAR g:TGrafo);	
		FUNCTION EsGrafoVacio(g:TGrafo):boolean;
		PROCEDURE InsertarNodo(VAR g:TGrafo; ciudad:TCiudad);
		PROCEDURE InsertarDestino(VAR g:TGrafo; ciudadorigen, ciudaddestino:TCiudad; duracion:TDuracion);
		
		{Metodos no propios del TAD}
		PROCEDURE Mostrar(g:TGrafo);
		
IMPLEMENTATION

	{Metodos propios del TAD}

	PROCEDURE CrearGrafoVacio(VAR g:TGrafo);
	BEGIN
		g:=NIL;
	END;
	
	FUNCTION EsGrafoVacio(g:TGrafo):boolean;
	BEGIN
		EsGrafoVacio:=(g=NIL);
	END;
	
	PROCEDURE InsertarNodo(VAR g:TGrafo; ciudad:TCiudad);
	VAR
		aux:TGrafo;
	BEGIN
		new(aux);
		AsignarCiudad(aux^.c,ciudad);
		aux^.next:=g;
		aux^.destino:=NIL;
		g:=aux;
	END;
	
	PROCEDURE InsertarDestino(VAR g:TGrafo; ciudadorigen, ciudaddestino:TCiudad; duracion:TDuracion);
	VAR
		aux:TGrafo;
		destino:TDestino;
	BEGIN
		aux:=g;
		WHILE(NOT(IgualCiudad(aux^.c,ciudadorigen))) DO
			aux:=aux^.next;
		new(destino);
		AsignarCiudad(destino^.c,ciudaddestino);
		AsignarDuracion(destino^.d,duracion);
		destino^.next:=aux^.destino;
		aux^.destino:=destino;
		
		aux:=g;
		WHILE(NOT(IgualCiudad(aux^.c,ciudaddestino))) DO
			aux:=aux^.next;
		new(destino);
		AsignarCiudad(destino^.c,ciudadorigen);
		AsignarDuracion(destino^.d,duracion);
		destino^.next:=aux^.destino;
		aux^.destino:=destino;
		
	END;

	{Metodos no propios del TAD}
	
	PROCEDURE Mostrar(g:TGrafo);
	VAR
		aux:TGrafo;
		destino:TDestino;
		c:integer;
	BEGIN
		aux:=g;
		c:=0;
		WHILE(NOT(EsGrafoVacio(aux))) DO BEGIN
			IF NOT EsGrafoVacio(aux) THEN BEGIN
				WRITELN('ORIGEN =>', aux^.c);
				destino:=aux^.destino;
				WRITELN('DESTINOS');
				WRITELN('========');
				WHILE(destino<>NIL) DO BEGIN
					c:=c+1;
					WRITELN(c,') ', aux^.c ,' - ', destino^.c ,' => DURACION => ', destino^.d:0:0, ' horas');
					destino:=destino^.next;
				END;
				aux:=aux^.next;
				WRITELN;
			END;
		END;
	END;
END.
