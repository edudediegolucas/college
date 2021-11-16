/*
	***************************************************************
	Práctica 5 realizada por Eduardo de Diego Lucas, 4º TELECO+ITS
	
	·Comando para compilar el archivo fuente en C:

	gcc -Wall -lpthread -lncurses -o edulucas_p5 edulucas_p5.c
	
	·Comando para ejecutar la práctica:
	
	./edulucas_p5 mapaX
	***************************************************************
*/

#include <stdlib.h>
#include <stdio.h>
#include <pthread.h>
#include <unistd.h>
#include <sched.h>
#include <sys/time.h>
#include <signal.h>
#include <ncurses.h>

// Tamaño del mapa
#define FIL 20
#define COL 50

// Rango de los sensores
#define RANGO 5

// Mapa
char mapa[FIL][COL+1];

// Robot
typedef enum orientacion{
	N,E,S,O
}orientacion;

typedef struct t_posicion{
	int x,y; 
	orientacion or;
}t_posicion;

typedef struct t_sensores{
	int s1,s2,s3;
}t_sensores;

typedef struct t_robot{
	t_posicion pos; 
	int M1,M2;
}t_robot;

char simbolo[4]={
	'^','>','V','<'
};

//Variable ROBOT
t_robot robot; 

//Variables globales
pthread_mutex_t semaforo;
int coordenadax;
int coordenaday;

//Metodos generales

void
iniciarPantalla(void)
{
	// Metodo para el arranque de la practica en la que aconseja ajustar la ventana.

	initscr();
	start_color();
	init_pair(1, COLOR_BLACK, COLOR_WHITE);
	attron(COLOR_PAIR(1));
	mvprintw(10,5,"MODO RECOMENDADO DE VENTANA: 60x25. Ajuste la ventana.");
	mvprintw(11,5,"Recuerde que el mapa es de 20x50 y empieza en 0,0");
	mvprintw(12,5,"Cuando esté listo, pulse una tecla.");
	attroff(COLOR_PAIR(1));
	refresh();
	getch();
	clear();
}

void
leerMapa(char *ruta)
{
	// Metodo para la lectura del mapa por medio de un fichero guardado en disco.

	FILE *fp;
	int i = 0;
	int j = 0;
	if ((fp = fopen(ruta, "r")) == NULL){
		endwin();
		perror("ERROR: el fichero mapa no se puede abrir.");
		exit(1);
	} 
	while(!ferror(fp) && !feof(fp)){
		if(j != COL+1){ //tenemos en cuenta los \n
			mapa[i][j] = fgetc(fp);
			j++;
		}
		else{
			j = 0;
			i++;	
		}
	}
	
	if(ferror(fp)){
		endwin();	
		perror("ERROR: lectura erronea de fichero.\n");		
	}
	fclose(fp);
}

int
comprobarMapa()
{
	// Metodo que comprueba que no haya un obstaculo en la posicion inical del robot.

	if(mapa[0][0] != 'X')
		return 1;
	else
		return 0;
}

void
pintaMapa(void) 
{
	// Metodo que pinta el mapa en pantalla utilizando la libreria de ncurses.h

	int x, y;
	
	y = 0;
	initscr();
	start_color();
	init_pair(1, COLOR_RED, COLOR_WHITE);
	init_pair(2, COLOR_CYAN, COLOR_BLACK);
	init_pair(3, COLOR_BLACK, COLOR_YELLOW);
	
	for(x = 0;x<FIL;x++){
		while(y != COL+1){
			if((mapa[x][y] == simbolo[0]) || (mapa[x][y] == simbolo[1]) || (mapa[x][y] == simbolo[2]) || (mapa[x][y] == simbolo[3])){
				attron(COLOR_PAIR(1));
				mvprintw(x,y, "%c",mapa[x][y]);
				attroff(COLOR_PAIR(1));
			}else{
				attron(COLOR_PAIR(2));
				mvprintw(x,y, "%c",mapa[x][y]);
				attroff(COLOR_PAIR(2));
			}
			if(mapa[x][y] == '#'){
				attron(COLOR_PAIR(3));
				mvprintw(x,y, "%c",mapa[x][y]);
				attroff(COLOR_PAIR(3));
			}
			y++;
		}
		y = 0;
	}
	refresh();
}

void
dameCoordenadas(void) 
{
	// Metoddo que pide las coordenadas

	char x[3], y[3];
	int p = 0;
	
	start_color();
	init_pair(5, COLOR_RED, COLOR_WHITE);
	init_pair(3, COLOR_BLACK, COLOR_YELLOW);
	
	while(!p){	
		initscr();
		attron(COLOR_PAIR(5));
		mvprintw(21,0,"*******************");
		attroff(COLOR_PAIR(5));
		mvprintw(22,0,"[Posicion x] => ");
		getstr(x);
		mvprintw(23,0,"[Posicion y] => ");
		getstr(y);
		attron(COLOR_PAIR(5));
		mvprintw(24,0,"*******************");
		attroff(COLOR_PAIR(5));
		refresh();
		coordenadax = atoi(x);
		coordenaday = atoi(y);
		if((mapa[coordenadax][coordenaday] == 'X') || (coordenadax > FIL-1)  || (coordenadax < 0)  || (coordenaday > COL-1) || (coordenaday < 0)){
			initscr();
			attron(COLOR_PAIR(3));
			mvprintw(7,5,"****************************************");
			mvprintw(8,5,"********COORDENADA ERRONEA  !!!*********");
			mvprintw(9,5,"****************************************");
			attroff(COLOR_PAIR(3));
			refresh();
			getch();
			clear();
			pintaMapa();
		}else{
			p = 1;
			mapa[coordenadax][coordenaday] = '#';
			pintaMapa();
		}
	}
}

