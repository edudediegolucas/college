package PracticaFinal.es.urjc.escet.gsyc.http;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.net.Socket;
import java.util.Map;
import java.util.Date;
import java.util.Random;
import java.util.HashMap;
import java.io.File;
import java.io.FileOutputStream;
import java.rmi.*;

import PracticaFinal.es.urjc.escet.gsyc.http.Constantes;
import PracticaFinal.es.urjc.escet.gsyc.peer.*;
import PracticaFinal.es.urjc.escet.gsyc.html.GeneradorHtml;
import PracticaFinal.es.urjc.escet.gsyc.rmi.*;
import PracticaFinal.es.urjc.escet.gsyc.p2p.tipos.*;

public class GestorDePeticionesHttp extends Thread {
    //atributos
    private Socket socket;
    private Random credencial;
    private String Directorio_Usuarios;
    private HashMap <String,String> usuarios;//HashMap donde guardaremos los nicks y las credenciales
    private HashMap <String,Peer> terminales;//HashMop donde guardaremos los peers y las credenciales
    private Registrador registro;//atributo RMI
   
   
   
   
    public GestorDePeticionesHttp(Socket socket, Random credencial, String Directorio_Usuarios, HashMap <String,String> usuarios,
            HashMap <String,Peer> terminales, Registrador registro){
        this.socket = socket;
        this.credencial= credencial;
        this.Directorio_Usuarios =Directorio_Usuarios;
        this.usuarios =usuarios;
        this.terminales=terminales;
        this.registro = registro;
       
    }
    //contamos los tipos de conexiones que se van a establecer, es decir, cuantas peticiones HTTP se van a establecer
    private static int iteraciones=0;
   
   //metodos
   
    private Byte comprobacion(String nick, String contrasenia){
        //Con este metodo comprobaremos si el fichero de usuario existe o no y si la clave esta mal introducida.
        //Usamos 3 numeros, 0 para saber que hay un error en el proceso de datos, 1 para registrar y 2 para validez de archivo y contrasenia
        Peer usuario;
        String nombrecfg = new String(Directorio_Usuarios+ "/"+ nick + ".cfg");//nombre del archivo con el nombre del nick
        String enteroLargo;//este va a ser la credencial
       
        File archivocfg = new File(nombrecfg);//creamos el archivo
        //Comprobamos que este archivo existe
        if (archivocfg.exists()){
            //obtiene la credencial del HashMap de usuarios
            enteroLargo= usuarios.get(nick);
            if (enteroLargo==null){
                //si la credencial es nula o no existe, entonces creamos una automaticamente
                enteroLargo= new Long(credencial.nextLong()).toString();
               
                usuarios.put(nick, enteroLargo);//por tanto la introduce dentro del HashMap y sera asi:
                /*Tabla Hash-->USUARIOS
                ============
                USUARIOS(key)    CREDENCIAL(value)
                ========        ==========
                Pepe            54545456464....
                Manolo            46465463441....
                */
                try{
                    //intenta crear un Peer nuevo con esa informacion y metiendo ese archivo de por medio
                    usuario = new Peer(nick,enteroLargo, archivocfg);
                    terminales.put(enteroLargo, usuario);//guarda en el HashMap de Peer lo realizado
                    /*Tabla Hash-->TERMINALES
                    ============
                    CREDENCIAL(key)    USUARIO(value)
                    ========        ==========
                    4152415211...    Peer1           
                    55415151521...    Peer2
                     */
                   }
                catch(Exception e){
                    //algun fallo?, todo mal entonces y se devuelve cero
                    return 0;
                }
               
                //AQUI ESTA EL ERROR, hay que ver como podemos obtener la clave a partir del PEER!!
                String otra_contrasenia = usuario.getClave();
                //ultima comprobacion
                if (otra_contrasenia.contentEquals(contrasenia)){
                    //existe el archivo y es correcta la contraseC1a
                    return 2;
                }
                else{
                    //contrasenias distintas?, fallo, devuelve cero
                    return 0;
                }
            }
            else{//credencial existe
                usuario = terminales.get(enteroLargo);//obtenemos el Peer del Hash de Peers y credenciales
                //usuarios.put(nick, enteroLargo);
                //******FALLO******
                String otra_contrasenia = usuario.getClave();
                if (otra_contrasenia.contentEquals(contrasenia)){
                    return 2;
                }
                else{
                    return 0;
                }
            }
        }// IF de archivo existe
        else{
            try{
                //el archivo no existe por lo que hay que crearlo
                //encadenamos los Streams necesarios
                FileOutputStream configuracion = new FileOutputStream(archivocfg);
                PrintWriter s = new PrintWriter(configuracion);
                /*
                Escribiremos dentro del archivo lo siguiente:
                PUERTO_P2P:
                DIRECTORIO_EXPORTADO:
                NICK: nick
                NOMBRE_COMPLETO:
                CORREO_ELECTRONICO:
                CLAVE: clave
                 */
                s.print("PUERTOP2P "+ "\r\n");
                s.print("DIRECTORIO_EXPORTADO "+ "\r\n");
                s.print("NICK " + "\"" +nick + "\""+ "\r\n");
                s.print("NOMBRE_COMPLETO "+ "\r\n");
                s.print("CORREO "+ "\r\n");
                s.print("CLAVE " + "\"" + contrasenia+"\"" + "\r\n");
               
                s.flush();
                s.close();
                configuracion.close();
                System.out.println("***FICHERO INICIAL de " + nick + " creado satisfactoriamente");
                enteroLargo= new Long(credencial.nextLong()).toString();
                //INTENTAR QUITAR EL MENOS DE LA CREDENCIAL
                usuarios.put(nick, enteroLargo);
                //registro.registrar(usuario, clave);
                System.out.println("***El usuario "+ nick + " posee esta credencial-->" + enteroLargo);
                String numero = new  String(usuarios.get(nick));
                //System.out.println("-->Recuperamos la credencial->" + numero);
            }
            catch(Exception e){
                //algun error en la escritura?, entonces devuelve cero
                System.out.println("-->No se ha podido escribir en disco...");
                return 0; 
            }
            //todo correcto se va a la pagina de registro
            return 1;
           
        }//archivo existe
       
       
    }//comprobacion
   
   
   
