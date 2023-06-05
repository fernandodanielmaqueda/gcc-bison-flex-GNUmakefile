# gcc-bison-flex-GNUmakefile, versión 2023.06.05-001-pre
# Este GNUmakefile sirve para construir, ejecutar y depurar proyectos en lenguaje C (archivos *.c con o sin archivos *.h asociados), proyectos en lenguaje C con flex (archivos *.l), proyectos en lenguaje C con bison (archivos *.y), y proyectos en lenguaje C con bison en conjunto con flex (así como proyectos que utilicen programas similares, como ser clang, yacc y lex)
# Para conseguir más información y asegurarse de obtener la versión base original más reciente, visite el repositorio del proyecto <https://github.com/fernandodanielmaqueda/gcc-bison-flex-GNUmakefile>

# Copyright (C) 2022-2023 Fernando Daniel Maqueda <https://github.com/fernandodanielmaqueda/>
# This GNUmakefile is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
# This GNUmakefile is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
# You should have received a copy of the GNU General Public License along with this. If not, see <https://www.gnu.org/licenses/>.

# Nombre del proyecto/programa/binario
PROGRAM:=miproyecto

# Subdirectorio en el que están ubicados los archivos *.c, *.y, y *.l fuente (excepto los archivos intermedios generados por CC, YACC y LEX). O sino puede quedar vacío para que se utilice el directorio actual. Por defecto: src/
srcdir:=src/
# Subdirectorio en el que se ubicará el binario construido. O sino puede quedar vacío para que se utilice el directorio actual. Por defecto: bin/
bindir:=bin/
# Subdirectorio en el que se ubicarán los otros makefiles (archivos *.d) producidos con las dependencias generadas automáticamente. O sino puede quedar vacío para que se utilice el directorio actual. Por defecto: .deps/
DEPDIR:=.deps/
# Subdirectorio en el que se ubicarán los archivos intermedios generados por CC, YACC y LEX. O sino puede quedar vacío para que se utilice el directorio actual. Por defecto: obj/
OBJDIR:=obj/

# Compilador de C, generador de analizadores sintácticos (parsers) y generador de analizadores léxicos (scanners) a usar, respectivamente
CC:=gcc
YACC:=bison
LEX:=flex

# Depurador a usar y las opciones a pasarle, respectivamente
GDB:=gdb
GDBFLAGS=

# Agregar acá las opciones que controlan el preprocesamiento que sean/serían COMUNES para TODOS los preprocesadores y/o compiladores de los lenguajes de programación (entre los que están C, C++, Objetive C, etc.). Por otra parte, añadir aquellas opciones que sean/serían SOLAMENTE para el preprocesador de C entre las variables CFLAGS, COBJS_CFLAGS, YOBJS_CFLAGS y/o LOBJS_CFLAGS, según el caso
CPPFLAGS=-I"$(if $(srcdir),$(DOLLAR-SIGNS-ESCAPED_srcdir),.)" -I"$(if $(OBJDIR),$(DOLLAR-SIGNS-ESCAPED_OBJDIR),.)"
# Entre las opciones que controlan el preprocesador, se encuentran:
# 	-I"Directorio" (es una de las opciones que sirven para especificar directorios para la búsqueda de archivos de cabecera (header files) (*.h): añade el directorio Directorio a la lista de directorios para buscar archivos de cabecera durante el preprocesamiento). Puede indicarse tanto por ruta relativa (desde este GNUmakefile) como por ruta absoluta, pero se recomienda la primera. También puede utilizarse -I"." para indicar el directorio actual. Por ejemplo: -I"include/"
#		Existen dos formas para la directiva de preprocesamiento #include:
#			(1) La que lleva corchetes angulares (angle-bracket form) (<>), como #include <math.h>
#			(2) La que lleva comillas dobles (quoted form) (""), como ser: #include "misfunciones.h"
#		Ambas formas hacen que la directiva #include sea reemplazada por todo el contenido del archivo de cabecera ó archivo fuente indicado en ella. La diferencia que hay entre ambas formas es el algoritmo de búsqueda utilizado para encontrar el archivo especificado; pero eso depende del compilador que se utilice, ya que es definido por la implementación. Pero los estándares también establecen, para la directiva que lleva comillas dobles (quoted form) (""), básicamente que si la búsqueda para esa forma no es soportada por el compilador, o si la búsqueda con ese algoritmo falla, entonces se debe pasar a buscar utilizando el algoritmo de búsqueda de la directiva que lleva corchetes angulares (angle-bracket form) (<>)
#		Dicho eso, en general, la forma que lleva comillas dobles (quoted form) ("") prioriza los archivos del usuario por sobre los archivos del sistema, y la forma que lleva corchetes angulares (angle-bracket form) (<>) es utilizada para los archivos del sistema.
#	-DNombre (para predefinir Nombre como una macro, con definición 1)
#	-DNombre=Definición (para predefinir Nombre como una macro, dada Definición)
#	-UNombre (para cancelar cualquier definición previa de Nombre, ya sea integrada o provista con una opción -D)

# Agregar acá las opciones PRINCIPALES que SIEMPRE se le quieran pasar a CC, YACC y LEX, según corresponda. Notar que también se les pueden agregar otras opciones según se encuentren las advertencias (warnings) y/o las depuraciones (debug) habilitadas o deshabilitadas (de acuerdo los valores definidos para las variables WARNINGS_CC, WARNINGS_YACC, WARNINGS_LEX, DEBUG_CC, DEBUG_YACC y DEBUG_LEX), y para CC también de acuerdo con el archivo objeto que se vaya a (re)generar (establecido en las variables COBJS_CFLAGS, YOBJS_CFLAGS y LOBJS_CFLAGS)
# 	Se espera, al respecto de CC, que las opciones que controlan el preprocesamiento que sean/serían SOLAMENTE para el preprocesador de C se añadan entre las variables CFLAGS, COBJS_CFLAGS, YOBJS_CFLAGS y/o LOBJS_CFLAGS, según el caso (de lo contrario en la variable CPPFLAGS), y que TODAS las opciones para enlazar sean agregadas en las variables LDFLAGS ó LDLIBS según correspondan
CFLAGS=-std=c99 -O0
#	Para CC, por ejemplo:
#		+ Opciones controlando el dialecto del lenguaje C: entre ellas, -ansi ó -std=c90 para C90, -std=c99 para C99, -std=c11 para C11, -std=c18 para C18, etc.
#		+ Opciones para controlar el formato de los mensajes de diagnóstico (warnings): entre ellas, -fdiagnostics-color=always
#		+ Opciones que controlan la optimización: entre ellas, -O, -O1, -O2, -O3, -O0, Os, -Ofast, -Og, -Oz, etc.
YFLAGS=--report=state --report=itemset --report=lookahead
# 	Para YACC, por ejemplo:
#		+ Opciones que controlan la salida de los archivos .output: entre ellas,
#			--report=state (para que se incluya en el archivo *.output generado una descripción de la gramática, conflictos tanto resueltos como sin resolver, y el autómata del analizador sintáctico)
#			--report=itemset (para que en el archivo *.output generado se muestren los estados y se incremente la descripción del autómata con el conjunto derivado para cada estado, en lugar de solamente su núcleo)
#			--report=lookahead (para que en el archivo *.output generado se muestren los estados se incremente la descripción del autómata con el conjunto siguiente de cada regla)
LFLAGS=

# Agregar acá otras opciones que se le quieran pasar siempre a CC EXCLUSIVAMENTE al (re)generar los archivos objeto desde los de C fuentes (de *.c a *.o), desde los archivos de C generados por YACC (de *.tab.c a *.tab.o) y desde los archivos de C generados por LEX (de *.lex.yy.c a *.lex.yy.o), según corresponda
COBJS_CFLAGS=
YOBJS_CFLAGS=
LOBJS_CFLAGS=

# Agregar acá las opciones para enlazar para CC
#	Se espera que se añadan TODAS las opciones -lNombreBiblioteca en la variable LDLIBS, y el resto de las opciones en la variable LDFLAGS
# 	Notar que ya se agregan las opciones -ly y -lfl para buscar y procesar las bibliotecas liby.a y libfl.a (ó liby.so y libfl.so, típicamente) para YACC y LEX cuando se encuentran archivos fuente de YACC ($(srcdir)*.y) y LEX ($(srcdir)*.l) correspondientemente. Si el enlazador no pudiera encontrar alguna de esas bibliotecas, se las debe indicar manualmente añadiendo las opciones -L correspondientes en la variable LDFLAGS.
LDFLAGS=
LDLIBS=-lm
# Entre las opciones para enlazar, se encuentran:
#	-lNombreBiblioteca (son pasadas directamente al enlazador y sirven para buscar y procesar la biblioteca con NombreBiblioteca al enlazar). Por ejemplo, -lm para que se busque y procese la biblioteca libm.a (ó libm.so) la cual contiene implementaciones de funciones que se necesitan definir para math.h, complex.h y fenv.h: por ejemplo, sin, cos, tan, log, log10, modf, pow, sqrt, fabs, ceil, floor, fmod, etc.
#		Existen dos tipos de bibliotecas:
#			(1) Estáticas (static): son archivos típicamente como "libNombreBiblioteca.a" que a su vez contienen archivos objeto (archivos *.o) 
#			(2) Compartidas/Dinámicas (shared/dynamic): son archivos típicamente con la forma "libNombreBiblioteca.so"
#		El enlazador busca en una lista estándar de directorios por la biblioteca con NombreBiblioteca. Los directorios en los que se busca incluye a varios directorios estándar del sistema sumado por cualquiera que se especifique con la opción -L
#		No todos los objetivos (targets) -así es como se denomina a los sistemas sobre los que se compila- soportan bibliotecas dinámicas, pero en aquellos en que sí: en el caso de que se encuentre tanto una biblioteca estática como una dinámica, el enlazador da preferencia a enlazar con la biblioteca dinámica a menos que se utilice la opción -static
#		Es importante el lugar del comando en el que se coloca esta opción; el enlazador busca y procesa bibliotecas y archivos objeto en el orden en el que éstos son especificados. Por ende, 'foo.o -lz bar.o' busca la biblioteca con nombre 'z' luego del archivo objeto 'foo.o' pero antes del archivo objeto 'bar.o'. Si 'bar.o' hace referencia a funciones que están en la biblioteca con nombre 'z', esas funciones podrían no ser cargadas
#	-L"Directorio" (éstas opciones sirven para especificar directorios para la búsqueda de bibliotecas (archivos lib*.a y/o lib*.so típicamente): añade el directorio Directorio a la lista de directorios para las búsquedas con las opciones -l. Puede indicarse tanto por ruta relativa (desde este GNUmakefile) como por ruta absoluta, pero se recomienda la primera. También puede utilizarse -L"." para indicar el directorio actual. Por ejemplo, -L"lib/"

