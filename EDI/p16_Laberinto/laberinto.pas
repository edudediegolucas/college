{********************************************************************************
* 										*
* Módulo: laberinto.pas 							*
* Tipo: Programa() Interfaz-Implementación TAD (+) Otros()			*
* Autor/es: Eduardo de Diego Lucas						*
* Fecha de actualización: 16/3/2011						*
* Descripción: Interfaz e implementacion de un laberinto			*
*										*
*********************************************************************************}

UNIT LABERINTO;

INTERFACE

	CONST
		MAX = 10;
	
	TYPE	
		TLaberinto = ARRAY[1..MAX,1..MAX] OF integer;
		TPosiciones = ARRAY[1..4] OF integer;

	PROCEDURE CrearLaberintoEjemplo(VAR l:TLaberinto);
	PROCEDURE DameCasilla(l:TLaberinto;x,y:integer;VAR e:integer);
	PROCEDURE PonerCasilla(VAR l:TLaberinto;x,y:integer;e:integer);
	PROCEDURE QuitarCasilla(VAR l:TLaberinto;x,y:integer);
	PROCEDURE MostrarLaberinto(l:TLaberinto);

IMPLEMENTATION

	PROCEDURE CrearLaberintoEjemplo(VAR l:TLaberinto);
	VAR
		i,j:integer;	
	BEGIN
		FOR i:=1 TO MAX DO
			FOR j:=1 TO MAX DO
				l[i,j]:=0;
		l[1,3]:=-1;
		l[1,8]:=-1;
		l[2,1]:=-1;
		l[2,3]:=-1;
		l[2,6]:=-1;
		l[2,7]:=-1;
		l[2,9]:=-1;
		l[3,7]:=-1;
		l[3,9]:=-1;
		l[4,2]:=-1;
		l[4,5]:=-1;
		l[4,6]:=-1;
		l[4,7]:=-1;
		l[5,3]:=-1;
		l[5,4]:=-1;
		l[5,8]:=-1;
		l[6,6]:=-1;
		l[6,8]:=-1;
		l[7,1]:=-1;
		l[7,4]:=-1;
		l[7,5]:=-1;
		l[7,8]:=-1;
		l[7,10]:=-1;
		l[8,2]:=-1;
		l[8,3]:=-1;
		l[8,9]:=-1;
		l[8,10]:=-1;
		l[9,6]:=-1;
		l[9,8]:=-1;
		l[9,9]:=-1;
		l[10,3]:=-1;
		l[10,5]:=-1;
		l[10,6]:=-1;
	END;

	PROCEDURE DameCasilla(l:TLaberinto;x,y:integer;VAR e:integer);
	BEGIN
		e:=l[x,y];
	END;

	PROCEDURE PonerCasilla(VAR l:TLaberinto;x,y:integer;e:integer);
	BEGIN
		l[x,y]:=e;
	END;

	PROCEDURE QuitarCasilla(VAR l:TLaberinto;x,y:integer);
	BEGIN
		l[x,y]:=0;
	END;

	PROCEDURE MostrarLaberinto(l:TLaberinto);
	VAR
		i,j:integer;	
	BEGIN
		WRITELN('_____________________');
		FOR i:=1 TO MAX DO BEGIN
			FOR j:=1 TO MAX DO BEGIN
				IF(j=1) THEN
					WRITE('|');
				IF(l[i,j]=0) THEN
					WRITE('  ')
				ELSE BEGIN
					IF(l[i,j] =-1) THEN
						WRITE('██')
					ELSE
						{WRITE(l[i,j]);}WRITE(' *');
				END;
				IF(j=MAX) THEN
					WRITELN('|');
			END;
		END;
		WRITELN('_____________________');
	END;
END.
