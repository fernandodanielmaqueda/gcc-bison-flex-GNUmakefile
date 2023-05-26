# gcc-bison-flex-GNUmakefile, versión 2023.05.26-001-pre
# Este makefile sirve para construir, ejecutar y depurar proyectos en lenguaje C (archivos *.c con o sin archivos *.h asociados), proyectos en lenguaje C con flex (archivos *.l), proyectos en lenguaje C con bison (archivos *.y), y proyectos en lenguaje C con bison en conjunto con flex (así como proyectos que utilicen programas similares, como ser clang, yacc y lex)
# Para obtener más información visite el repositorio <https://github.com/fernandodanielmaqueda/gcc-bison-flex-GNUmakefile>

# Copyright (C) 2022-2023 Fernando Daniel Maqueda <https://github.com/fernandodanielmaqueda/>
# This is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
# This is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
# You should have received a copy of the GNU General Public License along with this. If not, see <https://www.gnu.org/licenses/>.

# Nombre del proyecto/programa/binario
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

# Depurador a usar y las opciones a pasarle, respectivamente
GDB:=gdb
GDBFLAGS:=

# Agregar acá las opciones que controlan el preprocesador del lenguaje C
CPPFLAGS=-I"$(DOLLAR-SIGNS-ESCAPED_OBJDIR)" -I"$(DOLLAR-SIGNS-ESCAPED_SRCDIR)"
# 	Por ejemplo, aquí se ingresan las opciones -I"Directorio" para las búsquedas sobre directorios, las cuales sirven para indicar los directorios en donde se encuentran los archivos de cabecera (header files) (*.h) DEFINIDOS POR EL USUARIO de los que dependen los archivos de C (*.c), YACC (*.y), y/o LEX (*.l): es decir, sólo aquellos que están entre comillas dobles (""), como ser: #include "misfunciones.h"; no los que están entre corchetes angulares (<>), como #include <math.h>)

# Agregar acá las opciones para enlazar
#	Por ejemplo, añadir las opciones -L (en LDFLAGS) y -l (en LDLIBS) para CC, las cuales este a su vez se los pasa al enlazador ld y sirven para enlazar con las bibliotecas necesarias (tanto estáticas (lib*.a) como dinámicas (lib*.so))
# 	Esto se usa cuando el compilador no encuentra algún archivo de cabecera (header file) (*.h) DEL SISTEMA: es decir, sólo aquellos que están entre corchetes angulares (<>), como #include <math.h>; no los que están entre comillas dobles (""), como ser: #include "misfunciones.h")
# 	Para eso poner -lNombreBiblioteca en LDLIBS (si el compilador ya puede encontrar por si solo el archivo libNombreBiblioteca.aÓ.so) y/o poner -L"ruta/relativa/desde/este/makefile/Ó/absoluta/hasta/un/directorio/que/contiene/archivos/libNombreBiblioteca.aÓ.so" en LDFLAGS y luego -lNombreBiblioteca en LDLIBS (para indicar la ubicación del archivo libNombreBiblioteca.aÓ.so manualmente).
LDFLAGS:=
LDLIBS:=-lm
# 	Por ejemplo, -lm para incluir la biblioteca libm.a la cual contiene <math.h>, <complex.h> y <fenv.h>; y -L"lib" -L"C:/Users/Mi Usuario/Documents/Ejemplo - Directorio_De_Mi_Proyecto (1)" para indicar, por ruta relativa (desde este makefile) y por ruta absoluta, respectivamente, dos directorios que contienen bibliotecas
# 	Más abajo se agregan -lfl y -ly para incluir las bibliotecas libfl.a y liby.a para LEX y YACC según sea necesario. Si el compilador no encontrara alguno de esos archivos, se los debe indicar manualmente agregándolos en LDFLAGS.

# Acá se configuran las opciones para requerir o suprimir las advertencias (warnings) de CC según éstas se encuentren habilitadas o deshabilitadas
# 	Por defecto los warnings de CC se habilitan: en caso de que no se le defina un valor a WARNINGS_CC a un comando de make al generar un archivo intermedio y/o al construir un binario, es como si se le agregara WARNINGS_CC=1
# 	Si se quieren deshabilitar los warnings de CC se debe agregar WARNINGS_CC=0 al comando de make. Por ejemplo: <make WARNINGS_CC=0>, <make all WARNINGS_CC=0> y <make clean all WARNINGS_CC=0>
WARNINGS_CC?=1
ifneq ($(WARNINGS_CC),0)
WARNINGS_CC_ACTIVATION:=Si
# 	Agregar a continuación las opciones que se le quieran pasar a CC cuando se habiliten sus warnings (WARNINGS_CC=1), como ser, entre otras:
#		-Wall (para mostrar la mayoría de los tipos de warnings)
#		-Wextra (para mostrar aún más tipos de warnings que -Wall)
#		-Werror (para tratar a todos los warnings como errores)
#		-Wfatal-errors (para que no siga con la compilación tras ocurrir algún error, en lugar de intentar continuar e imprimir más mensajes de error)
#		-Wpedantic (para que muestre todos los warnings demandados estrictamente por el ISO C; rechace todos los programas que usen extensiones del lenguaje prohibidas, y algunos otros programas que no sigan el ISO C. Para ISO C, sigue la versión del estándar ISO C especificado por cualquier opción -std especificada)
#		-pedantic-errors (da un error donde sea que el estándar base requiera un diagnóstico, en algunos casos en donde hay comportamiento indefinido en tiempo de compilación y en otros casos que no previenen la compilación de programas que son válidos de acuerdo con el estándar. Esta opción NO es equivalente a la opción -Werror=pedantic, ya que hay errores habilitados por esta opción y no habilitados por la última y viceversa)
#		-Wno-unused-function (para que NO muestre un warning cuando una función con static como especificador de clase de almacenamiento es declarada pero no definida o que no es utilizada)
#		-Wno-unused-but-set-variable (para que NO muestre un warning cuando una variable local es inicializada pero no es utilizada)
#		-Wno-unused-variable (para que NO muestre un warning cuando una variable local o con static como especificador de clase de almacenamiento es declarada no es utilizada)
CFLAGS:=-Wall -Wpedantic
else
WARNINGS_CC_ACTIVATION:=No
# 	Agregar a continuación las opciones que se le quieran pasar a CC cuando se deshabiliten sus warnings (WARNINGS_CC=0), como ser -w (para no mostrar ningún warning)
CFLAGS:=
endif

