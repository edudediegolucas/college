{********************************************************************************
* 										*
* Módulo: laberinto.pas 							*
* Tipo: Programa() Interfaz-Implementación TAD (+) Otros()			*
* Autor/es: Eduardo de Diego Lucas						*
* Fecha de actualización: 19/3/2011						*
* Descripción: Interfaz e implementacion de un algoritmo RyP			*
*										*
*********************************************************************************}
UNIT RYP;

INTERFACE
	
	USES LABERINTO,TADSOLUCION,TADHIJOS,LISTADIN;

	PROCEDURE LaberintoRyP(VAR mejorSol:TSolucion;laberinto:TLaberinto);

IMPLEMENTATION

	PROCEDURE LaberintoRyP(VAR mejorSol:TSolucion;laberinto:TLaberinto);
	VAR
		sol:TSolucion;
		prioridad:TLista;
		cota,hijo:integer;
		hijos:THijos;	
	BEGIN
		CrearSolucionVacia(sol,laberinto);
		ConstruirSolInicial(mejorSol,laberinto);
		cota:=DameCoste(mejorSol);
		CrearVacia(prioridad);
		Construir(prioridad,sol);
		WHILE(NOT(EsVacia(prioridad))) DO BEGIN
			Primero(prioridad,sol);
			BorrarElemento(prioridad,sol);
			IF(EsSolucion(sol,laberinto)) THEN BEGIN
				IF(DameCoste(sol)<cota) THEN BEGIN
					CopiarSolucion(mejorSol,sol);
					cota:=DameCoste(sol);
				END;
			END
			ELSE BEGIN
				IF(DameCoste(sol)<cota) THEN BEGIN
					IF((DameX(sol)=0) AND (DameY(sol)=0)) THEN BEGIN
						AsignarSolucion(sol,1,1,1);
						Construir(prioridad,sol);
					END
					ELSE BEGIN
						Complecciones(sol,hijos,laberinto);
						FOR hijo:=1 TO DameNumHijos(hijos) DO BEGIN
							DameHijo(hijos,sol,hijo);
							IF((EsFactible(sol,DameX(sol),DameY(sol),laberinto)) AND (DameCoste(sol)<cota)) THEN BEGIN
								AsignarSolucion(sol,DameX(sol),DameY(sol),1);
								Construir(prioridad,sol);
							END;
						END;
					END;
				END;
			END;
		END;
	END;

END.
