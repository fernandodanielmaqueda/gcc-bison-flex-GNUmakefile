# Filename: executing.mk / v2024.04.25-001, part of gcc-bison-flex-GNUmakefile
# Makefile containing executing targets
# Copyright (C) 2022-2024 Fernando Daniel Maqueda <https://github.com/fernandodanielmaqueda/>
# You should have received a copy of the GNU General Public License along with this. If not, see <https://www.gnu.org/licenses/>.

# Prevents GNU Make from even considering to remake this very same makefile, as that isn't necessary, thus optimizing startup time
.PHONY: $(MKFWK_FOOTER_DIR)executing.mk

# Defines a canned recipe that checks if a program exists
define mkfwk_recipe_check_target_program_existence
	@if ! [ -f '$(1)' ]; then \
		$(PRINTF) '\n$(MKFWK_PRINTF_FORMAT_MSG_EXCEPTION_PROGRAM_DOES_NOT_EXIST): "%s". $(MKFWK_PRINTF_FORMAT_MSG_MUST_BE_BUILT_FIRST)...\n' '$(1)' ; \
		exit 1 ; \
	fi ;
endef

# Defines a canned recipe that changes the directory (cd), executes a command passed as a parameter, and changes to the previous directory (cd)
define mkfwk_cd_execute_and_cd_back
	$(call mkfwk_make_check_set_directory_existence,$(1))
	cd '$($(1))' ; $(MKFWK_BACKSLASH)
$(2) $(MKFWK_BACKSLASH)
cd - >/dev/null ;
endef

# Defines a canned recipe that changes the current working directory (cwd) to execute a command passed as a parameter
define mkfwk_recipe_change_cwd_to_execute
	$(if $($(1)),$(call mkfwk_cd_execute_and_cd_back,$(1),$(2)),$(2))
endef

# Defines an explicit rule that runs the target program in the very same window
define mkfwk_rule_for_run
.PHONY: run-$(2)
run-$(2):
ifneq ($$(MUST_MAKE),)
	@$$(PRINTF) '  * $$(MKFWK_PRINTF_FORMAT_MSG_MUST_MAKE_TARGET) "%s".\n' '$@'
else
	$(if $(VERBOSE),@$$(PRINTF) '\n#####( [run-$(2)] $$(MKFWK_PRINTF_FORMAT_MSG_INIT_TARGET-run) )#####\n')
	$$(call mkfwk_recipe_check_target_program_existence,$$($(1)DIR)$(2)$$(EXEEXT))
	$(if $(VERBOSE),@$$(PRINTF) '\n<<< $$(MKFWK_PRINTF_FORMAT_MSG_ABSOLUTE_PATH) (/): $$(MKFWK_PRINTF_FORMAT_MSG_DO_TARGET-run): "%s" >>>\n' '$$($(1)DIR)$(2)$$(EXEEXT)')
	$$(call mkfwk_recipe_change_cwd_to_execute,$(2)_CWD,'$$(abspath $$($(1)DIR)$(2)$$(EXEEXT))' $$($(2)_ARGS) ;)
	$(if $(VERBOSE),@$$(PRINTF) '<<< $$(MKFWK_PRINTF_FORMAT_MSG_DONE) >>>\n')
	$(if $(VERBOSE),@$$(PRINTF) '\n#####( $$(MKFWK_PRINTF_FORMAT_MSG_FINISHED) )#####\n')
endif
endef
$(foreach prefix,$(BINARY_PREFIXES),$(foreach variable,$($(prefix)_PROGRAMS),$(eval $(call mkfwk_rule_for_run,$(prefix),$(variable)))))
mkfwk_rule_for_run=

# Defines an explicit rule that debugs the target program using GDB in the very same window through a command-line interface (CLI)
define mkfwk_rule_for_gdb
.PHONY: gdb-$(2)
gdb-$(2):
ifneq ($$(MUST_MAKE),)
	@$$(PRINTF) '  * $$(MKFWK_PRINTF_FORMAT_MSG_MUST_MAKE_TARGET) "%s".\n' '$@'
