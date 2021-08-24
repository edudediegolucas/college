package PracticaFinal.es.urjc.escet.gsyc.http;

import java.io.IOException;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.Random;
import java.util.HashMap;

import PracticaFinal.es.urjc.escet.gsyc.peer.*;
import PracticaFinal.es.urjc.escet.gsyc.rmi.*;

public class ServidorHttpDelTerminal extends Thread {

	private int portNumber;
	private Random credencial;
	private HashMap <String,String> usuarios;
	private HashMap <String,Peer> terminales;
	private String Directorio_Usuarios;
	private Registrador registro;
	
	public ServidorHttpDelTerminal(int portNumber, Random credencial, HashMap <String,String> usuarios, HashMap <String,Peer> terminales,
			String Directorio_Usuarios,Registrador registro){
		this.portNumber = portNumber;
		this.credencial = credencial;
		this.usuarios = usuarios;
		this.terminales= terminales;
		this.Directorio_Usuarios = Directorio_Usuarios;
		this.registro = registro;
	}
	
	public void run() {

		// Declaramos server sobre del bloque try{}catch{} para poder utilizarlo
		// fuera del mismo
		ServerSocket server = null;
		try {
			server = new ServerSocket(this.portNumber); //se ata al puerto especificado
			System.out.println("El servidor HTTP del Terminal se ha atado satisfactoriamente al puerto "+ this.portNumber);
			System.out.println("Esperando conexiones...");
		} catch (IOException e) {
			// Esta excepcion indica que, seguramente, ha habido algun problema
			// al atarse al puerto especificado
			// Consideramos que esta excepcion es grave, por lo que el programa
			// no puede continuar.
			System.out
					.println("ERROR: No se puede crear un ServerSocket en el puerto "
							+ this.portNumber);
			System.out.println("Los detalles del error son los siguientes:");
			System.out.println(e.getMessage());
			e.printStackTrace();
			System.exit(-1);
		}

		// Aceptamos conexiones y las servimos, cada una en su Thread
		while (true) {
			try {
				Socket conn = server.accept();
				GestorDePeticionesHttp gestor = new GestorDePeticionesHttp(conn,credencial,Directorio_Usuarios, usuarios,terminales, registro);
				gestor.start();
			} catch (IOException e) {
				// Esta excepcion indica que algo ha ido mal en el
				// establecimiento de la conexion
				// Quizas otras conexiones puedan funcionar, por lo que dejamos
				// que la aplicacion continue
				// De todos modos, informamos de que algo no ha ido bien al
				// usuario.
				System.out.println("AVISO: Se ha producido un error estableciendo una conexion");
				System.out.println("Los detalles del problema son los siguientes:");
				System.out.println(e.getMessage());
				e.printStackTrace();
			}// try
		}// while
	}// run
}// class
