{********************************************************************************
* 																				*
* Módulo: SURVO.PAS 															*
* Tipo: Programa() Interfaz-Implementación TAD (*) Otros() 						*
* Autor/es: Eduardo de Diego Lucas												*
* Fecha de actualización: 10/06/2010											*
* Descripción: Especificacion e implementacion de los metodos propios           *
*				del puzzle.														*
* 																				*
*********************************************************************************}

UNIT SURVO;
	
INTERFACE
	USES 
		TSUMAS,TNUMEROS,TSUDOKU,TELEM;
		
	PROCEDURE LeerFichero(nombrefichero:string;VAR sumafilas:TFila;VAR sumacols:TCol;VAR sudoku:TTablero);
	FUNCTION EsSolucion(sudoku:TTablero;fila:integer):boolean;
	FUNCTION EsFactible(sudoku:TTablero;fila,columna,sumax,sumay,num:integer):boolean;
	PROCEDURE Resuelve(sumafilas:TFila;sumacols:TCol;numeros:TValores;VAR todos:TValores;VAR sudokusol:TTablero;
		VAR sudoku:TTAblero; fila,columna:TElemento;VAR exito:boolean);
		
IMPLEMENTATION

	PROCEDURE LeerFichero(nombrefichero:string;VAR sumafilas:TFila;VAR sumacols:TCol;VAR sudoku:TTablero);
	VAR
		archivo:Text;
		c,d,fila,columna,numero:TElemento;
		n,m:TElemento;
	BEGIN
		{LECTURA DE DATOS}
		ASSIGN(archivo,nombrefichero);
		RESET(archivo);
		Asignar(c,1);
		Asignar(d,1);
		Asignar(n,100);
		Asignar(m,100);
		WHILE NOT EOF(archivo) DO BEGIN
			READ(archivo,numero);
		IF(Igualar(c,1)) THEN
				Asignar(n,numero);
			IF(Igualar(c,2)) THEN
				Asignar(m,numero);
			IF((c>2) AND (c<=MAXFILA+2)) THEN
				InsertarSumaFila(sumafilas,numero);
			IF((c>MAXFILA+2) AND (c<=MAXFILA+MAXCOL+2)) THEN
				InsertarSumaCol(sumacols,numero);
			IF((c>MAXFILA+MAXCOL+2)) THEN BEGIN
				CASE d OF
					1:BEGIN
						Asignar(fila,numero);
						Aumentar(d,1);
					END;
					2:BEGIN
						Asignar(columna,numero);
						Aumentar(d,1);
					END;
					3:BEGIN			
						InsertarEnSudoku(sudoku,numero,fila,columna);
						Asignar(d,1);
					END;
				END;
		END;
			Aumentar(c,1);		
			END;
		CLOSE(archivo);
	END;
				
	{**********************************************************************}
		
	FUNCTION EsSolucion(sudoku:TTablero;fila:TElemento):boolean; 
	{Complejidad O(1)}
	BEGIN
		IF(DameFila(sudoku) < fila) THEN
			EsSolucion:=TRUE
		ELSE
			EsSolucion:=FALSE;
	END;
	
	{**********************************************************************}
	
	FUNCTION EsFactible(sudoku:TTablero;fila,columna,sumax,sumay,num:TElemento):boolean; 
	{Complejidad O(1)}
	VAR
		sumaf,sumac:TElemento;
	BEGIN
		EsFactible:=FALSE;
		EncontrarSumaFila(sudoku,fila,sumaf);	
		EncontrarSumaColumna(sudoku,columna,sumac);
		Asignar(sumaf,sumaf+num);
		Asignar(sumac,sumac+num);
		CASE columna OF
			1:BEGIN {columna 1}
				IF(sumaf <= sumax) THEN BEGIN
					IF(Igualar(fila,MAXFILA)) THEN BEGIN
						IF(Igualar(sumac,sumay)) THEN 
							EsFactible:=TRUE;
					END
				ELSE
						IF(sumac <= sumay) THEN
							EsFactible:=TRUE;
				END;
			END; {columna 1}
			2:BEGIN {columna 2}
				IF(sumaf <= sumax) THEN BEGIN
					IF(Igualar(fila,MAXFILA)) THEN BEGIN
						IF(Igualar(sumac,sumay)) THEN 
							EsFactible:=TRUE;
					END
					ELSE
						IF(sumac <= sumay) THEN
							EsFactible:=TRUE;
				END;
			END; {columna 2}
			3:BEGIN {columna 3}
				IF(sumaf <= sumax) THEN BEGIN
					IF(Igualar(fila,MAXFILA)) THEN BEGIN
						IF(Igualar(sumac,sumay)) THEN 
						EsFactible:=TRUE;
					END
					ELSE
						IF(sumac <= sumay) THEN
						EsFactible:=TRUE;
				END;
			END; {columna 3}
			4:BEGIN {columna 4}
				IF(sumaf = sumax) THEN BEGIN
					IF(Igualar(fila,MAXFILA)) THEN BEGIN
						IF(Igualar(sumac,sumay)) THEN 
						EsFactible:=TRUE;
					END
				ELSE
						IF(sumac <= sumay) THEN
							EsFactible:=TRUE;
				END;
			END; {columna 4}
		END;
	END;
	
	{**********************************************************************}
		
	PROCEDURE Resuelve(sumafilas:TFila;sumacols:TCol;numeros:TValores;VAR todos:TValores;VAR sudokusol:TTablero;
		VAR sudoku:TTAblero; fila,columna:TElemento;VAR exito:boolean);
	VAR
		restantes:TValores;
		sumax,sumay,fsig,csig:TElemento;
		num:TElemento;
	BEGIN
		IF(EsSolucion(sudoku,fila)) THEN
			exito:=TRUE
		ELSE BEGIN
			Copiar(restantes,numeros);
			WHILE(NOT(EsConjuntoVacio(restantes)) AND NOT(exito)) DO BEGIN
				DameNumero(restantes,num);
				QuitarNumero(restantes,num);
				CalcularSuma(sumafilas,sumacols,fila,columna,sumax,sumay);
				IF(EsFactible(sudoku,fila,columna,sumax,sumay,num) AND NOT(EstaEnSudoku(sudoku,num))) THEN BEGIN
					InsertarEnSudoku(sudoku,num,fila,columna);
					QuitarNumero(todos,num);
					CalcularSiguientePos(sudoku,fila,columna,fsig,csig);
					CopiarSudoku(sudokusol,sudoku);
					Resuelve(sumafilas,sumacols,numeros,todos,sudokusol,sudoku,fsig,csig,exito);
					QuitarDeSudoku(sudoku,num);
					InsertarNumero(todos,num);				
				END;
			END;
		END;
	END;
	
	{**********************************************************************}
		
END.
