package es.urjc.escet.gsyc.html;

import es.urjc.escet.gsyc.html.internal.Html;
import es.urjc.escet.gsyc.html.internal.HtmlForm;
import es.urjc.escet.gsyc.html.internal.HtmlP;
import es.urjc.escet.gsyc.html.internal.HtmlTable;
import es.urjc.escet.gsyc.html.internal.HtmlTableTd;
import es.urjc.escet.gsyc.html.internal.HtmlTableTr;
import es.urjc.escet.gsyc.http.Constantes;
import es.urjc.escet.gsyc.p2p.ListaUsuarios;
import es.urjc.escet.gsyc.p2p.Usuario;
import es.urjc.escet.gsyc.peer.Peer;

import java.util.HashMap;


public class GeneradorHtml {


  public static StringBuilder generaRaiz() {
    Html page = new Html();
    //aniadimos un titulo a la pagina
    page.setTile("***PAGINA DE REGISTRO DE LA APLICACION P2P DE ST-II***");
    page.addBr();
    HtmlP p = page.addP();
    p.addText("<html><H1 align=center>Bienvenido a la aplicacion P2P de ST-II</H1></html>");
    //p.setAlign(HtmlP.AlignType.CENTER);
    page.addHr();

    //Creamos una tabla de 3x3
    HtmlTable table = page.addTable();
    HtmlTableTr[] tr = new HtmlTableTr[3];
    HtmlTableTd[][] td = new HtmlTableTd[3][3];

    //Creamos los trs
    for (int i = 0; i < 3; i++)
      tr[i] = table.addTr();

    //Creamos los tds
    for (int i = 0; i < 3; i++)
      for (int j = 0; j < 3; j++)
        td[i][j] = tr[i].addTd();

    //Damos formato
    //table.setBorder(1);
    tr[0].setHeight(100);
    tr[1].setHeight(100);
    tr[1].setValign(HtmlTableTr.ValignStyle.BOTTOM);
    tr[2].setHeight(50);
    td[0][0].setWidth(35);
    td[0][1].setWidth(25);
    td[0][2].setWidth(40);

    //Creamos el formulario en el td central
    HtmlForm f = td[1][1].addForm(Constantes.RAIZ_PATH);

    //Creamos la tabla interna
    HtmlTable itable = f.addTable();
    HtmlTableTr[] itr = new HtmlTableTr[3];
    for (int i = 0; i < 3; i++)
      itr[i] = itable.addTr();

    HtmlTableTd[][] itd = new HtmlTableTd[3][2];
    for (int i = 0; i < 3; i++)
      for (int j = 0; j < 2; j++)
        itd[i][j] = itr[i].addTd();

    //Damos formato a la tabla interna
    //itable.setBorder(1);

    itd[0][0].setWidth(25);
    //Aniadimos los campos de formulario
    itd[0][0].addText("Nick P2P: ");
    itd[0][1].addInputText(Constantes.NICK);
    itd[1][0].addText("Contrasenia: ");
    itd[1][1].addInputPassword(Constantes.CLAVE);


    itr[2].setHeight(40);
    itr[2].setValign(HtmlTableTr.ValignStyle.BOTTOM);
    itd[2][0].addInputSubmit("  Enviar  ");
    itd[2][0].setAlign(HtmlTableTd.AlignStyle.CENTER);
    itd[2][1].addInputReset("  Borrar  ");
    itd[2][1].setAlign(HtmlTableTd.AlignStyle.CENTER);

    page.addHr();

    return page.getPage();
  }

