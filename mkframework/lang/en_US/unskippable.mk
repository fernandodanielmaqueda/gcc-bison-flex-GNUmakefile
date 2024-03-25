# Filename: unskippable.mk / v2024.03.25-001, part of gcc-bison-flex-GNUmakefile
# English (United States) language-specific makefile containing unskippable printing messages
# Copyright (C) 2022-2024 Fernando Daniel Maqueda <https://github.com/fernandodanielmaqueda/>
# You should have received a copy of the GNU General Public License along with this. If not, see <https://www.gnu.org/licenses/>.

# NOTE: avoid using single quotes (') whenever possible as they need to be escaped as '\'' for the shell, but not for GNU Make's $(error ...) and $(info ...) functions

# Prevents GNU Make from even considering to remake this very same makefile, as that isn't necessary, thus optimizing startup time
.PHONY: $(MKFWK_LANG_DIR)$(MKFWK_LOCALE_DIR)unskippable.mk

MKFWK_PRINTF_FORMAT_MSG_DONE=Done
MKFWK_PRINTF_FORMAT_MSG_FINISHED=Finished

define mkfwk_printf_strings_msg_info_dispensable_target_command_found
'INFO: Found the $(1) command pathname set in the corresponding make variable: $($(1))' \
'Therefore, the command is going to be used to make this target' \
'Continuing normally...'
endef

define mkfwk_printf_strings_msg_info_dispensable_target_command_not_found
'INFO: Could not find the $(1) command pathname set in the corresponding make variable: $($(1))' \
'Not a problem: the command is not indispensable to make this target' \
'Continuing normally...'
endef