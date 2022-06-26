{********************************************************************************
*										*
* Módulo: listadin2.pas								*
* Tipo: Programa() Interfaz-Implementación TAD (+) Otros() 			*
* Autor/es: Eduardo de Diego Lucas						*
* Fecha de actualización: 3/10/2010						*
* Descripción: Interfaz e implementacion del TAD lista dinámica doblemente	*
*		enlazada							*
*										*
*********************************************************************************}
UNIT LISTADIN2;

INTERFACE

	USES ELEMENTO;
	
	TYPE
		TLista = ^TNodoD;
		TNodoD = RECORD
			last:TLista;
			e:TElemento;
			next:TLista;
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
	PROCEDURE BorrarElemento(VAR lista:TLista;e:TElemento);
	PROCEDURE InsertarFinal(VAR lista:TLista;e:TElemento);

	{METODOS NO PROPIOS DEL TAD}
	PROCEDURE Mostrar(lista:TLista);
	
		
IMPLEMENTATION

	{METODOS PROPIOS DEL TAD}

	PROCEDURE CrearVacia(VAR lista:TLista);
	BEGIN
		lista := NIL;
	END;
	
	FUNCTION EsVacia(lista:TLista):boolean;
	BEGIN
		EsVacia:=(lista=NIL);
	END;

	PROCEDURE Construir(VAR lista:TLista;e:TElemento);
	VAR
		aux:TLista;
	BEGIN
		new(aux);
		Asignar(aux^.e,e);
		IF(EsVacia(lista)) THEN BEGIN
			aux^.last:=NIL;
			aux^.next:=NIL;
			lista:=aux;
		END
		ELSE BEGIN
			aux^.next:=lista;
			lista^.last:=aux;
			lista:=aux;
		END;
	END;
	
	PROCEDURE Primero(lista:TLista;VAR e:TElemento);
	VAR
		aux:TLista;
	BEGIN
		aux:=lista;
		IF(NOT(EsVacia(lista))) THEN
			Asignar(e,aux^.e)
		ELSE
			WRITELN('Lista Vacia!');	
	END;
	
	PROCEDURE Resto(VAR lista:TLista);
	VAR
		aux:TLista;
	BEGIN
		aux:=lista;
		IF(NOT(EsVacia(aux))) THEN
			aux:=aux^.next
		ELSE
			WRITELN('No hay lista posible!');
		lista:=aux;
	END;
	
	FUNCTION Longitud(lista:TLista):integer;
	VAR
		c:integer;
		aux:TLista;
	BEGIN
		c:=0;
		aux:=lista;
		WHILE(NOT(EsVacia(aux))) DO BEGIN
			Resto(aux);
			c:=c+1;
		END;
		Longitud:=c;
	END;
	
	PROCEDURE Ultimo(lista:TLista;VAR e:TElemento);
	VAR
		aux:TLista;
	BEGIN
		aux:=lista;
		IF(NOT(EsVacia(lista))) THEN BEGIN
			WHILE(NOT(EsVacia(aux^.next))) DO
				Resto(aux);
			Asignar(e,aux^.e);
		END
		ELSE
			WRITELN('Lista Vacia!');
	END;
	
	FUNCTION Pertenece(lista:TLista;e:TElemento):boolean;
	VAR
		aux:TLista;
		condicion:boolean;
	BEGIN
		aux:=lista;
		condicion:=FALSE;
		WHILE(NOT(EsVacia(aux)) AND NOT(condicion)) DO BEGIN
			IF(Igual(aux^.e, e)) THEN BEGIN
				condicion:=TRUE;
			END;
			Resto(aux);
		END;
		Pertenece:=condicion;
	END;
	
	PROCEDURE Concatenar(lista:TLista;VAR lista2:TLista);
	VAR
		aux:TLista;
	BEGIN		
		IF(NOT(EsVacia(lista))) THEN BEGIN
			aux:=lista;
			WHILE(NOT(EsVacia(aux^.next))) DO
				Resto(aux);
			aux^.next:=lista2;
			lista2^.last:=aux;
			lista2:=lista;
		END;
	END;
	
	PROCEDURE BorrarElemento(VAR lista:TLista;e:TElemento);
	VAR
		aux:TLista;
	BEGIN
		IF(NOT(EsVacia(lista))) THEN BEGIN
			aux:=lista;
			WHILE(NOT(EsVacia(aux))) DO BEGIN
				IF(Igual(aux^.e,e )) THEN BEGIN
					IF(NOT(EsVacia(aux^.last))) THEN
						aux^.last^.next:=aux^.next;
					IF(NOT(EsVacia(aux^.next))) THEN					
						aux^.next^.last:=aux^.last;
					dispose(aux);
				END;
				Resto(aux);
			END;
		END
		ELSE
			WRITELN('Lista Vacia. No se pueden borrar elementos');
	END;
	
	PROCEDURE InsertarFinal(VAR lista:TLista;e:TElemento);
	VAR
		aux,aux2:TLista;
	BEGIN
		new(aux2);
		Asignar(aux2^.e, e);
		aux:=lista;
		WHILE(NOT(EsVacia(aux^.next))) DO
			Resto(aux);
		aux^.next:=aux2;
		aux2^.next:=NIL;
		aux2^.last:=aux;
	END;
	
	{METODOS NO PROPIOS DEL TAD}

	PROCEDURE Mostrar(lista:TLista);
	VAR
		aux:TLista;
		c:integer;
	BEGIN
		c:=1;
		aux:=lista;
		WHILE(NOT(EsVacia(aux))) DO BEGIN
			WRITE('(',c,')->');
			WRITELN(aux^.e);
			Resto(aux);
			WRITELN;
			c:=c+1;
		END;
	END;
	
END.