    private StringBuilder procesaPeticionPaginaDesconocida(){
        StringBuilder page = new StringBuilder("");
        page.append("<html><title>ERROR 404</title></html>");
        page.append("<html><H1>ERROR 404</H1></html>");
        page.append("<html><H3>El recurso solicitado no se encuentra en el servidor </H3></html>");
        return page;
    }
    private StringBuilder procesaPeticionPaginaError(){
        StringBuilder page=new StringBuilder("");
        page.append("<html><title>ERROR 404</title></html>");
        page.append("<html><H1>ERROR 404</H1></html>");
        page.append("<html><H3>Error en la introduccion de datos. La pagina web no puede ser mostrada. </H3></html>");
        return page;
    }
      
    private StringBuilder procesaPeticionPaginaRaiz(){
        return GeneradorHtml.generaRaiz();
    }
    private StringBuilder procesaPeticionPaginaRegistro(){
        return GeneradorHtml.generarRegistro();
    }
    private StringBuilder procesaPeticionPaginaMenu(Peer usuario){
        return GeneradorHtml.generarMenu(usuario);
    }
   
    private StringBuilder procesaPeticionPaginaDir(Peer usuario, String[] archivos){
        return GeneradorHtml.generarDir(usuario, archivos);
    }
   
    private StringBuilder procesaPeticionPaginaLista(HashMap<String, Peer> terminales, String enteroLargo, ListaUsuarios lista_usuarios){
        return GeneradorHtml.generaLista(terminales, enteroLargo, lista_usuarios);
    }
   
    private StringBuilder procesaPeticionPaginaBaja(){
        return GeneradorHtml.generaBaja();
    }
   
    private StringBuilder generaMensaje200 (StringBuilder htmlPage) {
        StringBuilder respuesta = new StringBuilder("");
        respuesta.append("HTTP/1.1 200 OK\r\n");
        respuesta.append("Connection: close\r\n");
        respuesta.append ("Content-Type: text/html\r\n");
        respuesta.append("Content-Length: " + htmlPage.length() + "\r\n");
        respuesta.append("\r\n");
        respuesta.append(htmlPage);
        return respuesta;
    }

    private StringBuilder generaMensaje404(StringBuilder htmlPage) {
        StringBuilder respuesta = new StringBuilder("");
        respuesta.append("HTTP/1.1 404 Not Found\r\n");
        respuesta.append("Connection: close\r\n");
        respuesta.append("Content-Type: text/html\r\n");
        respuesta.append("Content-Length: " + htmlPage.length() + "\r\n");
        respuesta.append("\r\n");
        respuesta.append(htmlPage);
        return respuesta;
    }
  
