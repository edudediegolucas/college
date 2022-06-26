{********************************************************************************
*										*
* Módulo: quicksort.pas								*
* Tipo: Programa() Interfaz-Implementación TAD (+) Otros() 			*
* Autor/es: Eduardo de Diego Lucas						*
* Fecha de actualización: 15/3/2011						*
* Descripción: Interfaz que contiene el algoritmo quicksort			*
*										*
*********************************************************************************}

UNIT QUICKSORT;

INTERFACE
	
	USES ELEMTAD,VECTOR;

	PROCEDURE InicializarVector(VAR v:TVector);
	PROCEDURE Quicksort(VAR v:TVector;inicio,fin:integer);

IMPLEMENTATION
	
	PROCEDURE InicializarVector(VAR v:TVector);
	VAR
		i,x:TElemento;	
	BEGIN
		CrearVectorVacio(v);
		RANDOMIZE;
		FOR i:=1 TO MAX DO BEGIN
			x:=Random(100);
			Poner(v,x);
		END;
	END;

	PROCEDURE Separar(VAR v:TVector;inicio,fin:integer;VAR pivote:integer);
	VAR
		ePivote,e1,e2:TElemento;
		i,j:integer;	
	BEGIN
		EnPos(v,inicio,ePivote);
		i:=inicio+1;
		j:=fin;
		MostrarSeparacion(v,inicio,fin,inicio,i,j);
		REPEAT
			EnPos(v,i,e1);
			WHILE((i<=j) AND (e1<=ePivote)) DO BEGIN
				i:=i+1;
				EnPos(v,i,e1);
				MostrarSeparacion(v,inicio,fin,inicio,i,j);
			END;

			EnPos(v,j,e2);
			WHILE((i<=j) AND (e2>=ePivote)) DO BEGIN
				j:=j-1;
				EnPos(v,j,e2);
				MostrarSeparacion(v,inicio,fin,inicio,i,j);
			END;
			
			IF(i<j) THEN BEGIN
				Intercambiar(v,i,j);
				i:=i+1;
				j:=j-1;
				MostrarSeparacion(v,inicio,fin,inicio,i,j);
			END;
		UNTIL(i>j);

		Intercambiar(v,inicio,j);
		pivote:=j;
		MostrarSeparacion(v,inicio,fin,inicio,i,j);
	END;

	PROCEDURE Quicksort(VAR v:TVector;inicio,fin:integer);
	VAR
		pivote:integer;	
	BEGIN
		IF(inicio<fin) THEN BEGIN
			Separar(v,inicio,fin,pivote);
			Quicksort(v,inicio,pivote-1);
			Quicksort(v,pivote+1,fin);
		END;
	END;
END.
