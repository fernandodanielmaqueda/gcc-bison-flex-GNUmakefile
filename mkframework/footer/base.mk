# Filename: base.mk / v2024.03.25-001, part of gcc-bison-flex-GNUmakefile
# Makefile containing base definitions for the rest of the footer makefiles
# Copyright (C) 2022-2024 Fernando Daniel Maqueda <https://github.com/fernandodanielmaqueda/>
# You should have received a copy of the GNU General Public License along with this. If not, see <https://www.gnu.org/licenses/>.

# Prevents GNU Make from even considering to remake this very same makefile, as that isn't necessary, thus optimizing startup time
.PHONY: $(MKFWK_FOOTER_DIR)base.mk

# Adds the default directories needed to be made when building
TARGET_DIRS+=$(shell $(PRINTF) '%s\n' '$(BINDIR)' $(foreach prefix,BIN,$(foreach primary,PROGRAMS LIBRARIES SOLIBRARIES,$(foreach basename,$($(prefix)_$(primary)),$($(basename)_SOURCES)))) | $(SED) -e '2,$${' -e 'h' -e 's?^?$(OBJDIR)?' -e 'p' -e 'g' -e 's?^?$(DEPDIR)?' -e '}' | $(SED) -e 's?[^/]*$$??' -e 's?/$$??' | $(SED) -n -e ':a' -e 'p' -e 's?/[^/]*$$??' -e 'ta' ;)
# Removes duplicates (separately, just in case the user added directories)
TARGET_DIRS:=$(sort $(TARGET_DIRS))

## Beginning of skippable startup checks section
ifneq ($(STARTUP_CHECKS),)

# Checks that source files were set for each program, static library and shared library
$(foreach prefix,BIN,$(foreach primary,PROGRAMS LIBRARIES SOLIBRARIES,$(foreach basename,$($(prefix)_$(primary)),$(if $($(basename)_SOURCES),,$(error $(call mkfwk_make_msg_error_source_files_unset,$(basename)_SOURCES))))))
mkfwk_make_msg_error_source_files_unset=

# Checks that a linking order was set for each program and shared library
$(foreach prefix,BIN,$(foreach primary,PROGRAMS SOLIBRARIES,$(foreach basename,$($(prefix)_$(primary)),$(if $($(basename)_LDADD),,$(error $(call mkfwk_make_msg_error_linking_order_unset,$(basename)_LDADD))))))
mkfwk_make_msg_error_linking_order_unset=

endif
## Ending of skippable startup checks section

## Beginning of skippable runtime checks section
ifneq ($(RUNTIME_CHECKS),)

# Defines a canned recipe which checks that an indispensable target-specific command is set
define mkfwk_recipe_check_indispensable_target_command_to_be_set
	$(if $($(1)),,@$(PRINTF) '%s\n' $(call mkfwk_printf_strings_msg_error_indispensable_target_command_unset,$(1)) ; exit 1 ;)
endef

# Defines a canned recipe which checks that an indispensable target-specific command set can be found
define mkfwk_recipe_check_indispensable_target_command_existence
	@if ! $(call mkfwk_pathname_command_invocation,$($(1))) >/dev/null 2>&1; then $(PRINTF) '%s\n' $(call mkfwk_printf_strings_msg_error_set_indispensable_target_command_not_found,$(1)) ; exit 1 ; fi
endef

# Defines a canned recipe which checks that an indispensable target-specific command is set and can be found
define mkfwk_recipe_check_indispensable_target_command
	$(eval MKFWK_HAVE_CHECKED-$(1)=X)
	$(if $(VERBOSE),@$(PRINTF) '\n')
	$(call mkfwk_recipe_check_indispensable_target_command_to_be_set,$(1))
	$(call mkfwk_recipe_check_indispensable_target_command_existence,$(1))
endef

endif
## Ending of skippable runtime checks section

## Beginning of unskippable runtime checks

