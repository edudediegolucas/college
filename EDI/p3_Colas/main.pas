{********************************************************************************
*										*
* Módulo: MAIN.PAS								*
* Tipo: Programa(+) Interfaz-Implementación TAD () Otros() 			*
* Autor/es: Eduardo de Diego Lucas						*
* Fecha de actualización: 23/10/2010						*
* Descripción: Programa principal para probar TAD cola.				*
*										*
*********************************************************************************}
PROGRAM MAIN;

	USES COLAD;{COLAE; COLAD2;}
	
	VAR
		cola,cola2:TCola;
		opcion,c,num:integer;
		
	PROCEDURE Inicializar(VAR c:TCola);
	BEGIN
		CrearColaVacia(c);
	END;
	
BEGIN

	Inicializar(cola);
	Inicializar(cola2);
	WRITELN;
	WRITELN('*************************************************************');
	WRITELN('*                                                           *');
	WRITELN('*            PROGRAMA PARA PROBAR EL TAD COLA               *');
	WRITELN('*            	(Se manejan dos colas)                      *');
	WRITELN('*           Creado por Eduardo de Diego Lucas               *');
	WRITELN('*                                                           *');
	WRITELN('*************************************************************');
	
	opcion:=1;
	WHILE(opcion<>0) DO BEGIN
		num:=0;
		WRITELN;
		WRITELN('1.Insertar numero en cola');
		WRITELN('2.Primer elemento en la cola');
		WRITELN('3.Copiar cola');
		WRITELN('4.Eliminar elemento de la cola');
		WRITELN('5.Comprobar colas iguales');
		WRITELN('6.Longitud colas');
		WRITELN('7.Mostrar cola');
		WRITELN('0.Salir');
		WRITELN;
		WRITE('Elija opcion(0/7):');
		READLN(opcion);
		
		CASE opcion OF
			1:BEGIN
				WRITE('En que cola desea insertar el elemento? (1/2): ');
				READLN(c);
				WRITE('Deme numero a insertar: ');
				READLN(num);
				IF(c = 1) THEN
					Insertar(cola, num)
				ELSE
					Insertar(cola2,num);
			END;
			2:BEGIN
				WRITE('De que cola desea ver su primer elemento? (1/2): ');
				READLN(c);
				IF(c = 1) THEN BEGIN
					PrimeroCola(cola, num);
					WRITELN('El primer elemento en la cola 1 es: ', num);
				END
				ELSE BEGIN
					PrimeroCola(cola2, num);
					WRITELN('El primer elemento en la cola 2 es: ', num)
				END;
			END;
			3:BEGIN
				WRITELN('Copiando colas...');
				READLN;
				CopiarCola(cola,cola2);
				WRITELN('Colas copiadas!');
			END;
			{4:BEGIN
				WRITE('En que cola desea eliminar un elemento? (1/2): ');
				READLN(c);
				IF(c = 1) THEN
					Eliminar(cola)
				ELSE
					Eliminar(cola2);
			END;}
			5:BEGIN
				WRITELN('Comprobando si son colas iguales...');
				IF(IgualCola(cola,cola2)) THEN
					WRITELN('Colas iguales!')
				ELSE
					WRITELN('Colas no iguales!');
			END;
			6:BEGIN
				WRITE('De que cola desea saber su longitud? (1/2): ');
				READLN(c);
				IF(c = 1) THEN BEGIN
					num:=Longitud(cola);
					WRITELN('La longitud de la cola 1 es: ', num);
				END
				ELSE BEGIN
					num:=Longitud(cola2);
					WRITELN('La longitud de la cola 2 es: ', num)
				END;
			END;
			7:BEGIN
				WRITE('Que cola desea ver? (1/2): ');
				READLN(c);
				IF(c = 1) THEN
					Mostrar(cola)
				ELSE
					Mostrar(cola2);
			END;
		END;
	END;
	WRITELN;
	WRITELN('Ha salido del programa. Hasta la proxima!');
	
	READLN;
END.
