# Reglas para generar HTML, PostScript y PDF de usuario_adJ
# Basadas en infraestructura de dominio p�blico de repasa 
#   (http://structio.sourceforge.net/repasa)

include Make.inc

# Variables requeridas por comdocbook.mak

EXT_DOCBOOK=xdbk

SOURCES=basico_adJ-4.1.2.xdbk s.xdbk 
# Listado de fuentes XML. Preferiblmente en el orden de inclusi�n.

IMAGES=img/fluxbox-xfig.png img/home.png img/prev.png img/toc-minus.png img/blank.png img/important.png img/toc-plus.png img/caution.png img/next.png img/tip.png img/up.png img/draft.png img/note.png img/toc-blank.png img/warning.png img/instala1.png img/instala2.png img/instala3.png img/instala4.png img/instala5.png img/instala6.png img/ejlatex.png img/xiphos.png img/gimp.png img/inkscape.png img/insadJ1.png img/insadJ1.png img/insadJ2.png img/insadJ3.png img/insadJ4.png img/insadJ5.png img/insadJ6.png img/insadJ7.png img/audacious.png img/audacity.png img/gnumeric.png
# Listado de imagenes, preferiblemente en formato PNG

HTML_DIR=html
# Directorio en el que se generar� informaci�n en HTML (con reglas por defecto)

HTML_TARGET=$(HTML_DIR)/index.html
# Nombre del HTML principal (debe coincidir con el especificado en estilohtml.xsl)

XSLT_HTML=estilohtml.xsl
# Hoja XSLT para generar HTML con regla por defecto

PRINT_DIR=imp
# Directorio en el que se genera PostScript y PDF en reglas por defecto

DSSSL_PRINT=estilo.dsl\#print
# Hoja de estilo DSSSL para generar TeX en reglas por defecto

DSSSL_HTML=estilo.dsl\#html
# Hoja de estilo DSSSL para generar HTML en reglas por defecto
#
OTHER_HTML=

PRECVS=guias/

INDEX=indice.$(EXT_DOCBOOK)
# Si habr� un �ndice, nombre del archivo con el que debe generarse (incluirlo al final del documento).


# Variables requeridas por comdist.mk

GENDIST=Derechos.txt $(SOURCES) $(IMAGES)
# Dependencias por cumplir antes de generar distribuci�n

ACTHOST=git@github.com:pasosdeJesus/
# Sitio en Internet donde actualizar. M�todo indicado por $(ACT_PROC) de confv.sh

ACTDIR=usuario_adJ
# Directorio en $(ACTHOST) por actualizar

#USER=$(LOGNAME),structio
# Usuario en $(ACTHOST).  Si es el mismo que en la m�quina local comentar.

GENACT=ghtodo $(PROYECTO)-$(PRY_VERSION)_html.tar.gz #$(PRINT_DIR)/$(PROYECTO)-$(PRY_VERSION).ps.gz $(PRINT_DIR)/$(PROYECTO)-$(PRY_VERSION).pdf 
# Dependencias por cumplir antes de actualizar sitio en Internet al publicar