  public static StringBuilder generarRegistro() {
    Html page = new Html();

    page.setTile("***MENU DE REGISTRO***");//+ Constantes.NICK + " ***");
    page.addBr();
    page.addText("<html><H1 align=center>Formulario para clientes nuevos</H1></html>");
    HtmlP p = page.addP();
    p.addText("<html><H3 align=center>A continuacion debe escribir sus datos:</H3></html>");
    p.setAlign(HtmlP.AlignType.CENTER);
    page.addHr();

    //Creamos una tabla de 3x3
    HtmlTable table = page.addTable();
    HtmlTableTr[] tr = new HtmlTableTr[3];
    HtmlTableTd[][] td = new HtmlTableTd[3][3];

    //Creamos los trs
    for (int i = 0; i < 3; i++)
      tr[i] = table.addTr();

    //Creamos los tds
    for (int i = 0; i < 3; i++)
      for (int j = 0; j < 3; j++)
        td[i][j] = tr[i].addTd();

    //Damos formato
    //table.setBorder(1);
    tr[0].setHeight(100);
    tr[1].setHeight(100);
    tr[1].setValign(HtmlTableTr.ValignStyle.BOTTOM);
    tr[2].setHeight(50);
    td[0][0].setWidth(35);
    td[0][1].setWidth(25);
    td[0][2].setWidth(40);

    //Creamos el formulario en el td central
    //HtmlForm f = td[1][1].addForm(Constantes.DIR_LOCAL + "?" + Constantes.CREDENCIAL + "=" + Peer.getCredencial());
    HtmlForm f = td[1][1].addForm(Constantes.REGISTRAR_PATH);

    //Creamos la tabla interna
    HtmlTable itable = f.addTable();
    HtmlTableTr[] itr = new HtmlTableTr[7];
    for (int i = 0; i < 7; i++)
      itr[i] = itable.addTr();

    HtmlTableTd[][] itd = new HtmlTableTd[7][2];
    for (int i = 0; i < 7; i++)
      for (int j = 0; j < 2; j++)
        itd[i][j] = itr[i].addTd();

    //Damos formato a la tabla interna
    //itable.setBorder(1);

    itd[0][0].setWidth(150);
    //Aniadimos los campos de formulario

    itd[0][0].addText("Nombre Completo:");
    itd[0][1].addInputText(Constantes.NOMBRE_COMPLETO);
    itd[1][0].addText("Nick:");
    itd[1][1].addInputText(Constantes.NICK);
    itd[2][0].addText("Clave:");
    itd[2][1].addInputPassword(Constantes.CLAVE);
    itd[3][0].addText("Correo electronico:");
    itd[3][1].addInputText(Constantes.CORREO);
    itd[4][0].addText("Puerto P2P:");
    itd[4][1].addInputText(Constantes.PUERTOP2P);
    itd[5][0].addText("Directorio Exportado:");
    itd[5][1].addInputText(Constantes.DIRECTORIO_EXPORTADO);


    itr[6].setHeight(40);
    itr[6].setValign(HtmlTableTr.ValignStyle.BOTTOM);
    itd[6][0].addInputSubmit("  Aceptar  ");
    itd[6][0].setAlign(HtmlTableTd.AlignStyle.CENTER);
    itd[6][1].addInputReset("  Borrar  ");
    itd[6][1].setAlign(HtmlTableTd.AlignStyle.CENTER);

    page.addHr();

    return page.getPage();
  }

  public static StringBuilder generarMenu(Peer usuario) {
    Html page = new Html();

    page.setTile("***MENU DEL USUARIO " + usuario.getNick() + " ***");
    page.addBr();
    page.addBr();
    HtmlP p = page.addP();
    p.addText("<html><H1 align=center>MENU usuario " + usuario.getNick() + "</H1></html>");
    p.setAlign(HtmlP.AlignType.CENTER);
    page.addHr();

    //Creamos la tabla interna
    HtmlTable itable = page.addTable();
    HtmlTableTr[] itr = new HtmlTableTr[7];
    for (int i = 0; i < 7; i++)
      itr[i] = itable.addTr();

    //Ponemos 7 filas por si acaso queremos poner la clave por pantalla tambien
    HtmlTableTd[][] itd = new HtmlTableTd[7][1];
    for (int i = 0; i < 7; i++)
      for (int j = 0; j < 1; j++)
        itd[i][j] = itr[i].addTd();

    //Damos formato a la tabla interna
    //itable.setBorder(1);

    itd[0][0].setWidth(150);

    itd[0][0].addText("--->DATOS DEL USUARIO<---");
    itd[1][0].addText("NICK: " + usuario.getNick());
    itd[2][0].addText("NOMBRE COMPLETO: " + usuario.getNombre());
    itd[3][0].addText("CORREO ELECTRONICO: " + usuario.getCorreo());
    itd[4][0].addText("PUERTO P2P: " + usuario.getPuertoP2P());
    itd[5][0].addText("DIRECTORIO EXPORTADO: " + usuario.getDirectorio());

    page.addBr();
    page.addHr();
    page.addText("Que desea hacer?");
    page.addBr();
    page.addBr();
    page.addA(Constantes.MENU_PATH + "?" + Constantes.CREDENCIAL + "=" + usuario.getCredencial(), "MENU");
    page.addBr();
    page.addBr();
    page.addA(Constantes.RAIZ_PATH, "INICIO");
    page.addBr();
    page.addBr();
    page.addA(Constantes.REGISTRAR_PATH + "?" + Constantes.CREDENCIAL + "=" + usuario.getCredencial(), "MODIFICAR DATOS");
    page.addBr();
    page.addBr();
    page.addA(Constantes.DIR_LOCAL + "?" + Constantes.CREDENCIAL + "=" + usuario.getCredencial(), "DIRECTORIO LOCAL");
    page.addBr();
    page.addBr();
    page.addA(Constantes.LISTA_TODOS + "?" + Constantes.CREDENCIAL + "=" + usuario.getCredencial(), "LISTADO DE USUARIOS");
    page.addBr();
    page.addBr();
    page.addA(Constantes.DAR_DE_BAJA + "?" + Constantes.CREDENCIAL + "=" + usuario.getCredencial(), "DARSE DE BAJA");
    page.addBr();

    return page.getPage();
  }

