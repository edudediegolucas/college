{********************************************************************************
*										*
* Módulo: conjund.pas								*
* Tipo: Programa() Interfaz-Implementación TAD (+) Otros() 			*
* Autor/es: Eduardo de Diego Lucas						*
* Fecha de actualización: 15/3/2011						*
* Descripción: Interfaz TAD vector mediante un lista enlazada simple		*
*										*
*********************************************************************************}
UNIT VECTOR;
	
INTERFACE
	
	USES ELEMTAD;
	
	CONST
		MAX = 9;
	
	TYPE
		TVector = ARRAY[1..MAX] OF TElemento;

	{METODOS PROPIOS DEL TAD}
	PROCEDURE CrearVectorVacio(VAR v:TVector);
	PROCEDURE Poner(VAR v:TVector;e:TElemento);
	FUNCTION EsVectorVacio(v:TVector):boolean;
	PROCEDURE Elegir(v:TVector;VAR e:TElemento);
	FUNCTION Cardinal(v:TVector):integer;
	

	{METODOS NO PROPIOS DEL TAD}
	PROCEDURE Mostrar(v:TVector);
	PROCEDURE AsignarVector(VAR v1:TVector;v2:TVector);
	PROCEDURE EnPos(v:TVector;pos:integer;VAR e:TElemento);
	PROCEDURE Intercambiar(VAR v:TVector;x,y:integer);
	PROCEDURE MostrarSeparacion(v:TVector; inicio,fin,pivote,i,j:integer);

	
IMPLEMENTATION

	{METODOS PROPIOS DEL TAD}

	PROCEDURE CrearVectorVacio(VAR v:TVector);
	VAR
		i:integer;	
	BEGIN
		FOR i:=1 TO MAX DO
			Asignar(v[i],-1);
	END;
	
	FUNCTION EsVectorVacio(v:TVector):boolean;
	VAR
		i,c:integer;
	BEGIN
		
		c:=0;
		FOR i:=1 TO MAX DO
			IF(Igual(v[i],-1)) THEN
				c:=c+1;
		EsVectorVacio:=(c=MAX);
	END;
	
	PROCEDURE Poner(VAR v:TVector;e:TElemento);
	VAR
		i:integer;
	BEGIN
		IF(EsVectorVacio(v)) THEN BEGIN
			Asignar(v[1],e);
		END
		ELSE BEGIN
			i:=2;
			WHILE(NOT(Igual(v[i],-1))) DO
				i:=i+1;
			Asignar(v[i],e);
		END;
	END;
	
	PROCEDURE Elegir(v:TVector;VAR e:TElemento);
	BEGIN
		Asignar(e,v[1]);
	END;
	
	FUNCTION Cardinal(v:TVector):integer;
	VAR
		i:integer;
	BEGIN
		IF(NOT(EsVectorVacio(v))) THEN BEGIN
			Cardinal:=MAX;
		END
		ELSE
			Cardinal:=0;
	END;
	
	{FUNCTION Pertenece(c:TVector; e:TElemento):boolean;
	BEGIN
		Pertenece:=LISTADIN.Pertenece(c,e);
	END;
	
	PROCEDURE Quitar(VAR c:TVector; e:TElemento);
	BEGIN
		BorrarElemento(c,e);
	END;}

	{METODOS NO PROPIOS DEL TAD}
	
	PROCEDURE Mostrar(v:TVector);
	VAR
		i:integer;	
	BEGIN
		FOR i:=1 TO MAX DO
			WRITE('[',v[i],']	');
		READLN;
	END;

	PROCEDURE AsignarVector(VAR v1:TVector;v2:TVector);
	BEGIN
		v1:=v2;
	END;

	PROCEDURE MostrarElemento(v:TVector;pos:integer);
	VAR
		e:TElemento;
	BEGIN
		Asignar(e,v[pos]);
		WRITE('[',e,']	');
	END;

	PROCEDURE EnPos(v:TVector;pos:integer;VAR e:TElemento);
	BEGIN
		Asignar(e,v[pos]);
	END;

	PROCEDURE Intercambiar(VAR v:TVector;x,y:integer);
	VAR
		e1,e2:TElemento;	
	BEGIN
		Asignar(e1,v[x]);
		Asignar(e2,v[y]);
		Asignar(v[x],e2);
		Asignar(v[y],e1);
	END;

	PROCEDURE MostrarSeparacion(v:TVector; inicio,fin,pivote,i,j:integer);
	VAR 
		x:integer;
	BEGIN
		IF (inicio<fin) THEN BEGIN
			FOR x:=1 TO Cardinal(v) DO BEGIN
				IF ((x>=inicio) AND (x<=fin)) THEN
					MostrarElemento(v,x)
				ELSE
					WRITE('[ - ]	');
			END;
			WRITELN;
		END;
		FOR x:=1 TO Cardinal(v) DO BEGIN
			IF((x=i) AND (x=j)) THEN
				WRITE(' ^	')
			ELSE
				IF (x=i) THEN
					WRITE(' ^	')
				ELSE
					IF (x=j) THEN
						WRITE(' ^	')
					ELSE
						IF (x=pivote) THEN
							WRITE(' ^	')
						ELSE
							WRITE('	');
		END;
		WRITELN;
		FOR x:=1 TO Cardinal(v) DO BEGIN
			IF((x=i) AND (x=j)) THEN
				WRITE(' |	')
			ELSE
				IF (x=i) THEN
					WRITE(' |	')
				ELSE
					IF (x=j) THEN
						WRITE(' |	')
					ELSE
						IF (x=pivote) THEN
							WRITE(' |	')
						ELSE
							WRITE('	');
		END;
		WRITELN;
		FOR x:=1 TO Cardinal(v) DO BEGIN
			IF((x=i) AND (x=j)) THEN
				WRITE(' i=j	')
			ELSE
				IF(x=i) THEN
					WRITE(' i	')
				ELSE
					IF(x=j) THEN
						WRITE(' j	')
					ELSE
						IF(x=pivote) THEN
							WRITE(' p	')
						ELSE
							WRITE('	');
		END;
		WRITELN;
		READLN;
	END;

END.
