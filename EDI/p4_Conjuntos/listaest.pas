{********************************************************************************
*										*
* Módulo: listaest.pas 								*
* Tipo: Programa() Interfaz-Implementación TAD (+) Otros() 			*
* Autor/es: Eduardo de Diego Lucas						*
* Fecha de actualización: 3/10/2010						*
* Descripción: Interfaz e implementacion del TAD lista estática			*
*										*
*********************************************************************************}
UNIT LISTAEST;

INTERFACE
	
	USES ELEMTAD;
	
	CONST
		N = 50;
		INICIO = 1;
		
	TYPE
		TRango = 1..N;
		TNodo = ARRAY[TRango] OF TElemento;
		TLista = RECORD
			e:TNodo;
			fin:integer;
		END;

	{METODOS PROPIOS DEL TAD}
	PROCEDURE CrearVacia(VAR lista:TLista);
	PROCEDURE Construir(VAR lista:TLista;e:TElemento);
	FUNCTION EsVacia(lista:TLista):boolean;
	PROCEDURE Primero(lista:TLista;VAR e:TElemento);
	PROCEDURE Resto(VAR lista:TLista);
	FUNCTION Longitud(lista:TLista):integer;
	PROCEDURE Ultimo(lista:TLista;VAR e:TElemento);
	FUNCTION Pertenece(lista:TLista;e:TElemento):boolean;
	PROCEDURE Concatenar(lista:TLista;VAR lista2:TLista);
	PROCEDURE InsertarFinal(VAR lista:TLista;e:TElemento);
	PROCEDURE BorrarElemento(VAR lista:TLista;e:TElemento);
	
	{METODOS NO PROPIOS DEL TAD}
	PROCEDURE Mostrar(lista:TLista);
	
IMPLEMENTATION

	PROCEDURE CrearVacia(VAR lista:TLista);
	VAR
		i:integer;	
	BEGIN
		FOR i:=1 TO N DO
			Asignar(lista.e[i],-1);
		lista.fin:=1;
	END;
	
	FUNCTION EsVacia(lista:TLista):boolean;
	BEGIN
		EsVacia:=(lista.fin = 1);
	END;
	
	PROCEDURE Construir(VAR lista:TLista;e:TElemento);
	VAR
		i:integer;
		aux:TLista;	
	BEGIN
		IF(EsVacia(lista)) THEN BEGIN
			Asignar(lista.e[lista.fin],e);
			lista.fin:=lista.fin+1;
		END
		ELSE BEGIN
			IF(lista.fin<>N+1) THEN BEGIN
				aux:=lista;
				FOR i:=1 TO N DO
					Asignar(lista.e[i+1],aux.e[i]);
				Asignar(lista.e[INICIO],e);
				lista.fin:=lista.fin+1;
			END
			ELSE
				WRITELN('Lista llena. No se pueden introducir mas elementos.');
		END;
	END;
	
	PROCEDURE Primero(lista:TLista;VAR e:TElemento);
	BEGIN
		Asignar(e,lista.e[INICIO]);
	END;
	
	PROCEDURE Resto(VAR lista:TLista);
	VAR
		aux:TLista;
		i:integer;
	BEGIN
		aux:=lista;
		FOR i:=1 TO N DO
			Asignar(aux.e[i], lista.e[i+1]);
		lista:=aux;
		lista.fin:=lista.fin-1;
	END;
	
	FUNCTION Longitud(lista:TLista):integer;
	BEGIN
		Longitud:=lista.fin-1;
	END;
	
	PROCEDURE Ultimo(lista:TLista;VAR e:TElemento);
	BEGIN
		Asignar(e,lista.e[lista.fin-1]);
	END;
	
	FUNCTION Pertenece(lista:TLista;e:TElemento):boolean;
	VAR
		i:integer;
		condicion:boolean;
	BEGIN
		i:=1;
		condicion:=FALSE;
		WHILE((i<>N) AND (NOT(condicion)))DO BEGIN
			IF(Igual(lista.e[i], e)) THEN
				condicion:=TRUE;
			i:=i+1;
		END;
		Pertenece:=condicion;
	END;
	
	PROCEDURE Concatenar(lista:TLista;VAR lista2:TLista);
	VAR
		e:TElemento;
	BEGIN
		IF(EsVacia(lista2)) THEN
			lista2:=lista
		ELSE
			IF(NOT(EsVacia(lista))) THEN BEGIN
				Primero(lista,e);
				InsertarFinal(lista2,e);
				Resto(lista);
				Concatenar(lista,lista2);
			END;
	END;
	
	PROCEDURE InsertarFinal(VAR lista:TLista;e:TElemento);
	BEGIN
		IF(lista.fin<>N+1) THEN BEGIN
			Asignar(lista.e[lista.fin],e);
			lista.fin:=lista.fin+1;
		END
		ELSE
			WRITELN('Lista llena. No se pueden introducir mas elementos.');
	END;
	
	PROCEDURE BorrarElemento(VAR lista:TLista;e:TElemento);
	VAR
		i,j:integer;	
	BEGIN
		FOR i:=1 TO N DO
			IF(Igual(lista.e[i], e)) THEN BEGIN
				Asignar(lista.e[i],-1);
				FOR j:=i TO N DO
					Asignar(lista.e[j],lista.e[j+1]);
				lista.fin:=lista.fin-1;
			END;
	END;
	
	PROCEDURE Mostrar(lista:TLista);
	VAR
		i:integer;
	BEGIN
		i:=1;
		WHILE(i<>N) DO BEGIN
			IF(NOT(Igual(lista.e[i], -1))) THEN BEGIN
				WRITE('(',i,')->');
				WRITELN(lista.e[i]);
				WRITELN;				
			END;
			i:=i+1;
		END;
	END;

END.
