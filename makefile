# Copyright (C) 2022 Fernando Daniel Maqueda

# This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
# You should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/licenses/>.

# YACC-LEX-makefile: Este makefile sirve para compilar, ejecutar y depurar proyectos de LEX (archivos *.l) y proyectos de YACC (archivos *.y) + LEX (archivos *.l) (así como proyectos que utilicen programas compatibles con LEX y YACC, como ser flex y bison)
# Requiere GNU Make desde su versión 3.81 en adelante (u otros programas compatibles)
# Asímismo necesita ser ejecutado en una shell compatible con sh (sh, bash, etc.) y poder utilizar los siguientes comandos: command printf echo cd mkdir rm rmdir true sed grep dirname sort uniq
# Adicionalmente para poder abrir una nueva ventana, para Windows utiliza el comando start, y para el resto de los sistemas operativos utiliza el comando tmux

# Para determinar el programa utilizado como la shell
SHELL:=/bin/sh

# Comprueba que este makefile se esté ejecutando en una shell compatible con sh (sh, bash, etc.)
ifneq ($(shell for ELEMENTO in "Comprobacion de " "shell" ; do printf "$$ELEMENTO" ; case "$$ELEMENTO" in esac ; if [ ! "$$ELEMENTO" = "Comprobacion de " ]; then printf "." ; fi ; done ;),Comprobacion de shell.)
$(error ERROR: el comando <make> debe ejecutarse en una shell compatible con sh (sh, bash, etc.) para que este makefile funcione correctamente (no anda en PowerShell, CMD, etc.))
endif

# Subdirectorio en el que están ubicados los archivos *h, *.c, *.y, y *.l fuente (excepto los archivos intermedios generados por CC, YACC y LEX). Por ejemplo: src
SRCDIR:=src
# Subdirectorio en el que se ubicarán los archivos intermedios generados por CC, YACC y LEX. Por ejemplo: obj
OBJDIR:=obj
# Subdirectorio en el que se ubicarán los binarios buildeados. Por ejemplo: bin
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

# Detecta si el sistema operativo es Windows o no, para ver si la shell puede ejecutar el comando <start> de Windows o no
ifeq ($(OS),Windows_NT)
SO:=Windows
endif

# Configuraciones de acuerdo con el sistema operativo
ifeq ($(SO),Windows)
# Para Windows, se genera un ejecutable *.exe y se le agrega la bandera -m32 a CC para forzar a que éste buildee binarios de 32 bits por más que sea de 64 bits
BINSEXT:=exe
CFLAGS+=-m32
else
# En cualquier otro sistema operativo (GNU/Linux, MacOS, etc.) se genera un archivo *.out
BINSEXT:=out
endif

# Acá se configura el modo debug de CC, YACC y LEX según se encuentre activado o desactivado
# Por defecto el modo debug está desactivado: en caso de que no se le defina un valor a DEBUG al comando de make, es como si se le agregara DEBUG=0
# Si se quiere activar el modo debug de CC, YACC y LEX, se debe agregar DEBUG=1 al comando de make. Por ejemplo: <make DEBUG=1>, <make all DEBUG=1>, <make clean DEBUG=1> y <make clean all DEBUG=1>
DEBUG?=0
ifneq ($(DEBUG),0)
# Agregar acá los flags que se le quieran pasar a CC cuando se active el modo debug (DEBUG=1), como ser -g (produce información de depuración en el formato nativo del sistema operativo (stabs,COFF, XCOFF, o DWARF) para que pueda depurarse)
CFLAGS+= -g
# Agregar acá los flags que se le quieran pasar a YACC cuando se active el modo debug (DEBUG=1), como ser -t (define la macro YYDEBUG a 1 si no se la define)
YFLAGS+= -t
# Agregar acá los flags que se le quieran pasar a LEX cuando se active el modo debug (DEBUG=1), como ser -d (hace que el analizador generado se ejecute en modo de depuración)
LFLAGS+= -d
# Cuando se active el modo debug (DEBUG=1), sólo cuando CC vaya a generar el archivo objeto desde el archivo de C generado por YACC (de *.tab.c a *.tab.o) se le pasará este flag -D para que defina la macro YYDEBUG en un valor entero distinto de 0 lo cual permite la depuracion de YACC
C_YOBJFLAGS+= -DYYDEBUG=1
else
# Cuando se active el modo debug (DEBUG=1), sólo cuando CC vaya a generar el archivo objeto desde el archivo de C generado por YACC (de *.tab.c a *.tab.o) se le pasará este flag -D para que defina la macro YYDEBUG en el valor entero 0 lo cual NO permite la depuracion de YACC
C_YOBJFLAGS+= -DYYDEBUG=0
endif

