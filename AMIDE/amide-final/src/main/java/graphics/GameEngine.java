package graphics;

import lombok.SneakyThrows;
import lombok.extern.slf4j.Slf4j;
import org.lwjgl.input.Keyboard;
import org.lwjgl.input.Mouse;
import org.lwjgl.opengl.Display;
import org.lwjgl.opengl.DisplayMode;
import sounds.SoundEngine;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.stream.IntStream;

import static org.lwjgl.opengl.GL11.*;
import static org.lwjgl.util.glu.GLU.gluLookAt;
import static org.lwjgl.util.glu.GLU.gluPerspective;

@Slf4j
public class GameEngine {

  private static final int DISPLAY_WIDTH = 800;
  private static final int DISPLAY_HEIGHT = 600;
  private static final boolean FULLSCREEN = false;
  private static final float POSZ = -35.0f;

  private static GameEngine instance;

  public static GameEngine getInstance() {
    if (instance == null) {
      instance = new GameEngine();
    }
    return instance;
  }

  private GameEngine() {

  }

  public List<GameObject> objects = new ArrayList<>();
  public List<GameObject> outObjects = new ArrayList<>();

  //Camara
  private float eyeX, eyeY, eyeZ = 0.0f;
  private float xLookingAt = 0.0f;
  private float yLookingAt = 0.0f;
  private final float zLookingAt = POSZ;
  private final float xUpVector = 0.0f;
  private final float yUpVector = 1.0f;
  private final float zUpVector = 0.0f;

  //Texturas
  private Texture boxTex = null;
  private Texture spaceTex = null;
  private Texture shipTex = null;
  private final TextureLoader texLoader = new TextureLoader();

  private void destroy() {
    Mouse.destroy();
    Keyboard.destroy();
    Display.destroy();
  }

  private void initGL() {
    //2D Initialization
    glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
    glEnable(GL_DEPTH_TEST);
    glDisable(GL_LIGHTING);
  }

  //TODO
  private void processKeyboard() {
    float distance = 0.5f;
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
    if (Keyboard.isKeyDown(Keyboard.KEY_A)) {
      yLookingAt += distance;
      eyeY += distance;
    }
    if (Keyboard.isKeyDown(Keyboard.KEY_S)) {
      yLookingAt -= distance;
      eyeY -= distance;
    }
  }

  private void resizeGL() {
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    glViewport(0, 0, DISPLAY_WIDTH, DISPLAY_HEIGHT);
    gluPerspective(45.0f, (float) DISPLAY_WIDTH / (float) DISPLAY_HEIGHT, 0.001f, 10000.0f);

    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
  }

  @SneakyThrows
  public void startGameEngine() {
    SoundEngine soundEngine = SoundEngine.getInstance();
    ExecutorService executorServiceForSoundEngine = null;
    try {
      Display.setDisplayMode(new DisplayMode(DISPLAY_WIDTH, DISPLAY_HEIGHT));
      Display.setFullscreen(FULLSCREEN);
      Display.setTitle("Outer Rocks!");
      Display.create();

      //Keyboard
      Keyboard.create();
      //OpenGL
      initGL();
      resizeGL();
      boxTex = texLoader.getTexture("src/main/resources/images/box.png");
      IntStream.rangeClosed(0, 9)
              .forEach(value -> addObject(new Asteroid(boxTex, value)));
      executorServiceForSoundEngine = Executors.newSingleThreadExecutor();
      executorServiceForSoundEngine.execute(() -> soundEngine.playSound("lets_rock.mp3"));
      while (!Display.isCloseRequested() && !Keyboard.isKeyDown(Keyboard.KEY_ESCAPE)) {
        if (Display.isVisible()) {
          processKeyboard();
          updateScene();
          renderScene();
          updateCamera();
        } else {
          if (Display.isDirty()) {
            renderScene();
          }
          try {
            Thread.sleep(100);
          } catch (InterruptedException ex) {
          }
        }
        Display.update();
        Display.sync(60);
      }
      executorServiceForSoundEngine.execute(() -> soundEngine.playSound("haha.mp3"));
      log.info("*** GAME OVER ***");
    } finally {
      if (executorServiceForSoundEngine != null) {
        executorServiceForSoundEngine.shutdown();
      }
    }
  }

  private void renderScene() {
    glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glMatrixMode(GL_PROJECTION);
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    gluLookAt(eyeX, eyeY, eyeZ, xLookingAt, yLookingAt, zLookingAt, xUpVector, yUpVector, zUpVector);
    synchronized (objects) {
      for (GameObject obj : objects) {
        obj.render();
      }
    }
    synchronized (outObjects) {
      for (GameObject obj : outObjects) {
        obj.afterRender();
      }
    }
    glFlush();
  }

  private void updateScene() {
    glClear(GL_COLOR_BUFFER_BIT);
    glLoadIdentity();
    synchronized (objects) {
      for (GameObject obj : objects)
        obj.update();
    }
    synchronized (outObjects) {
      for (GameObject obj : outObjects) {
        obj.afterUpdate();
      }
    }
  }

  private void updateCamera() {
    //Actualizo la camara
    if (eyeZ > 99)
      eyeZ = 99.0f;
    if (eyeZ < -99)
      eyeZ = -99.0f;
    if (eyeY > 99)
      eyeY = 99.0f;
    if (eyeY < -99)
      eyeY = -99.0f;
    if (eyeX > 99)
      eyeX = 99.0f;
    if (eyeX < -99)
      eyeX = -99.0f;

    if (xLookingAt > 99)
      xLookingAt = 99.0f;
    if (xLookingAt < -99)
      xLookingAt = -99.0f;
    if (yLookingAt > 99)
      yLookingAt = 99.0f;
    if (yLookingAt < -99)
      yLookingAt = -99.0f;

  }

  public void addObject(GameObject obj) {
    synchronized (this.objects) {
      this.objects.add(obj);
    }
  }

  public void addOutObject(GameObject obj) {
    synchronized (this.outObjects) {
      this.outObjects.add(obj);
    }
  }

//  public void updateVelocidad(int opcion) {
//    synchronized (objects) {
//      for (GameObject obj : objects) {
//        if (opcion == 0)
//          obj.setV(obj.getV() - 0.01f);
//        else
//          obj.setV(obj.getV() + 0.01f);
//      }
//    }
//    synchronized (outObjects) {
//      for (GameObject obj : outObjects) {
//        if (opcion == 0)
//          obj.setV(obj.getV() - 0.01f);
//        else
//          obj.setV(obj.getV() + 0.01f);
//      }
//    }
//  }
}
