package graphics;

import de.matthiasmann.twl.utils.PNGDecoder;
import de.matthiasmann.twl.utils.PNGDecoder.Format;

import java.awt.event.KeyEvent;
import java.io.FileInputStream;
import static org.lwjgl.opengl.GL11.*;
import static org.lwjgl.util.glu.GLU.*;

import java.io.IOException;
import java.io.InputStream;
import java.nio.ByteBuffer;
import java.util.logging.FileHandler;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.lwjgl.LWJGLException;
import org.lwjgl.input.Keyboard;
import org.lwjgl.input.Mouse;
import org.lwjgl.opengl.Display;
import org.lwjgl.opengl.DisplayMode;

import java.util.Random;


public class Main {

	public static final int DISPLAY_WIDTH = 800;
	public static final int DISPLAY_HEIGHT = 600;
	public static final boolean FULLSCREEN = false;
	public static final Logger LOGGER = Logger.getLogger(Main.class.getName());
	
	//Constantes de numero de cajas y posicion Z fija
	public static final int CAJAS = 20;
	public static final float POSZ = -35.0f;

	//variables angulo y translacion para ir moviendo
	private float angle = 0.0f;
	private float [] trans = new float[CAJAS];
	private int [] change = new int[CAJAS];
	
	private Texture boxTex = null;
	private Texture spaceTex = null;
	private TextureLoader texLoader = new TextureLoader();
	private boolean texFilterLinear = false;
    
	//private Camera camera;
	private float[][] posiciones = new float[CAJAS][2]; //posiciones iniciales
	private float[][] exactas = new float[CAJAS][2];    //posiciones exactas en cada momento
	
	//Modo de movimiento 8 posibles!!!
	private int [] x = new int[CAJAS];
	private int [] y = new int[CAJAS];
	private int [] z = new int[CAJAS];
	Random generador = new Random();
	
	//Camara
	private float eyeX,eyeY,eyeZ = 0.0f;
	private float xLookingAt = 0.0f, yLookingAt = 0.0f, zLookingAt = POSZ;
	private float xUpVector = 0.0f, yUpVector = 1.0f, zUpVector = 0.0f;
	
	//Joypad
	//private GamePadController gpController = new GamePadController();
	
	static {
		try {
			LOGGER.addHandler(new FileHandler("errors.log", true));
		}catch (IOException ex) {
			LOGGER.log(Level.WARNING, ex.toString(), ex);
		}
	}

	public static void main(String[] args) {
		Main main = null;
		try {
			main = new Main();
			main.run();
		}catch (Exception ex) {
			LOGGER.log(Level.SEVERE, ex.toString(), ex);
		}finally {
			if (main != null)
				main.destroy();
			}
	}

	public Main() throws Exception {
		//Display
		Display.setDisplayMode(new DisplayMode(DISPLAY_WIDTH, DISPLAY_HEIGHT));
		Display.setFullscreen(FULLSCREEN);
		Display.setTitle("Outer Rocks!");
		Display.create();

		//Keyboard
		Keyboard.create();

		//Mouse
		Mouse.setGrabbed(false);
		Mouse.create();

		//OpenGL
		initGL();
		resizeGL();
		loadTextures();
	}

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

