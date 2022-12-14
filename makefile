# Copyright (C) 2022 Fernando Daniel Maqueda

# This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
# You should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/licenses/>.

# Bison-Flex-makefile: Este makefile sirve para construir, ejecutar y depurar proyectos en lenguaje C, proyectos en lenguaje C con Flex (archivos *.l), proyectos en lenguaje C con Bison (archivos *.y), y proyectos en lenguaje C con Bison (archivos *.y) + Flex (archivos *.l) (así como proyectos que utilicen programas similares, como ser Yacc y Lex)
# Requiere GNU Make desde su versión 3.81 en adelante (o algún otro programa compatible)
# Para ejecutarse necesita sh (Bourne Shell) para ser utilizado como la shell y estar el comando <command> integrado en la misma (en inglés: 'shell built-in command')
# También debe poder utilizar los siguientes comandos (disponibles en GNU coreutils (Core Utilities)): dirname echo false mkdir printf rm rmdir sort tr true uname uniq
# Así como estos otros comandos: grep sed
# Según sea el caso debe disponer de los siguientes programas (o compatibles) para realizar las acciones indicadas: gcc (para compilar archivos en lenguaje C) ; bison (para generar analizadores sintácticos en lenguaje C) ; flex (para generar analizadores léxicos en lenguaje C) ; gdb (para depurar binarios) ; tmux (para abrir una nueva ventana (a menos que se detecte un sistema operativo Windows, en cuyo caso se usa el comando <start>))

# Para determinar que sh sea el programa utilizado como la shell
SHELL:=/bin/sh

