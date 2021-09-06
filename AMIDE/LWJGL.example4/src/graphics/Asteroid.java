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
import java.util.Random;

public class Asteroid extends GameObject implements Serializable{
	
	//Modo de movimiento
	private int modex, modey, modez, change;
	//Textura
	private Texture boxTex = null;
	
	Random generator = new Random();
	
	public Asteroid(Texture tex){
		this.x = generator.nextInt(20)+1;
		this.y = generator.nextInt(20)+1;
		this.z = POSZ;
		
		this.boxTex = tex;
		
		this.id = generator.nextInt(10000);
		
		//this.id = generator.hashCode();
		
		modex = generator.nextInt(2);
		modey= generator.nextInt(2);
		modez= generator.nextInt(10);
		trans = 0;
		change = 1;
		v = 0.0f;
		
		esEspacio = false;
	}
	
	public void drawBox() {
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
	
	private void moverCaja(){
		glPushMatrix();
			if(modex==1){
				if(modey==1){
					exactx = trans + this.x;
					exacty = trans + this.y;
				}else{
					exactx = trans + this.x;
					exacty = this.y - trans;
				}
			}else{
				if(modey==1){
					exactx = this.x - trans;
					exacty = trans + this.y;
				}else{
					exactx = this.x - trans;
					exacty = this.y - trans;
				}
			}
			
			glTranslatef(exactx, exacty, POSZ);
			glRotatef(this.angle, 1.0f, 1.0f, 0.0f);
			glRotatef(this.angle * 1.2f, 0.0f, 0.0f, 1.0f);
			drawBox();
		glPopMatrix();
	}
	
	@Override
	public void render() {
		glPushMatrix();
			moverCaja();
		glPopMatrix();
	}
	
	@Override
	public void update(){
		angle += 0.5f;
		
		if(change==-1)
			trans -= 0.01f+v;
		else
			trans += 0.01f+v;
	
		
		//Compruebo si las cajas se sale de los extremos
		if(exactx>99){
			this.x = 99.0f;
			trans = 0.0f;
			change = change*-1;
		}
		if(exactx<-99){
			this.x = -99.0f;
			trans = 0.0f;
			change = change*-1;
		}
		if(exacty>99){
			this.y = -99.0f;
			trans = 0.0f;
		}
		if(exacty<-99){
			this.y = 99.0f;
			trans = 0.0f;
		}
		
	}

	public float getExactx() {
		return exactx;
	}
	
	public float getExacty() {
		return exacty;
	}

	@Override
	public void outupdate() {
		this.setExactx(this.getExactx());
		this.setExacty(this.getExacty());
		this.setAngle(this.getAngle());
				
	}

	@Override
	public void outrender() {
		glPushMatrix();
			glTranslatef(this.exactx, this.exacty, this.POSZ);
			glRotatef(this.angle, 1.0f, 1.0f, 0.0f);
			glRotatef(this.angle * 1.2f, 0.0f, 0.0f, 1.0f);
			drawBox();
		glPopMatrix();
	}
	
	
}