# Acá se configuran los warnings de YACC según se encuentren habilitados o deshabilitados
# 	Por defecto los warnings de YACC se habilitan: en caso de que no se le defina un valor a WARNINGS_YACC a un comando de make al generar un archivo intermedio y/o al construir un binario, es como si se le agregara WARNINGS_YACC=1
# 	Si se quieren deshabilitar los warnings de YACC se debe agregar WARNINGS_YACC=0 al comando de make. Por ejemplo: <make WARNINGS_YACC=0>, <make all WARNINGS_YACC=0> y <make clean all WARNINGS_YACC=0>
WARNINGS_YACC?=1
ifneq ($(WARNINGS_YACC),0)
WARNINGS_YACC_ACTIVATION:=Si
# 	Agregar a continuación las opciones que se le quieran pasar a YACC cuando se habiliten sus warnings (WARNINGS_YACC=1), como ser -Wall (para mostrar todos los warnings), -Werror (para tratar a los warnings como errores), etc.
YFLAGS:=-Wall
else
WARNINGS_YACC_ACTIVATION:=No
# 	Agregar a continuación las opciones que se le quieran pasar a YACC cuando se deshabiliten sus warnings (WARNINGS_YACC=0), como ser -Wnone (para no mostrar ningún warning)
YFLAGS:=
endif

# Acá se configuran los warnings de LEX según se encuentren habilitados o deshabilitados
# 	Por defecto los warnings de LEX se habilitan: en caso de que no se le defina un valor a WARNINGS_LEX a un comando de make al generar un archivo intermedio y/o al construir un binario, es como si se le agregara WARNINGS_LEX=1
# 	Si se quieren deshabilitar los warnings de LEX se debe agregar WARNINGS_LEX=0 al comando de make. Por ejemplo: <make WARNINGS_LEX=0>, <make all WARNINGS_LEX=0> y <make clean all WARNINGS_LEX=0>
WARNINGS_LEX?=1
ifneq ($(WARNINGS_LEX),0)
WARNINGS_LEX_ACTIVATION:=Si
# 	Agregar a continuación las opciones que se le quieran pasar a LEX cuando se habiliten sus warnings (WARNINGS_LEX=1)
LFLAGS:=
else
WARNINGS_LEX_ACTIVATION:=No
# 	Agregar a continuación las opciones que se le quieran pasar a LEX cuando se deshabiliten sus warnings (WARNINGS_LEX=0), como ser -w (para suprimir todos los mensajes de warning)
LFLAGS:=
endif

# Acá se configuran los símbolos de depuración de CC según se encuentren habilitados o deshabilitados
# 	Por defecto los símbolos de depuración de CC se habilitan: en caso de que no se le defina un valor a DEBUG_CC al comando de make, es como si se le agregara DEBUG_CC=1
# 	Si se quieren deshabilitar los símbolos de depuración de CC, se debe agregar DEBUG_CC=0 al comando de make. Por ejemplo: <make DEBUG_CC=0>, <make all DEBUG_CC=0> y <make clean all DEBUG_CC=0>
DEBUG_CC?=1
ifneq ($(DEBUG_CC),0)
DEBUG_CC_ACTIVATION:=Si
# 	Agregar a continuación las opciones que se le quieran pasar a CC cuando se habiliten sus símbolos de depuración (DEBUG_CC=1), como ser -g (produce información de depuración en el formato nativo del sistema operativo (stabs, COFF, XCOFF, o DWARF) para que pueda depurarse)
CFLAGS+=-g3
else
DEBUG_CC_ACTIVATION:=No
# 	Agregar a continuación las opciones que se le quieran pasar a CC cuando se deshabiliten sus símbolos de depuración (DEBUG_CC=0)
CFLAGS+=
endif

# Acá se configuran los símbolos de depuración de YACC según se encuentren habilitados o deshabilitados
# 	Por defecto los símbolos de depuración de YACC se deshabilitan: en caso de que no se le defina un valor a DEBUG_YACC al comando de make, es como si se le agregara DEBUG_YACC=0
# 	Si se quieren habilitar los símbolos de depuración de YACC, se debe agregar DEBUG_YACC=1 al comando de make. Por ejemplo: <make DEBUG_YACC=1>, <make all DEBUG_YACC=1> y <make clean all DEBUG_YACC=1>
DEBUG_YACC?=0
ifneq ($(DEBUG_YACC),0)
DEBUG_YACC_ACTIVATION:=Si
# 	Agregar a continuación las opciones que se le quieran pasar a YACC cuando se habiliten sus símbolos de depuración (DEBUG_YACC=1), como ser -t (define la macro YYDEBUG a 1 si no se la define)
YFLAGS+=-t
# 	Cuando se habiliten los símbolos de depuración de YACC (DEBUG_YACC=1), y sólo cuando CC vaya a generar el archivo objeto desde el archivo de C generado por YACC (de *.tab.c a *.tab.o) se le pasará este flag -D para que defina la macro YYDEBUG en un valor entero distinto de 0 lo cual permite la depuracion de YACC
C_YOBJFLAGS:=-DYYDEBUG=1
else
DEBUG_YACC_ACTIVATION:=No
# 	Agregar a continuación las opciones que se le quieran pasar a YACC cuando se deshabiliten sus símbolos de depuración (DEBUG_YACC=0)
YFLAGS+=
# 	Cuando se deshabiliten los símbolos de depuración de YACC (DEBUG_YACC=0), y sólo cuando CC vaya a generar el archivo objeto desde el archivo de C generado por YACC (de *.tab.c a *.tab.o) se le pasará este flag -D para que defina la macro YYDEBUG en el valor entero 0 lo cual NO permite la depuracion de YACC
C_YOBJFLAGS:=-DYYDEBUG=0
endif

# Acá se configuran los símbolos de depuración de LEX según se encuentren habilitados o deshabilitados
# 	Por defecto los símbolos de depuración de LEX se deshabilitan: en caso de que no se le defina un valor a DEBUG_LEX al comando de make, es como si se le agregara DEBUG_LEX=0
# 	Si se quieren habilitar los símbolos de depuración de LEX, se debe agregar DEBUG_LEX=1 al comando de make. Por ejemplo: <make DEBUG_LEX=1>, <make all DEBUG_LEX=1> y <make clean all DEBUG_LEX=1>
DEBUG_LEX?=0
ifneq ($(DEBUG_LEX),0)
DEBUG_LEX_ACTIVATION:=Si
# 	Agregar a continuación las opciones que se le quieran pasar a LEX cuando se habiliten sus símbolos de depuración (DEBUG_LEX=1), como ser -d (hace que el analizador generado se ejecute en modo de depuración)
LFLAGS+=-d
else
DEBUG_LEX_ACTIVATION:=No
# 	Agregar a continuación las opciones que se le quieran pasar a LEX cuando se deshabiliten sus símbolos de depuración (DEBUG_LEX=0)
LFLAGS+=
endif

