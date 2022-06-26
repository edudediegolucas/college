{********************************************************************************
* 										*
* Módulo: tabla.pas								*
* Tipo: Programa() Interfaz-Implementación TAD (+) Otros()			*
* Autor/es: Eduardo de Diego Lucas						*
* Fecha de actualización: 25/3/2011						*
* Descripción: Interfaz e implementacion de un TAD tabla			*
*										*
*********************************************************************************}

UNIT TABLA;

INTERFACE
	
	CONST
		PARTICIPANTES = 8;
		SEMANAS = 7;
	TYPE
		TTabla = ARRAY[1..PARTICIPANTES,1..SEMANAS] OF integer;

	PROCEDURE CrearTablaVacia(VAR t:TTabla);
	PROCEDURE DameParticipante(t:TTabla;participante,semana:integer;VAR p:integer);
	PROCEDURE PonerEnTabla(VAR t:TTabla;participante1,participante2,semana:integer);
	PROCEDURE MostrarTabla(t:TTabla);
	

IMPLEMENTATION

	PROCEDURE CrearTablaVacia(VAR t:TTabla);
	VAR
		i,j:integer;
	BEGIN
		FOR i:=1 TO PARTICIPANTES DO
			FOR j:=1 TO SEMANAS DO
				t[i,j]:=0;
	END;

	PROCEDURE DameParticipante(t:TTabla;participante,semana:integer;VAR p:integer);
	BEGIN
		p:=t[participante,semana];
	END;

	PROCEDURE PonerEnTabla(VAR t:TTabla;participante1,participante2,semana:integer);
	BEGIN
		t[participante1,semana]:=participante2;
	END;	


	PROCEDURE MostrarTabla(t:TTabla);
	VAR
		i,j:integer;
	BEGIN
		WRITELN(' ---------------');
		WRITELN(' |1 2 3 4 5 6 7|');
		WRITELN('----------------');
		FOR i:=1 TO PARTICIPANTES DO BEGIN
			WRITE(i,'|');
			FOR j:=1 TO SEMANAS DO BEGIN
				IF(j<>SEMANAS) THEN
					WRITE(t[i,j],' ')
				ELSE
					WRITELN(t[i,j],'|');
			END;
		END;
		WRITELN('----------------');
	END;
END.
