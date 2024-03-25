# Filename: must_make.mk / v2024.03.25-001, part of gcc-bison-flex-GNUmakefile
# Spanish (Argentina) language-specific makefile containing printing messages for the MUST_MAKE option
# Copyright (C) 2022-2024 Fernando Daniel Maqueda <https://github.com/fernandodanielmaqueda/>
# You should have received a copy of the GNU General Public License along with this. If not, see <https://www.gnu.org/licenses/>.

# NOTE: avoid using single quotes (') whenever possible as they need to be escaped as '\'' for the shell, but not for GNU Make's $(error ...) and $(info ...) functions

# Prevents GNU Make from even considering to remake this very same makefile, as that isn't necessary, thus optimizing startup time
.PHONY: $(MKFWK_LANG_DIR)$(MKFWK_LOCALE_DIR)must_make.mk

define MKFWK_MAKE_MSG_INFO_MUST_MAKE_ENABLED
INFO: Se encuentra habilitado el imprimir en su lugar los objetivos que deben ser (re)construidos
y sus dependencias que sean mas recientes (todas si el objetivo no existe),
debido a que la variable de make MUST_MAKE tiene definido un valor no vacio...
endef

define MKFWK_MAKE_MSG_INFO_MUST_MAKE_OVERRIDEN
INFO: Como se ha agregado la opcion "-t" ó "--touch" al iniciarse,
se deshabilita el imprimir en su lugar los objetivos que deben ser (re)construidos,
por mas de que la variable de make MUST_MAKE tenga definido un valor no vacio...
endef

MKFWK_PRINTF_FORMAT_MSG_MUST_MAKE_TARGET=Se debe construir el objetivo de make
MKFWK_PRINTF_FORMAT_MSG_MUST_REMAKE_TARGET=Se debe (re)construir el objetivo de make
MKFWK_PRINTF_FORMAT_MSG_PREREQUISITES_NEWER_THAN_TARGET=Sus dependencias mas recientes son