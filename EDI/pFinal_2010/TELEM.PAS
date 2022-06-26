{********************************************************************************
* 																				*
* Módulo: TELEM.PAS 															*
* Tipo: Programa() Interfaz-Implementación TAD (*) Otros() 						*
* Autor/es: Eduardo de Diego Lucas												*
* Fecha de actualización: 10/06/2010											*
* Descripción: Especificacion e implementacion de los metodos para el conjunto  *
* 				de numeros que se utilizaran para alcanzar la solucion.			*
* 				Se define el tipo TElelemento, que se utilizara para			*
* 					introducirlo dentro del puzzle. Es un entero.				*
* 																				*
*********************************************************************************}

UNIT TELEM;

INTERFACE
	
	TYPE
		TElemento = integer;
		
	PROCEDURE Asignar(VAR elemento1:TElemento;elemento2:TElemento);
	FUNCTION Igualar(elemento1,elemento2:TElemento):boolean;
	PROCEDURE Aumentar(VAR elemento1:TElemento;elemento2:TElemento);

IMPLEMENTATION
	
	{**********************************************************************}
	
	PROCEDURE Asignar(VAR elemento1:TElemento;elemento2:TElemento); 
	{Complejidad O(1)}
	BEGIN
		elemento1:=elemento2;
	END;
	
	{**********************************************************************}
	
	FUNCTION Igualar(elemento1,elemento2:TElemento):boolean; 
	{Complejidad O(1)}
	BEGIN
		Igualar:=elemento1=elemento2;
	END;
	
	{**********************************************************************}
	
	PROCEDURE Aumentar(VAR elemento1:TElemento;elemento2:TElemento); 
	{Complejidad O(1)}
	BEGIN
		elemento1:=elemento1 + elemento2;
	END;
	
	{**********************************************************************}

END.
