{********************************************************************************
*										*
* Módulo: elemtad.pas								*
* Tipo: Programa() Interfaz-Implementación TAD (+) Otros() 			*
* Autor/es: Eduardo de Diego Lucas						*
* Fecha de actualización: 13/11/2010						*
* Descripción: Interfaz TAD elemento, que en este caso en ciudad y duracion	*
*										*
*********************************************************************************}
UNIT ELEMTAD;

INTERFACE
	
	TYPE
		TCiudad = string;
		TDuracion = real;
	
	{Metodos para TCiudad}
	FUNCTION IgualCiudad(e1,e2:TCiudad):boolean;
	PROCEDURE AsignarCiudad(VAR e1:TCiudad;e2:TCiudad);

	{Metodos para TDuracion}
	FUNCTION IgualDuracion(e1,e2:TDuracion):boolean;
	PROCEDURE AsignarDuracion(VAR e1:TDuracion;e2:TDuracion);

IMPLEMENTATION
	
	{Metodos para TCiudad}
	FUNCTION IgualCiudad(e1,e2:TCiudad):boolean;
	BEGIN
		IF (e1 = e2) THEN
			IgualCiudad:=TRUE
		ELSE
			IgualCiudad:=FALSE
	END;

	PROCEDURE AsignarCiudad(VAR e1:TCiudad;e2:TCiudad);
	BEGIN
		e1:=e2;
	END;

	{Metodos para TDuracion}
	FUNCTION IgualDuracion(e1,e2:TDuracion):boolean;
	BEGIN
		IF (e1 = e2) THEN
			IgualDuracion:=TRUE
		ELSE
			IgualDuracion:=FALSE
	END;

	PROCEDURE AsignarDuracion(VAR e1:TDuracion;e2:TDuracion);
	BEGIN
		e1:=e2;
	END;

END.