	public void loadTextures() throws Exception {
		boxTex = texLoader.getTexture("Rock.png");
		spaceTex = texLoader.getTexture("space.png");
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
//		if(direccion == gpController.SOUTH){
//			eyeZ += distance;
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
//		if(movimiento == gpController.SOUTH){
//			yLookingAt -= distance;
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
		if (Keyboard.isKeyDown(Keyboard.KEY_SPACE)) {
			//updateFilter();
			//DISPARO!
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

	public void processMouse() {
		Mouse.getX();
		Mouse.getY();
	}

	public void render() {
		//Preparamos todo
		glClearColor (0.0f, 0.0f, 0.0f, 0.0f);
		glClear (GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
		glMatrixMode(GL_PROJECTION);
		glMatrixMode(GL_MODELVIEW);
		glLoadIdentity();
		
		//Actualizamos la camara
		gluLookAt(eyeX, eyeY, eyeZ, xLookingAt, yLookingAt, zLookingAt, xUpVector, yUpVector, zUpVector);
		
		//Dibujamos el espacio
		glPushMatrix();
			drawSpace();
		glPopMatrix();

		//Dibujamos las cajas
		for(int i = 0;i<CAJAS;i++){
			glPushMatrix();
				moverCaja(i);
			glPopMatrix();
		}
		glFlush();
	}

	private void drawBox() {
		glColor3f (1.0f, 1.0f, 1.0f);
		glEnable(GL_TEXTURE_2D);
		boxTex.bind();
		glBegin(GL_QUADS);
			glTexCoord2f(0.0f, 0.0f); glVertex3f (-1.0f, 1.0f, -1.0f);
			glTexCoord2f(1.0f, 0.0f); glVertex3f (-1.0f, 1.0f, 1.0f);
			glTexCoord2f(1.0f, 1.0f); glVertex3f (-1.0f, -1.0f, 1.0f);
			glTexCoord2f(0.0f, 1.0f); glVertex3f (-1.0f, -1.0f, -1.0f);

			glTexCoord2f(0.0f, 0.0f); glVertex3f (1.0f, 1.0f, -1.0f);
			glTexCoord2f(1.0f, 0.0f); glVertex3f (-1.0f, 1.0f, -1.0f);
			glTexCoord2f(1.0f, 1.0f); glVertex3f (-1.0f, -1.0f, -1.0f);
			glTexCoord2f(0.0f, 1.0f); glVertex3f (1.0f, -1.0f, -1.0f);

			glTexCoord2f(0.0f, 0.0f); glVertex3f (1.0f, 1.0f, 1.0f);
			glTexCoord2f(1.0f, 0.0f); glVertex3f (1.0f, 1.0f, -1.0f);
			glTexCoord2f(1.0f, 1.0f); glVertex3f (1.0f, -1.0f, -1.0f);
			glTexCoord2f(0.0f, 1.0f); glVertex3f (1.0f, -1.0f, 1.0f);
			
			glTexCoord2f(0.0f, 0.0f); glVertex3f (-1.0f, 1.0f, 1.0f);
			glTexCoord2f(1.0f, 0.0f); glVertex3f (1.0f, 1.0f, 1.0f);
			glTexCoord2f(1.0f, 1.0f); glVertex3f (1.0f, -1.0f, 1.0f);
			glTexCoord2f(0.0f, 1.0f); glVertex3f (-1.0f, -1.0f, 1.0f);

			glTexCoord2f(0.0f, 0.0f); glVertex3f (-1.0f, -1.0f, 1.0f);
			glTexCoord2f(1.0f, 0.0f); glVertex3f (1.0f, -1.0f, 1.0f);
			glTexCoord2f(1.0f, 1.0f); glVertex3f (1.0f, -1.0f, -1.0f);
			glTexCoord2f(0.0f, 1.0f); glVertex3f (-1.0f, -1.0f, -1.0f);

			glTexCoord2f(0.0f, 0.0f); glVertex3f (-1.0f, 1.0f, -1.0f);
			glTexCoord2f(1.0f, 0.0f); glVertex3f (1.0f, 1.0f, -1.0f);
			glTexCoord2f(1.0f, 1.0f); glVertex3f (1.0f, 1.0f, 1.0f);
			glTexCoord2f(0.0f, 1.0f); glVertex3f (-1.0f, 1.0f, 1.0f);

		glEnd();
	}

	private void drawSpace() {
		glColor3f (1.0f, 1.0f, 1.0f);
		glEnable(GL_TEXTURE_2D);
		spaceTex.bind();
		glBegin(GL_QUADS);
			glTexCoord2f(0.0f, 0.0f); glVertex3f (-100.0f, 100.0f, -100.0f);
			glTexCoord2f(1.0f, 0.0f); glVertex3f (-100.0f, 100.0f, 100.0f);
			glTexCoord2f(1.0f, 1.0f); glVertex3f (-100.0f, -100.0f, 100.0f);
			glTexCoord2f(0.0f, 1.0f); glVertex3f (-100.0f, -100.0f, -100.0f);

			glTexCoord2f(0.0f, 0.0f); glVertex3f (100.0f, 100.0f, -100.0f);
			glTexCoord2f(1.0f, 0.0f); glVertex3f (-100.0f, 100.0f, -100.0f);
			glTexCoord2f(1.0f, 1.0f); glVertex3f (-100.0f, -100.0f, -100.0f);
			glTexCoord2f(0.0f, 1.0f); glVertex3f (100.0f, -100.0f, -100.0f);

			glTexCoord2f(0.0f, 0.0f); glVertex3f (100.0f, 100.0f, 100.0f);
			glTexCoord2f(1.0f, 0.0f); glVertex3f (100.0f, 100.0f, -100.0f);
			glTexCoord2f(1.0f, 1.0f); glVertex3f (100.0f, -100.0f, -100.0f);
			glTexCoord2f(0.0f, 1.0f); glVertex3f (100.0f, -100.0f, 100.0f);

			glTexCoord2f(0.0f, 0.0f); glVertex3f (-100.0f, 100.0f, 100.0f);
			glTexCoord2f(1.0f, 0.0f); glVertex3f (100.0f, 100.0f, 100.0f);
			glTexCoord2f(1.0f, 1.0f); glVertex3f (100.0f, -100.0f, 100.0f);
			glTexCoord2f(0.0f, 1.0f); glVertex3f (-100.0f, -100.0f, 100.0f);

			glTexCoord2f(0.0f, 0.0f); glVertex3f (-100.0f, -100.0f, 100.0f);
			glTexCoord2f(1.0f, 0.0f); glVertex3f (100.0f, -100.0f, 100.0f);
			glTexCoord2f(1.0f, 1.0f); glVertex3f (100.0f, -100.0f, -100.0f);
			glTexCoord2f(0.0f, 1.0f); glVertex3f (-100.0f, -100.0f, -100.0f);

			glTexCoord2f(0.0f, 0.0f); glVertex3f (-100.0f, 100.0f, -100.0f);
			glTexCoord2f(1.0f, 0.0f); glVertex3f (100.0f, 100.0f, -100.0f);
			glTexCoord2f(1.0f, 1.0f); glVertex3f (100.0f, 100.0f, 100.0f);
			glTexCoord2f(0.0f, 1.0f); glVertex3f (-100.0f, 100.0f, 100.0f);
		glEnd();
	}

	//Metodo para mover la caja
	private void moverCaja(int numero){
		glPushMatrix();
		if(x[numero]==1){
			if(y[numero]==1){
				exactas[numero][0] = trans[numero]+posiciones[numero][0];
				exactas[numero][1] =trans[numero]+posiciones[numero][1];
			}else{
				exactas[numero][0] = trans[numero]+posiciones[numero][0];
				exactas[numero][1] = posiciones[numero][1]-trans[numero];
			}
		}else{
			if(y[numero]==1){
				exactas[numero][0] = posiciones[numero][0]-trans[numero];
				exactas[numero][1] = trans[numero]+posiciones[numero][1];
			}else{
				exactas[numero][0] = posiciones[numero][0]-trans[numero];
				exactas[numero][1] = posiciones[numero][1]-trans[numero];
			}
		}
		if(z[numero]==0)
			exactas[numero][0] = 0.0f;
		if(z[numero]==1)
			exactas[numero][1] = 0.0f;
		
		glTranslatef(exactas[numero][0], exactas[numero][1], POSZ);
		glRotatef(angle, 1.0f, 1.0f, 0.0f);
		glRotatef(angle * 1.2f, 0.0f, 0.0f, 1.0f);
		drawBox();
		glPopMatrix();
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
		for(int i = 0;i<CAJAS;i++){
			for(int j = 0;j<2;j++){
				if(generador.nextInt(2)==1)
					posiciones[i][j] = generador.nextInt(20)+1;
				else
					posiciones[i][j] = (generador.nextInt(20)+1)*-1;
			}
		}
		
		for(int i = 0;i<CAJAS;i++){
			x[i] = generador.nextInt(2);
			y[i] = generador.nextInt(2);
			z[i] = generador.nextInt(10);
			trans[i] = 0;
			change[i] = 1;
		}

		while (!Display.isCloseRequested() && !Keyboard.isKeyDown(Keyboard.KEY_ESCAPE)) {
			if (Display.isVisible()) {
				processKeyboard();
				processMouse();
				render();
				update();
			}else {
				if(Display.isDirty()) {
					render();
				}
				try {
					Thread.sleep(100);
				}catch (InterruptedException ex) {
				}
			}
			Display.update();
			Display.sync(60);
		}
	}

	public void update() {
		angle += 0.5f;
		for(int i = 0;i<CAJAS;i++){
			if(change[i]==-1)
				trans[i] -= 0.01f;
			else
				trans[i] +=0.01f;
		}
		//Compruebo si las cajas se sale de los extremos
		for(int i = 0;i<CAJAS;i++){
			if(exactas[i][0]>99){
				posiciones[i][0] = 99.0f;
				trans[i] = 0;
				change[i] = change[i]*-1;
			}
			if(exactas[i][0]<-99){
				posiciones[i][0] = -99.0f;
				trans[i] = 0;
				change[i] = change[i]*-1;
			}
			if(exactas[i][1]>99){
				posiciones[i][1] = -99.0f;
				trans[i] = 0;
			}
			if(exactas[i][1]<-99){
				posiciones[i][1] = 99.0f;
				trans[i] = 0;
			}
		}
		
		//Actualizo la camara
		if(eyeZ>99)
			eyeZ = 99.0f;
		if(eyeZ<-99)
			eyeZ = -99.0f;
		if(eyeY>99)
			eyeY = 99.0f;
		if(eyeY<-99)
			eyeY = -99.0f;
		if(xLookingAt>99)
			xLookingAt = 99.0f;
		if(xLookingAt<-99)
			xLookingAt = -99.0f;
		if(yLookingAt>99)
			yLookingAt = 99.0f;
		if(yLookingAt<-99)
			yLookingAt = -99.0f;
	}

	/*
	public void updateFilter() {
		boxTex.bind();
		texFilterLinear = !texFilterLinear;
		int filter;
		if (texFilterLinear) {
			filter = GL_LINEAR;
			System.err.println("Setting texture filter to GL_LINEAR");
		}else {
			filter = GL_NEAREST;
			System.err.println("Setting texture filter to GL_NEAREST");
		}
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, filter);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, filter);
	}*/
}
