# Filename: unskippable.mk / v2024.03.25-001, part of gcc-bison-flex-GNUmakefile
# Spanish (Argentina) language-specific makefile containing unskippable printing messages
# Copyright (C) 2022-2024 Fernando Daniel Maqueda <https://github.com/fernandodanielmaqueda/>
# You should have received a copy of the GNU General Public License along with this. If not, see <https://www.gnu.org/licenses/>.

# NOTE: avoid using single quotes (') whenever possible as they need to be escaped as '\'' for the shell, but not for GNU Make's $(error ...) and $(info ...) functions

# Prevents GNU Make from even considering to remake this very same makefile, as that isn't necessary, thus optimizing startup time
.PHONY: $(MKFWK_LANG_DIR)$(MKFWK_LOCALE_DIR)unskippable.mk

MKFWK_PRINTF_FORMAT_MSG_DONE=Realizado
MKFWK_PRINTF_FORMAT_MSG_FINISHED=Finalizado

define mkfwk_printf_strings_msg_info_dispensable_target_command_found
'INFO: Si se pudo encontrar la ruta hacia el comando $(1) definida en la variable de make correspondiente: $($(1))' \
'Por lo tanto, se utilizara el comando para construir este objetivo de make' \
'Continuando normalmente...'
endef

define mkfwk_printf_strings_msg_info_dispensable_target_command_not_found
'INFO: No se pudo encontrar la ruta hacia el comando $(1) definida en la variable de make correspondiente: $($(1))' \
'No es un problema: el comando no es indispensable para construir este objetivo de make' \
'Continuando normalmente...'
endef