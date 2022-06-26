{********************************************************************************
*										*
* Módulo: main.pas								*
* Tipo: Programa(+) Interfaz-Implementación TAD () Otros() 			*
* Autor/es: Eduardo de Diego Lucas						*
* Fecha de actualización: 23/10/2010						*
* Descripción: Programa principal para realizar el paso de postfija a arbol	*
*										*
*********************************************************************************}
PROGRAM MAIN;

	USES ARBOL, PILA, PILACHAR;

VAR
	a1,a2,a3:TArbolBin;
	p:TPila;
	infija, postfija:String;
	x:integer;
	
BEGIN
	WRITELN;
	WRITELN('*************************************************************');
	WRITELN('*                                                           *');
	WRITELN('*    PROGRAMA DE CREACION DE ARBOLES DE EXP. POSTFIJAS      *');
	WRITELN('*          CREADO A PARTIR CON AROBOLES Y PILAS             *');
	WRITELN('*                                                           *');
	WRITELN('*           Creado por Eduardo de Diego Lucas               *');
	WRITELN('*                                                           *');
	WRITELN('*************************************************************');
	
	WRITELN;

	WRITELN('Por favor escriba la expresion de forma infija.');
	READLN(infija);
	InfijaPostfija(infija, postfija);
	WRITELN('EXPRESION POSTFIJA FORMADA -> ' ,postfija);
	
	FOR x:=1 TO length(postfija) DO BEGIN
		CASE postfija[x] OF
			'0'..'9':BEGIN
				CrearArbolVacio(a1);
				Insertar(a1, postfija[x], NIL, NIL);
				PILA.Apilar(p,a1);
			END;
			'(','+','-','*','/','^',')':
				BEGIN
					CrearArbolVacio(a1);
					PILA.Cima(p,a2);
					PILA.Desapilar(p);
					PILA.Cima(p,a3);
					PILA.Desapilar(p);
					Insertar(a1, postfija[x], a3, a2);
					PILA.Apilar(p,a1);
				END;
		END;
	END;
	
	PILA.Cima(p,a1);
	WRITELN;
	WRITELN;
	ARBOL.Mostrar(a1);
		
	READLN;
	
END.
