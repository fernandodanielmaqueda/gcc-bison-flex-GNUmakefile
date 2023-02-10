# Copyright (C) 2022-2023 Fernando Daniel Maqueda

# This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
# You should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/licenses/>.

# gcc-bison-flex-GNUmakefile: Este makefile sirve para construir, ejecutar y depurar proyectos en lenguaje C, proyectos en lenguaje C con flex (archivos *.l), proyectos en lenguaje C con bison (archivos *.y), y proyectos en lenguaje C con bison (archivos *.y) en conjunto con flex (archivos *.l) (así como proyectos que utilicen programas similares, como ser clang, yacc y lex)
# Requiere GNU Make desde su versión 3.81 en adelante
# Para ejecutarse necesita sh (Bourne Shell) para ser utilizado como la shell y estar el comando <command> integrado en la misma (en inglés: 'shell built-in command')
# También debe poder utilizar los siguientes comandos (disponibles en GNU coreutils (Core Utilities)): [ cat cp expr false ls mkdir mv printf pwd rm rmdir test touch tr true uname
# Así como estos otros comandos: grep sed
# Según sea el caso debe disponer de los siguientes programas (o compatibles) para realizar las acciones que se indican: gcc (necesario para la generación automática de dependencias de los archivos en lenguaje C, así como para compilar dichos archivos) ; bison (para generar analizadores sintácticos en lenguaje C) ; flex (para generar analizadores léxicos en lenguaje C) ; gdb (para depurar binarios) ; tmux (para abrir una nueva ventana (a menos que se detecte un sistema operativo Windows, en cuyo caso se usa el comando <start>))

# Nombre del proyecto
PROGRAM:=miproyecto

# Subdirectorio en el que están ubicados los archivos *.h, *.c, *.y, y *.l fuente (excepto los archivos intermedios generados por CC, YACC y LEX). Por ejemplo: src/
SRCDIR:=src/
# Subdirectorio en el que se ubicarán los archivos intermedios generados por CC, YACC y LEX. Por ejemplo: obj/
OBJDIR:=obj/
# Subdirectorio en el que se ubicará el binario construido. Por ejemplo: bin/
BINDIR:=bin/
# Subdirectorio en el que se ubicarán los otros makefiles (archivos *.d) producidos con las dependencias generadas automáticamente. Por ejemplo: .deps/
DEPDIR:=.deps/

# Compilador de C, generador de analizadores sintácticos (parsers) y generador de analizadores léxicos (scanners) a usar, respectivamente
CC:=gcc
YACC:=bison
LEX:=flex

# Depurador de C a usar y los flags a pasarle, respectivamente
CDB:=gdb
CDBFLAGS:=

# Agregar acá los flags de control de la etapa de preprocesamiento que se le quieran pasar siempre a CC
CPPFLAGS=-I"$(DOLLAR-SIGNS-ESCAPED_OBJDIR)" -I"$(DOLLAR-SIGNS-ESCAPED_SRCDIR)"
# Por ejemplo, aquí se ingresan los flags -I"Directorio" para CC, los cuales sirven para indicar los directorios en donde se encuentran los archivos de cabecera (header files) (*.h) DEFINIDOS POR EL USUARIO de los que dependen los archivos de C (*.c), YACC (*.y), y/o LEX (*.l): es decir, sólo aquellos que están entre comillas dobles (""), como ser: #include "misfunciones.h"; no los que están entre corchetes angulares (<>), como #include <math.h>)

# Agregar acá los flags -L (en LDFLAGS) y -l (en LDLIBS) para CC (los cuales este a su vez se los pasa al enlazador LD), los cuales sirven para enlazar con las bibliotecas necesarias (tanto estáticas (lib*.a) como dinámicas (lib*.so))
# Esto se usa cuando el compilador no encuentra algún archivo de cabecera (header file) (*.h) DEL SISTEMA: es decir, sólo aquellos que están entre corchetes angulares (<>), como #include <math.h>; no los que están entre comillas dobles (""), como ser: #include "misfunciones.h")
# Para eso poner -lNombreBiblioteca en LDLIBS (si el compilador ya puede encontrar por si solo el archivo libNombreBiblioteca.aÓ.so) y/o poner -L"ruta/relativa/desde/este/makefile/Ó/absoluta/hasta/un/directorio/que/contiene/archivos/libNombreBiblioteca.aÓ.so" en LDFLAGS y luego -lNombreBiblioteca en LDLIBS (para indicar la ubicación del archivo libNombreBiblioteca.aÓ.so manualmente).
LDFLAGS:=
LDLIBS:=-lm
# Por ejemplo, -lm para incluir la biblioteca libm.a la cual contiene <math.h>, <complex.h> y <fenv.h>; y -L"lib" -L"C:/Users/Mi Usuario/Documents/Ejemplo - Directorio_De_Mi_Proyecto (1)" para indicar, por ruta relativa (desde este makefile) y por ruta absoluta, respectivamente, dos directorios que contienen bibliotecas
# Más abajo se agregan -lfl y -ly para incluir las bibliotecas libfl.a y liby.a para LEX y YACC según sea necesario. Si el compilador no encontrara alguno de esos archivos, se los debe indicar manualmente agregándolos en LDFLAGS.

# Acá se configuran los warnings de CC, YACC y LEX según se encuentren habilitados o deshabilitados
# Por defecto los warnings están deshabilitados: en caso de que no se le defina un valor a WARNINGS a un comando de make al generar un archivo intermedio y/o al construir un binario, es como si se le agregara WARNINGS=0
# Si se quieren habilitar los warnings de CC, YACC y LEX, se deben tanto generar los archivos intermedios así como construir el binario estando los comandos de make con WARNINGS=1 agregado al hacerlo. Por ejemplo: <make WARNINGS=1>, <make all WARNINGS=1> y <make clean all WARNINGS=1>
WARNINGS?=0
ifneq ($(WARNINGS),0)
WARNINGS_ENABLED:=Si
# Agregar acá los flags que se le quieran pasar a CC cuando se habiliten los warnings (WARNINGS=1), como ser -Wall (para mostrar la mayoría de los tipos de warnings), -Wextra (para mostrar aún más tipos de warnings que -Wall), -Werror (para tratar a todos los warnings como errores), -Wfatal-errors (para que no siga con la compilación tras ocurrir algún error, en lugar de intentar continuar e imprimir más mensajes de error), -Wno-unused-function (para que NO muestre un warning cuando una función con static como especificador de clase de almacenamiento es declarada pero no definida o que no es utilizada), -Wno-unused-but-set-variable (para que NO muestre un warning cuando una variable local es inicializada pero no es utilizada), -Wno-unused-variable (para que NO muestre un warning cuando una variable local o con static como especificador de clase de almacenamiento es declarada no es utilizada), etc.
CFLAGS:=-Wall
# Agregar acá los flags que se le quieran pasar a YACC cuando se habiliten los warnings (WARNINGS=1), como ser -Wall (para mostrar todos los warnings), -Werror (para tratar a los warnings como errores), etc.
YFLAGS:=-Wall
# Agregar acá los flags que se le quieran pasar a LEX cuando se habiliten los warnings (WARNINGS=1)
LFLAGS:=
else
WARNINGS_ENABLED:=No
# Agregar acá los flags que se le quieran pasar a CC cuando se deshabiliten los warnings (WARNINGS=0), como ser -w (para no mostrar ningún warning)
CFLAGS:=
# Agregar acá los flags que se le quieran pasar a YACC cuando se deshabiliten los warnings (WARNINGS=0), como ser -Wnone (para no mostrar ningún warning)
YFLAGS:=
# Agregar acá los flags que se le quieran pasar a LEX cuando se deshabiliten los warnings (WARNINGS=0), como ser -w (para suprimir todos los mensajes de warning)
LFLAGS:=
endif