# Agregar acá otras opciones que se le quieran pasar siempre a CC, YACC y LEX además de las opciones que ya están, según corresponda
CFLAGS+=-std=c99
#	Para CC, por ejemplo:
# 		- Opciones controlando el dialecto del lenguaje C: entre ellas, -ansi ó -std=c90 para C90, -std=c99 para C99, -std=c11 para C11, -std=c18 para C18, etc.
#		- Opciones para controlar el formato de los mensajes de diagnóstico (warnings)
YFLAGS+=--report=state --report=lookahead --report=itemset
# 	Para YACC, por ejemplo, --report=state (para que se incluya en el archivo *.output generado una descripción de la gramática, conflictos tanto resueltos como sin resolver, y el autómata LALR), --report=lookahead (para incrementar la descripción del autómata con cada conjunto de tokens siguientes de cada regla sobre el archivo *.output generado), --report=itemset (para que se incluya en el archivo *.output generado una descripción de la gramática, conflictos tanto resueltos como sin resolver, y el autómata LALR), --report=lookahead (para incrementar la descripción del autómata con el conjunto completo de ítems derivados para cada estado, en lugar de solamente el denominado núcleo sobre el archivo *.output generado), etc.
LFLAGS+=

# Agregar acá otras opciones que se le quieran pasar siempre a CC sólo al generar los archivos objeto desde los de C fuentes (de *.c a *.o), desde los archivos de C generados por YACC (de *.tab.c a *.tab.o) y desde los archivos de C generados por LEX (de *.lex.yy.c a *.lex.yy.o) además de las opciones que ya están, según corresponda
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

# Comprueba que la función $(shell ...) se ejecute correctamente. Una de las posibles causas por las que que falla es utilizar alguna de las opciones '-n', '--just-print', '--dry-run' y/o '--recon' al invocar a make, con las cuales se arroja un error similar al siguiente: process_begin: CreateProcess(NULL, "", ...) failed.
ifeq ($(shell echo foo ;),)
$(error ERROR: La funcion shell de GNU Make, necesaria para que pueda funcionar este makefile, no se puede ejecutar correctamente)
endif

# Comprueba que el comando <command> se pueda encontrar
ifeq ($(shell command -v cd ;),)
$(error ERROR: El comando <command>, necesario para que pueda funcionar este makefile, no esta instalado y/o no se puede encontrar y ejecutar)
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
UNAME_S:=$(shell uname)
SYSTEM:=$(patsubst CYGWIN_NT%,CYGWIN_NT,$(UNAME_S))

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
$(foreach variable,PROGRAM SRCDIR OBJDIR BINDIR DEPDIR,$(eval DOLLAR-SIGNS-ESCAPED_$(variable):=$$(call escapar_simbolo_pesos_conforme_a_shell,$$($$(variable)))))

# Define nuevas variables a partir de otras ya existentes pero con secuencias de escape para las comillas simples para que sus valores puedan sean utilizados dentro de otras comillas simples
$(foreach variable,OBJDIR DEPDIR,$(eval SINGLE-QUOTES-ESCAPED_$(variable):=$$(call escapar_comillas_simples_dentro_de_otras_comillas_simples,$$($$(variable)))))

# Define nuevas variables a partir de otras ya existentes pero con secuencias de escape para los espacios y con secuencias de escape para los símbolos de porcentaje conforme a make para que sus valores puedan sean utilizados directamente en los objetivos de determinadas reglas de make
$(foreach variable,OBJDIR DEPDIR,$(eval PERCENT-SIGNS-AND-SPACES-ESCAPED_$(variable):=$$(call escapar_espacios,$$(call escapar_simbolos_de_porcentaje_conforme_a_make,$$($$(variable))))))

# Define nuevas variables a partir de otras ya existentes pero sin sus barras traseras y con secuencias de escape para los espacios para que sus valores puedan sean utilizados directamente en los prerequisitos de sólo orden de determinadas reglas de make
$(foreach variable,OBJDIR BINDIR DEPDIR,$(eval TRAILING-SLASH-REMOVED-AND-SPACES-ESCAPED_$(variable):=$$(call escapar_espacios,$$(shell printf "%s" "$$(DOLLAR-SIGNS-ESCAPED_$$(variable))" | sed 's?/$$$$??' ;))))

# Produce los nombres de todos los archivos objeto a generar de acuerdo con los archivos fuente de C ($(SRCDIR)*.c), YACC ($(SRCDIR)*.y) y LEX ($(SRCDIR)*.l) que se encuentren, respectivamente
COBJS:=$(shell ls "$(DOLLAR-SIGNS-ESCAPED_SRCDIR)"*.c 2>/dev/null | sed -e 's?.*/??' -e 's?\(.*\)\.c?"$(SINGLE-QUOTES-ESCAPED_OBJDIR)\1.o"?' ;)
YOBJS:=$(shell ls "$(DOLLAR-SIGNS-ESCAPED_SRCDIR)"*.y 2>/dev/null | sed -e 's?.*/??' -e 's?\(.*\)\.y?"$(SINGLE-QUOTES-ESCAPED_OBJDIR)\1.tab.o"?' ;)
LOBJS:=$(shell ls "$(DOLLAR-SIGNS-ESCAPED_SRCDIR)"*.l 2>/dev/null | sed -e 's?.*/??' -e 's?\(.*\)\.l?"$(SINGLE-QUOTES-ESCAPED_OBJDIR)\1.lex.yy.o"?' ;)

# Para producir los nombres de todos los archivos de cabecera con definiciones de YACC a generar ($(OBJDIR)*.tab.h) de acuerdo con los nombres ya determinados de todos los archivos objeto de YACC también a generar ($(OBJDIR)*.tab.o)
YDEFS=$(shell printf "%s" '$(call escapar_comillas_simples_dentro_de_otras_comillas_simples,$(YOBJS))' | sed 's?"\([^"]*\)\.tab\.o"?"\1.tab.h"?g' ;)

# Acciones de acuerdo con los archivos fuente presentes en el proyecto
ifneq ($(YOBJS)$(LOBJS),)
ifneq ($(YOBJS),)
# 	Agrega el flag -ly para CC (y este a su vez se lo pasa al enlazador LD) para que incluya la biblioteca liby.a para YACC, ya que es necesaria. Si el enlazador no pudiera encontrar ese archivo, se lo debe indicar manualmente agregándolo en LDFLAGS.
LDLIBS+=-ly
endif
ifneq ($(LOBJS),)
# 	Agrega el flag -lfl para CC (y este a su vez se lo pasa al enlazador LD) para que incluya la biblioteca libfl.a para LEX, ya que es necesaria. Si el enlazador no pudiera encontrar ese archivo, se lo debe indicar manualmente agregándolo en LDFLAGS.
LDLIBS+=-lfl
endif
else
ifeq ($(COBJS),)
# 	Alerta si no ha encontrado ningún archivo fuente de C ($(SRCDIR)*.c), YACC ($(SRCDIR)*.y) ni de LEX ($(SRCDIR)*.l)
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
	$(CC) $(CPPFLAGS) -MM "$(call escapar_simbolo_pesos_conforme_a_shell,$<)" >> "$(1).tmp" || { $(RM) "$(1).tmp" ; false ; }
	sed -e ':a' -e '3s?^\([^:]*\)\(^\|[^\\]\)%?\1\2\\\%?' -e 't a' -e 's?\(^\|[^$$]\)\$$\($$\|[^$$]\)?\1$$$$\2?g' -e 's?\(^\|[^\\]\)#?\1\\\#?g' < "$(1).tmp" > "$(1).d"
	$(RM) "$(1).tmp"
	@printf "<<< Realizado >>>\n"
