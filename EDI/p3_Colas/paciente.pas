{********************************************************************************
*										*
* Módulo: paciente.pas								*
* Tipo: Programa() Interfaz-Implementación TAD (+) Otros() 			*
* Autor/es: Eduardo de Diego Lucas						*
* Fecha de actualización: 7/1/2011						*
* Descripción: Interfaz TAD Paciente						*
*										*
*********************************************************************************}

UNIT PACIENTE;

INTERFACE

	USES MEDICO;
	
	TYPE
		TPaciente = RECORD
			nombre:string;
			id:integer;
			medico:TMedico;
		END;

	PROCEDURE CrearPaciente(VAR p:TPaciente; n:string; id:integer);
	PROCEDURE MostrarPaciente(p:TPaciente);
	FUNCTION PacientesIgual(p1,p2:TPaciente):boolean;
	PROCEDURE AsignarMedico(VAR p:TPaciente; m:TMedico);
	PROCEDURE DameMedico(p:TPaciente; VAR m:TMedico);
	PROCEDURE Asignar(VAR p1:TPaciente;p2:TPaciente);
	
	
IMPLEMENTATION

	PROCEDURE CrearPaciente(VAR p:TPaciente; n:string; id:integer);
	BEGIN
		p.nombre:=n;
		p.id:=id;
	END;

	PROCEDURE MostrarPaciente(p:TPaciente);
	BEGIN
		WRITELN('ID PACIENTE: ', p.id ,',	NOMBRE PACIENTE: ', p.nombre,'	MEDICO ASIGNADO: ');
		MostrarMedico(p.medico);
	END;
	
	FUNCTION PacientesIgual(p1,p2:TPaciente):boolean;
	BEGIN
		PacientesIgual:=(p1.id = p2.id);
	END;
	
	PROCEDURE AsignarMedico(VAR p:TPaciente; m:TMedico);
	BEGIN
		MEDICO.Asignar(p.medico,m);
	END;

	PROCEDURE DameMedico(p:TPaciente; VAR m:TMedico);
	BEGIN
		MEDICO.Asignar(m, p.medico);
	END;

	PROCEDURE Asignar(VAR p1:TPaciente;p2:TPaciente);
	BEGIN
		p1:=p2;
	END;

	
END.
