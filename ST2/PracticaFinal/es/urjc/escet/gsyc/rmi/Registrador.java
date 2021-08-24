package PracticaFinal.es.urjc.escet.gsyc.rmi;

import java.rmi.Remote;
import java.rmi.RemoteException;

import PracticaFinal.es.urjc.escet.gsyc.p2p.tipos.*;

public interface Registrador extends Remote{
	//clase con la que utilizaremos el paradigma RMI de java
	public String registrar(Usuario usuario, String clave) throws RemoteException;
	
	public String darDeBaja(String nick, String clave) throws RemoteException;
	
	public ListaUsuarios getTodos() throws RemoteException;
	
	public Usuario getUsuario(String nick) throws RemoteException;

}