# Acá se configuran las opciones para requerir o suprimir las advertencias (warnings) de CC al (re)generar los archivos objeto y/o al (re)construir el binario, según se encuentren habilitadas o deshabilitadas
#	Al ejecutar este GNUmakefile con GNU Make, se puede indicar si habilitarlas ó deshabilitarlas agregando WARNINGS_CC=0 ó WARNINGS_CC=1 como opción, respectivamente. Por ejemplo, para deshabilitarlas: <make WARNINGS_CC=0>, <make all WARNINGS_CC=0> y <make clean all WARNINGS_CC=0>
#	En caso de que no se lo indique, se habilitan ó deshabilitan de acuerdo con el valor definido por defecto para la variable WARNINGS_CC (si está escrito WARNINGS_CC?=1 ó WARNINGS_CC?=0 por ejemplo), debido a que si es distinto de 0 se habilitan, caso contrario se deshabilitan
WARNINGS_CC?=1
ifneq ($(WARNINGS_CC),0)
WARNINGS_CC_ACTIVATION:=Si
# 	Agregar a continuación las opciones que se le quieran pasar a CC cuando sus advertencias (warnings) se encuentren habilitadas (WARNINGS_CC=1), como ser, entre otras:
#		-Wall (para mostrar la mayoría de los tipos de warnings)
#		-Wextra (para mostrar aún más tipos de warnings que -Wall)
#		-Werror (para tratar a todos los warnings como errores)
#		-Wfatal-errors (para que no siga con la compilación tras ocurrir algún error, en lugar de intentar continuar e imprimir más mensajes de error)
#		-Wpedantic (para que muestre todos los warnings demandados estrictamente por el ISO C; rechace todos los programas que usen extensiones del lenguaje prohibidas, y algunos otros programas que no sigan el ISO C. Para ISO C, sigue la versión del estándar ISO C especificado por cualquier opción -std especificada)
#		-pedantic-errors (da un error donde sea que el estándar base requiera un diagnóstico, en algunos casos en donde hay comportamiento indefinido en tiempo de compilación y en otros casos que no previenen la compilación de programas que son válidos de acuerdo con el estándar. Esta opción NO es equivalente a la opción -Werror=pedantic, ya que hay errores habilitados por esta opción y no habilitados por la última y viceversa)
#		-Wno-unused-function (para que NO muestre un warning cuando una función con static como especificador de clase de almacenamiento es declarada pero no definida o que no es utilizada)
#		-Wno-unused-but-set-variable (para que NO muestre un warning cuando una variable local es inicializada pero no es utilizada)
#		-Wno-unused-variable (para que NO muestre un warning cuando una variable local o con static como especificador de clase de almacenamiento es declarada no es utilizada)
CFLAGS+=-Wall -Wpedantic
else
WARNINGS_CC_ACTIVATION:=No
# 	Agregar a continuación las opciones que se le quieran pasar a CC cuando sus advertencias (warnings) se encuentren deshabilitadas (WARNINGS_CC=0), como ser -w (para no mostrar ningún warning)
CFLAGS+=
endif

# Acá se configuran las opciones para las advertencias (warnings) de YACC al (re)generar los archivos del analizador sintáctico (parser), según se encuentren habilitadas o deshabilitadas
#	Al ejecutar este GNUmakefile con GNU Make, se puede indicar si habilitarlas ó deshabilitarlas agregando WARNINGS_YACC=0 ó WARNINGS_YACC=1 como opción, respectivamente. Por ejemplo, para deshabilitarlas: <make WARNINGS_YACC=0>, <make all WARNINGS_YACC=0> y <make clean all WARNINGS_YACC=0>
#	En caso de que no se lo indique, se habilitan ó deshabilitan de acuerdo con el valor definido por defecto para la variable WARNINGS_YACC (si está escrito WARNINGS_YACC?=1 ó WARNINGS_YACC?=0 por ejemplo), debido a que si es distinto de 0 se habilitan, caso contrario se deshabilitan
WARNINGS_YACC?=1
ifneq ($(WARNINGS_YACC),0)
WARNINGS_YACC_ACTIVATION:=Si
# 	Agregar a continuación las opciones que se le quieran pasar a YACC cuando sus advertencias (warnings) se encuentren habilitadas (WARNINGS_YACC=1), como ser -Wall (para mostrar todos los warnings), -Werror (para tratar a los warnings como errores), etc.
YFLAGS+=-Wall
else
WARNINGS_YACC_ACTIVATION:=No
# 	Agregar a continuación las opciones que se le quieran pasar a YACC cuando sus advertencias (warnings) se encuentren deshabilitadas (WARNINGS_YACC=0), como ser -Wnone (para no mostrar ningún warning)
YFLAGS+=
endif

# Acá se configuran las opciones para las advertencias (warnings) de LEX al (re)generar los archivos del analizador léxico (scanner), según se encuentren habilitadas o deshabilitadas
#	Al ejecutar este GNUmakefile con GNU Make, se puede indicar si habilitarlas ó deshabilitarlas agregando WARNINGS_LEX=0 ó WARNINGS_LEX=1 como opción, respectivamente. Por ejemplo, para deshabilitarlas: <make WARNINGS_LEX=0>, <make all WARNINGS_LEX=0> y <make clean all WARNINGS_LEX=0>
#	En caso de que no se lo indique, se habilitan ó deshabilitan de acuerdo con el valor definido por defecto para la variable WARNINGS_LEX (si está escrito WARNINGS_LEX?=1 ó WARNINGS_LEX?=0 por ejemplo), debido a que si es distinto de 0 se habilitan, caso contrario se deshabilitan
WARNINGS_LEX?=1
ifneq ($(WARNINGS_LEX),0)
WARNINGS_LEX_ACTIVATION:=Si
# 	Agregar a continuación las opciones que se le quieran pasar a LEX cuando sus advertencias (warnings) se encuentren habilitadas (WARNINGS_LEX=1)
LFLAGS+=
else
WARNINGS_LEX_ACTIVATION:=No
# 	Agregar a continuación las opciones que se le quieran pasar a LEX cuando sus advertencias (warnings) se encuentren deshabilitadas (WARNINGS_LEX=0), como ser -w (para suprimir todos los mensajes de warning)
LFLAGS+=
endif

# Acá se configuran los símbolos de depuración (debug symbols) de CC al (re)generar los archivos objeto y/o al (re)construir el binario, según se encuentren habilitados o deshabilitados
#	Al ejecutar este GNUmakefile con GNU Make, se puede indicar si habilitarlos ó deshabilitarlos agregando DEBUG_CC=0 ó DEBUG_CC=1 como opción, respectivamente. Por ejemplo, para deshabilitarlos: <make DEBUG_CC=0>, <make all DEBUG_CC=0> y <make clean all DEBUG_CC=0>
#	En caso de que no se lo indique, se habilitan ó deshabilitan de acuerdo con el valor definido por defecto para la variable DEBUG_CC (si está escrito DEBUG_CC?=1 ó DEBUG_CC?=0 por ejemplo), debido a que si es distinto de 0 se habilitan, caso contrario se deshabilitan
DEBUG_CC?=1
ifneq ($(DEBUG_CC),0)
DEBUG_CC_ACTIVATION:=Si
# 	Agregar a continuación las opciones que se le quieran pasar a CC cuando sus símbolos de depuración (debug symbols) se encuentren habilitados (DEBUG_CC=1), como ser -g[Nivel] (produce información de depuración en el formato nativo del sistema operativo (stabs, COFF, XCOFF, o DWARF) para que pueda depurarse), -ggdb[Nivel] y -gvms[Nivel], opciones en las cuales Nivel indica la cantidad de información de depuración, pudiendo estar entre 0 (nada) y 3 (extra) y que por defecto (si no se especifica) es 2.
CFLAGS+=-g3
else
DEBUG_CC_ACTIVATION:=No
# 	Agregar a continuación las opciones que se le quieran pasar a CC cuando sus símbolos de depuración (debug symbols) se encuentren deshabilitados (DEBUG_CC=0)
CFLAGS+=
endif

# Acá se configuran las opciones para la depuración (debug) del analizador sintáctico (parser) generado por YACC al (re)generar sus archivos y/o al (re)generar el archivo objeto desde el archivo de C generado por YACC (de *.tab.c a *.tab.o), según se encuentre habilitada o deshabilitada
#	Al ejecutar este GNUmakefile con GNU Make, se puede indicar si habilitarla ó deshabilitarla agregando DEBUG_YACC=0 ó DEBUG_YACC=1 como opción, respectivamente. Por ejemplo, para habilitarla: <make DEBUG_YACC=1>, <make all DEBUG_YACC=1> y <make clean all DEBUG_YACC=1>
#	En caso de que no se lo indique, se habilita ó deshabilita de acuerdo con el valor definido por defecto para la variable DEBUG_YACC (si está escrito DEBUG_YACC?=1 ó DEBUG_YACC?=0 por ejemplo), debido a que si es distinto de 0 se habilita, caso contrario se deshabilita
DEBUG_YACC?=0
ifneq ($(DEBUG_YACC),0)
DEBUG_YACC_ACTIVATION:=Si
# 	Agregar a continuación las opciones que se le quieran pasar a YACC cuando la depuración (debug) de su analizador sintáctico (parser) se encuentren habilitada (DEBUG_YACC=1), como ser -t (define la macro YYDEBUG a 1 si no se la define)
YFLAGS+=-t
# 	Cuando la depuración (debug) del analizador sintáctico (parser) generado por YACC se encuentre habilitada (DEBUG_YACC=1), y sólo cuando CC vaya a generar el archivo objeto desde el archivo de C generado por YACC (de *.tab.c a *.tab.o) se le pasará este flag -D para que defina la macro YYDEBUG en un valor entero distinto de 0 lo cual permite la depuracion de YACC
YOBJS_CFLAGS+=-DYYDEBUG=1
else
DEBUG_YACC_ACTIVATION:=No
# 	Agregar a continuación las opciones que se le quieran pasar a YACC cuando la depuración (debug) de analizador sintáctico (parser) generado se encuentre deshabilitada (DEBUG_YACC=0)
YFLAGS+=
# 	Cuando la depuración (debug) del analizador sintáctico (parser) generado por YACC se encuentre deshabilitada (DEBUG_YACC=0), y sólo cuando CC vaya a generar el archivo objeto desde el archivo de C generado por YACC (de *.tab.c a *.tab.o) se le pasará este flag -D para que defina la macro YYDEBUG en el valor entero 0 lo cual NO permite la depuracion de YACC
YOBJS_CFLAGS+=-DYYDEBUG=0
endif

