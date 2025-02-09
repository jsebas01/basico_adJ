## Personalización {#personalizacion}

Como usuario puede personalizar diversos aspectos de su interacción con el 
sistema completo y con cada programa (como **fluxbox, xfe** y el interprete de 
ordenes). En esta sección presentamos la personalización del locale y 
algunas formas de personalizar el interprete de ordenes **ksh**.

### Locale {#locale}

Un locale define una codificación y formas de presentar información típicas 
de una región geográfica (números, valores monetarios, fechas, horas, idioma 
y cotejación u ordenamiento lexicográfico del mismo). adJ viene configurado 
por omisión con el locale es-CO.UTF-8 es decir en español, para Colombia 
y con codificación UTF-8. 

En UTF-8 puede codificarse UNICODE, que a su vez permite representar todos los 
lenguajes escritos --la mayoría de lenguajes occidentales, incluyendo el 
español.

Los locales se ubican en el directorio ```/usr/shar/locale``` y puede examinar 
los más comunes con
```
locale -a
```

Elija el locale más apropiado para su país. Recomendamos que emplee 
codificación UTF-8 y que establezca el locale en sus archivos 
```~/.fluxbox/startup``` y ```~/.profile``` agregando o cambiando la línea:
```
export LANG=es_CO.UTF-8
```
Los programas estándares emplearan esta variable (y otras asociadas) para 
determinar el locale y modificaran la forma de presentar:

- Los mensajes, menús y ayudas para que sean en su idioma. En adJ esto se 
	soporta via el porte **gettext**.
- La codificación de caracteres para que sea la que prefiere. En adJ se 
	emplea el soporte de LC_CTYPE de OpenBSD que es suficiente
	para UTF-8.
- Los ordenamientos alfabéticos serán apropiados para su idioma (por ejemplo 
	en español la á lexicograficamente equivale a la a, y la ñ está entre 
	la n y la o). En adJ se emplea una implementación mejorada sobre la de 
	FreeBSD que es suficiente para el español en codificaciones 
	ISO-8859-1, ISO-8859-15 y UTF-8 (aunque no basta para otros lenguajes 
	soportados por UNICODE).
- La forma de presentar números y valores monetarios será la particular de la 
	región geográfica elegida. En adJ empleamos una implementación mejorada 
	con base en la de FreeBSD que soporta especialmente bien todos los 
	paises de latinoamérica.
- También la forma de presentar fecha y hora se ve afectada por el locale así 
	como por la zona horaria.

### Personalización del interprete de ordenes ksh {#personalizacion_del_interprete_de_ordenes_ksh}

Es función del intérprete de ordenes recibir ordenes que el usuario ingrese 
por el teclado (o en general por entrada estándar) y ejecutar los programas 
apropiados. Dada la importancia y frecuencia de esta labor, los interpretes de 
ordenes (y en particular ```/bin/ksh```) 
suelen ser altamente personalizables a los gustos de cada usuario.

#### Ejecución de Programas {#ejecucion_de_programas}

Desde un intérprete de ordenes un usuario puede teclear bien nombres de 
programas o bien ordenes del intérprete de ordenes. Los programas por 
ejecutar se especifican dando la ruta completa de su ubicación en el sistema 
de archivos, o en caso de no dar ruta se buscan en orden en los directorios 
especificados en la variable de ambiente PATH. Por ejemplo si teclea:
```
$ banner Jesus
```
El intérprete de ordenes identifica que está intentando ejecutar ```banner``` 
(para presentar en grande una cadena) y que le pasa como primer parámetro Jesus.
Como ```banner``` no es una orden interno del intérprete de ordenes busca un 
archivo con permiso de ejecución en las rutas indicadas en la variable 
```PATH```, si el valor de tal variable fuera 
```/bin:/usr/X11R6/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:/usr/games:/sbin:/usr/sbin``` 
el intérprete de ordenes buscaría primero en ```/bin```, después en
```/usr/X11R6/bin``` y así sucesivamente para encontrarlo en ```/usr/bin```. 
Entonces pasaría el control a un programa del sistema operativo que se encarga 
de cargar y ejecutar el programa pasándole los parámetros que reciba 
(tal programa es ```/usr/libexec/ld.so```). El ejemplo anterior es equivalente 
a
```
$ /usr/bin/banner Jesus
```
puede verificar que ```banner``` es un programa ubicado en el directorio 
```/usr/bin``` con:
```
$ ls -l /usr/bin/b*
```
que mostrará todos los archivos de ese directorio que comiencen con la letra b.

#### Variables de ambiente {#variables_de_ambiente}

Puede personalizar algunos detalles del intérprete de ordenes o de algunos 
programas empleando variables de ambiente. Las variables de ambiente son 
palabras que tienen asociadas un valor, por ejemplo puede examinar el 
valor de la variable de ambiente ```PATH``` con:
```
echo $PATH
```
y puede modificarlo con:
```
export PATH=/bin:/usr/X11R6/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:/usr/games:/sbin:/usr/sbin
```

Si en su directorio personal a instalado programas en el subdirectorio bin y 
desea agregar la ruta a la variable PATH puede usar:
```
export PATH=$PATH:/home/$EUSER;/bin/
```


#### Variables de ambiente del intérprete de ordenes {#variables_de_ambiente_del_interprete_de_ordenes}