# Defines a canned recipe which checks if a dispensable target-specific command is set and can be found
define mkfwk_recipe_check_dispensable_target_command
	$(eval MKFWK_HAVE_CHECKED-$(1)=X)
	$(eval MKFWK_HAVE_COMMAND-$(1)=)
	$(if $($(1)),$(if $(shell ($(call mkfwk_pathname_command_invocation,$($(1)))) 2>/dev/null ;),$(eval MKFWK_HAVE_COMMAND-$(1)=X)))
	$(if $(MKFWK_HAVE_COMMAND-$(1)), \
	@$(PRINTF) '%s\n' '' $(call mkfwk_printf_strings_msg_info_dispensable_target_command_found,$(1)) '' ; \
	, \
	@$(PRINTF) '%s\n' '' $(call mkfwk_printf_strings_msg_info_dispensable_target_command_not_found,$(1)) '' ; \
	)

endef

## Ending of unskippable runtime checks

## Beginning of skippable verbose section
ifneq ($(VERBOSE),)

# Defines a canned recipe which prints a target command pathname
define mkfwk_recipe_print_command_pathname
	@$(PRINTF) '** $(1): $(MKFWK_PRINTF_FORMAT_MSG_PATHNAME): %s\n' "$$($(call mkfwk_pathname_command_invocation,$($(1))) 2>/dev/null | $(SED) -n 1p)"
endef

# Defines a recipe which prints a target command installed version
define mkfwk_recipe_print_command_version
	@$(PRINTF) '** $(1): $(MKFWK_PRINTF_FORMAT_MSG_INSTALLED_VERSION): %s\n' "$$($($(1)) $($(1)_VERSION_FLAG) | $(SED) -n 1p 2>/dev/null)" ;
endef

# Defines a canned recipe which prints whether an option type for a variable is enabled/disabled
define mkfwk_recipe_print_option_type_variable_activation
	@$(PRINTF) '** $(1)_$(2): $(if $($(1)_$(2)),$(MKFWK_MSG_FOR_ON),$(MKFWK_MSG_FOR_OFF))\n'
endef

# Defines a canned recipe which prints a command's basic info: its installed pathname and version
define mkfwk_recipe_print_command_info
	$(call mkfwk_recipe_print_command_pathname,$(1))
	$(call mkfwk_recipe_print_command_version,$(1))
endef

endif
## Ending of skippable verbose section

# Defines new flag variables from existing ones, indicating whether the checks for the corresponding variable have already been performed (if its value is non-empty) or not yet (if else), initializing them as empty.
$(foreach variable,CC YACC LEX AR GDB VALGRIND RANLIB,$(eval MKFWK_HAVE_CHECKED-$(variable)=))

# Defines a recipe which checks the indispensable target-specific command: CC
define MKFWK_RECIPE_CHECK_INDISPENSABLE_TARGET_COMMAND-CC
	$(call mkfwk_recipe_check_indispensable_target_command,CC)
	$(call mkfwk_recipe_print_command_info,CC)
	$(call mkfwk_recipe_print_option_type_variable_activation,CC,WARNINGS)
	$(call mkfwk_recipe_print_option_type_variable_activation,CC,DEBUG)
endef

# Defines a recipe which checks the indispensable target-specific command: YACC
define MKFWK_RECIPE_CHECK_INDISPENSABLE_TARGET_COMMAND-YACC
	$(call mkfwk_recipe_check_indispensable_target_command,YACC)
	$(call mkfwk_recipe_print_command_info,YACC)
	$(call mkfwk_recipe_print_option_type_variable_activation,YACC,WARNINGS)
	$(call mkfwk_recipe_print_option_type_variable_activation,YACC,DEBUG)
endef

# Defines a recipe which checks the indispensable target-specific command: LEX
define MKFWK_RECIPE_CHECK_INDISPENSABLE_TARGET_COMMAND-LEX
	$(call mkfwk_recipe_check_indispensable_target_command,LEX)
	$(call mkfwk_recipe_print_command_info,LEX)
	$(call mkfwk_recipe_print_option_type_variable_activation,LEX,WARNINGS)
	$(call mkfwk_recipe_print_option_type_variable_activation,LEX,DEBUG)
endef

