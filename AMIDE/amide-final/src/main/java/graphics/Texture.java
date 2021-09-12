package graphics;

import java.io.Serializable;

import static org.lwjgl.opengl.GL11.glBindTexture;

public class Texture implements Serializable {

  private final int target;
  private final int textureID;
  private int height;
  private int width;
  private int texWidth;
  private int texHeight;
  private float widthRatio;
  private float heightRatio;

  /**
   * Create a new texture
   *
   * @param target    The GL target
   * @param textureID The GL texture ID
   */
  public Texture(int target, int textureID) {
    this.target = target;
    this.textureID = textureID;
  }

  /**
   * Bind the specified GL context to a texture
   */
  public void bind() {
    glBindTexture(target, textureID);
  }

  /**
   * Get the height of the original image
   *
   * @return The height of the original image
   */
  public int getImageHeight() {
    return height;
  }

  /**
   * Get the width of the original image
   *
   * @return The width of the original image
   */
  public int getImageWidth() {
    return width;
  }

  /**
   * Get the height of the physical texture
   *
   * @return The height of physical texture
   */
  public float getHeight() {
    return heightRatio;
  }

  /**
   * Set the height of the image
   *
   * @param height The height of the image
   */
  public void setHeight(int height) {
    this.height = height;
    setHeight();
  }

  /**
   * Get the width of the physical texture
   *
   * @return The width of physical texture
   */
  public float getWidth() {
    return widthRatio;
  }

  /**
   * Set the width of the image
   *
   * @param width The width of the image
   */
  public void setWidth(int width) {
    this.width = width;
    setWidth();
  }

  /**
   * Set the height of this texture
   *
   * @param texHeight The height of the texture
   */
  public void setTextureHeight(int texHeight) {
    this.texHeight = texHeight;
    setHeight();
  }

  /**
   * Set the width of this texture
   *
   * @param texWidth The width of the texture
   */
  public void setTextureWidth(int texWidth) {
    this.texWidth = texWidth;
    setWidth();
  }

  /**
   * Set the height of the texture. This will update the
   * ratio also.
   */
  private void setHeight() {
    if (texHeight != 0) {
      heightRatio = ((float) height) / texHeight;
    }
  }

  /**
   * Set the width of the texture. This will update the
   * ratio also.
   */
  private void setWidth() {
    if (texWidth != 0) {
      widthRatio = ((float) width) / texWidth;
    }
  }
}
