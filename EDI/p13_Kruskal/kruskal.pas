{********************************************************************************
* 										*
* Módulo: kruskal.pas 								*
* Tipo: Programa() Interfaz-Implementación TAD (+) Otros()			*
* Autor/es: Eduardo de Diego Lucas						*
* Fecha de actualización: 19/2/2011						*
* Descripción: Interfaz e implementacion del algoritmo de Kruskal		*
*										*
*********************************************************************************}

UNIT KRUSKAL;

INTERFACE

	USES TADNODO, TADARISTA, CONJUNDN,CONJUNDA, GRAFO;

	PROCEDURE AlgoritmoKruskal(g:TGrafo; VAR cSolucion:TConjuntoA; VAR exito:boolean);

IMPLEMENTATION

	PROCEDURE DameAristaMinima(conjuntoAristas:TConjuntoA;nodo:TNodo;VAR arista:TArista;cSolucion:TConjuntoA;VAR error:boolean);
	VAR
		caux:TConjuntoA;
		aux:TArista;
		nodoaux,nodoaux2:TNodo;
		peso1,peso2:integer;
	BEGIN
		CrearArista(arista,0,0,100);
		error:=FALSE;
		CONJUNDA.Asignar(caux,conjuntoAristas);
		WHILE(NOT(CONJUNDA.EsConjuntoVacio(caux))) DO BEGIN
			CONJUNDA.Elegir(caux,aux);
			CONJUNDA.Quitar(caux,aux);
			DameNodoOrigen(aux,nodoaux);
			DameNodoDestino(aux,nodoaux2);
			IF((IgualNodo(nodo,nodoaux)) AND NOT(PerteneceNodo(cSolucion,nodoaux2))) THEN BEGIN
				DamePeso(arista,peso1);
				DamePeso(aux,peso2);
				IF(peso2<peso1) THEN
					TADARISTA.Asignar(arista,aux);
			END;
		END;
		DameNodoOrigen(arista,nodoaux);
		IF(IgualNodo(nodoaux,0)) THEN
			error:=TRUE;
	END;

	PROCEDURE AlgoritmoKruskal(g:TGrafo; VAR cSolucion:TConjuntoA; VAR exito:boolean);
	VAR
		nodo:TNodo;
		arista:TArista;
		conjuntoNodo:TConjuntoN;
		conjuntoArista:TConjuntoA;
		error:boolean;
	BEGIN
		exito:=FALSE;
		error:=FALSE;
		IF(NOT(EsGrafoVacio(g))) THEN BEGIN
			CONJUNDA.CrearConjuntoVacio(cSolucion);
			CONJUNDN.CrearConjuntoVacio(conjuntoNodo);
			CONJUNDA.CrearConjuntoVacio(conjuntoArista);
			DameNodos(g,conjuntoNodo);
			DameAristas(g,conjuntoArista);
			WHILE(NOT(CONJUNDN.EsConjuntoVacio(conjuntoNodo))) DO BEGIN
				CONJUNDN.Elegir(conjuntoNodo,nodo);
				CONJUNDN.Quitar(conjuntoNodo,nodo);
				DameAristaMinima(conjuntoArista,nodo,arista,cSolucion,error);
				IF(NOT(error)) THEN
					CONJUNDA.Poner(cSolucion,arista);
				CONJUNDA.Quitar(conjuntoArista,arista);	
			END;
			IF(CONJUNDN.EsConjuntoVacio(conjuntoNodo)) THEN
				exito:=TRUE;
		END;
	END;

END.