    private StringBuilder generaRespuesta(String path, Map<String, String> vars){
       //si el path coincide con alguna etiqueta, muestra la pagina, mensaje 200 OK
        String otra_contrasenia;
        String enteroLargo = null;
       
        //RAIZ
        if(path.contentEquals(Constantes.RAIZ_PATH)){
            //comprobamos que se reciben parametros o no
            if (vars==null){
                return generaMensaje200(procesaPeticionPaginaRaiz());
            }
            else if(vars.size()==2){
                String nick = vars.get(Constantes.NICK);
                String passwd= vars.get(Constantes.CLAVE);
                //si el gestor recibe 2 parametros, comprueba que son reales y entonces manda a la pagina registro o no
                if(nick!=null || passwd!=null){
                    Byte result_comp = comprobacion(nick,passwd);
                    if (result_comp==1){
                       
                        System.out.println("-->Registro");
                        return generaMensaje200(procesaPeticionPaginaRegistro());
                    }
                    else if(result_comp==2){
                        //es decir, que existe el usuario y el archivo pedido
                        //nick valido, pagina menu
                       
                        enteroLargo=usuarios.get(nick);
                        Peer usuario = terminales.get(enteroLargo);
                        try{
                            Usuario user = new Usuario(usuario.getNick(),usuario.getCorreo(),usuario.getNombre(),"localhost", usuario.getPuertoP2P());
                            registro.registrar(user, usuario.getClave());
                        }catch(RemoteException e){
                            System.out.println("-->Error en la ejecucion RMI");
                        }
                       
                        //String nick = usuario.getNick();
                        if (nick!=null){
                            System.out.println("-->Estoy manejando este nick : [" + nick + "]");
                            return generaMensaje200(procesaPeticionPaginaMenu(usuario));
                        }
                        else{
                            //PONER PAGINA INCORRECTA
                            System.out.println("-->Nick vacio");
                            return generaMensaje404(procesaPeticionPaginaError());
                        }
                    }
                    else if(result_comp==0){
                        System.out.println("-->Fallo!");
                        return generaMensaje200(procesaPeticionPaginaError());
                    }
                   
                }
                else{
                    System.out.println("-->Nick y contrasenia vacios...");
                    return generaMensaje404(procesaPeticionPaginaError());
                }
            }
        }//RAIZ
       
        //REGISTRO
        if(path.contentEquals(Constantes.REGISTRAR_PATH)){
            if(vars.size()==0){
                System.out.println("-->Sin variables");
                return generaMensaje200(procesaPeticionPaginaRegistro());
            }
            if(vars.size()==6){
                System.out.println("-->Con 6 variables");
                //se supone que hemos escrito todos los valores!!!!
                String nick=vars.get(Constantes.NICK);
                String passwd=vars.get(Constantes.CLAVE);
                String nombre=vars.get(Constantes.NOMBRE_COMPLETO);
                String puerto_nick=vars.get(Constantes.PUERTOP2P);
                Integer puerto = Integer.parseInt(puerto_nick);
                String Dir_Exportado = vars.get(Constantes.DIRECTORIO_EXPORTADO);
                String email=vars.get(Constantes.CORREO);
               
               
                String nombrecfg = new String(Directorio_Usuarios+ "/"+ nick + ".cfg");
                File archivocfg = new File(nombrecfg);
               
                if(archivocfg.exists()){
                    //EL ARCHIVO EXISTE!!!!
                    enteroLargo= usuarios.get(nick);
                    System.out.println("Esta es la credencial de nuevo del usuario "+ nick + " ---> "+ enteroLargo);
                    if (enteroLargo==null){
                        enteroLargo= new Long(credencial.nextLong()).toString();
                        usuarios.put(nick, enteroLargo);
                       
                        Peer usuario=terminales.get(enteroLargo);
                        otra_contrasenia = usuario.getClave();
                        //ultima comprobacion
                        if (otra_contrasenia.contentEquals(passwd)){
                            try{
                                //encadenamos los Streams necesarios
                                FileOutputStream configuracion = new FileOutputStream(archivocfg);
                                PrintWriter s = new PrintWriter(configuracion);
                                /*
                                Escribiremos dentro del archivo lo siguiente:
                                PUERTO_P2P:
                                DIRECTORIO_EXPORTADO:
                                NICK: nick
                                NOMBRE_COMPLETO:
                                CORREO_ELECTRONICO:
                                CLAVE: clave
                                 */       
                                s.print("PUERTOP2P " +"\""+ puerto +"\"" + "\r\n");
                                s.print("DIRECTORIO_EXPORTADO "+"\""+ Dir_Exportado +"\"" +"\r\n");
                                s.print("NICK " + "\"" +nick + "\""+ "\r\n");
                                s.print("NOMBRE_COMPLETO "+ "\""+nombre +"\"" + "\r\n");
                                s.print("CORREO "+ "\"" + email+"\"" +"\r\n");
                                s.print("CLAVE " + "\"" + passwd+"\"" + "\r\n");
                               
                                  s.flush();
                                s.close();
                                configuracion.close();
                                System.out.println("***FICHERO COMPLETO de " + nick + " creado satisfactoriamente");
                                enteroLargo= new Long(credencial.nextLong()).toString();
                                usuario= new Peer(nick,enteroLargo,archivocfg);
                                usuarios.put(nick, enteroLargo);
                                Usuario user = new Usuario(usuario.getNick(),usuario.getCorreo(),usuario.getNombre(),"localhost", usuario.getPuertoP2P());
                                registro.registrar(user, passwd);
                                return generaMensaje200(procesaPeticionPaginaMenu(usuario));
                            }catch(Exception e){
                                System.out.println("-->Error al escribir en disco...");
                                return generaMensaje404(procesaPeticionPaginaDesconocida());
                            }
                        }//if contrasenias iguales
                        else{
                            //si las claves son distintas procesas PARAMETROS INCORRECTOS!!!
                            System.out.println("-->Parametros incorrectos...claves distintas");
                            return generaMensaje404(procesaPeticionPaginaError());
                        }
                    }//if credencial vacio
                    else{
                        //CRDENCIAL NO VACIO y no asignado
                        try{
                            //encadenamos los Streams necesarios
                            FileOutputStream configuracion = new FileOutputStream(archivocfg);
                            PrintWriter s = new PrintWriter(configuracion);
                            /*
                            Escribiremos dentro del archivo lo siguiente:
                            PUERTO_P2P:
                            DIRECTORIO_EXPORTADO:
                            NICK: nick
                            NOMBRE_COMPLETO:
                            CORREO_ELECTRONICO:
                            CLAVE: clave
                             */       
                            s.print("PUERTOP2P " +"\""+ puerto +"\"" + "\r\n");
                            s.print("DIRECTORIO_EXPORTADO "+"\""+ Dir_Exportado +"\"" +"\r\n");
                            s.print("NICK " + "\"" +nick + "\""+ "\r\n");
                            s.print("NOMBRE_COMPLETO "+ "\""+nombre +"\"" + "\r\n");
                            s.print("CORREO "+ "\"" + email+"\"" +"\r\n");
                            s.print("CLAVE " + "\"" + passwd+"\"" + "\r\n");
                           
                              s.flush();
                            s.close();
                            configuracion.close();
                            System.out.println("***FICHERO COMPLETO de " + nick + " creado satisfactoriamente");
              
                            try{
                                Peer usuario= new Peer(nick,enteroLargo,archivocfg);
                                terminales.put(enteroLargo, usuario);
                                otra_contrasenia = usuario.getClave();
                                Usuario user = new Usuario(usuario.getNick(),usuario.getCorreo(),usuario.getNombre(),"localhost", usuario.getPuertoP2P());
                                registro.registrar(user, passwd);
                                return generaMensaje200(procesaPeticionPaginaMenu(usuario));
                               
                            }catch(Exception e){
                                System.out.println("ERROR2!");
                            }
                        }catch(Exception e){
                            System.out.println("ERROR!");
                        }
                        enteroLargo=usuarios.get(nick);
                    }
                }//ARCHIVO EXISTE               
 
                else{
                    enteroLargo= usuarios.get(nick);
                    if (enteroLargo==null){
                        enteroLargo= new Long(credencial.nextLong()).toString();
                        usuarios.put(nick, enteroLargo);
                        try{
                            Peer usuario = new Peer(nick,enteroLargo,archivocfg);
                        }catch(Exception e){
                           
                            return generaMensaje404(procesaPeticionPaginaDesconocida());
                        }
                        Peer usuario=terminales.get(enteroLargo);
                        otra_contrasenia = usuario.getClave();
                        //ultima comprobacion
                        if (otra_contrasenia.contentEquals(passwd)){
                            try{
                                //encadenamos los Streams necesarios
                                FileOutputStream configuracion = new FileOutputStream(archivocfg);
                                PrintWriter s = new PrintWriter(configuracion);
                                /*
                                 * Escribiremos dentro del archivo lo siguiente:
                                PUERTO_P2P:
                                DIRECTORIO_EXPORTADO:
                                NICK: nick
                                NOMBRE_COMPLETO:
                                CORREO_ELECTRONICO:
                                CLAVE: clave
                                 */       
                                s.print("PUERTOP2P " +"\""+ puerto +"\"" + "\r\n");
                                s.print("DIRECTORIO_EXPORTADO "+"\""+ Dir_Exportado +"\"" +"\r\n");
                                s.print("NICK " + "\"" +nick + "\""+ "\r\n");
                                s.print("NOMBRE_COMPLETO "+ "\""+nombre +"\"" + "\r\n");
                                s.print("CORREO "+ "\"" + email+"\"" +"\r\n");
                                s.print("CLAVE " + "\"" + passwd+"\"" + "\r\n");
                               
                                  s.flush();
                                s.close();
                                configuracion.close();
                                System.out.println("***FICHERO COMPLETO de " + nick + " creado satisfactoriamente");
                                enteroLargo= new Long(credencial.nextLong()).toString();
                                usuario= new Peer(nick,enteroLargo,archivocfg);
                                usuarios.put(nick, enteroLargo);
                                Usuario user = new Usuario(usuario.getNick(),usuario.getCorreo(),usuario.getNombre(),"localhost", usuario.getPuertoP2P());
                                registro.registrar(user, passwd);
                                return generaMensaje200(procesaPeticionPaginaMenu(usuario));
                            }catch(Exception e){
                               
                                return generaMensaje404(procesaPeticionPaginaDesconocida());
                            }
                        }//if contrasenias iguales
                    }//entero largo
                }//else archivo existe
            }//if argumentos=6
               else{
                   //parametros distintos a 6
               
                return generaMensaje200(procesaPeticionPaginaRegistro());
            }
            return generaMensaje200(procesaPeticionPaginaRegistro());
        }//REGISTRAR
       
        //MENU
        if(path.contentEquals(Constantes.MENU_PATH)){
            //menu?credencial=numero_credencial
            if (vars.size() ==1) {
                String nick = null;
                //cogemos la credencial de los datos guardados
                enteroLargo= vars.get(Constantes.CREDENCIAL);
                               
                if (enteroLargo == null){
                    return generaMensaje200(procesaPeticionPaginaRegistro());
                }
                else{
                    if (enteroLargo.contentEquals(vars.get(Constantes.CREDENCIAL))){
                        Peer usuario = terminales.get(enteroLargo);
                        if(usuario==null){
                            return generaMensaje404(procesaPeticionPaginaError());
                        }
                        nick = usuario.getNick();
                        System.out.println("***MENU**** accedido por "+ nick + " credencial con valor " + enteroLargo );
                       
                        if (nick !=null){
                            return generaMensaje200(procesaPeticionPaginaMenu(usuario));
                        }
                        else {
                            //el usuario esta vacio, por lo que no existe...
                            return generaMensaje200(procesaPeticionPaginaRaiz());
                        }
                    }else{
                            return generaMensaje404(procesaPeticionPaginaError());
                    }
                }
            }else{
                return generaMensaje200(procesaPeticionPaginaRaiz());
            }
        }

       
        //DIRECTORIO_LOCAL
        if(path.contentEquals(Constantes.DIR_LOCAL)){
            if (vars.size() ==1) {
                String nick = null;
                enteroLargo= vars.get(Constantes.CREDENCIAL);
               
                if (enteroLargo == null){
                    return generaMensaje200(procesaPeticionPaginaRaiz());
                }
                else{
                    if (enteroLargo.contentEquals(vars.get(Constantes.CREDENCIAL))){
                        Peer usuario=terminales.get(enteroLargo);
                        if(usuario==null){
                            return generaMensaje404(procesaPeticionPaginaError());
                        }
                        nick = usuario.getNick();
                        System.out.println("***DIR_LOCAL*** accedido por "+ nick +" credencial con valor " + enteroLargo );
                        if (nick !=null){
                            return generaMensaje200(procesaPeticionPaginaDir(usuario, usuario.getarchivos()));
                        }
                        else{
                            return generaMensaje200(procesaPeticionPaginaRaiz());
                        }
                    }else{
                        return generaMensaje404(procesaPeticionPaginaError());
                    }
                   
                }
            }else{
                return generaMensaje200(procesaPeticionPaginaError());
            }
        }
        //LISTA_TODOS
        if(path.contentEquals(Constantes.LISTA_TODOS)){
            if (vars.size() ==1) {
                String nick = null;
                enteroLargo= vars.get(Constantes.CREDENCIAL);
                if (enteroLargo == null){
                    return generaMensaje200(procesaPeticionPaginaRaiz());
                }
                else{
                    if (enteroLargo.contentEquals(vars.get(Constantes.CREDENCIAL))){
                        Peer usuario=terminales.get(enteroLargo);
                        if(usuario==null){
                            return generaMensaje404(procesaPeticionPaginaError());
                        }
                        nick = usuario.getNick();
                       
                        try{
                            ListaUsuarios lista_usuarios = registro.getTodos();
                            if (nick !=null){
                                System.out.println("***LISTA_TODOS*** accedido por "+ nick + " con credencial "+ enteroLargo );
                                return generaMensaje200(procesaPeticionPaginaLista(terminales, enteroLargo, lista_usuarios));
                            }
                            else{
                                return generaMensaje200(procesaPeticionPaginaRaiz());
                            }
                        }catch(RemoteException remote){
                            return generaMensaje404(procesaPeticionPaginaError());
                        }
                    }else{
                        return generaMensaje404(procesaPeticionPaginaError());
                    }
                }
            }else{
                return generaMensaje200(procesaPeticionPaginaError());
            }
        }
       
        //DAR_DE_BAJA
        if(path.contentEquals(Constantes.DAR_DE_BAJA)){
            if (vars.size() ==1) {
                String nick = null;
                enteroLargo= vars.get(Constantes.CREDENCIAL);
                if (enteroLargo == null){
                    return generaMensaje200(procesaPeticionPaginaRaiz());
                }
                else{
                    if (enteroLargo.contentEquals(vars.get(Constantes.CREDENCIAL))){
                        Peer usuario=terminales.get(enteroLargo);
                        nick = usuario.getNick();
                       
                        try{
                            registro.darDeBaja(nick, usuario.getClave());
                            if (nick !=null){
                                System.out.println("***DAR_DE_BAJA*** accedido por "+ nick + " con credencial "+ enteroLargo );
                                terminales.remove(usuario);
                                return generaMensaje200(procesaPeticionPaginaBaja());
                            }
                            else{
                                return generaMensaje200(procesaPeticionPaginaRaiz());
                            }
                        }catch(RemoteException remote){
                            return generaMensaje404(procesaPeticionPaginaError());
                        }
                    }else{
                        return generaMensaje404(procesaPeticionPaginaError());
                    }
                }
            }else{
                return generaMensaje200(procesaPeticionPaginaError());
            }
        }
   
       //si no, devuelve mensaje de error
       //System.out.println("NO HAY VALORES DE ENTRADA!");
       return generaMensaje404(procesaPeticionPaginaDesconocida());
   
        }
      
