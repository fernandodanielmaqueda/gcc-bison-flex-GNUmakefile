# Filename: executing.mk / v2024.03.25-001, part of gcc-bison-flex-GNUmakefile
# Makefile containing executing targets
# Copyright (C) 2022-2024 Fernando Daniel Maqueda <https://github.com/fernandodanielmaqueda/>
# You should have received a copy of the GNU General Public License along with this. If not, see <https://www.gnu.org/licenses/>.

# Prevents GNU Make from even considering to remake this very same makefile, as that isn't necessary, thus optimizing startup time
.PHONY: $(MKFWK_FOOTER_DIR)executing.mk

# Defines a canned recipe that checks if a program exists
define MKFWK_RECIPE_CHECK_TARGET_PROGRAM_EXISTENCE
	@if ! [ -f '$(TARGET_PROGRAM)' ]; then \
		$(PRINTF) '\n$(MKFWK_PRINTF_FORMAT_MSG_EXCEPTION_PROGRAM_DOES_NOT_EXIST): "%s". $(MKFWK_PRINTF_FORMAT_MSG_MUST_BE_BUILT_FIRST)...\n' '$(TARGET_PROGRAM)' ; \
		exit 1 ; \
	fi ;
endef

# Parses an explicit rule to run the target program in the very same window
.PHONY: run
run:
ifneq ($(MUST_MAKE),)
	@$(PRINTF) '  * $(MKFWK_PRINTF_FORMAT_MSG_MUST_MAKE_TARGET) "%s".\n' '$@'
else
	$(if $(VERBOSE),@$(PRINTF) '\n#####( [run] $(MKFWK_PRINTF_FORMAT_MSG_INIT_TARGET-run) )#####\n')
	$(MKFWK_RECIPE_CHECK_TARGET_PROGRAM_EXISTENCE)
	$(if $(VERBOSE),@$(PRINTF) '\n<<< $(MKFWK_PRINTF_FORMAT_MSG_RELATIVE_PATH) (./): $(MKFWK_PRINTF_FORMAT_MSG_DO_TARGET-run): "%s" >>>\n' '$(TARGET_PROGRAM)')
	$(if $(call mkfwk_dirname,$(TARGET_PROGRAM)),cd '$(call mkfwk_dirname,$(TARGET_PROGRAM))',:) ; \
 './$(notdir $(TARGET_PROGRAM))' $(TARGET_PROGRAM_ARGS) ; \
 $(if $(call mkfwk_dirname,$(TARGET_PROGRAM)),cd - >/dev/null,:) ;
	$(if $(VERBOSE),@$(PRINTF) '<<< $(MKFWK_PRINTF_FORMAT_MSG_DONE) >>>\n')
	$(if $(VERBOSE),@$(PRINTF) '\n#####( $(MKFWK_PRINTF_FORMAT_MSG_FINISHED) )#####\n')
endif

# Parses an explicit rule to debug the target program using GDB in the very same window through a command-line interface (CLI)
.PHONY: gdb
gdb:
ifneq ($(MUST_MAKE),)
	@$(PRINTF) '  * $(MKFWK_PRINTF_FORMAT_MSG_MUST_MAKE_TARGET) "%s".\n' '$@'
else
	$(if $(MKFWK_HAVE_CHECKED-GDB),,$(MKFWK_RECIPE_CHECK_INDISPENSABLE_TARGET_COMMAND-GDB))
	$(if $(VERBOSE),@$(PRINTF) '\n#####( [gdb] $(MKFWK_PRINTF_FORMAT_MSG_INIT_TARGET-gdb) )#####\n')
	$(MKFWK_RECIPE_CHECK_TARGET_PROGRAM_EXISTENCE)
	$(if $(VERBOSE),@$(PRINTF) '\n<<< GDB: $(MKFWK_PRINTF_FORMAT_MSG_DO_TARGET-gdb): "%s" >>>\n' '$(TARGET_PROGRAM)')
	$(if $(call mkfwk_dirname,$(TARGET_PROGRAM)),cd '$(call mkfwk_dirname,$(TARGET_PROGRAM))',:) ; \
 $(GDB) $(GDBFLAGS) './$(notdir $(TARGET_PROGRAM))' $(TARGET_PROGRAM_ARGS) ; \
 $(if $(call mkfwk_dirname,$(TARGET_PROGRAM)),cd - >/dev/null,:) ;
	$(if $(VERBOSE),@$(PRINTF) '<<< $(MKFWK_PRINTF_FORMAT_MSG_DONE) >>>\n')
	$(if $(VERBOSE),@$(PRINTF) '\n#####( $(MKFWK_PRINTF_FORMAT_MSG_FINISHED) )#####\n')
endif

# Defines an explicit rule that runs Valgrind using a specific tool in the very same window
define mkfwk_rule_for_valgrind
.PHONY: valgrind-$(1)
valgrind-$(1):
ifneq ($$(MUST_MAKE),)
	@$$(PRINTF) '  * $$(MKFWK_PRINTF_FORMAT_MSG_MUST_MAKE_TARGET) "%s".\n' '$$@'
else
	$$(if $$(MKFWK_HAVE_CHECKED-VALGRIND),,$$(MKFWK_RECIPE_CHECK_INDISPENSABLE_TARGET_COMMAND-VALGRIND))
	$(if $(VERBOSE),@$$(PRINTF) '\n#####( [valgrind-$(1)] $$(MKFWK_PRINTF_FORMAT_MSG_INIT_TARGET-valgrind) )#####\n')
	$$(MKFWK_RECIPE_CHECK_TARGET_PROGRAM_EXISTENCE)
	$(if $(VERBOSE),@$$(PRINTF) '\n<<< VALGRIND: $$(MKFWK_PRINTF_FORMAT_MSG_DO_TARGET-valgrind): "%s" >>>\n' '$$(TARGET_PROGRAM)')
	$$(if $$(call mkfwk_dirname,$$(TARGET_PROGRAM)),cd '$$(call mkfwk_dirname,$$(TARGET_PROGRAM))',:) ; \
 $$(VALGRIND) $$(VALGRIND_FLAGS) --tool=$(1) $$(VALGRIND_$(1)_FLAGS) './$$(notdir $$(TARGET_PROGRAM))' $$(TARGET_PROGRAM_ARGS) \
 $$(if $$(call mkfwk_dirname,$$(TARGET_PROGRAM)),cd - >/dev/null,:) ;
	$(if $(VERBOSE),@$$(PRINTF) '<<< $$(MKFWK_PRINTF_FORMAT_MSG_DONE) >>>\n')
	$(if $(VERBOSE),@$$(PRINTF) '\n#####( $$(MKFWK_PRINTF_FORMAT_MSG_FINISHED) )#####\n')
endif
endef
$(foreach tool,$(VALGRIND_TOOLS),$(eval $(call mkfwk_rule_for_valgrind,$(tool))))
VALGRIND_TOOLS=
mkfwk_rule_for_valgrind=