endef

# Define una secuencia de comandos enlatada la cual fuerza la eliminación de un binario si este ya existiera, por si el archivo está en uso, ya que esto impediría su construcción
define forzar_eliminacion_si_ya_existiera_el_binario
	if [ -f "$(1)" ]; then \
		printf "\n<<< Eliminando el binario ya existente: \"%s\" >>>\n" "$(1)" ; \
		set -x ; \
			$(RM) "$(1)" ; \
		{ set +x ; } 2>/dev/null ; \
		printf "<<< Realizado >>>\n" ; \
	fi ;
endef

# Define una secuencia de comandos enlatada que muestra una nota si la depuración de YACC está habilitada
define mostrar_nota_sobre_yacc_si_su_depuracion_esta_habilitada
	if [ -n '$(call escapar_comillas_simples_dentro_de_otras_comillas_simples,$(YOBJS))' ] && [ "X0" != "X$(DEBUG_YACC)" ]; then \
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
	printf \"  * Para cerrar la ventana de la sesion, presione <Ctrl>+<b>, seguidamente presione <x> y por ultimo presione <y>\n\" ; \
	printf \"  * Para apartar la sesion con sus ventanas sin cerrarla [detach], presione <Ctrl>+<b> y seguidamente presione <d>\n\" ; \
	printf \"  * Para alternar entre las sesiones abiertas de tmux, presione <Ctrl>+<b> y seguidamente presione <s>\n\" ; \
	printf \"  * Para alternar entre las ventanas de las sesiones abiertas de tmux, presione <Ctrl>+<b> y seguidamente presione <w>\n\" ; \
	printf \"  * Para iniciar el modo desplazamiento por la ventana, presione <Ctrl>+<b> y seguidamente presione <[>\n\" ; \
	printf \"     \t(con la distribucion de teclado latinoamericano, <[> es <Shift>+<{>)\n\" ; \
	printf \"  * Para finalizar el modo desplazamiento por la ventana, presione <q>\n\" ; \
	printf \"\nPresione <Enter> para continuar...\n\" ; \
	read ;
endef

# Para eliminar la lista de sufijos conocidos que make genera por defecto
.SUFFIXES:
# 	Esto se efectúa para cancelar las reglas implícitas predefinidas por make, ya que ninguna de ellas se utilizará y además con esto se ahorra en tiempo de ejecución

# Para especificar los objetivos que no generan archivos con ese mismo nombre para que se ejecuten siempre por más de que los archivos puedan llegar a existir
.PHONY: all run open clean cli_bin_debug_run cli_bin_debug_open empty
# 	La receta de una regla siempre se ejecutará si tiene como prerequisito de tipo normal a un target que sea .PHONY

# Para que make elimine el objetivo de una regla si ya se ha modificado y su receta finaliza con un estado de salida con valor no cero
.DELETE_ON_ERROR:

# A partir de aquí se configura para el solamente imprimir los objetivos que deben ser (re)construidos según se encuentre habilitado o deshabilitado
# 	Por defecto el solamente imprimir los objetivos que deben ser (re)construidos está deshabilitado: en caso de que no se le defina un valor a PRINT al comando de make, es como si se le agregara PRINT=0
# 	Si se quiere habilitar el solamente imprimir los objetivos que deben ser (re)construidos, se debe agregar PRINT=1 al comando de make. Por ejemplo: <make PRINT=1> y <make all PRINT=1>
PRINT_TARGETS?=0
ifneq ($(PRINT_TARGETS),0)
$(info La variable PRINT_TARGETS del makefile tiene valor distinto de 0)
$(info Por lo tanto solamente se imprimiran los objetivos que deben ser reconstruidos:)
endif
# Esto es útil para depurar el makefile y/o visualizar qué objetivos necesitan ser re(hechos) antes de que sean (re)construidos, ya sea porque no existen o porque han quedado obsoletos por modificaciones en los archivos fuente.

# Acá se configura el 'make all' según la regeneración de los archivos secundarios al ser eliminados se encuentre habilitada o deshabilitada
# 	Por defecto la regeneración de los archivos secundarios está habilitada
REGENERATE_SECONDARY:=1
ifneq ($(REGENERATE_SECONDARY),0)
# 	Para construir todos los archivos intermedios y el binario ya sea con sus SRCDIR*.l y/o SRCDIR*.y como fuentes, o ya sea con sus SRCDIR*.c como fuentes. Se ejecuta con <make> (por ser la meta por defecto) o <make all>
all: $(call sin_necesidad_de_comillas_dobles,$(COBJS)) $(call sin_necesidad_de_comillas_dobles,$(shell printf "%s" '$(call escapar_comillas_simples_dentro_de_otras_comillas_simples,$(YOBJS))' | sed 's?"\([^"]*\)\.tab\.o"?"\1.tab.c" "\1.tab.h" "\1.output" "\1.tab.o"?g' ;)) $(call sin_necesidad_de_comillas_dobles,$(shell printf "%s" '$(call escapar_comillas_simples_dentro_de_otras_comillas_simples,$(LOBJS))' | sed 's?"\([^"]*\)\.lex\.yy\.o"?"\1.lex.yy.c" "\1.lex.yy.o"?g' ;)) $(call escapar_espacios,$(BINDIR)$(PROGRAM)$(EXEEXT)) ;
ifneq ($(PRINT_TARGETS),0)
	@printf "  * Se debe (re)construir el objetivo '%s'.\n" "$@"
endif
else
# 	Para construir el binario ya sea con sus SRCDIR*.l y/o SRCDIR*.y como fuentes, o ya sea con sus SRCDIR*.c como fuentes. Se ejecuta con <make> (por ser la meta por defecto) o <make all>
all: $(call escapar_espacios,$(BINDIR)$(PROGRAM)$(EXEEXT)) ;
ifneq ($(PRINT_TARGETS),0)
	@printf "  * Se debe (re)construir el objetivo '%s'.\n" "$@"
endif
# 	Define explícitamente determinados objetivos como archivos secundarios; estos son tratados como archivos intermedios (aquellos que son creados por regla prerequisito de otra regla), excepto que nunca son eliminados automáticamente al terminar
.SECONDARY: $(call sin_necesidad_de_comillas_dobles,$(COBJS)) $(call sin_necesidad_de_comillas_dobles,$(shell printf "%s" '$(call escapar_comillas_simples_dentro_de_otras_comillas_simples,$(YOBJS))' | sed 's?"\([^"]*\)\.tab\.o"?"\1.tab.c" "\1.output" "\1.tab.o"?g' ;)) $(call sin_necesidad_de_comillas_dobles,$(shell printf "%s" '$(call escapar_comillas_simples_dentro_de_otras_comillas_simples,$(LOBJS))' | sed 's?"\([^"]*\)\.lex\.yy\.o"?"\1.lex.yy.c" "\1.lex.yy.o"?g' ;))
endif

