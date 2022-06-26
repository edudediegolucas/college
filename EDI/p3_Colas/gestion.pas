{********************************************************************************
*										*
* Módulo: gestion.pas								*
* Tipo: Programa(+) Interfaz-Implementación TAD () Otros() 			*
* Autor/es: Eduardo de Diego Lucas						*
* Fecha de actualización: 7/1/2011						*
* Descripción: Programa principal hospital					*
*										*
*********************************************************************************}
PROGRAM GESTION;

	USES HOSPITAL, PACIENTE, MEDICO;
	
	VAR
		hosp:THospital;
		pac:TPaciente;
		m:TMedico;
		n:string;
		opcion,id:integer;
		exito:boolean;

BEGIN

	WRITELN;
	WRITELN('*************************************************************');
	WRITELN('*                                                           *');
	WRITELN('*            PROGRAMA GESTION HOSPITAL	    	            *');
	WRITELN('*                                                           *');
	WRITELN('*           Creado por Eduardo de Diego Lucas               *');
	WRITELN('*                                                           *');
	WRITELN('*************************************************************');
	
	opcion:=1;
	WHILE(opcion<>0) DO BEGIN
		WRITELN;
		WRITELN('1.Crear hospital');
		WRITELN('2.Introducir pacientes en hospital');
		WRITELN('3.Consultar primer paciente');
		WRITELN('4.Eliminar primer paciente');
		WRITELN('5.Consultar medico de un paciente');
		WRITELN('6.Consultar todos los medicos');
		WRITELN('0.Salir');
		WRITELN;
		WRITE('Elija opcion(0/5):');
		READLN(opcion);
		
		CASE opcion OF
			1:BEGIN
				CrearHospitalVacio(hosp);
			END;
			
			2:BEGIN
				WRITE('Nombre paciente: ');
				READLN(n);
				WRITE('Id paciente: ');
				READLN(id);
				CrearPaciente(pac, n,id);
				InsertarEnHospital(hosp,pac);
			END;
			
			3:BEGIN
				ConsultarPrimero(hosp, pac, exito);
				IF(exito) THEN BEGIN
					WRITELN('El primer paciente es: ');
					MostrarPaciente(pac);
				END
				ELSE
					WRITELN('ERROR: Hospital Vacio!');
			END;
			
			4:BEGIN
				QuitarPrimero(hosp, exito);
				IF(exito) THEN
					WRITELN('Paciente borrado.')
				ELSE
					WRITELN('ERROR: Hospital Vacio!');
			END;
			5:BEGIN
				WRITE('Introduzca ID del paciente:');
				READLN(id);
				EncontrarPaciente(hosp,id,pac,exito);
				IF(exito) THEN BEGIN
					ConsultarMedico(hosp, pac, m);
					MostrarMedico(m);
				END
				ELSE
					WRITELN('Error!');
			END;
			6:BEGIN
				VerMedicos(hosp);
			END;
		END;
	END;
	WRITELN;
	WRITELN('Hasta otra!');
		
END.
