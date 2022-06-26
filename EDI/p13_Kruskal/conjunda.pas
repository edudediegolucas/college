{********************************************************************************
*										*
* Módulo: conjunda.pas								*
* Tipo: Programa() Interfaz-Implementación TAD (+) Otros() 			*
* Autor/es: Eduardo de Diego Lucas						*
* Fecha de actualización: 14/2/2011						*
* Descripción: Interfaz TAD conjunto mediante un lista enlazada simple		*
*										*
*********************************************************************************}
UNIT CONJUNDA;
	
INTERFACE
	
	USES TADARISTA, TADNODO, LISTADINA;
	
	
	TYPE
		TConjuntoA = TLista;

	{METODOS PROPIOS DEL TAD}
	PROCEDURE CrearConjuntoVacio(VAR c:TConjuntoA);
	PROCEDURE Poner(VAR c:TConjuntoA;e:TArista);
	FUNCTION EsConjuntoVacio(c:TConjuntoA):boolean;
	FUNCTION Pertenece(c:TConjuntoA;e:TArista):boolean;
	PROCEDURE Elegir(c:TConjuntoA;VAR e:TArista);
	FUNCTION Cardinal(c:TConjuntoA):integer;
	PROCEDURE Quitar(VAR c:TConjuntoA;e:TArista);
	PROCEDURE Union(c1:TConjuntoA;VAR c2:TConjuntoA);
	PROCEDURE Interseccion(c1:TConjuntoA;VAR c2:TConjuntoA);
	PROCEDURE Diferencia(c1:TConjuntoA;VAR c2:TConjuntoA);

	{METODOS NO PROPIOS DEL TAD}
	PROCEDURE Mostrar(c:TConjuntoA);
	FUNCTION PerteneceNodo(c:TConjuntoA; nodo:TNodo):boolean;
	PROCEDURE Asignar(VAR c1:TConjuntoA;c2:TConjuntoA);
	
IMPLEMENTATION

	{METODOS PROPIOS DEL TAD}

	PROCEDURE CrearConjuntoVacio(VAR c:TConjuntoA);
	BEGIN
		CrearVacia(c);
	END;
	
	FUNCTION EsConjuntoVacio(c:TConjuntoA):boolean;
	BEGIN
		EsConjuntoVacio:=EsVacia(c);
	END;

	FUNCTION Pertenece(c:TConjuntoA; e:TArista):boolean;
	BEGIN
		Pertenece:=LISTADINA.Pertenece(c,e);
	END;
	
	PROCEDURE Poner(VAR c:TConjuntoA;e:TArista);
	BEGIN
		IF(EsConjuntoVacio(c)) THEN BEGIN
			Construir(c, e);
		END
		ELSE BEGIN
			IF(NOT(Pertenece(c,e))) THEN
				InsertarFinal(c,e);
		END;
	END;
	
	PROCEDURE Elegir(c:TConjuntoA;VAR e:TArista);
	BEGIN
		Primero(c,e);
	END;
	
	FUNCTION Cardinal(c:TConjuntoA):integer;
	BEGIN
		Cardinal:=Longitud(c);
	END;
	
	
	PROCEDURE Quitar(VAR c:TConjuntoA; e:TArista);
	BEGIN
		BorrarElemento(c,e);
	END;
	
	PROCEDURE Union(c1:TConjuntoA;VAR c2:TConjuntoA);
	BEGIN
		Concatenar(c1,c2);
	END;
	
	PROCEDURE Interseccion(c1:TConjuntoA;VAR c2:TConjuntoA);
	VAR
		aux:TConjuntoA;
		e:TArista;
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
	
	PROCEDURE Diferencia(c1:TConjuntoA;VAR c2:TConjuntoA);
	VAR
		aux:TConjuntoA;
		e:TArista;
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
	
	PROCEDURE Mostrar(c:TConjuntoA);
	BEGIN
		LISTADINA.Mostrar(c);
	END;

	FUNCTION PerteneceNodo(c:TConjuntoA; nodo:TNodo):boolean;
	VAR
		aux:TConjuntoA;
		a:TArista;
		n:TNodo;
		condicion:boolean;	
	BEGIN
		aux:=c;
		condicion:=FALSE;
		WHILE(NOT(EsConjuntoVacio(aux))) DO BEGIN
			Elegir(aux,a);
			Quitar(aux,a);
			DameNodoOrigen(a,n);
			IF(IgualNodo(nodo,n)) THEN
				condicion:=TRUE;
		END;
		PerteneceNodo:=condicion;
	END;

	PROCEDURE Asignar(VAR c1:TConjuntoA;c2:TConjuntoA);
	BEGIN
		c1:=c2;
	END;

END.