FILESACT=$(PROYECTO)-$(PRY_VERSION).tar.gz $(PROYECTO)-$(PRY_VERSION)_html.tar.gz $(HTML_DIR)/* #$(PRINT_DIR)/$(PROYECTO)-$(PRY_VERSION).ps.gz $(PRINT_DIR)/$(PROYECTO)-$(PRY_VERSION).pdf 
# Archivos que se debe actualizar en sitio de Internet cuando se publica

all: $(HTML_TARGET) #$(PRINT_DIR)/$(PROYECTO).ps $(PRINT_DIR)/$(PROYECTO).pdf

cvstodo: distcvs 
	rm -rf $(PROYECTO)-$(PRY_VERSION)
	tar xvfz $(PROYECTO)-$(PRY_VERSION).tar.gz
	(cd $(PROYECTO)-$(PRY_VERSION); ./conf.sh; make $(PROYECTO)-$(PRY_VERSION)_html.tar.gz)
	cp $(PROYECTO)-$(PRY_VERSION)/$(PROYECTO)-$(PRY_VERSION)_html.tar.gz .

ghtodo: distgh
	(cd $(PROYECTO)-$(PRY_VERSION); ./conf.sh; make $(PROYECTO)-$(PRY_VERSION)_html.tar.gz)
	cp $(PROYECTO)-$(PRY_VERSION)/$(PROYECTO)-$(PRY_VERSION)_html.tar.gz .

repasa:
	DEF=$(PROYECTO).def CLA=$(PROYECTO).cla SEC=$(PROYECTO).sec DESC="Informaci�n extraida de: $(PRY_DESC)" FECHA="$(FECHA_ACT)" BIBLIO="$(URLSITE)" TIPO_DERECHOS="Dominio p�blico" TIEMPO_DERECHOS="$(MES_ACT)" DERECHOS="Informaci�n cedida al dominio p�blico. Sin garant�as." AUTORES="Vladimir T�mara" IDSIGNIFICADO="adJ_usuario" awk -f herram/db2rep $(SOURCES)

# Para usar DocBook
include herram/comdocbook.mak

# Para crear distribuci�n de fuentes y publicar en Internet
include herram/comdist.mak

# Elimina hasta configuraci�n
limpiadist: limpiamas
	rm -f confv.sh confv.xml Make.inc personaliza.ent
	rm -rf $(HTML_DIR)
	rm -rf $(PRINT_DIR)


# Elimina archivos generables
limpiamas: limpia
	rm -f img/*.eps img/*.ps
	rm -f $(PROYECTO)-$(PRY_VERSION).tar.gz
	rm -f genindice.xdbk genindice.xdbk.m genindice.xml.m HTML.index.m
	rm -rf $(PROYECTO)-$(PRY_VERSION)
	rm -rf $(PROYECTO)_gh-pages
	rm -f $(INDEX).xdbk $(INDEX).xdbk.m $(INDEX).xml.m HTML.index.m
	rm -f confaux.sed indice.xdbk.m confv.ent


# Elimina backups y archivos temporales
limpia:
	rm -f *bak *~ *tmp confaux.tmp $(PROYECTO)-$(PRY_VERSION)_html.tar.gz
	rm -f $(PROYECTO)-4.1.*


Derechos.txt: $(PROYECTO).$(EXT_DOCBOOK)
	make html/index.html
	$(W3M) $(W3M_OPT) -dump html/index.html | awk -f herram/conthtmldoc.awk > Derechos.txt

instala:
	mkdir -p $(DESTDIR)$(INSDOC)
	install html/*html html/*png $(DESTDIR)$(INSDOC)
	if (test -f $(PRINT_DIR)/$(PROYECTO).ps) then { install imp/*ps $(DESTDIR)$(INSDOC); } fi;

repasa:
	DEF=$(PROYECTO).def CLA=$(PROYECTO).cla SEC=$(PROYECTO).sec DESC="Informaci�n extraida de: $(PRY_DESC)" FECHA="$(FECHA_ACT)" BIBLIO="$(URLSITE)" TIPO_DERECHOS="Dominio p�blico" TIEMPO_DERECHOS="$(MES_ACT)" DERECHOS="Informaci�n cedida al dominio p�blico. Sin garant�as." AUTORES="Vladimir T�mara" IDSIGNIFICADO="openbsd_usuario" awk -f herram/db2rep $(SOURCES)


programas.xdbk: infoversion.ent
	if (test -f /home/$(LOGNAME)/comp/adJ/Contenido.txt) then { cp /home/$(LOGNAME)/comp/adJ/Contenido.txt Contenido.txt ; recode utf8..latin1 Contenido.txt; } else { touch Contenido.txt; } fi;
	awk -f herram/convContenido.awk Contenido.txt > programas.xdbk; 

infoversion.ent:
	if (test -f ../servidor_adJ/infoversion.ent) then { \
		cp ../servidor_adJ/infoversion.ent .; \
	} fi;
PANDOC=/home/vtamara/.cabal/bin/pandoc 

FUENTESMD= conceptos_basicos.md correo_electronico.md edicion_de_textos.md \
	formatos_de_archivos.md introduccion.md \
	labores_basicas_de_administracion.md \
	mas_formas_de_uso_de_ssh.md novedades.md personalizacion.md \
	primer_uso_de_adJ.md primeras_paginas_html.md \
	soporte.md transferencia_de_informacion_a_y_desde_el_servidor.md \
	uso_de_medios_de_almacenamiento.md bibliografia.md

s.xdbk: $(FUENTESMD)
	$(PANDOC) -t docbook -o s.xdbk $(FUENTESMD)