# Regla explícita que tiene como objetivo este mismo makefile para evitar que make intente rehacerlo, ya que no es necesario hacerlo, esto con el propósito de optimizar el tiempo de inicialización
GNUmakefile:: ;

# Regla explícita para ejecutar el binario que se construye desde la misma ventana
run:
ifeq ($(PRINT_TARGETS),0)
	@printf "\n=================[ Ejecutar el binario en esta ventana ]=================\n"
	@printf "\n<<< \"%s\" >>>\n" "$(DOLLAR-SIGNS-ESCAPED_BINDIR)$(DOLLAR-SIGNS-ESCAPED_PROGRAM)$(EXEEXT)"
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
else
	@printf "  * Se debe (re)construir el objetivo '%s'.\n" "$@"
endif

# Regla explícita para abrir el binario que se construye en una ventana nueva
open:
ifeq ($(PRINT_TARGETS),0)
	@printf "\n=================[ Ejecutar el binario en una ventana nueva ]=================\n"
	@printf "\n<<< \"%s\" >>>\n" "$(DOLLAR-SIGNS-ESCAPED_BINDIR)$(DOLLAR-SIGNS-ESCAPED_PROGRAM)$(EXEEXT)"
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
else
	@printf "  * Se debe (re)construir el objetivo '%s'.\n" "$@"
endif

# Regla explícita para borrar todos los archivos intermedios y el binario generados al construir
clean:
ifeq ($(PRINT_TARGETS),0)
	@printf "\n=================[ Eliminar todo lo que se genera al construir ]=================\n"
	@if [ -d "$(DOLLAR-SIGNS-ESCAPED_BINDIR)" ]; then \
		if [ -f "$(DOLLAR-SIGNS-ESCAPED_BINDIR)$(DOLLAR-SIGNS-ESCAPED_PROGRAM)$(EXEEXT)" ]; then \
			printf "\n<<< Eliminando el binario: \"%s\" >>>\n" "$(DOLLAR-SIGNS-ESCAPED_BINDIR)$(DOLLAR-SIGNS-ESCAPED_PROGRAM)$(EXEEXT)" ; \
			set -x ; \
				$(RM) "$(DOLLAR-SIGNS-ESCAPED_BINDIR)$(DOLLAR-SIGNS-ESCAPED_PROGRAM)$(EXEEXT)" ; \
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
							$(RM) "$(DOLLAR-SIGNS-ESCAPED_OBJDIR)$$BASENAME$$EXT" ; \
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
							$(RM) "$(DOLLAR-SIGNS-ESCAPED_OBJDIR)$$BASENAME$$EXT" ; \
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
						$(RM) "$$COBJ" ; \
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
						$(RM) "$(DOLLAR-SIGNS-ESCAPED_DEPDIR)$$BASENAME.lex.yy.d" ; \
					{ set +x ; } 2>/dev/null ; \
					printf "<<< Realizado >>>\n" ; \
				fi ; \
				if [ -f "$(DOLLAR-SIGNS-ESCAPED_DEPDIR)$$BASENAME.lex.yy.tmp" ]; then \
					printf "\n<<< Eliminando el archivo temporal: \"%s\" >>>\n" "$(DOLLAR-SIGNS-ESCAPED_DEPDIR)$$BASENAME.lex.yy.tmp" ; \
					set -x ; \
						$(RM) "$(DOLLAR-SIGNS-ESCAPED_DEPDIR)$$BASENAME.lex.yy.tmp" ; \
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
						$(RM) "$(DOLLAR-SIGNS-ESCAPED_DEPDIR)$$BASENAME.tab.d" ; \
					{ set +x ; } 2>/dev/null ; \
					printf "<<< Realizado >>>\n" ; \
				fi ; \
				if [ -f "$(DOLLAR-SIGNS-ESCAPED_DEPDIR)$$BASENAME.tab.tmp" ]; then \
					printf "\n<<< Eliminando el archivo temporal: \"%s\" >>>\n" "$(DOLLAR-SIGNS-ESCAPED_DEPDIR)$$BASENAME.tab.tmp" ; \
					set -x ; \
						$(RM) "$(DOLLAR-SIGNS-ESCAPED_DEPDIR)$$BASENAME.tab.tmp" ; \
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
						$(RM) "$(DOLLAR-SIGNS-ESCAPED_DEPDIR)$$BASENAME.d" ; \
					{ set +x ; } 2>/dev/null ; \
					printf "<<< Realizado >>>\n" ; \
				fi ; \
				if [ -f "$(DOLLAR-SIGNS-ESCAPED_DEPDIR)$$BASENAME.tmp" ]; then \
					printf "\n<<< Eliminando el archivo temporal: \"%s\" >>>\n" "$(DOLLAR-SIGNS-ESCAPED_DEPDIR)$$BASENAME.tmp" ; \
					set -x ; \
						$(RM) "$(DOLLAR-SIGNS-ESCAPED_DEPDIR)$$BASENAME.tmp" ; \
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
else
	@printf "  * Se debe (re)construir el objetivo '%s'.\n" "$@"
endif

# Regla explícita para depurar el binario que se construye desde la misma ventana por medio de una interfaz de línea de comandos (CLI)
cli_bin_debug_run:
ifeq ($(PRINT_TARGETS),0)
	@printf "\n=================[ Depurar el binario en esta ventana por medio de una interfaz de linea de comandos (CLI) ]=================\n"
	@printf "\n<<< \"%s\" >>>\n" "$(DOLLAR-SIGNS-ESCAPED_BINDIR)$(DOLLAR-SIGNS-ESCAPED_PROGRAM)$(EXEEXT)"
	@if [ -f "$(DOLLAR-SIGNS-ESCAPED_BINDIR)$(DOLLAR-SIGNS-ESCAPED_PROGRAM)$(EXEEXT)" ]; then \
		$(call sh_existe_comando,$(GDB)) ; \
		$(call sh_ruta_comando,$(GDB)) ; \
		printf "** Version instalada de $(GDB): %s **\n" "$$($(GDB) --version | sed -n 1p 2>/dev/null)" ; \
		set -x ; \
			cd "$(DOLLAR-SIGNS-ESCAPED_BINDIR)" ; \
			$(GDB) $(GDBFLAGS) "./$(DOLLAR-SIGNS-ESCAPED_PROGRAM)$(EXEEXT)" ; \
			cd - >/dev/null ; \
		{ set +x ; } 2>/dev/null ; \
	else \
		printf "(No existe el binario \"%s\")\n" "$(DOLLAR-SIGNS-ESCAPED_BINDIR)$(DOLLAR-SIGNS-ESCAPED_PROGRAM)$(EXEEXT)" ; \
	fi ;
	@printf "<<< Realizado >>>\n"
	@printf "\n=================[ Finalizado ]=============\n"