Cada programa emplea sus propias variables de ambiente, en particular el 
intérprete de ordenes. Recomendamos el uso de **ksh** como interprete de 
ordenes por ser liviano y estándar en sistemas OpenBSD. Con este intérprete de 
ordenes, puede establecerse el valor de la variable de ambiente ```VISUAL``` 
con:
```
$ export VISUAL=vi
```
Esta variable es usada por **ksh** para determinar qué secuencias de teclas 
utilizar para dar órdenes especiales desde la línea de ordenes. El valor 
```vi``` indica que se usen las teclas que se usan con el editor vi (por 
ejemplo en modo ordenes, es decir después de oprimir **ESC**, 
pueden usarse **k** para ir a la instrucción anterior de la historia, **j** 
para ir a la siguiente, **?** seguido de una cadena para buscar una orden 
en la historia que incluya la cadena, **0** para ir al comienzo de la línea, 
**$** para ir al final de la linea, **i** para insertar en la posición del 
cursor y salir del modo ordenes). 
Si prefiere otra forma de interacción emplee:
```
export VISUAL=gmacs
```

Otra variable usado por diversos programas es ```TERM``` que permite establecer 
el tipo de terminal que se está usando.  por ejemplo:
```
$ export TERM=xterm-color
```
que permite presentar colores si trabaja directamente en el sistema 
OpenBSD con X-Window o
```
$ export TERM=wsvt25
```
que permite presentar colores si emplea la consola tipo texto en un PC 
ordinario o si se conecta con putty (por ejemplo cuando ingresa a vim).

#### Configuración por defecto de sesiones con ksh

Notará que el valor de las variables de ambiente que fije durante una sesión 
se perderá cuando termine la sesión. Para lograr una configuración más 
perdurable puede establecer la variable de ambiente a un archivo ejecutado 
por el intérprete de ordenes automáticamente cada vez que inicia una sesión. 
En el caso del intérprete ksh tal archivo es ```~/.profile```. 
Un ejemplo de un archivo ```~/.profile``` es:

```
alias vi=vim
export VISUAL=vi
export PATH=$HOME/bin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:/usr/games:/sbin:/usr/sbin:/usr/local/sbin:.
if (test "$TERM" = "xterm") then {
	export TERM=xterm-color
else {
	export TERM=wsvt25
} fi;
which colorls > /dev/null
if (test "$?" == "0") then {
	export CLICOLOR=1
	alias ls=colorls
} fi;
export  PKG_PATH=ftp://rt.fm/pub/OpenBSD/5.7/packages/i386
export PS1="\h$ "
export LANG="es_CO.UTF-8"
```

La orden alias ```vi=vim``` indica que cada vez que se ejecute la orden 
```vi``` se llame al programa vim (ver Sección 7.3, “Editor vi”). Note que 
también se establecen las variables de ambiente

- ```VISUAL``` modo de edición en ksh.
- ```PATH``` que establece rutas en la cual buscar programas (se separan 
	unas de otras con dos puntos).
- ```TERM``` que establece el tipo de terminal que está usando. Desde 
	terminales gráficas será xterm o xterm-color, mientras que desde 
	consolas tipo texto típicamente será vt220 o wsvt25.
- ```PKG_PATH``` que establece ruta en la cual buscar paquetes por instalar 
	--usado por administradores de sistemas OpenBSD.
- ```LANG``` define el locale, es decir las identificaciones culturales y de 
	idioma para un área geográfica.
- ```PS1``` que establece el símbolo de espera de ordenes principal de 
	**ksh**, el valor de este ejemplo ("\\h$ ") establece un símbolo de 
	espera de ordenes que presenta el nombre de la máquina seguido del 
	símbolo pesos y un espacio.
  
#### colorls {#colorls}

En el ejemplo presentado si está instalado el programa ```colorls``` (del 
paquete colorls), este se define como alias para la orden ```ls```, de forma 
que la lista de archivos se presente con colores y como ha sido modificado
para adJ presentará orden correcto en español. Esto ocurrirá desde consolas 
tipo texto. Si está usando OpenBSD con X-Window y ```xterm```, además de lo 
anterior necesita agregar a su archivo ```~/.Xdefaults`` (o crearlo 
si no existe):

```
// Con base en http://dentarg.starkast.net/files/configs/dot.zshrc

XTerm*color0:                   #000000

XTerm*color1:                   #bf7276

XTerm*color2:                   #86af80
XTerm*color3:                   #968a38
XTerm*color4:                   #3673b5
XTerm*color5:                   #9a70b2
XTerm*color6:                    #7abecc
XTerm*color7:                   #dbdbdb
XTerm*color8:                   #6692af
XTerm*color9:                   #e5505f
XTerm*color10:                  #87bc87
XTerm*color11:                  #e0d95c
XTerm*color12:                  #1b85d6
XTerm*color13:                  #ad73ba
XTerm*color14:                  #338eaa
XTerm*color15:                  #f4f4f4
XTerm*colorBD:                  #ffffff
XTerm*foreground:               #000000
XTerm*background:               #ffffff
XTerm*font:                     shine2.se
XTerm*boldMode:                 false
XTerm*scrollBar:                false
XTerm*colorMode:                on
XTerm*dynamicColors:            on
XTerm*highlightSelection:       true
XTerm*eightBitInput:            false
XTerm*metaSendsEscape:          false
XTerm*oldXtermFKeys:            true
```

#### Lecturas recomendadas {#lecturas_recomendadas_personalizacion}

Puede ver detalles de las variables de ambiente empleadas por ksh con 
```
man ksh
```
La configuración de colores es tomada de una respuesta de Steve Jones en 
una lista de correo, está disponible en 
<http://mailman.theapt.org/pipermail/openbsd-newbies/2004-April/001806.html>.

