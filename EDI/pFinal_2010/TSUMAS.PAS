{********************************************************************************
* 																				*
* Módulo: TSUMAS.PAS 															*
* Tipo: Programa() Interfaz-Implementación TAD (*) Otros() 						*
* Autor/es: Eduardo de Diego Lucas												*
* Fecha de actualización: 10/06/2010											*
* Descripción: Especificacion e implementacion de los metodos propios 			*
*				para el conjunto que simboliza las sumas de filas y columnas	*
* 				del survo-puzzle.												*
*				Se definen los tipos TFila y TCol que recogeran las sumas.		*
*																				*
*********************************************************************************}

UNIT TSUMAS;

INTERFACE
		
	USES
		TELEM;
	CONST
		{***Definimos como constantes las dimensiones del survo-sudoku***}
		MAXFILA = 3;
		MAXCOL = 4;

	TYPE
		TFila = ARRAY[1..MAXFILA] OF TElemento;
		TCol = ARRAY[1..MAXCOL] OF TElemento;

	PROCEDURE CrearSumaFilaVacio(VAR sumafilas:TFila);
	PROCEDURE CrearSumaColVacio(VAR sumacols:TCol);
	PROCEDURE InsertarSumaFila(VAR sumafilas:TFila; num:TElemento);
	PROCEDURE InsertarSumaCol(VAR sumacols:TCol; num:TElemento);
	PROCEDURE DameSumaFila(sumafilas:TFila;fila:TElemento;VAR suma:TElemento);
	PROCEDURE DameSumaCol(sumacols:TCol;col:TElemento;VAR suma:TElemento);
	PROCEDURE CalcularSuma(sumafilas:TFila;sumacols:TCol;fila,columna:TElemento;VAR sumax,sumay:TElemento);
	

IMPLEMENTATION

	{**********************************************************************}

	PROCEDURE CrearSumaFilaVacio(VAR sumafilas:TFila); 
	{Complejidad O(n)}
	VAR
		i:TElemento;
	BEGIN
		FOR i:=1 TO MAXFILA DO
			Asignar(sumafilas[i],0);
	END;
	
	{**********************************************************************}
	
	PROCEDURE CrearSumaColVacio(VAR sumacols:TCol); 
	{Complejidad O(n)}
	VAR
		j:TElemento;
	BEGIN
		FOR j:=1 TO MAXCOL DO
			Asignar(sumacols[j],0);
	END;
	
	{**********************************************************************}
	
	PROCEDURE InsertarSumaFila(VAR sumafilas:TFila; num:TElemento); 
	{Complejidad O(n)}
	VAR
		i:TElemento;
	BEGIN
		Asignar(i,1);
		WHILE(NOT(Igualar(sumafilas[i],0))) DO
			Aumentar(i,1);
		Asignar(sumafilas[i],num);
	END;
	
	{**********************************************************************}
	
	PROCEDURE InsertarSumaCol(VAR sumacols:TCol; num:TElemento); 
	{Complejidad O(n)}
	VAR
		j:TElemento;
	BEGIN
		Asignar(j,1);
		WHILE(NOT(Igualar(sumacols[j],0))) DO
			Aumentar(j,1);
		Asignar(sumacols[j],num);
	END;
	
	
	{**********************************************************************}
	
	PROCEDURE DameSumaFila(sumafilas:TFila;fila:TElemento;VAR suma:TElemento); 
	{Complejidad O(1)}
	BEGIN
		Asignar(suma,sumafilas[fila]);
	END;
	
	{**********************************************************************}
	
	PROCEDURE DameSumaCol(sumacols:TCol;col:TElemento;VAR suma:TElemento); 
	{Complejidad O(1)}
	BEGIN
		Asignar(suma,sumacols[col]);
	END;
	
	{**********************************************************************}
			
	PROCEDURE CalcularSuma(sumafilas:TFila;sumacols:TCol;fila,columna:TElemento;VAR sumax,sumay:TElemento); 
	{Complejidad O(1)}
	BEGIN
		DameSumaFila(sumafilas,fila,sumax);
		DameSumaCol(sumacols,columna,sumay);	
	END;
	
	{**********************************************************************}


END.