int
sacarDistancia(t_sensores *sens)
{
	// Metoddo que hace la logica del robot.
	//Devolvera 0 si NO tiene que cambiar de direccion
	//1 si tiene que dar un giro horario y 2 si tiene que dar un giro antihorario
	int x, y, giro;	
	
	
	x = robot.pos.x;
	y = robot.pos.y;
	giro = 0;
	
	switch(robot.pos.or){
		case N:
			if(x == coordenadax){
				if(y > coordenaday){ //izquierda
					if(sens->s1 == 0)
						giro = 0;
					if(sens->s2 == 0)
						giro = 2;
					if(sens->s3 == 0)
						giro = 2;
					if((sens->s1 == 0) && (sens->s3 == 0))
						giro = 0;
					if((sens->s1 == 0) && (sens->s2 == 0))
						giro = 1;
					if((sens->s3 == 0) && (sens->s2 == 0))
						giro = 2;
					if((sens->s1 == 0) && (sens->s2 == 0) && (sens->s3 == 0))
						giro = 1;
					if((sens->s1 != 0) && (sens->s2 != 0) && (sens->s3 != 0))
						giro = 2;
				}else{ //derecha
					if(sens->s1 == 0)
						giro = 1;
					if(sens->s2 == 0)
						giro = 1;
					if(sens->s3 == 0)
						giro = 0;
					if((sens->s1 == 0) && (sens->s3 == 0))
						giro = 0;
					if((sens->s1 == 0) && (sens->s2 == 0))
						giro = 1;
					if((sens->s3 == 0) && (sens->s2 == 0))
						giro = 2;
					if((sens->s1 == 0) && (sens->s2 == 0) && (sens->s3 == 0))
						giro = 1;
					if((sens->s1 != 0) && (sens->s2 != 0) && (sens->s3 != 0))
						giro = 1;
				}
			}else{
				if((x > coordenadax) && (y > coordenaday)){ //arriba e izquierda
					if(sens->s1 == 0)
						giro = 0;
					if(sens->s2 == 0)
						giro = 2;
					if(sens->s3 == 0)
						giro = 0;
					if((sens->s1 == 0) && (sens->s3 == 0))
						giro = 0;
					if((sens->s1 == 0) && (sens->s2 == 0))
						giro = 1;
					if((sens->s3 == 0) && (sens->s2 == 0))
						giro = 2;
					if((sens->s1 == 0) && (sens->s2 == 0) && (sens->s3 == 0))
						giro = 1;
					if((sens->s1 != 0) && (sens->s2 != 0) && (sens->s3 != 0))
						giro = 0;
				}
				if((x > coordenadax) && (y < coordenaday)){ //arriba y derecha
					if(sens->s1 == 0)
						giro = 0;
					if(sens->s2 == 0)
						giro = 1;
					if(sens->s3 == 0)
						giro = 1;
					if((sens->s1 == 0) && (sens->s3 == 0))
						giro = 0;
					if((sens->s1 == 0) && (sens->s2 == 0))
						giro = 1;
					if((sens->s3 == 0) && (sens->s2 == 0))
						giro = 2;
					if((sens->s1 == 0) && (sens->s2 == 0) && (sens->s3 == 0))
						giro = 1;
					if((sens->s1 != 0) && (sens->s2 != 0) && (sens->s3 != 0))
						giro = 0;
				}
				if((x > coordenadax) && (y == coordenaday)){ //arriba 
					if(sens->s1 == 0)
						giro = 0;
					if(sens->s2 == 0)
						giro = 1;
					if(sens->s3 == 0)
						giro = 0;
					if((sens->s1 == 0) && (sens->s3 == 0))
						giro = 0;
					if((sens->s1 == 0) && (sens->s2 == 0))
						giro = 1;
					if((sens->s3 == 0) && (sens->s2 == 0))
						giro = 2;
					if((sens->s1 == 0) && (sens->s2 == 0) && (sens->s3 == 0))
						giro = 1;
					if((sens->s1 != 0) && (sens->s2 != 0) && (sens->s3 != 0))
						giro = 0;
				}
				if((x < coordenadax) && (y > coordenaday)){ //abajo e izquierda
					if(sens->s1 == 0)
						giro = 1;
					if(sens->s2 == 0)
						giro = 1;
					if(sens->s3 == 0)
						giro = 2;
					if((sens->s1 == 0) && (sens->s3 == 0))
						giro = 1;
					if((sens->s1 == 0) && (sens->s2 == 0))
						giro = 1;
					if((sens->s3 == 0) && (sens->s2 == 0))
						giro = 2;
					if((sens->s1 == 0) && (sens->s2 == 0) && (sens->s3 == 0))
						giro = 1;
					if((sens->s1 != 0) && (sens->s2 != 0) && (sens->s3 != 0))
						giro = 2;
				}
				if((x < coordenadax) && (y < coordenaday)){ //abajo y derecha
					if(sens->s1 == 0)
						giro = 1;
					if(sens->s2 == 0)
						giro = 1;
					if(sens->s3 == 0)
						giro = 2;
					if((sens->s1 == 0) && (sens->s3 == 0))
						giro = 1;
					if((sens->s1 == 0) && (sens->s2 == 0))
						giro = 1;
					if((sens->s3 == 0) && (sens->s2 == 0))
						giro = 2;
					if((sens->s1 == 0) && (sens->s2 == 0) && (sens->s3 == 0))
						giro = 1;
					if((sens->s1 != 0) && (sens->s2 != 0) && (sens->s3 != 0))
						giro = 1;
				}
				if((x < coordenadax) && (y == coordenaday)){ //abajo
					if(sens->s1 == 0)
						giro = 1;
					if(sens->s2 == 0)
						giro = 1;
					if(sens->s3 == 0)
						giro = 2;
					if((sens->s1 == 0) && (sens->s3 == 0))
						giro = 1;
					if((sens->s1 == 0) && (sens->s2 == 0))
						giro = 1;
					if((sens->s3 == 0) && (sens->s2 == 0))
						giro = 2;
					if((sens->s1 == 0) && (sens->s2 == 0) && (sens->s3 == 0))
						giro = 1;
					if((sens->s1 != 0) && (sens->s2 != 0) && (sens->s3 != 0))
						giro = 1;
				}
			}
			break;
		case E:
			if(x == coordenadax){
				if(y > coordenaday){ //izquierda
					if(sens->s1 == 0)
						giro = 1;
					if(sens->s2 == 0)
						giro = 1;
					if(sens->s3 == 0)
						giro = 1;
					if((sens->s1 == 0) && (sens->s3 == 0))
						giro = 1;
					if((sens->s1 == 0) && (sens->s2 == 0))
						giro = 1;
					if((sens->s3 == 0) && (sens->s2 == 0))
						giro = 2;
					if((sens->s1 == 0) && (sens->s2 == 0) && (sens->s3 == 0))
						giro = 1;
					if((sens->s1 != 0) && (sens->s2 != 0) && (sens->s3 != 0))
						giro = 1;
				}else{ //derecha
					if(sens->s1 == 0)
						giro = 0;
					if(sens->s2 == 0)
						giro = 1;
					if(sens->s3 == 0)
						giro = 0;
					if((sens->s1 == 0) && (sens->s3 == 0))
						giro = 0;
					if((sens->s1 == 0) && (sens->s2 == 0))
						giro = 1;
					if((sens->s3 == 0) && (sens->s2 == 0))
						giro = 2;
					if((sens->s1 == 0) && (sens->s2 == 0) && (sens->s3 == 0))
						giro = 1;
					if((sens->s1 != 0) && (sens->s2 != 0) && (sens->s3 != 0))
						giro = 0;
				}
			}else{
				if((x > coordenadax) && (y > coordenaday)){ //arriba e izquierda
					if(sens->s1 == 0)
						giro = 1;
					if(sens->s2 == 0)
						giro = 1;
					if(sens->s3 == 0)
						giro = 2;
					if((sens->s1 == 0) && (sens->s3 == 0))
						giro = 1;
					if((sens->s1 == 0) && (sens->s2 == 0))
						giro = 1;
					if((sens->s3 == 0) && (sens->s2 == 0))
						giro = 2;
					if((sens->s1 == 0) && (sens->s2 == 0) && (sens->s3 == 0))
						giro = 1;
					if((sens->s1 != 0) && (sens->s2 != 0) && (sens->s3 != 0))
						giro = 1;
				}
				if((x > coordenadax) && (y < coordenaday)){ //arriba y derecha
					if(sens->s1 == 0)
						giro = 0;
					if(sens->s2 == 0)
						giro = 2;
					if(sens->s3 == 0)
						giro = 0;
					if((sens->s1 == 0) && (sens->s3 == 0))
						giro = 0;
					if((sens->s1 == 0) && (sens->s2 == 0))
						giro = 1;
					if((sens->s3 == 0) && (sens->s2 == 0))
						giro = 2;
					if((sens->s1 == 0) && (sens->s2 == 0) && (sens->s3 == 0))
						giro = 1;
					if((sens->s1 != 0) && (sens->s2 != 0) && (sens->s3 != 0))
						giro = 0;
				}
				if((x > coordenadax) && (y == coordenaday)){ //arriba 
					if(sens->s1 == 0)
						giro = 0;
					if(sens->s2 == 0)
						giro = 2;
					if(sens->s3 == 0)
						giro = 2;
					if((sens->s1 == 0) && (sens->s3 == 0))
						giro = 0;
					if((sens->s1 == 0) && (sens->s2 == 0))
						giro = 1;
					if((sens->s3 == 0) && (sens->s2 == 0))
						giro = 2;
					if((sens->s1 == 0) && (sens->s2 == 0) && (sens->s3 == 0))
						giro = 1;
					if((sens->s1 != 0) && (sens->s2 != 0) && (sens->s3 != 0))
						giro = 2;
				}
				if((x < coordenadax) && (y > coordenaday)){ //abajo e izquierda
					if(sens->s1 == 0)
						giro = 1;
					if(sens->s2 == 0)
						giro = 1;
					if(sens->s3 == 0)
						giro = 0;
					if((sens->s1 == 0) && (sens->s3 == 0))
						giro = 1;
					if((sens->s1 == 0) && (sens->s2 == 0))
						giro = 1;
					if((sens->s3 == 0) && (sens->s2 == 0))
						giro = 2;
					if((sens->s1 == 0) && (sens->s2 == 0) && (sens->s3 == 0))
						giro = 1;
					if((sens->s1 != 0) && (sens->s2 != 0) && (sens->s3 != 0))
						giro = 1;
				}
				if((x < coordenadax) && (y < coordenaday)){ //abajo y derecha
					if(sens->s1 == 0)
						giro = 0;
					if(sens->s2 == 0)
						giro = 1;
					if(sens->s3 == 0)
						giro = 0;
					if((sens->s1 == 0) && (sens->s3 == 0))
						giro = 0;
					if((sens->s1 == 0) && (sens->s2 == 0))
						giro = 1;
					if((sens->s3 == 0) && (sens->s2 == 0))
						giro = 2;
					if((sens->s1 == 0) && (sens->s2 == 0) && (sens->s3 == 0))
						giro = 1;
					if((sens->s1 != 0) && (sens->s2 != 0) && (sens->s3 != 0))
						giro = 0;
				}
				if((x < coordenadax) && (y == coordenaday)){ //abajo 
					if(sens->s1 == 0)
						giro = 1;
					if(sens->s2 == 0)
						giro = 1;
					if(sens->s3 == 0)
						giro = 0;
					if((sens->s1 == 0) && (sens->s3 == 0))
						giro = 0;
					if((sens->s1 == 0) && (sens->s2 == 0))
						giro = 1;
					if((sens->s3 == 0) && (sens->s2 == 0))
						giro = 2;
					if((sens->s1 == 0) && (sens->s2 == 0) && (sens->s3 == 0))
						giro = 1;
					if((sens->s1 != 0) && (sens->s2 != 0) && (sens->s3 != 0))
						giro = 1;
				}
			}
			break;
		case S:
			if(x == coordenadax){
				if(y > coordenaday){ //izquierda
					if(sens->s1 == 0)
						giro = 1;
					if(sens->s2 == 0)
						giro = 1;
					if(sens->s3 == 0)
						giro = 0;
					if((sens->s1 == 0) && (sens->s3 == 0))
						giro = 0;
					if((sens->s1 == 0) && (sens->s2 == 0))
						giro = 1;
					if((sens->s3 == 0) && (sens->s2 == 0))
						giro = 2;
					if((sens->s1 == 0) && (sens->s2 == 0) && (sens->s3 == 0))
						giro = 1;
					if((sens->s1 != 0) && (sens->s2 != 0) && (sens->s3 != 0))
						giro = 1;
				}else{ //derecha
					if(sens->s1 == 0)
						giro = 0;
					if(sens->s2 == 0)
						giro = 2;
					if(sens->s3 == 0)
						giro = 2;
					if((sens->s1 == 0) && (sens->s3 == 0))
						giro = 0;
					if((sens->s1 == 0) && (sens->s2 == 0))
						giro = 1;
					if((sens->s3 == 0) && (sens->s2 == 0))
						giro = 2;
					if((sens->s1 == 0) && (sens->s2 == 0) && (sens->s3 == 0))
						giro = 1;
					if((sens->s1 != 0) && (sens->s2 != 0) && (sens->s3 != 0))
						giro = 2;
				}
			}else{
				if((x > coordenadax) && (y > coordenaday)){ //arriba e izquierda
					if(sens->s2 == 0)
						giro = 1;
					if(sens->s2 == 0)
						giro = 1;
					if(sens->s3 == 0)
						giro = 0;
					if((sens->s1 == 0) && (sens->s3 == 0))
						giro = 1;
					if((sens->s1 == 0) && (sens->s2 == 0))
						giro = 1;
					if((sens->s3 == 0) && (sens->s2 == 0))
						giro = 2;
					if((sens->s1 == 0) && (sens->s2 == 0) && (sens->s3 == 0))
						giro = 1;
					if((sens->s1 != 0) && (sens->s2 != 0) && (sens->s3 != 0))
						giro = 1;
				}
				if((x > coordenadax) && (y < coordenaday)){ //arriba y derecha
					if(sens->s1 == 0)
						giro = 1;
					if(sens->s2 == 0)
						giro = 1;
					if(sens->s3 == 0)
						giro = 2;
					if((sens->s1 == 0) && (sens->s3 == 0))
						giro = 1;
					if((sens->s1 == 0) && (sens->s2 == 0))
						giro = 1;
					if((sens->s3 == 0) && (sens->s2 == 0))
						giro = 2;
					if((sens->s1 == 0) && (sens->s2 == 0) && (sens->s3 == 0))
						giro = 1;
					if((sens->s1 != 0) && (sens->s2 != 0) && (sens->s3 != 0))
						giro = 1;
				}
				if((x > coordenadax) && (y == coordenaday)){ //arriba 
					if(sens->s1 == 0)
						giro = 1;
					if(sens->s2 == 0)
						giro = 1;
					if(sens->s3 == 0)
						giro = 2;
					if((sens->s1 == 0) && (sens->s3 == 0))
						giro = 1;
					if((sens->s1 == 0) && (sens->s2 == 0))
						giro = 1;
					if((sens->s3 == 0) && (sens->s2 == 0))
						giro = 2;
					if((sens->s1 == 0) && (sens->s2 == 0) && (sens->s3 == 0))
						giro = 1;
					if((sens->s1 != 0) && (sens->s2 != 0) && (sens->s3 != 0))
						giro = 1;
				}
				if((x < coordenadax) && (y > coordenaday)){ //abajo e izquierda
					if(sens->s1 == 0)
						giro = 0;
					if(sens->s2 == 0)
						giro = 1;
					if(sens->s3 == 0)
						giro = 0;
					if((sens->s1 == 0) && (sens->s3 == 0))
						giro = 0;
					if((sens->s1 == 0) && (sens->s2 == 0))
						giro = 1;
					if((sens->s3 == 0) && (sens->s2 == 0))
						giro = 2;
					if((sens->s1 == 0) && (sens->s2 == 0) && (sens->s3 == 0))
						giro = 1;
					if((sens->s1 != 0) && (sens->s2 != 0) && (sens->s3 != 0))
						giro = 0;
				}
				if((x < coordenadax) && (y < coordenaday)){ //abajo y derecha
					if(sens->s1 == 0)
						giro = 0;
					if(sens->s2 == 0)
						giro = 2;
					if(sens->s3 == 0)
						giro = 0;
					if((sens->s1 == 0) && (sens->s3 == 0))
						giro = 0;
					if((sens->s1 == 0) && (sens->s2 == 0))
						giro = 1;
					if((sens->s3 == 0) && (sens->s2 == 0))
						giro = 2;
					if((sens->s1 == 0) && (sens->s2 == 0) && (sens->s3 == 0))
						giro = 1;
					if((sens->s1 != 0) && (sens->s2 != 0) && (sens->s3 != 0))
						giro = 0;
				}
				if((x < coordenadax) && (y == coordenaday)){ //abajo
					if(sens->s1 == 0)
						giro = 0;
					if(sens->s2 == 0)
						giro = 1;
					if(sens->s3 == 0)
						giro = 0;
					if((sens->s1 == 0) && (sens->s3 == 0))
						giro = 0;
					if((sens->s1 == 0) && (sens->s2 == 0))
						giro = 1;
					if((sens->s3 == 0) && (sens->s2 == 0))
						giro = 2;
					if((sens->s1 == 0) && (sens->s2 == 0) && (sens->s3 == 0))
						giro = 1;
					if((sens->s1 != 0) && (sens->s2 != 0) && (sens->s3 != 0))
						giro = 0;
				}
			}
			break;
		case O:
			if(x == coordenadax){
				if(y > coordenaday){ //izquierda
					if(sens->s1 == 0)
						giro = 0;
					if(sens->s2 == 0)
						giro = 1;
					if(sens->s3 == 0)
						giro = 0;
					if((sens->s1 == 0) && (sens->s3 == 0))
						giro = 0;
					if((sens->s1 == 0) && (sens->s2 == 0))
						giro = 1;
					if((sens->s3 == 0) && (sens->s2 == 0))
						giro = 2;
					if((sens->s1 == 0) && (sens->s2 == 0) && (sens->s3 == 0))
						giro = 1;
					if((sens->s1 != 0) && (sens->s2 != 0) && (sens->s3 != 0))
						giro = 0;
				}else{ //derecha
					if(sens->s1 == 0)
						giro = 1;
					if(sens->s2 == 0)
						giro = 1;
					if(sens->s3 == 0)
						giro = 1;
					if((sens->s1 == 0) && (sens->s3 == 0))
						giro = 1;
					if((sens->s1 == 0) && (sens->s2 == 0))
						giro = 1;
					if((sens->s3 == 0) && (sens->s2 == 0))
						giro = 2;
					if((sens->s1 == 0) && (sens->s2 == 0) && (sens->s3 == 0))
						giro = 1;
					if((sens->s1 != 0) && (sens->s2 != 0) && (sens->s3 != 0))
						giro = 1;
				}
			}else{
				if((x > coordenadax) && (y > coordenaday)){ //arriba e izquierda
					if(sens->s1 == 0)
						giro = 0;
					if(sens->s2 == 0)
						giro = 1;
					if(sens->s3 == 0)
						giro = 0;
					if((sens->s1 == 0) && (sens->s3 == 0))
						giro = 0;
					if((sens->s1 == 0) && (sens->s2 == 0))
						giro = 1;
					if((sens->s3 == 0) && (sens->s2 == 0))
						giro = 2;
					if((sens->s1 == 0) && (sens->s2 == 0) && (sens->s3 == 0))
						giro = 1;
					if((sens->s1 != 0) && (sens->s2 != 0) && (sens->s3 != 0))
						giro = 0;
				}
				if((x > coordenadax) && (y < coordenaday)){ //arriba y derecha
					if(sens->s1 == 0)
						giro = 1;
					if(sens->s2 == 0)
						giro = 1;
					if(sens->s3 == 0)
						giro = 2;
					if((sens->s1 == 0) && (sens->s3 == 0))
						giro = 1;
					if((sens->s1 == 0) && (sens->s2 == 0))
						giro = 1;
					if((sens->s3 == 0) && (sens->s2 == 0))
						giro = 2;
					if((sens->s1 == 0) && (sens->s2 == 0) && (sens->s3 == 0))
						giro = 1;
					if((sens->s1 != 0) && (sens->s2 != 0) && (sens->s3 != 0))
						giro = 1;
				}
				if((x > coordenadax) && (y == coordenaday)){ //arriba 
					if(sens->s1 == 0)
						giro = 1;
					if(sens->s2 == 0)
						giro = 1;
					if(sens->s3 == 0)
						giro = 0;
					if((sens->s1 == 0) && (sens->s3 == 0))
						giro = 0;
					if((sens->s1 == 0) && (sens->s2 == 0))
						giro = 1;
					if((sens->s3 == 0) && (sens->s2 == 0))
						giro = 2;
					if((sens->s1 == 0) && (sens->s2 == 0) && (sens->s3 == 0))
						giro = 1;
					if((sens->s1 != 0) && (sens->s2 != 0) && (sens->s3 != 0))
						giro = 1;
				}
				if((x < coordenadax) && (y > coordenaday)){ //abajo e izquierda
					if(sens->s1 == 0)
						giro = 0;
					if(sens->s2 == 0)
						giro = 2;
					if(sens->s3 == 0)
						giro = 0;
					if((sens->s1 == 0) && (sens->s3 == 0))
						giro = 0;
					if((sens->s1 == 0) && (sens->s2 == 0))
						giro = 1;
					if((sens->s3 == 0) && (sens->s2 == 0))
						giro = 2;
					if((sens->s1 == 0) && (sens->s2 == 0) && (sens->s3 == 0))
						giro = 1;
					if((sens->s1 != 0) && (sens->s2 != 0) && (sens->s3 != 0))
						giro = 0;
				}
				if((x < coordenadax) && (y < coordenaday)){ //abajo y derecha
					if(sens->s1 == 0)
						giro = 0;
					if(sens->s2 == 0)
						giro = 2;
					if(sens->s3 == 0)
						giro = 2;
					if((sens->s1 == 0) && (sens->s3 == 0))
						giro = 1;
					if((sens->s1 == 0) && (sens->s2 == 0))
						giro = 1;
					if((sens->s3 == 0) && (sens->s2 == 0))
						giro = 2;
					if((sens->s1 == 0) && (sens->s2 == 0) && (sens->s3 == 0))
						giro = 1;
					if((sens->s1 != 0) && (sens->s2 != 0) && (sens->s3 != 0))
						giro = 1;
				}
				if((x < coordenadax) && (y == coordenaday)){ //abajo 
					if(sens->s1 == 0)
						giro = 0;
					if(sens->s2 == 0)
						giro = 2;
					if(sens->s3 == 0)
						giro = 2;
					if((sens->s1 == 0) && (sens->s3 == 0))
						giro = 0;
					if((sens->s1 == 0) && (sens->s2 == 0))
						giro = 1;
					if((sens->s3 == 0) && (sens->s2 == 0))
						giro = 2;
					if((sens->s1 == 0) && (sens->s2 == 0) && (sens->s3 == 0))
						giro = 1;
					if((sens->s1 != 0) && (sens->s2 != 0) && (sens->s3 != 0))
						giro = 2;
				}
			}
			break;
	}
	return giro;

}


