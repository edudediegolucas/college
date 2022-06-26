{********************************************************************************
*										*
* Módulo: conjund.pas								*
* Tipo: Programa() Interfaz-Implementación TAD (+) Otros() 			*
* Autor/es: Eduardo de Diego Lucas						*
* Fecha de actualización: 14/2/2011						*
* Descripción: Interfaz TAD conjunto mediante un lista enlazada simple		*
*										*
*********************************************************************************}
UNIT CONJUND;
	
INTERFACE
	
	USES ELEMTAD, LISTADIN;
	
	
	TYPE
		TConjunto = TLista;

	{METODOS PROPIOS DEL TAD}
	PROCEDURE CrearConjuntoVacio(VAR c:TConjunto);
	PROCEDURE Poner(VAR c:TConjunto;e:TElemento);
	FUNCTION EsConjuntoVacio(c:TConjunto):boolean;
	FUNCTION Pertenece(c:TConjunto;e:TElemento):boolean;
	PROCEDURE Elegir(c:TConjunto;VAR e:TElemento);
	FUNCTION Cardinal(c:TConjunto):integer;
	PROCEDURE Quitar(VAR c:TConjunto;e:TElemento);
	PROCEDURE Union(c1:TConjunto;VAR c2:TConjunto);
	PROCEDURE Interseccion(c1:TConjunto;VAR c2:TConjunto);
	PROCEDURE Diferencia(c1:TConjunto;VAR c2:TConjunto);

	{METODOS NO PROPIOS DEL TAD}
	PROCEDURE Mostrar(c:TConjunto);
	PROCEDURE SumarConjunto(c:TConjunto;VAR suma:integer);
	
IMPLEMENTATION

	{METODOS PROPIOS DEL TAD}

	PROCEDURE CrearConjuntoVacio(VAR c:TConjunto);
	BEGIN
		CrearVacia(c);
	END;
	
	FUNCTION EsConjuntoVacio(c:TConjunto):boolean;
	BEGIN
		EsConjuntoVacio:=EsVacia(c);
	END;
	
	PROCEDURE Poner(VAR c:TConjunto;e:TElemento);
	BEGIN
		IF(EsConjuntoVacio(c)) THEN BEGIN
			Construir(c, e);
		END
		ELSE BEGIN
			InsertarFinal(c,e);
		END;
	END;
	
	PROCEDURE Elegir(c:TConjunto;VAR e:TElemento);
	BEGIN
		Primero(c,e);
	END;
	
	FUNCTION Cardinal(c:TConjunto):integer;
	BEGIN
		Cardinal:=Longitud(c);
	END;
	
	FUNCTION Pertenece(c:TConjunto; e:TElemento):boolean;
	BEGIN
		Pertenece:=LISTADIN.Pertenece(c,e);
	END;
	
	PROCEDURE Quitar(VAR c:TConjunto; e:TElemento);
	BEGIN
		BorrarElemento(c,e);
	END;
	
	PROCEDURE Union(c1:TConjunto;VAR c2:TConjunto);
	BEGIN
		Concatenar(c1,c2);
	END;
	
	PROCEDURE Interseccion(c1:TConjunto;VAR c2:TConjunto);
	VAR
		aux:TConjunto;
		e:TElemento;
	BEGIN
		aux:=c1;
		IF(EsConjuntoVacio(aux)) THEN
			c2:=c2
		ELSE BEGIN
			WHILE(NOT(EsConjuntoVacio(aux))) DO BEGIN
				Primero(aux,e);
				IF(NOT(Pertenece(c2,e))) THEN
					Quitar(c2, e);
				Resto(aux);
			END;
		END;
	END;
	
	PROCEDURE Diferencia(c1:TConjunto;VAR c2:TConjunto);
	VAR
		aux:TConjunto;
		e:TElemento;
	BEGIN
		aux:=c1;
		IF(EsConjuntoVacio(aux)) THEN
			c2:=c2
		ELSE BEGIN
			WHILE(NOT(EsConjuntoVacio(aux))) DO BEGIN
				Primero(aux,e);
				IF(Pertenece(c2,e)) THEN
					Quitar(c2,e)
				ELSE
					Poner(c2,e);
				Resto(aux);
			END;
		END;
	END;

	{METODOS NO PROPIOS DEL TAD}
	
	PROCEDURE Mostrar(c:TConjunto);
	BEGIN
		LISTADIN.Mostrar(c);
	END;

	PROCEDURE SumarConjunto(c:TConjunto;VAR suma:integer);
	VAR
		e:TElemento;
		aux:TConjunto;	
	BEGIN
		suma:=0;
		aux:=c;
		WHILE(NOT(EsConjuntoVacio(aux))) DO BEGIN
			Elegir(aux,e);
			Quitar(aux,e);
			suma:=suma + e;
		END;
	END;

END.
