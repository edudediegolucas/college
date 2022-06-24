--*******************************************************
--******Práctica 6 (Final)de Sistemas Telemáticos I**********
--*******************************************************
--*****************Curso 2008/2009**********************
--*******************************************************
--******************Realizada por:************************
--*******************************************************
--*************Eduardo de Diego Lucas********************
--*******************************************************
--******************TELECO+ITIS*************************

--gnutelight.adb

--***PAQUETES A UTILIZAR****
with Lower_Layer_UDP;
with Ada.Text_IO;
with Ada.Strings.Unbounded;
with Ada.Strings.Unbounded.Text_IO;
with Ada.Command_Line;
with Ada.Streams;
with Ada.Streams.Stream_IO;
with Ada.Calendar;
with gnutelight_Contacts;
with Ada.Exceptions;

With gnutelight_Handler;
with pantalla;

--***INICIO DEL PROCEDIMIENTO***
procedure Gnutelight is

package LLU renames Lower_Layer_UDP;
package ASU renames Ada.Strings.Unbounded;
package ASU_IO renames Ada.Strings.Unbounded.Text_IO;
package ACL renames Ada.Command_Line;
package S_IO renames Ada.Streams.Stream_IO;

use type Ada.Streams.Stream_IO.Count;
use type Ada.Calendar.Time;

--***VARIABLES***

EP_SVC,EP_RES,EP_SVC_peer,contacto:LLU.End_Point_Type;
ret_min,ret_max,pct_fallos,ventana:Integer;
puerto_peer:Integer;
FILE_NAME, FILE_NAME_NEW,maquina_SVC,puerto_SVC,opciones, CONTENIDO:ASU.Unbounded_String;
maquina_peer,IP_peer:ASU.Unbounded_String;
BLOCK_DATA:Ada.Streams.Stream_Element_Array(1..1024);
Buffer:aliased LLU.Buffer_Type(2048);
Ultimo:S_IO.Positive_Count;
Fichero_Destino:S_IO.File_Type;
OPTIONS:Natural:=1;
BLOCK_POS, BLOCK_POS_NEW:Positive:=1;
BLOCK_SIZE, BLOCK_SIZE_NEW:Positive:=1024;
tamano:Integer:=0;


vent_vacia:Integer;
intentos:Integer:=0;

comando,respuesta:ASU.Unbounded_String;

Longitud:Ada.Streams.Stream_Element_Offset;
BYTES:Natural:=100;
plazo_ret,Tiempo_Llegada:Duration;
cont:Natural;
Expired,conectado,fin_descarga,fin_chat, CHAT_FIN, finaliza:Boolean;
Tiempo_Inicial,Tiempo_Anterior,Tiempo_Peticion,Tiempo_Fin:Ada.Calendar.Time;

--***TIPOS DE MENSAJE A ENVIAR***

--type Message_Type is (HELLO,WELCOME,DATAREQ,DATA,DATAERR);
--type Option_Type is (SIZEREQ, SIZE, FILE_NOT_FOUND, BLOCK_NOT_FOUND);
type Message_Type is (HELLO, WELCOME, DATAREQ, DATA, DATAERR, CHAT);
type Option_Type is (SIZEREQ, SIZE, FILE_NOT_FOUND, BLOCK_NOT_FOUND);

recibido:Message_Type;
recibido2,recibido3:Option_Type;

Usage_Error:exception;
Separa_Error:exception;

--***REGISTRO DE VENTANA***
type Rventana is record
	POS_BLOCK:Natural:=0;
	Tiempo_Peticion:Ada.Calendar.Time:=Ada.Calendar.Clock;
end record;

type Aventana is array(1..100) of Rventana;

v:Aventana;
--***PROCEDIMIENTO PARA TROCEAR COMANDO DE ENTRADA***

procedure Separar_Comandos(Palabra:in out ASU.Unbounded_String;Comando: out ASU.Unbounded_String;Espacio:in String) is
	Ubicacion:Integer;
