{********************************************************************************
*										*
* Módulo: criba.pas								*
* Tipo: Programa(+) Interfaz-Implementación TAD () Otros()			*
* Autor/es: Eduardo de Diego Lucas						*
* Fecha de actualización: 23/10/2010						*
* Descripción: Programa principal criba de Eratóstones				*
*										*
*********************************************************************************}
PROGRAM CRIBA;

	USES CONJUND; {CONJUNBOOL, CONJUNE, CONJUND}
	
	PROCEDURE CribaEratostones(VAR c:TConjunto;limite:integer);
	VAR
		i,j:integer;
	BEGIN
		CrearConjuntoVacio(c);
		FOR i:=2 TO limite DO
			Poner(c,i);
		WRITELN('Estos son lo numeros del conjunto...');
		Mostrar(c);
		WRITELN;
		FOR i:=2 TO limite DO BEGIN
			IF(Pertenece(c,i)) THEN
				FOR j:=i+1 TO limite DO
					IF((j MOD i) = 0) THEN
						IF(Pertenece(c,j)) THEN
							Quitar(c,j);
		END;
		WRITELN('Y estos son los numeros primos despues de hacer la criba del conjunto:');
		READLN;
		Mostrar(c);
	END;
	
	VAR
		c:TConjunto;
BEGIN

	CribaEratostones(c,16);
	READLN;

	
END.
