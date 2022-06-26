{********************************************************************************
*										*
* Módulo: grafo.pas								*
* Tipo: Programa() Interfaz-Implementación TAD (+) Otros() 			*
* Autor/es: Eduardo de Diego Lucas						*
* Fecha de actualización: 18/2/2011						*
* Descripción: Interfaz TAD grafo						*
*										*
*********************************************************************************}

UNIT GRAFO;

INTERFACE

	USES TADNODO,TADARISTA,CONJUNDN,CONJUNDA;
	
	TYPE
		TOrigen= ^TNodoOrigen;
		TDestino = ^TNodoDestino;
		
		TNodoOrigen = RECORD
			n:TNodo;
			next:TOrigen;
			arista:TDestino;
		END;
		
		TNodoDestino = RECORD
			a:TArista;
			next:TDestino;
		END;
		
		TGrafo = TOrigen;
		
		{Metodos propios del TAD}
		PROCEDURE CrearGrafoVacio(VAR g:TGrafo);	
		FUNCTION EsGrafoVacio(g:TGrafo):boolean;
		PROCEDURE InsertarNodo(VAR g:TGrafo; nodo:TNodo);
		PROCEDURE InsertarArista(VAR g:TGrafo; nodo1, nodo2:TNodo; peso:integer);
		
		{Metodos no propios del TAD}
		PROCEDURE Mostrar(g:TGrafo);
		PROCEDURE DameNodos(g:TGrafo; VAR conjn:TConjuntoN);
		PROCEDURE DameAristas(g:TGrafo; VAR conja:TConjuntoA);
		
IMPLEMENTATION

	{Metodos propios del TAD}

	PROCEDURE CrearGrafoVacio(VAR g:TGrafo);
	BEGIN
		g:=NIL;
	END;
	
	FUNCTION EsGrafoVacio(g:TGrafo):boolean;
	BEGIN
		EsGrafoVacio:=(g=NIL);
	END;
	
	PROCEDURE InsertarNodo(VAR g:TGrafo; nodo:TNodo);
	VAR
		aux:TGrafo;
	BEGIN
		new(aux);
		TADNODO.Asignar(aux^.n,nodo);
		aux^.next:=g;
		aux^.arista:=NIL;
		g:=aux;
	END;
	
	PROCEDURE InsertarArista(VAR g:TGrafo; nodo1,nodo2:TNodo; peso:integer);
	VAR
		aux1,aux2:TGrafo;
		d1,d2:TDestino;
	BEGIN
		IF(NOT(EsGrafoVacio(g))) THEN BEGIN
			aux1:=g;
			WHILE(NOT(IgualNodo(aux1^.n,nodo1))) DO
				aux1:=aux1^.next;
			new(d1);
			CrearArista(d1^.a,nodo1,nodo2,peso);
			IF(aux1^.arista = NIL) THEN BEGIN
				d1^.next:=NIL;
				aux1^.arista:=d1;
			END
			ELSE BEGIN
				d1^.next:=aux1^.arista;
				aux1^.arista:=d1;
			END;
			
			aux2:=g;
			WHILE(NOT(IgualNodo(aux2^.n,nodo2))) DO
				aux2:=aux2^.next;
			new(d2);
			CrearArista(d2^.a,nodo2,nodo1,peso);
			IF(aux2^.arista = NIL) THEN BEGIN
				d2^.next:=NIL;
				aux2^.arista:=d2;
			END
			ELSE BEGIN
				d2^.next:=aux2^.arista;
				aux2^.arista:=d2;
			END;
		END
		ELSE
			WRITELN('Grafo vacio! No se puede insertar aristas!');
	END;

	{Metodos no propios del TAD}
	
	PROCEDURE Mostrar(g:TGrafo);
	VAR
		aux:TGrafo;
		destino:TDestino;
		nodo1,nodo2:TNodo;
		c, peso:integer;
	BEGIN
		aux:=g;
		c:=0;
		WHILE(NOT(EsGrafoVacio(aux))) DO BEGIN
			IF NOT EsGrafoVacio(aux) THEN BEGIN
				WRITELN('NODO[', aux^.n,']');
				destino:=aux^.arista;
				WRITELN('ARISTAS');
				WRITELN('========');
				WHILE(destino<>NIL) DO BEGIN
					c:=c+1;
					DameNodoOrigen(destino^.a,nodo1);
					DameNodoDestino(destino^.a,nodo2);
					DamePeso(destino^.a,peso);
					WRITELN(c,') ', nodo1 ,' - ', nodo2 ,' => PESO => ', peso);
					destino:=destino^.next;
				END;
				aux:=aux^.next;
				c:=0;
				WRITELN;
			END;
		END;
	END;

	PROCEDURE DameNodos(g:TGrafo; VAR conjn:TConjuntoN);
	VAR
		aux:TGrafo;	
	BEGIN
		IF(NOT(EsGrafoVacio(g))) THEN BEGIN
			aux:=g;
			WHILE(NOT(EsGrafoVacio(aux))) DO BEGIN
				CONJUNDN.Poner(conjn,aux^.n);
				aux:=aux^.next;
			END;
		END;
	END;

	PROCEDURE DameAristas(g:TGrafo; VAR conja:TConjuntoA);
	VAR
		aux:TGrafo;
		destino:TDestino;	
	BEGIN
		IF(NOT(EsGrafoVacio(g))) THEN BEGIN
			aux:=g;
			WHILE(NOT(EsGrafoVacio(aux))) DO BEGIN
				destino:=aux^.arista;
				WHILE(destino <> NIL) DO BEGIN
					CONJUNDA.Poner(conja,destino^.a);
					destino:=destino^.next;
				END;
				aux:=aux^.next;
			END;
		END;
	END;	
END.
