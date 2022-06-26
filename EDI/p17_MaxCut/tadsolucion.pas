{********************************************************************************
*										*
* Módulo: tadnodo.pas								*
* Tipo: Programa() Interfaz-Implementación TAD (+) Otros() 			*
* Autor/es: Eduardo de Diego Lucas						*
* Fecha de actualización: 19/3/2011						*
* Descripción: Interfaz TAD nodo, un entero					*
*										*
*********************************************************************************}

UNIT TADSOLUCION;

INTERFACE
	
	USES TADNODO,TADARISTA,GRAFO,CONJUNDN,CONJUNDA;

	CONST
		N = 5;
	
	TYPE
		TSolucion = RECORD
			conjA,conjB:ARRAY[1..N] OF integer;
			valor:integer;
		END;

	PROCEDURE CrearSolVacia(VAR s:TSolucion);
	FUNCTION EstaEnSolucion(s:TSolucion;n:TNodo):boolean;
	FUNCTION EsMejor(sol1,sol2:TSolucion):boolean;
	PROCEDURE PonerSolucion(VAR s:TSolucion;n:TNodo;grupo:char;aristas:TConjuntoA);
	PROCEDURE QuitarSolucion(VAR s:TSolucion;n:TNodo;grupo:char;aristas:TConjuntoA);
	PROCEDURE AsignarSolucion(VAR sol1:TSolucion;sol2:TSolucion);
	FUNCTION DameTamSolucion(s:TSolucion):integer;
	PROCEDURE MostrarSolucion(s:TSolucion);