# Acá se configuran las opciones para la depuración (debug) del analizador léxico (scanner) generado por LEX al (re)generar sus archivos, según se encuentre habilitada o deshabilitada
#	Al ejecutar este GNUmakefile con GNU Make, se puede indicar si habilitarla ó deshabilitarla agregando DEBUG_LEX=0 ó DEBUG_LEX=1 como opción, respectivamente. Por ejemplo, para habilitarla: <make DEBUG_LEX=1>, <make all DEBUG_LEX=1> y <make clean all DEBUG_LEX=1>
#	En caso de que no se lo indique, se habilita ó deshabilita de acuerdo con el valor definido por defecto para la variable DEBUG_LEX (si está escrito DEBUG_LEX?=1 ó DEBUG_LEX?=0 por ejemplo), debido a que si es distinto de 0 se habilita, caso contrario se deshabilita
DEBUG_LEX?=0
ifneq ($(DEBUG_LEX),0)
DEBUG_LEX_ACTIVATION:=Si
# 	Agregar a continuación las opciones que se le quieran pasar a LEX cuando la depuración (debug) de su analizador léxico (scanner) generado se encuentre habilitada (DEBUG_LEX=1), como ser -d (hace que el analizador generado se ejecute en modo de depuración)
LFLAGS+=-d
else
DEBUG_LEX_ACTIVATION:=No
# 	Agregar a continuación las opciones que se le quieran pasar a LEX cuando la depuración (debug) de su analizador léxico (scanner) generado se encuentre deshabilitada (DEBUG_LEX=0)
LFLAGS+=
endif

