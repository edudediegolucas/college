{********************************************************************************
*										*
* Módulo: elemtad2.pas								*
* Tipo: Programa() Interfaz-Implementación TAD (+) Otros() 			*
* Autor/es: Eduardo de Diego Lucas						*
* Fecha de actualización: 16/2/2011						*
* Descripción: Interfaz TAD elemento, dos enteros: peso y valor			*
*										*
*********************************************************************************}

UNIT ELEMTAD2;

INTERFACE
	
	TYPE
		TElemento = RECORD
			w:integer;
			v:integer;
		END;

	PROCEDURE CrearElemento(VAR e:TElemento; peso, valor:integer);	
	FUNCTION IgualPeso(e1,e2:TElemento):boolean;
	FUNCTION IgualValor(e1,e2:TElemento):boolean;
	FUNCTION MayorPeso(e1,e2:TElemento):boolean;
	FUNCTION MayorValor(e1,e2:TElemento):boolean;
	FUNCTION MayorValorPorPeso(e1,e2:TElemento):boolean;
	PROCEDURE Asignar(VAR e1:TElemento;e2:TElemento);
	PROCEDURE DamePeso(e:TElemento;VAR peso:integer);
	PROCEDURE DameValor(e:TElemento;VAR valor:integer);

IMPLEMENTATION

	PROCEDURE CrearElemento(VAR e:TElemento; peso, valor:integer);
	BEGIN
		e.w:=peso;
		e.v:=valor;
	END;
	
	FUNCTION IgualPeso(e1,e2:TElemento):boolean;
	BEGIN
		IF (e1.w = e2.w) THEN
			IgualPeso:=TRUE
		ELSE
			IgualPeso:=FALSE
	END;

	FUNCTION IgualValor(e1,e2:TElemento):boolean;
	BEGIN
		IF (e1.v = e2.v) THEN
			IgualValor:=TRUE
		ELSE
			IgualValor:=FALSE
	END;

	FUNCTION MayorPeso(e1,e2:TElemento):boolean;
	BEGIN
		IF (e1.w > e2.w) THEN
			MayorPeso:=TRUE
		ELSE
			MayorPeso:=FALSE
	END;

	FUNCTION MayorValor(e1,e2:TElemento):boolean;
	BEGIN
		IF (e1.v > e2.v) THEN
			MayorValor:=TRUE
		ELSE
			MayorValor:=FALSE
	END;

	FUNCTION MayorValorPorPeso(e1,e2:TElemento):boolean;
	BEGIN
		IF (e1.v/e1.w > e2.v/e2.w) THEN
			MayorValorPorPeso:=TRUE
		ELSE
			MayorValorPorPeso:=FALSE
	END;
	

	PROCEDURE Asignar(VAR e1:TElemento;e2:TElemento);
	BEGIN
		e1:=e2;
	END;
	
	PROCEDURE DamePeso(e:TElemento;VAR peso:integer);
	BEGIN
		peso:=e.w;
	END;

	PROCEDURE DameValor(e:TElemento;VAR valor:integer);
	BEGIN
		valor:=e.v;
	END;

END.
