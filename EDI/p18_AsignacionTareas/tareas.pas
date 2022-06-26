{********************************************************************************
* 										*
* Módulo: tareas.pas 								*
* Tipo: Programa() Interfaz-Implementación TAD (+) Otros()			*
* Autor/es: Eduardo de Diego Lucas						*
* Fecha de actualización: 4/4/2011						*
* Descripción: Interfaz e implementacion del algoritmo RyP para tareas		*
*										*
*********************************************************************************}
UNIT TAREAS;

INTERFACE

	USES TADATOS,TADSOLUCION,LISTADIN,TADHIJOS;

	PROCEDURE AsignacionTareasRyP(VAR mejorSol:TSolucion;datos:TDatos);

IMPLEMENTATION

	PROCEDURE AsignacionTareasRyP(VAR mejorSol:TSolucion;datos:TDatos);
	VAR
		sol:TSolucion;
		prioridad:TLista;
		cota,hijo,valor:integer;
		hijos:THijos;	
	BEGIN
		CrearSolucionVacia(sol);
		ConstruirSolInicial(mejorSol,datos);
		cota:=DameCoste(mejorSol);
		CrearVacia(prioridad);
		Construir(prioridad,sol);
		WHILE(NOT(EsVacia(prioridad))) DO BEGIN
			Primero(prioridad,sol);
			BorrarElemento(prioridad,sol);
			IF(EsSolucion(sol,datos)) THEN BEGIN
				IF(DameCoste(sol)<cota) THEN BEGIN
					CopiarSolucion(mejorSol,sol);
					cota:=DameCoste(sol);
				END;
			END
			ELSE BEGIN
				IF(DameCoste(sol)<cota) THEN BEGIN
					Complecciones(sol,hijos,datos);
					FOR hijo:=1 TO DameNumHijos(hijos) DO BEGIN
						DameHijo(hijos,sol,hijo);
						DameValorHijo(hijos,hijo,valor); {se puede quitar...}
						IF((EsFactible(sol,datos)) AND (DameCoste(sol)<cota)) THEN 								Construir(prioridad,sol);
					END;
				END;
			END;
		END;
	END;

END.
