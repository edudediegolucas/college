package sounds;

import java.io.File;

import javax.sound.sampled.AudioInputStream;
import javax.sound.sampled.AudioSystem;
import javax.sound.sampled.Clip;
import javax.sound.sampled.DataLine;

public class Sounds implements Runnable{
	
	public void playSound(String filename){
		try{
		    File soundFile = new File("/home/edu/workspace/AMIDE_Final/LWJGL.example4/sounds/"+filename);
		    AudioInputStream sound = AudioSystem.getAudioInputStream(soundFile);
	
		    DataLine.Info info = new DataLine.Info(Clip.class, sound.getFormat());
		    Clip clip = (Clip) AudioSystem.getLine(info);
		    clip.open(sound);
		    
		    // play the sound clip
		    clip.start();
		    clip.flush();
		    clip.close();
		} catch(Exception e){
			e.printStackTrace();
		}
	}

	@Override
	public void run() {
		playSound("lets_rock.wav");
	}

}