else
	@printf "  * Se debe (re)construir el objetivo '%s'.\n" "$@"
endif

# Regla explícita para depurar el binario que se construye en una ventana nueva por medio de una interfaz de línea de comandos (CLI)
cli_bin_debug_open:
ifeq ($(PRINT_TARGETS),0)
	@printf "\n=================[ Depurar el binario en una ventana nueva por medio de una interfaz de linea de comandos (CLI) ]=================\n"
	@printf "\n<<< \"%s\" >>>\n" "$(DOLLAR-SIGNS-ESCAPED_BINDIR)$(DOLLAR-SIGNS-ESCAPED_PROGRAM)$(EXEEXT)"
	@if [ -f "$(DOLLAR-SIGNS-ESCAPED_BINDIR)$(DOLLAR-SIGNS-ESCAPED_PROGRAM)$(EXEEXT)" ]; then \
		$(call sh_existe_comando,$(GDB)) ; \
		$(call sh_ruta_comando,$(GDB)) ; \
		printf "** Version instalada de $(GDB): %s **\n" "$$($(GDB) --version | sed -n 1p 2>/dev/null)" ; \
		case "$(OPEN_COMMAND)" in \
			("start") \
				set -x ; \
					cd "$(DOLLAR-SIGNS-ESCAPED_BINDIR)" ; \
					start $(GDB) $(GDBFLAGS) "$(DOLLAR-SIGNS-ESCAPED_PROGRAM)$(EXEEXT)" ; \
					cd - >/dev/null ; \
				{ set +x ; } 2>/dev/null ;; \
			(*) \
				$(call sh_existe_comando,tmux) ; \
				$(call sh_ruta_comando,tmux) ; \
				printf "** Version instalada de tmux: %s **\n" "$$(tmux -V | sed -n 1p 2>/dev/null)" ; \
				set -x ; \
					cd "$(DOLLAR-SIGNS-ESCAPED_BINDIR)" ; \
					tmux new "$(nota_tmux) set -x ; $(GDB) $(GDBFLAGS) \"$(call escapar_simbolo_pesos_conforme_a_shell,$(call escapar_simbolo_pesos_conforme_a_shell,$(DOLLAR-SIGNS-ESCAPED_PROGRAM)$(EXEEXT)))\"" ; \
					cd - >/dev/null ; \
				{ set +x ; } 2>/dev/null ; \
				printf "NOTA: Para volver a las sesiones apartadas de tmux [detached], ejecute el comando <tmux attach>\n" ;; \
		esac ; \
	else \
		printf "(No existe el binario \"%s\")\n" "$(DOLLAR-SIGNS-ESCAPED_BINDIR)$(DOLLAR-SIGNS-ESCAPED_PROGRAM)$(EXEEXT)" ; \
	fi ;
	@printf "<<< Realizado >>>\n"
	@printf "\n=================[ Finalizado ]=============\n"
else
	@printf "  * Se debe (re)construir el objetivo '%s'.\n" "$@"
endif

# Para incluir el/los otro/s makefile/s ya producido/s con los prerequisitos generados automáticamente
sinclude $(call sin_necesidad_de_comillas_dobles,$(shell printf "%s" '$(call escapar_comillas_simples_dentro_de_otras_comillas_simples,$(COBJS))' | sed -e 's?"[^"]*/?"?g' -e 's?"\([^"]*\)\.o"?"$(SINGLE-QUOTES-ESCAPED_DEPDIR)\1.d"?g' ;)) $(call sin_necesidad_de_comillas_dobles,$(shell printf "%s" '$(call escapar_comillas_simples_dentro_de_otras_comillas_simples,$(YOBJS))' | sed -e 's?"[^"]*/?"?g' -e 's?"\([^"]*\)\.tab\.o"?"$(SINGLE-QUOTES-ESCAPED_DEPDIR)\1.tab.d"?g' ;)) $(call sin_necesidad_de_comillas_dobles,$(shell printf "%s" '$(call escapar_comillas_simples_dentro_de_otras_comillas_simples,$(LOBJS))' | sed -e 's?"[^"]*/?"?g' -e 's?"\([^"]*\)\.lex\.yy\.o"?"$(SINGLE-QUOTES-ESCAPED_DEPDIR)\1.lex.yy.d"?g' ;))
# 	La directiva sinclude hace que make suspenda la lectura del makefile actual y lea en orden los otros makefiles que se indican antes de continuar. Si alguno de los makefiles indicados no puede ser encontrado, no es un error fatal inmediato; el procesamiento de este makefile continúa. Una vez que haya finalizado la etapa de lectura de makefiles, make intentará rehacer cualquiera que haya quedado obsoleto o que no exista. Si no puede encontrar una regla para rehacer algún otro makefile, o sí que la encontró pero ocurre un fallo al ejecutar la receta, make lo diagnostica como un error fatal al tratarse de la directiva include.

# Regla explícita con una receta vacía que no hace nada. Este objetivo es el que se establece como meta por defecto en el/los otro/s makefile/s producido/s para evitar que al ser incluido/s se ejecute alguna otra regla que sí que haga algo
empty: ;

# Regla implícita de tipo regla de patrón con CC: Para construir el binario $(BINDIR)$(PROGRAM)$(EXEEXT)
$(call escapar_espacios,$(call escapar_simbolos_de_porcentaje_conforme_a_make,$(BINDIR)$(PROGRAM)$(EXEEXT))): $(call sin_necesidad_de_comillas_dobles,$(COBJS)) $(call sin_necesidad_de_comillas_dobles,$(YOBJS)) $(call sin_necesidad_de_comillas_dobles,$(LOBJS)) | $(TRAILING-SLASH-REMOVED-AND-SPACES-ESCAPED_BINDIR)
ifeq ($(PRINT_TARGETS),0)
# 	Anuncia que se va a iniciar la construcción
	@printf "\n=================[ Construccion con $(CC): \"%s\" ]=================\n" "$(call escapar_simbolo_pesos_conforme_a_shell,$@)"
# 	Si el binario ya existiera, fuerza su eliminación por si el archivo está en uso, ya que esto impediría su construcción
	@$(call forzar_eliminacion_si_ya_existiera_el_binario,$(call escapar_simbolo_pesos_conforme_a_shell,$@))
# 	Construye el binario
	@printf "\n<<< $(CC)->$(CC): Enlazando el/los archivo/s objeto con la/s biblioteca/s para construir el binario: \"%s\" [WARNINGS_CC: $(WARNINGS_CC_ACTIVATION) | DEBUG_CC: $(DEBUG_CC_ACTIVATION)] >>>\n" "$(call escapar_simbolo_pesos_conforme_a_shell,$@)"
	@$(call sh_existe_comando,$(CC))
	@$(call sh_ruta_comando,$(CC))
	@printf "** Version instalada de $(CC): %s **\n" "$$($(CC) --version | sed -n 1p 2>/dev/null)"
	$(CC) $(CFLAGS) -o"$(call escapar_simbolo_pesos_conforme_a_shell,$@)" $(call escapar_simbolo_pesos_conforme_a_shell,$(COBJS)) $(call escapar_simbolo_pesos_conforme_a_shell,$(YOBJS)) $(call escapar_simbolo_pesos_conforme_a_shell,$(LOBJS)) $(LDFLAGS) $(LDLIBS)
	@printf "<<< Realizado >>>\n"
