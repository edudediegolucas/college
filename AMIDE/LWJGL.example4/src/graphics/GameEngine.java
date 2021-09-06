package graphics;

import static org.lwjgl.opengl.GL11.GL_COLOR_BUFFER_BIT;
import static org.lwjgl.opengl.GL11.GL_DEPTH_BUFFER_BIT;
import static org.lwjgl.opengl.GL11.GL_DEPTH_TEST;
import static org.lwjgl.opengl.GL11.GL_LIGHTING;
import static org.lwjgl.opengl.GL11.GL_MODELVIEW;
import static org.lwjgl.opengl.GL11.GL_PROJECTION;
import static org.lwjgl.opengl.GL11.glClear;
import static org.lwjgl.opengl.GL11.glClearColor;
import static org.lwjgl.opengl.GL11.glDisable;
import static org.lwjgl.opengl.GL11.glEnable;
import static org.lwjgl.opengl.GL11.glFlush;
import static org.lwjgl.opengl.GL11.glLoadIdentity;
import static org.lwjgl.opengl.GL11.glMatrixMode;
import static org.lwjgl.opengl.GL11.glViewport;
import static org.lwjgl.util.glu.GLU.gluLookAt;
import static org.lwjgl.util.glu.GLU.gluPerspective;


import java.util.ArrayList;

import org.lwjgl.LWJGLException;
import org.lwjgl.input.Keyboard;
import org.lwjgl.input.Mouse;
import org.lwjgl.opengl.Display;
import org.lwjgl.opengl.DisplayMode;

import sounds.Sounds;

public class GameEngine implements Runnable{
	
	public static final int DISPLAY_WIDTH = 800;
	public static final int DISPLAY_HEIGHT = 600;
	public static final boolean FULLSCREEN = false;
	public static final float POSZ = -35.0f;
	
	public ArrayList<GameObject> objects = new ArrayList<GameObject>();
	
	public ArrayList<GameObject> outObjects = new ArrayList<GameObject>();
	
	//Camara
	private float eyeX,eyeY,eyeZ = 0.0f;
	private float xLookingAt = 0.0f, yLookingAt = 0.0f, zLookingAt = POSZ;
	private float xUpVector = 0.0f, yUpVector = 1.0f, zUpVector = 0.0f;
	
	//Texturas
	private Texture boxTex = null;
	private Texture spaceTex = null;
	private Texture shipTex = null;
	private TextureLoader texLoader = new TextureLoader();
	
	//Joypad
	//private GamePadController gpController = new GamePadController();
	
	public void destroy() {
		//Methods already check if created before destroying.
		Mouse.destroy();
		Keyboard.destroy();
		Display.destroy();
	}
	public void initGL() {
		//2D Initialization
		glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
		glEnable(GL_DEPTH_TEST);
		glDisable(GL_LIGHTING);
	}
	
