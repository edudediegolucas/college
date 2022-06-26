{********************************************************************************
* 																				*
* Módulo: MAIN.PAS																*
* Tipo: Programa(*) Interfaz-Implementación TAD () Otros() 						*
* Autor/es: Eduardo de Diego Lucas												*
* Fecha de actualización: 10/06/2010											*
* Descripción: Programa principal practica obligatoria sobre el survo puzzle.	*
* 																				*
*********************************************************************************}

PROGRAM MAIN;

	USES TSUMAS,SURVO,TSUDOKU,TNUMEROS;
	
	{**********************************************************************}
	
	PROCEDURE InicioMAIN(direccion:string;VAR exito:boolean;VAR sumafilas:TFila;VAR sumacols:TCol;
		VAR numeros:TValores;VAR sudoku,sudokusol:TTablero); {O(n^2)}
	BEGIN
		CrearSumaFilaVacio(sumafilas);
		CrearSumaColVacio(sumacols);
		CrearConjuntoNumeros(numeros);
		CrearSudokuVacio(sudoku);
		LeerFichero(direccion,sumafilas,sumacols,sudoku);
		CopiarSudoku(sudokusol,sudoku);
		QuitarComunes(numeros,sudoku);
		exito:=FALSE;
	END;
	
	{**********************************************************************}
	
	VAR
		sumafilas:TFila;
		sumacols:TCol;
		numeros:TValores;
		sudoku,sudokusolucion:TTablero;
		exito:boolean;
BEGIN
	
	WRITELN('RESOULCION DEL SURVO PUZZLE');
	WRITELN('Practica creada por Eduardo de Diego Lucas, 3ero TELECO+ITIS');
	WRITELN('EDI, curso 2009-2010');
	WRITELN;
	WRITELN('********* MAIN.PAS *************');
	READLN;
	
	WRITELN('LECTURA DEL FICHERO, PULSE UNA TECLA...');
	READLN;
	
	{***Iniciamos todas las varibles principales que vamos a utilizar en el programa.***}
	{***Introducimos la ruta del archivo a leer como string. Cambiar si hace falta.***}
		
	InicioMAIN('/home/edu/EDI/pFinal_2010/ENTRADA.TXT',exito,sumafilas,sumacols,numeros,sudoku,sudokusolucion);
			
	WRITELN('RESOLUCION DE SURVO-SUDOKU, PULSE UNA TECLA...');
	WRITELN;
	WRITELN;
	WRITELN;
	WRITELN;
	READLN;
	
	{***Llamamos a la funcion estrella de la practica.***}
	
	Resuelve(sumafilas,sumacols,numeros,numeros,sudokusolucion,sudoku,1,1,exito);
	
	{***Comprobamos si hemos tenido exito o no.***}
	
	IF(exito) THEN BEGIN
		WRITELN('CONSEGUIDO! Hemos obtenido el siguiente survo puzzle resultado:');
		WRITELN;
		WRITELN;
		MostrarSudoku(sudokusolucion,sumafilas,sumacols);
	END
	ELSE BEGIN
		WRITELN('NO CONSEGUIDO! No ha sido posible obtener una solucion factible para resolver el puzzle.');
	END;

	WRITELN;
	WRITELN;
	WRITELN;
	WRITELN('***FIN DEL PROGRAMA***');
	READLN;
			
END.
