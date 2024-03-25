# Filename: startup_checks.mk / v2024.03.25-001, part of gcc-bison-flex-GNUmakefile
# Spanish (Argentina) language-specific makefile containing printing messages for startup checks
# Copyright (C) 2022-2024 Fernando Daniel Maqueda <https://github.com/fernandodanielmaqueda/>
# You should have received a copy of the GNU General Public License along with this. If not, see <https://www.gnu.org/licenses/>.

# NOTE: avoid using single quotes (') whenever possible as they need to be escaped as '\'' for the shell, but not for GNU Make's $(error ...) and $(info ...) functions

# Prevents GNU Make from even considering to remake this very same makefile, as that isn't necessary, thus optimizing startup time
.PHONY: $(MKFWK_LANG_DIR)$(MKFWK_LOCALE_DIR)startup_checks.mk

define MKFWK_MAKE_MSG_ERROR_SH_NOT_FOUND
ERROR: No se puede encontrar Bourne Shell (sh)
sh es necesario para que este makefile pueda funcionar
Comprueba que una shell compatible (sh, bash, dash, zsh, etc.) este instalada en tu sistema actual en ejecucion
endef

define MKFWK_MAKE_MSG_ERROR_INCOMPATIBLE_MAKEFLAG_SPECIFIED
ERROR: make se ha ejecutado con las opciones "-n", "--just-print", "--dry-run" o "--recon"
Este makefile no puede funcionar correctamente con ellas
Re-ejecuta make sin agregar ninguna de esas opciones
endef

define MKFWK_MAKE_MSG_ERROR_SHELL_FUNCTION
ERROR: La funcion shell de GNU Make no se esta ejecutando correctamente
Es necesaria para que este makefile pueda funcionar
endef

define mkfwk_make_msg_error_core_command_unset
ERROR: No hay una ruta hacia el comando $(1) establecida en la variable de make correspondiente
El comando es necesario para que el makefile pueda funcionar
Establece la variable acordemente
endef

define mkfwk_make_msg_error_set_packaged_core_command_not_found
ERROR: La ruta hacia el comando $(1) establecida en la variable de make correspondiente, no se puede encontrar: $($(1))
El comando es necesario para que el makefile pueda funcionar
Comprueba que el comando esta instalado en tu sistema actual en ejecucion; se lo incluye en $(2)
De otro modo, la variable podria estar establecida incorrectamente
endef

define mkfwk_make_msg_error_set_core_command_not_found
ERROR: La ruta hacia el comando $(1) establecida en la variable de make correspondiente, no se puede encontrar: $($(1))
El comando es necesario para que el makefile pueda funcionar
Comprueba que el comando esta instalado en tu sistema actual en ejecucion
De otro modo, la variable podria estar establecida incorrectamente
endef

define mkfwk_make_msg_error_set_directory_not_found
ERROR: La ruta hacia el directorio $(1) establecida en la variable de make correspondiente, no se puede encontrar: $($(1))
Comprueba que el directorio este ubicado acordemente
De otro modo, la variable podria estar establecida incorrectamente
endef

define mkfwk_make_msg_error_source_files_unset
ERROR: No hay establecidos archivos fuente en la variable de make $(1)
Los archivos fuente deben estar establecidos para que el makefile pueda funcionar
Establece la variable acordemente
Nota: Si la variable tiene establecidos los archivos fuente que se encuentren, entonces ninguno fue hallado;
en ese caso comprueba que se puedan encontrar archivos fuente
endef

define mkfwk_make_msg_error_linking_order_unset
ERROR: No hay establecido un orden de enlazado en la variable de make $(1)
El orden de enlazado debe estar establecido para que el makefile pueda funcionar
Establece la variable acordemente
endef

MKFWK_PRINTF_FORMAT_MSG_RENAMING_TO_SOLVE_CONFLICT=Renombrando para resolver un eventual conflicto de nombres de rutas