{********************************************************************************
* 																				*
* Módulo: TSUDOKU.PAS 															*
* Tipo: Programa() Interfaz-Implementación TAD (*) Otros() 						*
* Autor/es: Eduardo de Diego Lucas												*
* Fecha de actualización: 10/06/2010											*
* Descripción: Especificacion e implementacion de los metodos para el sudoku    *
* 				como tablero donde poner los numeros.							*
* 				Se define el tipo TTablero.										*
*																				*
*********************************************************************************}

UNIT TSUDOKU;

INTERFACE
	
	USES
		TNUMEROS,TSUMAS,TELEM;
			
	TYPE
		TTablero= ARRAY[1..MAXFILA,1..MAXCOL] OF TElemento;
	
	PROCEDURE CrearSudokuVacio(VAR sudoku:TTablero);
	PROCEDURE InsertarEnSudoku(VAR sudoku:TTablero;num,fila,col:integer);
	FUNCTION DameFila(sudoku:TTablero):integer;
	FUNCTION EstaOcupado(sudoku:TTAblero;fila,columna:integer):boolean;
	FUNCTION EstaEnSudoku(sudoku:TTablero;num:integer):boolean;
	PROCEDURE EncontrarSumaFila(sudoku:TTablero;fila:integer;VAR suma:TElemento);
	PROCEDURE EncontrarSumaColumna(sudoku:TTablero;columna:TElemento;VAR suma:TElemento);
	PROCEDURE QuitarComunes(VAR numeros:TValores;sudoku:TTablero);
	PROCEDURE QuitarDeSudoku(VAR sudoku:TTablero;num:TElemento);
	PROCEDURE CopiarSudoku(VAR s1:TTablero;s2:TTablero);
	PROCEDURE CalcularSiguientePos(sudoku:TTablero;fila,columna:integer;VAR fsig,csig:TElemento);
	
	PROCEDURE MostrarSudoku(sudoku:TTablero;sumafilas:TFila;sumacols:TCol);
	
