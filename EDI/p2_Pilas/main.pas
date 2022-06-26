{********************************************************************************
*										*
* Módulo: main.pas								*
* Tipo: Programa(+) Interfaz-Implementación TAD () Otros() 			*
* Autor/es: Eduardo de Diego Lucas						*
* Fecha de actualización: 6/10/2010						*
* Descripción: Programa para conocer palabras o frases palindromas usando	*
*					pilas					*
*										*
*********************************************************************************}
PROGRAM MAIN;
	
	USES PILADIN1,PALINDROMO; {PILADIN1, PILADIN2}
	
VAR
	frase:string;
	
BEGIN
	
	WRITELN;
	WRITELN('*************************************************************');
	WRITELN('*                                                           *');
	WRITELN('*PROGRAMA DE RECONOCIMIENTO DE PALABRAS O FRASES PALINDROMAS*');
	WRITELN('*                 CREADO A PARTIR DE PILAS                  *');
	WRITELN('*                                                           *');
	WRITELN('*           Creado por Eduardo de Diego Lucas               *');
	WRITELN('*                                                           *');
	WRITELN('*************************************************************');
	REPEAT		
	WRITELN;
		WRITELN('Para salir escriba 0');
		WRITE('Digame una frase o palabra por favor: ');
		READLN(frase);
		IF(frase <> '0') THEN
			Palindroma(frase);
	UNTIL(frase = '0');
	WRITELN('Ha salido del programa, hasta pronto!');
			
	READLN;
END.