# Defines a recipe which checks the indispensable target-specific command: AR
define MKFWK_RECIPE_CHECK_INDISPENSABLE_TARGET_COMMAND-AR
	$(call mkfwk_recipe_check_indispensable_target_command,AR)
	$(call mkfwk_recipe_print_command_info,AR)
endef

# Defines a recipe which checks the indispensable target-specific command: GDB
define MKFWK_RECIPE_CHECK_INDISPENSABLE_TARGET_COMMAND-GDB
	$(call mkfwk_recipe_check_indispensable_target_command,GDB)
	$(call mkfwk_recipe_print_command_info,GDB)
endef

# Defines a recipe which checks the indispensable target-specific command: VALGRIND
define MKFWK_RECIPE_CHECK_INDISPENSABLE_TARGET_COMMAND-VALGRIND
	$(call mkfwk_recipe_check_indispensable_target_command,VALGRIND)
	$(call mkfwk_recipe_print_command_info,VALGRIND)
endef

# Defines a recipe which checks the dispensable target-specific command: RANLIB
define MKFWK_RECIPE_CHECK_DISPENSABLE_TARGET_COMMAND-RANLIB
	$(call mkfwk_recipe_check_dispensable_target_command,RANLIB)
	$(if $(MKFWK_HAVE_COMMAND-RANLIB),$(call mkfwk_recipe_print_command_info,RANLIB))
endef

# Defines a canned sequence of commands which removes a file if exists
define mkfwk_sh_remove_file
	if [ -f $(1) ]; then \
		$(if $(VERBOSE),$(PRINTF) '\n<<< $(MKFWK_PRINTF_FORMAT_MSG_REMOVING) $(2): "%s" >>>\n' $(1) ;) \
		set -x ; \
			$(RM) $(RMFLAGS) $(1) ; \
		{ set +x ; } 2>/dev/null ; \
		$(if $(VERBOSE),$(PRINTF) '<<< $(MKFWK_PRINTF_FORMAT_MSG_DONE) >>>\n' ;) \
	fi ;
endef

# Defines a canned recipe which removes files using for loops
define mkfwk_recipe_remove_files_for_loop
	@for BASEPATH in $(1) ; do \
		for SUFFIX in $(2) ; do \
			$(call mkfwk_sh_remove_file,"$$BASEPATH""$$SUFFIX",$(3)) \
		done ; \
	done
endef

# Defines a canned recipe which removes files if any were passed as an argument
define mkfwk_recipe_remove_files_if_any
$(if $(filter-out '',$(1)),$(call mkfwk_recipe_remove_files_for_loop,$(1),$(2),$(3)))
endef

# Defines a canned sequence of commands which removes a directory if exists
define mkfwk_sh_remove_directory
	if [ -d $(1) ]; then \
		$(if $(VERBOSE),$(PRINTF) '\n<<< $(MKFWK_PRINTF_FORMAT_MSG_REMOVING_DIRECTORY): "%s" >>>\n' $(1) ;) \
		set -x ; \
			$(RMDIR) $(1) 2>/dev/null || $(TRUE) ; \
		{ set +x ; } 2>/dev/null ; \
		$(if $(VERBOSE),$(PRINTF) '<<< $(MKFWK_PRINTF_FORMAT_MSG_DONE) >>>\n' ;) \
	fi ;
endef

# Defines a canned recipe which removes directories using a for loop
define mkfwk_recipe_remove_directories_for_loop
	@for DIRECTORY in $(1) ; do \
		$(call mkfwk_sh_remove_directory,"$$DIRECTORY") \
	done
endef

# Defines a canned recipe which removes directories if any were passed as an argument
define mkfwk_recipe_remove_directories_if_any
$(if $(filter-out '',$(1)),$(call mkfwk_recipe_remove_directories_for_loop,$(1)))
endef

# With this, make will delete the target of a rule if it has changed and its recipe exits with a nonzero exit status, just as it does when it receives a signal
.DELETE_ON_ERROR:
#   This is because usually when a recipe line fails, if it has changed the target file at all, the file is corrupted and cannot be used—or at least it is not completely updated.
#     Yet the file's timestamp says that it is now up to date, so the next time make runs, it will not try to update that file