# 	Anuncia que se completó la construcción
	@printf "\n=================[ Finalizado ]=================\n"
# 	Muestra una nota si hay YACC y si su depuración está habilitada
	@$(call mostrar_nota_sobre_yacc_si_su_depuracion_esta_habilitada)
else
	@printf "  * Se debe (re)construir el objetivo '%s'.\n" "$(call escapar_simbolo_pesos_conforme_a_shell,$@)"
endif

# Para habilitar una segunda expansión en los prerequisitos para todas las reglas que siguen a continuación
.SECONDEXPANSION:
# 	Esto lo hacemos para poder producir las secuencias de escape para los espacios en aquellos objetivos que utilizan reglas de patrón (los que contienen el caracter %)

# Regla implícita de tipo regla de patrón con YACC + CC: Para generar el archivo objeto $(OBJDIR)%.tab.o desde $(OBJDIR)%.tab.c
$(PERCENT-SIGNS-AND-SPACES-ESCAPED_OBJDIR)%.tab.o: $$(call escapar_espacios,$$(OBJDIR)%.tab.c) $$(call escapar_espacios,$$(SRCDIR)%.y) $$(call escapar_espacios,$$(DEPDIR)%.tab.d) | $$(TRAILING-SLASH-REMOVED-AND-SPACES-ESCAPED_DEPDIR) $$(TRAILING-SLASH-REMOVED-AND-SPACES-ESCAPED_OBJDIR)
ifeq ($(PRINT_TARGETS),0)
	$(call receta_para_.d,$(call escapar_simbolo_pesos_conforme_a_shell,$(shell printf "%s" "$(call escapar_simbolo_pesos_conforme_a_shell,$@)" | sed -e 's?.*/??' -e 's?\(.*\)\.o?$(SINGLE-QUOTES-ESCAPED_DEPDIR)\1?' ;)))
	@printf "\n<<< $(YACC)->$(CC): Generando el archivo objeto: \"%s\" [WARNINGS_CC: $(WARNINGS_CC_ACTIVATION) | DEBUG_CC: $(DEBUG_CC_ACTIVATION)] >>>\n" "$(call escapar_simbolo_pesos_conforme_a_shell,$@)"
	@$(call sh_existe_comando,$(CC))
	@$(call sh_ruta_comando,$(CC))
	@printf "** Version instalada de $(CC): %s **\n" "$$($(CC) --version | sed -n 1p 2>/dev/null)"
	$(CC) $(CPPFLAGS) $(CFLAGS) $(C_YOBJFLAGS) -c -o"$(call escapar_simbolo_pesos_conforme_a_shell,$@)" "$(call escapar_simbolo_pesos_conforme_a_shell,$<)"
	@printf "<<< Realizado >>>\n"
else
	@printf "  * Se debe (re)construir el objetivo '%s'.\n" "$(call escapar_simbolo_pesos_conforme_a_shell,$@)"
endif

# Regla implícita de tipo regla de patrón con YACC: Para generar los archivos del analizador sintáctico (parser) $(OBJDIR)%.tab.c, $(OBJDIR)%.tab.h y $(OBJDIR)%.tab.output desde $(SRCDIR)%.y
$(PERCENT-SIGNS-AND-SPACES-ESCAPED_OBJDIR)%.tab.c $(PERCENT-SIGNS-AND-SPACES-ESCAPED_OBJDIR)%.tab.h $(PERCENT-SIGNS-AND-SPACES-ESCAPED_OBJDIR)%.output: $$(call escapar_espacios,$$(SRCDIR)%.y) | $$(TRAILING-SLASH-REMOVED-AND-SPACES-ESCAPED_OBJDIR)
ifeq ($(PRINT_TARGETS),0)
	@printf "\n<<< $(YACC): Generando los archivos del analizador sintactico (parser): \"%s\" [WARNINGS_YACC: $(WARNINGS_YACC_ACTIVATION) | DEBUG_YACC: $(DEBUG_YACC_ACTIVATION)] >>>\n" "$(call escapar_simbolo_pesos_conforme_a_shell,$(shell printf "%s" "$(call escapar_simbolo_pesos_conforme_a_shell,$<)" | sed -e 's?.*/??' -e 's?\(.*\)\.y?$(SINGLE-QUOTES-ESCAPED_OBJDIR)\1<.tab.c><.tab.h><.output>?' ;))"
	@$(call sh_existe_comando,$(YACC))
	@$(call sh_ruta_comando,$(YACC))
	@printf "** Version instalada de $(YACC): %s **\n" "$$($(YACC) --version | sed -n 1p 2>/dev/null)"
	$(YACC) -d -v $(YFLAGS) -o"$(call escapar_simbolo_pesos_conforme_a_shell,$(shell printf "%s" "$(call escapar_simbolo_pesos_conforme_a_shell,$<)" | sed -e 's?.*/??' -e 's?\(.*\)\.y?$(SINGLE-QUOTES-ESCAPED_OBJDIR)\1.tab.c?' ;))" "$(call escapar_simbolo_pesos_conforme_a_shell,$<)"
	@printf "<<< Realizado >>>\n"
else
	@printf "  * Se debe (re)construir el objetivo '%s'.\n" "$(call escapar_simbolo_pesos_conforme_a_shell,$@)"
endif

# Regla implícita de tipo regla de patrón con LEX + CC: Para generar el archivo objeto $(OBJDIR)%.lex.yy.o desde $(OBJDIR)%.lex.yy.c
$(PERCENT-SIGNS-AND-SPACES-ESCAPED_OBJDIR)%.lex.yy.o: $$(call escapar_espacios,$$(OBJDIR)%.lex.yy.c) $$(call escapar_espacios,$$(SRCDIR)%.l) $$(call escapar_espacios,$$(DEPDIR)%.lex.yy.d) | $$(TRAILING-SLASH-REMOVED-AND-SPACES-ESCAPED_DEPDIR) $$(TRAILING-SLASH-REMOVED-AND-SPACES-ESCAPED_OBJDIR) $$(call sin_necesidad_de_comillas_dobles,$$(YDEFS))
ifeq ($(PRINT_TARGETS),0)
	$(call receta_para_.d,$(call escapar_simbolo_pesos_conforme_a_shell,$(shell printf "%s" "$(call escapar_simbolo_pesos_conforme_a_shell,$@)" | sed -e 's?.*/??' -e 's?\(.*\)\.o?$(SINGLE-QUOTES-ESCAPED_DEPDIR)\1?' ;)))
	@printf "\n<<< $(LEX)->$(CC): Generando el archivo objeto: \"%s\" [WARNINGS_CC: $(WARNINGS_CC_ACTIVATION) | DEBUG_CC: $(DEBUG_CC_ACTIVATION)] >>>\n" "$(call escapar_simbolo_pesos_conforme_a_shell,$@)"
	@$(call sh_existe_comando,$(CC))
	@$(call sh_ruta_comando,$(CC))
	@printf "** Version instalada de $(CC): %s **\n" "$$($(CC) --version | sed -n 1p 2>/dev/null)"
	$(CC) $(CPPFLAGS) $(CFLAGS) $(C_LOBJFLAGS) -c -o"$(call escapar_simbolo_pesos_conforme_a_shell,$@)" "$(call escapar_simbolo_pesos_conforme_a_shell,$<)"
	@printf "<<< Realizado >>>\n"