int
leerSensores(t_sensores *sens)
{
	// Metodo que implementa la funcion de leer sensores de un robot.
	// Devuelve una escala de 0 a 5 dependiendo si esta lejos o no un obstaculo.

	int i = 1;
	int j = 1;
	int k = 1;
	int p = 0;	//condicion de salida
	
	int x,y;

	x = robot.pos.x;
	y = robot.pos.y;

	//s1 es el sensor de la izquierda
	//s2 es el sensor del centro
	//s3 es el sensor de la derecha

	//inicializacion por defecto
	sens->s1 = RANGO;
	sens->s2 = RANGO;
	sens->s3 = RANGO;


	switch(robot.pos.or){
		case N:
			//s1
			p = 0;
			while(i != RANGO+2 && !p){
				if((y-i) <= -1){
					y = COL-1;
					if(mapa[x][y-i] == 'X'){
						sens->s1 = i-1;
						p = 1;
					}
					else
						i++;
				}else{
					if(mapa[x][y-i] == 'X'){
						sens->s1 = i-1;
						p = 1;
					}else
						i++;
				}
			}
			//s2
			p = 0;
			x = robot.pos.x;
			y = robot.pos.y;
			while(j != RANGO+2 && !p){
				if((x-j) <= -1){
					x = FIL-1;
					if(mapa[x-j][y] == 'X'){
						sens->s2 = j-1;
						p = 1;
					}
					else
						j++;
				}else{
					if(mapa[x-j][y] == 'X'){
						sens->s2 = j-1;
						p = 1;
					}else
						j++;
				}
			}
			//s3
			p = 0;
			x = robot.pos.x;
			y = robot.pos.y;
			while(k != RANGO+2 && !p){
				if((y+k) >= COL){
					y = 0;
					if(mapa[x][y+k] == 'X'){
						sens->s3 = k-1;
						p = 1;
					}
					else
						k++;
				}else{
					if(mapa[x][y+k] == 'X'){
						sens->s3 = k-1;
						p = 1;
					}else
						k++;
				}
			}
			break;
		case E:
			//s1
			p = 0;
			while(i != RANGO+2 && !p){
				if((x-i) <= -1){
					x = FIL-1;
					if(mapa[x-i][y] == 'X'){
						sens->s1 = i-1;
						p = 1;
					}
					else
						i++;
				}else{
					if(mapa[x-i][y] == 'X'){
						sens->s1 = i-1;
						p = 1;
					}else
						i++;
				}
			}
			//s2
			p = 0;
			x = robot.pos.x;
			y = robot.pos.y;
			while(j != RANGO+2 && !p){
				if((y+j) >= COL){
					y = 0;
					if(mapa[x][y+j] == 'X'){
						sens->s2 = j-1;
						p = 1;
					}
					else
						j++;
				}else{
					if(mapa[x][y+j] == 'X'){
						sens->s2 = j-1;
						p = 1;
					}else
						j++;
				}
			}
			//s3
			p = 0;
			x = robot.pos.x;
			y = robot.pos.y;
			while(k != RANGO+2 && !p){
				if((x+k) >= FIL){
					x = 0;
					if(mapa[x+k][y] == 'X'){
						sens->s3 = k-1;
						p = 1;
					}
					else
						k++;
				}else{
					if(mapa[x+k][y] == 'X'){
						sens->s3 = k-1;
						p = 1;
					}else
						k++;
				}
			}
			break;
		case S:
			//s1
			p = 0;
			while(i != RANGO+2 && !p){
				if((y+i) >= COL){
					y = 0;
					if(mapa[x][y+i] == 'X'){
						sens->s1 = i-1;
						p = 1;
					}
					else
						i++;
				}else{
					if(mapa[x][y+i] == 'X'){
						sens->s1 = i-1;
						p = 1;
					}else
						i++;
				}
			}
			//s2
			p = 0;
			x = robot.pos.x;
			y = robot.pos.y;
			while(j != RANGO+2 && !p){
				if((x+j) >= FIL){
					x = 0;
					if(mapa[x+j][y] == 'X'){
						sens->s2 = j-1;
						p = 1;
					}
					else
						j++;
				}else{
					if(mapa[x+j][y] == 'X'){
						sens->s2 = j-1;
						p = 1;
					}else
						j++;
				}
			}
			//s3
			p = 0;
			x = robot.pos.x;
			y = robot.pos.y;
			while(k != RANGO+2 && !p){
				if((y-k) <= 0){
					y = COL; //COL-1
					if(mapa[x][y-k] == 'X'){
						sens->s3 = k-1;
						p = 1;
					}
					else
						k++;
				}else{
					if(mapa[x][y-k] == 'X'){
						sens->s3 = k-1;
						p = 1;
					}else
						k++;
				}
			}	
			break;
		case O:
			//s1
			p = 0;
			i = 0;
			while(i != RANGO+2 && !p){
				if((x+i) >= FIL){
					x = 0;
					if(mapa[x+i][y] == 'X'){
						sens->s1 = i-1;
						p = 1;
					}
					else
						i++;
				}else{
					if(mapa[x+i][y] == 'X'){
						sens->s1 = i-1;
						p = 1;
					}else
						i++;
				}
			}
			//s2
			p = 0;
			j = 0;
			x = robot.pos.x;
			y = robot.pos.y;
			while(j != RANGO+2 && !p){
				if((y-j) <= -1){
					y = COL-1;
					if(mapa[x][y-j] == 'X'){
						sens->s2 = j-1;
						p = 1;
					}
					else
						j++;
				}else{
					if(mapa[x][y-j] == 'X'){
						sens->s2 = j-1;
						p = 1;
					}else
						j++;
				}
			}	
			//s3
			p = 0;
			k = 0;
			x = robot.pos.x;
			y = robot.pos.y;
			while(k != RANGO+2 && !p){
				if((x-k) <= -1){
					x = FIL-1;
					if(mapa[x-k][y] == 'X'){
						sens->s3 = k-1;
						p = 1;
					}
					else
						k++;
				}else{
					if(mapa[x-k][y] == 'X'){
						sens->s3 = k-1;
						p = 1;
					}else
						k++;
				}
			}
			break;
	}
	
	/*initscr();
	mvprintw(27,0,"s1[%d] s2[%d] s3[%d]", sens->s1, sens->s2, sens->s3);
	refresh();*/		
	return 1;
		
}