# Define una variable que contiene un solo espacio para luego utilizarla para sustituir con secuencias de escape cada uno de los espacios
espacio:=$(subst ",," ")

# Define una variable que contiene un signo numeral para poder ser utilizado en referencias macro y en invocaciones de funciones
numeral:=\#

# Comprueba que se haya encontrado una shell sh en el sistema
ifeq ($(wildcard $(subst $(espacio),\$(espacio),$(SHELL))),)
$(error ERROR: no hay una shell sh instalada y/o no se ha podido encontrar y ejecutar)
endif

# Comprueba que el comando <command> se encuentre integrado en la shell (en inglés: 'shell built-in command')
ifeq ($(shell command -v cd ;),)
$(error ERROR: El comando <command> no se encuentra integrado en la shell)
endif

# Comprueba que se puedan encontrar todos los comandos necesarios que se presentan en GNU coreutils (Core Utilities)
define make_comprobar_comando_coreutils
$(if $(shell command -v $(1) ;),,$(error ERROR: El comando <$(1)>, necesario para que pueda funcionar este makefile y que se presenta en GNU coreutils, no esta instalado y/o no se puede encontrar y ejecutar))
endef
$(foreach comando,dirname echo false mkdir printf rm rmdir sort tr true uname uniq,$(eval $(call make_comprobar_comando_coreutils,$(comando))))

# Comprueba que se puedan encontrar el resto de los comandos necesarios
define make_comprobar_otro_comando
$(if $(shell command -v $(1) ;),,$(error ERROR: El comando <$(1)>, necesario para que pueda funcionar este makefile, no esta instalado y/o no se puede encontrar y ejecutar))
endef
$(foreach comando,grep sed,$(eval $(call make_comprobar_otro_comando,$(comando))))

# Subdirectorio en el que están ubicados los archivos *h, *.c, *.y, y *.l fuente (excepto los archivos intermedios generados por CC, YACC y LEX). Por ejemplo: src
SRCDIR:=src
# Subdirectorio en el que se ubicarán los archivos intermedios generados por CC, YACC y LEX. Por ejemplo: obj
OBJDIR:=obj
# Subdirectorio en el que se ubicarán los binarios construidos. Por ejemplo: bin
BINDIR:=bin

# Compilador de C, generador de analizadores sintácticos (parsers) y generador de analizadores léxicos (scanners) a usar, respectivamente
CC:=gcc
YACC:=bison
LEX:=flex

# Depurador de C a usar y los flags a pasarle, respectivamente
CDB:=gdb
CDBFLAGS:=

# Agregar acá los flags -L (en LIBSDIRS) y -l (en LIBS) para CC, los cuales sirven para enlazar con las bibliotecas necesarias (tanto estáticas (lib*.a) como dinámicas (lib*.so))
# Esto se usa cuando el compilador no encuentra algún archivo de cabecera (header file) (*.h) DEL SISTEMA: es decir, sólo aquellos que están entre corchetes angulares (<>), como #include <math.h>; no los que están entre comillas (""), como ser: #include "misfunciones.h")
# Para eso poner -lNombreBiblioteca en LIBS (si el compilador ya puede encontrar por si solo el archivo libNombreBiblioteca.aÓ.so) y/o poner -L"ruta/relativa/desde/este/makefile/Ó/absoluta/hasta/un/directorio/que/contiene/archivos/libNombreBiblioteca.aÓ.so" en LIBSDIRS y luego -lNombreBiblioteca en LIBS (para indicar la ubicación del archivo libNombreBiblioteca.aÓ.so manualmente).
LIBSDIRS:=
LIBS:=-lm
# Por ejemplo, -lm para incluir la biblioteca libm.a la cual contiene <math.h>, <complex.h> y <fenv.h>; y -L"lib" -L"C:/Users/Mi Usuario/Documents/Ejemplo - Directorio_De_Mi_Proyecto (1)" para indicar, por ruta relativa (desde este makefile) y por ruta absoluta, respectivamente, dos directorios que contienen bibliotecas
# Más abajo se agregan -lfl y -ly para incluir las bibliotecas libfl.a y liby.a para LEX y YACC según sea necesario. Si el compilador no encontrara alguno de esos archivos, se los debe indicar manualmente agregándolos en LIBSDIRS.

# Detecta si el sistema operativo es Windows o no, sabiendo que si lo es, Windows define una variable de entorno (Windows Environment Variable) con nombre 'OS' hoy en día típicamente con valor 'Windows_NT'
ifeq ($(OS),Windows_NT)
SO:=Windows_NT
# En caso de que el sistema operativo es Windows, se detecta si la aplicación y la arquitectura del procesador son de 32 o de 64 bits (sabiendo que Windows define una variable de entorno (Windows Environment Variable) con nombre 'PROCESSOR_ARCHITECTURE' típicamente con valor 'AMD64' tanto para aplicación como procesador de 64 bits, y sino usualmente con valor 'x86' para aplicación de 32 bits, en cuyo caso Windows también define define una variable de entorno (Windows Environment Variable) con nombre 'PROCESSOR_ARCHITEW6432' típicamente con valor 'AMD64' para procesador de 64 bits, y sino usualmente con valor 'x86' para procesador de 32 bits
ifeq ($(PROCESSOR_ARCHITECTURE),AMD64)
APPLICATION_BITS:=64
PROCESSOR_BITS:=64
else
APPLICATION_BITS:=32
ifeq ($(PROCESSOR_ARCHITEW6432),AMD64)
PROCESSOR_BITS:=64
else
PROCESSOR_BITS:=32
endif
endif
# Para definir si la shell puede ejecutar el comando <start> de Windows o no
ifneq ($(shell command -v start ;),)
OPEN_COMMAND:=start
endif
# Para definir si la shell puede ejecutar el comando <where> de Windows o no
ifneq ($(shell command -v where ;),)
PATHNAME_COMMAND:=where
endif
endif

# Así se puede detectar el sistema (o kernel) en ejecución ; particularmente se consulta si se está utilizando Cygwin o no
UNAME_S:=$(shell uname)
SYSTEM:=$(patsubst CYGWIN_NT%,CYGWIN_NT,$(UNAME_S))

# Configuraciones de acuerdo con el sistema operativo
ifeq ($(SO),Windows_NT)
# Para Windows, se genera un ejecutable *.exe
BINSEXT:=exe
# También para Windows, si el procesador es de 64 bits y no se está usando Cygwin, se le agrega la bandera -m32 a CC para forzar a que éste construya binarios de 32 bits por más que el procesador sea de 64 bits
ifeq ($(PROCESSOR_BITS),64)
ifneq ($(SYSTEM),CYGWIN_NT)
CFLAGS+=-m32
endif
endif
else
# En cualquier otro sistema operativo (GNU/Linux, MacOS, etc.) se genera un archivo *.out
BINSEXT:=out
endif

# Acá se configura el debug de CC, YACC y LEX según se encuentre habilitado o deshabilitado
# Por defecto el debug está deshabilitado: en caso de que no se le defina un valor a DEBUG al comando de make, es como si se le agregara DEBUG=0
# Si se quiere habilitar el debug de CC, YACC y LEX, se debe agregar DEBUG=1 al comando de make. Por ejemplo: <make DEBUG=1>, <make all DEBUG=1> y <make clean all DEBUG=1>
DEBUG?=0
ifneq ($(DEBUG),0)
# Agregar acá los flags que se le quieran pasar a CC cuando se habilite el modo debug (DEBUG=1), como ser -g (produce información de depuración en el formato nativo del sistema operativo (stabs,COFF, XCOFF, o DWARF) para que pueda depurarse)
CFLAGS+= -g
# Agregar acá los flags que se le quieran pasar a YACC cuando se habilite el modo debug (DEBUG=1), como ser -t (define la macro YYDEBUG a 1 si no se la define)
YFLAGS+= -t
# Agregar acá los flags que se le quieran pasar a LEX cuando se habilite el modo debug (DEBUG=1), como ser -d (hace que el analizador generado se ejecute en modo de depuración)
LFLAGS+= -d
# Cuando se habilite el debug (DEBUG=1), y sólo cuando CC vaya a generar el archivo objeto desde el archivo de C generado por YACC (de *.tab.c a *.tab.o) se le pasará este flag -D para que defina la macro YYDEBUG en un valor entero distinto de 0 lo cual permite la depuracion de YACC
C_YOBJFLAGS+= -DYYDEBUG=1
else
# Cuando se deshabilite el debug (DEBUG=0), y sólo cuando CC vaya a generar el archivo objeto desde el archivo de C generado por YACC (de *.tab.c a *.tab.o) se le pasará este flag -D para que defina la macro YYDEBUG en el valor entero 0 lo cual NO permite la depuracion de YACC
C_YOBJFLAGS+= -DYYDEBUG=0
endif

# Acá se configuran los warnings de CC, YACC y LEX según se encuentren habilitados o deshabilitados
# Por defecto los warnings están deshabilitados: en caso de que no se le defina un valor a WARNINGS a un comando de make al generar un archivo intermedio y/o al construir un binario, es como si se le agregara WARNINGS=0
# Si se quieren habilitar los warnings de CC, YACC y LEX, se deben tanto generar los archivos intermedios así como construir el binario estando los comandos de make con WARNINGS=1 agregado al hacerlo. Por ejemplo: <make WARNINGS=1>, <make all WARNINGS=1> y <make clean all WARNINGS=1>
WARNINGS?=0
ifneq ($(WARNINGS),0)
# Agregar acá los flags que se le quieran pasar a CC cuando se habiliten los warnings (WARNINGS=1), como ser -Wall (para mostrar la mayoría de los tipos de warnings), -Wextra (para mostrar aún más tipos de warnings que -Wall), -Werror (para tratar a todos los warnings como errores), -Wfatal-errors (para que no siga con la compilación tras ocurrir algún error, en lugar de intentar continuar e imprimir más mensajes de error), -Wno-unused-function (para que NO muestre un warning cuando una función con static como especificador de clase de almacenamiento es declarada pero no definida o que no es utilizada), -Wno-unused-but-set-variable (para que NO muestre un warning cuando una variable local es inicializada pero no es utilizada), -Wno-unused-variable (para que NO muestre un warning cuando una variable local o con static como especificador de clase de almacenamiento es declarada no es utilizada), etc.
CFLAGS+= -Wall
# Agregar acá los flags que se le quieran pasar a YACC cuando se habiliten los warnings (WARNINGS=1), como ser -Wall (para mostrar todos los warnings), -Werror (para tratar a los warnings como errores), etc.
YFLAGS+= -Wall
# Agregar acá los flags que se le quieran pasar a LEX cuando se habiliten los warnings (WARNINGS=1)
LFLAGS+=
else
# Agregar acá los flags que se le quieran pasar a CC cuando se deshabiliten los warnings (WARNINGS=0), como ser -w (para no mostrar ningún warning)
CFLAGS+=
# Agregar acá los flags que se le quieran pasar a YACC cuando se deshabiliten los warnings (WARNINGS=0), como ser -Wnone (para no mostrar ningún warning)
YFLAGS+=
# Agregar acá los flags que se le quieran pasar a LEX cuando se deshabiliten los warnings (WARNINGS=0), como ser -w (para suprimir todos los mensajes de warning)
LFLAGS+=
endif

# Agregar acá otros flags que se le quieran pasar siempre a CC, YACC y LEX además de los flags que ya están, según corresponda
CFLAGS+=
# Para YACC, por ejemplo, --report=state (para que se incluya en el archivo *.output generado una descripción de la gramática, conflictos tanto resueltos como sin resolver, y el autómata LALR), --report=lookahead (para incrementar la descripción del autómata con cada conjunto de tokens siguientes de cada regla sobre el archivo *.output generado), --report=itemset (para que se incluya en el archivo *.output generado una descripción de la gramática, conflictos tanto resueltos como sin resolver, y el autómata LALR), --report=lookahead (para incrementar la descripción del autómata con el conjunto completo de ítems derivados para cada estado, en lugar de solamente el denominado núcleo sobre el archivo *.output generado), etc.
YFLAGS+= --report=state --report=lookahead --report=itemset
LFLAGS+=

# Agregar acá otros flags que se le quieran pasar siempre a CC sólo al generar los archivos objeto desde los de C fuentes (de *.c a *.o), desde los archivos de C generados por YACC (de *.tab.c a *.tab.o) y desde los archivos de C generados por LEX (de *.lex.yy.c a *.lex.yy.o) además de los flags que ya están, según corresponda
C_COBJFLAGS+=
C_YOBJFLAGS+=
C_LOBJFLAGS+=

# Definimos en una variable la configuración para poder mostrarla en donde sea relevante para el usuario
configuracion:=DEBUG: $(if $(filter-out 0,$(DEBUG)),Si,No) | WARNINGS: $(if $(filter-out 0,$(WARNINGS)),Si,No)

# Define las variables de los directorios pero con secuencias de escape para los espacios  
define escapar_directorio
ESC_$(1):=$(subst $(espacio),\$(espacio),$($(1)))
endef
$(foreach directorio,SRCDIR OBJDIR BINDIR,$(eval $(call escapar_directorio,$(directorio))))

# Encuentra los archivos de cabecera (header files) ($(SRCDIR)/*.h) fuentes
HSRCS:=$(subst "",,"$(subst .h $(SRCDIR),.h" "$(SRCDIR),$(wildcard $(ESC_SRCDIR)/*.h))")

# Acá se deben agregar las rutas relativas (desde este makefile) y/o rutas absolutas a todos los archivos de cabecera (header files) (*.h) DEFINIDOS POR EL USUARIO de los que dependen los archivos de C (*.c), YACC (*.y), y LEX (*.l), según corresponda.
# Es decir, sólo aquellos que están entre comillas (""), como ser: #include "misfunciones.h"; no los que están entre corchetes angulares (<>), como #include <math.h>)
# Cada una de las rutas agregadas tiene que ser hacia un archivo de cabecera (header file) (*.h), debe estar entre comillas dobles ("") y separadas entre sí al menos por un solo espacio
CDEPS:=$(HSRCS)
YDEPS:=$(HSRCS)
LDEPS:=$(HSRCS)
# Por ejemplo: "src/dependencia1.h" "src/dependencia2.h" ... "src/dependenciaN.h"

# Encuentra y agrega los archivos fuente de C ($(SRCDIR)/*.c), YACC ($(SRCDIR)/*.y) y LEX ($(SRCDIR)/*.l), respectivamente
# Cada una de las rutas agregadas tiene que ser hacia un archivo (*.c), (*.y) o (*.l) según corresponda, debe estar entre comillas dobles ("") y separadas entre sí al menos por un solo espacio
CSRCS:=$(subst "",,"$(subst .c $(SRCDIR),.c" "$(SRCDIR),$(wildcard $(ESC_SRCDIR)/*.c))")
YSRCS:=$(subst "",,"$(subst .y $(SRCDIR),.y" "$(SRCDIR),$(wildcard $(ESC_SRCDIR)/*.y))")
LSRCS:=$(subst "",,"$(subst .l $(SRCDIR),.l" "$(SRCDIR),$(wildcard $(ESC_SRCDIR)/*.l))")

# Comprueba que el formato de las rutas definidas en CDEPS, YDEPS, LDEPS, CSRCS, YSRCS y LSRCS sea correcto: tienen que ser hacia archivos (*.h), (*.c), (*.y) o (*.l) según corresponda, deben estar entre comillas dobles ("") y separados entre sí por al menos un espacio
define comprobar_formato
$(if $(shell echo "$(subst ",\",$($(1)))" | grep -E -x -v '("[^"]*\$(2)"(( )+"[^"]*\$(2)")*)?' ;),$(error ERROR: El formato de las rutas hacia archivos *$(2) definidas en la variable $(1) del makefile es incorrecto [tienen que ser hacia archivos *$(2), deben estar entre comillas dobles ("") y separados entre si por al menos un espacio]: $($(1))))
endef
$(foreach variable,CDEPS YDEPS LDEPS,$(eval $(call comprobar_formato,$(variable),.h)))
$(eval $(call comprobar_formato,CSRCS,.c))
$(eval $(call comprobar_formato,YSRCS,.y))
$(eval $(call comprobar_formato,LSRCS,.l))

# Comprueba que todos los archivos definidos en CDEPS, YDEPS, LDEPS, CSRCS, YSRCS y LSRCS existan
define comprobar_existencias
archivos_inexistentes:=$(shell for FILE in $($(1)) ; do if [ ! -f "$$FILE" ]; then echo "\"$$FILE\"" ; fi ; done ;)
$$(if $$(archivos_inexistentes),$$(error ERROR: El/los siguiente/s archivo/s definido/s en la variable $(1) del makefile no existe/n: $$(archivos_inexistentes)))
endef
$(foreach variable,CDEPS YDEPS LDEPS CSRCS YSRCS LSRCS,$(eval $(call comprobar_existencias,$(variable))))

# Agrega las rutas a todos los archivos de cabecera (header files) (*.h) con definiciones de YACC ($(OBJDIR)/*.tab.h) a generar de acuerdo con los archivos fuente de YACC ($(SRCDIR)/*.y) como dependencias de los archivos de C (*.c)
CDEPS:=$(shell echo "$(subst ",\",$(CDEPS))" | sed 's|"\(.*\)"|"\1" |g' ;)$(shell echo "$(subst ",\",$(YSRCS))" | sed 's|"$(SRCDIR)/\([^"]*\)\.y"|"$(OBJDIR)/\1.tab.h"|g' ;)
# Esto se hace con el propósito de que primero se generen los archivos de cabecera (header files) (*.h) con definiciones de YACC ($(OBJDIR)/*.tab.h) y recién luego se puedan generar los archivos objeto (*.o) a partir de los archivos de C (*.c), ya que estos pueden depender de ellos

# De acuerdo con las dependencias agregadas en CDEPS, YDEPS y LDEPS, produce los flags -I"Directorio" para pasarle a CC según corresponda, para indicar los directorios en donde se encuentran dichos archivos de cabecera (header files) (*.h) DEFINIDOS POR EL USUARIO
CIDIRS:=$(if $(CDEPS),$(subst -I".",-I"$(CURDIR)",$(shell for DEP in $(CDEPS) ; do dirname $$DEP ; done | sort | uniq | sed 's|\([^\n]*\)|-I"\1"|g' ;)))
YIDIRS:=$(if $(YDEPS),$(subst -I".",-I"$(CURDIR)",$(shell for DEP in $(YDEPS) ; do dirname $$DEP ; done | sort | uniq | sed 's|\([^\n]*\)|-I"\1"|g' ;)))
LIDIRS:=$(if $(LDEPS),$(subst -I".",-I"$(CURDIR)",$(shell for DEP in $(LDEPS) ; do dirname $$DEP ; done | sort | uniq | sed 's|\([^\n]*\)|-I"\1"|g' ;)))

# Produce el nombre de todos los archivos objeto a generar de acuerdo con los archivos fuente de C ($(SRCDIR)/*.c), YACC ($(SRCDIR)/*.y) y LEX ($(SRCDIR)/*.l), respectivamente
COBJS:=$(shell echo "$(subst ",\",$(CSRCS))" | sed 's|"$(SRCDIR)/\([^"]*\)\.c"|"$(OBJDIR)/\1.o"|g' ;)
YOBJS:=$(shell echo "$(subst ",\",$(YSRCS))" | sed 's|"$(SRCDIR)/\([^"]*\)\.y"|"$(OBJDIR)/\1.tab.o"|g' ;)
LOBJS:=$(shell echo "$(subst ",\",$(LSRCS))" | sed 's|"$(SRCDIR)/\([^"]*\)\.l"|"$(OBJDIR)/\1.lex.yy.o"|g' ;)

# Primero produce el nombre de todos los binarios a generar de acuerdo con los archivos fuente de LEX ($(SRCDIR)/*.l)
ifneq ($(LSRCS),)
BINS:=$(shell echo "$(subst ",\",$(LSRCS))" | sed 's|"$(SRCDIR)/\([^"]*\)\.l"|"$(BINDIR)/\1.$(BINSEXT)"|g' ;)
endif
# Luego también produce el nombre de todos los binarios a generar de acuerdo con los archivos fuente de YACC ($(SRCDIR)/*.y)
ifneq ($(YSRCS),)
ifndef BINS
BINS:=$(shell echo "$(subst ",\",$(YSRCS))" | sed 's|"$(SRCDIR)/\([^"]*\)\.y"|"$(BINDIR)/\1.$(BINSEXT)"|g' ;)
else
BINS:=$(shell for BIN in $(BINS) $(shell echo "$(subst ",\",$(LSRCS))" | sed 's|"$(SRCDIR)/\([^"]*\)\.l"|"$(BINDIR)/\1.$(BINSEXT)"|g' ;) ; do echo "$$BIN" ; done | sort | uniq | sed 's|\([^\n]*\)|"\1"|g' ;)
endif
endif
# Si no hubieran archivos fuente de YACC ($(SRCDIR)/*.y) ni de LEX ($(SRCDIR)/*.l), entonces produce el nombre de todos los binarios a generar de acuerdo con los archivos fuente de C ($(SRCDIR)/*.c)
ifndef BINS
BINS:=$(shell echo "$(subst ",\",$(CSRCS))" | sed 's|"$(SRCDIR)/\([^"]*\)\.c"|"$(BINDIR)/\1.$(BINSEXT)"|g' ;)
CEXCLUSIVE:=1
endif

# Alerta si no hay ningun binario a generar definido en la variable BINS del makefile
$(if $(BINS),,$(error ERROR: no se ha encontrado ningun archivo de $(CC) (*.c), $(YACC) (*.y) ni $(LEX) (*.l) en el directorio de archivos fuente definido en la variable SRCDIR del makefile: "$(SRCDIR)"))

# Produce el nombre de todos los archivos que se generan al compilar (tanto archivos secundarios como binarios), a excepción de los archivos objeto de acuerdo con los archivos fuente de C (COBJS)
ifndef CEXCLUSIVE
ALL:=$(shell for BIN in $(shell echo "$(subst ",\",$(BINS))" | sed 's|"$(BINDIR)/\([^"]*\)\.$(BINSEXT)"|"\1"|g' ;) ; do if [ -f "$(SRCDIR)/$$BIN.y" ]; then echo "\"$(OBJDIR)/$$BIN.tab.c\"" ; echo "\"$(OBJDIR)/$$BIN.tab.h\"" ; echo "\"$(OBJDIR)/$$BIN.output\"" ; echo "\"$(OBJDIR)/$$BIN.tab.o\"" ; fi ; if [ -f "$(SRCDIR)/$$BIN.l" ]; then echo "\"$(OBJDIR)/$$BIN.lex.yy.c\"" ; echo "\"$(OBJDIR)/$$BIN.lex.yy.o\"" ; fi ; echo "\"$(BINDIR)/$$BIN.$(BINSEXT)\"" ; done ; )
endif

# Definimos las variables de los archivos a generar pero con secuencias de escape para los espacios  
define escapar_archivos
ESC_$(1):=$(subst ",,$(subst "\ "," ",$(subst $(espacio),\$(espacio),$($(1)))))
endef
$(foreach variable,COBJS YOBJS LOBJS BINS ALL,$(eval $(call escapar_archivos,$(variable))))

# Para especificar los objetivos que no generan archivos con ese mismo nombre para que se ejecuten siempre por más de que los archivos puedan llegar a existir
.PHONY: all run open clean cdebug-run cdebug-open
# La receta de una regla siempre se ejecutará si tiene como prerequisito de tipo normal a un target que sea .PHONY

# Para eliminar la lista de sufijos conocidos que make genera por defecto
.SUFFIXES:
# Esto lo hacemos para desactivar las reglas implícitas de make, ya que traen problemas por sus comportamientos erráticos

# Para habilitar una segunda expansión en los prerequisitos para todas las reglas que siguen a continuación 
.SECONDEXPANSION:
# Esto lo hacemos para poder producir las secuencias de escape para los espacios en aquellos objetivos que utilizan reglas de patrón (los que contienen el caracter %)

# Para comprobar si se pueden encontrar los comandos que se van a ejecutar
define sh_existe_comando
if ! command -v $(1) >/dev/null; then echo "ERROR: El comando <$(1)> no esta instalado y/o no se puede encontrar y ejecutar" ; exit 1 ; fi
endef

# Para mostrar la ruta hacia el comando
ifeq ($(PATHNAME_COMMAND),where)
define sh_ruta_comando
echo "** Ruta hacia $(1): $$(where $(1) | sed -n 1p) **"
endef
else
define sh_ruta_comando
echo "** Ruta hacia $(1): $$(command -v $(1)) **"
endef
endif

# Si el binario ya existiera, fuerza su eliminación por si el archivo está en uso, ya que esto impediría su construcción
define forzar_eliminacion_si_ya_existiera_el_binario
if [ -f "$(1)" ]; then \
	echo "" ; \
	echo "<<< Eliminando el binario ya existente: \"$(1)\" >>>" ; \
	echo "rm -f \"$(1)\"" ; rm -f "$(1)" ; \
	echo "<<< Realizado >>>" ; \
fi ;
endef

# Muestra una nota si el debug está habilitado
define mostrar_nota_sobre_yacc_si_la_depuracion_esta_habilitada
if [ ! "$(DEBUG)" = "0" ]; then \
	echo "" ; \
	echo "NOTA: Se ha definido la macro YYDEBUG en un valor entero distinto de 0 para permitir la depuracion de $(YACC)" ; \
	echo "  Para depurar $(YACC), tambien debe asignarle un valor entero distinto de 0 a la variable de tipo int yydebug" ; \
	echo "  Una manera de lograr eso es agregarle el siguiente codigo al main() antes de que se llame a yyparse():" ; \
	echo "    #if YYDEBUG" ; \
	echo "      yydebug = 1;" ; \
	echo "    #endif" ; \
fi ;
endef

# Acá se configura el 'make all' según la regeneración de los archivos secundarios al ser eliminados se encuentre habilitada o deshabilitada
# Por defecto la regeneración de los archivos secundarios está habilitada
REGENERATE_SECONDARY:=1
ifneq ($(REGENERATE_SECONDARY),0)
ifndef CEXCLUSIVE
# Para construir todos los archivos secundarios y todos los binarios con sus SRCDIR/*.l y/o SRCDIR/*.y como fuentes. Se ejecuta con <make> (por ser la primera regla) o <make all>
all: $(subst ",,$(subst "\ "," ",$(subst $(espacio),\$(espacio),$(CSRCS)))) $(subst ",,$(subst "\ "," ",$(subst $(espacio),\$(espacio),$(CDEPS)))) $(ESC_COBJS) $(subst ",,$(subst "\ "," ",$(subst $(espacio),\$(espacio),$(YSRCS)))) $(subst ",,$(subst "\ "," ",$(subst $(espacio),\$(espacio),$(YDEPS)))) $(subst ",,$(subst "\ "," ",$(subst $(espacio),\$(espacio),$(LSRCS)))) $(subst ",,$(subst "\ "," ",$(subst $(espacio),\$(espacio),$(LDEPS)))) $(ESC_ALL)
else
# Para construir todos los archivos secundarios y todos los binarios con sus SRCDIR/*.c como fuentes. Se ejecuta con <make> (por ser la primera regla) o <make all>
all: $(subst ",,$(subst "\ "," ",$(subst $(espacio),\$(espacio),$(CSRCS)))) $(subst ",,$(subst "\ "," ",$(subst $(espacio),\$(espacio),$(CDEPS)))) $(ESC_COBJS) $(ESC_BINS)
endif
else
# Para construir todos los binarios ya sea con sus SRCDIR/*.l y/o SRCDIR/*.y o ya sea con sus SRCDIR/*.c como fuentes. Se ejecuta con <make> (por ser la primera regla) o <make all>
all: $(ESC_BINS)
# Para que make no elimine los archivos secundarios (aquellos que son creados por regla prerequisito de otra regla) al terminar
.SECONDARY: $(ESC_BINS) $(ESC_OBJDIR) $(ESC_BINDIR) $(ESC_COBJS) $(ESC_YOBJS) $(subst ",,$(subst "\ "," ",$(subst $(espacio),\$(espacio),$(shell echo "$(subst ",\",$(YOBJS))" | sed 's|"$(OBJDIR)/\([^"]*\)\.tab\.o"|"$(OBJDIR)/\1.tab.c"|g' ;)))) $(subst ",,$(subst "\ "," ",$(subst $(espacio),\$(espacio),$(shell echo "$(subst ",\",$(YOBJS))" | sed 's|"$(OBJDIR)/\([^"]*\)\.tab\.o"|"$(OBJDIR)/\1.tab.h"|g' ;)))) $(subst ",,$(subst "\ "," ",$(subst $(espacio),\$(espacio),$(shell echo "$(subst ",\",$(YOBJS))" | sed 's|"$(OBJDIR)/\([^"]*\)\.tab\.o"|"$(OBJDIR)/\1.output"|g' ;)))) $(ESC_LOBJS) $(subst ",,$(subst "\ "," ",$(subst $(espacio),\$(espacio),$(shell echo "$(subst ",\",$(LOBJS))" | sed 's|"$(OBJDIR)/\([^"]*\)\.lex\.yy\.o"|"$(OBJDIR)/\1.lex.yy.c"|g' ;))))
endif

