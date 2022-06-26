{********************************************************************************
*										*
* Módulo: medico.pas								*
* Tipo: Programa() Interfaz-Implementación TAD (+) Otros() 			*
* Autor/es: Eduardo de Diego Lucas						*
* Fecha de actualización: 7/1/2011						*
* Descripción: Interfaz TAD Medico						*
*										*
*********************************************************************************}

UNIT MEDICO;

INTERFACE

	TYPE
		TMedico = RECORD
			nombre:string;
			apellidos:string
		END;

	PROCEDURE InsertarMedico(VAR m:TMedico; nombre,apellidos:string);
	PROCEDURE MostrarMedico(m:TMedico);
	PROCEDURE Asignar(VAR m1:TMedico; m2:TMedico);
	
IMPLEMENTATION

	PROCEDURE InsertarMedico(VAR m:TMedico; nombre,apellidos:string);
	BEGIN
		m.nombre:=nombre;
		m.apellidos:=apellidos;
	END;

	PROCEDURE MostrarMedico(m:TMedico);
	BEGIN
		WRITELN('APELLIDOS MEDICO: ', m.apellidos ,',	NOMBRE MEDICO: ', m.nombre);
	END;

	PROCEDURE Asignar(VAR m1:TMedico; m2:TMedico);
	BEGIN
		m1:=m2;
	END;

	
	
END.
