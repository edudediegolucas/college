{********************************************************************************
* 										*
* Módulo: tadatos.pas 								*
* Tipo: Programa() Interfaz-Implementación TAD (+) Otros()			*
* Autor/es: Eduardo de Diego Lucas						*
* Fecha de actualización: 4/4/2011						*
* Descripción: Interfaz e implementacion del TAD datos de tareas ejemplo	*
*										*
*********************************************************************************}
UNIT TADATOS;

INTERFACE

	CONST
		N = 4;

	TYPE
		TDatos = ARRAY[1..N,1..N] OF integer;

	PROCEDURE InicializarDatos(VAR datos:TDatos);
	FUNCTION DameDato(datos:TDatos;i,j:integer):integer;
	FUNCTION DameMax(datos:TDatos):integer;
	PROCEDURE CopiarDatos(VAR datos1:TDatos;datos2:TDatos);
	PROCEDURE QuitarDato(VAR datos:TDatos;i:integer);
	PROCEDURE MostrarDatos(datos:TDatos);

IMPLEMENTATION

	PROCEDURE InicializarDatos(VAR datos:TDatos);	
	BEGIN
		datos[1,1]:=11;
		datos[1,2]:=12;
		datos[1,3]:=18;
		datos[1,4]:=40;
		datos[2,1]:=14;
		datos[2,2]:=15;
		datos[2,3]:=13;
		datos[2,4]:=22;
		datos[3,1]:=11;
		datos[3,2]:=17;
		datos[3,3]:=19;
		datos[3,4]:=23;
		datos[4,1]:=17;
		datos[4,2]:=14;
		datos[4,3]:=20;
		datos[4,4]:=28;
	END;

	FUNCTION DameDato(datos:TDatos;i,j:integer):integer;
	BEGIN
		DameDato:=datos[i,j];
	END;

	FUNCTION DameMax(datos:TDatos):integer;
	BEGIN
		DameMax:=N;
	END;

	PROCEDURE CopiarDatos(VAR datos1:TDatos;datos2:TDatos);
	BEGIN
		datos1:=datos2;
	END;
	
	PROCEDURE QuitarDato(VAR datos:TDatos;i:integer);
	VAR
		j:integer;
	BEGIN
		FOR j:=1 TO N DO
			datos[j,i]:=100;
	END;

	PROCEDURE MostrarDatos(datos:TDatos);
	VAR
		i,j:integer;
	BEGIN
		WRITELN('	|1	2	3	4');
		WRITELN('__________________________________');
		FOR i:=1 TO N DO BEGIN
			CASE i OF
				1:WRITE('a	|');
				2:WRITE('b	|');
				3:WRITE('c	|');
				4:WRITE('d	|');
			END;
			FOR j:=1 TO N DO
				IF(j<>N) THEN
					WRITE(datos[i,j],'	')
				ELSE
					WRITELN(datos[i,j]);
		END;
	END;

END.
