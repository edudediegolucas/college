package graphics;

import static org.lwjgl.opengl.GL11.*;

import java.io.Serializable;

public class SpaceShip extends GameObject implements Serializable{
	
	private Texture tex = null;
	
	public SpaceShip(Texture tex){
		this.tex = tex;
		this.esNave = true;
	}
	
	public void drawShip(){
		glColor3f (1.0f, 1.0f, 1.0f);
		glEnable(GL_TEXTURE_2D);
		tex.bind();
		glBegin(GL_TRIANGLES); 
			glTexCoord2f(0.0f, 0.0f);glVertex3f( 0.0f, 1.0f, 0.0f); // Top
			glTexCoord2f(1.0f, 0.0f);glVertex3f(-1.0f,-1.0f, 0.0f); // Bottom Left
			glTexCoord2f(1.0f, 1.0f);glVertex3f( 1.0f,-1.0f, 0.0f); // Bottom Right
		glEnd();
	}
	
	@Override
	public void render() {
		glPushMatrix();
			glRotatef(-75, 1.0f, 0.0f, 0.0f);
			drawShip();
		glPopMatrix();
		
	}

	@Override
	public void update() {
		
	}

	@Override
	public void outupdate() {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void outrender() {
		// TODO Auto-generated method stub
		
	}

}