    public void run(){
        try{
            //Recuperamos la peticion del cliente
            BufferedReader in = new BufferedReader(new InputStreamReader(this.socket.getInputStream()));
          
            //Leemos la primera linea (linea de peticion HTTP) que es obligatoria
            String firstLine = in.readLine();
            iteraciones++;
            Date ahora = new Date();
            //Escribir en la consola que pagina se esta accediendo en ese momento
            System.out.println(iteraciones + ") "+ ahora + " -> " + firstLine);
                      
            //Leemos resto de cabeceras, por si nos interesan. Solo trabajamos con GET, por lo que no hay cuerpo
            String line = null;
            while( (line=in.readLine()) != null){
                //Si la linea esta en blanco, entonces se han terminado las cabeceras
                if(line.contentEquals(""))
                    break;
            }
              
            //Recuperamos el recuros solicitado y las variables GET presentes
            String path = AnalizadorHttpGet.getPath(firstLine);
            Map<String, String> vars = AnalizadorHttpGet.getVars(firstLine);
           
          
            //Procedemos a construir la respuesta
            StringBuilder respuesta = generaRespuesta(path, vars);
           
           
           
            PrintWriter out = new PrintWriter(new OutputStreamWriter(this.socket.getOutputStream()));
            out.print(respuesta.toString());
            out.close();
            in.close();
          
        } catch (IOException e) {
            System.out.println ("AVISO: ha habido un problema leyendo o escribiendo en el socket especificado");
            System.out.println("Los detalles del problema son los siguientes");
            System.out.println(e.getMessage ());
            e.printStackTrace();
            return;
        }
    }

}