# Para ejecutar los binarios que se construyen sucesivamente desde la misma ventana
run:
	@echo ""
	@echo "=================[ Ejecutar sucesivamente en esta ventana el/los binario/s: $(subst ",\",$(BINS)) ]================="
	@for BIN in $(shell echo "$(subst ",\",$(BINS))" | sed 's|"$(BINDIR)/\([^"]*\)\.$(BINSEXT)"|"\1.$(BINSEXT)"|g' ;) ; do \
		echo "" ; \
		echo "<<< Ejecutando en esta ventana el binario: \"$(BINDIR)/$$BIN\" >>>" ; \
		if [ -f "$(BINDIR)/$$BIN" ]; then \
			echo "cd \"$(BINDIR)\"" ; cd "$(BINDIR)" ; \
			echo "\"./$$BIN\"" ; "./$$BIN" ; \
			echo "cd - >/dev/null" ; cd - >/dev/null ; \
		else \
			echo "(No existe el binario \"$(BINDIR)/$$BIN\")" ; \
		fi ; \
		echo "<<< Realizado >>>" ; \
	done ;
	@echo ""
	@echo "=================[ Finalizado ]============="

# Para abrir los binarios que se construyen sucesivamente en ventanas nuevas
open:
	@echo ""
	@echo "=================[ Ejecutar sucesivamente en una/s ventana/s nueva/s el/los binario/s: $(subst ",\",$(BINS)) ]================="
	@for BIN in $(shell echo "$(subst ",\",$(BINS))" | sed 's|"$(BINDIR)/\([^"]*\)\.$(BINSEXT)"|"\1.$(BINSEXT)"|g' ;) ; do \
		echo "" ; \
		echo "<<< Ejecutando en una ventana nueva el binario: \"$(BINDIR)/$$BIN\" >>>" ; \
		if [ -f "$(BINDIR)/$$BIN" ]; then \
			case "$(OPEN_COMMAND)" in \
				"start") \
					echo "cd \"$(BINDIR)\"" ; cd "$(BINDIR)" ; \
					echo "start \"$(subst /,\\,$(CURDIR)/$(BINDIR)/)\$$BIN \" \"$$BIN\"" ; start "$(subst /,\\,$(CURDIR)/$(BINDIR)/)\$$BIN " "$$BIN" ; \
					echo "cd - >/dev/null" ; cd - >/dev/null ;; \
				*) \
					$(call sh_existe_comando,tmux) ; \
					$(call sh_ruta_comando,tmux) ; \
					echo "** Version instalada de tmux: $$(tmux -V | sed -n 1p) **" ; \
					echo "cd \"$(BINDIR)\"" ; cd "$(BINDIR)" ; \
					echo "tmux new \"echo \\\"NOTA: ...\\\" ; \\\"./$$BIN\\\"\"" ; tmux new "echo \"NOTA: Esta es una ventana de una sesion abierta de tmux (Terminal MUltipleXer)\" ; echo \"  * Para cerrar la ventana de la sesion, presione <CTRL+b>, seguidamente presione <x> y por ultimo presione <y>\" ; echo \"  * Para apartar la sesion con sus ventanas sin cerrarla [detach], presione <CTRL+b> y seguidamente presione <d>\" ; echo \"  * Para alternar entre las sesiones abiertas de tmux, presione <CTRL+b> y seguidamente presione <s>\" ; echo \"  * Para alternar entre las ventanas de las sesiones abiertas de tmux, presione <CTRL+b> y seguidamente presione <w>\" ; echo \"  * Para iniciar el modo desplazamiento por la ventana, presione <CTRL+b> y seguidamente presione <[> . Para finalizarlo, presione <q>\" ; echo \"\\\"./$$BIN\\\"\" ; \"./$$BIN\"" ; \
					echo "NOTA: Para volver a las sesiones apartadas de tmux [detached], ejecute el comando <tmux attach>" ; \
					echo "cd - >/dev/null" ; cd - >/dev/null ;; \
			esac ; \
		else \
			echo "(No existe el binario \"$(BINDIR)/$$BIN\")" ; \
		fi ; \
		echo "<<< Realizado >>>" ; \
	done ;
	@echo ""
	@echo "=================[ Finalizado ]============="

