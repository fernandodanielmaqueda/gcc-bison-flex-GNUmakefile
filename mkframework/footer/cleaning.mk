# Filename: cleaning.mk / v2024.03.25-001, part of gcc-bison-flex-GNUmakefile
# Makefile containing cleaning targets
# Copyright (C) 2022-2024 Fernando Daniel Maqueda <https://github.com/fernandodanielmaqueda/>
# You should have received a copy of the GNU General Public License along with this. If not, see <https://www.gnu.org/licenses/>.

# Prevents GNU Make from even considering to remake this very same makefile, as that isn't necessary, thus optimizing startup time
.PHONY: $(MKFWK_FOOTER_DIR)cleaning.mk

# Parses an explicit rule to clean the files associated with automatic dependency generation
.PHONY: cleandeps
cleandeps:
ifneq ($(MUST_MAKE),)
	@$(PRINTF) '  * $(MKFWK_PRINTF_FORMAT_MSG_MUST_MAKE_TARGET) "%s".\n' '$@'
else
	$(if $(VERBOSE),@$(PRINTF) '\n#####( [cleandeps] $(MKFWK_PRINTF_FORMAT_MSG_INIT_TARGET-cleandeps) )#####\n')
	$(call mkfwk_recipe_remove_files_if_any,'$(subst $(MKFWK_SPACE),'$(MKFWK_SPACE)',$(patsubst %.c,$(DEPDIR)%,$(patsubst %.y,$(DEPDIR)%.tab,$(patsubst %.l,$(DEPDIR)%.lex.yy,$(filter %.c %.y %.l,$(foreach prefix,BIN,$(foreach primary,PROGRAMS LIBRARIES SOLIBRARIES,$(foreach variable,$($(prefix)_$(primary)),$($(variable)_SOURCES)))))))))','d.tmp.2' '.d.tmp.1' '.d.timestamp' '.d',$(MKFWK_PRINTF_FORMAT_MSG_THE_.d_ASSOCIATED_FILE))
	$(if $(VERBOSE),@$(PRINTF) '\n#####( $(MKFWK_PRINTF_FORMAT_MSG_FINISHED) )#####\n')
endif

# Parses an explicit rule to also clean the programs and compilation output files
.PHONY: mostlyclean
mostlyclean: cleandeps
ifneq ($(MUST_MAKE),)
	@$(PRINTF) '  * $(MKFWK_PRINTF_FORMAT_MSG_MUST_MAKE_TARGET) "%s". $(MKFWK_PRINTF_FORMAT_MSG_PREREQUISITES_NEWER_THAN_TARGET): %s\n' '$@' '$<'
else
	$(if $(VERBOSE),@$(PRINTF) '\n#####( [mostlyclean] $(MKFWK_PRINTF_FORMAT_MSG_INIT_TARGET-mostlyclean) )#####\n')
	$(foreach prefix,BIN,$(foreach primary,PROGRAMS,$(foreach variable,$($(prefix)_$(primary)),@$(call mkfwk_sh_remove_file,'$($(prefix)DIR)$(variable)$(EXEEXT)',$(MKFWK_PRINTF_FORMAT_MSG_THE_PROGRAM))$(MKFWK_NEWLINE))))
	$(call mkfwk_recipe_remove_files_if_any,'$(subst $(MKFWK_SPACE),'$(MKFWK_SPACE)',$(patsubst %.c,$(OBJDIR)%,$(patsubst %.y,$(OBJDIR)%.tab,$(patsubst %.l,$(OBJDIR)%.lex.yy,$(filter %.c %.y %.l,$(foreach prefix,BIN,$(foreach primary,PROGRAMS LIBRARIES SOLIBRARIES,$(foreach variable,$($(prefix)_$(primary)),$($(variable)_SOURCES)))))))))','.o' '.s' '.i',$(MKFWK_PRINTF_FORMAT_MSG_THE_COMPILATION_OUTPUT_FILE))
	$(if $(VERBOSE),@$(PRINTF) '\n#####( $(MKFWK_PRINTF_FORMAT_MSG_FINISHED) )#####\n')
endif

# Parses an explicit rule to also clean the library files
.PHONY: clean
clean: mostlyclean
ifneq ($(MUST_MAKE),)
	@$(PRINTF) '  * $(MKFWK_PRINTF_FORMAT_MSG_MUST_MAKE_TARGET) "%s". $(MKFWK_PRINTF_FORMAT_MSG_PREREQUISITES_NEWER_THAN_TARGET): %s\n' '$@' '$<'
else
	$(if $(VERBOSE),@$(PRINTF) '\n#####( [clean] $(MKFWK_PRINTF_FORMAT_MSG_INIT_TARGET-clean) )#####\n')
	$(foreach prefix,BIN,$(foreach primary,LIBRARIES SOLIBRARIES,$(foreach variable,$($(prefix)_$(primary)),@$(call mkfwk_sh_remove_file,'$($(prefix)DIR)$(variable)',$(MKFWK_PRINTF_FORMAT_MSG_THE_LIBRARY_FILE))$(MKFWK_NEWLINE))))
	$(if $(VERBOSE),@$(PRINTF) '\n#####( $(MKFWK_PRINTF_FORMAT_MSG_FINISHED) )#####\n')
endif

