{********************************************************************************
* 										*
* Módulo: tadhijos.pas 								*
* Tipo: Programa() Interfaz-Implementación TAD (+) Otros()			*
* Autor/es: Eduardo de Diego Lucas						*
* Fecha de actualización: 5/4/2011						*
* Descripción: Interfaz e implementacion del TAD hijos para RyP			*
*										*
*********************************************************************************}
UNIT TADHIJOS;

INTERFACE

	USES LABERINTO,TADSOLUCION;

	CONST
		N = 10;
	TYPE
		THijos = RECORD
			hijos:ARRAY[1..N] OF TSolucion;
			tope:integer;
		END;

	PROCEDURE Complecciones(sol:TSolucion;VAR h:THijos;laberinto:TLaberinto);
	FUNCTION DameNumHijos(hijos:THijos):integer;
	PROCEDURE DameHijo(hijos:THijos;VAR sol:TSolucion;i:integer);
	
IMPLEMENTATION

	PROCEDURE Complecciones(sol:TSolucion;VAR h:THijos;laberinto:TLaberinto);
	VAR
		i,x,y,valor:integer;	
	BEGIN
		h.tope:=4;
		CopiarSolucion(h.hijos[1],sol);
		CopiarSolucion(h.hijos[2],sol);
		CopiarSolucion(h.hijos[3],sol);
		CopiarSolucion(h.hijos[4],sol);
		FOR i:=1 TO h.tope DO BEGIN
			DameSiguientePos(laberinto,i,DameX(sol),DameY(sol),x,y);
			DameValor(sol,x,y,valor);
			AsignarSolucion(h.hijos[i],x,y,valor);
		END;
	END;

	FUNCTION DameNumHijos(hijos:THijos):integer;
	BEGIN
		DameNumHijos:=hijos.tope;
	END;
	
	PROCEDURE DameHijo(hijos:THijos;VAR sol:TSolucion;i:integer);
	BEGIN
		CopiarSolucion(sol,hijos.hijos[i]);
	END;

END.
