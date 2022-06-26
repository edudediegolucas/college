{********************************************************************************
* 										*
* Módulo: tadsolucion.pas							*
* Tipo: Programa() Interfaz-Implementación TAD (+) Otros()			*
* Autor/es: Eduardo de Diego Lucas						*
* Fecha de actualización: 5/4/2011						*
* Descripción: Interfaz e implementacion del TAD solucion RyP			*
*										*
*********************************************************************************}
UNIT TADSOLUCION;

INTERFACE

	USES LABERINTO;

	TYPE
		TSolucion = RECORD
			coste:integer;
			solucion: TLaberinto;
			x,y:integer;
		END;

	PROCEDURE CrearSolucionVacia(VAR sol:TSolucion;laberinto:TLaberinto);
	PROCEDURE CopiarSolucion(VAR sol1:TSolucion;sol2:TSolucion);
	FUNCTION EstaEnSolucion(sol:TSolucion;i:integer):boolean;
	FUNCTION Igual(sol1,sol2:TSolucion):boolean;
	FUNCTION DameCoste(sol:TSolucion):integer;
	FUNCTION DameX(sol:TSolucion):integer;
	FUNCTION DameY(sol:TSolucion):integer;
	PROCEDURE DameUltimo(sol:TSolucion;VAR valor:integer);
	PROCEDURE DameValor(sol:TSolucion;x,y:integer;VAR valor:integer);
	PROCEDURE ConstruirSolInicial(VAR sol:TSolucion;laberinto:TLaberinto); 
	FUNCTION EsSolucion(sol:TSolucion;laberinto:TLaberinto):boolean;
	FUNCTION EsFactible(sol:TSolucion;x,y:integer;laberinto:TLaberinto):boolean;
	PROCEDURE AsignarSolucion(VAR sol:TSolucion;x,y:integer;valor:integer);
	PROCEDURE DameSiguientePos(laberinto:TLaberinto;tipo,x,y:integer;VAR posx,posy:integer);
	PROCEDURE MostrarSolucion(sol:TSolucion);

IMPLEMENTATION

	PROCEDURE CrearSolucionVacia(VAR sol:TSolucion;laberinto:TLaberinto);
	VAR
		i,j:integer;	
	BEGIN
		FOR i:=1 TO MAX DO BEGIN
			FOR j:=1 TO MAX DO BEGIN
				IF(laberinto[i,j]<>-1) THEN
					sol.solucion[i,j]:=0
				ELSE
					sol.solucion[i,j]:=-1;
			END;
		END;
		sol.coste:=0;
		sol.x:=0;
		sol.y:=0;
	END;

	PROCEDURE CopiarSolucion(VAR sol1:TSolucion;sol2:TSolucion);
	BEGIN
		sol1:=sol2;
	END;

	FUNCTION Igual(sol1,sol2:TSolucion):boolean;
	VAR
		i,j,c:integer;	
	BEGIN
		c:=0;
		IF(sol1.coste = sol2.coste) THEN BEGIN
			FOR i:=1 TO MAX DO
				FOR j:=1 TO MAX DO
					IF(sol1.solucion[i,j] = sol2.solucion[i,j]) THEN
						c:=c+1;
		END;
		Igual:=(c=(MAX*MAX));
	END;

	FUNCTION EstaEnSolucion(sol:TSolucion;i:integer):boolean;
	VAR
		j,k:integer;	
	BEGIN
		EstaEnSolucion:=FALSE;
		FOR j:=1 TO MAX DO
			FOR k:=1 TO MAX DO
				IF(sol.solucion[j,k]=i) THEN
					EstaEnSolucion:=TRUE;
	END;

	PROCEDURE DameUltimo(sol:TSolucion;VAR valor:integer);
	BEGIN
		valor:=sol.solucion[sol.x,sol.y];
	END;

	PROCEDURE DameValor(sol:TSolucion;x,y:integer;VAR valor:integer);
	BEGIN
		valor:=sol.solucion[x,y];
	END;

	FUNCTION EsSolucion(sol:TSolucion;laberinto:TLaberinto):boolean;
	BEGIN
		EsSolucion:=((sol.x = DameMax(laberinto)) AND (sol.y = DameMax(laberinto)));
	END;
	
	FUNCTION EsFactible(sol:TSolucion;x,y:integer;laberinto:TLaberinto):boolean;
	VAR
		valor:integer;
		condicion1,condicion2:boolean;
	BEGIN
		condicion1:=FALSE;
		condicion2:=FALSE;
		DameValor(sol,x,y,valor);
		IF((valor<>-1) AND (valor<>1)) THEN
			condicion1:=TRUE;
		IF((x<1) OR (x>MAX) OR (y<1) OR (y>MAX)) THEN
			condicion2:=TRUE;
		EsFactible:=((condicion1) AND (sol.x <= DameMax(laberinto)) AND NOT(condicion2));
	END;

	FUNCTION DameCoste(sol:TSolucion):integer;
	BEGIN
		DameCoste:=sol.coste;
	END;

	FUNCTION DameX(sol:TSolucion):integer;
	BEGIN
		DameX:=sol.x;
	END;

	FUNCTION DameY(sol:TSolucion):integer;
	BEGIN
		DameY:=sol.y;
	END;

	PROCEDURE DameSiguientePos(laberinto:TLaberinto;tipo,x,y:integer;VAR posx,posy:integer);
	BEGIN
		IF((x=0) AND (y=0)) THEN BEGIN
			posx:=1;
			posy:=1;
		END
		ELSE BEGIN
			CASE tipo OF
				1:BEGIN {NORTE}
					posx:=x-1;
					posy:=y;
				END;
				2:BEGIN {SUR}
					posx:=x+1;
					posy:=y;
				END;
				3:BEGIN {OESTE}
					posx:=x;
					posy:=y-1;
				END;
				4:BEGIN {ESTE}
					posx:=x;
					posy:=y+1;
				END;
			END;
		END;
	END;

	PROCEDURE CalculaCoste(VAR sol:TSolucion); 
	VAR
		i,j,c:integer;	
	BEGIN
		c:=0;
		FOR i:=1 TO MAX DO
			FOR j:=1 TO MAX DO
				IF(sol.solucion[i,j]=1) THEN
					c:=c+1;
		sol.coste:=c;
	END;

	PROCEDURE AsignarSolucion(VAR sol:TSolucion;x,y:integer;valor:integer);
	BEGIN
		sol.solucion[x,y]:=valor;
		CalculaCoste(sol);
		sol.x:=x;
		sol.y:=y;
	END;

	PROCEDURE ConstruirSolInicial(VAR sol:TSolucion;laberinto:TLaberinto); 
	BEGIN
		CrearSolucionVacia(sol,laberinto);
		sol.coste:=100;		
	END;

	PROCEDURE MostrarSolucion(sol:TSolucion);	
	BEGIN
		WRITELN('SOLUCIÓN AL LABERINTO:');
		MostrarLaberinto(sol.solucion);
		WRITELN;
		WRITELN('COSTE => ', sol.coste);
		WRITELN;
	END;

END.