int
leerGps(t_posicion *posactual)  
{
	// Metodo que devuelve la poscion acutal

	posactual->x = robot.pos.x;
	posactual->y = robot.pos.y;
	posactual->or = robot.pos.or;
	
	return 1;
}

int
comprobarLlegada(int posx, int posy)
{
	// Metodo que comprueba si se ha llegado al destino

	start_color();
	init_pair(4, COLOR_RED, COLOR_YELLOW);

	if((posx == coordenadax) && (posy == coordenaday)){ //Llega al destino
		robot.M1 = 0;
		robot.M2 = 0;
		initscr();
		attron(COLOR_PAIR(4));
		mvprintw(7,5,"****************************************");
		mvprintw(8,5,"****EL ROBOT HA LLEGADO AL DESTINO******");
		mvprintw(9,5,"****************************************");
		attroff(COLOR_PAIR(4));
		refresh();
		return 1;
	}else
		return 0;
}

void
pararMotores(void)
{
	// Metodo que para los motores
	robot.M1 = 0;
	robot.M2 = 0;
}

void
todoRecto(void)
{
	// Metodd que indica al robot de seguir recto
	robot.M1 = 1;
	robot.M2 = 1;
}

void
giroHorario(void)
{
	// Metodd que indica al robot de girar en sentido horario
	robot.M1 = 1;
	robot.M2 = 0;
}

