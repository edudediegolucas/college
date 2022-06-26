{********************************************************************************
*										*
* Módulo: pila.pas								*
* Tipo: Programa() Interfaz-Implementación TAD (+) Otros() 			*
* Autor/es: Eduardo de Diego Lucas						*
* Fecha de actualización: 23/10/2010						*
* Descripción: Interfaz e implementacion del TAD pila dinámica			*
*										*
*********************************************************************************}
UNIT PILACHAR;

INTERFACE
		
	TYPE
		TPilaC = ^TNodo;
		TNodo = RECORD
			info:char;
			ant:TPilaC;
		END;
	
	{METODOS PROPIOS DEL TAD}
	PROCEDURE CrearPilaVacia(VAR pila:TPilaC);
	FUNCTION EsPilaVacia(pila:TPilaC):boolean;
	PROCEDURE Apilar(VAR pila:TPilaC; e:char);
	PROCEDURE Cima(pila:TPilaC; VAR e:char);
	PROCEDURE Desapilar(VAR pila:TPilaC);
	
	{METODOS NO PROPIOS DEL TAD}
	PROCEDURE InfijaPostfija(cadInf:String; VAR cadPost:String);
		
IMPLEMENTATION

	{METODOS PROPIOS DEL TAD}

	PROCEDURE CrearPilaVacia(VAR pila:TPilaC);
	BEGIN
		pila:=NIL;
	END;
	
	FUNCTION EsPilaVacia(pila:TPilaC):boolean;
	BEGIN
		EsPilaVacia:=(pila = NIL);
	END;
	
	PROCEDURE Apilar(VAR pila:TPilaC; e:char);
	VAR
		aux:TPilaC;
	BEGIN
		new(aux);
		aux^.info:=e;
		aux^.ant:=pila;
		pila:=aux;
	END;
	
	PROCEDURE Cima(pila:TPilaC; VAR e:char);
	BEGIN
		IF NOT EsPilaVacia(pila) THEN
			e:=pila^.info;
	END;
	
	PROCEDURE Desapilar(VAR pila:TPilaC);
	VAR
		aux:TPilaC;
	BEGIN
		aux:=pila;
		IF NOT EsPilaVacia(aux) THEN BEGIN
			aux:=aux^.ant;
			pila:=aux;
		END
		ELSE
			WRITELN('No se puede desapilar nada!');
	END;

	FUNCTION PrioridadDentro(c:char):integer;
	BEGIN
		CASE c OF
			'(': PrioridadDentro:=5;
			'^': PrioridadDentro:=4;
			'*','/': PrioridadDentro:=3;
			'+','-': PrioridadDentro:=2;
			' ': PrioridadDentro:=0;
		END;
	END;
	
	FUNCTION PrioridadFuera(c:char):integer;
	BEGIN
		CASE c OF
			'(': PrioridadFuera:=5;
			'^': PrioridadFuera:=4;
			'*','/': PrioridadFuera:=3;
			'+','-': PrioridadFuera:=2;
			' ': PrioridadFuera:=0;
		END;

	END;

	{METODOS NO PROPIOS DEL TAD}

	PROCEDURE InfijaPostfija(cadInf:String; VAR cadPost:String);
	VAR
		posicion:integer;
		p:TPilaC;
		c:char;
	BEGIN
		cadPost:='';
		posicion:=1;
		CrearPilaVacia(p);
		WHILE(posicion <= length(cadInf)) DO BEGIN
			CASE cadInf[posicion] OF
				'0'..'9':
					BEGIN
					cadPost:=cadPost + cadInf[posicion];
					
					END;
				'(','+','-','*','/','^':
					BEGIN
						IF(NOT(EsPilaVacia(p))) THEN BEGIN
							Cima(p,c);
							WHILE(NOT(EsPilaVacia(p)) AND (PrioridadDentro(c) >= PrioridadFuera(cadInf[posicion]))) DO BEGIN
								cadPost:=cadPost + c + ' ';
								Desapilar(p);
								IF(NOT(EsPilaVacia(p))) THEN
									Cima(p,c);
							END;
						END;
							Apilar(p,cadInf[posicion]);
					END;
				')':
					BEGIN
						Cima(p,c);
						WHILE(NOT(EsPilaVacia(p)) AND (c <>'(')) DO BEGIN
							cadPost:=cadPost + c + ' ';
							Desapilar(p);
							IF(NOT(EsPilaVacia(p))) THEN
								Cima(p,c);
						END;
						Desapilar(p);
					END;
				' ':
					BEGIN
					END;
			END;
			posicion:=posicion + 1;
		END;
		WHILE(NOT(EsPilaVacia(p))) DO BEGIN
			Cima(p,c);
			cadPost:=cadPost + c + ' ';
			Desapilar(p);
		END;
	END;

	

END.
