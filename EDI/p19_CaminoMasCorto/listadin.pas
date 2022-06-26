{********************************************************************************
* 										*
* Módulo: listadin.pas 								*
* Tipo: Programa() Interfaz-Implementación TAD (+) Otros()			*
* Autor/es: Eduardo de Diego Lucas						*
* Fecha de actualización: 14/2/2011						*
* Descripción: Interfaz e implementacion del TAD lista dinámica simple		*
*										*
*********************************************************************************}
UNIT LISTADIN;

INTERFACE
	
	USES
		TADSOLUCION;
	
	TYPE
		TLista = ^TNodo;
		TNodo = RECORD
			e:TSolucion;
			next:TLista;
		END;

	{METODOS PROPIOS DEL TAD}
	PROCEDURE CrearVacia(VAR lista:TLista);
	PROCEDURE Construir(VAR lista:TLista;e:TSolucion);
	FUNCTION EsVacia(lista:TLista):boolean;
	PROCEDURE Primero(lista:TLista;VAR e:TSolucion);
	PROCEDURE Resto(VAR lista:TLista);
	FUNCTION Longitud(lista:TLista):integer;
	PROCEDURE Ultimo(lista:TLista;VAR e:TSolucion);
	FUNCTION Pertenece(lista:TLista;e:TSolucion):boolean;
	PROCEDURE Concatenar(lista:TLista;VAR lista2:TLista);
	PROCEDURE BorrarElemento(VAR lista:TLista;e:TSolucion);
	PROCEDURE InsertarFinal(VAR lista:TLista;e:TSolucion);

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

	PROCEDURE Construir(VAR lista:TLista;e:TSolucion);
	VAR
		aux1:TLista;
	BEGIN
		new(aux1);
		CopiarSolucion(aux1^.e,e);
		IF(EsVacia(lista)) THEN BEGIN
			aux1^.next:=NIL;
			lista:=aux1;
		END
		ELSE BEGIN
			aux1^.next:=lista;
			lista:=aux1;
		END;
	END;
	
	PROCEDURE Primero(lista:TLista;VAR e:TSolucion);
	VAR
		aux:TLista;
	BEGIN
		aux:=lista;
		IF(NOT(EsVacia(lista))) THEN
			CopiarSolucion(e,aux^.e)
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
	
	PROCEDURE Ultimo(lista:TLista;VAR e:TSolucion);
	VAR
		aux:TLista;
	BEGIN
		aux:=lista;
		IF(NOT(EsVacia(lista))) THEN BEGIN
			WHILE(NOT(EsVacia(aux^.next))) DO
				Resto(aux);
			CopiarSolucion(e,aux^.e);
		END
		ELSE
			WRITELN('Lista Vacia!');
	END;
	
	FUNCTION Pertenece(lista:TLista;e:TSolucion):boolean;
	VAR
		aux:TLista;
		condicion:boolean;
	BEGIN
		aux:=lista;
		condicion:=FALSE;
		WHILE(NOT(EsVacia(aux)) AND NOT(condicion)) DO BEGIN
			IF(Igual(aux^.e,e)) THEN BEGIN
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
			lista2:=lista;
		END;
	END;
	
	PROCEDURE BorrarElemento(VAR lista:TLista;e:TSolucion);
	VAR
		aux,aux1:TLista;
		condicion:boolean;
	BEGIN
		condicion:=FALSE;
		IF(NOT(EsVacia(lista))) THEN BEGIN
			aux:=lista;
			IF(Igual(aux^.e,e)) THEN BEGIN
				Resto(lista);
				aux:=NIL;
				dispose(aux);
			END
			ELSE BEGIN
				aux1:=aux;
				IF(NOT(EsVacia(aux^.next))) THEN BEGIN
					Resto(aux);				
					WHILE(NOT(EsVacia(aux)) AND NOT(condicion)) DO BEGIN
						IF(Igual(aux^.e,e )) THEN BEGIN
							aux1^.next:=aux^.next;
							aux:=NIL;
							dispose(aux);
							condicion:=TRUE;
						END
						ELSE BEGIN
							aux1:=aux;
							IF(NOT(EsVacia(aux^.next))) THEN
								Resto(aux)
							ELSE 
								condicion:=TRUE;
						END;
					END;
				END;
			END;
		END
		ELSE
			WRITELN('Lista Vacia. No se pueden borrar elementos');
	END;
	
	PROCEDURE InsertarFinal(VAR lista:TLista;e:TSolucion);
	VAR
		aux,aux2:TLista;
	BEGIN
		new(aux2);
		CopiarSolucion(aux2^.e,e);
		aux:=lista;
		WHILE(NOT(EsVacia(aux^.next))) DO
			aux:=aux^.next;
		aux^.next:=aux2;
		aux2^.next:=NIL;
	END;
	
	{METODOS NO PROPIOS DEL TAD}
	
	PROCEDURE Mostrar(lista:TLista);
	VAR
		aux:TLista;
	BEGIN
		aux:=lista;
		WHILE(NOT(EsVacia(aux))) DO BEGIN
			MostrarSolucion(aux^.e);
			Resto(aux);
		END;
	END;
	
END.
