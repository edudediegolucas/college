{********************************************************************************
*										*
* Módulo: conjund2.pas								*
* Tipo: Programa() Interfaz-Implementación TAD (+) Otros() 			*
* Autor/es: Eduardo de Diego Lucas						*
* Fecha de actualización: 15/2/2011						*
* Descripción: Interfaz TAD conjunto mediante un lista enlazada simple		*
*										*
*********************************************************************************}
UNIT CONJUND2;
	
INTERFACE
	
	USES ELEMTAD2, LISTADIN2;
	
	
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
	PROCEDURE ElegirMaxValor(c:TConjunto;VAR e:TElemento);
	PROCEDURE ElegirMenorPeso(c:TConjunto;VAR e:TElemento);
	PROCEDURE ElegirMayorValorPorPeso(c:TConjunto;VAR e:TElemento);
	PROCEDURE Mostrar(c:TConjunto);
	PROCEDURE SumarValor(c:TConjunto;VAR suma:integer);
	PROCEDURE SumarPeso(c:TConjunto;VAR suma:integer);
	
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

	PROCEDURE ElegirMaxValor(c:TConjunto;VAR e:TElemento);
	VAR
		aux:TConjunto;
		eaux1,eaux2:TElemento;
	BEGIN
		aux:=c;
		CrearElemento(eaux1,0,0);
		WHILE(NOT(EsConjuntoVacio(aux))) DO BEGIN
			Primero(aux,eaux2);
			IF(MayorValor(eaux2,eaux1)) THEN
				Asignar(eaux1,eaux2);
			Quitar(aux,eaux2);
		END;
		Asignar(e,eaux1);
	END;

	PROCEDURE ElegirMenorPeso(c:TConjunto;VAR e:TElemento);
	VAR
		aux:TConjunto;
		eaux1,eaux2:TElemento;
	BEGIN
		aux:=c;
		CrearElemento(eaux1,100,0);
		WHILE(NOT(EsConjuntoVacio(aux))) DO BEGIN
			Primero(aux,eaux2);
			IF(NOT(MayorPeso(eaux2,eaux1))) THEN
				Asignar(eaux1,eaux2);
			Quitar(aux,eaux2);
		END;
		Asignar(e,eaux1);
	END;

	PROCEDURE ElegirMayorValorPorPeso(c:TConjunto;VAR e:TElemento);
	VAR
		aux:TConjunto;
		eaux1,eaux2:TElemento;
	BEGIN
		aux:=c;
		CrearElemento(eaux1,100,0);
		WHILE(NOT(EsConjuntoVacio(aux))) DO BEGIN
			Primero(aux,eaux2);
			IF(MayorValorPorPeso(eaux2,eaux1)) THEN
				Asignar(eaux1,eaux2);
			Quitar(aux,eaux2);
		END;
		Asignar(e,eaux1);
	END;
	
	FUNCTION Cardinal(c:TConjunto):integer;
	BEGIN
		Cardinal:=Longitud(c);
	END;
	
	FUNCTION Pertenece(c:TConjunto; e:TElemento):boolean;
	BEGIN
		Pertenece:=LISTADIN2.Pertenece(c,e);
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
		LISTADIN2.Mostrar(c);
	END;

	PROCEDURE SumarValor(c:TConjunto;VAR suma:integer);
	VAR
		e:TElemento;
		aux:TConjunto;
		valor:integer;
	BEGIN
		suma:=0;
		aux:=c;
		WHILE(NOT(EsConjuntoVacio(aux))) DO BEGIN
			Elegir(aux,e);
			Quitar(aux,e);
			DameValor(e,valor);
			suma:=suma + valor;
		END;
	END;

	PROCEDURE SumarPeso(c:TConjunto;VAR suma:integer);
	VAR
		e:TElemento;
		aux:TConjunto;
		peso:integer;
	BEGIN
		suma:=0;
		aux:=c;
		WHILE(NOT(EsConjuntoVacio(aux))) DO BEGIN
			Elegir(aux,e);
			Quitar(aux,e);
			DamePeso(e,peso);
			suma:=suma + peso;
		END;
	END;

END.
