# ST1 (Sistemas Telemáticos I) - 2007-2009

This is the final assignment for ST1 subject in 2009. It is based on peer communication (files and chat) exchanging packets via TCP/IP protocol. 


It is writing in Ada language. In order to remain the _old times_, I've decided to maintain the Spanish sentences and comments inside the code.

## How to build and run it

Make sure you have ```gnatmake``` installed. After this, you must build the Lower Layer lib provided (TCP and UDP library created by URJC teachers): check `INSTALL` file inside `ll` folder for more info. 

Build it by doing:

```
gnatmake lower_layer_udp
gnatmake lower_layer_tcp
gnatmake gnutelight
```

It will create an executable called simply `gnutelight`.

You can exectue in 2 ways, as server and as peer.

```
# ./gnutelight <port> <folderToServeFiles> <minLatency> <maxLatency> <percFail> <windowSize>
./gnutelight 7777 dir1 0 10 0 10
```

```
# ./gnutelight <port> <folderToServeFiles> <minLatency> <maxLatency> <percFail> <windowSize> <serverMachine> <portServerMachine>
./gnutelight 7778 dir1 0 10 0 10 server 7777 
```

---
### After several tries, the executable does not work 😑
It hangs while creating a Lower Layer peer.

```
************************GNUTELIGHT.ADB*********************************
Bienvenido al programa gnutelight.adb. Ha iniciado un nodo que servira y descarga archivos.
************************************************************************
Excepcion imprevista: LOWER_LAYER.BINDING_ERROR en: lower_layer-inet.adb:370
``` 

I also moved /ll/lib files into source path because `gnatmake` command does not find source library files. I tried:

```
$ gnatmake -I/ll/lib gnutelight
x86_64-linux-gnu-gcc-10 -c -I/ll/lib gnutelight.adb
gnutelight.adb:15:06: file "lower_layer_udp.ads" not found
gnatmake: "gnutelight.adb" compilation error

$ gnatmake -aI/ll/lib gnutelight
x86_64-linux-gnu-gcc-10 -c -I/ll/lib gnutelight.adb
gnutelight.adb:15:06: file "lower_layer_udp.ads" not found
gnatmake: "gnutelight.adb" compilation error

$ gnatmake -aI/ll/lib -aO/ll/lib gnutelight
x86_64-linux-gnu-gcc-10 -c -I/ll/lib gnutelight.adb
gnutelight.adb:15:06: file "lower_layer_udp.ads" not found
gnatmake: "gnutelight.adb" compilation error 
```

Without succes... 😔

Please, if you know of find the way to compile without putting lib source files into the source path, I would be very glad to chat with you!

Even!, if you know why this is not working, please let me know!