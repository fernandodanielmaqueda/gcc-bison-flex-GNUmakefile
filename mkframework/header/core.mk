# Filename: core.mk / v2024.03.25-001, part of gcc-bison-flex-GNUmakefile
# Makefile containing core checks and definitions
# Copyright (C) 2022-2024 Fernando Daniel Maqueda <https://github.com/fernandodanielmaqueda/>
# You should have received a copy of the GNU General Public License along with this. If not, see <https://www.gnu.org/licenses/>.

# Prevents GNU Make from even considering to remake this very same makefile, as that isn't necessary, thus optimizing startup time
.PHONY: $(MKFWK_HEADER_DIR)core.mk

# Defines a new flag variable indicating whether the "-t" or "--touch" option has been specified from the command-line (if the resulting value is non-empty) or not (if else)
MKFWK_HAVE_ACTIVATED_OPTION_-t_--touch:=$(if $(findstring t,$(firstword -$(MAKEFLAGS))),X)

# Informs the user when the MUST_MAKE option was enabled.
#   If the "-t" or "--touch" option has also been specified, informs that the MUST_MAKE option gets overriden by it.
ifneq ($(MUST_MAKE),)
ifeq ($(MKFWK_HAVE_ACTIVATED_OPTION_-t_--touch),)
$(info $(MKFWK_MAKE_MSG_INFO_MUST_MAKE_ENABLED))
else
override MUST_MAKE=
$(info $(MKFWK_MAKE_MSG_INFO_MUST_MAKE_OVERRIDEN))
endif
endif
MKFWK_MAKE_MSG_INFO_MUST_MAKE_ENABLED=
MKFWK_MAKE_MSG_INFO_MUST_MAKE_OVERRIDEN=

# Determines sh to be the program to be used as the shell
SHELL=/bin/sh

# Defines as the pathname command that comes by default: command -v
define mkfwk_pathname_command_invocation
command -v $(1)
endef

# Pathnames to the core commands
AWK=awk
CUT=cut
ECHO=echo
EXPR=expr
FALSE=false
FIND=find
MKDIR=mkdir
MV=mv
PRINTF=printf
RM=rm
RMDIR=rmdir
SED=sed
SORT=sort
TEST=test
TEST_LEFT_SQUARE_BRACKET_FORM=[
TOUCH=touch
TR=tr
TRUE=true
UNAME=uname

# Options to be passed to the core commands
RMFLAGS=-f

## Beginning of skippable startup checks section
ifneq ($(STARTUP_CHECKS),)

# Space-separated lists of core commands
MKFWK_COREUTILS_CORE_COMMANDS=CUT EXPR FALSE MKDIR MV PRINTF RM RMDIR SORT TEST TEST_LEFT_SQUARE_BRACKET_FORM TOUCH TR TRUE UNAME
MKFWK_FINDUTILS_CORE_COMMANDS=FIND
MKFWK_STANDALONE_CORE_COMMANDS=AWK SED

# Checks that all of the core commands are set
define mkfwk_make_check_core_command_to_be_set
$(if $($(1)),,$(error $(call mkfwk_make_msg_error_core_command_unset,$(1))))
endef
$(foreach variable,$(MKFWK_COREUTILS_CORE_COMMANDS) $(MKFWK_FINDUTILS_CORE_COMMANDS) $(MKFWK_STANDALONE_CORE_COMMANDS),$(eval $(call mkfwk_make_check_core_command_to_be_set,$(variable))))
mkfwk_make_check_core_command_to_be_set=
mkfwk_make_msg_error_core_command_unset=

# Checks that a shell was actually found
$(if $(wildcard $(subst $(MKFWK_SPACE),\$(MKFWK_SPACE),$(SHELL))),,$(error $(MKFWK_MAKE_MSG_ERROR_SH_NOT_FOUND)))
MKFWK_MAKE_MSG_ERROR_SH_NOT_FOUND=

# Checks that options "-n", "--just-print", "--dry-run" nor "--recon" were added when invoking GNU Make, since they inhibit GNU Make's $(shell ...) function
$(if $(findstring n,$(firstword -$(MAKEFLAGS))),$(error $(MKFWK_MAKE_MSG_ERROR_INCOMPATIBLE_MAKEFLAG_SPECIFIED)))
MKFWK_MAKE_MSG_ERROR_INCOMPATIBLE_MAKEFLAG_SPECIFIED=

# Checks that GNU Make's $(shell ...) function is working properly just in case.
#   In that situation an error similar to this one may be printed: process_begin: CreateProcess(NULL, "", ...) failed.
$(if $(shell $(ECHO) X ;),,$(error $(MKFWK_MAKE_MSG_ERROR_SHELL_FUNCTION)))
MKFWK_MAKE_MSG_ERROR_SHELL_FUNCTION=

# Checks that all of the set packaged core commands can be found
define mkfwk_make_check_set_packaged_core_command_existence
$(if $(shell $(call mkfwk_pathname_command_invocation,$($(1))) 2>/dev/null ;),,$(error $(call mkfwk_make_msg_error_set_packaged_core_command_not_found,$(1),$(2))))
endef
$(foreach variable,$(MKFWK_COREUTILS_CORE_COMMANDS),$(eval $(call mkfwk_make_check_set_packaged_core_command_existence,$(variable),GNU coreutils)))
$(foreach variable,$(MKFWK_FINDUTILS_CORE_COMMANDS),$(eval $(call mkfwk_make_check_set_packaged_core_command_existence,$(variable),GNU findutils)))
TEST_LEFT_SQUARE_BRACKET_FORM=
MKFWK_COREUTILS_CORE_COMMANDS=
MKFWK_FINDUTILS_CORE_COMMANDS=
mkfwk_make_check_set_packaged_core_command_existence=
mkfwk_make_msg_error_set_packaged_core_command_not_found=

# Checks that all of the set standalone core commands can be found
define mkfwk_make_check_set_standalone_core_command_existence
$(if $(shell $(call mkfwk_pathname_command_invocation,$($(1))) 2>/dev/null ;),,$(error $(call mkfwk_make_msg_error_set_core_command_not_found,$(1))))
endef
$(foreach variable,$(MKFWK_STANDALONE_CORE_COMMANDS),$(eval $(call mkfwk_make_check_set_standalone_core_command_existence,$(variable))))
mkfwk_make_check_set_standalone_core_command_existence=
mkfwk_make_msg_error_set_core_command_not_found=
MKFWK_STANDALONE_CORE_COMMANDS=

endif
## Ending of skippable startup checks section

# Defines a function that checks if a set directory does exist
define mkfwk_make_check_set_directory_existence
$(if $($(1)),$(if $(shell if ! [ -d $$($(PRINTF) '%s' '$($(1))' | $(SED) 's?/$$??') ]; then $(ECHO) X ; fi ;),$(error $(call mkfwk_make_msg_error_set_directory_not_found,$(1)))))
endef

# Defines a function that gets the directory component out of a pathname (without any trailing slash)
define mkfwk_dirname
$(filter-out .,$(patsubst %/,%,$(dir $(1))))
endef