	public void processKeyboard() {
		float distance = 0.5f;
		
		//JOYPAD
		//Iniciamos el joypad
//		gpController.poll();
//
//		//Cruceta
//		int direccion = gpController.getHatDir();
//		if(direccion == gpController.NORTH){
//			eyeZ -= distance;
//		}
//		if(direccion == gpController.NW){
//			eyeZ -= distance;
//			eyeX -= distance;
//		}
//		if(direccion == gpController.NE){
//			eyeZ -= distance;
//			eyeX += distance;
//		}
//		if(direccion == gpController.SOUTH){
//			eyeZ += distance;
//		}
//		if(direccion == gpController.SW){
//			eyeZ += distance;
//			eyeX -=distance;
//		}
//		if(direccion == gpController.SE){
//			eyeZ += distance;
//			eyeX +=distance;
//		}
//		if(direccion == gpController.WEST){
//			eyeX -= distance;
//			xLookingAt -= distance;
//		}
//		if(direccion == gpController.EAST){
//			eyeX += distance;
//			xLookingAt += distance;
//		}
//
//		//Analogico izquierdo
//		int movimiento = gpController.getXYStickDir();
//		if(movimiento == gpController.NORTH){
//			yLookingAt += distance;
//		}
//		if(movimiento == gpController.NW){
//			yLookingAt += distance;
//			xLookingAt -= distance;
//		}
//		if(movimiento == gpController.NE){
//			yLookingAt += distance;
//			xLookingAt += distance;
//		}
//		if(movimiento == gpController.SOUTH){
//			yLookingAt -= distance;
//		}
//		if(movimiento == gpController.SW){
//			yLookingAt -= distance;
//			xLookingAt -= distance;
//		}
//		if(movimiento == gpController.SE){
//			yLookingAt -= distance;
//			xLookingAt += distance;
//		}
//		if(movimiento == gpController.WEST){
//			xLookingAt -= distance;
//		}
//		if(movimiento == gpController.EAST){
//			xLookingAt += distance;
//		}
//
//		//Botones
//		boolean[] buttons = gpController.getButtons();
//		if(gpController.isButtonPressed(6)){
//			yLookingAt += distance;
//			eyeY += distance;
//		}
//		if(gpController.isButtonPressed(5)){
//			yLookingAt -= distance;
//			eyeY -= distance;
//		}
//
//		//Cambiamos la velocidad
//		if(gpController.isButtonPressed(7)){
//			updateVelocidad(0);
//		}
//		if(gpController.isButtonPressed(8)){
//			updateVelocidad(1);
//		}
		
		
		
		
		
		
		//TECLADO
		if (Keyboard.isKeyDown(Keyboard.KEY_DOWN)) {
			eyeZ += distance;
		}
		if (Keyboard.isKeyDown(Keyboard.KEY_UP)) {
			eyeZ -= distance;
		}
		if (Keyboard.isKeyDown(Keyboard.KEY_LEFT)) {
			xLookingAt -= distance;
		}
		if (Keyboard.isKeyDown(Keyboard.KEY_RIGHT)) {
			xLookingAt += distance;
		}
		if(Keyboard.isKeyDown(Keyboard.KEY_A)){
			yLookingAt += distance;
			eyeY += distance;
        }
		if(Keyboard.isKeyDown(Keyboard.KEY_S)){
			yLookingAt -= distance;
			eyeY -= distance;
		}
	}
	
	public void resizeGL() {
		glMatrixMode(GL_PROJECTION);
		glLoadIdentity();
		glViewport(0, 0, DISPLAY_WIDTH, DISPLAY_HEIGHT);
		gluPerspective(45.0f, (float) DISPLAY_WIDTH / (float) DISPLAY_HEIGHT, 0.001f, 10000.0f);

		glMatrixMode(GL_MODELVIEW);
		glLoadIdentity();
	}
	
