{********************************************************************************
*										*
* Módulo: palindromo.pas							*
* Tipo: Programa() Interfaz-Implementación TAD (+) Otros() 			*
* Autor/es: Eduardo de Diego Lucas						*
* Fecha de actualización: 6/10/2010						*
* Descripción: Unidad que recoge los subprogramas para reconocer frases o	*
* 				palabras palindromas				*
*										*
*********************************************************************************}
UNIT PALINDROMO;

INTERFACE

	USES ELEMTAD,PILADIN2; {PILADIN1, PILADIN2}
	
	PROCEDURE ApilarEnPila(VAR p:TPila; frase:string);
	PROCEDURE MontarPila(p1:TPila; VAR p2:TPila);
	FUNCTION EsPalindromo(p1,p2:TPila):boolean;
	PROCEDURE Palindroma(VAR frase:string);
	
IMPLEMENTATION
	
	PROCEDURE ApilarEnPila(VAR p:TPila; frase:string);
	VAR
		i:integer;
	BEGIN
		FOR i:=1 TO Length(frase) DO BEGIN
			IF(frase[i] <> ' ') THEN
				Apilar(p,frase[i]);
		END;
	END;
	
	PROCEDURE MontarPila(p1:TPila; VAR p2:TPila);
	VAR
		c:char;
	BEGIN
		CrearPilaVacia(p2);
		WHILE(NOT(EsPilaVacia(p1))) DO BEGIN
			Cima(p1,c);
			Apilar(p2,c);
			Desapilar(p1);
		END;
	END;
	
	FUNCTION EsPalindromo(p1,p2:TPila):boolean;
	VAR
		c1,c2:char;
		condicion:boolean;
	BEGIN
		condicion:=TRUE;
		WHILE(NOT(EsPilaVacia(p1)) AND condicion) DO BEGIN
			Cima(p1,c1);
			Cima(p2,c2);
			IF(Igual(c1,c2)) THEN BEGIN
				Desapilar(p1);
				Desapilar(p2);			
			END
			ELSE BEGIN
				condicion:=FALSE;
			END;
		END;
		EsPalindromo:=condicion;
	END;

	PROCEDURE Palindroma(VAR frase:string);
	VAR
		p,q:TPila;
	BEGIN
		CrearPilaVacia(p);
		CrearPilaVacia(q);
		ApilarEnPila(p,frase);
		MontarPila(p,q);
		IF(EsPalindromo(p,q)) THEN
			WRITELN(frase, ' es una frase/palabra palindroma')
		ELSE
			WRITELN(frase, ' no es una frase/palbra palindroma');
	END;	

END.