# Acá se configuran los warnings de CC, YACC y LEX según se encuentren activados o desactivados
# Por defecto los warnings están desactivados: en caso de que no se le defina un valor a WARNINGS a un comando de make al generar un archivo intermedio y/o al buildear un binario, es como si se le agregara WARNINGS=0
# Si se quieren activar los warnings de CC, YACC y LEX, se deben tanto generar los archivos intermedios como buildear el binario estando los comandos de make con WARNINGS=1 agregado al hacerlo. Por ejemplo: <make WARNINGS=1>, <make all WARNINGS=1> y <make clean all WARNINGS=1>
WARNINGS?=0
ifneq ($(WARNINGS),0)
# Agregar acá los flags que se le quieran pasar a CC cuando se activen los warnings (WARNINGS=1), como ser -Wall (para mostrar la mayoría de los tipos de warnings), -Wextra (para mostrar aún más tipos de warnings que -Wall), -Werror (para tratar a todos los warnings como errores), -Wfatal-errors (para que no siga con la compilación tras ocurrir algún error, en lugar de intentar continuar e imprimir más mensajes de error)
CFLAGS+= -Wall
# Agregar acá los flags que se le quieran pasar a YACC cuando se activen los warnings (WARNINGS=1), como ser -Wall (para mostrar todos los warnings), -Werror (para tratar a los warnings como errores), etc.
YFLAGS+= -Wall
# Agregar acá los flags que se le quieran pasar a LEX cuando se activen los warnings (WARNINGS=1)
LFLAGS+=
else
# Agregar acá los flags que se le quieran pasar a CC cuando se desactiven los warnings (WARNINGS=0), como ser -w (para no mostrar ningún warning)
CFLAGS+=
# Agregar acá los flags que se le quieran pasar a YACC cuando se desactiven los warnings (WARNINGS=0), como ser -Wnone (para no mostrar ningún warning)
YFLAGS+=
# Agregar acá los flags que se le quieran pasar a LEX cuando se desactiven los warnings (WARNINGS=0), como ser -w (para suprimir todos los mensajes de warning)
LFLAGS+=
endif

# Agregar acá otros flags que se le quieran pasar siempre a CC, YACC y LEX además de los flags que ya están, según corresponda
CFLAGS+=
YFLAGS+=
LFLAGS+=

# Agregar acá otros flags que se le quieran pasar siempre a CC sólo al generar los archivos objeto desde los de C fuentes (de *.c a *.o), desde los archivos de C generados por YACC (de *.tab.c a *.tab.o) y desde los archivos de C generados por LEX (de *.lex.yy.c a *.lex.yy.o) además de los flags que ya están, según corresponda
C_COBJFLAGS+=
C_YOBJFLAGS+=
C_LOBJFLAGS+=

# Definimos en una variable la configuración para poder mostrarla en donde sea relevante para el usuario
configuracion:=DEBUG: $(if $(filter-out 0,$(DEBUG)),Si,No) | WARNINGS: $(if $(filter-out 0,$(WARNINGS)),Si,No)