# Para borrar todos los archivos intermedios y binarios generados al compilar
clean:
	@echo ""
	@echo "=================[ Eliminar todo lo que se genera al compilar ]================="
	@if [ -d "$(BINDIR)" ]; then \
		for BIN in $(BINS) ; do \
			if [ -f "$$BIN" ]; then \
				echo "" ; \
				echo "<<< Eliminando el binario: \"$$BIN\" >>>" ; \
				echo "rm -f \"$$BIN\"" ; rm -f "$$BIN" ; \
				echo "<<< Realizado >>>" ; \
			fi ; \
		done ; \
		echo "" ; \
		echo "<<< Eliminando el directorio \"$(BINDIR)\" si esta vacio y no esta en uso >>>" ; \
		echo "rmdir \"$(BINDIR)\" 2>/dev/null || true" ; rmdir "$(BINDIR)" 2>/dev/null || true ; \
		echo "<<< Realizado >>>" ; \
	fi ;
	@if [ -d "$(OBJDIR)" ]; then \
		if [ ! $(CEXCLUSIVE) ]; then \
			for BIN in $(shell echo "$(subst ",\",$(BINS))" | sed 's|"$(BINDIR)/\([^"]*\)\.$(BINSEXT)"|"$(OBJDIR)/\1"|g' ;) ; do \
				for EXT in .lex.yy.o .lex.yy.c .tab.o .output .tab.h .tab.c ; do \
					if [ -f "$$BIN$$EXT" ]; then \
						echo "" ; \
						echo "<<< Eliminando el archivo intermedio: \"$$BIN$$EXT\" >>>" ; \
						echo "rm -f \"$$BIN$$EXT\"" ; rm -f "$$BIN$$EXT" ; \
						echo "<<< Realizado >>>" ; \
					fi ; \
				done ; \
			done ; \
		fi ; \
		for COBJ in $(COBJS) ; do \
			if [ -f "$$COBJ" ]; then \
				echo "" ; \
				echo "<<< Eliminando el archivo intermedio: \"$$COBJ\" >>>" ; \
				echo "rm -f \"$$COBJ\"" ; rm -f "$$COBJ" ; \
				echo "<<< Realizado >>>" ; \
			fi ; \
		done ; \
		echo "" ; \
		echo "<<< Eliminando el directorio \"$(OBJDIR)\" si esta vacio y no esta en uso >>>" ; \
		echo "rmdir \"$(OBJDIR)\" 2>/dev/null || true" ; rmdir "$(OBJDIR)" 2>/dev/null || true ; \
		echo "<<< Realizado >>>" ; \
	fi ;
	@echo ""
	@echo "=================[ Finalizado ]============="