else
	$$(if $$(MKFWK_HAVE_CHECKED-GDB),,$$(MKFWK_RECIPE_CHECK_INDISPENSABLE_TARGET_COMMAND-GDB))
	$(if $(VERBOSE),@$$(PRINTF) '\n#####( [gdb-$(2)] $$(MKFWK_PRINTF_FORMAT_MSG_INIT_TARGET-gdb) )#####\n')
	$$(call mkfwk_recipe_check_target_program_existence,$$($(1)DIR)$(2)$$(EXEEXT))
	$(if $(VERBOSE),@$$(PRINTF) '\n<<< GDB: $$(MKFWK_PRINTF_FORMAT_MSG_DO_TARGET-gdb): "%s" >>>\n' '$$($(1)DIR)$(2)$$(EXEEXT)')
	$$(call mkfwk_recipe_change_cwd_to_execute,$(2)_CWD,$$(GDB) $$(GDBFLAGS) '$$(abspath $$($(1)DIR)$(2)$$(EXEEXT))' $$($(2)_ARGS) ;)
	$(if $(VERBOSE),@$$(PRINTF) '<<< $$(MKFWK_PRINTF_FORMAT_MSG_DONE) >>>\n')
	$(if $(VERBOSE),@$$(PRINTF) '\n#####( $$(MKFWK_PRINTF_FORMAT_MSG_FINISHED) )#####\n')
endif
endef
$(foreach prefix,$(BINARY_PREFIXES),$(foreach variable,$($(prefix)_PROGRAMS),$(eval $(call mkfwk_rule_for_gdb,$(prefix),$(variable)))))
mkfwk_rule_for_gdb=

# Defines an explicit rule that runs Valgrind using a specific tool in the very same window
define mkfwk_rule_for_valgrind
.PHONY: valgrind-$(1)-$(3)
valgrind-$(1)-$(3):
ifneq ($$(MUST_MAKE),)
	@$$(PRINTF) '  * $$(MKFWK_PRINTF_FORMAT_MSG_MUST_MAKE_TARGET) "%s".\n' '$$@'
else
	$$(if $$(MKFWK_HAVE_CHECKED-VALGRIND),,$$(MKFWK_RECIPE_CHECK_INDISPENSABLE_TARGET_COMMAND-VALGRIND))
	$(if $(VERBOSE),@$$(PRINTF) '\n#####( [valgrind-$(1)-$(3)] $$(MKFWK_PRINTF_FORMAT_MSG_INIT_TARGET-valgrind) )#####\n')
	$$(call mkfwk_recipe_check_target_program_existence,$$($(2)DIR)$(3)$$(EXEEXT))
	$(if $(VERBOSE),@$$(PRINTF) '\n<<< VALGRIND: $$(MKFWK_PRINTF_FORMAT_MSG_DO_TARGET-valgrind): "%s" >>>\n' '$$($(2)DIR)$(3)$$(EXEEXT)')
	$$(call mkfwk_recipe_change_cwd_to_execute,$(2)_CWD,$$(VALGRIND) $$(VALGRIND_FLAGS) --tool=$(1) $$(VALGRIND_$(1)_FLAGS) '$$(abspath $$($(2)DIR)$(3)$$(EXEEXT))' $$($(3)_ARGS) ;)
	$(if $(VERBOSE),@$$(PRINTF) '<<< $$(MKFWK_PRINTF_FORMAT_MSG_DONE) >>>\n')
	$(if $(VERBOSE),@$$(PRINTF) '\n#####( $$(MKFWK_PRINTF_FORMAT_MSG_FINISHED) )#####\n')
endif
endef
$(foreach prefix,$(BINARY_PREFIXES),$(foreach variable,$($(prefix)_PROGRAMS),$(foreach tool,$(VALGRIND_TOOLS),$(eval $(call mkfwk_rule_for_valgrind,$(tool),$(prefix),$(variable))))))
VALGRIND_TOOLS=
mkfwk_rule_for_valgrind=