# Define una variable que contiene un solo espacio para luego utilizarla para sustituir cada con secuencias de escape cada uno de los espacios
espacio:=$(subst ",," ")

# Define una variable que contiene un signo numeral para poder ser utilizado en referencias macro y en invocaciones de funciones
numeral:=\#

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

# Encuentra y agrega los archivos fuentes de C ($(SRCDIR)/*.c), YACC ($(SRCDIR)/*.y) y LEX ($(SRCDIR)/*.l), respectivamente
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

# De acuerdo con las dependencias agregadas en CDEPS, YDEPS y LDEPS, produce los flags -I"Directorio" para pasarle a CC según corresponda, para indicar los directorios en donde se encuentran dichos archivos de cabecera (header files) (*.h) DEFINIDOS POR EL USUARIO
CIDIRS:=$(if $(CDEPS),$(subst -I".",-I"$(CURDIR)",$(shell dirname $(CDEPS) | sort | uniq | sed 's|\([^\n]*\)|-I"\1"|g')))
YIDIRS:=$(if $(YDEPS),$(subst -I".",-I"$(CURDIR)",$(shell dirname $(YDEPS) | sort | uniq | sed 's|\([^\n]*\)|-I"\1"|g')))
LIDIRS:=$(if $(LDEPS),$(subst -I".",-I"$(CURDIR)",$(shell dirname $(LDEPS) | sort | uniq | sed 's|\([^\n]*\)|-I"\1"|g')))

# Produce el nombre de todos los archivos objeto a generar de acuerdo con los archivos fuente de C ($(SRCDIR)/*.c), YACC ($(SRCDIR)/*.y) y LEX ($(SRCDIR)/*.l), respectivamente
COBJS:=$(shell echo "$(subst ",\",$(CSRCS))" | sed 's|"$(SRCDIR)/\([^"]*\)\.c"|"$(OBJDIR)/\1.o"|g' ;)
YOBJS:=$(shell echo "$(subst ",\",$(YSRCS))" | sed 's|"$(SRCDIR)/\([^"]*\)\.y"|"$(OBJDIR)/\1.tab.o"|g' ;)
LOBJS:=$(shell echo "$(subst ",\",$(LSRCS))" | sed 's|"$(SRCDIR)/\([^"]*\)\.l"|"$(OBJDIR)/\1.lex.yy.o"|g' ;)

# Produce el nombre de todos los binarios a generar de acuerdo con los archivos fuente de LEX ($(SRCDIR)/*.l)
BINS:=$(shell echo "$(subst ",\",$(LSRCS))" | sed 's|"$(SRCDIR)/\([^"]*\)\.l"|"$(BINDIR)/\1.$(BINSEXT)"|g' ;)

# Alerta si no hay ningun binario a generar definido en la variable BINS del makefile
$(if $(BINS),,$(error ERROR: no se ha encontrado ningun archivo de $(LEX) (*.l) en el directorio de archivos fuente definido en la variable SRCDIR del makefile: "$(SRCDIR)"))

# Produce el nombre de todos los archivos que se generan al compilar (tanto archivos secundarios como binarios), a excepción de los archivos objeto de acuerdo con los archivos fuente de C (COBJS)
ALL:=$(shell for BIN in $(shell echo "$(subst ",\",$(BINS))" | sed 's|"$(BINDIR)/\([^"]*\)\.$(BINSEXT)"|"\1"|g' ;) ; do if [ -f "$(SRCDIR)/$$BIN.y" ]; then echo "\"$(OBJDIR)/$$BIN.tab.c\"" ; echo "\"$(OBJDIR)/$$BIN.tab.h\"" ; echo "\"$(OBJDIR)/$$BIN.output\"" ; echo "\"$(OBJDIR)/$$BIN.tab.o\"" ; fi ; echo "\"$(OBJDIR)/$$BIN.lex.yy.c\"" ; echo "\"$(OBJDIR)/$$BIN.lex.yy.o\"" ; echo "\"$(BINDIR)/$$BIN.$(BINSEXT)\"" ; done ; )

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
define existe_comando
if ! command -v $(1) >/dev/null; then echo "ERROR: El comando <$(1)> no esta instalado y/o no se puede encontrar y ejecutar" ; exit 1 ; fi
endef

# Acá se configura el 'make all' según la regeneración de los archivos secundarios al ser eliminados se encuentre activada o desactivada
# Por defecto la regeneración de los archivos secundarios está activada
REGENERATE_SECONDARY:=1
ifneq ($(REGENERATE_SECONDARY),0)
# Para buildear todos los archivos secundarios y todos los binarios con sus SRCDIR/*.l como fuentes. Se ejecuta con <make> (por ser la primera regla) o <make all>
all: $(subst ",,$(subst "\ "," ",$(subst $(espacio),\$(espacio),$(CSRCS)))) $(subst ",,$(subst "\ "," ",$(subst $(espacio),\$(espacio),$(CDEPS)))) $(ESC_COBJS) $(subst ",,$(subst "\ "," ",$(subst $(espacio),\$(espacio),$(YSRCS)))) $(subst ",,$(subst "\ "," ",$(subst $(espacio),\$(espacio),$(YDEPS)))) $(subst ",,$(subst "\ "," ",$(subst $(espacio),\$(espacio),$(LSRCS)))) $(subst ",,$(subst "\ "," ",$(subst $(espacio),\$(espacio),$(LDEPS)))) $(ESC_ALL)
else
# Para buildear todos los binarios con sus SRCDIR/*.l como fuentes. Se ejecuta con <make> (por ser la primera regla) o <make all>
all: $(ESC_BINS)
# Para que make no elimine los archivos secundarios (aquellos que son creados por regla prerequisito de otra regla) al terminar
.SECONDARY: $(ESC_BINS) $(ESC_OBJDIR) $(ESC_BINDIR) $(ESC_COBJS) $(ESC_YOBJS) $(subst ",,$(subst "\ "," ",$(subst $(espacio),\$(espacio),$(shell echo "$(subst ",\",$(YOBJS))" | sed 's|"$(OBJDIR)/\([^"]*\)\.tab\.o"|"$(OBJDIR)/\1.tab.c"|g' ;)))) $(subst ",,$(subst "\ "," ",$(subst $(espacio),\$(espacio),$(shell echo "$(subst ",\",$(YOBJS))" | sed 's|"$(OBJDIR)/\([^"]*\)\.tab\.o"|"$(OBJDIR)/\1.tab.h"|g' ;)))) $(subst ",,$(subst "\ "," ",$(subst $(espacio),\$(espacio),$(shell echo "$(subst ",\",$(YOBJS))" | sed 's|"$(OBJDIR)/\([^"]*\)\.tab\.o"|"$(OBJDIR)/\1.output"|g' ;)))) $(ESC_LOBJS) $(subst ",,$(subst "\ "," ",$(subst $(espacio),\$(espacio),$(shell echo "$(subst ",\",$(LOBJS))" | sed 's|"$(OBJDIR)/\([^"]*\)\.lex\.yy\.o"|"$(OBJDIR)/\1.lex.yy.c"|g' ;))))
endif