# Para depurar los binarios que se construyen sucesivamente desde la misma ventana
cdebug-run:
	@echo ""
	@echo "=================[ Depurar sucesivamente en esta ventana el/los binario/s: $(subst ",\",$(BINS)) ]================="
	@for BIN in $(shell echo "$(subst ",\",$(BINS))" | sed 's|"$(BINDIR)/\([^"]*\)\.$(BINSEXT)"|"\1.$(BINSEXT)"|g' ;) ; do \
		echo "" ; \
		echo "<<< $(CDB): Depurando en esta ventana el binario: \"$(BINDIR)/$$BIN\" >>>" ; \
		if [ -f "$(BINDIR)/$$BIN" ]; then \
			$(call sh_existe_comando,$(CDB)) ; \
			$(call sh_ruta_comando,$(CDB)) ; \
			echo "** Version instalada de $(CDB): $$($(CDB) --version | sed -n 1p) **" ; \
			echo "cd \"$(BINDIR)\"" ; cd "$(BINDIR)" ; \
			echo "$(CDB) $(CDBFLAGS) \"./$$BIN\"" ; $(CDB) $(CDBFLAGS) "./$$BIN" ; \
			echo "cd - >/dev/null" ; cd - >/dev/null ; \
		else \
			echo "(No existe el binario \"$(BINDIR)/$$BIN\")" ; \
		fi ; \
		echo "<<< Realizado >>>" ; \
	done ;
	@echo ""
	@echo "=================[ Finalizado ]============="

