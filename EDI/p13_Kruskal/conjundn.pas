{********************************************************************************
*										*
* Módulo: conjundn.pas								*
* Tipo: Programa() Interfaz-Implementación TAD (+) Otros() 			*
* Autor/es: Eduardo de Diego Lucas						*
* Fecha de actualización: 14/2/2011						*
* Descripción: Interfaz TAD conjunto mediante un lista enlazada simple		*
*										*
*********************************************************************************}
UNIT CONJUNDN;
	
INTERFACE
	
	USES TADNODO, LISTADINN;
	
	
	TYPE
		TConjuntoN = TLista;

	{METODOS PROPIOS DEL TAD}
	PROCEDURE CrearConjuntoVacio(VAR c:TConjuntoN);
	PROCEDURE Poner(VAR c:TConjuntoN;e:TNodo);
	FUNCTION EsConjuntoVacio(c:TConjuntoN):boolean;
	FUNCTION Pertenece(c:TConjuntoN;e:TNodo):boolean;
	PROCEDURE Elegir(c:TConjuntoN;VAR e:TNodo);
	FUNCTION Cardinal(c:TConjuntoN):integer;
	PROCEDURE Quitar(VAR c:TConjuntoN;e:TNodo);
	PROCEDURE Union(c1:TConjuntoN;VAR c2:TConjuntoN);
	PROCEDURE Interseccion(c1:TConjuntoN;VAR c2:TConjuntoN);
	PROCEDURE Diferencia(c1:TConjuntoN;VAR c2:TConjuntoN);

	{METODOS NO PROPIOS DEL TAD}
	PROCEDURE Mostrar(c:TConjuntoN);
	
IMPLEMENTATION

	{METODOS PROPIOS DEL TAD}

	PROCEDURE CrearConjuntoVacio(VAR c:TConjuntoN);
	BEGIN
		CrearVacia(c);
	END;
	
	FUNCTION EsConjuntoVacio(c:TConjuntoN):boolean;
	BEGIN
		EsConjuntoVacio:=EsVacia(c);
	END;
	
	PROCEDURE Poner(VAR c:TConjuntoN;e:TNodo);
	BEGIN
		IF(EsConjuntoVacio(c)) THEN BEGIN
			Construir(c, e);
		END
		ELSE BEGIN
			InsertarFinal(c,e);
		END;
	END;
	
	PROCEDURE Elegir(c:TConjuntoN;VAR e:TNodo);
	BEGIN
		Primero(c,e);
	END;
	
	FUNCTION Cardinal(c:TConjuntoN):integer;
	BEGIN
		Cardinal:=Longitud(c);
	END;
	
	FUNCTION Pertenece(c:TConjuntoN; e:TNodo):boolean;
	BEGIN
		Pertenece:=LISTADINN.Pertenece(c,e);
	END;
	
	PROCEDURE Quitar(VAR c:TConjuntoN; e:TNodo);
	BEGIN
		BorrarElemento(c,e);
	END;
	
	PROCEDURE Union(c1:TConjuntoN;VAR c2:TConjuntoN);
	BEGIN
		Concatenar(c1,c2);
	END;
	
	PROCEDURE Interseccion(c1:TConjuntoN;VAR c2:TConjuntoN);
	VAR
		aux:TConjuntoN;
		e:TNodo;
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
	
	PROCEDURE Diferencia(c1:TConjuntoN;VAR c2:TConjuntoN);
	VAR
		aux:TConjuntoN;
		e:TNodo;
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
	
	PROCEDURE Mostrar(c:TConjuntoN);
	BEGIN
		LISTADINN.Mostrar(c);
	END;

END.