begin
	Ubicacion:=ASU.Index(Palabra,Espacio);
	if (Ubicacion>1) then
		Comando:=ASU.Head(Palabra,Ubicacion-1);
		ASU.Tail(Palabra,ASU.Length(Palabra)-Ubicacion);
	else
		raise Separa_Error;
	end if;
end Separar_Comandos;
	

--***PROCEDIMIENTO PARA MOSTRAR LA VENTANA ANUNCIADA***

procedure Mostrar_Ventana(Vent:Aventana;Tam:Integer) is
begin
	Ada.Text_IO.Put("[");
	for x in 1..Tam loop
		Ada.Text_IO.Put(Integer'Image(Vent(x).POS_BLOCK) & "|");
	end loop;
	Ada.Text_IO.Put_Line(" ]");
end Mostrar_Ventana;

--***PROCEDIMIENTO PARA COMPROBAR Y LIMPIAR LA VENTANA***

procedure Limpiar_Ventana(Vent: in out Aventana;Tam:Integer; vent_vacia: out Integer) is
begin
	vent_vacia:=0;--completar ventana
	for x in 1..Tam loop--reutilizacion de ventana
		if Vent(x).POS_BLOCK=BLOCK_POS_NEW then--si la posicion de ventana es la que se ha escrito se borra
			Vent(x).POS_BLOCK:=0;
		end if;
		if Vent(x).POS_BLOCK=0 then
			Vent_vacia:=vent_vacia+1;--contamos cuantas posiciones se han escrito, CONDICION DE SALIDA
		end if;
	end loop;
end Limpiar_Ventana;

My_Contacts: Gnutelight_Contacts.Contacts_List_Type;


begin

	if ACL.Argument_Count /=6 and ACL.Argument_Count /=8 then raise Usage_Error;
	end if;
	pantalla.Borrar;
	pantalla.Poner_Color_Fondo(pantalla.Naranja);
	pantalla.Poner_Color(pantalla.Blanco);
	Ada.Text_IO.Put_Line ("************************GNUTELIGHT.ADB*********************************");
	Ada.Text_IO.Put_Line ("Bienvenido al programa gnutelight.adb. Ha iniciado un nodo que servira y descarga archivos.");
	Ada.Text_IO.Put_Line ("************************************************************************");
	pantalla.Poner_Color_Fondo(pantalla.Normal);

	--***INICIO DEL PROGRAMA CON 6 ARGUMENTOS INTRODUCIDOS, nodo principal***
	EP_SVC:=LLU.Build(LLU.To_IP(LLU.Get_Host_Name),Integer'Value(ACL.Argument(1)));
	gnutelight_handler.Directorio:=ASU.To_Unbounded_String(ACL.Argument(2));
	ret_min:=Integer'Value(ACL.Argument(3));
	ret_max:=Integer'Value(ACL.Argument(4));
	pct_fallos:=Integer'Value(ACL.Argument(5));
	ventana:=Integer'Value(ACL.Argument(6));

	Gnutelight_Contacts.Add_One(gnutelight_handler.contactos,EP_SVC);
	--***PLAZO DE RETRANSMISION***
	--Calculado a partir del doble del retardo maximo en milisegundos
	plazo_ret:=(2.0/1000.0)*Duration(ret_max);
	LLU.Set_Faults_Percent(pct_fallos);
	LLU.Set_Random_Propagation_Delay(ret_min,ret_max);

	LLU.Bind(EP_SVC,Gnutelight_Handler.My_Handler'Access);
	LLU.Bind_Any(EP_RES);
	cont:=1;--numero de contactos
	finaliza:=False;--condicion para finalizar el programa
	conectado:=False;
	
	--***INICIO DEL PROGRAMA CON 8 ARGUMENTOS, nodo que se conecta***
	if ACL.Argument_Count =8 then
		maquina_peer:=ASU.To_Unbounded_String(ACL.Argument(7));
		puerto_peer:=Integer'Value(ACL.Argument(8));
		IP_peer:=ASU.To_unbounded_String(LLU.To_IP(ASU.To_String(maquina_peer)));
		Tiempo_Inicial:=Ada.Calendar.Clock;
		EP_SVC_peer:=LLU.Build(ASU.To_String(IP_peer),puerto_peer);
		cont:=1;

		--***ENVIO MENSAJE "HELLO"****
		--Mecanismo que funciona de la siguiente manera, enviaremos como máximo 10 intentos del mensaje HELLO para conectarse al nodo
		--del que queramos descargarnos algún fichero. Tras recibir el mensaje WELCOME, el nodo guarda los contactos ya existentes
		--Estructura del mensaje:
		----|HELLO| | EP_RES| | EP_SVC|
		for x in 1..10 loop
			LLU.Reset(Buffer);
			Message_Type'Output(Buffer'Access, HELLO);
			LLU.End_Point_Type'Output (Buffer'Access, EP_RES);
			LLU.End_Point_Type'Output(Buffer'Access, EP_SVC);
			LLU.Send(EP_SVC_peer, Buffer'Access);

			LLU.Reset(Buffer);
			LLU.Receive(EP_RES,Buffer'Access,plazo_ret,Expired);
			if Expired then
				pantalla.Poner_Color(pantalla.Rojo);
				Ada.Text_IO.Put_Line ("Se ha expirado el plazo. INTENTO-->" & Integer'Image(x));
			else
				pantalla.Poner_Color(pantalla.Verde);
				Ada.Text_IO.Put_Line ("Mensaje WELCOME recibido!");
				recibido:=Message_Type'Input(Buffer'Access);
				if recibido=WELCOME then
					cont:=Natural'Input(Buffer'Access);--contactos recibidos
					for x in 1..cont loop
						EP_SVC:=LLU.End_Point_Type'Input (Buffer'Access);
						Gnutelight_Contacts.Add_One (gnutelight_handler.contactos,EP_SVC);--añadimos cada uno de los contactos recibidos
					end loop;
					conectado:=True;
				end if;--recibido	
			end if;--expired
		exit when conectado;
		end loop;--las 10 iteraciones del HELLO
	end if;--argumentos de entrada
	pantalla.Poner_Color(pantalla.Amarillo);
	Ada.Text_IO.Put_Line("Ahora hay : " & Integer'Image(cont)& " contactos conectados.");

	--***INICIO DEL MENU PRINCIPAL***
	loop
		pantalla.Poner_Color(pantalla.Blanco);
		Ada.Text_IO.Put_Line ("");
		Ada.Text_IO.Put_Line ("****Menu de comandos****");
		Ada.Text_IO.Put_Line ("Recuerde que los comandos para este programa son 'contactos', 'configuracion', 'descarga', 'chat' y 'termina'");
		Ada.Text_IO.Put_Line ("Para el comando descarga, se recuerda que es: 'descarga maquina puerto_maquina archivo'");
		Ada.Text_IO.Put_Line ("");
		Ada.Text_IO.Put_Line("Ejemplo: '>descarga zeta01 9000 archivo1.txt'");
		Ada.Text_IO.Put_Line ("");
		Ada.Text_IO.Put_Line ("Para el comando chat, se recuerda que es: 'chat maquina puerto_maquina' ");
		Ada.Text_IO.Put_Line ("");		
		Ada.Text_IO.Put_Line("Ejemplo: '>chat zeta01 9000' ");		
		pantalla.Poner_Color(pantalla.Amarillo);
		Ada.Text_IO.Put("gnutelight>");
		pantalla.Poner_Color(pantalla.Blanco);
		opciones:= ASU_IO.Get_Line;

	--***CONTACTOS***
		if ASU.To_String(opciones)="contactos" then
			pantalla.Poner_Color(pantalla.Verde);
			Ada.Text_IO.Put_Line (" ");
			Ada.Text_IO.Put_Line ("Lista de contactos:");
			Ada.Text_IO.Put_Line("*************************************CONTACTOS*************************************");
			for x in 1..cont loop
				contacto:=Gnutelight_Contacts.Get_One(gnutelight_handler.contactos,x);
				Ada.text_IO.Put_line("contacto " & Integer'Image(x) & "-> " & LLU.Image(contacto));                  
				Ada.Text_IO.Put_Line (" ");
			end loop;--for
			Ada.Text_IO.Put_Line("*************************************************************************************");
		--end if;--CONTACTOS
	
	--***TERMINA***
		else
			if ASU.To_String(opciones)="termina" then
				pantalla.Poner_Color_Fondo(pantalla.Gris);
				pantalla.Poner_Color(pantalla.Rojo);
				Ada.Text_IO.Put_Line (" ");
				Ada.Text_IO.Put_Line("Hasta otra!");
				Ada.Text_IO.Put_Line("********************************FIN DE GNUTELIGHT.ADB**************************************");
				pantalla.Poner_Color(pantalla.Blanco);
				pantalla.Poner_Color_Fondo(pantalla.Normal);
				LLU.Finalize;
				finaliza:=True;
			end if;--TERMINA
		end if;
	--***CONFIGURACION***
		if ASU.To_String(opciones)="configuracion" then
			pantalla.Poner_Color(pantalla.Amarillo);
			Ada.Text_IO.Put_Line (" ");
			Ada.Text_IO.Put_Line("*************************************CONFIGURACION*************************************");
			Ada.Text_IO.Put("Configuracion del nodo--> " );
			ASU.Text_IO.Put_Line(ASU.To_Unbounded_String(LLU.Image(EP_SVC)));
			Ada.Text_IO.Put_Line("Establecida funcion descarga en puerto :" & ASU.To_String(ASU.To_Unbounded_String(ACL.Argument(1))));
			Ada.Text_IO.Put_Line("Retardos (en milisegundos)--> MIN("& Integer'Image(ret_min) & ") // MAX("&Integer'Image(ret_max) & ")");
			Ada.Text_IO.Put_Line("Porcentaje de fallos--> " &Integer'Image(pct_fallos)& "%");
			Ada.Text_IO.Put_Line("Tamanio de ventana--> " &Integer'Image(ventana));
			if ACL.Argument_Count =8 then
				Ada.Text_IO.Put("Atado con el nodo--> '" & ASU.To_String(maquina_peer)& "'");
				Ada.Text_IO.Put_Line(" en el puerto---> " & Integer'Image(puerto_peer));
			end if;	
		end if;--Configuracion		

	--***DESCARGA***
		if ASU.index(opciones,"descarga")=1 then
			LLU.Reset(Buffer);
			BLOCK_POS:=1;
			comando:=opciones;
			Separar_Comandos(opciones, comando," ");
			Separar_Comandos(opciones, maquina_SVC," ");
			Separar_Comandos(opciones, puerto_SVC," ");
			FILE_NAME:=opciones;
			pantalla.Poner_Color(pantalla.Azul_Claro);
			Ada.Text_IO.Put_Line("**************************************DESCARGA*******************************************");
			Ada.Text_IO.Put_Line ("Se va a proceder a descargar segun esta configuracion, ¿esta seguro? (s/n)");
			
			Ada.Text_IO.Put("Maquina -->");
			pantalla.Poner_Color(pantalla.Blanco);
			Ada.Text_IO.Put_Line (ASU.To_String(maquina_SVC));
			pantalla.Poner_Color(pantalla.Azul_Claro);
			Ada.Text_IO.Put("Puerto -->");
			pantalla.Poner_Color(pantalla.Blanco);
			Ada.Text_IO.Put_Line(ASU.To_String(puerto_SVC));
			pantalla.Poner_Color(pantalla.Azul_Claro);
			Ada.Text_IO.Put("Archivo -->");
			pantalla.Poner_Color(pantalla.Blanco);
			Ada.Text_IO.Put_Line(ASU.To_String(FILE_NAME));
			pantalla.Poner_Color(pantalla.Azul_Claro);
			Ada.Text_IO.Put("Porcentaje de Fallos -->");
			pantalla.Poner_Color(pantalla.Blanco);
			Ada.Text_IO.Put_Line(Integer'Image(pct_fallos) & "%");
			
			pantalla.Poner_Color(pantalla.Amarillo);
			Ada.Text_IO.Put("Respuesta>");
			pantalla.Poner_Color(pantalla.Blanco);
			respuesta:=ASU_IO.Get_Line;
			if ASU.To_String(respuesta)="s" or ASU.To_String(respuesta)="si" then
				fin_descarga:=False;
				Tiempo_Inicial:=Ada.Calendar.Clock;
				--Creamos el archivo en la carpeta de nuestro nodo e iniciamos las variables necesarias para la perfecta ejecucción del programa
				S_IO.Create(Fichero_Destino,S_IO.Out_file, ASU.To_String(gnutelight_handler.Directorio) & "/"& ASU.To_String(FILE_NAME));
				EP_SVC_peer:=LLU.Build(LLU.To_IP(ASU.To_String(maquina_SVC)),Integer'Value(Asu.To_String(puerto_SVC)));
				BLOCK_SIZE:=1024;
				intentos:=0;
				vent_vacia:=0;
				
				loop
				--***INICIO DE LA DESCARGA***
				--Empezamos llenando la ventana para enviarsela al nodo de respuesta.
				--Calculamos los tiempos de retransmisión y si hace falta se retransmite, enviando de nuevo un DATAREQ.
			
					Tiempo_Peticion:=Ada.Calendar.Clock;--Se guarda el tiempo de inicio de descarga
					--***ENVIO***
					if Fin_descarga=False then--condicion necesaria para que el programa deje de pedir bloques una vez terminado
						for x in 1..ventana loop
							if v(x).POS_BLOCK=0 then--para primera posicion enviar el DATAREQ
							--Vamos a enviar los bloques con el siguiente formarto:
							--|DATAREQ| | OPTIONS| | EP_RES| | FILE_NAME| | BLOCK_POS| | BLOCK_SIZE| |SIZEREQ|
								LLU.Reset(Buffer);
								Message_Type'Output(Buffer'Access, DATAREQ);
								Natural'Output(Buffer'Access, OPTIONS);
								LLU.End_Point_Type'Output(Buffer'Access, EP_RES);
								ASU.Unbounded_String'Output(Buffer'Access, FILE_NAME);
								Positive'Output(Buffer'Access, BLOCK_POS);
								Positive'Output(Buffer'Access, BLOCK_SIZE);
								Option_Type'Output(Buffer'Access, SIZEREQ);

								pantalla.Poner_Color(pantalla.Verde);
								Ada.Text_IO.Put_Line ("ENVIANDO posicion"& Positive'Image(BLOCK_POS));
								v(x).POS_BLOCK:=BLOCK_POS;
								v(x).TIempo_Peticion:=Ada.Calendar.Clock ;--TIEMPO ACTUAL
								--Mostramos la ventana cada vez que introducimos una nueva posición de bloque
								Mostrar_Ventana(v, ventana);
								LLU.Send(EP_SVC_peer,Buffer'Access);
								BLOCK_POS:=BLOCK_SIZE+BLOCK_POS;
							end if;--POS_BLOCK
					end loop;
				end if;--Fin_descarga
			
				LLU.Reset(Buffer);
				--***CALCULO DE TIEMPOS***
				--Es imprescindible calcular los tiempos para la retransmisión necesaria de bloques
				--Por lo tanto, si el tiempo del bloque que ya ha sido pedido se pasa, se iguala a un nuevo tiempo para el plazo de retransmisión
				Tiempo_Anterior:=Ada.Calendar.Clock;
				for x in 1..ventana loop
					if Tiempo_Anterior>v(x).Tiempo_Peticion and v(x).POS_BLOCK/=0 then
						Tiempo_Anterior:=v(x).Tiempo_Peticion;
					end if;
				end loop;
			
				Tiempo_Llegada:=(Tiempo_Anterior+plazo_ret)-Tiempo_Peticion;

				LLU.Reset(Buffer);
				LLU.Receive(EP_RES,Buffer'Access,Tiempo_Llegada,Expired);--se recibe entre el tiempo de llegada y el plazo expirado
			
			--***REENVIO****
				if Expired then
					--Se ha vencido el plazo para obtener un mensaje DATA, por lo que se hace el reenvio
					intentos:=intentos+1;
					pantalla.Poner_Color(pantalla.Rojo);
					for x in 1..ventana loop
						if (v(x).Tiempo_Peticion=Tiempo_Anterior) and v(x).POS_BLOCK/=0 then
							LLU.Reset(Buffer);
							Message_Type'Output(Buffer'Access, DATAREQ);
							Natural'Output(Buffer'Access, OPTIONS);
							LLU.End_Point_Type'Output(Buffer'Access, EP_RES);
							ASU.Unbounded_String'Output(Buffer'Access, FILE_NAME);
							Positive'Output(Buffer'Access, v(x).POS_BLOCK);
							Positive'Output(Buffer'Access, BLOCK_SIZE);
							Option_Type'Output(Buffer'Access, SIZEREQ);
							pantalla.Poner_Color(pantalla.Magenta);
							Ada.Text_IO.Put_Line ("RE-ENVIANDO posicion"& Integer'Image(v(x).POS_BLOCK) &"--->INTENTO["& Integer'Image(intentos)&"]");					
							v(x).TIempo_Peticion:=Ada.Calendar.Clock ;--TIEMPO ACTUAL
						   Mostrar_Ventana(v, ventana);
							LLU.Send(EP_SVC_peer,Buffer'Access);
							LLU.Reset(Buffer);
						end if;--v(x)
					end loop;--ventana
						
				else
			
				recibido:=Message_Type'Input(Buffer'Access);
	
				--***RECIBIR***
				if recibido=DATA then
					--Se reciben los bloques DATA con el siguiente formato:
					--|DATA| | OPTIONS| | FILE_NAME_NEW| | BLOCK_POS_NEW| | BLOCK_SIZE_NEW| | SIZE| |BYTES|
					OPTIONS:=Natural'Input(Buffer'Access);
					FILE_NAME_NEW:=ASU.Unbounded_String'Input(Buffer'Access);

					--Algoritmo para saber si es bueno el archivo:
					--comprobamos si el archivo pedido es el mismo que el que hemos recibido, si es así, continuamos la descarga, si no,
					--ignoramos el paquete.
					if (ASU.To_String(FILE_NAME)=ASU.To_String(FILE_NAME_NEW)) then
						BLOCK_POS_NEW:=Positive'Input(Buffer'Access);
						BLOCK_SIZE_NEW:=Positive'Input(Buffer'Access);
					
						Longitud:=Ada.Streams.Stream_Element_Offset(BLOCK_SIZE_NEW);
						Ultimo:=S_IO.Positive_Count(BLOCK_POS_NEW);
				
						pantalla.Poner_Color(pantalla.Amarillo);
						Ada.Text_IO.Put_Line("RECIBIDA POSICION:" & Positive'Image(BLOCK_POS_NEW));
						--Copiamos el archivo donde hemos creado nuestro archivo primitivo
						if Integer(Longitud) /=0 and recibido =DATA then
							BLOCK_DATA:=Ada.Streams.Stream_Element_Array'Input (Buffer'Access);
							S_IO.Write(Fichero_Destino,BLOCK_DATA(1..Longitud),Ultimo);
							Ada.Text_IO.Put_Line ("TAMANIO DE ESTE BLOQUE"& Positive'Image(BLOCK_SIZE_NEW));
							tamano:= tamano + BLOCK_SIZE_NEW;
							--Ada.Text_IO.Put_Line("***************=>" & Integer'Image(tamano));
						else 
							fin_descarga:=True;
						end if;
						if OPTIONS=1 then
							recibido3:=Option_Type'Input(Buffer'Access);--SIZE
							BYTES:=Natural'Input(Buffer'Access);
							Ada.Text_IO.Put_Line(Integer'Image(tamano/BYTES * 100) & "% completado");
						end if;--OPTIONS
				--***ALGORITMO DE VENTANA***	
						Limpiar_Ventana(v, ventana, vent_vacia);
						Mostrar_Ventana(v, ventana);
					end if;--nombres de fichero
			
					elsif recibido=DATAERR then--DATAERR
				--Si recibimos un DATAERR, la estructura de este mensaje es:
				--|DATAERR| | OPTIONS| | FILE_NAME_NEW| | BLOCK_POS_NEW| |FILE_NOT_FOUND//BLOCK_NOT_FOUND|
						OPTIONS:=Natural'Input(Buffer'Access);
						FILE_NAME_NEW:=ASU.Unbounded_String'Input(Buffer'Access);
				--Al igual que antes vemos si el nombre es el correcto, si no, lo consideramos basura, esto sirve para el caso de
				-- descargas sucesivas
						if (ASU.To_String(FILE_NAME)=ASU.To_String(FILE_NAME_NEW)) then
							BLOCK_POS_NEW:=Positive'Input(Buffer'Access);
							recibido2:=Option_Type'Input(Buffer'Access);
						   if recibido2=FILE_NOT_FOUND then
						   	pantalla.Poner_Color(pantalla.Rojo);
						    	Ada.Text_IO.Put_line("Error en la recepcion del archivo. Archivo inexistente.");
					   	else
							pantalla.Poner_Color(pantalla.Rojo);
							Ada.Text_IO.Put_line("Recibido DATAERR: Bloque " &Positive'Image(BLOCK_POS_NEW) &  " no encontrado.");
							fin_descarga:=True;
							--***ALGORITMO DE VENTANA***
							Limpiar_Ventana(v, ventana, vent_vacia);
						--Mostramos la ventana por última vez para ver el total de posicions de bloque enviadas
							Mostrar_Ventana(v, ventana);
						end if;--recibido2
					end if;--nombres de fichero
				end if;--DATA o DATAERR
		end if;--expired	

	--***CONDICION DE SALIDA DEL BUCLE DE DESCARGA***
		exit when ((vent_vacia=ventana) and fin_descarga) or recibido2=FILE_NOT_FOUND;
		end loop;--descarga
		if recibido2=FILE_NOT_FOUND then	
			Ada.Text_IO.Put_Line("Tamanio total transferido 0 bytes.");
			S_IO.Close(Fichero_Destino);
			recibido2:=BLOCK_NOT_FOUND;
		else
			Ada.Text_IO.Put_Line("Tamanio total transferido " & Integer'Image(BYTES) & " bytes.");
			S_IO.Close(Fichero_Destino);
		end if;
		Tiempo_Fin:= Ada.Calendar.Clock;
		pantalla.Poner_Color(pantalla.Blanco);
		Ada.Text_IO.Put("La transferencia del archivo " & ASU.To_String(FILE_NAME) &" ha tardado: ");
		pantalla.Poner_Color(pantalla.Amarillo);
		Ada.Text_IO.Put_Line(Integer'Image(Integer(Tiempo_Fin-Tiempo_Inicial)) & " segundos");
		
		pantalla.Poner_Color_Fondo(pantalla.Naranja);
		pantalla.Poner_Color(pantalla.Blanco);
		Ada.Text_IO.Put_Line("**************************************FIN DE DESCARGA*******************************************");
		pantalla.Poner_Color_Fondo(pantalla.Normal);		
		
		end if;--respuesta
	end if;--DESCARGA

	if ASU.index(opciones,"chat")=1 then
			LLU.Reset(Buffer);
			BLOCK_POS:=1;
			comando:=opciones;
			Separar_Comandos(opciones, comando," ");
			Separar_Comandos(opciones, maquina_SVC," ");
			puerto_SVC:=opciones;
			pantalla.Poner_Color(pantalla.Verde); -- hacer el color NARANJA, POR FAVOR !!!
			Ada.Text_IO.Put_Line("**************************************CHAT*******************************************");
			Ada.Text_IO.Put_Line ("Se va a proceder a establecer una comunicación via chat segun esta configuracion, ¿esta seguro? (s/n)");
			Ada.Text_IO.Put("Maquina -->");
			pantalla.Poner_Color(pantalla.Blanco);
			Ada.Text_IO.Put_Line (ASU.To_String(maquina_SVC));
			pantalla.Poner_Color(pantalla.Azul_Claro);
			Ada.Text_IO.Put("Puerto -->");
			pantalla.Poner_Color(pantalla.Blanco);
			Ada.Text_IO.Put_Line(ASU.To_String(puerto_SVC));
			pantalla.Poner_Color(pantalla.Azul_Claro);
			
			pantalla.Poner_Color(pantalla.Amarillo);
			Ada.Text_IO.Put("Respuesta>");
			pantalla.Poner_Color(pantalla.Blanco);
			respuesta:=ASU_IO.Get_Line;
			if ASU.To_String(respuesta)="s" or ASU.To_String(respuesta)="si" then
				fin_chat:=FALSE;
				CHAT_FIN:=FALSE;

				EP_SVC_peer:=LLU.Build(LLU.To_IP(ASU.To_String(maquina_SVC)),Integer'Value(Asu.To_String(puerto_SVC)));

				Ada.Text_IO.Put_Line ("Para finalizar escriba termina");
				
				loop
					pantalla.Poner_Color(pantalla.Amarillo);
					Ada.Text_IO.Put("Nodo" & ASU.To_String(ASU.To_Unbounded_String(ACL.Argument(1))) &">");
					pantalla.Poner_Color(pantalla.Blanco);
					CONTENIDO:=ASU_IO.Get_Line;
					if ASU.To_String(CONTENIDO)="termina" then
						Ada.Text_IO.Put_Line ("FIN DEL CHAT. Finalizando la conexion...");
						CHAT_FIN:=TRUE;
						--ENVIAR FIN_CHAT
							Message_Type'Output(Buffer'Access, CHAT);
							LLU.End_Point_Type'Output(Buffer'Access, EP_RES);
							ASU.Unbounded_String'Output(Buffer'Access, CONTENIDO);
							Boolean'Output(Buffer'Access, CHAT_FIN);

							LLU.Send(EP_SVC_peer,Buffer'Access);
							LLU.Reset(Buffer);
							fin_chat:=TRUE;
					else
						if ASU.To_String(CONTENIDO)="" then
							LLU.Reset(Buffer);
						else

					--Vamos a enviar los bloques con el siguiente formarto:
							--|CHAT| | EP_RES| | CONTENIDO| |CHAT_FIN|
								LLU.Reset(Buffer);
								Message_Type'Output(Buffer'Access, CHAT);
								LLU.End_Point_Type'Output(Buffer'Access, EP_RES);
								ASU.Unbounded_String'Output(Buffer'Access, CONTENIDO);
								Boolean'Output(Buffer'Access, CHAT_FIN);

								LLU.Send(EP_SVC_peer,Buffer'Access);
								

								LLU.Reset(Buffer);

							end if;
					end if;

				
				exit when fin_chat;				
				end loop;

			end if;
			
	end if;
	
	exit when finaliza;
	end loop;
	
	exception
when Usage_Error =>
	pantalla.Poner_Color(pantalla.Rojo);
	Ada.Text_IO.Put_Line ("Parametros no validos.");
	pantalla.Poner_Color(pantalla.Blanco);
	LLU.Finalize;

when Separa_Error =>
	pantalla.Poner_Color(pantalla.Rojo);
   Ada.Text_IO.Put_Line ("Parametros mal introducidos.");
	LLU.Finalize;

when Ex:others =>
		pantalla.Poner_Color(pantalla.Rojo);
    Ada.Text_IO.Put_Line ("Excepcion imprevista: " &
                          Ada.Exceptions.Exception_Name(Ex) & " en: " &
                          Ada.Exceptions.Exception_Message(Ex));
    LLU.Finalize;

end Gnutelight;