# Para depurar los binarios que se construyen sucesivamente en ventanas nuevas
cdebug-open:
	@echo ""
	@echo "=================[ Depurar sucesivamente en una/s ventana/s nueva/s el/los binario/s: $(subst ",\",$(BINS)) ]================="
	@for BIN in $(shell echo "$(subst ",\",$(BINS))" | sed 's|"$(BINDIR)/\([^"]*\)\.$(BINSEXT)"|"\1.$(BINSEXT)"|g' ;) ; do \
		echo "" ; \
		echo "<<< $(CDB): Depurando en una ventana nueva el binario: \"$(BINDIR)/$$BIN\" >>>" ; \
		if [ -f "$(BINDIR)/$$BIN" ]; then \
			$(call sh_existe_comando,$(CDB)) ; \
			$(call sh_ruta_comando,$(CDB)) ; \
			echo "** Version instalada de $(CDB): $$($(CDB) --version | sed -n 1p) **" ; \
			case "$(OPEN_COMMAND)" in \
				"start") \
					echo "cd \"$(BINDIR)\"" ; cd "$(BINDIR)" ; \
					echo "start $(CDB) $(CDBFLAGS) \"$$BIN\"" ; start $(CDB) $(CDBFLAGS) "$$BIN" ; \
					echo "cd - >/dev/null" ; cd - >/dev/null ;; \
				*) \
					$(call sh_existe_comando,tmux) ; \
					$(call sh_ruta_comando,tmux) ; \
					echo "** Version instalada de tmux: $$(tmux -V | sed -n 1p) **" ; \
					echo "cd \"$(BINDIR)\"" ; cd "$(BINDIR)" ; \
					echo "tmux new \"echo \\\"NOTA: ...\\\" ; $(CDB) $(CDBFLAGS) \\\"$$BIN\\\"\"" ; tmux new "echo \"NOTA: Esta es una ventana de una sesion abierta de tmux (Terminal MUltipleXer)\" ; echo \"  * Para cerrar la ventana de la sesion, presione <CTRL+b>, seguidamente presione <x> y por ultimo presione <y>\" ; echo \"  * Para apartar la sesion con sus ventanas sin cerrarla [detach], presione <CTRL+b> y seguidamente presione <d>\" ; echo \"  * Para alternar entre las sesiones abiertas de tmux, presione <CTRL+b> y seguidamente presione <s>\" ; echo \"  * Para alternar entre las ventanas de las sesiones abiertas de tmux, presione <CTRL+b> y seguidamente presione <w>\" ; echo \"  * Para iniciar el modo desplazamiento por la ventana, presione <CTRL+b> y seguidamente presione <[> . Para finalizarlo, presione <q>\" ; echo \"$(CDB) $(CDBFLAGS) \\\"$$BIN\\\"\" ; $(CDB) $(CDBFLAGS) \"$$BIN\"" ; \
					echo "NOTA: Para volver a las sesiones apartadas de tmux [detached], ejecute el comando <tmux attach>" ; \
					echo "cd - >/dev/null" ; cd - >/dev/null ;; \
			esac ; \
		else \
			echo "(No existe el binario \"$(BINDIR)/$$BIN\")" ; \
		fi ; \
		echo "<<< Realizado >>>" ; \
	done ;
	@echo ""
	@echo "=================[ Finalizado ]============="

