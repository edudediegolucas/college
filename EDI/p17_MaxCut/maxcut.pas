{********************************************************************************
*										*
* Módulo: maxcut.pas								*
* Tipo: Programa() Interfaz-Implementación TAD (+) Otros() 			*
* Autor/es: Eduardo de Diego Lucas						*
* Fecha de actualización: 19/3/2011						*
* Descripción: Interfaz e implementacion algoritmo Max Cut			*
*										*
*********************************************************************************}

UNIT MAXCUT;

INTERFACE

	USES TADNODO,TADARISTA,CONJUNDA,CONJUNDN,GRAFO,TADSOLUCION;

	PROCEDURE InicializarBT(VAR sol1,sol2:TSolucion;VAR nodos:TConjuntoN;VAR aristas:TConjuntoA;g:TGrafo);
	PROCEDURE MaxCutBT(VAR sol,mejorSol:TSolucion;VAR nodos:TConjuntoN;aristas:TConjuntoA);

IMPLEMENTATION

	FUNCTION EsSolucion(s:TSolucion):boolean;
	BEGIN
		EsSolucion:=(DameTamSolucion(s)=N);
	END;

	PROCEDURE InicializarBT(VAR sol1,sol2:TSolucion;VAR nodos:TConjuntoN;VAR aristas:TConjuntoA;g:TGrafo);
	BEGIN
		CrearSolVacia(sol1);
		CrearSolVacia(sol2);
		CONJUNDN.CrearConjuntoVacio(nodos);
		CONJUNDA.CrearConjuntoVacio(aristas);
		DameNodos(g,nodos);
		DameAristas(g,aristas);
	END;

	PROCEDURE MaxCutBT(VAR sol,mejorSol:TSolucion;VAR nodos:TConjuntoN;aristas:TConjuntoA);
	VAR
		nodo:TNodo;
	BEGIN
		IF(EsSolucion(sol)) THEN BEGIN
			IF(EsMejor(sol,mejorSol)) THEN BEGIN
				AsignarSolucion(mejorSol,sol);
			END;
		END	
		ELSE BEGIN
			MostrarSolucion(sol);
			READLN;
			Elegir(nodos,nodo);
			Quitar(nodos,nodo);
			IF(NOT(EstaEnSolucion(sol,nodo))) THEN BEGIN
				PonerSolucion(sol,nodo,'A',aristas);
				MaxCutBT(sol,mejorSol,nodos,aristas);
			END;
			QuitarSolucion(sol,nodo,'A',aristas);
			IF(NOT(EstaEnSolucion(sol,nodo))) THEN BEGIN
				PonerSolucion(sol,nodo,'B',aristas);
				MaxCutBT(sol,mejorSol,nodos,aristas);
			END;
			QuitarSolucion(sol,nodo,'B',aristas);
			CONJUNDN.Poner(nodos,nodo);
		END;
	END;
END.