# Acá se configura el debug de CC, YACC y LEX según se encuentre habilitado o deshabilitado
# Por defecto el debug está deshabilitado: en caso de que no se le defina un valor a DEBUG al comando de make, es como si se le agregara DEBUG=0
# Si se quiere habilitar el debug de CC, YACC y LEX, se debe agregar DEBUG=1 al comando de make. Por ejemplo: <make DEBUG=1>, <make all DEBUG=1> y <make clean all DEBUG=1>
DEBUG?=0
ifneq ($(DEBUG),0)
DEBUG_ENABLED:=Si
# Agregar acá los flags que se le quieran pasar a CC cuando se habilite el modo debug (DEBUG=1), como ser -g (produce información de depuración en el formato nativo del sistema operativo (stabs, COFF, XCOFF, o DWARF) para que pueda depurarse)
CFLAGS+=-g
# Agregar acá los flags que se le quieran pasar a YACC cuando se habilite el modo debug (DEBUG=1), como ser -t (define la macro YYDEBUG a 1 si no se la define)
YFLAGS+=-t
# Agregar acá los flags que se le quieran pasar a LEX cuando se habilite el modo debug (DEBUG=1), como ser -d (hace que el analizador generado se ejecute en modo de depuración)
LFLAGS+=-d
# Cuando se habilite el debug (DEBUG=1), y sólo cuando CC vaya a generar el archivo objeto desde el archivo de C generado por YACC (de *.tab.c a *.tab.o) se le pasará este flag -D para que defina la macro YYDEBUG en un valor entero distinto de 0 lo cual permite la depuracion de YACC
C_YOBJFLAGS:=-DYYDEBUG=1
else
DEBUG_ENABLED:=No
# Cuando se deshabilite el debug (DEBUG=0), y sólo cuando CC vaya a generar el archivo objeto desde el archivo de C generado por YACC (de *.tab.c a *.tab.o) se le pasará este flag -D para que defina la macro YYDEBUG en el valor entero 0 lo cual NO permite la depuracion de YACC
C_YOBJFLAGS:=-DYYDEBUG=0
endif

# Agregar acá otros flags que se le quieran pasar siempre a CC, YACC y LEX además de los flags que ya están, según corresponda
CFLAGS+=
# Para YACC, por ejemplo, --report=state (para que se incluya en el archivo *.output generado una descripción de la gramática, conflictos tanto resueltos como sin resolver, y el autómata LALR), --report=lookahead (para incrementar la descripción del autómata con cada conjunto de tokens siguientes de cada regla sobre el archivo *.output generado), --report=itemset (para que se incluya en el archivo *.output generado una descripción de la gramática, conflictos tanto resueltos como sin resolver, y el autómata LALR), --report=lookahead (para incrementar la descripción del autómata con el conjunto completo de ítems derivados para cada estado, en lugar de solamente el denominado núcleo sobre el archivo *.output generado), etc.
YFLAGS+=--report=state --report=lookahead --report=itemset
LFLAGS+=

# Agregar acá otros flags que se le quieran pasar siempre a CC sólo al generar los archivos objeto desde los de C fuentes (de *.c a *.o), desde los archivos de C generados por YACC (de *.tab.c a *.tab.o) y desde los archivos de C generados por LEX (de *.lex.yy.c a *.lex.yy.o) además de los flags que ya están, según corresponda
C_COBJFLAGS+=
C_YOBJFLAGS+=
C_LOBJFLAGS+=

