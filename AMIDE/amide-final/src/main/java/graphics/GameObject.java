package graphics;

import lombok.Data;

import java.io.Serializable;

@Data
public abstract class GameObject implements Serializable {

  protected static final float POSZ = -35.0f; // ?

  protected int id;
  protected float x;
  protected float y;
  protected float z;
  protected float radius;
  protected float angle;
  protected float velocity;

  protected boolean isMovable;
  //Posiciones iniciales
//  protected float x, y, z, radius = 0.0f;
//  protected float xUpVector = 0.0f, yUpVector = 1.0f, zUpVector = 0.0f;
//  protected float xVelocity = 0.0f, yVelocity = 0.0f, zVelocity = 0.0f;
  //Posiciones exactas
//  protected float exactx, exacty, exactz, trans;
//  protected float v;
//  protected float angle = 0.0f;

  /**
   * Render this object
   */
  public abstract void render();

  public abstract void update();

  public abstract void afterRender();

  public abstract void afterUpdate();

}