IMPLEMENTATION

	{**********************************************************************}

	PROCEDURE CrearSudokuVacio(VAR sudoku:TTablero); 
	{Complejidad O(n^2)}
	VAR
		i,j:TElemento;
		cero:TElemento;
	BEGIN
		Asignar(cero,0);
		FOR i:=1 TO MAXFILA DO
			FOR j:=1 TO MAXCOL DO
				Asignar(sudoku[i,j],cero);
	END;
	
	{**********************************************************************}
	
	FUNCTION DameFila(sudoku:TTablero):TElemento; 
	{Complejidad O(1)}
	BEGIN
		DameFila:=MAXFILA; {Aqui no podemos realizar el procedimiento asignar de TELEM, ya que es una funcion}
	END;
	
	{**********************************************************************}
	
	FUNCTION EstaOcupado(sudoku:TTAblero;fila,columna:TElemento):boolean; 
	{Complejidad O(1)}
	BEGIN
		EstaOcupado:=(NOT(Igualar(sudoku[fila,columna],0)));
	END;
	
	{**********************************************************************}
	
	FUNCTION EstaEnSudoku(sudoku:TTablero;num:TElemento):boolean; 
	{Complejidad O(n^2)}
	VAR
		i,j:TElemento;
	BEGIN
		EstaEnSudoku:=FALSE;
		FOR i:=1 TO MAXFILA DO BEGIN
			FOR j:=1 TO MAXCOL DO BEGIN
				IF(Igualar(sudoku[i,j],num)) THEN
					EstaEnSudoku:=TRUE;
			END;
		END;
	END;
	
	{**********************************************************************}
	
	PROCEDURE InsertarEnSudoku(VAR sudoku:TTablero;num,fila,col:TElemento); 
	{Complejidad O(1)}
	BEGIN
		Asignar(sudoku[fila,col],num);
	END;
	
	{**********************************************************************}
	
	PROCEDURE EncontrarSumaFila(sudoku:TTablero;fila:TElemento;VAR suma:TElemento); 
	{Complejidad O(n)}
	VAR
		j:TElemento;
	BEGIN
		Asignar(suma,0);
		FOR j:=1 TO MAXCOL DO
			Aumentar(suma,sudoku[fila,j]);
	END;
	
	{**********************************************************************}
	
	PROCEDURE EncontrarSumaColumna(sudoku:TTablero;columna:TElemento;VAR suma:TElemento); 
	{Complejidad O(n)}
	VAR
		i:TElemento;
	BEGIN
		suma:=0;
		FOR i:=1 TO MAXFILA DO
			Aumentar(suma,sudoku[i,columna]);
	END;
	
	{**********************************************************************}
	
	PROCEDURE QuitarComunes(VAR numeros:TValores;sudoku:TTablero); 
	{Complejidad O(n^2)}
	VAR
		i,j,x,valor:TElemento;
	BEGIN
		FOR x:=1 TO N DO
			FOR i:=1 TO MAXFILA DO
				FOR j:=1 TO MAXCOL DO BEGIN
					DameNumeroEnPosicion(numeros,x,valor);
					IF(Igualar(sudoku[i,j],valor)) THEN
						Asignar(valor,0); 
				END;
	END;
	
	{**********************************************************************}
	
	PROCEDURE QuitarDeSudoku(VAR sudoku:TTablero;num:TElemento); 
	{Complejidad O(n^2)}
	VAR
		i,j:TElemento;
	BEGIN
		FOR i:=1 TO MAXFILA DO BEGIN
			FOR j:=1 TO MAXCOL DO BEGIN
				IF(Igualar(sudoku[i,j],num)) THEN
					Asignar(sudoku[i,j],0);
			END;
		END;
	END;
	
	{**********************************************************************}
		
	PROCEDURE CalcularSiguientePos(sudoku:TTablero;fila,columna:TElemento;VAR fsig,csig:TElemento); 
	{Complejidad O(1)}
		BEGIN
			IF ((fila=MAXFILA) AND (columna=MAXCOL)) THEN BEGIN
	            Asignar(fsig,fila+1);
				Asignar(csig,1);
			END
			ELSE BEGIN
				IF ((fila<=MAXFILA) AND (columna<MAXCOL)) THEN BEGIN
					Asignar(fsig,fila);
					Asignar(csig,columna+1);
				END
				ELSE BEGIN
					IF ((columna=MAXCOL) AND (fila<=MAXFILA)) THEN BEGIN
						Asignar(fsig,fila+1);
						Asignar(csig,1);
					END;
				END;
			END;
			IF(EstaOcupado(sudoku,fsig,csig)) THEN BEGIN
				IF ((fsig=MAXFILA) AND (csig=MAXCOL)) THEN BEGIN
		            Asignar(fsig,fsig+1);
					Asignar(csig,1);
				END
				ELSE BEGIN
					IF ((fsig<=MAXFILA) AND (csig<MAXCOL)) THEN BEGIN
						Asignar(fsig,fsig);
						Asignar(csig,csig+1);
					END
					ELSE BEGIN
						IF ((csig=MAXCOL) AND (fsig<=MAXFILA)) THEN BEGIN
							Asignar(fsig,fsig+1);
							Asignar(csig,1);
						END;
					END;
				END;
			END;
		END;
	
	{**********************************************************************}
	
	PROCEDURE CopiarSudoku(VAR s1:TTablero;s2:TTablero); 
	{Complejidad O(1)}
	BEGIN
		s1:=s2;
	END;
	
	PROCEDURE MostrarSudoku(sudoku:TTablero;sumafilas:TFila;sumacols:TCol); 
	{Complejidad O(n^2)}
	VAR
		s1,s2,s3,s4,i,j,sumaf:TElemento;
	BEGIN
		WRITELN('  -----------------');
		WRITELN('  | A | B | C | D |');
		WRITELN('-------------------');
		FOR i:=1 TO MAXFILA DO BEGIN
			WRITE(i,' |');
			FOR j:=1 TO MAXCOL DO BEGIN
				IF(NOT(Igualar(j,MAXCOL))) THEN
					WRITE(' ',sudoku[i,j],' |')
				ELSE BEGIN
					DameSumaFila(sumafilas,i,sumaf);
					WRITELN(' ',sudoku[i,j],' | [',sumaf,']')
				END;
			END;
			WRITELN('-------------------');
		END;
		DameSumaCol(sumacols,1,s1);
		DameSumaCol(sumacols,2,s2);
		DameSumaCol(sumacols,3,s3);
		DameSumaCol(sumacols,4,s4);
		WRITELN('  | ',s1,'| ',s2,'| ',s3,'| ',s4,'|');
		WRITELN('  -----------------');
	END;
	
END.
