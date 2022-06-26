{********************************************************************************
*										*
* Módulo: hospital.pas								*
* Tipo: Programa() Interfaz-Implementación TAD (+) Otros() 			*
* Autor/es: Eduardo de Diego Lucas						*
* Fecha de actualización: 7/1/2011						*
* Descripción: Interfaz TAD Hospital						*
*										*
*********************************************************************************}

UNIT HOSPITAL;

INTERFACE
	
	USES PACIENTE, MEDICO, COLAD2H;
	
	CONST
		NMedicos = 5;
	TYPE
		THospital = RECORD
			nombre:string;
			pacientes:TCola;
			medicos: ARRAY[1..NMedicos] OF TMedico;
			camas:integer;
		END;		
	
	PROCEDURE CrearHospitalVacio(VAR h:THospital);
	FUNCTION EsHospitalVacio(h:THospital):boolean;
	PROCEDURE InsertarEnHospital(VAR h:THospital; p:TPaciente);
	PROCEDURE ConsultarMedico(h:THospital; p:TPaciente; VAR m:TMedico);
	PROCEDURE VerMedicos(h:THospital);
	PROCEDURE ConsultarPrimero(h:THospital; VAR p:TPaciente;VAR exito:boolean);
	PROCEDURE QuitarPrimero(VAR h:THospital; VAR exito:boolean);
	PROCEDURE EncontrarPaciente(h:THospital; id:integer; VAR p:TPaciente; VAR encontrado:boolean);
	

IMPLEMENTATION

	FUNCTION EsHospitalVacio(h:THospital):boolean;
	BEGIN
		EsHospitalVacio:=(EsColaVacia(h.pacientes));
	END;

	PROCEDURE CrearHospitalVacio(VAR h:THospital);
	VAR
		i:integer;
		n,a:string;
	BEGIN
		CrearColaVacia(h.pacientes);
		h.camas:=75;
		WRITE('Nombre del hospital: ');
		READLN(h.nombre);
		FOR i:=1 TO NMedicos DO BEGIN
			WRITE('Nombre medico ', i ,' : ');
			READLN(n);
			WRITE('Apellido medico ', i ,' : ');
			READLN(a);
			InsertarMedico(h.medicos[i], n,a);
		END;
		WRITELN('Hospital creado satisfactoriamente!');
	END;

	PROCEDURE InsertarEnHospital(VAR h:THospital; p:TPaciente);
	VAR
		num:integer;	
	BEGIN
		IF(h.camas <> 0) THEN BEGIN
			num:=0;
			WHILE((num<1) OR (num>5)) DO BEGIN
				WRITE('Que medico le asigna?: (1/5): ');
				READLN(num);
			END;
			AsignarMedico(p, h.medicos[num]);
			Insertar(h.pacientes, p);
			h.camas:=h.camas - 1;
		END
		ELSE
			WRITELN('Hospital vacio!');
	END;
	
	PROCEDURE ConsultarMedico(h:THospital; p:TPaciente; VAR m:TMedico);
	VAR
		aux:TCola;
		paux:TPaciente;
		encontrado:boolean;
	BEGIN
		encontrado:=FALSE;
		IF(NOT(EsHospitalVacio(h))) THEN BEGIN
			aux:=h.pacientes;
			WHILE(NOT(EsColaVacia(aux)) AND NOT(encontrado)) DO BEGIN
				PrimeroCola(aux, paux);
				IF(PacientesIgual(p,paux)) THEN BEGIN
					encontrado:=TRUE;
					DameMedico(paux, m);
				END;
				Siguiente(aux); 
			END;
		END
		ELSE
			WRITELN('Hospital vacio!');	
	END;

	PROCEDURE VerMedicos(h:THospital);
	VAR
		i:integer;	
	BEGIN
		IF(h.camas <> 0) THEN BEGIN
			WRITELN('*** MEDICOS DEL HOSPITAL ', h.nombre,' ***');
			FOR i:=1 TO NMedicos DO BEGIN
				WRITE(i,' ->');
				MostrarMedico(h.medicos[i]);
			END;
		END
		ELSE
			WRITELN('Hospital vacio!');
	END;
	
	PROCEDURE ConsultarPrimero(h:THospital; VAR p:TPaciente;VAR exito:boolean);
	BEGIN
		IF(NOT(EsHospitalVacio(h))) THEN BEGIN
			exito:=TRUE;
			PrimeroCola(h.pacientes, p);
		END
		ELSE
			exito:=FALSE;
	END;
	
	PROCEDURE QuitarPrimero(VAR h:THospital; VAR exito:boolean);
	BEGIN
		IF(NOT(EsHospitalVacio(h))) THEN BEGIN
			exito:=TRUE;
			Eliminar(h.pacientes);
		END
		ELSE
			exito:=FALSE;
	END;

	PROCEDURE EncontrarPaciente(h:THospital; id:integer; VAR p:TPaciente; VAR encontrado:boolean);
	VAR
		aux:TCola;
		p1,paux:TPaciente;
	BEGIN
		encontrado:=FALSE;
		IF(NOT(EsHospitalVacio(h))) THEN BEGIN
			aux:=h.pacientes;
			CrearPaciente(p1,' ',id); {solo me baso en el id}
			WHILE(NOT(EsColaVacia(aux)) AND NOT(encontrado)) DO BEGIN
				PrimeroCola(aux, paux);
				IF(PacientesIgual(p1,paux)) THEN BEGIN
					encontrado:=TRUE;
					p:=paux;
				END;
				Eliminar(aux); 
			END;
			IF(NOT(encontrado)) THEN
				WRITELN('Paciente no encontrado!');
		END
		ELSE
			WRITELN('Hospital vacio!');
	END;

END.
