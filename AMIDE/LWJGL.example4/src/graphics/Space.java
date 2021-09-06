package graphics;

import static org.lwjgl.opengl.GL11.GL_QUADS;
import static org.lwjgl.opengl.GL11.GL_TEXTURE_2D;
import static org.lwjgl.opengl.GL11.glBegin;
import static org.lwjgl.opengl.GL11.glColor3f;
import static org.lwjgl.opengl.GL11.glEnable;
import static org.lwjgl.opengl.GL11.glEnd;
import static org.lwjgl.opengl.GL11.glPopMatrix;
import static org.lwjgl.opengl.GL11.glPushMatrix;
import static org.lwjgl.opengl.GL11.glRotatef;
import static org.lwjgl.opengl.GL11.glTexCoord2f;
import static org.lwjgl.opengl.GL11.glTranslatef;
import static org.lwjgl.opengl.GL11.glVertex3f;

import java.io.IOException;
import java.io.Serializable;

public class Space extends GameObject implements Serializable{
	
	private Texture spaceTex = null;
	
	public Space(Texture tex) {
		this.spaceTex = tex;
		esEspacio = true;
		trans = 0;
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
	
	private void moverSpace(){
		glPushMatrix();
			glRotatef(this.angle, 1.0f, this.angle, 0.0f);
			drawSpace();
		glPopMatrix();
	}
	
	@Override
	public void render() {
		glPushMatrix();
			moverSpace();
		glPopMatrix();
	}

	@Override
	public void update() {
		angle+=0.05;
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