# Parses an explicit rule with nothing defined to be cleaned: you may define it to your needs
.PHONY: distclean
distclean: clean
ifneq ($(MUST_MAKE),)
	@$(PRINTF) '  * $(MKFWK_PRINTF_FORMAT_MSG_MUST_MAKE_TARGET) "%s". $(MKFWK_PRINTF_FORMAT_MSG_PREREQUISITES_NEWER_THAN_TARGET): %s\n' '$@' '$<'
else
	$(if $(VERBOSE),@$(PRINTF) '\n#####( [distclean] $(MKFWK_PRINTF_FORMAT_MSG_INIT_TARGET-distclean) )#####\n')
	$(if $(VERBOSE),@$(PRINTF) '\n#####( $(MKFWK_PRINTF_FORMAT_MSG_FINISHED) )#####\n')
endif

# Parses an explicit rule with nothing defined to be cleaned: you may define it to your needs
.PHONY: realclean
realclean: distclean
ifneq ($(MUST_MAKE),)
	@$(PRINTF) '  * $(MKFWK_PRINTF_FORMAT_MSG_MUST_MAKE_TARGET) "%s". $(MKFWK_PRINTF_FORMAT_MSG_PREREQUISITES_NEWER_THAN_TARGET): %s\n' '$@' '$<'
else
	$(if $(VERBOSE),@$(PRINTF) '\n#####( [realclean] $(MKFWK_PRINTF_FORMAT_MSG_INIT_TARGET-realclean) )#####\n')
	$(if $(VERBOSE),@$(PRINTF) '\n#####( $(MKFWK_PRINTF_FORMAT_MSG_FINISHED) )#####\n')
endif

# Parses an explicit rule with nothing defined to be cleaned: you may define it to your needs
.PHONY: clobber
clobber: realclean
ifneq ($(MUST_MAKE),)
	@$(PRINTF) '  * $(MKFWK_PRINTF_FORMAT_MSG_MUST_MAKE_TARGET) "%s". $(MKFWK_PRINTF_FORMAT_MSG_PREREQUISITES_NEWER_THAN_TARGET): %s\n' '$@' '$<'
else
	$(if $(VERBOSE),@$(PRINTF) '\n#####( [clobber] $(MKFWK_PRINTF_FORMAT_MSG_INIT_TARGET-clobber) )#####\n')
	$(if $(VERBOSE),@$(PRINTF) '\n#####( $(MKFWK_PRINTF_FORMAT_MSG_FINISHED) )#####\n')
endif

# Parses an explicit rule to also clean the YACC-and-LEX-generated files
.PHONY: maintainer-clean
maintainer-clean: clobber
ifneq ($(MUST_MAKE),)
	@$(PRINTF) '  * $(MKFWK_PRINTF_FORMAT_MSG_MUST_MAKE_TARGET) "%s". $(MKFWK_PRINTF_FORMAT_MSG_PREREQUISITES_NEWER_THAN_TARGET): %s\n' '$@' '$<'
else
	$(if $(VERBOSE),@$(PRINTF) '\n#####( [maintainer-clean] $(MKFWK_PRINTF_FORMAT_MSG_INIT_TARGET-maintainer-clean) )#####\n')
	$(call mkfwk_recipe_remove_files_if_any,'$(subst $(MKFWK_SPACE),'$(MKFWK_SPACE)',$(patsubst %.l,$(OBJDIR)%,$(filter %.l,$(foreach prefix,BIN,$(foreach primary,PROGRAMS LIBRARIES SOLIBRARIES,$(foreach variable,$($(prefix)_$(primary)),$($(variable)_SOURCES)))))))','.lex.yy.c',$(MKFWK_PRINTF_FORMAT_MSG_THE_LEX_GENERATED_FILE))
	$(call mkfwk_recipe_remove_files_if_any,'$(subst $(MKFWK_SPACE),'$(MKFWK_SPACE)',$(patsubst %.y,$(OBJDIR)%,$(filter %.y,$(foreach prefix,BIN,$(foreach primary,PROGRAMS LIBRARIES SOLIBRARIES,$(foreach variable,$($(prefix)_$(primary)),$($(variable)_SOURCES)))))))','.tab.c' '.tab.h' '.output',$(MKFWK_PRINTF_FORMAT_MSG_THE_YACC_GENERATED_FILE))
	$(if $(VERBOSE),@$(PRINTF) '\n#####( $(MKFWK_PRINTF_FORMAT_MSG_FINISHED) )#####\n')
endif

# Parses an explicit rule to also remove the target directories
.PHONY: cleandirs
cleandirs: maintainer-clean
ifneq ($(MUST_MAKE),)
	@$(PRINTF) '  * $(MKFWK_PRINTF_FORMAT_MSG_MUST_MAKE_TARGET) "%s". $(MKFWK_PRINTF_FORMAT_MSG_PREREQUISITES_NEWER_THAN_TARGET): %s\n' '$@' '$<'
else
	$(if $(VERBOSE),@$(PRINTF) '\n#####( [cleandirs] $(MKFWK_PRINTF_FORMAT_MSG_INIT_TARGET-cleandirs) )#####\n')
	$(call mkfwk_recipe_remove_directories_if_any,$(shell $(PRINTF) "'%s'\n" '$(subst $(MKFWK_SPACE),'$(MKFWK_SPACE)',$(TARGET_DIRS))' | $(AWK) -F'/' '{print NF-1, $$0}' | $(SORT) -n -r -k 1,1 | $(CUT) -f 2- -d' ' ;))
	$(if $(VERBOSE),@$(PRINTF) '\n#####( $(MKFWK_PRINTF_FORMAT_MSG_FINISHED) )#####\n')
endif