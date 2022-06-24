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

--gnutelight_handler.adb

--***PAQUETES A UTILIZAR****
with Lower_Layer_UDP;
with Ada.Text_IO ;
with Ada.Strings.Unbounded;
with Ada.Strings.Unbounded.Text_IO;
with Ada.Command_Line;
with Ada.Streams;
with Ada.Streams.Stream_IO ;
with Gnat.IO_Aux;
with Gnutelight_Contacts;
with pantalla;



package body Gnutelight_Handler is


package LLU renames Lower_Layer_UDP;
package ASU renames Ada.Strings.Unbounded;
package ASU_IO renames Ada.Strings.Unbounded.Text_IO;
package S_IO renames Ada.Streams.Stream_IO;
package ACL renames Ada.Command_Line ;
package GIA renames Gnat.IO_Aux;

--***INICIO DEL PROCEDIMIENTO***
-- procedimiento que se ejecutara cada vez que llege un mensaje
procedure My_Handler (From:       in LLU.End_Point_Type;
                       To:         in LLU.End_Point_Type;
                       Buff_A: access LLU.Buffer_Type) is

--***VARIABLES***
EP_RES,EP_SVC: LLU.End_Point_Type;
FILE_NAME, CONTENIDO: ASU.Unbounded_String;
Fichero_Destino: S_IO.File_Type;
Ultimo: S_IO.Positive_Count;

Nombre_Fichero: S_IO.File_Type;
Longitud: Ada.Streams.Stream_Element_Offset ;
BLOCK_DATA:Ada.Streams.Stream_Element_Array (1..1024);
contactos:Natural:=1;
OPTIONS:Natural:=1;
BLOCK_POS:Positive;
BLOCK_SIZE:Positive;
BYTES:Natural;
Tam:S_IO.Count;

CHAT_FIN:boolean;

--***TIPOS DE MENSAJE A ENVIAR***
type Message_Type is (HELLO,WELCOME,DATAREQ,DATA,DATAERR, CHAT);
type Option_Type is (SIZEREQ,SIZE,FILE_NOT_FOUND,BLOCK_NOT_FOUND);

recibido:Message_Type;
recibido2:Option_Type;

My_Contacts: Gnutelight_Contacts.Contacts_List_Type;

        
begin
  
 	--***ENVIO MENSAJE "WELCOME"****
	--Tras recibir un mensaje HELLO de un nodo cualquiera, es obligación de este nodo enviar un mensaje WELCOME para conectarse y atarse a él
	--Estructura del mensaje:
	----|WELCOME| | CONTACTOS_GNUTELIGHT| | EP_RES CONTACTO|
	recibido:=Message_Type'Input(Buff_A);
	if recibido=HELLO then
		EP_RES:=LLU.End_Point_Type'Input (Buff_A);
		EP_SVC:=LLU.End_Point_Type'Input(Buff_A);
		Gnutelight_Contacts.Add_One (gnutelight_handler.contactos,EP_SVC);
		LLU.Reset (Buff_A.all);
		Message_Type'Output(Buff_A, WELCOME);
		Integer'Output(Buff_A,Gnutelight_Contacts.Total (gnutelight_handler.contactos));
		for x in 1..Gnutelight_Contacts.Total (gnutelight_handler.contactos) loop
			LLU.End_Point_Type'Output (Buff_A,Gnutelight_Contacts.Get_one(gnutelight_handler.contactos,x));
		end loop;                      
                
		LLU.Send(EP_RES, Buff_A);
		pantalla.Poner_Color(pantalla.Verde);
		Ada.Text_IO.Put_Line ("gnutelight listo");
	end if;   
            
