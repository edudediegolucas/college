{********************************************************************************
*										*
* Módulo: main.pas								*
* Tipo: Programa(+) Interfaz-Implementación TAD () Otros() 			*
* Autor/es: Eduardo de Diego Lucas						*
* Fecha de actualización: 3/10/2010						*
* Descripción: Programa que utiliza lista de numeros				*
*										*
*********************************************************************************}

PROGRAM MAIN;

	USES ELEMENTO, LISTADIN; {LISTADIN,LISTADIN2,LISTAEST}
	
	VAR
		lista,lista2:TLista;
		a:TElemento;
BEGIN
	
	WRITELN;
	WRITELN('***********************************');
	WRITELN('*                                 *');
	WRITELN('*      PROGRAMA DE NUMEROS        *');
	WRITELN('*SISTEMA CREADO A PARTIR DE LISTAS*');
	WRITELN('*                                 *');
	WRITELN('*Creado por Eduardo de Diego Lucas*');
	WRITELN('*                                 *');
	WRITELN('***********************************');
	WRITELN;
	WRITELN('0.Creamos la lista desde cero.');
	CrearVacia(lista);
	READLN;
	WRITELN('1.Lista de numeros con secuencia: 7-9-6-8-12-5-4-0');
	Construir(lista, 7);
	InsertarFinal(lista,9);
	InsertarFinal(lista,6);
	InsertarFinal(lista,8);
	InsertarFinal(lista,12);
	InsertarFinal(lista,5);
	InsertarFinal(lista,4);
	InsertarFinal(lista,0);
	READLN;
	WRITELN('2.Numero de elementos en la lista: ', Longitud(lista));
	READLN;
	WRITELN('3.Comprobacion numero 8 en lista.');
	READLN;
	IF Pertenece(lista,8) THEN 
		WRITELN('->El numero 8 esta en la lista.')
	ELSE
		WRITELN('->El numero 8 no esta en la lista.');
	WRITELN;	
	WRITELN('4.Comprobacion numero 3 en lista.');
	READLN;
	IF Pertenece(lista,3) THEN 
		WRITELN('->El numero 3 esta en la lista.')
	ELSE
		WRITELN('->El numero 3 no esta en la lista.');
	WRITELN;	
	WRITELN('5.Insercion numero 3 en la lista.');
	READLN;
	Construir(lista,3);
	WRITELN('6.Numero de elementos en la lista: ', Longitud(lista));
	READLN;
	WRITELN('7.Ultimo elemento de la lista:');
	Ultimo(lista,a);
	WRITELN('->El ultimo elemento de la lista es: ', a );
	WRITELN;	
	WRITELN('8.Mostramos todos los elementos de la lista.');
	READLN;
	Mostrar(lista);
	WRITELN('9.Borramos el numero 0');
	READLN;
	BorrarElemento(lista,0);
	WRITELN('10.Mostramos todos los elementos de la lista.');
	READLN;
	Mostrar(lista);
	WRITELN('11.Insercion numero 2 en la lista.');
	READLN;
	InsertarFinal(lista,2);
	WRITELN('12.Numero de elementos en la lista: ', Longitud(lista));
	READLN;
	WRITELN('13.Ultimo elemento de la lista:');
	Ultimo(lista,a);
	WRITELN('->El ultimo elemento de la lista es: ', a );
	WRITELN;	
	WRITELN('14.Creamos una nueva lista con la secuencia: 4-0');
	READLN;	
	CrearVacia(lista2);
	Construir(lista2, 4);
	InsertarFinal(lista2, 0);
	WRITELN('15.Concatenamos ambas listas.');
	READLN;
	Concatenar(lista2,lista);
	WRITELN('16.Mostramos todos los elementos de la lista concatenada.');
	READLN;
	Mostrar(lista);
	WRITELN('17.Numero de elementos en la lista: ', Longitud(lista));
	READLN;
	WRITELN;
	WRITELN;
	WRITELN('Fin del programa. Hasta la proxima!');
		
	READLN;

END.
