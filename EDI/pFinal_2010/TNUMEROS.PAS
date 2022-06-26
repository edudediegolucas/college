{********************************************************************************
* 																				*
* Módulo: TNUMEROS.PAS 															*
* Tipo: Programa() Interfaz-Implementación TAD (*) Otros() 						*
* Autor/es: Eduardo de Diego Lucas												*
* Fecha de actualización: 10/06/2010											*
* Descripción: Especificacion e implementacion de los metodos para el conjunto  *
* 				de numeros que se utilizaran para alcanzar la solucion.			*
* 				Se define el tipo TValores que recoge los numeros a utilizar.	*
*																				*
*********************************************************************************}

UNIT TNUMEROS;

INTERFACE
		
	USES
		TELEM;
		
	CONST
		{***Definimos como constantes la dimension del conjunto (12 numeros en total del 1 al 12)***}
		N = 12;
	
	TYPE
		TValores = ARRAY [1..N] OF TElemento;

	PROCEDURE CrearConjuntoNumeros(VAR numeros:TValores);
	PROCEDURE InsertarNumero(VAR numeros:TValores;num:TElemento);
	PROCEDURE QuitarNumero(VAR numeros:TValores; num:TElemento);
	FUNCTION EsConjuntoVacio(numeros:TValores):boolean;
	
	PROCEDURE DameNumero(VAR numeros:TValores; VAR valor:TElemento);
	PROCEDURE DameNumeroEnPosicion(VAR numeros:TValores; pos:TElemento;VAR valor:TElemento);
	PROCEDURE Copiar(VAR numeros1:TValores;numeros2:TValores);
	PROCEDURE MostrarNumeros(numeros:TValores);
	
	
IMPLEMENTATION

	{**********************************************************************}

	PROCEDURE CrearConjuntoNumeros(VAR numeros:TValores); 
	{Complejidad O(n)}
	VAR
		i:TElemento;
	BEGIN
		FOR i:=1 TO N DO BEGIN
			Asignar(numeros[i],i);
		END;
	END;
	
	{**********************************************************************}
	
	FUNCTION EsConjuntoVacio(numeros:TValores):boolean; 
	{Complejidad O(n)}
	VAR
		i,suma:TElemento;
	BEGIN
		EsConjuntoVacio:=FALSE;
		Asignar(suma,0);
		FOR i:=1 TO N DO
			Aumentar(suma,numeros[i]);
		IF(suma = 0) THEN
			EsConjuntoVacio:=TRUE;
	END;
	
	{**********************************************************************}
	
	PROCEDURE InsertarNumero(VAR numeros:TValores;num:TElemento); 
	{Complejidad O(n)}
	VAR
		i:TElemento;
	BEGIN
		Asignar(i,1);
		WHILE(NOT(Igualar(numeros[i],0))) DO
			Aumentar(i,1);
		Asignar(numeros[i],num);
	END;
	
	{**********************************************************************}
	
	PROCEDURE QuitarNumero(VAR numeros:TValores; num:TElemento); 
	{Complejidad O(n)}
	VAR
		i:TElemento;
	BEGIN
		Asignar(i,1);
		WHILE(NOT(Igualar(numeros[i],num))) DO
			Aumentar(i,1);
		Asignar(numeros[i],0);
	END;
	
	{**********************************************************************}
	
	PROCEDURE DameNumero(VAR numeros:TValores; VAR valor:TElemento); 
	{Complejidad O(n)}
	VAR
		i:TElemento;
		condicion:boolean;
	BEGIN
		condicion:=FALSE;
		Asignar(i,1);
		Asignar(valor,0);
		IF(NOT(EsConjuntoVacio(numeros))) THEN BEGIN
			WHILE(NOT(condicion)) DO BEGIN
				IF(NOT(Igualar(numeros[i],0))) THEN
					condicion:=TRUE;
				Aumentar(i,1);
			END;
			Asignar(valor,numeros[i-1]);
		END
	END;
	
	{**********************************************************************}
	
	PROCEDURE DameNumeroEnPosicion(VAR numeros:TValores; pos:TElemento;VAR valor:TElemento); 
	{Complejidad O(1)}
	BEGIN
		Asignar(valor,numeros[pos]);
	END;
	
	{**********************************************************************}
	
	PROCEDURE Copiar(VAR numeros1:TValores;numeros2:TValores); 
	{Complejidad O(1)}
	BEGIN
		numeros1:=numeros2;
	END;
	
	{**********************************************************************}
	
	PROCEDURE MostrarNumeros(numeros:TValores); 
	{Complejidad O(n)}
	VAR
		i:TElemento;
	BEGIN
		FOR i:=1 TO N DO BEGIN
			IF(NOT(Igualar(i,N))) THEN
				WRITE(' ', numeros[i],'][')
			ELSE
				WRITELN(' ', numeros[i]);
		END;
	END;
	
	{**********************************************************************}

END.