# Define una variable que contiene un solo espacio para luego utilizarla para sustituir con secuencias de escape cada uno de los espacios
espacio:=$(subst ",," ")

# Define una variable que contiene un símbolo numeral para poder ser utilizado adentro de referencias macro y/o invocaciones de funciones de make
numeral:=\#

# Para realizar las secuencias de escape para los espacios del valor pasado como parámetro
define escapar_espacios
$(subst $(espacio),\$(espacio),$(1))
endef

# Para realizar las secuencias de escape para los espacios y seguidamente quitar las comillas dobles del valor pasado como parámetro
define sin_necesidad_de_comillas_dobles
$(subst ",,$(subst "\ "," ",$(call escapar_espacios,$(1))))
endef

# Para realizar las secuencias de escape para los signos de pesos conforme a la shell (cada $ es reemplazado por \$) del valor pasado como parámetro
define escapar_simbolo_pesos_conforme_a_shell
$(subst $$,\$$,$(1))
endef

# Para realizar las secuencias de escape para las comillas simples cuando se encuentran dentro de otras comillas simples (cada ' es reemplazada por '\'' aunque también podría ser reemplazada por '"'"') del valor pasado como parámetro
define escapar_comillas_simples_dentro_de_otras_comillas_simples
$(subst ','\'',$(1))
endef

# Para realizar las secuencias de escape para los símbolos de porcentaje conforme a make (cada % es reemplazado por \%) del valor pasado como parámetro
define escapar_simbolos_de_porcentaje_conforme_a_make
$(subst %,\%,$(1))
endef

# Para determinar que sh sea el programa utilizado como la shell
SHELL:=/bin/sh

# Comprueba que se haya encontrado una shell sh en el sistema
ifeq ($(wildcard $(call escapar_espacios,$(SHELL))),)
$(error ERROR: no hay una shell sh instalada y/o no se ha podido encontrar y ejecutar)
endif

# Comprueba que el comando <command> se encuentre integrado en la shell (en inglés: 'shell built-in command')
ifeq ($(shell command -v cd ;),)
$(error ERROR: El comando <command>, necesario para que pueda funcionar este makefile, no se encuentra integrado en la shell)
endif

# Comprueba que se puedan encontrar todos los comandos necesarios que se presentan en GNU coreutils (Core Utilities)
define make_comprobar_comando_coreutils
$(if $(shell command -v $(1) ;),,$(error ERROR: El comando <$(1)>, necesario para que pueda funcionar este makefile y que se presenta en GNU coreutils, no esta instalado y/o no se puede encontrar y ejecutar))
endef
$(foreach comando,[ cat cp expr false ls mkdir mv printf pwd rm rmdir test touch tr true uname,$(eval $(call make_comprobar_comando_coreutils,$(comando))))

# Comprueba que se puedan encontrar el resto de los comandos necesarios
define make_comprobar_otro_comando
$(if $(shell command -v $(1) ;),,$(error ERROR: El comando <$(1)>, necesario para que pueda funcionar este makefile, no esta instalado y/o no se puede encontrar y ejecutar))
endef
$(foreach comando,grep sed,$(eval $(call make_comprobar_otro_comando,$(comando))))

# Detecta si el sistema operativo es Windows o no, sabiendo que si lo es, Windows define una variable de entorno (Windows Environment Variable) con nombre 'OS' hoy en día típicamente con valor 'Windows_NT'
ifeq ($(OS),Windows_NT)
SO:=Windows_NT
# En caso de que el sistema operativo es Windows, se detecta si la aplicación y la arquitectura del procesador son de 32 o de 64 bits (sabiendo que Windows define una variable de entorno (Windows Environment Variable) con nombre 'PROCESSOR_ARCHITECTURE' típicamente con valor 'AMD64' tanto para aplicación como procesador de 64 bits, y sino usualmente con valor 'x86' para aplicación de 32 bits, en cuyo caso Windows también define define una variable de entorno (Windows Environment Variable) con nombre 'PROCESSOR_ARCHITEW6432' típicamente con valor 'AMD64' para procesador de 64 bits, y sino usualmente con valor 'x86' para procesador de 32 bits
ifeq ($(PROCESSOR_ARCHITECTURE),AMD64)
BITS_APPLICATION:=64
BITS_PROCESSOR:=64
else
BITS_APPLICATION:=32
ifeq ($(PROCESSOR_ARCHITEW6432),AMD64)
BITS_PROCESSOR:=64
else
BITS_PROCESSOR:=32
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

# Así se puede detectar el sistema (o kernel) en ejecución; particularmente se consulta si se está utilizando Cygwin o no
UNAME_S:=$(shell uname)
SYSTEM:=$(patsubst CYGWIN_NT%,CYGWIN_NT,$(UNAME_S))

# Configuraciones de acuerdo con el sistema operativo
ifeq ($(SO),Windows_NT)
# Para Windows, se genera un ejecutable *.exe
EXEEXT:=.exe
# También para Windows, si el procesador es de 64 bits y no se está usando Cygwin, se le agrega la bandera -m32 a CC para forzar a que éste construya binarios de 32 bits por más que el procesador sea de 64 bits
ifeq ($(BITS_PROCESSOR),64)
ifneq ($(SYSTEM),CYGWIN_NT)
CFLAGS+=-m32
endif
endif
else
# En cualquier otro sistema operativo (GNU/Linux, MacOS, etc.) se genera un archivo *.out
EXEEXT:=.out
endif

# Define nuevas variables pero con secuencias de escape para los signos de pesos conforme a la shell para que sus valores puedan sean utilizados dentro de comillas dobles
$(foreach variable,PROGRAM SRCDIR OBJDIR BINDIR DEPDIR,$(eval DOLLAR-SIGNS-ESCAPED_$(variable):=$$(call escapar_simbolo_pesos_conforme_a_shell,$$($$(variable)))))

# Define nuevas variables pero con secuencias de escape para las comillas simples para que sus valores puedan sean utilizados dentro de otras comillas simples
$(foreach variable,OBJDIR DEPDIR,$(eval SINGLE-QUOTES-ESCAPED_$(variable):=$$(call escapar_comillas_simples_dentro_de_otras_comillas_simples,$$($$(variable)))))

# Define nuevas variables pero con secuencias de escape para los espacios y con secuencias de escape para los símbolos de porcentaje conforme a make para que sus valores puedan sean utilizados directamente en los objetivos de determinadas reglas de make
$(foreach variable,OBJDIR DEPDIR,$(eval PERCENT-SIGNS-AND-SPACES-ESCAPED_$(variable):=$$(call escapar_espacios,$$(call escapar_simbolos_de_porcentaje_conforme_a_make,$$($$(variable))))))

# Define nuevas variables pero sin sus barras traseras y con secuencias de escape para los espacios para que sus valores puedan sean utilizados directamente en los prerequisitos de sólo orden de determinadas reglas de make
$(foreach variable,OBJDIR BINDIR DEPDIR,$(eval TRAILING-SLASH-REMOVED-AND-SPACES-ESCAPED_$(variable):=$$(call escapar_espacios,$$(shell printf "%s" "$$(DOLLAR-SIGNS-ESCAPED_$$(variable))" | sed 's?/$$$$??' ;))))

# Produce los nombres de todos los archivos objeto a generar de acuerdo con los archivos fuente de C ($(SRCDIR)*.c), YACC ($(SRCDIR)*.y) y LEX ($(SRCDIR)*.l) que se encuentren, respectivamente
COBJS:=$(shell ls "$(DOLLAR-SIGNS-ESCAPED_SRCDIR)"*.c 2>/dev/null | sed -e 's?.*/??' -e 's?\(.*\)\.c?"$(SINGLE-QUOTES-ESCAPED_OBJDIR)\1.o"?' ;)
YOBJS:=$(shell ls "$(DOLLAR-SIGNS-ESCAPED_SRCDIR)"*.y 2>/dev/null | sed -e 's?.*/??' -e 's?\(.*\)\.y?"$(SINGLE-QUOTES-ESCAPED_OBJDIR)\1.tab.o"?' ;)
LOBJS:=$(shell ls "$(DOLLAR-SIGNS-ESCAPED_SRCDIR)"*.l 2>/dev/null | sed -e 's?.*/??' -e 's?\(.*\)\.l?"$(SINGLE-QUOTES-ESCAPED_OBJDIR)\1.lex.yy.o"?' ;)

# Determina si sólo se han encontrado archivos fuente de C ($(SRCDIR)*.c) o no
ifneq ($(YOBJS)$(LOBJS),)
ifneq ($(YOBJS),)
# Agrega el flag -ly para CC (y este a su vez se lo pasa al enlazador LD) para que incluya la biblioteca liby.a para YACC, ya que es necesaria. Si el enlazador no pudiera encontrar ese archivo, se lo debe indicar manualmente agregándolo en LDFLAGS.
LDLIBS+=-ly
endif
ifneq ($(LOBJS),)
# Agrega el flag -lfl para CC (y este a su vez se lo pasa al enlazador LD) para que incluya la biblioteca libfl.a para LEX, ya que es necesaria. Si el enlazador no pudiera encontrar ese archivo, se lo debe indicar manualmente agregándolo en LDFLAGS.
LDLIBS+=-lfl
endif
else
ifneq ($(COBJS),)
else
# Alerta si no ha encontrado ningún archivo fuente de C ($(SRCDIR)*.c), YACC ($(SRCDIR)*.y) ni de LEX ($(SRCDIR)*.l)
$(error ERROR: no se ha encontrado ningun archivo de $(CC) (*.c), $(YACC) (*.y) ni $(LEX) (*.l) en el directorio de archivos fuente definido en la variable SRCDIR del makefile: "$(SRCDIR)")
endif
endif

# Define una secuencia de comandos enlatada para comprobar si se pueden encontrar los comandos que se van a ejecutar
define sh_existe_comando
	if ! command -v $(1) >/dev/null; then printf "ERROR: El comando <$(1)> no esta instalado y/o no se puede encontrar y ejecutar\n" ; exit 1 ; fi
endef

# Define una secuencia de comandos enlatada para mostrar la ruta hacia el comando
ifeq ($(PATHNAME_COMMAND),where)
define sh_ruta_comando
	printf "** Ruta hacia $(1): %s **\n" "$$(where $(1) | sed -n 1p | sed 's?\\\?\\\\?g')"
endef
else
define sh_ruta_comando
	printf "** Ruta hacia $(1): %s **\n" "$$(command -v $(1))"
endef
endif

# Define una secuencia de comandos enlatada para producir el otro makefile $(DEPDIR)%.d a incluir con prerequisitos generados automáticamente desde $(SRCDIR)%.c
define receta_para_.d
	@printf "\n<<< $(CC): Produciendo el otro makefile a incluir con prerequisitos generados automaticamente: \"%s\" >>>\n" "$(1).d" 
	@$(call sh_existe_comando,$(CC))
	@$(call sh_ruta_comando,$(CC))
	@printf "** Version instalada de $(CC): %s **\n" "$$($(CC) --version | sed -n 1p 2>/dev/null)"
	printf "empty:\n\n%s" "$(call escapar_espacios,$(call escapar_espacios,$(1).d)) $(call escapar_espacios,$(call escapar_espacios,$(call escapar_simbolo_pesos_conforme_a_shell,$(OBJDIR))))" > "$(1).tmp"
	$(CC) $(CPPFLAGS) -MM "$(call escapar_simbolo_pesos_conforme_a_shell,$<)" >> "$(1).tmp" || { rm -f "$(1).tmp" ; false ; }
	sed -e ':a' -e '3s?^\([^:]*\)\(^\|[^\\]\)%?\1\2\\\%?' -e 't a' -e 's?\(^\|[^$$]\)\$$\($$\|[^$$]\)?\1$$$$\2?g' -e 's?\(^\|[^\\]\)#?\1\\\#?g' < "$(1).tmp" > "$(1).d"
	rm -f "$(1).tmp"
	@printf "<<< Realizado >>>\n"
endef

# Define una secuencia de comandos enlatada la cual fuerza la eliminación de un binario si este ya existiera, por si el archivo está en uso, ya que esto impediría su construcción
define forzar_eliminacion_si_ya_existiera_el_binario
	if [ -f "$(1)" ]; then \
		printf "\n<<< Eliminando el binario ya existente: \"%s\" >>>\n" "$(1)" ; \
		set -x ; \
			rm -f "$(1)" ; \
		{ set +x ; } 2>/dev/null ; \
		printf "<<< Realizado >>>\n" ; \
	fi ;
endef

# Define una secuencia de comandos enlatada que muestra una nota si el debug está habilitado
define mostrar_nota_sobre_yacc_si_la_depuracion_esta_habilitada
	if [ -n '$(call escapar_comillas_simples_dentro_de_otras_comillas_simples,$(YOBJS))' ] && [ "X0" != "X$(DEBUG)" ]; then \
		printf "\nNOTA: Se ha definido la macro YYDEBUG en un valor entero distinto de 0 para permitir la depuracion de $(YACC)\n" ; \
		printf "  Para depurar $(YACC), tambien debe asignarle un valor entero distinto de 0 a la variable de tipo int yydebug\n" ; \
		printf "  Una manera de lograr eso es agregarle el siguiente codigo al main() antes de que se llame a yyparse():\n" ; \
		printf "    #if YYDEBUG\n" ; \
		printf "      yydebug = 1;\n" ; \
		printf "    #endif\n" ; \
	fi ;
endef

# Define una secuencia de comandos enlatada que muestra una nota en las ventanas de las sesiones abiertas de tmux (Terminal MUltipleXer)
define nota_tmux
	printf \"NOTA: Esta es una ventana de una sesion abierta de tmux (Terminal MUltipleXer)\n\" ; \
	printf \"  * Para cerrar la ventana de la sesion, presione <CTRL+b>, seguidamente presione <x> y por ultimo presione <y>\n\" ; \
	printf \"  * Para apartar la sesion con sus ventanas sin cerrarla [detach], presione <CTRL+b> y seguidamente presione <d>\n\" ; \
	printf \"  * Para alternar entre las sesiones abiertas de tmux, presione <CTRL+b> y seguidamente presione <s>\n\" ; \
	printf \"  * Para alternar entre las ventanas de las sesiones abiertas de tmux, presione <CTRL+b> y seguidamente presione <w>\n\" ; \
	printf \"  * Para iniciar el modo desplazamiento por la ventana, presione <CTRL+b> y seguidamente presione <[> . Para finalizarlo, presione <q>\n\" ;
endef

# Para eliminar la lista de sufijos conocidos que make genera por defecto
.SUFFIXES:
# Esto se efectúa para cancelar las reglas implícitas predefinidas por make, ya que ninguna de ellas se utilizará y además con esto se ahorra en tiempo de ejecución

# Para especificar los objetivos que no generan archivos con ese mismo nombre para que se ejecuten siempre por más de que los archivos puedan llegar a existir
.PHONY: all run open clean cdebug-run cdebug-open empty
# La receta de una regla siempre se ejecutará si tiene como prerequisito de tipo normal a un target que sea .PHONY

# Para que make elimine el objetivo de una regla si ya se ha modificado y su receta finaliza con un estado de salida con valor no cero
.DELETE_ON_ERROR:

# Acá se configura el 'make all' según la regeneración de los archivos secundarios al ser eliminados se encuentre habilitada o deshabilitada
# Por defecto la regeneración de los archivos secundarios está habilitada
REGENERATE_SECONDARY:=1
ifneq ($(REGENERATE_SECONDARY),0)
# Para construir todos los archivos intermedios y el binario ya sea con sus SRCDIR*.l y/o SRCDIR*.y como fuentes, o ya sea con sus SRCDIR*.c como fuentes. Se ejecuta con <make> (por ser la meta por defecto) o <make all>
all: $(call sin_necesidad_de_comillas_dobles,$(COBJS)) $(call sin_necesidad_de_comillas_dobles,$(shell printf "%s" '$(call escapar_comillas_simples_dentro_de_otras_comillas_simples,$(YOBJS))' | sed 's?"\([^"]*\)\.tab\.o"?"\1.tab.c" "\1.tab.h" "\1.output" "\1.tab.o"?g' ;)) $(call sin_necesidad_de_comillas_dobles,$(shell printf "%s" '$(call escapar_comillas_simples_dentro_de_otras_comillas_simples,$(LOBJS))' | sed 's?"\([^"]*\)\.lex\.yy\.o"?"\1.lex.yy.c" "\1.lex.yy.o"?g' ;)) $(call escapar_espacios,$(BINDIR)$(PROGRAM)$(EXEEXT))
else
# Para construir el binario ya sea con sus SRCDIR*.l y/o SRCDIR*.y como fuentes, o ya sea con sus SRCDIR*.c como fuentes. Se ejecuta con <make> (por ser la meta por defecto) o <make all>
all: $(call escapar_espacios,$(BINDIR)$(PROGRAM)$(EXEEXT))
# Define explícitamente determinados objetivos como archivos secundarios; estos son tratados como archivos intermedios (aquellos que son creados por regla prerequisito de otra regla), excepto que nunca son eliminados automáticamente al terminar
.SECONDARY: $(call sin_necesidad_de_comillas_dobles,$(COBJS)) $(call sin_necesidad_de_comillas_dobles,$(shell printf "%s" '$(call escapar_comillas_simples_dentro_de_otras_comillas_simples,$(YOBJS))' | sed 's?"\([^"]*\)\.tab\.o"?"\1.tab.c" "\1.output" "\1.tab.o"?g' ;)) $(call sin_necesidad_de_comillas_dobles,$(shell printf "%s" '$(call escapar_comillas_simples_dentro_de_otras_comillas_simples,$(LOBJS))' | sed 's?"\([^"]*\)\.lex\.yy\.o"?"\1.lex.yy.c" "\1.lex.yy.o"?g' ;))
endif

# Regla explícita que tiene como objetivo este mismo makefile para evitar que make intente rehacerlo, ya que no es necesario hacerlo, esto con el propósito de optimizar el tiempo de inicialización
GNUmakefile:: ;

# Regla explícita para ejecutar el binario que se construye desde la misma ventana
run:
	@printf "\n=================[ Ejecutar en esta ventana el binario: \"%s\" ]=================\n" "$(DOLLAR-SIGNS-ESCAPED_BINDIR)$(DOLLAR-SIGNS-ESCAPED_PROGRAM)$(EXEEXT)"
	@printf "\n<<< Ejecutando en esta ventana el binario: \"%s\" >>>\n" "$(DOLLAR-SIGNS-ESCAPED_BINDIR)$(DOLLAR-SIGNS-ESCAPED_PROGRAM)$(EXEEXT)"
	@if [ -f "$(DOLLAR-SIGNS-ESCAPED_BINDIR)$(DOLLAR-SIGNS-ESCAPED_PROGRAM)$(EXEEXT)" ]; then \
		set -x ; \
			cd "$(DOLLAR-SIGNS-ESCAPED_BINDIR)" ; \
			"./$(DOLLAR-SIGNS-ESCAPED_PROGRAM)$(EXEEXT)" ; \
			cd - >/dev/null ; \
		{ set +x ; } 2>/dev/null ; \
	else \
		printf "(No existe el binario \"%s\")\n" "$(DOLLAR-SIGNS-ESCAPED_BINDIR)$(DOLLAR-SIGNS-ESCAPED_PROGRAM)$(EXEEXT)" ; \
	fi ;
	@printf "<<< Realizado >>>\n"
	@printf "\n=================[ Finalizado ]=============\n"

# Regla explícita para abrir el binario que se construye en una ventana nueva
open:
	@printf "\n=================[ Ejecutar en una ventana nueva el binario: \"%s\" ]=================\n" "$(DOLLAR-SIGNS-ESCAPED_BINDIR)$(DOLLAR-SIGNS-ESCAPED_PROGRAM)$(EXEEXT)"
	@printf "\n<<< Ejecutando en una ventana nueva el binario: \"%s\" >>>\n" "$(DOLLAR-SIGNS-ESCAPED_BINDIR)$(DOLLAR-SIGNS-ESCAPED_PROGRAM)$(EXEEXT)"
	@if [ -f "$(DOLLAR-SIGNS-ESCAPED_BINDIR)$(DOLLAR-SIGNS-ESCAPED_PROGRAM)$(EXEEXT)" ]; then \
		case "$(OPEN_COMMAND)" in \
			("start") \
				set -x ; \
					cd "$(DOLLAR-SIGNS-ESCAPED_BINDIR)" ; \
					start "$(call escapar_simbolo_pesos_conforme_a_shell,$(subst /,\\,$(CURDIR)/$(BINDIR)))$(DOLLAR-SIGNS-ESCAPED_PROGRAM)$(EXEEXT) " "$(DOLLAR-SIGNS-ESCAPED_PROGRAM)$(EXEEXT)" ; \
					cd - >/dev/null ; \
				{ set +x ; } 2>/dev/null ;; \
			(*) \
				$(call sh_existe_comando,tmux) ; \
				$(call sh_ruta_comando,tmux) ; \
				printf "** Version instalada de tmux: %s **\n" "$$(tmux -V | sed -n 1p 2>/dev/null)" ; \
				set -x ; \
					cd "$(DOLLAR-SIGNS-ESCAPED_BINDIR)" ; \
					tmux new "$(nota_tmux) set -x ; \"./$(call escapar_simbolo_pesos_conforme_a_shell,$(call escapar_simbolo_pesos_conforme_a_shell,$(DOLLAR-SIGNS-ESCAPED_PROGRAM)$(EXEEXT)))\"" ; \
					cd - >/dev/null ; \
				{ set +x ; } 2>/dev/null ; \
				printf "NOTA: Para volver a las sesiones apartadas de tmux [detached], ejecute el comando <tmux attach>\n" ;; \
		esac ; \
	else \
		printf "(No existe el binario \"%s\")\n" "$(DOLLAR-SIGNS-ESCAPED_BINDIR)$(DOLLAR-SIGNS-ESCAPED_PROGRAM)$(EXEEXT)" ; \
	fi ;
	@printf "<<< Realizado >>>\n"
	@printf "\n=================[ Finalizado ]=============\n"

# Regla explícita para borrar todos los archivos intermedios y el binario generados al construir
clean:
	@printf "\n=================[ Eliminar todo lo que se genera al construir ]=================\n"
	@if [ -d "$(DOLLAR-SIGNS-ESCAPED_BINDIR)" ]; then \
		if [ -f "$(DOLLAR-SIGNS-ESCAPED_BINDIR)$(DOLLAR-SIGNS-ESCAPED_PROGRAM)$(EXEEXT)" ]; then \
			printf "\n<<< Eliminando el binario: \"%s\" >>>\n" "$(DOLLAR-SIGNS-ESCAPED_BINDIR)$(DOLLAR-SIGNS-ESCAPED_PROGRAM)$(EXEEXT)" ; \
			set -x ; \
				rm -f "$(DOLLAR-SIGNS-ESCAPED_BINDIR)$(DOLLAR-SIGNS-ESCAPED_PROGRAM)$(EXEEXT)" ; \
			{ set +x ; } 2>/dev/null ; \
			printf "<<< Realizado >>>\n" ; \
		fi ; \
		printf "\n<<< Eliminando el directorio \"%s\" si esta vacio y no esta en uso >>>\n" "$(DOLLAR-SIGNS-ESCAPED_BINDIR)" ; \
		set -x ; \
			rmdir "$(DOLLAR-SIGNS-ESCAPED_BINDIR)" 2>/dev/null || true ; \
		{ set +x ; } 2>/dev/null ; \
		printf "<<< Realizado >>>\n" ; \
	fi ;
	@if [ -d "$(DOLLAR-SIGNS-ESCAPED_OBJDIR)" ]; then \
		if [ -n '$(call escapar_comillas_simples_dentro_de_otras_comillas_simples,$(LOBJS))' ]; then \
			for BASENAME in $(call escapar_simbolo_pesos_conforme_a_shell,$(shell printf "%s" '$(call escapar_comillas_simples_dentro_de_otras_comillas_simples,$(LOBJS))' | sed -e 's?"[^"]*/?"?g' -e 's?"\([^"]*\)\.lex\.yy\.o"?"\1"?g' ;)) ; do \
				for EXT in .lex.yy.o .lex.yy.c ; do \
					if [ -f "$(DOLLAR-SIGNS-ESCAPED_OBJDIR)$$BASENAME$$EXT" ]; then \
						printf "\n<<< Eliminando el archivo intermedio: \"%s\" >>>\n" "$(DOLLAR-SIGNS-ESCAPED_OBJDIR)$$BASENAME$$EXT" ; \
						set -x ; \
							rm -f "$(DOLLAR-SIGNS-ESCAPED_OBJDIR)$$BASENAME$$EXT" ; \
						{ set +x ; } 2>/dev/null ; \
						printf "<<< Realizado >>>\n" ; \
					fi ; \
				done ; \
			done ; \
		fi ; \
		if [ -n '$(call escapar_comillas_simples_dentro_de_otras_comillas_simples,$(YOBJS))' ]; then \
			for BASENAME in $(call escapar_simbolo_pesos_conforme_a_shell,$(shell printf "%s" '$(call escapar_comillas_simples_dentro_de_otras_comillas_simples,$(YOBJS))' | sed -e 's?"[^"]*/?"?g' -e 's?"\([^"]*\)\.tab\.o"?"\1"?g' ;)) ; do \
				for EXT in .tab.o .output .tab.h .tab.c ; do \
					if [ -f "$(DOLLAR-SIGNS-ESCAPED_OBJDIR)$$BASENAME$$EXT" ]; then \
						printf "\n<<< Eliminando el archivo intermedio: \"%s\" >>>\n" "$(DOLLAR-SIGNS-ESCAPED_OBJDIR)$$BASENAME$$EXT" ; \
						set -x ; \
							rm -f "$(DOLLAR-SIGNS-ESCAPED_OBJDIR)$$BASENAME$$EXT" ; \
						{ set +x ; } 2>/dev/null ; \
						printf "<<< Realizado >>>\n" ; \
					fi ; \
				done ; \
			done ; \
		fi ; \
		if [ -n '$(call escapar_comillas_simples_dentro_de_otras_comillas_simples,$(COBJS))' ]; then \
			for COBJ in $(call escapar_simbolo_pesos_conforme_a_shell,$(COBJS)) ; do \
				if [ -f "$$COBJ" ]; then \
					printf "\n<<< Eliminando el archivo intermedio: \"%s\" >>>\n" "$$COBJ" ; \
					set -x ; \
						rm -f "$$COBJ" ; \
					{ set +x ; } 2>/dev/null ; \
					printf "<<< Realizado >>>\n" ; \
				fi ; \
			done ; \
		fi ; \
		printf "\n<<< Eliminando el directorio \"%s\" si esta vacio y no esta en uso >>>\n" "$(DOLLAR-SIGNS-ESCAPED_OBJDIR)" ; \
		set -x ; \
			rmdir "$(DOLLAR-SIGNS-ESCAPED_OBJDIR)" 2>/dev/null || true ; \
		{ set +x ; } 2>/dev/null ; \
		printf "<<< Realizado >>>\n" ; \
	fi ;
	@if [ -d "$(DOLLAR-SIGNS-ESCAPED_DEPDIR)" ]; then \
		if [ -n '$(call escapar_comillas_simples_dentro_de_otras_comillas_simples,$(LOBJS))' ]; then \
			for BASENAME in $(call escapar_simbolo_pesos_conforme_a_shell,$(shell printf "%s" '$(call escapar_comillas_simples_dentro_de_otras_comillas_simples,$(LOBJS))' | sed -e 's?"[^"]*/?"?g' -e 's?"\([^"]*\)\.lex\.yy\.o"?"\1"?g' ;)) ; do \
				if [ -f "$(DOLLAR-SIGNS-ESCAPED_DEPDIR)$$BASENAME.lex.yy.d" ]; then \
					printf "\n<<< Eliminando el otro makefile con prerequisitos generados automaticamente: \"%s\" >>>\n" "$(DOLLAR-SIGNS-ESCAPED_DEPDIR)$$BASENAME.lex.yy.d" ; \
					set -x ; \
						rm -f "$(DOLLAR-SIGNS-ESCAPED_DEPDIR)$$BASENAME.lex.yy.d" ; \
					{ set +x ; } 2>/dev/null ; \
					printf "<<< Realizado >>>\n" ; \
				fi ; \
				if [ -f "$(DOLLAR-SIGNS-ESCAPED_DEPDIR)$$BASENAME.lex.yy.tmp" ]; then \
					printf "\n<<< Eliminando el archivo temporal: \"%s\" >>>\n" "$(DOLLAR-SIGNS-ESCAPED_DEPDIR)$$BASENAME.lex.yy.tmp" ; \
					set -x ; \
						rm -f "$(DOLLAR-SIGNS-ESCAPED_DEPDIR)$$BASENAME.lex.yy.tmp" ; \
					{ set +x ; } 2>/dev/null ; \
					printf "<<< Realizado >>>\n" ; \
				fi ; \
			done ; \
		fi ; \
		if [ -n '$(call escapar_comillas_simples_dentro_de_otras_comillas_simples,$(YOBJS))' ]; then \
			for BASENAME in $(call escapar_simbolo_pesos_conforme_a_shell,$(shell printf "%s" '$(call escapar_comillas_simples_dentro_de_otras_comillas_simples,$(YOBJS))' | sed -e 's?"[^"]*/?"?g' -e 's?"\([^"]*\)\.tab\.o"?"\1"?g' ;)) ; do \
				if [ -f "$(DOLLAR-SIGNS-ESCAPED_DEPDIR)$$BASENAME.tab.d" ]; then \
					printf "\n<<< Eliminando el otro makefile con prerequisitos generados automaticamente: \"%s\" >>>\n" "$(DOLLAR-SIGNS-ESCAPED_DEPDIR)$$BASENAME.tab.d" ; \
					set -x ; \
						rm -f "$(DOLLAR-SIGNS-ESCAPED_DEPDIR)$$BASENAME.tab.d" ; \
					{ set +x ; } 2>/dev/null ; \
					printf "<<< Realizado >>>\n" ; \
				fi ; \
				if [ -f "$(DOLLAR-SIGNS-ESCAPED_DEPDIR)$$BASENAME.tab.tmp" ]; then \
					printf "\n<<< Eliminando el archivo temporal: \"%s\" >>>\n" "$(DOLLAR-SIGNS-ESCAPED_DEPDIR)$$BASENAME.tab.tmp" ; \
					set -x ; \
						rm -f "$(DOLLAR-SIGNS-ESCAPED_DEPDIR)$$BASENAME.tab.tmp" ; \
					{ set +x ; } 2>/dev/null ; \
					printf "<<< Realizado >>>\n" ; \
				fi ; \
			done ; \
		fi ; \
		if [ -n '$(call escapar_comillas_simples_dentro_de_otras_comillas_simples,$(COBJS))' ]; then \
			for BASENAME in $(call escapar_simbolo_pesos_conforme_a_shell,$(shell printf "%s" '$(call escapar_comillas_simples_dentro_de_otras_comillas_simples,$(COBJS))' | sed -e 's?"[^"]*/?"?g' -e 's?"\([^"]*\)\.o"?"\1"?g' ;)) ; do \
				if [ -f "$(DOLLAR-SIGNS-ESCAPED_DEPDIR)$$BASENAME.d" ]; then \
					printf "\n<<< Eliminando el otro makefile con prerequisitos generados automaticamente: \"%s\" >>>\n" "$(DOLLAR-SIGNS-ESCAPED_DEPDIR)$$BASENAME.d" ; \
					set -x ; \
						rm -f "$(DOLLAR-SIGNS-ESCAPED_DEPDIR)$$BASENAME.d" ; \
					{ set +x ; } 2>/dev/null ; \
					printf "<<< Realizado >>>\n" ; \
				fi ; \
				if [ -f "$(DOLLAR-SIGNS-ESCAPED_DEPDIR)$$BASENAME.tmp" ]; then \
					printf "\n<<< Eliminando el archivo temporal: \"%s\" >>>\n" "$(DOLLAR-SIGNS-ESCAPED_DEPDIR)$$BASENAME.tmp" ; \
					set -x ; \
						rm -f "$(DOLLAR-SIGNS-ESCAPED_DEPDIR)$$BASENAME.tmp" ; \
					{ set +x ; } 2>/dev/null ; \
					printf "<<< Realizado >>>\n" ; \
				fi ; \
			done ; \
		fi ; \
		printf "\n<<< Eliminando el directorio \"%s\" si esta vacio y no esta en uso >>>\n" "$(DOLLAR-SIGNS-ESCAPED_DEPDIR)" ; \
		set -x ; \
			rmdir "$(DOLLAR-SIGNS-ESCAPED_DEPDIR)" 2>/dev/null || true ; \
		{ set +x ; } 2>/dev/null ; \
		printf "<<< Realizado >>>\n" ; \
	fi ;
	@printf "\n=================[ Finalizado ]=============\n"

# Regla explícita para depurar el binario que se construye desde la misma ventana
cdebug-run:
	@printf "\n=================[ Depurar en esta ventana el binario: \"%s\" ]=================\n" "$(DOLLAR-SIGNS-ESCAPED_BINDIR)$(DOLLAR-SIGNS-ESCAPED_PROGRAM)$(EXEEXT)"
	@printf "\n<<< $(CDB): Depurando en esta ventana el binario: \"%s\" >>>\n" "$(DOLLAR-SIGNS-ESCAPED_BINDIR)$(DOLLAR-SIGNS-ESCAPED_PROGRAM)$(EXEEXT)"
	@if [ -f "$(DOLLAR-SIGNS-ESCAPED_BINDIR)$(DOLLAR-SIGNS-ESCAPED_PROGRAM)$(EXEEXT)" ]; then \
		$(call sh_existe_comando,$(CDB)) ; \
		$(call sh_ruta_comando,$(CDB)) ; \
		printf "** Version instalada de $(CDB): %s **\n" "$$($(CDB) --version | sed -n 1p 2>/dev/null)" ; \
		set -x ; \
			cd "$(DOLLAR-SIGNS-ESCAPED_BINDIR)" ; \
			$(CDB) $(CDBFLAGS) "./$(DOLLAR-SIGNS-ESCAPED_PROGRAM)$(EXEEXT)" ; \
			cd - >/dev/null ; \
		{ set +x ; } 2>/dev/null ; \
	else \
		printf "(No existe el binario \"%s\")\n" "$(DOLLAR-SIGNS-ESCAPED_BINDIR)$(DOLLAR-SIGNS-ESCAPED_PROGRAM)$(EXEEXT)" ; \
	fi ;
	@printf "<<< Realizado >>>\n"
	@printf "\n=================[ Finalizado ]=============\n"

# Regla explícita para depurar el binario que se construye en una ventana nueva
cdebug-open:
	@printf "\n=================[ Depurar en una ventana nueva el binario: \"%s\" ]=================\n" "$(DOLLAR-SIGNS-ESCAPED_BINDIR)$(DOLLAR-SIGNS-ESCAPED_PROGRAM)$(EXEEXT)"
	@printf "\n<<< $(CDB): Depurando en una ventana nueva el binario: \"%s\" >>>\n" "$(DOLLAR-SIGNS-ESCAPED_BINDIR)$(DOLLAR-SIGNS-ESCAPED_PROGRAM)$(EXEEXT)"
	@if [ -f "$(DOLLAR-SIGNS-ESCAPED_BINDIR)$(DOLLAR-SIGNS-ESCAPED_PROGRAM)$(EXEEXT)" ]; then \
		$(call sh_existe_comando,$(CDB)) ; \
		$(call sh_ruta_comando,$(CDB)) ; \
		printf "** Version instalada de $(CDB): %s **\n" "$$($(CDB) --version | sed -n 1p 2>/dev/null)" ; \
		case "$(OPEN_COMMAND)" in \
			("start") \
				set -x ; \
					cd "$(DOLLAR-SIGNS-ESCAPED_BINDIR)" ; \
					start $(CDB) $(CDBFLAGS) "$(DOLLAR-SIGNS-ESCAPED_PROGRAM)$(EXEEXT)" ; \
					cd - >/dev/null ; \
				{ set +x ; } 2>/dev/null ;; \
			(*) \
				$(call sh_existe_comando,tmux) ; \
				$(call sh_ruta_comando,tmux) ; \
				printf "** Version instalada de tmux: %s **\n" "$$(tmux -V | sed -n 1p 2>/dev/null)" ; \
				set -x ; \
					cd "$(DOLLAR-SIGNS-ESCAPED_BINDIR)" ; \
					tmux new "$(nota_tmux) set -x ; $(CDB) $(CDBFLAGS) \"$(call escapar_simbolo_pesos_conforme_a_shell,$(call escapar_simbolo_pesos_conforme_a_shell,$(DOLLAR-SIGNS-ESCAPED_PROGRAM)$(EXEEXT)))\"" ; \
					cd - >/dev/null ; \
				{ set +x ; } 2>/dev/null ; \
				printf "NOTA: Para volver a las sesiones apartadas de tmux [detached], ejecute el comando <tmux attach>\n" ;; \
		esac ; \
	else \
		printf "(No existe el binario \"%s\")\n" "$(DOLLAR-SIGNS-ESCAPED_BINDIR)$(DOLLAR-SIGNS-ESCAPED_PROGRAM)$(EXEEXT)" ; \
	fi ;
	@printf "<<< Realizado >>>\n"
	@printf "\n=================[ Finalizado ]=============\n"

# Para incluir el/los otro/s makefile/s ya producido/s con los prerequisitos generados automáticamente
sinclude $(call sin_necesidad_de_comillas_dobles,$(shell printf "%s" '$(call escapar_comillas_simples_dentro_de_otras_comillas_simples,$(COBJS))' | sed -e 's?"[^"]*/?"?g' -e 's?"\([^"]*\)\.o"?"$(SINGLE-QUOTES-ESCAPED_DEPDIR)\1.d"?g' ;)) $(call sin_necesidad_de_comillas_dobles,$(shell printf "%s" '$(call escapar_comillas_simples_dentro_de_otras_comillas_simples,$(YOBJS))' | sed -e 's?"[^"]*/?"?g' -e 's?"\([^"]*\)\.tab\.o"?"$(SINGLE-QUOTES-ESCAPED_DEPDIR)\1.tab.d"?g' ;)) $(call sin_necesidad_de_comillas_dobles,$(shell printf "%s" '$(call escapar_comillas_simples_dentro_de_otras_comillas_simples,$(LOBJS))' | sed -e 's?"[^"]*/?"?g' -e 's?"\([^"]*\)\.lex\.yy\.o"?"$(SINGLE-QUOTES-ESCAPED_DEPDIR)\1.lex.yy.d"?g' ;))
# La directiva sinclude hace que make suspenda la lectura del makefile actual y lea en orden los otros makefiles que se indican antes de continuar. Si alguno de los makefiles indicados no puede ser encontrado, no es un error fatal inmediato; el procesamiento de este makefile continúa. Una vez que haya finalizado la etapa de lectura de makefiles, make intentará rehacer cualquiera que haya quedado obsoleto o que no exista. Si no puede encontrar una regla para rehacer algún otro makefile, o sí que la encontró pero ocurre un fallo al ejecutar la receta, make lo diagnostica como un error fatal al tratarse de la directiva include.

# Regla explícita con una receta vacía que no hace nada. Este objetivo es el que se establece como meta por defecto en el/los otro/s makefile/s producido/s para evitar que al ser incluido/s se ejecute alguna otra regla que sí que haga algo
empty: ;

# Regla implícita de tipo regla de patrón con CC: Para construir el binario $(BINDIR)$(PROGRAM)$(EXEEXT)
$(call escapar_espacios,$(call escapar_simbolos_de_porcentaje_conforme_a_make,$(BINDIR)$(PROGRAM)$(EXEEXT))): $(call sin_necesidad_de_comillas_dobles,$(COBJS)) $(call sin_necesidad_de_comillas_dobles,$(YOBJS)) $(call sin_necesidad_de_comillas_dobles,$(LOBJS)) | $(TRAILING-SLASH-REMOVED-AND-SPACES-ESCAPED_BINDIR)
# Anuncia que se va a iniciar la construcción
	@printf "\n=================[ Construccion con $(CC): \"%s\" ]=================\n" "$(call escapar_simbolo_pesos_conforme_a_shell,$@)"
# Si el binario ya existiera, fuerza su eliminación por si el archivo está en uso, ya que esto impediría su construcción
	@$(call forzar_eliminacion_si_ya_existiera_el_binario,$(call escapar_simbolo_pesos_conforme_a_shell,$@))
# Construye el binario
	@printf "\n<<< $(CC)->$(CC): Enlazando el/los archivo/s objeto con la/s biblioteca/s para construir el binario: \"%s\" [WARNINGS: $(WARNINGS_ENABLED) | DEBUG: $(DEBUG_ENABLED)] >>>\n" "$(call escapar_simbolo_pesos_conforme_a_shell,$@)"
	@$(call sh_existe_comando,$(CC))
	@$(call sh_ruta_comando,$(CC))
	@printf "** Version instalada de $(CC): %s **\n" "$$($(CC) --version | sed -n 1p 2>/dev/null)"
	$(CC) $(CFLAGS) -o"$(call escapar_simbolo_pesos_conforme_a_shell,$@)" $(call escapar_simbolo_pesos_conforme_a_shell,$(COBJS)) $(call escapar_simbolo_pesos_conforme_a_shell,$(YOBJS)) $(call escapar_simbolo_pesos_conforme_a_shell,$(LOBJS)) $(LDFLAGS) $(LDLIBS)
	@printf "<<< Realizado >>>\n"
# Anuncia que se completó la construcción
	@printf "\n=================[ Finalizado ]=================\n"
# Muestra una nota si el debug está habilitado
	@$(call mostrar_nota_sobre_yacc_si_la_depuracion_esta_habilitada)

# Para habilitar una segunda expansión en los prerequisitos para todas las reglas que siguen a continuación
.SECONDEXPANSION:
# Esto lo hacemos para poder producir las secuencias de escape para los espacios en aquellos objetivos que utilizan reglas de patrón (los que contienen el caracter %)

# Regla implícita de tipo regla de patrón con YACC + CC: Para generar el archivo objeto $(OBJDIR)%.tab.o desde $(OBJDIR)%.tab.c
$(PERCENT-SIGNS-AND-SPACES-ESCAPED_OBJDIR)%.tab.o: $$(call escapar_espacios,$$(OBJDIR)%.tab.c) $$(call escapar_espacios,$$(SRCDIR)%.y) $$(call escapar_espacios,$$(DEPDIR)%.tab.d) | $$(TRAILING-SLASH-REMOVED-AND-SPACES-ESCAPED_DEPDIR) $$(TRAILING-SLASH-REMOVED-AND-SPACES-ESCAPED_OBJDIR)
	$(call receta_para_.d,$(call escapar_simbolo_pesos_conforme_a_shell,$(shell printf "%s" "$(call escapar_simbolo_pesos_conforme_a_shell,$@)" | sed -e 's?.*/??' -e 's?\(.*\)\.o?$(SINGLE-QUOTES-ESCAPED_DEPDIR)\1?' ;)))
	@printf "\n<<< $(YACC)->$(CC): Generando el archivo objeto: \"%s\" [WARNINGS: $(WARNINGS_ENABLED) | DEBUG: $(DEBUG_ENABLED)] >>>\n" "$(call escapar_simbolo_pesos_conforme_a_shell,$@)"
	@$(call sh_existe_comando,$(CC))
	@$(call sh_ruta_comando,$(CC))
	@printf "** Version instalada de $(CC): %s **\n" "$$($(CC) --version | sed -n 1p 2>/dev/null)"
	$(CC) $(CPPFLAGS) $(CFLAGS) $(C_YOBJFLAGS) -c -o"$(call escapar_simbolo_pesos_conforme_a_shell,$@)" "$(call escapar_simbolo_pesos_conforme_a_shell,$<)"
	@printf "<<< Realizado >>>\n"

# Regla implícita de tipo regla de patrón con YACC: Para generar los archivos del analizador sintáctico (parser) $(OBJDIR)%.tab.c, $(OBJDIR)%.tab.h y $(OBJDIR)%.tab.output desde $(SRCDIR)%.y
$(PERCENT-SIGNS-AND-SPACES-ESCAPED_OBJDIR)%.tab.c $(PERCENT-SIGNS-AND-SPACES-ESCAPED_OBJDIR)%.tab.h $(PERCENT-SIGNS-AND-SPACES-ESCAPED_OBJDIR)%.output: $$(call escapar_espacios,$$(SRCDIR)%.y) | $$(TRAILING-SLASH-REMOVED-AND-SPACES-ESCAPED_OBJDIR)
	@printf "\n<<< $(YACC): Generando los archivos del analizador sintactico (parser): \"%s\" [WARNINGS: $(WARNINGS_ENABLED) | DEBUG: $(DEBUG_ENABLED)] >>>\n" "$(call escapar_simbolo_pesos_conforme_a_shell,$(shell printf "%s" "$(call escapar_simbolo_pesos_conforme_a_shell,$<)" | sed -e 's?.*/??' -e 's?\(.*\)\.y?$(SINGLE-QUOTES-ESCAPED_OBJDIR)\1<.tab.c><.tab.h><.output>?' ;))"
	@$(call sh_existe_comando,$(YACC))
	@$(call sh_ruta_comando,$(YACC))
	@printf "** Version instalada de $(YACC): %s **\n" "$$($(YACC) --version | sed -n 1p 2>/dev/null)"
	$(YACC) -d -v $(YFLAGS) -o"$(call escapar_simbolo_pesos_conforme_a_shell,$(shell printf "%s" "$(call escapar_simbolo_pesos_conforme_a_shell,$<)" | sed -e 's?.*/??' -e 's?\(.*\)\.y?$(SINGLE-QUOTES-ESCAPED_OBJDIR)\1.tab.c?' ;))" "$(call escapar_simbolo_pesos_conforme_a_shell,$<)"
	@printf "<<< Realizado >>>\n"

define archivos_de_cabecera_con_definiciones_de_yacc
$(shell printf "%s" '$(call escapar_comillas_simples_dentro_de_otras_comillas_simples,$(YOBJS))' | sed 's?"\([^"]*\)\.tab\.o"?"\1.tab.h"?g' ;)
endef

# Regla implícita de tipo regla de patrón con LEX + CC: Para generar el archivo objeto $(OBJDIR)%.lex.yy.o desde $(OBJDIR)%.lex.yy.c
$(PERCENT-SIGNS-AND-SPACES-ESCAPED_OBJDIR)%.lex.yy.o: $$(call escapar_espacios,$$(OBJDIR)%.lex.yy.c) $$(call escapar_espacios,$$(SRCDIR)%.l) $$(call escapar_espacios,$$(DEPDIR)%.lex.yy.d) | $$(TRAILING-SLASH-REMOVED-AND-SPACES-ESCAPED_DEPDIR) $$(TRAILING-SLASH-REMOVED-AND-SPACES-ESCAPED_OBJDIR) $$(call sin_necesidad_de_comillas_dobles,$$(archivos_de_cabecera_con_definiciones_de_yacc))
	$(call receta_para_.d,$(call escapar_simbolo_pesos_conforme_a_shell,$(shell printf "%s" "$(call escapar_simbolo_pesos_conforme_a_shell,$@)" | sed -e 's?.*/??' -e 's?\(.*\)\.o?$(SINGLE-QUOTES-ESCAPED_DEPDIR)\1?' ;)))
	@printf "\n<<< $(LEX)->$(CC): Generando el archivo objeto: \"%s\" [WARNINGS: $(WARNINGS_ENABLED) | DEBUG: $(DEBUG_ENABLED)] >>>\n" "$(call escapar_simbolo_pesos_conforme_a_shell,$@)"
	@$(call sh_existe_comando,$(CC))
	@$(call sh_ruta_comando,$(CC))
	@printf "** Version instalada de $(CC): %s **\n" "$$($(CC) --version | sed -n 1p 2>/dev/null)"
	$(CC) $(CPPFLAGS) $(CFLAGS) $(C_LOBJFLAGS) -c -o"$(call escapar_simbolo_pesos_conforme_a_shell,$@)" "$(call escapar_simbolo_pesos_conforme_a_shell,$<)"
	@printf "<<< Realizado >>>\n"

# Regla implícita de tipo regla de patrón con LEX: Para generar el archivo del analizador léxico (scanner) $(OBJDIR)%.lex.yy.c desde $(SRCDIR)%.l
$(PERCENT-SIGNS-AND-SPACES-ESCAPED_OBJDIR)%.lex.yy.c: $$(call escapar_espacios,$$(SRCDIR)%.l) | $$(TRAILING-SLASH-REMOVED-AND-SPACES-ESCAPED_OBJDIR)
	@printf "\n<<< $(LEX): Generando el archivo del analizador lexico (scanner): \"%s\" [WARNINGS: $(WARNINGS_ENABLED) | DEBUG: $(DEBUG_ENABLED)] >>>\n" "$(call escapar_simbolo_pesos_conforme_a_shell,$@)"
	@$(call sh_existe_comando,$(LEX))
	@$(call sh_ruta_comando,$(LEX))
	@printf "** Version instalada de $(LEX): %s **\n" "$$($(LEX) --version | sed -n 1p 2>/dev/null)"
	$(LEX) $(LFLAGS) -o"$(call escapar_simbolo_pesos_conforme_a_shell,$@)" "$(call escapar_simbolo_pesos_conforme_a_shell,$<)"
	@printf "<<< Realizado >>>\n"

# Regla implícita de tipo regla de patrón con CC: Para generar el archivo objeto $(OBJDIR)%.o desde $(SRCDIR)%.c
$(PERCENT-SIGNS-AND-SPACES-ESCAPED_OBJDIR)%.o: $$(call escapar_espacios,$$(SRCDIR)%.c) $$(call escapar_espacios,$$(DEPDIR)%.d) | $$(TRAILING-SLASH-REMOVED-AND-SPACES-ESCAPED_DEPDIR) $$(TRAILING-SLASH-REMOVED-AND-SPACES-ESCAPED_OBJDIR)
	$(call receta_para_.d,$(call escapar_simbolo_pesos_conforme_a_shell,$(shell printf "%s" "$(call escapar_simbolo_pesos_conforme_a_shell,$@)" | sed -e 's?.*/??' -e 's?\(.*\)\.o?$(SINGLE-QUOTES-ESCAPED_DEPDIR)\1?' ;)))
	@printf "\n<<< $(CC): Generando el archivo objeto: \"%s\" [WARNINGS: $(WARNINGS_ENABLED) | DEBUG: $(DEBUG_ENABLED)] >>>\n" "$(call escapar_simbolo_pesos_conforme_a_shell,$@)"
	@$(call sh_existe_comando,$(CC))
	@$(call sh_ruta_comando,$(CC))
	@printf "** Version instalada de $(CC): %s **\n" "$$($(CC) --version | sed -n 1p 2>/dev/null)"
	$(CC) $(CPPFLAGS) $(CFLAGS) $(C_COBJFLAGS) -c -o"$(call escapar_simbolo_pesos_conforme_a_shell,$@)" "$(call escapar_simbolo_pesos_conforme_a_shell,$<)"
	@printf "<<< Realizado >>>\n"

# Regla implícita de tipo regla de patrón con una receta vacía que no hace nada: Para evitar errores al momento de incluir los otros makefiles con prerequisitos generados automáticamente, respecto de los objetivos $(DEPDIR)%.d , $(DEPDIR)%.tab.d y $(DEPDIR)%.lex.yy.d , los cuales son creados como efecto secundario de las recetas para los objetivos $(OBJDIR)%.o , $(OBJDIR)%.tab.o y $(OBJDIR)%.lex.yy.o respectivamente: si el objetivo no existe la receta vacía asegura de que make no reclamará sobre que no sabe cómo construir el objetivo, y sólo asumirá de que el objetivo está obsoleto
%.d: ;

# Regla implícita de tipo regla de patrón con una receta vacía que no hace nada: Para evitar errores al momento de incluir los otros makefiles con prerequisitos generados automáticamente, respecto de los objetivos %.h : si el objetivo no existe la receta vacía asegura de que make no reclamará sobre que no sabe cómo construir el objetivo, y sólo asumirá de que el objetivo está obsoleto
%.h: ;

# Regla explícita con objetivos independientes para crear los directorios en donde se ubican los archivos intermedios, el binario, y los makefiles producidos correspondientemente, si alguno no existiera
$(call escapar_simbolos_de_porcentaje_conforme_a_make,$(TRAILING-SLASH-REMOVED-AND-SPACES-ESCAPED_OBJDIR)) $(call escapar_simbolos_de_porcentaje_conforme_a_make,$(TRAILING-SLASH-REMOVED-AND-SPACES-ESCAPED_BINDIR)) $(call escapar_simbolos_de_porcentaje_conforme_a_make,$(TRAILING-SLASH-REMOVED-AND-SPACES-ESCAPED_DEPDIR)):
	@printf "\n<<< Creando el directorio: \"%s\" >>>\n" "$(call escapar_simbolo_pesos_conforme_a_shell,$@)"
	mkdir -p "$(call escapar_simbolo_pesos_conforme_a_shell,$@)"
	@printf "<<< Realizado >>>\n"