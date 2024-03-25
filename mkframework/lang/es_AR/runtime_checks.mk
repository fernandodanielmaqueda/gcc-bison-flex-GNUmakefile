# Filename: runtime_checks.mk / v2024.03.25-001, part of gcc-bison-flex-GNUmakefile
# Spanish (Argentina) language-specific makefile containing printing messages for runtime_checks checks
# Copyright (C) 2022-2024 Fernando Daniel Maqueda <https://github.com/fernandodanielmaqueda/>
# You should have received a copy of the GNU General Public License along with this. If not, see <https://www.gnu.org/licenses/>.

# NOTE: avoid using single quotes (') whenever possible as they need to be escaped as '\'' for the shell, but not for GNU Make's $(error ...) and $(info ...) functions

# Prevents GNU Make from even considering to remake this very same makefile, as that isn't necessary, thus optimizing startup time
.PHONY: $(MKFWK_LANG_DIR)$(MKFWK_LOCALE_DIR)runtime_checks.mk

define mkfwk_printf_strings_msg_error_indispensable_target_command_unset
'ERROR: No hay una ruta hacia el comando $(1) definida en la variable de make correspondiente' \
'El comando es indispensable para construir este objetivo de make' \
'Establece la variable acordemente'
endef

define mkfwk_printf_strings_msg_error_set_indispensable_target_command_not_found
'ERROR: La ruta hacia el comando $(1) definida en la variable de make correspondiente, no se puede encontrar: $($(1))' \
'El comando es indispensable para construir este objetivo de make' \
'Comprueba que el comando esta instalado en tu sistema actual en ejecucion' \
'De otro modo, la variable podria estar definida incorrectamente'
endef