	public void run() {
		//last_tm = System.currentTimeMillis();
		
		//Display
		try {
			Display.setDisplayMode(new DisplayMode(DISPLAY_WIDTH, DISPLAY_HEIGHT));
			Display.setFullscreen(FULLSCREEN);
			Display.setTitle("Outer Rocks!");
			Display.create();

			//Keyboard
			Keyboard.create();
		} catch (LWJGLException e) {
			e.printStackTrace();
		}
		//OpenGL
		initGL();
		resizeGL();
		
		//Sonidos
		Sounds s = new Sounds();
		//Se inician los sonidos
		new Thread(s).start();
		
		try{
			//Cargamos las texturas
			boxTex = texLoader.getTexture("Rock.png");
			spaceTex = texLoader.getTexture("space.png");
			shipTex = texLoader.getTexture("ship.png");
			//Creamos los objetos: 1 espacio y 10 asteroides
			Space space = new Space(spaceTex);
			//SpaceShip nave = new SpaceShip(shipTex);
			Asteroid a1 = new Asteroid(boxTex);
			Asteroid a2 = new Asteroid(boxTex);
			Asteroid a3 = new Asteroid(boxTex);
			Asteroid a4 = new Asteroid(boxTex);
			Asteroid a5 = new Asteroid(boxTex);
			Asteroid a6 = new Asteroid(boxTex);
			Asteroid a7 = new Asteroid(boxTex);
			Asteroid a8 = new Asteroid(boxTex);
			Asteroid a9 = new Asteroid(boxTex);
			Asteroid a0 = new Asteroid(boxTex);
			//Los añadimos a la lista de objetos
			this.addObject(space);
			//this.addObject(nave);
			this.addObject(a1);
			this.addObject(a2);
			this.addObject(a3);
			this.addObject(a4);
			this.addObject(a5);
			this.addObject(a6);
			this.addObject(a7);
			this.addObject(a8);
			this.addObject(a9);
			this.addObject(a0);
			
			//Iniciamos los sonidos
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		while (!Display.isCloseRequested() && !Keyboard.isKeyDown(Keyboard.KEY_ESCAPE)) {
			if (Display.isVisible()) {
				processKeyboard();
				updateScene();
				renderScene();
				updateCamera();
			}else {
				if (Display.isDirty()) {
					renderScene();
				}
				try {
					Thread.sleep(100);
				}catch (InterruptedException ex) {
				}
			}
			Display.update();
			Display.sync(60);
        }
		s.playSound("haha.wav");
		System.out.println("*** GAME OVER ***");
    }
		
	public void renderScene() {
		//Preparamos todo
		glClearColor (0.0f, 0.0f, 0.0f, 0.0f);
		glClear (GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
		glMatrixMode(GL_PROJECTION);
		glMatrixMode(GL_MODELVIEW);
		glLoadIdentity();
		gluLookAt(eyeX, eyeY, eyeZ, xLookingAt, yLookingAt, zLookingAt, xUpVector, yUpVector, zUpVector);
		synchronized(objects){
			for (GameObject obj : objects) {
				obj.render();
			}
		}
		synchronized(outObjects){
			for (GameObject obj : outObjects) {
				obj.outrender();
			}
		}
		glFlush();
	}
	
	public void updateScene() {
		glClear(GL_COLOR_BUFFER_BIT);
		glLoadIdentity();
		synchronized(objects){
			for (GameObject obj : objects)
				obj.update();
		}
		synchronized(outObjects){
			for (GameObject obj : outObjects) {
				obj.outupdate();
			}
		}
	}
		
	public void updateCamera(){
		//Actualizo la camara
		if(eyeZ>99)
			eyeZ = 99.0f;
		if(eyeZ<-99)
			eyeZ = -99.0f;
		if(eyeY>99)
			eyeY = 99.0f;
		if(eyeY<-99)
			eyeY = -99.0f;
		if(eyeX>99)
			eyeX = 99.0f;
		if(eyeX<-99)
			eyeX = -99.0f;
		
		if(xLookingAt>99)
			xLookingAt = 99.0f;
		if(xLookingAt<-99)
			xLookingAt = -99.0f;
		if(yLookingAt>99)
			yLookingAt = 99.0f;
		if(yLookingAt<-99)
			yLookingAt = -99.0f;
		
	}
	
	public void addObject(GameObject obj) {
		synchronized(this.objects){
			this.objects.add(obj);
		}
    }
	
	public void addOutObject(GameObject obj) {
		synchronized(this.outObjects){
			this.outObjects.add(obj);
		}
    }
	
	public void updateVelocidad(int opcion){
		synchronized(objects){
			for (GameObject obj : objects){
				if(opcion == 0)
					obj.setV(obj.getV()-0.01f);
				else
					obj.setV(obj.getV()+0.01f);
			}
		}
		synchronized(outObjects){
			for (GameObject obj : outObjects){
				if(opcion == 0)
					obj.setV(obj.getV()-0.01f);
				else
					obj.setV(obj.getV()+0.01f);
			}
		}
		
	}
}
