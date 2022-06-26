{********************************************************************************
* 										*
* Módulo: tadhijos.pas 								*
* Tipo: Programa() Interfaz-Implementación TAD (+) Otros()			*
* Autor/es: Eduardo de Diego Lucas						*
* Fecha de actualización: 4/4/2011						*
* Descripción: Interfaz e implementacion del TAD hijos para RyP			*
*										*
*********************************************************************************}
UNIT TADHIJOS;

INTERFACE

	USES TADATOS,TADSOLUCION;

	CONST
		MAX = 10;
	TYPE
		THijos = RECORD
			hijos:ARRAY[1..MAX] OF TSolucion;
			tope:integer;
		END;

	PROCEDURE Complecciones(sol:TSolucion;VAR h:THijos;datos:TDatos);
	FUNCTION DameNumHijos(hijos:THijos):integer;
	PROCEDURE DameHijo(hijos:THijos;VAR sol:TSolucion;i:integer);
	PROCEDURE DameValorHijo(hijos:THijos;i:integer;VAR valor:integer);

IMPLEMENTATION

	PROCEDURE Complecciones(sol:TSolucion;VAR h:THijos;datos:TDatos);
	VAR
		j:integer;	
	BEGIN
		h.tope:=4;
		CopiarSolucion(h.hijos[1],sol);
		CopiarSolucion(h.hijos[2],sol);
		CopiarSolucion(h.hijos[3],sol);
		CopiarSolucion(h.hijos[4],sol);
		FOR j:=1 TO N DO BEGIN
			AsignarSolucion(h.hijos[j],j,datos);
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

	PROCEDURE DameValorHijo(hijos:THijos;i:integer;VAR valor:integer);
	BEGIN
		valor:=DameUltimo(hijos.hijos[i]);
	END;

END.