# Para ejecutar los binarios que se buildean sucesivamente desde la misma ventana
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

# Para abrir los binarios que se buildean sucesivamente en ventanas nuevas
open:
	@echo ""
	@echo "=================[ Ejecutar sucesivamente en una/s ventana/s nueva/s el/los binario/s: $(subst ",\",$(BINS)) ]================="
	@for BIN in $(shell echo "$(subst ",\",$(BINS))" | sed 's|"$(BINDIR)/\([^"]*\)\.$(BINSEXT)"|"\1.$(BINSEXT)"|g' ;) ; do \
		echo "" ; \
		echo "<<< Ejecutando en una ventana nueva el binario: \"$(BINDIR)/$$BIN\" >>>" ; \
		if [ -f "$(BINDIR)/$$BIN" ]; then \
			case "$(SO)" in \
				"Windows") \
					echo "cd \"$(BINDIR)\"" ; cd "$(BINDIR)" ; \
					echo "start \"$(subst /,\\,$(CURDIR)/$(BINDIR)/)\$$BIN \" \"$$BIN\"" ; start "$(subst /,\\,$(CURDIR)/$(BINDIR)/)\$$BIN " "$$BIN" ; \
					echo "cd - >/dev/null" ; cd - >/dev/null ;; \
				*) \
					$(call existe_comando,tmux) ; \
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

