{********************************************************************************
*										*
* Módulo: arbolavl.pas								*
* Tipo: Programa() Interfaz-Implementación TAD (+) Otros() 			*
* Autor/es: Eduardo de Diego Lucas						*
* Fecha de actualización: 30/10/2010						*
* Descripción: Interfaz TAD arbol AVL						*
*										*
*********************************************************************************}

UNIT ARBOLAVL;

INTERFACE
		
	USES ELEMTAD;

	TYPE
		TAvl = ^TNodo;
		TNodo = RECORD
			info:TElemento;
			izq,der:TAvl;
			altura:integer;
		END;
	
	{METODOS PROPIOS DEL TAD}
	PROCEDURE CrearAVLVacio(VAR a:TAvl);
	FUNCTION EsArbolAVLVacio(a:TAvl):boolean;
	PROCEDURE Construir(VAR a:TAvl;izq, der:TAvl;e:TElemento; altura:integer);
	PROCEDURE RotacionSimpleIzquierda(VAR a:TAvl);
	PROCEDURE RotacionSimpleDerecha(VAR a:TAvl);
	PROCEDURE RotacionDobleIzquierdaDerecha(VAR a:TAvl);
	PROCEDURE RotacionDobleDerechaIzquierda(VAR a:TAvl);
	PROCEDURE ReequilibrarAVL(VAR a:TAvl);
	PROCEDURE InsertarEnAVL(VAR a:TAvl;e:TElemento);
	FUNCTION FactorEquilibrio(a:TAvl):integer;

	{METODOS NO PROPIOS DEL TAD}
	PROCEDURE Mostrar(a:TAvl);
	

IMPLEMENTATION

	{METODOS PROPIOS DEL TAD}

	PROCEDURE CrearAVLVacio(VAR a:TAvl);
	BEGIN
		a:=NIL;
	END;

	FUNCTION EsArbolAVLVacio(a:TAvl):boolean;
	BEGIN
		EsArbolAVLVacio:=(a = NIL);
	END;

	PROCEDURE Construir(VAR a:TAvl;izq, der:TAvl;e:TElemento; altura:integer);
	BEGIN
		new(a);
		a^.info:=e;
		a^.izq:=izq;
		a^.der:=der;
		a^.altura:=altura;
	END;

	FUNCTION FactorEquilibrio(a:TAvl):integer;
	BEGIN
		FactorEquilibrio:=(a^.der^.altura - a^.izq^.altura);
	END;
	
	PROCEDURE RotacionSimpleIzquierda(VAR a:TAvl);
	VAR
		aux:TAvl;
		altura1, altura2:integer;
	BEGIN
		IF(NOT(EsArbolAVLVacio(a^.izq))) THEN BEGIN
			aux:=a^.izq;
			a^.izq:=aux^.der;
			aux^.der:=a;
			altura1:=a^.izq^.altura;
			altura2:=a^.der^.altura;
			IF(altura1 >= altura2) THEN
				a^.altura:=altura1 + 1
			ELSE
				a^.altura:=altura2 + 1;			
			altura1:=aux^.izq^.altura;
			altura2:=a^.altura;
			IF(altura1 >= altura2) THEN
				aux^.altura:=altura1 + 1
			ELSE
				aux^.altura:=altura2 + 1;
			a:=aux;
		END
		ELSE
			WRITELN('ERROR: el AVL debe tener hijo izquierdo');
	END;

	PROCEDURE RotacionSimpleDerecha(VAR a:TAvl);
	VAR
		aux:TAvl;
		altura1, altura2:integer;
	BEGIN
		IF(NOT(EsArbolAVLVacio(a^.der))) THEN BEGIN
			aux:=a^.der;
			a^.der:=aux^.izq;
			aux^.izq:=a;
			altura1:=a^.izq^.altura;
			altura2:=a^.der^.altura;
			IF(altura1 >= altura2) THEN
				a^.altura:=altura1 + 1
			ELSE
				a^.altura:=altura2 + 1;	
			altura1:=aux^.der^.altura;
			altura2:=a^.altura;
			IF(altura1 >= altura2) THEN
				aux^.altura:=altura1 + 1
			ELSE
				aux^.altura:=altura2 + 1;
			a:=aux;
		END
		ELSE
			WRITELN('ERROR: el AVL debe tener hijo derecho');
	END;

	PROCEDURE RotacionDobleIzquierdaDerecha(VAR a:TAvl);
	BEGIN
		IF(NOT(EsArbolAVLVacio(a^.izq))) THEN BEGIN
			RotacionSimpleDerecha(a^.izq);
			RotacionSimpleIzquierda(a);
		END
		ELSE
			WRITELN('ERROR: el AVL debe tener hijo izquierdo');
	END;

	PROCEDURE RotacionDobleDerechaIzquierda(VAR a:TAvl);
	BEGIN
		IF(NOT(EsArbolAVLVacio(a^.der))) THEN BEGIN
			RotacionSimpleIzquierda(a^.der);
			RotacionSimpleDerecha(a);
		END
		ELSE
			WRITELN('ERROR: el AVL debe tener hijo derecho');
	END;		
	
	PROCEDURE ReequilibrarAVL(VAR a:TAvl);
	BEGIN
		IF(FactorEquilibrio(a) = 2) THEN BEGIN
			IF(FactorEquilibrio(a^.der) = 1) THEN BEGIN
				RotacionSimpleDerecha(a);
				RotacionDobleDerechaIzquierda(a);		
			END;
		END
		ELSE BEGIN
			IF(FactorEquilibrio(a) = -2) THEN BEGIN
				IF(FactorEquilibrio(a^.izq) = -1) THEN BEGIN
					RotacionSimpleIzquierda(a);
					RotacionDobleIzquierdaDerecha(a);		
				END;
			END;
		END;
	END;

	FUNCTION Altura(a:TAvl):integer;
	BEGIN
		IF(NOT(EsArbolAVLVacio(a))) THEN
			Altura:=a^.altura
		ELSE
			Altura:=0;
	END;
	
	PROCEDURE InsertarEnAVL(VAR a:TAvl;e:TElemento);
	VAR
		e1:integer;
	BEGIN
		IF(EsArbolAVLVacio(a)) THEN
			Construir(a,NIL,NIL,e,Altura(a)+1)
		ELSE BEGIN
			e1:=a^.info;
			IF(e1 >= e) THEN BEGIN
				InsertarEnAVL(a^.izq,e);
				a^.izq^.altura:=Altura(a) + 1;
				//ReequilibrarAVL(a);
			END
			ELSE BEGIN
				InsertarEnAVL(a^.der,e);
				a^.der^.altura:=Altura(a) + 1;
				//ReequilibrarAVL(a);
			END;
		END;
	END;

	{METODOS NO PROPIOS DEL TAD}

	PROCEDURE Mostrar(a:TAvl);	
	BEGIN
		IF(NOT(EsArbolAVLVacio(a))) THEN BEGIN
			WRITELN('Raíz AVL: ', a^.info);
			WRITELN('=Hijo izq=');
			Mostrar(a^.izq);
			WRITELN('Hijo der=');
			Mostrar(a^.der);
		END;
	END;

END.