# Define una variable que contiene un solo espacio para luego utilizarla para sustituir con secuencias de escape cada uno de los espacios
espacio:=$(subst ",," ")

# Define una variable que contiene un símbolo numeral para poder ser utilizado adentro de referencias macro y/o invocaciones de funciones de GNU Make
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

# Para realizar las secuencias de escape para los símbolos de porcentaje conforme a GNU Make (cada % es reemplazado por \%) del valor pasado como parámetro
define escapar_simbolos_de_porcentaje_conforme_a_make
$(subst %,\%,$(1))
endef

# Para determinar que sh sea el programa utilizado como la shell
SHELL:=/bin/sh

# Comprueba que se haya encontrado una shell sh en el sistema
ifeq ($(wildcard $(call escapar_espacios,$(SHELL))),)
$(error ERROR: no hay una shell sh instalada y/o no se ha podido encontrar y ejecutar)
endif

# Comprueba que no se hayan agregado las opciones '-n', '--just-print', '--dry-run' y/o '--recon' al ejecutar este GNUmakefile con GNU Make, debido a que impiden la correcta ejecución de la función $(shell ...), necesaria para que este GNUmakefile pueda funcionar
ifneq ($(findstring n,$(firstword -$(MAKEFLAGS))),)
$(error ERROR: Este GNUmakefile no puede funcionar con las opciones '-n', '--just-print', '--dry-run' y/o '--recon' agregadas)
endif

# Comprueba que la función $(shell ...) se ejecute correctamente. Una de las posibles causas por las que que falla es utilizar alguna de las opciones '-n', '--just-print', '--dry-run' y/o '--recon' al invocar a GNU Make, con las cuales se arroja un error similar al siguiente: process_begin: CreateProcess(NULL, "", ...) failed.
ifeq ($(shell echo foo ;),)
$(error ERROR: La funcion shell de GNU Make, necesaria para que este GNUmakefile pueda funcionar, no se ejecuta correctamente)
endif

# Define las rutas hacia algunos de los comandos a utilizar
TMUX:=tmux
MKDIR:=mkdir
RM:=rm

# Comprueba que el comando <command> se pueda encontrar
ifeq ($(shell command -v cd ;),)
$(error ERROR: El comando <command>, necesario para que pueda funcionar este GNUmakefile, no esta instalado y/o no se puede encontrar y ejecutar)
endif

# Comprueba que se puedan encontrar aquellos de los comandos necesarios que SÍ se presentan en GNU coreutils (Core Utilities)
define make_comprobar_comando_coreutils
$(if $(shell command -v $(1) ;),,$(error ERROR: El comando <$(1)>, necesario para que pueda funcionar este GNUmakefile y que se presenta en GNU coreutils, no esta instalado y/o no se puede encontrar y ejecutar))
endef
$(foreach comando,[ cat cp expr false ls $(MKDIR) mv printf pwd $(RM) rmdir test touch tr true uname,$(eval $(call make_comprobar_comando_coreutils,$(comando))))

# Comprueba que se puedan encontrar el resto de los comandos necesarios que NO se presentan en GNU coreutils (Core Utilities)
define make_comprobar_otro_comando
$(if $(shell command -v $(1) ;),,$(error ERROR: El comando <$(1)>, necesario para que pueda funcionar este GNUmakefile, no esta instalado y/o no se puede encontrar y ejecutar))
endef
$(foreach comando,grep sed,$(eval $(call make_comprobar_otro_comando,$(comando))))

# Define las opciones para algunos de los comandos a utilizar
RM:=$(RM) -f
MKDIR_P:=$(MKDIR) -p

# Detecta si el sistema operativo es Windows o no, sabiendo que si lo es, Windows define una variable de entorno (Windows Environment Variable) con nombre 'OS' hoy en día típicamente con valor 'Windows_NT'
ifeq ($(OS),Windows_NT)
SO:=Windows_NT
# 	En caso de que el sistema operativo es Windows, se detecta si la aplicación y la arquitectura del procesador son de 32 o de 64 bits (sabiendo que Windows define una variable de entorno (Windows Environment Variable) con nombre 'PROCESSOR_ARCHITECTURE' típicamente con valor 'AMD64' tanto para aplicación como procesador de 64 bits, y sino usualmente con valor 'x86' para aplicación de 32 bits, en cuyo caso Windows también define define una variable de entorno (Windows Environment Variable) con nombre 'PROCESSOR_ARCHITEW6432' típicamente con valor 'AMD64' para procesador de 64 bits, y sino usualmente con valor 'x86' para procesador de 32 bits
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
# 	Para definir si la shell puede ejecutar el comando <start> de Windows o no
ifneq ($(shell command -v start ;),)
OPEN_COMMAND:=start
endif
# 	Para definir si la shell puede ejecutar el comando <where> de Windows o no
ifneq ($(shell command -v where ;),)
PATHNAME_COMMAND:=where
endif
endif

# Así se puede detectar el sistema (o kernel) en ejecución; particularmente se consulta si se está utilizando Cygwin o no
OUTPUT_UNAME_S:=$(shell uname)
SYSTEM:=$(patsubst CYGWIN_NT%,CYGWIN_NT,$(OUTPUT_UNAME_S))

# Configuraciones de acuerdo con el sistema operativo
ifeq ($(SO),Windows_NT)
# 	Para Windows, se genera un ejecutable *.exe
EXEEXT:=.exe
# 	También para Windows, si el procesador es de 64 bits y no se está usando Cygwin, se le agrega la bandera -m32 a CC para forzar a que éste construya binarios de 32 bits por más que el procesador sea de 64 bits
ifeq ($(BITS_PROCESSOR),64)
ifneq ($(SYSTEM),CYGWIN_NT)
CFLAGS+=-m32
endif
endif
else
# 	En cualquier otro sistema operativo (GNU/Linux, MacOS, etc.) se genera un archivo *.out
EXEEXT:=.out
endif

# Define nuevas variables a partir de otras ya existentes pero con secuencias de escape para los signos de pesos conforme a la shell para que sus valores puedan sean utilizados dentro de comillas dobles
$(foreach variable,PROGRAM srcdir bindir DEPDIR OBJDIR,$(eval DOLLAR-SIGNS-ESCAPED_$(variable):=$$(call escapar_simbolo_pesos_conforme_a_shell,$$($$(variable)))))

# Define nuevas variables a partir de otras ya existentes pero con secuencias de escape para las comillas simples para que sus valores puedan sean utilizados dentro de otras comillas simples
$(foreach variable,DEPDIR OBJDIR,$(eval SINGLE-QUOTES-ESCAPED_$(variable):=$$(call escapar_comillas_simples_dentro_de_otras_comillas_simples,$$($$(variable)))))

# Define nuevas variables a partir de otras ya existentes pero con secuencias de escape para los espacios y con secuencias de escape para los símbolos de porcentaje conforme a GNU Make para que sus valores puedan sean utilizados directamente en los objetivos de determinadas reglas de make
$(foreach variable,DEPDIR OBJDIR,$(eval PERCENT-SIGNS-AND-SPACES-ESCAPED_$(variable):=$$(call escapar_espacios,$$(call escapar_simbolos_de_porcentaje_conforme_a_make,$$($$(variable))))))

# Define nuevas variables a partir de otras ya existentes pero sin sus barras traseras y con secuencias de escape para los signos de pesos conforme a la shell para que sus valores puedan sean utilizados directamente en las comprobaciones de que no existan archivos con los mismos nombres de los directorios
$(foreach variable,bindir DEPDIR OBJDIR,$(eval TRAILING-SLASH-REMOVED-AND-DOLLAR-SIGNS-ESCAPED_$(variable):=$$(call escapar_simbolo_pesos_conforme_a_shell,$$(shell printf "%s" "$$(DOLLAR-SIGNS-ESCAPED_$$(variable))" | sed 's?/$$$$??' ;))))

# Define nuevas variables a partir de otras ya existentes pero sin sus barras traseras y con secuencias de escape para los espacios para que sus valores puedan sean utilizados directamente en los prerequisitos de sólo orden de determinadas reglas de make
$(foreach variable,bindir DEPDIR OBJDIR,$(eval TRAILING-SLASH-REMOVED-AND-SPACES-ESCAPED_$(variable):=$$(call escapar_espacios,$$(shell printf "%s" "$$(DOLLAR-SIGNS-ESCAPED_$$(variable))" | sed 's?/$$$$??' ;))))

# Comprueba que no existan archivos con los mismos nombres de los directorios, ya que no puede existir un directorio con el mismo nombre de un archivo, debido a que no se los podría diferenciar entre sí
define make_comprobar_que_no_exista_archivo_con_el_nombre_del_directorio
ifneq ($($(1)),)
ifneq ($$(shell if [ -f "$$(TRAILING-SLASH-REMOVED-AND-DOLLAR-SIGNS-ESCAPED_$(1))" ]; then echo foo ; fi ;),)
$$(info INFO: El archivo "$$(TRAILING-SLASH-REMOVED-AND-DOLLAR-SIGNS-ESCAPED_$(1))" tiene el mismo nombre que el del directorio definido en la variable $(1) del GNUmakefile, por lo tanto para poder continuar se procedera a eliminarlo...)
$$(shell $$(RM) "$$(TRAILING-SLASH-REMOVED-AND-DOLLAR-SIGNS-ESCAPED_$(1))" ;)
$$(info ... realizado.)
endif
endif
endef
$(foreach variable,bindir DEPDIR OBJDIR,$(eval $(call make_comprobar_que_no_exista_archivo_con_el_nombre_del_directorio,$(variable))))

# Produce los nombres de todos los archivos objeto a (re)generar de acuerdo con los archivos fuente de C ($(srcdir)*.c), YACC ($(srcdir)*.y) y LEX ($(srcdir)*.l) que se encuentren, respectivamente
COBJS:=$(shell ls "$(DOLLAR-SIGNS-ESCAPED_srcdir)"*.c 2>/dev/null | sed -e 's?.*/??' -e 's?\(.*\)\.c?"$(SINGLE-QUOTES-ESCAPED_OBJDIR)\1.o"?' ;)
YOBJS:=$(shell ls "$(DOLLAR-SIGNS-ESCAPED_srcdir)"*.y 2>/dev/null | sed -e 's?.*/??' -e 's?\(.*\)\.y?"$(SINGLE-QUOTES-ESCAPED_OBJDIR)\1.tab.o"?' ;)
LOBJS:=$(shell ls "$(DOLLAR-SIGNS-ESCAPED_srcdir)"*.l 2>/dev/null | sed -e 's?.*/??' -e 's?\(.*\)\.l?"$(SINGLE-QUOTES-ESCAPED_OBJDIR)\1.lex.yy.o"?' ;)

# Para producir los nombres de todos los archivos de cabecera con definiciones de YACC a (re)generar ($(OBJDIR)*.tab.h) de acuerdo con los nombres ya determinados de todos los archivos objeto de YACC también a (re)generar ($(OBJDIR)*.tab.o)
YDEFS=$(shell printf "%s" '$(call escapar_comillas_simples_dentro_de_otras_comillas_simples,$(YOBJS))' | sed 's?"\([^"]*\)\.tab\.o"?"\1.tab.h"?g' ;)

# Acciones de acuerdo con los archivos fuente presentes en el proyecto
ifneq ($(YOBJS)$(LOBJS),)
ifneq ($(YOBJS),)
# 	Agrega la opción -ly para CC (y que este a su vez se la pasa directamente al enlazador) para que busque y procese la biblioteca liby.a (ó liby.so, típicamente) la cual contiene implementaciones de funciones que se necesitan definir para el analizador sintáctico (parser) generado por YACC: una función yyerror y un main. Si el enlazador no pudiera encontrar esa biblioteca, se la debe indicar manualmente añadiendo la opción -L correspondiente en la variable LDFLAGS.
LDLIBS+=-ly
endif
ifneq ($(LOBJS),)
# 	Agrega la opción -lfl para CC (y que este a su vez se la pasa directamente al enlazador) para que busque y procese la biblioteca libfl.a (ó libfl.so, típicamente) la cual contiene implementaciones de funciones que se necesitan definir para el analizador léxico (scanner) generado por LEX: una función yywrap y un main. Si el enlazador no pudiera encontrar esa biblioteca, se la debe indicar manualmente añadiendo la opción -L correspondiente en la varible LDFLAGS.
LDLIBS+=-lfl
endif
else
ifeq ($(COBJS),)
# 	Alerta si no ha encontrado ningún archivo fuente de C ($(srcdir)*.c), YACC ($(srcdir)*.y) ni de LEX ($(srcdir)*.l)
$(error ERROR: no se ha encontrado ningun archivo fuente de C (*.c), YACC (*.y) ni LEX (*.l) en el directorio definido en la variable srcdir del GNUmakefile: "$(srcdir)")
endif
endif

# Define una secuencia de comandos enlatada para comprobar si se pueden encontrar los comandos que se van a ejecutar
define sh_existe_comando
	if ! command -v $($(1)) >/dev/null; then printf "ERROR: El comando <$($(1))> no esta instalado y/o no se puede encontrar y ejecutar\n" ; exit 1 ; fi
endef

# Define una secuencia de comandos enlatada para mostrar la ruta hacia el comando
ifeq ($(PATHNAME_COMMAND),where)
define sh_ruta_comando
	printf "** Ruta hacia $(1): %s **\n" "$$(where $($(1)) | sed -n 1p | sed 's?\\\?\\\\?g')"
endef
else
define sh_ruta_comando
	printf "** Ruta hacia $(1): %s **\n" "$$(command -v $($(1)))"
endef
endif

# Define una secuencia de comandos enlatada para comprobar que un comando esté instalado y que se pueda encontrar y ejecutar, imprimir la ruta hacia dicho comando y seguidamente su versión instalada; todo esto dado el nombre de la variable que contiene el nombre del comando y la opción para que éste imprima la versión instalada
define sh_comprobar_existencia_y_mostrar_ruta_y_version_comando
	$(call sh_existe_comando,$(1)) ; \
	$(call sh_ruta_comando,$(1)) ; \
	printf "** Version instalada de $(1): %s **\n" "$$($($(1)) $(2) | sed -n 1p 2>/dev/null)"
endef

# Define una secuencia de comandos enlatada que elimina un archivo, dados su descripción y su nombre 
define sh_eliminar_archivo
	if [ -f "$(2)" ]; then \
		printf "\n<<< Eliminando $(1): \"%s\" >>>\n" "$(2)" ; \
		set -x ; \
			$(RM) "$(2)" ; \
		{ set +x ; } 2>/dev/null ; \
		printf "<<< Realizado >>>\n" ; \
	fi
endef

# Define una secuencia de comandos enlatada que elimina un directorio, dado su nombre
define sh_eliminar_directorio
	if [ -d "$(1)" ]; then \
		printf "\n<<< Eliminando el directorio \"%s\" si esta vacio y no esta en uso >>>\n" "$(1)" ; \
		set -x ; \
			rmdir "$(1)" 2>/dev/null || true ; \
		{ set +x ; } 2>/dev/null ; \
		printf "<<< Realizado >>>\n" ; \
	fi
endef

# Define una secuencia de comandos enlatada que muestra una nota en las ventanas de las sesiones abiertas de tmux (Terminal MUltipleXer)
define sh_mostrar_nota_sobre_tmux
	printf \"NOTA: Esta es una ventana de una sesion abierta de tmux (Terminal MUltipleXer)\n\" ; \
	printf \"  * Para cerrar la ventana de la sesion, presione <Ctrl>+<b>, seguidamente presione <x> y por ultimo presione <y>\n\" ; \
	printf \"  * Para apartar la sesion con sus ventanas sin cerrarla [detach], presione <Ctrl>+<b> y seguidamente presione <d>\n\" ; \
	printf \"  * Para alternar entre las sesiones abiertas de tmux, presione <Ctrl>+<b> y seguidamente presione <s>\n\" ; \
	printf \"  * Para alternar entre las ventanas de las sesiones abiertas de tmux, presione <Ctrl>+<b> y seguidamente presione <w>\n\" ; \
	printf \"  * Para iniciar el modo desplazamiento por la ventana, presione <Ctrl>+<b> y seguidamente presione <[>\n\" ; \
	printf \"     (con la distribucion de teclado latinoamericano, <[> es <Shift>+<{>)\n\" ; \
	printf \"  * Para finalizar el modo desplazamiento por la ventana, presione <q>\n\" ; \
	printf \"\nPresione <Enter> para continuar...\" ; \
	read
endef

# Define una secuencia de comandos enlatada que muestra una nota si la depuración (debug) del analizador sintáctico (parser) generado por YACC se encuentra habilitada (DEBUG_YACC=1)
define sh_mostrar_nota_sobre_yacc_si_su_depuracion_se_encuentra_habilitada
	if [ -n '$(call escapar_comillas_simples_dentro_de_otras_comillas_simples,$(YOBJS))' ] && [ "X0" != "X$(DEBUG_YACC)" ]; then \
		printf "\nNOTA: Se ha definido la macro YYDEBUG en un valor entero distinto de 0 para permitir la depuracion de YACC\n" ; \
		printf "  Para depurar YACC, tambien debe asignarle un valor entero distinto de 0 a la variable de tipo int yydebug\n" ; \
		printf "  Una manera de lograr eso es agregarle el siguiente codigo al main() antes de que se llame a yyparse():\n" ; \
		printf "    #if YYDEBUG\n" ; \
		printf "      yydebug = 1;\n" ; \
		printf "    #endif\n" ; \
	fi
endef

# Define una secuencia de comandos enlatada con una receta para (re)generar el otro makefile $(DEPDIR)%.d a incluir con prerequisitos producidos automáticamente desde $(srcdir)%.c
define receta_para_.d
	@printf "\n<<< CC: (Re)generando el otro makefile a incluir con prerequisitos producidos automaticamente: \"%s\" >>>\n" "$(1).d"
	@$(call sh_comprobar_existencia_y_mostrar_ruta_y_version_comando,CC,--version)
	printf "empty:\n\n%s" "$(call escapar_espacios,$(call escapar_espacios,$(1).d)) $(call escapar_espacios,$(call escapar_espacios,$(call escapar_simbolo_pesos_conforme_a_shell,$(OBJDIR))))" > "$(1).d.tmp"
	$(CC) $(CPPFLAGS) $(CFLAGS) -MM "$(call escapar_simbolo_pesos_conforme_a_shell,$<)" >> "$(1).d.tmp" || { $(RM) "$(1).d.tmp" ; false ; }
	sed -e ':a' -e '3s?^\([^:]*\)\(^\|[^\\]\)%?\1\2\\\%?' -e 't a' -e 's?\(^\|[^$$]\)\$$\($$\|[^$$]\)?\1$$$$\2?g' -e 's?\(^\|[^\\]\)#?\1\\\#?g' < "$(1).d.tmp" > "$(1).d"
	$(RM) "$(1).d.tmp"
	@printf "<<< Realizado >>>\n"
endef

# Para eliminar la lista de sufijos conocidos que make genera por defecto
.SUFFIXES:
# 	Esto se efectúa para cancelar las reglas implícitas predefinidas por make, ya que ninguna de ellas se utilizará y además con esto se ahorra en tiempo de ejecución

# Para que GNU Make elimine el objetivo de una regla si ya se ha modificado y su receta finaliza con un estado de salida con valor no cero
.DELETE_ON_ERROR:

# Para establecer explícitamente la meta por defecto, en lugar de que ésta sea el primer objetivo sin iniciar con '.' y que además no contenga una o más '/'
.DEFAULT_GOAL: all

# Para especificar los objetivos que no generan archivos con ese mismo nombre para que se ejecuten siempre por más de que los archivos puedan llegar a existir
.PHONY: all clean run open cli_bin_debug_run cli_bin_debug_open empty
# 	La receta de una regla siempre se ejecutará si tiene como prerequisito de tipo normal a un target que sea .PHONY

# A partir de aquí inicia la configuración para solamente imprimir los objetivos que deben ser (re)construidos así como sus dependencias que sean más recientes (todas si el objetivo no existe), según se encuentre habilitado o deshabilitado
#	Al ejecutar este GNUmakefile con GNU Make, se puede indicar si habilitarlo ó deshabilitarlo agregando PRINT_ONLY=0 ó PRINT_ONLY=1 como opción, respectivamente. Por ejemplo, para habilitarlo: <make PRINT_ONLY=1> y <make all PRINT_ONLY=1>
#	En caso de que no se lo indique, se habilita ó deshabilita de acuerdo con el valor definido por defecto para la variable PRINT_ONLY (si está escrito PRINT_ONLY?=1 ó PRINT_ONLY?=0 por ejemplo), debido a que si es distinto de 0 se habilita, caso contrario se deshabilita
# 	Como excepción, siempre se deshabilitará si se agregan las opciones '-t' y/o '--touch' al ejecutar este GNUmakefile con GNU Make, sin importar el valor definido para la variable PRINT_ONLY
PRINT_ONLY?=0
ifneq ($(PRINT_ONLY),0)
ifeq ($(findstring t,$(firstword -$(MAKEFLAGS))),)
$(info INFO: Se encuentra habilitado el solamente imprimir los objetivos que deben ser (re)construidos asi como sus dependencias que sean mas recientes (todas si el objetivo no existe), debido a que la variable PRINT_ONLY del GNUmakefile tiene definido un valor distinto de 0...)
else
override PRINT_ONLY:=0
$(info INFO: Como se ha agregado la opcion '-t' ó '--touch' al ejecutarse, se deshabilita el solamente imprimir los objetivos que deben ser (re)construidos asi como sus dependencias que sean mas recientes (todas si el objetivo no existe), por mas de que la variable PRINT_ONLY del GNUmakefile tenga definido un valor distinto de 0...)
endif
endif

# Acá se configura al objetivo 'all', según la regeneración de los archivos secundarios al ser eliminados se encuentre habilitada o deshabilitada
#	Al ejecutar este GNUmakefile con GNU Make, se puede indicar si habilitarla ó deshabilitarla agregando REGENERATE_SECONDARY=0 ó REGENERATE_SECONDARY=1 como opción, respectivamente. Por ejemplo, para deshabilitarla: <make REGENERATE_SECONDARY=0> y <make all REGENERATE_SECONDARY=0>
#	En caso de que no se lo indique, se habilita ó deshabilita de acuerdo con el valor definido por defecto para la variable REGENERATE_SECONDARY (si está escrito REGENERATE_SECONDARY?=1 ó REGENERATE_SECONDARY?=0 por ejemplo), debido a que si es distinto de 0 se habilita, caso contrario se deshabilita
REGENERATE_SECONDARY?=1
ifneq ($(REGENERATE_SECONDARY),0)
# 	Para (re)construir todos los archivos intermedios y el binario ya sea con sus srcdir*.l y/o srcdir*.y como fuentes, o ya sea con sus srcdir*.c como fuentes. Se ejecuta con <make> (por ser la meta por defecto) o <make all>
all: $(call sin_necesidad_de_comillas_dobles,$(COBJS)) $(call sin_necesidad_de_comillas_dobles,$(shell printf "%s" '$(call escapar_comillas_simples_dentro_de_otras_comillas_simples,$(YOBJS))' | sed 's?"\([^"]*\)\.tab\.o"?"\1.tab.c" "\1.tab.h" "\1.output" "\1.tab.o"?g' ;)) $(call sin_necesidad_de_comillas_dobles,$(shell printf "%s" '$(call escapar_comillas_simples_dentro_de_otras_comillas_simples,$(LOBJS))' | sed 's?"\([^"]*\)\.lex\.yy\.o"?"\1.lex.yy.c" "\1.lex.yy.o"?g' ;)) $(call escapar_espacios,$(bindir)$(PROGRAM)$(EXEEXT)) ;
ifneq ($(PRINT_ONLY),0)
	@printf "  * Se debe construir el objetivo \"%s\".\n" "$@"
endif
else
# 	Para (re)construir el binario ya sea con sus srcdir*.l y/o srcdir*.y como fuentes, o ya sea con sus srcdir*.c como fuentes. Se ejecuta con <make> (por ser la meta por defecto) o <make all>
all: $(call escapar_espacios,$(bindir)$(PROGRAM)$(EXEEXT)) ;
ifneq ($(PRINT_ONLY),0)
	@printf "  * Se debe construir el objetivo \"%s\".\n" "$@"
endif
# 	Define explícitamente determinados objetivos como archivos secundarios; estos son tratados como archivos intermedios (aquellos que son creados por regla prerequisito de otra regla), excepto que nunca son eliminados automáticamente al terminar
.SECONDARY: $(call sin_necesidad_de_comillas_dobles,$(COBJS)) $(call sin_necesidad_de_comillas_dobles,$(shell printf "%s" '$(call escapar_comillas_simples_dentro_de_otras_comillas_simples,$(YOBJS))' | sed 's?"\([^"]*\)\.tab\.o"?"\1.tab.c" "\1.output" "\1.tab.o"?g' ;)) $(call sin_necesidad_de_comillas_dobles,$(shell printf "%s" '$(call escapar_comillas_simples_dentro_de_otras_comillas_simples,$(LOBJS))' | sed 's?"\([^"]*\)\.lex\.yy\.o"?"\1.lex.yy.c" "\1.lex.yy.o"?g' ;))
endif

# Regla explícita que tiene como objetivo este mismo GNUmakefile para evitar que make intente reconstruirlo, ya que eso no es necesario, con lo cual se optimiza el tiempo de inicialización
GNUmakefile:: ;

# Regla explícita para borrar el binario y todos los archivos intermedios generados al construir
clean:
ifneq ($(PRINT_ONLY),0)
	@printf "  * Se debe construir el objetivo \"%s\".\n" "$@"
else
	@printf "\n=================[ Eliminar todo lo que se genera al construir ]=================\n"
	@$(call sh_eliminar_archivo,el binario,$(DOLLAR-SIGNS-ESCAPED_bindir)$(DOLLAR-SIGNS-ESCAPED_PROGRAM)$(EXEEXT))
	@$(call sh_eliminar_directorio,$(DOLLAR-SIGNS-ESCAPED_bindir))
	@if [ -n '$(call escapar_comillas_simples_dentro_de_otras_comillas_simples,$(LOBJS))' ]; then \
		for BASENAME in $(call escapar_simbolo_pesos_conforme_a_shell,$(shell printf "%s" '$(call escapar_comillas_simples_dentro_de_otras_comillas_simples,$(LOBJS))' | sed -e 's?"[^"]*/?"?g' -e 's?"\([^"]*\)\.lex\.yy\.o"?"\1"?g' ;)) ; do \
			$(call sh_eliminar_archivo,el archivo objeto,$(DOLLAR-SIGNS-ESCAPED_OBJDIR)$$BASENAME.lex.yy.o) ; \
			$(call sh_eliminar_archivo,el otro makefile con prerequisitos producidos automaticamente,$(DOLLAR-SIGNS-ESCAPED_DEPDIR)$$BASENAME.lex.yy.d) ; \
			$(call sh_eliminar_archivo,el archivo temporal,$(DOLLAR-SIGNS-ESCAPED_DEPDIR)$$BASENAME.lex.yy.d.tmp) ; \
			$(call sh_eliminar_archivo,el archivo fuente de C generado por LEX que implementa un analizador lexico (scanner),$(DOLLAR-SIGNS-ESCAPED_OBJDIR)$$BASENAME.lex.yy.c) ; \
		done ; \
	fi
	@if [ -n '$(call escapar_comillas_simples_dentro_de_otras_comillas_simples,$(YOBJS))' ]; then \
		for BASENAME in $(call escapar_simbolo_pesos_conforme_a_shell,$(shell printf "%s" '$(call escapar_comillas_simples_dentro_de_otras_comillas_simples,$(YOBJS))' | sed -e 's?"[^"]*/?"?g' -e 's?"\([^"]*\)\.tab\.o"?"\1"?g' ;)) ; do \
			$(call sh_eliminar_archivo,el archivo objeto,$(DOLLAR-SIGNS-ESCAPED_OBJDIR)$$BASENAME.tab.o) ; \
			$(call sh_eliminar_archivo,el otro makefile con prerequisitos producidos automaticamente,$(DOLLAR-SIGNS-ESCAPED_DEPDIR)$$BASENAME.tab.d) ; \
			$(call sh_eliminar_archivo,el archivo temporal,$(DOLLAR-SIGNS-ESCAPED_DEPDIR)$$BASENAME.tab.d.tmp) ; \
			$(call sh_eliminar_archivo,el archivo de texto con informacion sobre el analizador sintactico (parser) generado por YACC,$(DOLLAR-SIGNS-ESCAPED_OBJDIR)$$BASENAME.output) ; \
			$(call sh_eliminar_archivo,el archivo de cabecera con definiciones del analizador sintactico (parser) generado por YACC,$(DOLLAR-SIGNS-ESCAPED_OBJDIR)$$BASENAME.tab.h) ; \
			$(call sh_eliminar_archivo,el archivo fuente de C generado por YACC que implementa un analizador sintactico (parser),$(DOLLAR-SIGNS-ESCAPED_OBJDIR)$$BASENAME.tab.c) ; \
		done ; \
	fi
	@if [ -n '$(call escapar_comillas_simples_dentro_de_otras_comillas_simples,$(COBJS))' ]; then \
		for BASENAME in $(call escapar_simbolo_pesos_conforme_a_shell,$(shell printf "%s" '$(call escapar_comillas_simples_dentro_de_otras_comillas_simples,$(COBJS))' | sed -e 's?"[^"]*/?"?g' -e 's?"\([^"]*\)\.o"?"\1"?g' ;)) ; do \
			$(call sh_eliminar_archivo,el archivo objeto,$(DOLLAR-SIGNS-ESCAPED_OBJDIR)$$BASENAME.o) ; \
			$(call sh_eliminar_archivo,el otro makefile con prerequisitos producidos automaticamente,$(DOLLAR-SIGNS-ESCAPED_DEPDIR)$$BASENAME.d) ; \
			$(call sh_eliminar_archivo,el archivo temporal,$(DOLLAR-SIGNS-ESCAPED_DEPDIR)$$BASENAME.d.tmp) ; \
		done ; \
	fi
	@$(call sh_eliminar_directorio,$(DOLLAR-SIGNS-ESCAPED_OBJDIR))
	@$(call sh_eliminar_directorio,$(DOLLAR-SIGNS-ESCAPED_DEPDIR))
	@printf "\n=================[ Finalizado ]=============\n"
endif

# Regla explícita para ejecutar el binario que se construye desde la misma ventana
run:
ifneq ($(PRINT_ONLY),0)
	@printf "  * Se debe construir el objetivo \"%s\".\n" "$@"
else
	@printf "\n=================[ Ejecutar el binario en esta ventana ]=================\n"
	@if [ -f "$(DOLLAR-SIGNS-ESCAPED_bindir)$(DOLLAR-SIGNS-ESCAPED_PROGRAM)$(EXEEXT)" ]; then \
		printf "\n<<< dot (.): Ejecutando en esta ventana el binario: \"%s\" >>>\n" "$(DOLLAR-SIGNS-ESCAPED_bindir)$(DOLLAR-SIGNS-ESCAPED_PROGRAM)$(EXEEXT)" ; \
		set -x ; \
			cd "$(DOLLAR-SIGNS-ESCAPED_bindir)" ; \
			"./$(DOLLAR-SIGNS-ESCAPED_PROGRAM)$(EXEEXT)" ; \
			cd - >/dev/null ; \
		{ set +x ; } 2>/dev/null ; \
		printf "<<< Realizado >>>\n" ; \
	else \
		printf "\nEXCEPCION: No existe el binario \"%s\". Se lo debe construir para poder ejecutarlo...\n" "$(DOLLAR-SIGNS-ESCAPED_bindir)$(DOLLAR-SIGNS-ESCAPED_PROGRAM)$(EXEEXT)" ; \
	fi
	@printf "\n=================[ Finalizado ]=============\n"
endif

# Regla explícita para abrir el binario que se construye en una ventana nueva
open:
ifneq ($(PRINT_ONLY),0)
	@printf "  * Se debe construir el objetivo \"%s\".\n" "$@"
else
	@printf "\n=================[ Ejecutar el binario en una ventana nueva ]=================\n"
	@if [ -f "$(DOLLAR-SIGNS-ESCAPED_bindir)$(DOLLAR-SIGNS-ESCAPED_PROGRAM)$(EXEEXT)" ]; then \
		case "$(OPEN_COMMAND)" in \
			("start") \
				printf "\n<<< start: Ejecutando en una ventana nueva el binario: \"%s\" >>>\n" "$(DOLLAR-SIGNS-ESCAPED_bindir)$(DOLLAR-SIGNS-ESCAPED_PROGRAM)$(EXEEXT)" ; \
				set -x ; \
					cd "$(DOLLAR-SIGNS-ESCAPED_bindir)" ; \
					start "$(call escapar_simbolo_pesos_conforme_a_shell,$(subst /,\\,$(CURDIR)/$(bindir)))$(DOLLAR-SIGNS-ESCAPED_PROGRAM)$(EXEEXT) " "$(DOLLAR-SIGNS-ESCAPED_PROGRAM)$(EXEEXT)" ; \
					cd - >/dev/null ; \
				{ set +x ; } 2>/dev/null ; \
				printf "<<< Realizado >>>\n" ;; \
			(*) \
				printf "\n<<< TMUX->dot (.): Ejecutando en una ventana nueva el binario: \"%s\" >>>\n" "$(DOLLAR-SIGNS-ESCAPED_bindir)$(DOLLAR-SIGNS-ESCAPED_PROGRAM)$(EXEEXT)" ; \
				$(call sh_comprobar_existencia_y_mostrar_ruta_y_version_comando,TMUX,-V) ; \
				set -x ; \
					cd "$(DOLLAR-SIGNS-ESCAPED_bindir)" ; \
					$(TMUX) new "$(sh_mostrar_nota_sobre_tmux) ; set -x ; \"./$(call escapar_simbolo_pesos_conforme_a_shell,$(call escapar_simbolo_pesos_conforme_a_shell,$(DOLLAR-SIGNS-ESCAPED_PROGRAM)$(EXEEXT)))\"" ; \
					cd - >/dev/null ; \
				{ set +x ; } 2>/dev/null ; \
				printf "NOTA: Para volver a las sesiones apartadas de tmux [detached], ejecute el comando <tmux attach>\n" ; \
				printf "<<< Realizado >>>\n" ;; \
		esac ; \
	else \
		printf "\nEXCEPCION: No existe el binario \"%s\". Se lo debe construir para poder ejecutarlo...\n" "$(DOLLAR-SIGNS-ESCAPED_bindir)$(DOLLAR-SIGNS-ESCAPED_PROGRAM)$(EXEEXT)" ; \
	fi
	@printf "\n=================[ Finalizado ]=============\n"
endif

# Regla explícita para depurar el binario que se construye desde la misma ventana por medio de una interfaz de línea de comandos (CLI)
cli_bin_debug_run:
ifneq ($(PRINT_ONLY),0)
	@printf "  * Se debe construir el objetivo \"%s\".\n" "$@"
else
	@printf "\n=================[ Depurar el binario en esta ventana por medio de una interfaz de linea de comandos (CLI) ]=================\n"
	@if [ -f "$(DOLLAR-SIGNS-ESCAPED_bindir)$(DOLLAR-SIGNS-ESCAPED_PROGRAM)$(EXEEXT)" ]; then \
		printf "\n<<< GDB: Depurando en esta ventana por medio de una interfaz de linea de comandos (CLI) el binario: \"%s\" >>>\n" "$(DOLLAR-SIGNS-ESCAPED_bindir)$(DOLLAR-SIGNS-ESCAPED_PROGRAM)$(EXEEXT)" ; \
		$(call sh_comprobar_existencia_y_mostrar_ruta_y_version_comando,GDB,--version) ; \
		set -x ; \
			cd "$(DOLLAR-SIGNS-ESCAPED_bindir)" ; \
			$(GDB) $(GDBFLAGS) "./$(DOLLAR-SIGNS-ESCAPED_PROGRAM)$(EXEEXT)" ; \
			cd - >/dev/null ; \
		{ set +x ; } 2>/dev/null ; \
		printf "<<< Realizado >>>\n" ; \
	else \
		printf "\nEXCEPCION: No existe el binario \"%s\". Se lo debe construir para poder depurarlo...\n" "$(DOLLAR-SIGNS-ESCAPED_bindir)$(DOLLAR-SIGNS-ESCAPED_PROGRAM)$(EXEEXT)" ; \
	fi
	@printf "\n=================[ Finalizado ]=============\n"
endif

# Regla explícita para depurar el binario que se construye en una ventana nueva por medio de una interfaz de línea de comandos (CLI)
cli_bin_debug_open:
ifneq ($(PRINT_ONLY),0)
	@printf "  * Se debe construir el objetivo \"%s\".\n" "$@"
else
	@printf "\n=================[ Depurar el binario en una ventana nueva por medio de una interfaz de linea de comandos (CLI) ]=================\n"
	@if [ -f "$(DOLLAR-SIGNS-ESCAPED_bindir)$(DOLLAR-SIGNS-ESCAPED_PROGRAM)$(EXEEXT)" ]; then \
		case "$(OPEN_COMMAND)" in \
			("start") \
				printf "\n<<< start->GDB: Depurando en una ventana nueva por medio de una interfaz de linea de comandos (CLI) el binario: \"%s\" >>>\n" "$(DOLLAR-SIGNS-ESCAPED_bindir)$(DOLLAR-SIGNS-ESCAPED_PROGRAM)$(EXEEXT)" ; \
				$(call sh_comprobar_existencia_y_mostrar_ruta_y_version_comando,GDB,--version) ; \
				set -x ; \
					cd "$(DOLLAR-SIGNS-ESCAPED_bindir)" ; \
					start $(GDB) $(GDBFLAGS) "$(DOLLAR-SIGNS-ESCAPED_PROGRAM)$(EXEEXT)" ; \
					cd - >/dev/null ; \
				{ set +x ; } 2>/dev/null ;; \
			(*) \
				printf "\n<<< TMUX->GDB: Depurando en una ventana nueva por medio de una interfaz de linea de comandos (CLI) el binario: \"%s\" >>>\n" "$(DOLLAR-SIGNS-ESCAPED_bindir)$(DOLLAR-SIGNS-ESCAPED_PROGRAM)$(EXEEXT)" ; \
				$(call sh_comprobar_existencia_y_mostrar_ruta_y_version_comando,TMUX,-V) ; \
				$(call sh_comprobar_existencia_y_mostrar_ruta_y_version_comando,GDB,--version) ; \
				set -x ; \
					cd "$(DOLLAR-SIGNS-ESCAPED_bindir)" ; \
					$(TMUX) new "$(sh_mostrar_nota_sobre_tmux) ; set -x ; $(GDB) $(GDBFLAGS) \"$(call escapar_simbolo_pesos_conforme_a_shell,$(call escapar_simbolo_pesos_conforme_a_shell,$(DOLLAR-SIGNS-ESCAPED_PROGRAM)$(EXEEXT)))\"" ; \
					cd - >/dev/null ; \
				{ set +x ; } 2>/dev/null ; \
				printf "NOTA: Para volver a las sesiones apartadas de tmux [detached], ejecute el comando <tmux attach>\n" ;; \
		esac ; \
	else \
		printf "\nEXCEPCION: No existe el binario \"%s\". Se lo debe construir para poder depurarlo...\n" "$(DOLLAR-SIGNS-ESCAPED_bindir)$(DOLLAR-SIGNS-ESCAPED_PROGRAM)$(EXEEXT)" ; \
	fi
	@printf "<<< Realizado >>>\n"
	@printf "\n=================[ Finalizado ]=============\n"
endif

# Regla explícita con una receta vacía que no hace nada. Este objetivo es el que se establece como meta por defecto en el/los otro/s makefile/s producido/s para evitar que al ser incluido/s se ejecute alguna otra regla que sí que haga algo
empty: ;

# Para incluir el/los otro/s makefile/s ya generado/s con los prerequisitos producidos automáticamente
sinclude $(call sin_necesidad_de_comillas_dobles,$(shell printf "%s" '$(call escapar_comillas_simples_dentro_de_otras_comillas_simples,$(COBJS))' | sed -e 's?"[^"]*/?"?g' -e 's?"\([^"]*\)\.o"?"$(SINGLE-QUOTES-ESCAPED_DEPDIR)\1.d"?g' ;)) $(call sin_necesidad_de_comillas_dobles,$(shell printf "%s" '$(call escapar_comillas_simples_dentro_de_otras_comillas_simples,$(YOBJS))' | sed -e 's?"[^"]*/?"?g' -e 's?"\([^"]*\)\.tab\.o"?"$(SINGLE-QUOTES-ESCAPED_DEPDIR)\1.tab.d"?g' ;)) $(call sin_necesidad_de_comillas_dobles,$(shell printf "%s" '$(call escapar_comillas_simples_dentro_de_otras_comillas_simples,$(LOBJS))' | sed -e 's?"[^"]*/?"?g' -e 's?"\([^"]*\)\.lex\.yy\.o"?"$(SINGLE-QUOTES-ESCAPED_DEPDIR)\1.lex.yy.d"?g' ;))
# 	La directiva sinclude hace que GNU Make suspenda la lectura del makefile actual y lea en orden los otros makefiles que se indican antes de continuar. Si alguno de los makefiles indicados no puede ser encontrado, no es un error fatal inmediato; el procesamiento de este makefile continúa. Una vez que haya finalizado la etapa de lectura de makefiles, GNU Make intentará (re)hacer cualquiera que haya quedado obsoleto o que no exista. Si no puede encontrar una regla para (re)hacer algún otro makefile, o sí que la encontró pero ocurre un fallo al ejecutar la receta, GNU Make lo diagnostica como un error fatal solamente en caso de utilizarse la directiva include (no así para las directivas sinclude y -include las cuales son equivalentes entre sí)
#	En este GNUmakefile no debería haber diferencia alguna entre usar la directiva include o las directivas sinclude ó -include, pero en versiones tempranas de GNU Make (entre la 3.81 y la 4.1 por lo menos), al utilizar la directiva include se muestra un error innecesario del estilo $(warning ...) cada vez que algún makefile indicado no puede ser encontrado (aún no existe) en el momento en el que se suspende la lectura del makefile actual y se leen en orden los otros makefiles que se indican antes de continuar; en este caso mensajes con el formato: GNUmakefile:NumeroDeLineaDeLaDirectivaInclude: $(DEPDIR)%.d: No such file or directory
#		Si bien esto ya fue solucionado a partir de GNU Make 4.2, se prefirió utilizar cualquiera de las directivas sinclude ó -include (puesto que éstas son equivalentes entre sí) por sobre la directiva include justamente para que en las versiones más tempranas de GNU Make no aparezcan dichas advertencias absolutamente irrelevantes

# Regla explícita con CC: Para (re)construir el binario $(bindir)$(PROGRAM)$(EXEEXT)
$(call escapar_espacios,$(call escapar_simbolos_de_porcentaje_conforme_a_make,$(bindir)$(PROGRAM)$(EXEEXT))): $(call sin_necesidad_de_comillas_dobles,$(COBJS)) $(call sin_necesidad_de_comillas_dobles,$(YOBJS)) $(call sin_necesidad_de_comillas_dobles,$(LOBJS)) | $(TRAILING-SLASH-REMOVED-AND-SPACES-ESCAPED_bindir)
ifneq ($(PRINT_ONLY),0)
	@printf "  * Se debe (re)construir el objetivo \"%s\". Sus dependencias que son mas recientes son: %s\n" "$(call escapar_simbolo_pesos_conforme_a_shell,$@)" "$(call escapar_simbolo_pesos_conforme_a_shell,$?)"
else
	@printf "\n=================[ (Re)construccion con CC: \"%s\" ]=================\n" "$(call escapar_simbolo_pesos_conforme_a_shell,$@)"
	@$(call sh_eliminar_archivo,el binario ya existente,$(call escapar_simbolo_pesos_conforme_a_shell,$@))
	@printf "\n<<< CC->CC: Enlazando todos los archivos objeto y las bibliotecas para (re)construir el binario: \"%s\" [WARNINGS_CC: $(WARNINGS_CC_ACTIVATION) | DEBUG_CC: $(DEBUG_CC_ACTIVATION)] >>>\n" "$(call escapar_simbolo_pesos_conforme_a_shell,$@)"
	@$(call sh_comprobar_existencia_y_mostrar_ruta_y_version_comando,CC,--version)
	$(CC) $(CFLAGS) $(LDFLAGS) -o"$(call escapar_simbolo_pesos_conforme_a_shell,$@)" $(call escapar_simbolo_pesos_conforme_a_shell,$(COBJS)) $(call escapar_simbolo_pesos_conforme_a_shell,$(YOBJS)) $(call escapar_simbolo_pesos_conforme_a_shell,$(LOBJS)) $(LDLIBS)
	@printf "<<< Realizado >>>\n"
	@printf "\n=================[ Finalizado ]=================\n"
	@$(call sh_mostrar_nota_sobre_yacc_si_su_depuracion_se_encuentra_habilitada)
endif

# Para habilitar una segunda expansión en los prerequisitos para todas las reglas que siguen a continuación
.SECONDEXPANSION:
# 	Esto lo hacemos para poder producir las secuencias de escape para los espacios en aquellos objetivos que utilizan reglas de patrón (los que contienen el caracter %)

# Regla implícita de tipo regla de patrón con YACC + CC: Para (re)generar el archivo objeto $(OBJDIR)%.tab.o desde $(OBJDIR)%.tab.c
$(PERCENT-SIGNS-AND-SPACES-ESCAPED_OBJDIR)%.tab.o: $$(call escapar_espacios,$$(OBJDIR)%.tab.c) $$(call escapar_espacios,$$(srcdir)%.y) $$(call escapar_espacios,$$(DEPDIR)%.tab.d) | $$(TRAILING-SLASH-REMOVED-AND-SPACES-ESCAPED_DEPDIR) $$(TRAILING-SLASH-REMOVED-AND-SPACES-ESCAPED_OBJDIR)
ifeq ($(findstring t,$(firstword -$(MAKEFLAGS))),)
ifneq ($(PRINT_ONLY),0)
	@printf "  * Se debe (re)construir el objetivo \"%s\". Sus dependencias que son mas recientes son: %s\n" "$(call escapar_simbolo_pesos_conforme_a_shell,$@)" "$(call escapar_simbolo_pesos_conforme_a_shell,$?)"
else
	$(call receta_para_.d,$(call escapar_simbolo_pesos_conforme_a_shell,$(shell printf "%s" "$(call escapar_simbolo_pesos_conforme_a_shell,$@)" | sed -e 's?.*/??' -e 's?\(.*\)\.o?$(SINGLE-QUOTES-ESCAPED_DEPDIR)\1?' ;)))
	@printf "\n<<< YACC->CC: (Re)generando el archivo objeto: \"%s\" [WARNINGS_CC: $(WARNINGS_CC_ACTIVATION) | DEBUG_CC: $(DEBUG_CC_ACTIVATION)] >>>\n" "$(call escapar_simbolo_pesos_conforme_a_shell,$@)"
	@$(call sh_comprobar_existencia_y_mostrar_ruta_y_version_comando,CC,--version)
	$(CC) $(CPPFLAGS) $(CFLAGS) $(YOBJS_CFLAGS) -c -o"$(call escapar_simbolo_pesos_conforme_a_shell,$@)" "$(call escapar_simbolo_pesos_conforme_a_shell,$<)"
	@printf "<<< Realizado >>>\n"
endif
else
	+touch "$(call escapar_simbolo_pesos_conforme_a_shell,$(shell printf "%s" "$(call escapar_simbolo_pesos_conforme_a_shell,$@)" | sed -e 's?.*/??' -e 's?\(.*\)\.o?$(SINGLE-QUOTES-ESCAPED_DEPDIR)\1.d?' ;))"
	+touch "$(call escapar_simbolo_pesos_conforme_a_shell,$@)"
endif

# Regla implícita de tipo regla de patrón con YACC: Para (re)generar los archivos del analizador sintáctico (parser) $(OBJDIR)%.tab.c, $(OBJDIR)%.tab.h y $(OBJDIR)%.tab.output desde $(srcdir)%.y
$(PERCENT-SIGNS-AND-SPACES-ESCAPED_OBJDIR)%.tab.c $(PERCENT-SIGNS-AND-SPACES-ESCAPED_OBJDIR)%.tab.h $(PERCENT-SIGNS-AND-SPACES-ESCAPED_OBJDIR)%.output: $$(call escapar_espacios,$$(srcdir)%.y) | $$(TRAILING-SLASH-REMOVED-AND-SPACES-ESCAPED_OBJDIR)
ifneq ($(PRINT_ONLY),0)
	@printf "  * Se debe (re)construir el objetivo \"%s\". Sus dependencias que son mas recientes son: %s\n" "$(call escapar_simbolo_pesos_conforme_a_shell,$@)" "$(call escapar_simbolo_pesos_conforme_a_shell,$?)"
else
	@printf "\n<<< YACC: (Re)generando los archivos del analizador sintactico (parser): \"%s\" [WARNINGS_YACC: $(WARNINGS_YACC_ACTIVATION) | DEBUG_YACC: $(DEBUG_YACC_ACTIVATION)] >>>\n" "$(call escapar_simbolo_pesos_conforme_a_shell,$(shell printf "%s" "$(call escapar_simbolo_pesos_conforme_a_shell,$<)" | sed -e 's?.*/??' -e 's?\(.*\)\.y?$(SINGLE-QUOTES-ESCAPED_OBJDIR)\1<.tab.c><.tab.h><.output>?' ;))"
	@$(call sh_comprobar_existencia_y_mostrar_ruta_y_version_comando,YACC,--version)
	$(YACC) $(YFLAGS) -d -v -o"$(call escapar_simbolo_pesos_conforme_a_shell,$(shell printf "%s" "$(call escapar_simbolo_pesos_conforme_a_shell,$<)" | sed -e 's?.*/??' -e 's?\(.*\)\.y?$(SINGLE-QUOTES-ESCAPED_OBJDIR)\1.tab.c?' ;))" "$(call escapar_simbolo_pesos_conforme_a_shell,$<)"
	@printf "<<< Realizado >>>\n"
endif

# Regla implícita de tipo regla de patrón con LEX + CC: Para (re)generar el archivo objeto $(OBJDIR)%.lex.yy.o desde $(OBJDIR)%.lex.yy.c
$(PERCENT-SIGNS-AND-SPACES-ESCAPED_OBJDIR)%.lex.yy.o: $$(call escapar_espacios,$$(OBJDIR)%.lex.yy.c) $$(call escapar_espacios,$$(srcdir)%.l) $$(call escapar_espacios,$$(DEPDIR)%.lex.yy.d) | $$(TRAILING-SLASH-REMOVED-AND-SPACES-ESCAPED_DEPDIR) $$(TRAILING-SLASH-REMOVED-AND-SPACES-ESCAPED_OBJDIR) $$(call sin_necesidad_de_comillas_dobles,$$(YDEFS))
ifeq ($(findstring t,$(firstword -$(MAKEFLAGS))),)
ifneq ($(PRINT_ONLY),0)
	@printf "  * Se debe (re)construir el objetivo \"%s\". Sus dependencias que son mas recientes son: %s\n" "$(call escapar_simbolo_pesos_conforme_a_shell,$@)" "$(call escapar_simbolo_pesos_conforme_a_shell,$?)"
else
	$(call receta_para_.d,$(call escapar_simbolo_pesos_conforme_a_shell,$(shell printf "%s" "$(call escapar_simbolo_pesos_conforme_a_shell,$@)" | sed -e 's?.*/??' -e 's?\(.*\)\.o?$(SINGLE-QUOTES-ESCAPED_DEPDIR)\1?' ;)))
	@printf "\n<<< LEX->CC: (Re)generando el archivo objeto: \"%s\" [WARNINGS_CC: $(WARNINGS_CC_ACTIVATION) | DEBUG_CC: $(DEBUG_CC_ACTIVATION)] >>>\n" "$(call escapar_simbolo_pesos_conforme_a_shell,$@)"
	@$(call sh_comprobar_existencia_y_mostrar_ruta_y_version_comando,CC,--version)
	$(CC) $(CPPFLAGS) $(CFLAGS) $(LOBJS_CFLAGS) -c -o"$(call escapar_simbolo_pesos_conforme_a_shell,$@)" "$(call escapar_simbolo_pesos_conforme_a_shell,$<)"
	@printf "<<< Realizado >>>\n"
endif
else
	+touch "$(call escapar_simbolo_pesos_conforme_a_shell,$(shell printf "%s" "$(call escapar_simbolo_pesos_conforme_a_shell,$@)" | sed -e 's?.*/??' -e 's?\(.*\)\.o?$(SINGLE-QUOTES-ESCAPED_DEPDIR)\1.d?' ;))"
	+touch "$(call escapar_simbolo_pesos_conforme_a_shell,$@)"
endif

# Regla implícita de tipo regla de patrón con LEX: Para (re)generar el archivo del analizador léxico (scanner) $(OBJDIR)%.lex.yy.c desde $(srcdir)%.l
$(PERCENT-SIGNS-AND-SPACES-ESCAPED_OBJDIR)%.lex.yy.c: $$(call escapar_espacios,$$(srcdir)%.l) | $$(TRAILING-SLASH-REMOVED-AND-SPACES-ESCAPED_OBJDIR)
ifneq ($(PRINT_ONLY),0)
	@printf "  * Se debe (re)construir el objetivo \"%s\". Sus dependencias que son mas recientes son: %s\n" "$(call escapar_simbolo_pesos_conforme_a_shell,$@)" "$(call escapar_simbolo_pesos_conforme_a_shell,$?)"
else
	@printf "\n<<< LEX: (Re)generando el archivo del analizador lexico (scanner): \"%s\" [WARNINGS_LEX: $(WARNINGS_LEX_ACTIVATION) | DEBUG_LEX: $(DEBUG_LEX_ACTIVATION)] >>>\n" "$(call escapar_simbolo_pesos_conforme_a_shell,$@)"
	@$(call sh_comprobar_existencia_y_mostrar_ruta_y_version_comando,LEX,--version)
	$(LEX) $(LFLAGS) -o"$(call escapar_simbolo_pesos_conforme_a_shell,$@)" "$(call escapar_simbolo_pesos_conforme_a_shell,$<)"
	@printf "<<< Realizado >>>\n"
endif

# Regla implícita de tipo regla de patrón con CC: Para (re)generar el archivo objeto $(OBJDIR)%.o desde $(srcdir)%.c
$(PERCENT-SIGNS-AND-SPACES-ESCAPED_OBJDIR)%.o: $$(call escapar_espacios,$$(srcdir)%.c) $$(call escapar_espacios,$$(DEPDIR)%.d) | $$(TRAILING-SLASH-REMOVED-AND-SPACES-ESCAPED_DEPDIR) $$(TRAILING-SLASH-REMOVED-AND-SPACES-ESCAPED_OBJDIR)
ifeq ($(findstring t,$(firstword -$(MAKEFLAGS))),)
ifneq ($(PRINT_ONLY),0)
	@printf "  * Se debe (re)construir el objetivo \"%s\". Sus dependencias que son mas recientes son: %s\n" "$(call escapar_simbolo_pesos_conforme_a_shell,$@)" "$(call escapar_simbolo_pesos_conforme_a_shell,$?)"
else
	$(call receta_para_.d,$(call escapar_simbolo_pesos_conforme_a_shell,$(shell printf "%s" "$(call escapar_simbolo_pesos_conforme_a_shell,$@)" | sed -e 's?.*/??' -e 's?\(.*\)\.o?$(SINGLE-QUOTES-ESCAPED_DEPDIR)\1?' ;)))
	@printf "\n<<< CC: (Re)generando el archivo objeto: \"%s\" [WARNINGS_CC: $(WARNINGS_CC_ACTIVATION) | DEBUG_CC: $(DEBUG_CC_ACTIVATION)] >>>\n" "$(call escapar_simbolo_pesos_conforme_a_shell,$@)"
	@$(call sh_comprobar_existencia_y_mostrar_ruta_y_version_comando,CC,--version)
	$(CC) $(CPPFLAGS) $(CFLAGS) $(COBJS_CFLAGS) -c -o"$(call escapar_simbolo_pesos_conforme_a_shell,$@)" "$(call escapar_simbolo_pesos_conforme_a_shell,$<)"
	@printf "<<< Realizado >>>\n"
endif
else
	+touch "$(call escapar_simbolo_pesos_conforme_a_shell,$(shell printf "%s" "$(call escapar_simbolo_pesos_conforme_a_shell,$@)" | sed -e 's?.*/??' -e 's?\(.*\)\.o?$(SINGLE-QUOTES-ESCAPED_DEPDIR)\1.d?' ;))"
	+touch "$(call escapar_simbolo_pesos_conforme_a_shell,$@)"
endif

# Regla implícita de tipo regla de patrón con una receta vacía que no hace nada: Para evitar errores al momento de incluir los otros makefiles con prerequisitos producidos automáticamente, respecto de los objetivos $(DEPDIR)%.d , $(DEPDIR)%.tab.d y $(DEPDIR)%.lex.yy.d , los cuales son creados como efecto secundario de las recetas para los objetivos $(OBJDIR)%.o , $(OBJDIR)%.tab.o y $(OBJDIR)%.lex.yy.o respectivamente: si el objetivo no existe la receta vacía asegura de que make no reclamará sobre que no sabe cómo construir el objetivo, y sólo asumirá de que el objetivo está obsoleto
%.d: ;

# Regla implícita de tipo regla de patrón con una receta vacía que no hace nada: Para evitar errores al momento de incluir los otros makefiles con prerequisitos producidos automáticamente, respecto de los objetivos %.h : si el objetivo no existe la receta vacía asegura de que make no reclamará sobre que no sabe cómo construir el objetivo, y sólo asumirá de que el objetivo está obsoleto
%.h: ;

# Regla explícita con objetivos independientes para crear los directorios en donde se ubican los archivos intermedios, el binario, y los makefiles producidos correspondientemente, si alguno no existiera
$(call escapar_simbolos_de_porcentaje_conforme_a_make,$(TRAILING-SLASH-REMOVED-AND-SPACES-ESCAPED_OBJDIR)) $(call escapar_simbolos_de_porcentaje_conforme_a_make,$(TRAILING-SLASH-REMOVED-AND-SPACES-ESCAPED_bindir)) $(call escapar_simbolos_de_porcentaje_conforme_a_make,$(TRAILING-SLASH-REMOVED-AND-SPACES-ESCAPED_DEPDIR)):
ifneq ($(PRINT_ONLY),0)
	@printf "  * Se debe construir el objetivo \"%s\".\n" "$(call escapar_simbolo_pesos_conforme_a_shell,$@)"
else
	+@printf "\n<<< Creando el directorio: \"%s\" >>>\n" "$(call escapar_simbolo_pesos_conforme_a_shell,$@)"
	+$(MKDIR_P) "$(call escapar_simbolo_pesos_conforme_a_shell,$@)"
	+@printf "<<< Realizado >>>\n"
endif