# Para depurar los binarios que se buildean sucesivamente desde la misma ventana
cdebug-run:
	@echo ""
	@echo "=================[ Depurar sucesivamente en esta ventana el/los binario/s: $(subst ",\",$(BINS)) ]================="
	@for BIN in $(shell echo "$(subst ",\",$(BINS))" | sed 's|"$(BINDIR)/\([^"]*\)\.$(BINSEXT)"|"\1.$(BINSEXT)"|g' ;) ; do \
		echo "" ; \
		echo "<<< $(CDB): Depurando en esta ventana el binario: \"$(BINDIR)/$$BIN\" >>>" ; \
		if [ -f "$(BINDIR)/$$BIN" ]; then \
			$(call existe_comando,$(CDB)) ; \
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

# Para depurar los binarios que se buildean sucesivamente en ventanas nuevas
cdebug-open:
	@echo ""
	@echo "=================[ Depurar sucesivamente en una/s ventana/s nueva/s el/los binario/s: $(subst ",\",$(BINS)) ]================="
	@for BIN in $(shell echo "$(subst ",\",$(BINS))" | sed 's|"$(BINDIR)/\([^"]*\)\.$(BINSEXT)"|"\1.$(BINSEXT)"|g' ;) ; do \
		echo "" ; \
		echo "<<< $(CDB): Depurando en una ventana nueva el binario: \"$(BINDIR)/$$BIN\" >>>" ; \
		if [ -f "$(BINDIR)/$$BIN" ]; then \
			$(call existe_comando,$(CDB)) ; \
			echo "** Version instalada de $(CDB): $$($(CDB) --version | sed -n 1p) **" ; \
			case "$(SO)" in \
				"Windows") \
					echo "cd \"$(BINDIR)\"" ; cd "$(BINDIR)" ; \
					echo "start $(CDB) $(CDBFLAGS) \"$$BIN\"" ; start $(CDB) $(CDBFLAGS) "$$BIN" ; \
					echo "cd - >/dev/null" ; cd - >/dev/null ;; \
				*) \
					$(call existe_comando,tmux) ; \
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

