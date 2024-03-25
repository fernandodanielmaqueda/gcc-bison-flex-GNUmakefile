# Filename: verbose.mk / v2024.03.25-001, part of gcc-bison-flex-GNUmakefile
# Spanish (Argentina) language-specific makefile containing verbose printing messages
# Copyright (C) 2022-2024 Fernando Daniel Maqueda <https://github.com/fernandodanielmaqueda/>
# You should have received a copy of the GNU General Public License along with this. If not, see <https://www.gnu.org/licenses/>.

# NOTE: avoid using single quotes (') whenever possible as they need to be escaped as '\'' for the shell, but not for GNU Make's $(error ...) and $(info ...) functions

# Prevents GNU Make from even considering to remake this very same makefile, as that isn't necessary, thus optimizing startup time
.PHONY: $(MKFWK_LANG_DIR)$(MKFWK_LOCALE_DIR)verbose.mk

MKFWK_MSG_FOR_ON=Habilitado
MKFWK_MSG_FOR_OFF=Deshabilitado

MKFWK_PRINTF_FORMAT_MSG_PATHNAME=Ruta
MKFWK_PRINTF_FORMAT_MSG_INSTALLED_VERSION=Version

MKFWK_PRINTF_FORMAT_MSG_REMOVING=Eliminando
MKFWK_PRINTF_FORMAT_MSG_REMOVING_DIRECTORY=Eliminando el directorio (solo si esta vacio, no esta en uso, etc.)

define MKFWK_PRINTF_STRINGS_MSG_NOTE_YACC_DEBUGGING
'NOTA: Se ha definido la macro YYDEBUG en un valor entero distinto de 0 asi las herramientas de depuracion de YACC son compiladas' \
'Para depurar YACC, la variable de tipo int yydebug debe tener asignado un valor entero distinto de 0 en tiempo de ejecucion' \
'Una manera de lograr eso es agregarle el siguiente codigo al main() antes de que se llame a yyparse()'
endef

MKFWK_PRINTF_FORMAT_MSG_INIT_TARGET-cleandeps=Eliminar los archivos asociados con la generacion automatica de dependencias
MKFWK_PRINTF_FORMAT_MSG_INIT_TARGET-mostlyclean=Eliminar los programas y los archivos de salida de compilacion
MKFWK_PRINTF_FORMAT_MSG_INIT_TARGET-clean=Eliminar los archivos de bibliotecas
MKFWK_PRINTF_FORMAT_MSG_INIT_TARGET-distclean=Nada configurado para eliminar
MKFWK_PRINTF_FORMAT_MSG_INIT_TARGET-realclean=Nada configurado para eliminar
MKFWK_PRINTF_FORMAT_MSG_INIT_TARGET-clobber=Nada configurado para eliminar
MKFWK_PRINTF_FORMAT_MSG_INIT_TARGET-maintainer-clean=Eliminar los archivos generados por YACC y LEX
MKFWK_PRINTF_FORMAT_MSG_INIT_TARGET-cleandirs=Eliminar los directorios objetivo

MKFWK_PRINTF_FORMAT_MSG_THE_FILE=el archivo
MKFWK_PRINTF_FORMAT_MSG_THE_PROGRAM=el programa
MKFWK_PRINTF_FORMAT_MSG_THE_LIBRARY_FILE=el archivo de biblioteca
MKFWK_PRINTF_FORMAT_MSG_THE_COMPILATION_OUTPUT_FILE=el archivo de salida de compilacion
MKFWK_PRINTF_FORMAT_MSG_THE_.d_ASSOCIATED_FILE=el archivo asociado con la generacion automatica de dependencias
MKFWK_PRINTF_FORMAT_MSG_THE_LEX_GENERATED_FILE=el archivo generado por LEX
MKFWK_PRINTF_FORMAT_MSG_THE_YACC_GENERATED_FILE=el archivo generado por YACC

MKFWK_PRINTF_FORMAT_MSG_EXCEPTION_PROGRAM_DOES_NOT_EXIST=EXCEPTION: No existe el programa objetivo
MKFWK_PRINTF_FORMAT_MSG_MUST_BE_BUILT_FIRST=Se lo debe construir primero
MKFWK_PRINTF_FORMAT_MSG_RELATIVE_PATH=Ruta relativa

MKFWK_PRINTF_FORMAT_MSG_INIT_TARGET-run=Ejecutar un programa en esta ventana
MKFWK_PRINTF_FORMAT_MSG_DO_TARGET-run=Ejecutando el programa objetivo

MKFWK_PRINTF_FORMAT_MSG_INIT_TARGET-gdb=Depurar un programa en esta ventana por medio de una interfaz de linea de comandos (CLI)
MKFWK_PRINTF_FORMAT_MSG_DO_TARGET-gdb=Depurando el programa objetivo

MKFWK_PRINTF_FORMAT_MSG_INIT_TARGET-valgrind=Ejecutar la herramienta de Valgrind correspondiente en esta ventana con el programa objetivo
MKFWK_PRINTF_FORMAT_MSG_DO_TARGET-valgrind=Ejecutando con el programa objetivo

MKFWK_PRINTF_FORMAT_MSG_THE_ALREADY_EXISTING_PROGRAM=el programa ya existente

MKFWK_PRINTF_FORMAT_MSG_REGENERATING_THE_PROGRAM=(Re)generando el programa
MKFWK_PRINTF_FORMAT_MSG_REGENERATING_THE_LIBRARY_FILE=(Re)generando la libreria
MKFWK_PRINTF_FORMAT_MSG_REPLACING_ARCHIVE=Reemplazando/Agregando archivo(s) objeto en el archivo
MKFWK_PRINTF_FORMAT_MSG_EXECUTING_RANLIB=Actualizando la tabla de simbolos del archivo
MKFWK_PRINTF_FORMAT_MSG_REGENERATING_THE_.d_FILES=(Re)generando los archivos asociados con la generacion automatica de dependencias
MKFWK_PRINTF_FORMAT_MSG_REGENERATING_THE_.tab.c_.tab.h_.output_FILES=(Re)generando los archivos del analizador sintactico (parser) implementado
MKFWK_PRINTF_FORMAT_MSG_REGENERATING_THE_.lex.yy.c_FILE=(Re)generando el archivo fuente de C del analizador lexico (scanner) implementado
MKFWK_PRINTF_FORMAT_MSG_REGENERATING_THE_.i_FILE=(Re)generando el archivo preprocesado
MKFWK_PRINTF_FORMAT_MSG_REGENERATING_THE_.s_FILE=(Re)generando el archivo ensamblador
MKFWK_PRINTF_FORMAT_MSG_REGENERATING_THE_.o_FILE=(Re)generando el archivo objeto

MKFWK_PRINTF_FORMAT_MSG_MAKING_DIRECTORY=Creando el directorio