--***DATAREQ***
	if recibido = DATAREQ then  
		OPTIONS:=Natural'Input(Buff_A);
		Ada.Text_IO.Put("Conexion establecida con---> " );
		EP_RES := LLU.End_Point_Type'Input(Buff_A);
		ASU.Text_IO.Put_Line(ASU.To_Unbounded_String(LLU.Image(EP_RES)));
		FILE_NAME:= ASU.Unbounded_String'Input(Buff_A);
		pantalla.Poner_Color(pantalla.Amarillo);
		Ada.Text_IO.Put_Line ("Archivo pedido: " & ASU.To_String(FILE_NAME));
		BLOCK_POS:=Positive'Input(Buff_A);
		BLOCK_SIZE:=Positive'Input(Buff_A);
		
		if OPTIONS=1 then
			recibido2:=Option_Type'Input(Buff_A);--SIZEREQ
		end if;
		
		Ada.Text_IO.Put_line("DATAREQ recibido!");
		
		--***DATAERR***
		if OPTIONS=1 then
			--Algoritmo que nos indica si el archivo existe o no.
			--Si no existe, debe de enviar un mensaje FILE_NOT_FOUND
			--Si existe, debe de seguir con la descarga del archivo y por tanto lo lee
			if not GIA.File_Exists(ASU.To_String(gnutelight_handler.Directorio) & "/" & ASU.To_String(FILE_NAME)) then       		LLU.Reset(Buff_A.all);
				Message_Type'Output(Buff_A, DATAERR);
				Natural'Output(Buff_A, OPTIONS);
				ASU.Unbounded_String'Output(Buff_A, FILE_NAME);
				Positive'Output(Buff_A, BLOCK_POS);
				Option_Type'Output(Buff_A, FILE_NOT_FOUND);
				LLU.Send(EP_RES, Buff_A);
				pantalla.Poner_Color(pantalla.Rojo);
				Ada.Text_IO.Put_line("Error en el envio del archivo. Archivo inexistente.");	
			else		
			
			--Abrimos el archivo
			S_IO.Open(Nombre_Fichero,S_IO.In_file, ASU.To_String(gnutelight_handler.Directorio) & "/" & ASU.To_String(FILE_NAME));
			Tam:=S_IO.Size(Nombre_Fichero);
			--Y vemos que tamaño tiene
			BYTES:=Natural(Tam);
			pantalla.Poner_Color(pantalla.Verde);
			Ada.Text_IO.Put_line("POSICION DE BLOQUE RECIBIDA==>["& Positive'Image(BLOCK_POS) &"]");
			Ada.Text_IO.Put_line(" "); 
						
			--***DATA***
		
			if Integer(BLOCK_POS)<Integer(BYTES) then
				Ultimo:=S_IO.Positive_Count(BLOCK_POS);
				S_IO.Read(Nombre_Fichero, BLOCK_DATA, Longitud, Ultimo);
				BLOCK_SIZE:=Positive(Longitud);
				if Positive(BLOCK_SIZE)<1024 then
					pantalla.Poner_Color(pantalla.Azul);
					Ada.Text_IO.Put_line("TAMANIO DE ESTE BLOQUE==>["& Positive'Image(BLOCK_SIZE) & "] bytes.");
				else
					pantalla.Poner_Color(pantalla.Verde);
					Ada.Text_IO.Put_line("TAMANIO DE ESTE BLOQUE==>["& Positive'Image(BLOCK_SIZE) & "] bytes.");
				end if;--BLOCK_SIZE
			--Se envian el resto de modulos del paquete
			LLU.Reset(Buff_A.all);			
			Message_Type'Output(Buff_A, DATA);
			Positive'Output(Buff_A, OPTIONS);
			ASU.Unbounded_String'Output(Buff_A, FILE_NAME);
			Positive'Output(Buff_A, BLOCK_POS);
			Positive'Output(Buff_A, BLOCK_SIZE);

			if Integer(Longitud) /=0 then				Ada.Streams.Stream_Element_Array'Output(Buff_A, BLOCK_DATA);
				if OPTIONS=1 then
					Option_Type'Output(Buff_A, SIZE);
					Natural'Output(Buff_A, BYTES);
				end if;
				S_IO.Close(Nombre_Fichero);
      		LLU.Send(EP_RES, Buff_A);
      	end if;--Longitud
    		
			else--se debe enviar un DATAERR con BLOCK_NOT_FOUND, indicando que ha llegado un bloque con tamaño mayor que el archivo a descargar
    			LLU.Reset(Buff_A.all);
    			Message_Type'Output(Buff_A, DATAERR);
				Natural'Output(Buff_A, OPTIONS);
				ASU.Unbounded_String'Output(Buff_A, FILE_NAME);
				Positive'Output(Buff_A, BLOCK_POS);
				Option_Type'Output(Buff_A, BLOCK_NOT_FOUND);
				LLU.Send(EP_RES, Buff_A);
				LLU.Reset(Buff_A.all);
				pantalla.Poner_Color(pantalla.Rojo);
				Ada.Text_IO.Put_line("Enviando BLOCK_NOT_FOUND:" & Integer'Image(BLOCK_POS));    
				S_IO.Close(Nombre_Fichero);
      		LLU.Send(EP_RES, Buff_A);
    			end if;--BLOCK_POS
			end if;--existe fichero
		end if;--OPTIONS
	end if;--DATAREQ

	if recibido=CHAT then
		EP_RES:=LLU.End_Point_Type'Input (Buff_A);
		CONTENIDO:= ASU.Unbounded_String'Input(Buff_A);
		CHAT_FIN:= Boolean'Input(Buff_A);
		LLU.Reset (Buff_A.all);
		if CHAT_FIN then
			Ada.Text_IO.Put_Line(" CONEXION DE CHAT CERRADA POR EL OTRO NODO ");
		else
			pantalla.Poner_Color(pantalla.Verde);
			Ada.Text_IO.Put_Line(" ");
			pantalla.Poner_Color(pantalla.Rojo);			
			Ada.Text_IO.Put("Nodo =>"& ASU.To_String(ASU.To_Unbounded_String(LLU.Image(EP_RES))) &" >");
			pantalla.Poner_Color(pantalla.Blanco);			
			Ada.Text_IO.Put_Line(ASU.To_String(CONTENIDO));
		end if;		
	end if;   



end My_Handler;

end Gnutelight_Handler;
