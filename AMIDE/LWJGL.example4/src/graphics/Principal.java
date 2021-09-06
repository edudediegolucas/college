package graphics;

import java.io.IOException;
import java.util.ArrayList;

import sounds.Sounds;

import network.EchoWorker;
import network.NioServer;


public class Principal {
	
	public static void main(String[] args){
		//Motor del juego
		GameEngine gEngine = new GameEngine();
		
		try {
			//Se inicia openGL
			new Thread(gEngine).start();
			
			System.out.println("*** NEW GAME ***");
			
			try {
				ArrayList<EchoWorker> workers = new ArrayList();
				EchoWorker worker1 = new EchoWorker();
				EchoWorker worker2 = new EchoWorker();
				EchoWorker worker3 = new EchoWorker();
				EchoWorker worker4 = new EchoWorker();
				EchoWorker worker5 = new EchoWorker();
				new Thread(worker1).start();
				new Thread(worker2).start();
				new Thread(worker3).start();
				new Thread(worker4).start();
				new Thread(worker5).start();
				workers.add(worker1);
				workers.add(worker2);
				workers.add(worker3);
				workers.add(worker4);
				workers.add(worker5);
				//Se añaden a la lista para el servidor
				new Thread(new NioServer(null, 9090, workers, gEngine)).start();
			} catch (IOException e) {
				e.printStackTrace();
			}
			
			
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