void
giroAntiHorario(void)
{
	// Metodd que indica al robot de de girar en sentido antihorario
	robot.M1 = 0;
	robot.M2 = 1;
}

void
moverMotores(t_sensores *sens)
{
	int accion,posx,posy,posor;

	posx = robot.pos.x;
	posy = robot.pos.y;
	posor = robot.pos.or;
	
	if(comprobarLlegada(posx,posy))
		pararMotores();
	else{
		accion = sacarDistancia(sens);
		switch(accion){
			case 0://nada
				todoRecto();
				break;
			case 1://giro horario
				giroHorario();
				break;
			case 2://giro antihorario
				giroAntiHorario();
				break;
		}
	}
}


// Simulador
void
*simulador(void *arg) 
{
	
	while(1){
		// El simulador realiza la simulacion aproximadamente cada segundo
		// que es ritmo al que hay que actualizar los motores
		sleep(1);
		pthread_mutex_lock(&semaforo);
		// Borro el robot
		mapa[robot.pos.x][robot.pos.y] = ' ';
		// Calculo la nueva posicion en funcion de motores y orientacion
		switch (robot.M1){
			case 1: //motor1 encendido
				if (robot.M2) // motor2 encendido: avanzo
					switch (robot.pos.or) {
						case N: // hacia arriba
							robot.pos.x = (robot.pos.x-1 < 0) ? FIL-1: robot.pos.x-1;
							break;
						case S: // hacia abajo
							robot.pos.x = (robot.pos.x+1>= FIL) ? 0 : robot.pos.x+1;
							break;
						case E: // hacia la derecha
							robot.pos.y = (robot.pos.y+1 >= COL+1) ? 0 : robot.pos.y+1 ;
							break;
						case O: // hacia la izquierda
							robot.pos.y = (robot.pos.y-1 < 0) ? COL-1 : robot.pos.y-1 ;
					} // switch (robot.or)
				else { //motor2 apagado: giro horario
					robot.pos.or = (robot.pos.or+1)%4;
				}
				break;
			case 0: //motor1 apagado
				if (robot.M2){ // motor2 encendido: giro antihorario
					robot.pos.or = (robot.pos.or-1)%4;
				}
				break;
		} // switch (robot.M1)
		// Pongo el robot en el mapa en su posicion y con su orientacion
		mapa[robot.pos.x][robot.pos.y]=simbolo[robot.pos.or];
		pthread_mutex_unlock(&semaforo);
		pintaMapa(); // Lo vuelvo a pintar
	}
	pthread_exit(NULL);
}

