{********************************************************************************
* 										*
* Módulo: tadsolucion.pas							*
* Tipo: Programa() Interfaz-Implementación TAD (+) Otros()			*
* Autor/es: Eduardo de Diego Lucas						*
* Fecha de actualización: 4/4/2011						*
* Descripción: Interfaz e implementacion del TAD solucion RyP			*
*										*
*********************************************************************************}
UNIT TADSOLUCION;

INTERFACE

	USES TADATOS;

	TYPE
		TSolucion = RECORD
			coste:integer;
			solucion: ARRAY[1..N] OF integer;
			max:integer;
		END;

	PROCEDURE CrearSolucionVacia(VAR sol:TSolucion);
	PROCEDURE CopiarSolucion(VAR sol1:TSolucion;sol2:TSolucion);
	FUNCTION EstaEnSolucion(sol:TSolucion;i:integer):boolean;
	FUNCTION Igual(sol1,sol2:TSolucion):boolean;
	FUNCTION DameCoste(sol:TSolucion):integer;
	FUNCTION DameMaxSolucion(sol:TSolucion):integer;
	FUNCTION DameUltimo(sol:TSolucion):integer;
	PROCEDURE AsignarSolucion(VAR sol:TSolucion;i:integer;datos:TDatos);
	FUNCTION EsSolucion(sol:TSolucion;datos:TDatos):boolean;
	FUNCTION EsFactible(sol:TSolucion;datos:TDatos):boolean;
	PROCEDURE ConstruirSolInicial(VAR sol:TSolucion;datos:TDatos);
	PROCEDURE MostrarSolucion(sol:TSolucion);

IMPLEMENTATION

	PROCEDURE CrearSolucionVacia(VAR sol:TSolucion);
	VAR
		i:integer;	
	BEGIN
		FOR i:=1 TO N DO
			sol.solucion[i]:=0;
		sol.coste:=0;
		sol.max:=1;
	END;

	PROCEDURE CopiarSolucion(VAR sol1:TSolucion;sol2:TSolucion);
	BEGIN
		sol1:=sol2;
	END;

	FUNCTION Igual(sol1,sol2:TSolucion):boolean;
	VAR
		i,c:integer;	
	BEGIN
		c:=0;
		IF(sol1.coste = sol2.coste) THEN BEGIN
			FOR i:=1 TO N DO
				IF(sol1.solucion[i] = sol2.solucion[i]) THEN
					c:=c+1;
		END;
		Igual:=(c=N);
	END;

	FUNCTION EstaEnSolucion(sol:TSolucion;i:integer):boolean;
	VAR
		j:integer;	
	BEGIN
		EstaEnSolucion:=FALSE;
		FOR j:=1 TO N DO
			IF(sol.solucion[j]=i) THEN
				EstaEnSolucion:=TRUE;
	END;

	FUNCTION EsSolucion(sol:TSolucion;datos:TDatos):boolean;
	BEGIN
		EsSolucion:=(sol.max > DameMax(datos));
	END;

	FUNCTION EsFactibleVoraz(sol:TSolucion;i:integer;datos:TDatos):boolean;
	BEGIN
		EsFactibleVoraz:=((sol.max <= DameMax(datos)) AND (NOT(EstaEnSolucion(sol,i))));
	END;
	
	FUNCTION EsFactible(sol:TSolucion;datos:TDatos):boolean;
	VAR
		i,j:integer;
		condicion:boolean;	
	BEGIN
		condicion:=TRUE;	
		FOR i:=1 TO N-1 DO
			FOR j:=i+1 TO N DO
				IF((sol.solucion[i]=sol.solucion[j]) AND (sol.solucion[i]<>0) AND (sol.solucion[j]<>0)) THEN
					condicion:=FALSE;
		EsFactible:=((condicion AND (sol.max <= DameMax(datos))) OR (condicion AND (sol.max > DameMax(datos))));				
	END;

	FUNCTION DameCoste(sol:TSolucion):integer;
	BEGIN
		DameCoste:=sol.coste;
	END;

	FUNCTION DameMenorTarea(datos:TDatos;i:integer):integer;
	VAR
		j,menor:integer;
	BEGIN
		menor:=100;
		DameMenorTarea:=0;
		FOR j:=1 TO N DO
			IF(datos[i,j]<menor) THEN BEGIN
				menor:=datos[i,j];
				DameMenorTarea:=j;
			END;
	END;

	FUNCTION DameMaxSolucion(sol:TSolucion):integer; 
	BEGIN
		IF(sol.max<>1) THEN
			DameMaxSolucion:=sol.max-1
		ELSE
			DameMaxSolucion:=sol.max;
	END;

	FUNCTION DameUltimo(sol:TSolucion):integer;
	BEGIN
		DameUltimo:=sol.solucion[sol.max-1];
	END;

	PROCEDURE CalculaCoste(VAR sol:TSolucion;i:integer;datos:TDatos); 
	BEGIN
		sol.coste:=sol.coste + datos[sol.max,i];
	END;

	PROCEDURE AsignarSolucion(VAR sol:TSolucion;i:integer;datos:TDatos);
	BEGIN
		CalculaCoste(sol,i,datos);
		sol.solucion[sol.max]:=i;
		sol.max:=sol.max+1;
	END;

	PROCEDURE ConstruirSolInicial(VAR sol:TSolucion;datos:TDatos); {Algoritmo Voraz}
	VAR
		i,menor:integer;
		datoaux:TDatos;	
	BEGIN
		CrearSolucionVacia(sol);
		CopiarDatos(datoaux,datos);
		FOR i:=1 TO N DO BEGIN
			menor:=DameMenorTarea(datoaux,i);
			IF(EsFactibleVoraz(sol,menor,datoaux)) THEN BEGIN
				AsignarSolucion(sol,menor,datoaux);
				QuitarDato(datoaux,menor);
			END;
		END;			
	END;

	PROCEDURE MostrarSolucion(sol:TSolucion);
	VAR
		i:integer;	
	BEGIN
		WRITELN('TAREAS ASIGNADAS:');
		FOR i:=1 TO N DO BEGIN
			CASE i OF
				1:WRITE('a [', sol.solucion[i] ,']	');
				2:WRITE('b [', sol.solucion[i] ,']	');
				3:WRITE('c [', sol.solucion[i] ,']	');
				4:WRITE('d [', sol.solucion[i] ,']	');
			END;
		END;
		WRITELN;
		WRITELN('COSTE => ', sol.coste);
		WRITELN;
	END;

END.