  public static StringBuilder generarDir(Peer usuario, String[] archivos) {
    Html page = new Html();

    page.setTile("***DIRECTORIO DEL USUARIO " + usuario.getNick() + " ***");
    page.addBr();
    HtmlP p = page.addP();
    p.addText("<html><H1 align=center>Esta es la pagina directorio del usuario " + usuario.getNick() + "</H1></html>");
    p.setAlign(HtmlP.AlignType.CENTER);
    page.addHr();

    page.addText("<html><H3 align=center>Contenido del archivo exportado===> " + usuario.getDirectorio() + "</H3></html>");
    page.addBr();
    int numerodearchivos;
    numerodearchivos = archivos.length;
    if (numerodearchivos == 0) {
      page.addBr();
      page.addText("El directorio exportado no contiene ningun archivo.");
      page.addBr();
    } else {
      for (int x = 1; x < numerodearchivos; x++) {
        page.addBr();
        page.addText(x + ")--> " + archivos[x]);
        page.addBr();
      }
    }

    page.addBr();
    page.addA(Constantes.MENU_PATH + "?" + Constantes.CREDENCIAL + "=" + usuario.getCredencial(), "MENU");
    page.addHr();

    return page.getPage();
  }

  public static StringBuilder generaLista(HashMap<String, Peer> terminales, String enteroLargo, ListaUsuarios lista_usuarios) {
    Html page = new Html();
    Peer usuario = terminales.get(enteroLargo);
    int numero = 0;
    page.setTile("***LISTADO DE LOS USUARIOS accedido por " + usuario.getNick() + "***");
    page.addBr();
    HtmlP p = page.addP();
    p.addText("<html><H1 align=center> LISTADO de los usuarios</H1><html>");
    p.addText("<html><H3 align=center><BLINK>A continuacion se listaran todos los usuarios que ahora estan disponibles/conectados</BLINK></H3></html>");
    page.addBr();
    page.addHr();

    p.setAlign(HtmlP.AlignType.CENTER);
    if (terminales != null) {
      numero = terminales.size();
    }
    System.out.println("Numero de usuarios disponibles-> " + (numero));
    for (int x = 1; x < numero + 1; x++) {

      //procedemos a sacar los usuarios
      Usuario usuarioN = lista_usuarios.getUsuario(x - 1);
      if (usuarioN != null) {
        page.addBr();
        page.addHr();
        page.addText("USUARIO--> " + x);
        page.addBr();
        page.addText("Nick usuario: " + usuarioN.getNick());
        page.addBr();
        page.addText("Nombre Completo: " + usuarioN.getNombreCompleto());
        page.addBr();
        page.addText("Correo electronico: " + usuarioN.getCorreoElectronico());
        page.addBr();
        page.addText("Host del usuario: " + usuarioN.getHost());
        page.addBr();
        String puerto = Integer.toString(usuarioN.getPuertop2p());
        page.addText("Puerto en uso: " + puerto);
        page.addBr();

        page.addHr();
      }
    }

    page.addBr();
    page.addA(Constantes.MENU_PATH + "?" + Constantes.CREDENCIAL + "=" + usuario.getCredencial(), "MENU");
    page.addHr();

    return page.getPage();
  }

  public static StringBuilder generaBaja() {
    Html page = new Html();

    page.setTile("***BAJA DE USUARIOS***");
    page.addBr();
    HtmlP p = page.addP();
    p.addText("<html><H2 align=center>El usuario se ha dado de baja en el Servidor Central</H2></html>");
    p.setAlign(HtmlP.AlignType.CENTER);
    page.addHr();

    page.addBr();
    page.addA(Constantes.RAIZ_PATH, "INICIO");
    page.addBr();

    return page.getPage();
  }

}
