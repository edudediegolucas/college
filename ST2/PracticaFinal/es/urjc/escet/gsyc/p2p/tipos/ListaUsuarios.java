package PracticaFinal.es.urjc.escet.gsyc.p2p.tipos;

import java.io.Serializable;
import java.util.ArrayList;

public class ListaUsuarios implements Serializable{
	//Clase de intercambio a traves de RMI
	
	private ArrayList<Usuario> lista;
	
	public ListaUsuarios(ArrayList<Usuario> lista){
		if(lista==null){
			this.lista=new ArrayList<Usuario>();
		}
		this.lista=lista;
	}
	public int size(){
		return lista.size();
	}
	public Usuario getUsuario(int i){
		if(i<0 || i>= lista.size()){
			return null;
		}else{
			return lista.get(i);
		}
	}

}
