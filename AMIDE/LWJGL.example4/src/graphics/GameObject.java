package graphics;

import java.io.Serializable;

public abstract class GameObject implements Serializable{

	public static final float POSZ = -35.0f;
	
	//Posiciones iniciales
    protected float x, y, z, radius = 0.0f;
    protected float xUpVector = 0.0f, yUpVector = 1.0f, zUpVector = 0.0f;
    protected float xVelocity = 0.0f, yVelocity = 0.0f, zVelocity = 0.0f;
    
    protected int id;
    protected int ok = 0;
    
    //Posiciones exactas
	protected float exactx, exacty, exactz, trans;
	protected float v;
	
	public boolean esEspacio;
	public boolean esNave;
    
    
    protected float angle = 0.0f;
    
    public void setAngle(float angle){
    	this.angle = angle;
    }
    
    public float getAngle(){
    	return angle;
    }


    /**
     * Return the x coordinate of this object.
     * @return the x coordinate of this object
     */
    public float getX() {
        return x;
    }
    
    public float getExactx(){
    	return exactx;
    }
    
    public float getExacty(){
    	return exacty;
    }
    
    public float getExactz(){
    	return exactz;
    }
    
    public int getID(){
    	return id;
    }
    
    public void setExactx(float x){
    	this.exactx = x;
    }
    
    public void setExacty(float y){
    	this.exacty = y;
    }
    
    public void setExactz(float z){
    	this.exactz = z;
    }
    
    public int getOK(){
    	return ok;
    }
    
    public void setOK(int ok){
    	this.ok = ok;
    }
    
    public float getV(){
    	return v;
    }
    
    public void setV(float v){
    	this.v = v;
    }

    /**
     * Return the x velocity of this object.
     * @return the x velocity of this object
     */
    public float getVX() {
        return xVelocity;
    }

    /**
     * Return the y coordinate of this object.
     * @return the y coordinate of this object
     */
    public float getY() {
        return y;
    }

    /**
     * Return the y velocity of this object.
     * @return the y velocity of this object
     */
    public float getVY() {
        return yVelocity;
    }

    /**
     * Return the z coordinate of this object.
     * @return the z coordinate of this object
     */
    public float getZ() {
        return z;
    }

    /**
     * Return the z velocity of this object.
     * @return the z velocity of this object
     */
    public float getVZ() {
        return zVelocity;
    }

    /**
     * Return the radius of this object.
     * @return the radius of this object
     */
    public float getRadius() {
        return radius;
    }

    /**
     * Return the x component of the upvector of this object.
     * @return the x component of the upvector of this object
     */
    public float getXUpVector() {
        return this.xUpVector;
    }

    /**
     * Return the y component of the upvector of this object.
     * @return the y component of the upvector of this object
     */
    public float getYUpVector() {
        return this.yUpVector;
    }

    /**
     * Return the z component of the upvector of this object.
     * @return the z component of the upvector of this object
     */
    public float getZUpVector() {
        return this.zUpVector;
    }

    /**
     * Set the x coordinate of this object
     * @param x New x coordinate
     */
    public void setX(float x) {
        this.x = x;
    }

    /**
     * Set the x velocity of this object
     * @param xVelocity New x velocity
     */
    public void setVX(float xVelocity) {
        this.xVelocity = xVelocity;
    }

    /**
     * Set the y coordinate of this object
     * @param y New y coordinate
     */
    public void setY(float y) {
        this.y = y;
    }

    /**
     * Set the y velocity of this object
     * @param yVelocity New y velocity
     */
    public void setVY(float yVelocity) {
        this.yVelocity = yVelocity;
    }

    /**
     * Set the z coordinate of this object
     * @param z New z coordinate
     */
    public void setZ(float z) {
        this.z = z;
    }

    /**
     * Set the z velocity of this object
     * @param zVelocity New y velocity
     */
    public void setVZ(float zVelocity) {
        this.zVelocity = zVelocity;
    }

    /**
     * Set the x compoment of UpVector of this object
     * @param xUpVector New x compoment of UpVector
     */
    public void setXUpVector(float xUpVector) {
        this.xUpVector = xUpVector;
    }

    /**
     * Set the y compoment of UpVector of this object
     * @param yUpVector New y compoment of UpVector
     */
    public void setYUpVector(float yUpVector) {
        this.yUpVector = yUpVector;
    }

    /**
     * Set the z compoment of UpVector of this object
     * @param zUpVector New z compoment of UpVector
     */
    public void setZUpVector(float zUpVector) {
        this.zUpVector = zUpVector;
    }

    /**
     * Set the position of this object
     * @param x New x coordinate
     * @param y New y coordinate
     * @param z New z coordinate
     */
    public void setPosition(float x, float y, float z) {
        this.x = x;
        this.y = y;
        this.z = z;
    }

    /**
     * Set the velocity vector of this object
     * @param xVelocity New x velocity
     * @param yVelocity New y velocity
     * @param zVelocity New z velocity
     */
    public void setVelocity(float xVelocity, float yVelocity, float zVelocity) {
        this.xVelocity = xVelocity;
        this.yVelocity = yVelocity;
        this.zVelocity = zVelocity;
    }

    /**
     * Set the Up vector of this object
     * @param zUpVector New x zUpVector
     * @param yUpVector New y zUpVector
     * @param xUpVector New z zUpVector
     */
    public void setUpVector(float xUpVector, float yUpVector, float zUpVector) {
        this.xUpVector = xUpVector;
        this.yUpVector = yUpVector;
        this.zUpVector = zUpVector;
    }

    /**
     * Set the radius of this object
     * @param radius New radius
     */
    public void setRadius(float radius) {
        this.radius = radius;
    }

    public void step(long tm) {
        // Opcionalmente se multiplica por el tiempo
        this.x += this.xVelocity; //*tm
        this.y += this.yVelocity; //*tm
        this.z += this.zVelocity; //*tm
    }

    /**
     * Render this object
     */
    public abstract void render();
    
    public abstract void update();
    
    public abstract void outrender();
    
    public abstract void outupdate();
    
}