# Para YACC + LEX + CC: Para construir el binario $(BINDIR)/%.$(BINSEXT)
$(ESC_BINDIR)/%.$(BINSEXT): $$(subst $$(espacio),\$$(espacio),$(SRCDIR)/%.l) $$(subst $$(espacio),\$$(espacio),$(SRCDIR)/%.y) $$(subst ",,$$(subst "\ "," ",$$(subst $$(espacio),\$$(espacio),$(CSRCS)))) $$(subst ",,$$(subst "\ "," ",$$(subst $$(espacio),\$$(espacio),$(CDEPS)))) $$(subst ",,$$(subst "\ "," ",$$(subst $$(espacio),\$$(espacio),$(COBJS)))) $$(subst $$(espacio),\$$(espacio),$(OBJDIR)/%.tab.c) $$(subst $$(espacio),\$$(espacio),$(OBJDIR)/%.tab.h) $$(subst ",,$$(subst "\ "," ",$$(subst $$(espacio),\$$(espacio),$(YDEPS)))) $$(subst $$(espacio),\$$(espacio),$(OBJDIR)/%.tab.o) $$(subst $$(espacio),\$$(espacio),$(OBJDIR)/%.lex.yy.c) $$(subst ",,$$(subst "\ "," ",$$(subst $$(espacio),\$$(espacio),$(LDEPS)))) $$(subst $$(espacio),\$$(espacio),$(OBJDIR)/%.lex.yy.o) | $$(subst $$(espacio),\$$(espacio),$(BINDIR))
# Anuncia que se va a iniciar la construcción
	@echo ""
	@echo "=================[ Construccion con $(YACC)+$(LEX)+$(CC): \"$@\" ]================="
# Si el binario ya existiera, fuerza su eliminación por si el archivo está en uso, ya que esto impediría su construcción
	@$(call forzar_eliminacion_si_ya_existiera_el_binario,$@)
# Construye el binario
	@echo ""
	@echo "<<< $(CC)->$(CC): Enlazando el/los archivo/s objeto con la/s biblioteca/s para construir el binario: \"$@\" [$(configuracion)] >>>"
	@$(call sh_existe_comando,$(CC))
	@$(call sh_ruta_comando,$(CC))
	@echo "** Version instalada de $(CC): $$($(CC) --version | sed -n 1p) **"
	$(CC) $(CFLAGS) -o"$@" $(COBJS) "$(shell echo "$@" | sed 's|$(BINDIR)/\(.*\)\.$(BINSEXT)|$(OBJDIR)/\1.tab.o|' ;)" "$(shell echo "$@" | sed 's|$(BINDIR)/\(.*\)\.$(BINSEXT)|$(OBJDIR)/\1.lex.yy.o|' ;)" $(LIBSDIRS) -lfl -ly $(LIBS)
	@echo "<<< Realizado >>>"
# Anuncia que se completó la construcción
	@echo ""
	@echo "=================[ Finalizado ]================="
# Muestra una nota si el debug está habilitado
	@$(call mostrar_nota_sobre_yacc_si_la_depuracion_esta_habilitada)

# Para YACC + CC: Para construir el binario $(BINDIR)/%.$(BINSEXT)
$(ESC_BINDIR)/%.$(BINSEXT): $$(subst $$(espacio),\$$(espacio),$(SRCDIR)/%.y) $$(subst ",,$$(subst "\ "," ",$$(subst $$(espacio),\$$(espacio),$(CSRCS)))) $$(subst ",,$$(subst "\ "," ",$$(subst $$(espacio),\$$(espacio),$(CDEPS)))) $$(subst ",,$$(subst "\ "," ",$$(subst $$(espacio),\$$(espacio),$(COBJS)))) $$(subst $$(espacio),\$$(espacio),$(OBJDIR)/%.tab.c) $$(subst $$(espacio),\$$(espacio),$(OBJDIR)/%.tab.h) $$(subst ",,$$(subst "\ "," ",$$(subst $$(espacio),\$$(espacio),$(YDEPS)))) $$(subst $$(espacio),\$$(espacio),$(OBJDIR)/%.tab.o) | $$(subst $$(espacio),\$$(espacio),$(BINDIR))
# Anuncia que se va a iniciar la construcción
	@echo ""
	@echo "=================[ Construccion con $(YACC)+$(CC): \"$@\" ]================="
# Si el binario ya existiera, fuerza su eliminación por si el archivo está en uso, ya que esto impediría su construcción
	@$(call forzar_eliminacion_si_ya_existiera_el_binario,$@)
# Construye el binario
	@echo ""
	@echo "<<< $(CC)->$(CC): Enlazando el/los archivo/s objeto con la/s biblioteca/s para construir el binario: \"$@\" [$(configuracion)] >>>"
	@$(call sh_existe_comando,$(CC))
	@$(call sh_ruta_comando,$(CC))
	@echo "** Version instalada de $(CC): $$($(CC) --version | sed -n 1p) **"
	$(CC) $(CFLAGS) -o"$@" $(COBJS) "$(shell echo "$@" | sed 's|$(BINDIR)/\(.*\)\.$(BINSEXT)|$(OBJDIR)/\1.tab.o|' ;)" $(LIBSDIRS) -ly $(LIBS)
	@echo "<<< Realizado >>>"
# Anuncia que se completó la construcción
	@echo ""
	@echo "=================[ Finalizado ]================="
# Muestra una nota si el debug está habilitado
	@$(call mostrar_nota_sobre_yacc_si_la_depuracion_esta_habilitada)

# Para LEX + CC: Para construir el binario $(BINDIR)/%.$(BINSEXT)
$(ESC_BINDIR)/%.$(BINSEXT): $$(subst $$(espacio),\$$(espacio),$(SRCDIR)/%.l) $$(subst ",,$$(subst "\ "," ",$$(subst $$(espacio),\$$(espacio),$(CSRCS)))) $$(subst ",,$$(subst "\ "," ",$$(subst $$(espacio),\$$(espacio),$(CDEPS)))) $$(subst ",,$$(subst "\ "," ",$$(subst $$(espacio),\$$(espacio),$(COBJS)))) $$(subst $$(espacio),\$$(espacio),$(OBJDIR)/%.lex.yy.c) $$(subst ",,$$(subst "\ "," ",$$(subst $$(espacio),\$$(espacio),$(LDEPS)))) $$(subst $$(espacio),\$$(espacio),$(OBJDIR)/%.lex.yy.o) | $$(subst $$(espacio),\$$(espacio),$(BINDIR))
# Anuncia que se va a iniciar la construcción
	@echo ""
	@echo "=================[ Construccion con $(LEX)+$(CC): \"$@\" ]================="
# Si el binario ya existiera, fuerza su eliminación por si el archivo está en uso, ya que esto impediría su construcción
	@$(call forzar_eliminacion_si_ya_existiera_el_binario,$@)
# Construye el binario
	@echo ""
	@echo "<<< $(CC)->$(CC): Enlazando el/los archivo/s objeto con la/s biblioteca/s para construir el binario: \"$@\" [$(configuracion)] >>>"
	@$(call sh_existe_comando,$(CC))
	@$(call sh_ruta_comando,$(CC))
	@echo "** Version instalada de $(CC): $$($(CC) --version | sed -n 1p) **"
	$(CC) $(CFLAGS) -o"$@" $(COBJS) "$(shell echo "$@" | sed 's|$(BINDIR)/\(.*\)\.$(BINSEXT)|$(OBJDIR)/\1.lex.yy.o|' ;)" $(LIBSDIRS) -lfl $(LIBS)
	@echo "<<< Realizado >>>"
# Anuncia que se completó la construcción
	@echo ""
	@echo "=================[ Finalizado ]================="

# Para CC: Para construir el binario $(BINDIR)/%.$(BINSEXT)
$(ESC_BINDIR)/%.$(BINSEXT): $$(subst ",,$$(subst "\ "," ",$$(subst $$(espacio),\$$(espacio),$(CSRCS)))) $$(subst ",,$$(subst "\ "," ",$$(subst $$(espacio),\$$(espacio),$(CDEPS)))) $$(subst ",,$$(subst "\ "," ",$$(subst $$(espacio),\$$(espacio),$(COBJS)))) | $$(subst $$(espacio),\$$(espacio),$(BINDIR))
# Anuncia que se va a iniciar la construcción
	@echo ""
	@echo "=================[ Construccion con $(CC): \"$@\" ]================="
# Si el binario ya existiera, fuerza su eliminación por si el archivo está en uso, ya que esto impediría su construcción
	@$(call forzar_eliminacion_si_ya_existiera_el_binario,$@)
# Construye el binario
	@echo ""
	@echo "<<< $(CC)->$(CC): Enlazando el/los archivo/s objeto con la/s biblioteca/s para construir el binario: \"$@\" [$(configuracion)] >>>"
	@$(call sh_existe_comando,$(CC))
	@$(call sh_ruta_comando,$(CC))
	@echo "** Version instalada de $(CC): $$($(CC) --version | sed -n 1p) **"
	$(CC) $(CFLAGS) -o"$@" $(COBJS) $(LIBSDIRS) $(LIBS)
	@echo "<<< Realizado >>>"
# Anuncia que se completó la construcción
	@echo ""
	@echo "=================[ Finalizado ]================="

# Para YACC + CC: Para generar el archivo objeto $(OBJDIR)/%.tab.o desde $(OBJDIR)/%.tab.c con sus dependencias
$(ESC_OBJDIR)/%.tab.o: $$(subst $$(espacio),\$$(espacio),$(SRCDIR)/%.y) $$(subst $$(espacio),\$$(espacio),$(OBJDIR)/%.tab.c) $$(subst $$(espacio),\$$(espacio),$(OBJDIR)/%.tab.h) $$(subst ",,$$(subst "\ "," ",$$(subst $$(espacio),\$$(espacio),$(YDEPS)))) | $$(subst $$(espacio),\$$(espacio),$(OBJDIR))
	@echo ""
	@echo "<<< $(YACC)->$(CC): Generando el archivo objeto: \"$@\" [$(configuracion)] >>>"
	@$(call sh_existe_comando,$(CC))
	@$(call sh_ruta_comando,$(CC))
	@echo "** Version instalada de $(CC): $$($(CC) --version | sed -n 1p) **"
	$(CC) $(CFLAGS) $(C_YOBJFLAGS) -c -o"$@" "$(shell echo "$@" | sed 's|$(OBJDIR)/\(.*\)\.tab\.o|$(OBJDIR)/\1.tab.c|' ;)" $(YIDIRS)
	@echo "<<< Realizado >>>"

# Para YACC: Para generar los archivos del analizador sintáctico (parser) $(OBJDIR)/%.tab.c, $(OBJDIR)/%.tab.h y $(OBJDIR)/%.tab.output desde $(SRCDIR)/%.y
$(ESC_OBJDIR)/%.tab.c $(ESC_OBJDIR)/%.tab.h $(ESC_OBJDIR)/%.output: $$(subst $$(espacio),\$$(espacio),$(SRCDIR)/%.y) | $$(subst $$(espacio),\$$(espacio),$(OBJDIR))
	@echo ""
	@echo "<<< $(YACC): Generando los archivos del analizador sintactico (parser): \"$(shell echo "$<" | sed 's|$(SRCDIR)/\(.*\)\.y|$(OBJDIR)/\1<.tab.c><.tab.h><.output>|' ;)\" [$(configuracion)] >>>"
	@$(call sh_existe_comando,$(YACC))
	@$(call sh_ruta_comando,$(YACC))
	@echo "** Version instalada de $(YACC): $$($(YACC) --version | sed -n 1p) **"
	$(YACC) -d -v $(YFLAGS) -o"$(shell echo "$<" | sed 's|$(SRCDIR)/\(.*\)\.y|$(OBJDIR)/\1.tab.c|' ;)" "$<"
	@echo "<<< Realizado >>>"

# Para LEX + CC (y sí hay YACC): Para generar el archivo objeto $(OBJDIR)/%.lex.yy.o desde $(OBJDIR)/%.lex.yy.c con $(OBJDIR)/%.tab.h y el resto de sus dependencias
$(ESC_OBJDIR)/%.lex.yy.o: $$(subst $$(espacio),\$$(espacio),$(SRCDIR)/%.l) $$(subst $$(espacio),\$$(espacio),$(SRCDIR)/%.y) $$(subst $$(espacio),\$$(espacio),$(OBJDIR)/%.tab.h) $$(subst $$(espacio),\$$(espacio),$(OBJDIR)/%.lex.yy.c) $$(subst ",,$$(subst "\ "," ",$$(subst $$(espacio),\$$(espacio),$(LDEPS)))) | $$(subst $$(espacio),\$$(espacio),$(OBJDIR))
	@echo ""
	@echo "<<< $(YACC)+$(LEX)->$(CC): Generando el archivo objeto: \"$@\" [$(configuracion)] >>>"
	@$(call sh_existe_comando,$(CC))
	@$(call sh_ruta_comando,$(CC))
	@echo "** Version instalada de $(CC): $$($(CC) --version | sed -n 1p) **"
	$(CC) $(CFLAGS) $(C_LOBJFLAGS) -c -o"$@" "$(shell echo "$@" | sed 's|$(OBJDIR)/\(.*\)\.lex\.yy\.o|$(OBJDIR)/\1.lex.yy.c|' ;)" $(LIDIRS)
	@echo "<<< Realizado >>>"

# Para LEX + CC (y no hay YACC): Para generar el archivo objeto $(OBJDIR)/%.lex.yy.o desde $(OBJDIR)/%.lex.yy.c con sus dependencias
$(ESC_OBJDIR)/%.lex.yy.o: $$(subst $$(espacio),\$$(espacio),$(SRCDIR)/%.l) $$(subst $$(espacio),\$$(espacio),$(OBJDIR)/%.lex.yy.c) $$(subst ",,$$(subst "\ "," ",$$(subst $$(espacio),\$$(espacio),$(LDEPS)))) | $$(subst $$(espacio),\$$(espacio),$(OBJDIR))
	@echo ""
	@echo "<<< $(LEX)->$(CC): Generando el archivo objeto: \"$@\" [$(configuracion)] >>>"
	@$(call sh_existe_comando,$(CC))
	@$(call sh_ruta_comando,$(CC))
	@echo "** Version instalada de $(CC): $$($(CC) --version | sed -n 1p) **"
	$(CC) $(CFLAGS) $(C_LOBJFLAGS) -c -o"$@" "$(shell echo "$@" | sed 's|$(OBJDIR)/\(.*\)\.lex\.yy\.o|$(OBJDIR)/\1.lex.yy.c|' ;)" $(LIDIRS)
	@echo "<<< Realizado >>>"

# Para LEX: Para generar el archivo del analizador léxico (scanner) $(OBJDIR)/%.lex.yy.c desde $(SRCDIR)/%.l
$(ESC_OBJDIR)/%.lex.yy.c: $$(subst $$(espacio),\$$(espacio),$(SRCDIR)/%.l) | $$(subst $$(espacio),\$$(espacio),$(OBJDIR))
	@echo ""
	@echo "<<< $(LEX): Generando el archivo del analizador lexico (scanner): \"$@\" [$(configuracion)] >>>"
	@$(call sh_existe_comando,$(LEX))
	@$(call sh_ruta_comando,$(LEX))
	@echo "** Version instalada de $(LEX): $$($(LEX) --version | sed -n 1p) **"
	$(LEX) $(LFLAGS) -o"$@" "$<"
	@echo "<<< Realizado >>>"

# Para CC: Para generar el archivo objeto $(OBJDIR)/%.o desde $(SRCDIR)/%.c con sus dependencias
$(ESC_OBJDIR)/%.o: $$(subst $$(espacio),\$$(espacio),$(SRCDIR)/%.c) $$(subst ",,$$(subst "\ "," ",$$(subst $$(espacio),\$$(espacio),$(CDEPS)))) | $$(subst $$(espacio),\$$(espacio),$(OBJDIR))
	@echo ""
	@echo "<<< $(CC): Generando el archivo objeto: \"$@\" [$(configuracion)] >>>"
	@$(call sh_existe_comando,$(CC))
	@$(call sh_ruta_comando,$(CC))
	@echo "** Version instalada de $(CC): $$($(CC) --version | sed -n 1p) **"
	$(CC) $(CFLAGS) $(C_COBJFLAGS) -c -o"$@" "$<" $(CIDIRS)
	@echo "<<< Realizado >>>"

# Para crear los directorios en donde se ubican los archivos intermedios y los binarios, si alguno no existiera
$(ESC_OBJDIR) $(ESC_BINDIR):
	@echo ""
	@echo "<<< Creando el directorio: \"$@\" >>>"
	mkdir -p "$@"
	@echo "<<< Realizado >>>"