# Filename: startup_checks.mk / v2024.03.25-001, part of gcc-bison-flex-GNUmakefile
# English (United States) language-specific makefile containing printing messages for startup checks
# Copyright (C) 2022-2024 Fernando Daniel Maqueda <https://github.com/fernandodanielmaqueda/>
# You should have received a copy of the GNU General Public License along with this. If not, see <https://www.gnu.org/licenses/>.

# NOTE: avoid using single quotes (') whenever possible as they need to be escaped as '\'' for the shell, but not for GNU Make's $(error ...) and $(info ...) functions

# Prevents GNU Make from even considering to remake this very same makefile, as that isn't necessary, thus optimizing startup time
.PHONY: $(MKFWK_LANG_DIR)$(MKFWK_LOCALE_DIR)startup_checks.mk

define MKFWK_MAKE_MSG_ERROR_SH_NOT_FOUND
ERROR: Bourne Shell (sh) cannot be found
sh is needed for this makefile to work
Ensure that a compatible shell (sh, bash, dash, zsh, etc.) is installed in your current running system
endef

define MKFWK_MAKE_MSG_ERROR_INCOMPATIBLE_MAKEFLAG_SPECIFIED
ERROR: make was run with the "-n", "--just-print", "--dry-run" or "--recon" options
This makefile cannot work properly with any of these
Re-run make without adding any of those options
endef

define MKFWK_MAKE_MSG_ERROR_SHELL_FUNCTION
ERROR: The shell function of GNU Make is not executing properly
It is needed for this makefile to work
endef

define mkfwk_make_msg_error_core_command_unset
ERROR: No $(1) command pathname is set in the corresponding make variable
The command is needed for this makefile to work
Set the variable accordingly
endef

define mkfwk_make_msg_error_set_packaged_core_command_not_found
ERROR: The $(1) command pathname set in the corresponding make variable, cannot be found: $($(1))
The command is needed for this makefile to work
Ensure that the command is installed in your current running system; it is included in $(2)
Otherwise, the variable may be incorrectly set
endef

define mkfwk_make_msg_error_set_core_command_not_found
ERROR: The $(1) command pathname set in the corresponding make variable, cannot be found: $($(1))
The command is needed for this makefile to work
Ensure that the command is installed in your current running system
Otherwise, the variable may be incorrectly set
endef

define mkfwk_make_msg_error_set_directory_not_found
ERROR: The $(1) directory pathname set in the corresponding make variable, cannot be found: $($(1))
The directory is needed for this makefile to work
Ensure that the directory is located accordingly
Otherwise, the variable may be incorrectly set
endef

define mkfwk_make_msg_error_source_files_unset
ERROR: No source files are set in the $(1) make variable
The source files must be established for this makefile to work
Set the variable accordingly
Note: If the variable is set to the source files that are found, then none were obtained;
in that case, ensure that source files can be found
endef

define mkfwk_make_msg_error_linking_order_unset
ERROR: No linking order is set in the $(1) make variable
The linking order must be established for this makefile to work
Set the variable accordingly
endef

MKFWK_PRINTF_FORMAT_MSG_RENAMING_TO_SOLVE_CONFLICT=Renaming to solve an eventual pathname conflict