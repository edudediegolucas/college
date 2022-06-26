{********************************************************************************
*										*
* Módulo: colaest.pas 								*
* Tipo: Programa() Interfaz-Implementación TAD (+) Otros() 			*
* Autor/es: Eduardo de Diego Lucas						*
* Fecha de actualización: 7/1/2011						*
* Descripción: Interfaz TAD cola estatica circular				*
*										*
*********************************************************************************}
UNIT COLAEST;

INTERFACE
	
	USES ELEMTAD;
	
	CONST
		N = 50;
		INICIO = 1;
		
	TYPE
		TRango = 1..N;
		TNodo = ARRAY[TRango] OF TElemento;
		TCola = RECORD
			e:TNodo;
			fin:integer;
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
	VAR
		i:integer;	
	BEGIN
		FOR i:=1 TO N DO
			Asignar(c.e[i],-1);
		c.fin:=1;
	END;
	
	FUNCTION EsColaVacia(c:TCola):boolean;
	BEGIN
		EsColaVacia:=(c.fin = 1);
	END;
	
	PROCEDURE Insertar(VAR c:TCola; e:TElemento);	
	BEGIN
		IF(EsColaVacia(c) AND (c.fin<>N+1)) THEN BEGIN
			Asignar(c.e[c.fin],e);
			c.fin:=c.fin+1;
		END
		ELSE 
			WRITELN('Lista llena. No se pueden introducir mas elementos.');
	END;
	
	PROCEDURE PrimeroCola(c:TCola;VAR e:TElemento);
	BEGIN
		Asignar(e,c.e[INICIO]);
	END;

	FUNCTION Longitud(c:TCola):integer;
	BEGIN
		Longitud:=c.fin-1;
	END;
	
	FUNCTION IgualCola(c1,c2:TCola):boolean;
	VAR
		i:integer;
		distinto:boolean;
	BEGIN
		distinto:=FALSE;
		IF(NOT(EsColaVacia(c1)) AND NOT(EsColaVacia(c2))) THEN BEGIN
			IF(Longitud(c1) = Longitud(c2)) THEN BEGIN
				i:=1;
				WHILE((c1.fin<> Longitud(c1))AND (NOT(distinto))) DO BEGIN
					IF(NOT(Igual(c1.e[i],c2.e[i]))) THEN
						distinto:=TRUE
					ELSE BEGIN
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
		i:integer;
	BEGIN
		i:=1;
		IF(NOT(EsColaVacia(c1))) THEN BEGIN
			CrearColaVacia(c2);
			WHILE(i <> Longitud(c1)+1) DO BEGIN
				Insertar(c2, c1.e[i]);
				i:=i+1;
			END;
		END;
	END;

	PROCEDURE Eliminar(VAR c:TCola; e:TElemento);
	VAR
		encontrado:boolean;
		i, j:integer;
	BEGIN
		i:=1;
		encontrado:=FALSE;
		IF(NOT(EsColaVacia(c))) THEN BEGIN
			WHILE((i <> Longitud(c)+1) AND NOT(encontrado)) DO BEGIN
				IF(Igual(c.e[i], e)) THEN BEGIN
					encontrado:=TRUE;
					FOR j:=i TO Longitud(c) DO
						c.e[j]:=c.e[j+1];
					c.fin:=c.fin-1;
					
				END
				ELSE BEGIN
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
		i:integer;
	BEGIN
		i:=1;
		WHILE(i<>c.fin) DO BEGIN
			IF(NOT(Igual(c.e[i], -1))) THEN BEGIN
				WRITE('(',i,')->');
				WRITELN(c.e[i]);
				WRITELN;				
			END;
			i:=i+1;
		END;
	END;

END.
