# Filename: must_make.mk / v2024.03.25-001, part of gcc-bison-flex-GNUmakefile
# English (United States) language-specific makefile containing printing messages for the MUST_MAKE option
# Copyright (C) 2022-2024 Fernando Daniel Maqueda <https://github.com/fernandodanielmaqueda/>
# You should have received a copy of the GNU General Public License along with this. If not, see <https://www.gnu.org/licenses/>.

# NOTE: avoid using single quotes (') whenever possible as they need to be escaped as '\'' for the shell, but not for GNU Make's $(error ...) and $(info ...) functions

# Prevents GNU Make from even considering to remake this very same makefile, as that isn't necessary, thus optimizing startup time
.PHONY: $(MKFWK_LANG_DIR)$(MKFWK_LOCALE_DIR)must_make.mk

define MKFWK_MAKE_MSG_INFO_MUST_MAKE_ENABLED
INFO: It is enabled to print instead the targets that must be (re)made
and their newer dependencies (all if the target does not exist),
as the MUST_MAKE make variable has a non-empty set value...
endef

define MKFWK_MAKE_MSG_INFO_MUST_MAKE_OVERRIDEN
INFO: As the "-t" or "--touch" option has been added at startup,
it disables to print instead the targets that must be (re)made,
even though the MUST_MAKE make variable has a non-empty set value...
endef

MKFWK_PRINTF_FORMAT_MSG_MUST_MAKE_TARGET=Must make target
MKFWK_PRINTF_FORMAT_MSG_MUST_REMAKE_TARGET=Must (re)make target
MKFWK_PRINTF_FORMAT_MSG_PREREQUISITES_NEWER_THAN_TARGET=Its newer dependencies are