else
	@printf "  * Se debe (re)construir el objetivo '%s'.\n" "$(call escapar_simbolo_pesos_conforme_a_shell,$@)"
endif

# Regla implícita de tipo regla de patrón con LEX: Para generar el archivo del analizador léxico (scanner) $(OBJDIR)%.lex.yy.c desde $(SRCDIR)%.l
$(PERCENT-SIGNS-AND-SPACES-ESCAPED_OBJDIR)%.lex.yy.c: $$(call escapar_espacios,$$(SRCDIR)%.l) | $$(TRAILING-SLASH-REMOVED-AND-SPACES-ESCAPED_OBJDIR)
ifeq ($(PRINT_TARGETS),0)
	@printf "\n<<< $(LEX): Generando el archivo del analizador lexico (scanner): \"%s\" [WARNINGS_LEX: $(WARNINGS_LEX_ACTIVATION) | DEBUG_LEX: $(DEBUG_LEX_ACTIVATION)] >>>\n" "$(call escapar_simbolo_pesos_conforme_a_shell,$@)"
	@$(call sh_existe_comando,$(LEX))
	@$(call sh_ruta_comando,$(LEX))
	@printf "** Version instalada de $(LEX): %s **\n" "$$($(LEX) --version | sed -n 1p 2>/dev/null)"
	$(LEX) $(LFLAGS) -o"$(call escapar_simbolo_pesos_conforme_a_shell,$@)" "$(call escapar_simbolo_pesos_conforme_a_shell,$<)"
	@printf "<<< Realizado >>>\n"
else
	@printf "  * Se debe (re)construir el objetivo '%s'.\n" "$(call escapar_simbolo_pesos_conforme_a_shell,$@)"
endif

# Regla implícita de tipo regla de patrón con CC: Para generar el archivo objeto $(OBJDIR)%.o desde $(SRCDIR)%.c
$(PERCENT-SIGNS-AND-SPACES-ESCAPED_OBJDIR)%.o: $$(call escapar_espacios,$$(SRCDIR)%.c) $$(call escapar_espacios,$$(DEPDIR)%.d) | $$(TRAILING-SLASH-REMOVED-AND-SPACES-ESCAPED_DEPDIR) $$(TRAILING-SLASH-REMOVED-AND-SPACES-ESCAPED_OBJDIR)
ifeq ($(PRINT_TARGETS),0)
	$(call receta_para_.d,$(call escapar_simbolo_pesos_conforme_a_shell,$(shell printf "%s" "$(call escapar_simbolo_pesos_conforme_a_shell,$@)" | sed -e 's?.*/??' -e 's?\(.*\)\.o?$(SINGLE-QUOTES-ESCAPED_DEPDIR)\1?' ;)))
	@printf "\n<<< $(CC): Generando el archivo objeto: \"%s\" [WARNINGS_CC: $(WARNINGS_CC_ACTIVATION) | DEBUG_CC: $(DEBUG_CC_ACTIVATION)] >>>\n" "$(call escapar_simbolo_pesos_conforme_a_shell,$@)"
	@$(call sh_existe_comando,$(CC))
	@$(call sh_ruta_comando,$(CC))
	@printf "** Version instalada de $(CC): %s **\n" "$$($(CC) --version | sed -n 1p 2>/dev/null)"
	$(CC) $(CPPFLAGS) $(CFLAGS) $(C_COBJFLAGS) -c -o"$(call escapar_simbolo_pesos_conforme_a_shell,$@)" "$(call escapar_simbolo_pesos_conforme_a_shell,$<)"
	@printf "<<< Realizado >>>\n"
else
	@printf "  * Se debe (re)construir el objetivo '%s'.\n" "$(call escapar_simbolo_pesos_conforme_a_shell,$@)"
endif

# Regla implícita de tipo regla de patrón con una receta vacía que no hace nada: Para evitar errores al momento de incluir los otros makefiles con prerequisitos generados automáticamente, respecto de los objetivos $(DEPDIR)%.d , $(DEPDIR)%.tab.d y $(DEPDIR)%.lex.yy.d , los cuales son creados como efecto secundario de las recetas para los objetivos $(OBJDIR)%.o , $(OBJDIR)%.tab.o y $(OBJDIR)%.lex.yy.o respectivamente: si el objetivo no existe la receta vacía asegura de que make no reclamará sobre que no sabe cómo construir el objetivo, y sólo asumirá de que el objetivo está obsoleto
%.d: ;

# Regla implícita de tipo regla de patrón con una receta vacía que no hace nada: Para evitar errores al momento de incluir los otros makefiles con prerequisitos generados automáticamente, respecto de los objetivos %.h : si el objetivo no existe la receta vacía asegura de que make no reclamará sobre que no sabe cómo construir el objetivo, y sólo asumirá de que el objetivo está obsoleto
%.h: ;

# Regla explícita con objetivos independientes para crear los directorios en donde se ubican los archivos intermedios, el binario, y los makefiles producidos correspondientemente, si alguno no existiera
$(call escapar_simbolos_de_porcentaje_conforme_a_make,$(TRAILING-SLASH-REMOVED-AND-SPACES-ESCAPED_OBJDIR)) $(call escapar_simbolos_de_porcentaje_conforme_a_make,$(TRAILING-SLASH-REMOVED-AND-SPACES-ESCAPED_BINDIR)) $(call escapar_simbolos_de_porcentaje_conforme_a_make,$(TRAILING-SLASH-REMOVED-AND-SPACES-ESCAPED_DEPDIR)):
ifeq ($(PRINT_TARGETS),0)
	@printf "\n<<< Creando el directorio: \"%s\" >>>\n" "$(call escapar_simbolo_pesos_conforme_a_shell,$@)"
	mkdir -p "$(call escapar_simbolo_pesos_conforme_a_shell,$@)"
	@printf "<<< Realizado >>>\n"
else
	@printf "  * Se debe (re)construir el objetivo '%s'.\n" "$(call escapar_simbolo_pesos_conforme_a_shell,$@)"
endif