//Planificador
void
*planificador(void *arg)
{
	// Hilo del planificador ciclico

	t_sensores *sens;
	t_posicion *pos;
	int modulo = 0;
	
	sens = malloc(sizeof(t_sensores));
	pos = malloc(sizeof(t_posicion));
	
	while(1){
		usleep(500000);				
		pthread_mutex_lock(&semaforo);
		switch(modulo){
			case 0:
				leerSensores(sens);				
				leerGps(pos);							
				moverMotores(sens);
				break;
			case 1:
				leerSensores(sens);
				break;
		}
		modulo = (modulo+1)%2;

		/*initscr();
		mvprintw(23,0,"POS: [%d].x [%d].y [%d].or", pos->x, pos->y, pos->or);
		mvprintw(24,0,"MOTORES: [%d]1 [%d]2", robot.M1, robot.M2);
		mvprintw(25,0,"MODULO [%d]", modulo);
		refresh();*/
		pthread_mutex_unlock(&semaforo);
	}

	pthread_exit(NULL);
}

void
manejador(int s)
{
	switch(s){
		case SIGTERM:
			endwin();
			printf("Gracias por usar el programa ROBOT :D\n");
			exit(-1);
			break;
	}

}

int
main(int argc, char** argv)
{
	pthread_t hilo_simulacion, hilo_planificador;
	
		
	//Comprobacion argumentos de entrada
	// USO: ./programa ruta_archivo_mapa
	
	if(argc != 2){
		printf("USO: ./programa ruta_archivo_mapa\n");
		exit(-1);
	}
	
	leerMapa(argv[1]);
	if(!comprobarMapa()){
		endwin();
		printf("\nMapa erroneo. No puede haber obstaculo en posicion (0,0).\n");
		exit(-1);
	}
	signal(SIGTERM, manejador);

	iniciarPantalla();
	pintaMapa();
	
	// INICIO ROBOT
	// Posicion del robot:
	//inicialmente (1,1), hacia abajo y con motores encendidos
	robot.pos.x = 0;
	robot.pos.y = 0;
	robot.pos.or = S;
	robot.M1 = 1;
	robot.M2 = 1;
	mapa[robot.pos.x][robot.pos.y]=simbolo[robot.pos.or];

	pintaMapa();
	dameCoordenadas();	

	pthread_create(&hilo_planificador, NULL, planificador, NULL);
	pthread_create(&hilo_simulacion, NULL, simulador, NULL);

	pthread_exit(NULL);
	

	exit(-1);
}