# Para YACC + LEX + CC: Para buildear el binario $(BINDIR)/%.$(BINSEXT)
$(ESC_BINDIR)/%.$(BINSEXT): $$(subst $$(espacio),\$$(espacio),$(SRCDIR)/%.l) $$(subst $$(espacio),\$$(espacio),$(SRCDIR)/%.y) $$(subst ",,$$(subst "\ "," ",$$(subst $$(espacio),\$$(espacio),$(CSRCS)))) $$(subst ",,$$(subst "\ "," ",$$(subst $$(espacio),\$$(espacio),$(CDEPS)))) $$(subst ",,$$(subst "\ "," ",$$(subst $$(espacio),\$$(espacio),$(COBJS)))) $$(subst $$(espacio),\$$(espacio),$(OBJDIR)/%.tab.c) $$(subst $$(espacio),\$$(espacio),$(OBJDIR)/%.tab.h) $$(subst ",,$$(subst "\ "," ",$$(subst $$(espacio),\$$(espacio),$(YDEPS)))) $$(subst $$(espacio),\$$(espacio),$(OBJDIR)/%.tab.o) $$(subst $$(espacio),\$$(espacio),$(OBJDIR)/%.lex.yy.c) $$(subst ",,$$(subst "\ "," ",$$(subst $$(espacio),\$$(espacio),$(LDEPS)))) $$(subst $$(espacio),\$$(espacio),$(OBJDIR)/%.lex.yy.o) | $$(subst $$(espacio),\$$(espacio),$(BINDIR))
# Anuncia que se va a iniciar el build
	@echo ""
	@echo "=================[ Build con $(YACC)+$(LEX)+$(CC): \"$@\" ]================="
# Si el binario ya existiera, fuerza su eliminación por si el archivo está en uso, ya que esto impediría su buildeo
	@if [ -f "$@" ]; then \
		echo "" ; \
		echo "<<< Eliminando el binario ya existente: \"$@\" >>>" ; \
		echo "rm -f \"$@\"" ; rm -f "$@" ; \
		echo "<<< Realizado >>>" ; \
	fi ;
# Buildea el binario
	@echo ""
	@echo "<<< $(CC)->$(CC): Enlazando el/los archivo/s objeto con la/s biblioteca/s para buildear el binario: \"$@\" [$(configuracion)] >>>"
	@$(call existe_comando,$(CC))
	@echo "** Version instalada de $(CC): $$($(CC) --version | sed -n 1p) **"
	$(CC) $(CFLAGS) -o"$@" $(COBJS) "$(shell echo "$@" | sed 's|$(BINDIR)/\(.*\)\.$(BINSEXT)|$(OBJDIR)/\1.tab.o|' ;)" "$(shell echo "$@" | sed 's|$(BINDIR)/\(.*\)\.$(BINSEXT)|$(OBJDIR)/\1.lex.yy.o|' ;)" $(LIBSDIRS) -lfl -ly $(LIBS)
	@echo "<<< Realizado >>>"
# Anuncia que se completó el build
	@echo ""
	@echo "=================[ Finalizado ]================="
# Muestra una nota si el modo debug está activado
	@if [ ! "$(DEBUG)" = "0" ]; then \
		echo "" ; \
		echo "NOTA: Se ha definido la macro YYDEBUG en un valor entero distinto de 0 para permitir la depuracion de $(YACC)" ; \
		echo "  Para depurar $(YACC), tambien debe asignarle un valor entero distinto de 0 a la variable de tipo int yydebug" ; \
		echo "  Una manera de lograr eso es agregarle el siguiente codigo al main() antes de que se llame a yyparse():" ; \
		echo "    #if YYDEBUG" ; \
		echo "      yydebug = 1;" ; \
		echo "    #endif" ; \
	fi ;

# Para LEX + CC: Para buildear el binario $(BINDIR)/%.$(BINSEXT)
$(ESC_BINDIR)/%.$(BINSEXT): $$(subst $$(espacio),\$$(espacio),$(SRCDIR)/%.l) $$(subst ",,$$(subst "\ "," ",$$(subst $$(espacio),\$$(espacio),$(CSRCS)))) $$(subst ",,$$(subst "\ "," ",$$(subst $$(espacio),\$$(espacio),$(CDEPS)))) $$(subst ",,$$(subst "\ "," ",$$(subst $$(espacio),\$$(espacio),$(COBJS)))) $$(subst $$(espacio),\$$(espacio),$(OBJDIR)/%.lex.yy.c) $$(subst ",,$$(subst "\ "," ",$$(subst $$(espacio),\$$(espacio),$(LDEPS)))) $$(subst $$(espacio),\$$(espacio),$(OBJDIR)/%.lex.yy.o) | $$(subst $$(espacio),\$$(espacio),$(BINDIR))
# Anuncia que se va a iniciar el build
	@echo ""
	@echo "=================[ Build con $(LEX)+$(CC): \"$@\" ]================="
# Si el binario ya existiera, fuerza su eliminación por si el archivo está en uso, ya que esto impediría su buildeo
	@if [ -f "$@" ]; then \
		echo "" ; \
		echo "<<< Eliminando el binario ya existente: \"$@\" >>>" ; \
		echo "rm -f \"$@\"" ; rm -f "$@" ; \
		echo "<<< Realizado >>>" ; \
	fi ;
# Buildea el binario
	@echo ""
	@echo "<<< $(CC)->$(CC): Enlazando el/los archivo/s objeto con la/s biblioteca/s para buildear el binario: \"$@\" [$(configuracion)] >>>"
	@$(call existe_comando,$(CC))
	@echo "** Version instalada de $(CC): $$($(CC) --version | sed -n 1p) **"
	$(CC) $(CFLAGS) -o"$@" $(COBJS) "$(shell echo "$@" | sed 's|$(BINDIR)/\(.*\)\.$(BINSEXT)|$(OBJDIR)/\1.lex.yy.o|' ;)" $(LIBSDIRS) -lfl $(LIBS)
	@echo "<<< Realizado >>>"
# Anuncia que se completó el build
	@echo ""
	@echo "=================[ Finalizado ]================="

# Para crear los directorios en donde se ubican los archivos intermedios y los binarios, si alguno no existiera
$(ESC_OBJDIR) $(ESC_BINDIR):
	@echo ""
	@echo "<<< Creando el directorio: \"$@\" >>>"
	@echo "mkdir -p \"$@\"" ; mkdir -p "$@"
	@echo "<<< Realizado >>>"

# Para CC: Para generar el archivo objeto $(OBJDIR)/%.o desde $(SRCDIR)/%.c con sus dependencias
$(ESC_OBJDIR)/%.o: $$(subst $$(espacio),\$$(espacio),$(SRCDIR)/%.c) $$(subst ",,$$(subst "\ "," ",$$(subst $$(espacio),\$$(espacio),$(CDEPS)))) | $$(subst $$(espacio),\$$(espacio),$(OBJDIR))
	@echo ""
	@echo "<<< $(CC): Generando el archivo objeto: \"$@\" [$(configuracion)] >>>"
	@$(call existe_comando,$(CC))
	@echo "** Version instalada de $(CC): $$($(CC) --version | sed -n 1p) **"
	$(CC) $(CFLAGS) $(C_COBJFLAGS) -c -o"$@" "$<" $(CIDIRS)
	@echo "<<< Realizado >>>"

# Para YACC + CC: Para generar el archivo objeto $(OBJDIR)/%.tab.o desde $(OBJDIR)/%.tab.c con sus dependencias
$(ESC_OBJDIR)/%.tab.o: $$(subst $$(espacio),\$$(espacio),$(SRCDIR)/%.y) $$(subst $$(espacio),\$$(espacio),$(OBJDIR)/%.tab.c) $$(subst $$(espacio),\$$(espacio),$(OBJDIR)/%.tab.h) $$(subst ",,$$(subst "\ "," ",$$(subst $$(espacio),\$$(espacio),$(YDEPS)))) | $$(subst $$(espacio),\$$(espacio),$(OBJDIR))
	@echo ""
	@echo "<<< $(YACC)->$(CC): Generando el archivo objeto: \"$@\" [$(configuracion)] >>>"
	@$(call existe_comando,$(CC))
	@echo "** Version instalada de $(CC): $$($(CC) --version | sed -n 1p) **"
	$(CC) $(CFLAGS) $(C_YOBJFLAGS) -c -o"$@" "$(shell echo "$@" | sed 's|$(OBJDIR)/\(.*\)\.tab\.o|$(OBJDIR)/\1.tab.c|' ;)" $(YIDIRS)
	@echo "<<< Realizado >>>"

# Para YACC: Para generar los archivos del analizador sintáctico (parser) $(OBJDIR)/%.tab.c, $(OBJDIR)/%.tab.h y $(OBJDIR)/%.tab.output desde $(SRCDIR)/%.y
$(ESC_OBJDIR)/%.tab.c $(ESC_OBJDIR)/%.tab.h $(ESC_OBJDIR)/%.output: $$(subst $$(espacio),\$$(espacio),$(SRCDIR)/%.y) | $$(subst $$(espacio),\$$(espacio),$(OBJDIR))
	@echo ""
	@echo "<<< $(YACC): Generando los archivos del analizador sintactico (parser): \"$(shell echo "$<" | sed 's|$(SRCDIR)/\(.*\)\.y|$(OBJDIR)/\1<.tab.c><.tab.h><.output>|' ;)\" [$(configuracion)] >>>"
	@$(call existe_comando,$(YACC))
	@echo "** Version instalada de $(YACC): $$($(YACC) --version | sed -n 1p) **"
	$(YACC) -d -v $(YFLAGS) -o"$(shell echo "$<" | sed 's|$(SRCDIR)/\(.*\)\.y|$(OBJDIR)/\1.tab.c|' ;)" "$<"
	@echo "<<< Realizado >>>"

# Para LEX + CC (y sí hay YACC): Para generar el archivo objeto $(OBJDIR)/%.lex.yy.o desde $(OBJDIR)/%.lex.yy.c con $(OBJDIR)/%.tab.h y el resto de sus dependencias
$(ESC_OBJDIR)/%.lex.yy.o: $$(subst $$(espacio),\$$(espacio),$(SRCDIR)/%.l) $$(subst $$(espacio),\$$(espacio),$(SRCDIR)/%.y) $$(subst $$(espacio),\$$(espacio),$(OBJDIR)/%.tab.h) $$(subst $$(espacio),\$$(espacio),$(OBJDIR)/%.lex.yy.c) $$(subst ",,$$(subst "\ "," ",$$(subst $$(espacio),\$$(espacio),$(LDEPS)))) | $$(subst $$(espacio),\$$(espacio),$(OBJDIR))
	@echo ""
	@echo "<<< $(YACC)+$(LEX)->$(CC): Generando el archivo objeto: \"$@\" [$(configuracion)] >>>"
	@$(call existe_comando,$(CC))
	@echo "** Version instalada de $(CC): $$($(CC) --version | sed -n 1p) **"
	$(CC) $(CFLAGS) $(C_LOBJFLAGS) -c -o"$@" "$(shell echo "$@" | sed 's|$(OBJDIR)/\(.*\)\.lex\.yy\.o|$(OBJDIR)/\1.lex.yy.c|' ;)" $(LIDIRS)
	@echo "<<< Realizado >>>"

# Para LEX + CC (y no hay YACC): Para generar el archivo objeto $(OBJDIR)/%.lex.yy.o desde $(OBJDIR)/%.lex.yy.c con sus dependencias
$(ESC_OBJDIR)/%.lex.yy.o: $$(subst $$(espacio),\$$(espacio),$(SRCDIR)/%.l) $$(subst $$(espacio),\$$(espacio),$(OBJDIR)/%.lex.yy.c) $$(subst ",,$$(subst "\ "," ",$$(subst $$(espacio),\$$(espacio),$(LDEPS)))) | $$(subst $$(espacio),\$$(espacio),$(OBJDIR))
	@echo ""
	@echo "<<< $(LEX)->$(CC): Generando el archivo objeto: \"$@\" [$(configuracion)] >>>"
	@$(call existe_comando,$(CC))
	@echo "** Version instalada de $(CC): $$($(CC) --version | sed -n 1p) **"
	$(CC) $(CFLAGS) $(C_LOBJFLAGS) -c -o"$@" "$(shell echo "$@" | sed 's|$(OBJDIR)/\(.*\)\.lex\.yy\.o|$(OBJDIR)/\1.lex.yy.c|' ;)" $(LIDIRS)
	@echo "<<< Realizado >>>"}

# Para LEX: Para generar el archivo del analizador léxico (scanner) $(OBJDIR)/%.lex.yy.c desde $(SRCDIR)/%.l
$(ESC_OBJDIR)/%.lex.yy.c: $$(subst $$(espacio),\$$(espacio),$(SRCDIR)/%.l) | $$(subst $$(espacio),\$$(espacio),$(OBJDIR))
	@echo ""
	@echo "<<< $(LEX): Generando el archivo del analizador lexico (scanner): \"$@\" [$(configuracion)] >>>"
	@$(call existe_comando,$(LEX))
	@echo "** Version instalada de $(LEX): $$($(LEX) --version | sed -n 1p) **"
	$(LEX) $(LFLAGS) -o"$@" "$<"
	@echo "<<< Realizado >>>"