IMPLEMENTATION
	
	PROCEDURE CrearSolVacia(VAR s:TSolucion);
	VAR
		i:integer;	
	BEGIN
		FOR i:=1 TO N DO BEGIN
			s.conjA[i]:=0;
			s.conjB[i]:=0;
		END;
		s.valor:=0;
	END;

	FUNCTION EstaEnSolucion(s:TSolucion;n:TNodo):boolean;
	VAR
		i:integer;
		condicion1,condicion2:boolean;
	BEGIN
		condicion1:=FALSE;
		condicion2:=FALSE;
		FOR i:=1 TO N DO BEGIN
			IF(IgualNodo(s.conjA[i],n)) THEN
				condicion1:=TRUE;
		END;
		FOR i:=1 TO N DO BEGIN
			IF(IgualNodo(s.conjB[i],n)) THEN
				condicion2:=TRUE;
		END;
		
		EstaEnSolucion:=(condicion1 OR condicion2);
	END;

	FUNCTION EsMejor(sol1,sol2:TSolucion):boolean;
	BEGIN
		EsMejor:=(sol1.valor > sol2.valor);
	END;
	
	PROCEDURE DameConjuntoNodos(sol:TSolucion;grupo:char;VAR conjunto:TConjuntoN);
	VAR
		i:integer;	
	BEGIN
		CONJUNDN.CrearConjuntoVacio(conjunto);
		IF(grupo = 'A') THEN BEGIN
			FOR i:=1 TO N DO
				CONJUNDN.Poner(conjunto,sol.conjA[i]);
		END
		ELSE BEGIN
			FOR i:=1 TO N DO
				CONJUNDN.Poner(conjunto,sol.conjB[i]);
		END;
	END;

	FUNCTION CalculaContribucion(sol:TSolucion;grupo:char;nodo:TNodo;aristas:TConjuntoA):integer;
	VAR
		otrogrupo:char;
		conjunto:TConjuntoN;
		contribucion,peso:integer;
		aux:TConjuntoA;
		arista:TArista;
		nodoaux,origen,destino:TNodo;
	BEGIN
		IF(grupo = 'A') THEN
			otrogrupo:='B'
		ELSE
			otrogrupo:='A';
		contribucion:=0;
		DameConjuntoNodos(sol,otrogrupo,conjunto);
		WHILE(NOT(CONJUNDN.EsConjuntoVacio(conjunto))) DO BEGIN
			CONJUNDN.Elegir(conjunto,nodoaux);
			CONJUNDN.Quitar(conjunto,nodoaux);
			IF(CONJUNDA.PerteneceNodo(aristas,nodoaux)) THEN BEGIN
				CONJUNDA.Asignar(aux,aristas);
				WHILE(NOT(CONJUNDA.EsConjuntoVacio(aux))) DO BEGIN
					CONJUNDA.Elegir(aux,arista);
					CONJUNDA.Quitar(aux,arista);
					DameNodoOrigen(arista,origen);
					DameNodoDestino(arista,destino);
					IF((IgualNodo(origen,nodoaux)) AND (IgualNodo(destino,nodo))) THEN BEGIN
						DamePeso(arista,peso);
						contribucion:=contribucion + peso;
					END;
				END;
			END;
		END;
		CalculaContribucion:=contribucion;
	END;

	PROCEDURE PonerSolucion(VAR s:TSolucion;n:TNodo;grupo:char;aristas:TConjuntoA);
	VAR
		i:integer;
		condicion:boolean;	
	BEGIN
		condicion:=TRUE;
		i:=1;
		IF(grupo = 'A') THEN BEGIN
			WHILE(condicion) DO BEGIN
				IF(s.conjA[i]<>0) THEN
					i:=i+1
				ELSE
					condicion:=FALSE;
			END;
			s.conjA[i]:=n;
		END
		ELSE BEGIN
			WHILE(condicion) DO BEGIN
				IF(s.conjB[i]<>0) THEN
					i:=i+1
				ELSE
					condicion:=FALSE;
			END;
			s.conjB[i]:=n;
		END;
		s.valor:=s.valor + CalculaContribucion(s,grupo,n,aristas);
	END;
	
	PROCEDURE QuitarSolucion(VAR s:TSolucion;n:TNodo;grupo:char;aristas:TConjuntoA);
	VAR
		i:integer;
		condicion:boolean;		
	BEGIN
		condicion:=TRUE;
		i:=1;
		IF(grupo = 'A') THEN BEGIN
			WHILE(condicion) DO BEGIN
				IF(s.conjA[i]<>n) THEN
					i:=i+1
				ELSE
					condicion:=FALSE;
			END;
			s.conjA[i]:=0;
		END
		ELSE BEGIN
			WHILE(condicion) DO BEGIN
				IF(s.conjB[i]<>n) THEN
					i:=i+1
				ELSE
					condicion:=FALSE;
			END;
			s.conjB[i]:=0;
		END;

		s.valor:=s.valor - CalculaContribucion(s,grupo,n,aristas);
	END;

	PROCEDURE AsignarSolucion(VAR sol1:TSolucion;sol2:TSolucion);
	BEGIN
		sol1:=sol2;
	END;
	
	FUNCTION DameValor(s:TSolucion):integer;
	BEGIN
		DameValor:=s.valor;
	END;
	
	FUNCTION DameTamSolucion(s:TSolucion):integer;
	VAR
		tam,i:integer;	
	BEGIN
		tam:=0;
		FOR i:=1 TO N DO
			IF(s.conjA[i]<>0) THEN
				tam:=tam + 1;
		FOR i:=1 TO N DO
			IF(s.conjB[i]<>0) THEN
				tam:=tam + 1;
		DameTamSolucion:=tam;
	END;

	PROCEDURE MostrarSolucion(s:TSolucion);	
	VAR
		i:integer;
	BEGIN
		WRITELN('Conjunto A:');
		FOR i:=1 TO N DO BEGIN
			IF(s.conjA[i]<>0) THEN
				WRITE('[',s.conjA[i],']	');
		END;
		WRITELN;
		WRITELN('Conjunto B:');
		FOR i:=1 TO N DO BEGIN
			IF(s.conjB[i]<>0) THEN
				WRITE('[',s.conjB[i],']	');
		END;
		WRITELN;
		WRITELN('TOTAL VALOR CORTE ARISTAS: ',s.valor);
		WRITELN;		
	END;

END.
