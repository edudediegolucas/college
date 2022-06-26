{********************************************************************************
* 										*
* Módulo: calendariodv.pas							*
* Tipo: Programa() Interfaz-Implementación TAD (+) Otros()			*
* Autor/es: Eduardo de Diego Lucas						*
* Fecha de actualización: 25/3/2011						*
* Descripción: Interfaz e implementacion de un algoritmo DyV para un calendario	*
*										*
*********************************************************************************}

UNIT CALENDARIODV;

INTERFACE

	USES TABLA;

	PROCEDURE Calendario(VAR t:TTabla);

IMPLEMENTATION

	PROCEDURE CompletarTabla(VAR t:TTabla; pInf,pSup,sInf,sSup, pInicial:integer);
	VAR
		i,j,l,aux:integer;
	BEGIN
		FOR i:=sInf TO sSup DO BEGIN
			PonerEnTabla(t,pInf,pInicial,i);
			pInicial:=pInicial+1;
		END;
		FOR j:=pInf+1 TO pSup DO BEGIN
			FOR l:=sInf+1 TO sSup DO BEGIN
				DameParticipante(t,j-1,l-1,aux);
				PonerEnTabla(t,j,aux,l);
			END;
			DameParticipante(t,j-1,sSup,aux);
			PonerEnTabla(t,j,aux,sInf);
		END;
	END;

	PROCEDURE FormarTabla(VAR t:TTabla;inf,sup:integer);
	VAR
		mediana,sSup,sInf:integer;	
	BEGIN
		{caso base}
		IF((sup-inf)=1) THEN BEGIN
			PonerEnTabla(t,sup,inf,1);
			PonerEnTabla(t,inf,sup,1);
			WRITELN('***CASO BASE***');
			MostrarTabla(t);
			READLN;
		END
		{caso recursivo}
		ELSE BEGIN
			mediana:=(inf+sup) DIV 2;
			FormarTabla(t,inf,mediana);
			FormarTabla(t,mediana+1,sup);

			sSup:=sup-inf;
			sInf:=(sSup+1) DIV 2;
			
			CompletarTabla(t,inf,mediana,sInf,sSup,mediana+1);
			CompletarTabla(t,mediana+1,sup,sInf,sSup,inf);
			WRITELN('***CASO RECURSIVO***');
			MostrarTabla(t);
			READLN;
		END;
	END;

	PROCEDURE Calendario(VAR t:TTabla);
	BEGIN
		FormarTabla(t,1,PARTICIPANTES);
	END;

END.
