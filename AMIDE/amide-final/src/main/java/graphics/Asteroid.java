package graphics;

import java.util.concurrent.ThreadLocalRandom;

import static org.lwjgl.opengl.GL11.*;

public class Asteroid extends GameObject {

  //  private final int modex;
//  private final int modey;
//  private final int modez;
  private int change;
  private Texture texture;

  public Asteroid(Texture texture, int id) {
    this.texture = texture;
    this.x = ThreadLocalRandom.current().nextInt(1, 20);
    this.y = ThreadLocalRandom.current().nextInt(1, 20);
    this.z = ThreadLocalRandom.current().nextInt(1, 20);
    this.id = id;
    this.isMovable = true;

    //modex = generator.nextInt(2);
    //modey = generator.nextInt(2);
    //modez = generator.nextInt(10);
    //trans = 0;
    change = 1;
    //v = 0.0f;
  }

  public void drawBox() {
    glColor3f(1.0f, 1.0f, 1.0f);
    glEnable(GL_TEXTURE_2D);
    texture.bind();
    glBegin(GL_QUADS);

    glTexCoord2f(0.0f, 0.0f);
    glVertex3f(-1.0f, 1.0f, -1.0f);
    glTexCoord2f(1.0f, 0.0f);
    glVertex3f(-1.0f, 1.0f, 1.0f);
    glTexCoord2f(1.0f, 1.0f);
    glVertex3f(-1.0f, -1.0f, 1.0f);
    glTexCoord2f(0.0f, 1.0f);
    glVertex3f(-1.0f, -1.0f, -1.0f);

    glTexCoord2f(0.0f, 0.0f);
    glVertex3f(1.0f, 1.0f, -1.0f);
    glTexCoord2f(1.0f, 0.0f);
    glVertex3f(-1.0f, 1.0f, -1.0f);
    glTexCoord2f(1.0f, 1.0f);
    glVertex3f(-1.0f, -1.0f, -1.0f);
    glTexCoord2f(0.0f, 1.0f);
    glVertex3f(1.0f, -1.0f, -1.0f);

    glTexCoord2f(0.0f, 0.0f);
    glVertex3f(1.0f, 1.0f, 1.0f);
    glTexCoord2f(1.0f, 0.0f);
    glVertex3f(1.0f, 1.0f, -1.0f);
    glTexCoord2f(1.0f, 1.0f);
    glVertex3f(1.0f, -1.0f, -1.0f);
    glTexCoord2f(0.0f, 1.0f);
    glVertex3f(1.0f, -1.0f, 1.0f);

    glTexCoord2f(0.0f, 0.0f);
    glVertex3f(-1.0f, 1.0f, 1.0f);
    glTexCoord2f(1.0f, 0.0f);
    glVertex3f(1.0f, 1.0f, 1.0f);
    glTexCoord2f(1.0f, 1.0f);
    glVertex3f(1.0f, -1.0f, 1.0f);
    glTexCoord2f(0.0f, 1.0f);
    glVertex3f(-1.0f, -1.0f, 1.0f);

    glTexCoord2f(0.0f, 0.0f);
    glVertex3f(-1.0f, -1.0f, 1.0f);
    glTexCoord2f(1.0f, 0.0f);
    glVertex3f(1.0f, -1.0f, 1.0f);
    glTexCoord2f(1.0f, 1.0f);
    glVertex3f(1.0f, -1.0f, -1.0f);
    glTexCoord2f(0.0f, 1.0f);
    glVertex3f(-1.0f, -1.0f, -1.0f);

    glTexCoord2f(0.0f, 0.0f);
    glVertex3f(-1.0f, 1.0f, -1.0f);
    glTexCoord2f(1.0f, 0.0f);
    glVertex3f(1.0f, 1.0f, -1.0f);
    glTexCoord2f(1.0f, 1.0f);
    glVertex3f(1.0f, 1.0f, 1.0f);
    glTexCoord2f(0.0f, 1.0f);
    glVertex3f(-1.0f, 1.0f, 1.0f);

    glEnd();
  }

  private void moverCaja() {
//    glPushMatrix();
//    if (modex == 1) {
//      if (modey == 1) {
//        exactx = trans + this.x;
//        exacty = trans + this.y;
//      } else {
//        exactx = trans + this.x;
//        exacty = this.y - trans;
//      }
//    } else {
//      if (modey == 1) {
//        exactx = this.x - trans;
//        exacty = trans + this.y;
//      } else {
//        exactx = this.x - trans;
//        exacty = this.y - trans;
//      }
//    }
//
//    glTranslatef(exactx, exacty, POSZ);
//    glRotatef(this.angle, 1.0f, 1.0f, 0.0f);
//    glRotatef(this.angle * 1.2f, 0.0f, 0.0f, 1.0f);
//    drawBox();
//    glPopMatrix();
  }

  @Override
  public void render() {
    glPushMatrix();
    //moverCaja();
    glPopMatrix();
  }

  @Override
  public void update() {
//    angle += 0.5f;
//
//    if (change == -1)
//      trans -= 0.01f + v;
//    else
//      trans += 0.01f + v;
//
//
//    //Compruebo si las cajas se sale de los extremos
//    if (exactx > 99) {
//      this.x = 99.0f;
//      trans = 0.0f;
//      change = change * -1;
//    }
//    if (exactx < -99) {
//      this.x = -99.0f;
//      trans = 0.0f;
//      change = change * -1;
//    }
//    if (exacty > 99) {
//      this.y = -99.0f;
//      trans = 0.0f;
//    }
//    if (exacty < -99) {
//      this.y = 99.0f;
//      trans = 0.0f;
//    }

  }

  @Override
  public void afterUpdate() {
//    this.setExactx(this.getExactx());
//    this.setExacty(this.getExacty());
//    this.setAngle(this.getAngle());
  }

  @Override
  public void afterRender() {
    glPushMatrix();
//    glTranslatef(this.exactx, this.exacty, POSZ);
//    glRotatef(this.angle, 1.0f, 1.0f, 0.0f);
//    glRotatef(this.angle * 1.2f, 0.0f, 0.0f, 1.0f);
    drawBox();
    glPopMatrix();
  }


}
