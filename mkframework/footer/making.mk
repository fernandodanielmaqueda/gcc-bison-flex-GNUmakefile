# Filename: making.mk / v2024.03.25-001, part of gcc-bison-flex-GNUmakefile
# Makefile containing targets to actually make
# Copyright (C) 2022-2024 Fernando Daniel Maqueda <https://github.com/fernandodanielmaqueda/>
# You should have received a copy of the GNU General Public License along with this. If not, see <https://www.gnu.org/licenses/>.

# Prevents GNU Make from even considering to remake this very same makefile, as that isn't necessary, thus optimizing startup time
.PHONY: $(MKFWK_FOOTER_DIR)making.mk

# Adds the -fpic option to be passed to CC when compiling each shared library
$(foreach basename,$(foreach prefix,BIN,$(foreach primary,SOLIBRARIES,$($(prefix)_$(primary)))),$(eval $(basename)_CFLAGS+=-fpic))

# Adds the primary options to their source files
$(foreach basename,$(foreach prefix,BIN,$(foreach primary,PROGRAMS LIBRARIES SOLIBRARIES,$($(prefix)_$(primary)))),$(foreach source,$(sort $(filter %.c %.y %.l,$($(basename)_SOURCES))),\
  $(eval $(source)_CPPFLAGS+=$($(basename)_CPPFLAGS)) \
  $(eval $(source)_CFLAGS+=$($(basename)_CFLAGS)) \
  $(eval $(source)_ASFLAGS+=$($(basename)_ASFLAGS)) \
))

# Produces the pathnames of the header files with YACC definitions to (re)generate ($(OBJDIR)*.tab.h)
MKFWK_YDEFS=$(patsubst %.y,$(OBJDIR)%.tab.h,$(filter %.y,$(foreach prefix,BIN,$(foreach primary,PROGRAMS LIBRARIES SOLIBRARIES,$(foreach basename,$($(prefix)_$(primary)),$($(basename)_SOURCES))))))

# Defines new variables from existing ones but removing any trailing slash, so it can be directly used as a prerequisite name
$(foreach prefix,BIN,$(eval MKFWK_TRAILING_SLASH_REMOVED-$(prefix)DIR:=$(patsubst %/,%,$($(prefix)DIR))))

# Parses an explicit rule with an empty recipe which does nothing
.PHONY: empty
empty: ;
#   This target is set as the default goal in the makefiles with automatically generated dependencies that are made ($(DEPDIR)*.d files) ensuring that when they are included, no other target gets made

# If the INCLUDE_DEPS option is enabled, includes the makefiles with automatically generated dependencies ($(DEPDIR)*.d files) whether they are already made or not
ifneq ($(INCLUDE_DEPS),)
sinclude $(patsubst %.c,$(DEPDIR)%.d,$(patsubst %.y,$(DEPDIR)%.tab.d,$(patsubst %.l,$(DEPDIR)%.lex.yy.d,$(filter %.c %.y %.l,$(foreach prefix,BIN,$(foreach primary,PROGRAMS LIBRARIES SOLIBRARIES,$(foreach basename,$($(prefix)_$(primary)),$($(basename)_SOURCES))))))))
endif

# Defines a canned recipe which prints a note explaining how YACC debugging works
ifneq ($(VERBOSE),)
define MKFWK_RECIPE_PRINT_YACC_DEBUG_NOTE
	@$(PRINTF) '%s\n' \
		'' \
		$(MKFWK_PRINTF_STRINGS_MSG_NOTE_YACC_DEBUGGING) \
		'    #if YYDEBUG' \
		'      yydebug = 1;' \
		'    #endif' ;
endef
endif

# Defines an explicit rule that (re)makes a program and then parses it for each one of them
define mkfwk_rule_for_program
$$($(1)DIR)$(2)$$(EXEEXT): \
  $$(shell $$(PRINTF) '%s\n' '$$(subst $$(MKFWK_SPACE),'$$(MKFWK_SPACE)',$$($(2)_SOURCES))' | $$(SED) \
      -e '/\.c$$$$/ s?\(.*\)\.c$$$$?$$(DEPDIR)\1.d.timestamp $(if $(GENERATE_ASSEMBLING_OUTPUT)$(GENERATE_COMPILING_OUTPUT)$(GENERATE_PREPROCESSING_OUTPUT),$$(OBJDIR))\1$(if $(GENERATE_ASSEMBLING_OUTPUT),.o,$(if $(GENERATE_COMPILING_OUTPUT),.s,$(if $(GENERATE_PREPROCESSING_OUTPUT),.i,.c)))?' \
      -e '/\.y$$$$/ s?\(.*\)\.y$$$$?$$(DEPDIR)\1.tab.d.timestamp $$(OBJDIR)\1$(if $(GENERATE_ASSEMBLING_OUTPUT),.tab.o,$(if $(GENERATE_COMPILING_OUTPUT),.tab.s,$(if $(GENERATE_PREPROCESSING_OUTPUT),.tab.i,.tab.c)))?' \
      -e '/\.l$$$$/ s?\(.*\)\.l$$$$?$$(DEPDIR)\1.lex.yy.d.timestamp $$(OBJDIR)\1$(if $(GENERATE_ASSEMBLING_OUTPUT),.lex.yy.o,$(if $(GENERATE_COMPILING_OUTPUT),.lex.yy.s,$(if $(GENERATE_PREPROCESSING_OUTPUT),.lex.yy.i,.lex.yy.c)))?' \
    ;) \
  | $$(MKFWK_TRAILING_SLASH_REMOVED-$(1)DIR)
ifneq ($$(MUST_MAKE),)
	@$$(PRINTF) '  * $$(MKFWK_PRINTF_FORMAT_MSG_MUST_REMAKE_TARGET) "%s". $$(MKFWK_PRINTF_FORMAT_MSG_PREREQUISITES_NEWER_THAN_TARGET): %s\n' '$$@' '$$?'
else
	$$(if $$(MKFWK_HAVE_CHECKED-CC),,$$(MKFWK_RECIPE_CHECK_INDISPENSABLE_TARGET_COMMAND-CC))
	$(if $(GENERATE_ASSEMBLING_OUTPUT)$(GENERATE_COMPILING_OUTPUT)$(GENERATE_PREPROCESSING_OUTPUT),,$$(call mkfwk_recipe_for_all_.d_files,$(2)))
	@$$(call mkfwk_sh_remove_file,'$$@',$$(MKFWK_PRINTF_FORMAT_MSG_THE_ALREADY_EXISTING_PROGRAM))
	$(if $(VERBOSE),@$$(PRINTF) '\n<<< CC: $$(MKFWK_PRINTF_FORMAT_MSG_REGENERATING_THE_PROGRAM): "%s" >>>\n' '$$@')
	$$(CC) $(if $(GENERATE_ASSEMBLING_OUTPUT)$(GENERATE_COMPILING_OUTPUT)$(GENERATE_PREPROCESSING_OUTPUT),,$$(CPPFLAGS) $$($(2)_CPPFLAGS) $$(if $$(filter %.y,$$($(2)_SOURCES)),$(if $(DEBUG_YACC),-DYYDEBUG=1,-DYYDEBUG=0))) $$(CFLAGS) $$($(2)_CFLAGS) $(if $(GENERATE_ASSEMBLING_OUTPUT),,$$(ASFLAGS) $$($(2)_ASFLAGS)) $$(LDFLAGS) $$($(2)_LDFLAGS) $(MKFWK_BACKSLASH)
 -o'$$@' $(MKFWK_BACKSLASH)
 $$(patsubst %.l,'$$(OBJDIR)%$(if $(GENERATE_ASSEMBLING_OUTPUT),.lex.yy.o,$(if $(GENERATE_COMPILING_OUTPUT),.lex.yy.s,$(if $(GENERATE_PREPROCESSING_OUTPUT),.lex.yy.i,.lex.yy.c)))',\
 $$(patsubst %.y,'$$(OBJDIR)%$(if $(GENERATE_ASSEMBLING_OUTPUT),.tab.o,$(if $(GENERATE_COMPILING_OUTPUT),.tab.s,$(if $(GENERATE_PREPROCESSING_OUTPUT),.tab.i,.tab.c)))',\
 $$(patsubst %.c,'$(if $(GENERATE_ASSEMBLING_OUTPUT)$(GENERATE_COMPILING_OUTPUT)$(GENERATE_PREPROCESSING_OUTPUT),$$(OBJDIR))%$(if $(GENERATE_ASSEMBLING_OUTPUT),.o,$(if $(GENERATE_COMPILING_OUTPUT),.s,$(if $(GENERATE_PREPROCESSING_OUTPUT),.i,.c)))',\
 $$($(2)_LDADD)))) $(MKFWK_BACKSLASH)
 $$(LDLIBS) $$(if $$(filter %.y,$$($(2)_SOURCES)),-ly) $$(if $$(filter %.l,$$($(2)_SOURCES)),-lfl)
	$(if $(VERBOSE),@$$(PRINTF) '<<< $$(MKFWK_PRINTF_FORMAT_MSG_DONE) >>>\n')
	$(if $(VERBOSE),$$(if $$(filter %.y,$$($(2)_SOURCES)),$(if $(DEBUG_YACC),$$(MKFWK_RECIPE_PRINT_YACC_DEBUG_NOTE))))
endif
endef
$(foreach prefix,BIN,$(foreach variable,$($(prefix)_PROGRAMS),$(eval $(call mkfwk_rule_for_program,$(prefix),$(variable)))))
mkfwk_rule_for_program=

# Defines an explicit rule that (re)makes a shared library and then parses it for each one of them
define mkfwk_rule_for_shared_library
$$($(1)DIR)$(2): \
  $$(shell $$(PRINTF) '%s\n' '$$(subst $$(MKFWK_SPACE),'$$(MKFWK_SPACE)',$$($(2)_SOURCES))' | $$(SED) \
      -e '/\.c$$$$/ s?\(.*\)\.c$$$$?$$(DEPDIR)\1.d.timestamp $(if $(GENERATE_ASSEMBLING_OUTPUT)$(GENERATE_COMPILING_OUTPUT)$(GENERATE_PREPROCESSING_OUTPUT),$$(OBJDIR))\1$(if $(GENERATE_ASSEMBLING_OUTPUT),.o,$(if $(GENERATE_COMPILING_OUTPUT),.s,$(if $(GENERATE_PREPROCESSING_OUTPUT),.i,.c)))?' \
      -e '/\.y$$$$/ s?\(.*\)\.y$$$$?$$(DEPDIR)\1.tab.d.timestamp $$(OBJDIR)\1$(if $(GENERATE_ASSEMBLING_OUTPUT),.tab.o,$(if $(GENERATE_COMPILING_OUTPUT),.tab.s,$(if $(GENERATE_PREPROCESSING_OUTPUT),.tab.i,.tab.c)))?' \
      -e '/\.l$$$$/ s?\(.*\)\.l$$$$?$$(DEPDIR)\1.lex.yy.d.timestamp $$(OBJDIR)\1$(if $(GENERATE_ASSEMBLING_OUTPUT),.lex.yy.o,$(if $(GENERATE_COMPILING_OUTPUT),.lex.yy.s,$(if $(GENERATE_PREPROCESSING_OUTPUT),.lex.yy.i,.lex.yy.c)))?' \
    ;) \
  | $$(MKFWK_TRAILING_SLASH_REMOVED-$(1)DIR)
ifneq ($$(MUST_MAKE),)
	@$$(PRINTF) '  * $$(MKFWK_PRINTF_FORMAT_MSG_MUST_REMAKE_TARGET) "%s". $$(MKFWK_PRINTF_FORMAT_MSG_PREREQUISITES_NEWER_THAN_TARGET): %s\n' '$$@' '$$?'
else
	$$(if $$(MKFWK_HAVE_CHECKED-CC),,$$(MKFWK_RECIPE_CHECK_INDISPENSABLE_TARGET_COMMAND-CC))
	$(if $(GENERATE_ASSEMBLING_OUTPUT)$(GENERATE_COMPILING_OUTPUT)$(GENERATE_PREPROCESSING_OUTPUT),,$$(call mkfwk_recipe_for_all_.d_files,$(2)))
	$(if $(VERBOSE),@$$(PRINTF) '\n<<< CC: $$(MKFWK_PRINTF_FORMAT_MSG_REGENERATING_THE_LIBRARY_FILE): "%s" >>>\n' '$$@')
	$$(CC) $(if $(GENERATE_ASSEMBLING_OUTPUT)$(GENERATE_COMPILING_OUTPUT)$(GENERATE_PREPROCESSING_OUTPUT),,$$(CPPFLAGS) $$($(2)_CPPFLAGS) $$(if $$(filter %.y,$$($(2)_SOURCES)),$(if $(DEBUG_YACC),-DYYDEBUG=1,-DYYDEBUG=0))) $$(CFLAGS) $$($(2)_CFLAGS) $(if $(GENERATE_ASSEMBLING_OUTPUT),,$$(ASFLAGS) $$($(2)_ASFLAGS)) $$(LDFLAGS) $$($(2)_LDFLAGS) -shared -Wl,-soname,'$(2)' $(MKFWK_BACKSLASH)
 -o'$$@' $(MKFWK_BACKSLASH)
 $$(patsubst %.l,'$$(OBJDIR)%$(if $(GENERATE_ASSEMBLING_OUTPUT),.lex.yy.o,$(if $(GENERATE_COMPILING_OUTPUT),.lex.yy.s,$(if $(GENERATE_PREPROCESSING_OUTPUT),.lex.yy.i,.lex.yy.c)))',\
 $$(patsubst %.y,'$$(OBJDIR)%$(if $(GENERATE_ASSEMBLING_OUTPUT),.tab.o,$(if $(GENERATE_COMPILING_OUTPUT),.tab.s,$(if $(GENERATE_PREPROCESSING_OUTPUT),.tab.i,.tab.c)))',\
 $$(patsubst %.c,'$(if $(GENERATE_ASSEMBLING_OUTPUT)$(GENERATE_COMPILING_OUTPUT)$(GENERATE_PREPROCESSING_OUTPUT),$$(OBJDIR))%$(if $(GENERATE_ASSEMBLING_OUTPUT),.o,$(if $(GENERATE_COMPILING_OUTPUT),.s,$(if $(GENERATE_PREPROCESSING_OUTPUT),.i,.c)))',\
 $$($(2)_LDADD)))) $(MKFWK_BACKSLASH)
 $$(LDLIBS) $$(if $$(filter %.y,$$($(2)_SOURCES)),-ly) $$(if $$(filter %.l,$$($(2)_SOURCES)),-lfl)
	$(if $(VERBOSE),@$$(PRINTF) '<<< $$(MKFWK_PRINTF_FORMAT_MSG_DONE) >>>\n')
	$(if $(VERBOSE),$$(if $$(filter %.y,$$($(2)_SOURCES)),$(if $(DEBUG_YACC),$$(MKFWK_RECIPE_PRINT_YACC_DEBUG_NOTE))))
endif
endef
$(foreach prefix,BIN,$(foreach variable,$($(prefix)_SOLIBRARIES),$(eval $(call mkfwk_rule_for_shared_library,$(prefix),$(variable)))))
mkfwk_rule_for_shared_library=

# Defines a canned recipe which executes the RANLIB command for updating the symbol table of an archive
define MKFWK_RECIPE_FOR_RANLIB
	$(if $(VERBOSE),@$(PRINTF) '\n<<< RANLIB: $(MKFWK_PRINTF_FORMAT_MSG_EXECUTING_RANLIB): "%s" >>>\n' '$@')
	$(RANLIB) '$@'
	$(if $(VERBOSE),@$(PRINTF) '<<< $(MKFWK_PRINTF_FORMAT_MSG_DONE) >>>\n')
endef

# Defines an explicit rule that (re)makes a static library and then parses it for each one of them
define mkfwk_rule_for_static_library
$$($(1)DIR)$(2): \
  $$(shell $$(PRINTF) '%s\n' '$$(subst $$(MKFWK_SPACE),'$$(MKFWK_SPACE)',$$($(2)_SOURCES))' | $$(SED) \
      -e '/\.c$$$$/ s?\(.*\)\.c$$$$?$$(DEPDIR)\1.d.timestamp $$(OBJDIR)\1.o?' \
      -e '/\.y$$$$/ s?\(.*\)\.y$$$$?$$(DEPDIR)\1.tab.d.timestamp $$(OBJDIR)\1.tab.o?' \
      -e '/\.l$$$$/ s?\(.*\)\.l$$$$?$$(DEPDIR)\1.lex.yy.d.timestamp $$(OBJDIR)\1.lex.yy.o?' \
    ;) \
  | $$(MKFWK_TRAILING_SLASH_REMOVED-$(1)DIR)
ifeq ($$(MKFWK_HAVE_ACTIVATED_OPTION_-t_--touch),)
ifneq ($$(MUST_MAKE),)
	@$$(PRINTF) '  * $$(MKFWK_PRINTF_FORMAT_MSG_MUST_REMAKE_TARGET) "%s". $$(MKFWK_PRINTF_FORMAT_MSG_PREREQUISITES_NEWER_THAN_TARGET): %s\n' '$$@' '$$?'
else
	$$(if $$(MKFWK_HAVE_CHECKED-AR),,$$(MKFWK_RECIPE_CHECK_INDISPENSABLE_TARGET_COMMAND-AR))
	$(if $(VERBOSE),@$$(PRINTF) '\n<<< AR: $$(MKFWK_PRINTF_FORMAT_MSG_REPLACING_ARCHIVE): "%s" >>>\n' '$$@')
	$$(AR) $$(ARFLAGS) '$$@' '$$(subst $$(MKFWK_SPACE),'$$(MKFWK_SPACE)',$$(filter %.o,$$?))'
	$(if $(VERBOSE),@$$(PRINTF) '<<< $$(MKFWK_PRINTF_FORMAT_MSG_DONE) >>>\n')
	$$(if $$(MKFWK_HAVE_CHECKED-RANLIB),,$$(MKFWK_RECIPE_CHECK_DISPENSABLE_TARGET_COMMAND-RANLIB))
	$$(if $$(MKFWK_HAVE_COMMAND-RANLIB),$$(MKFWK_RECIPE_FOR_RANLIB))
	$(if $(VERBOSE),$$(if $$(filter %.y,$$($(2)_SOURCES)),$(if $(DEBUG_YACC),$$(MKFWK_RECIPE_PRINT_YACC_DEBUG_NOTE))))
endif
else
	+$$(TOUCH) '$$@'
	+$$(if $$(MKFWK_HAVE_CHECKED-RANLIB),,$$(call MKFWK_RECIPE_CHECK_DISPENSABLE_TARGET_COMMAND,RANLIB))
	+$$(if $$(MKFWK_HAVE_COMMAND-RANLIB),$$(RANLIB) -t '$$@' 2>/dev/null || $(TRUE))
endif
endef
$(foreach prefix,BIN,$(foreach variable,$($(prefix)_LIBRARIES),$(eval $(call mkfwk_rule_for_static_library,$(prefix),$(variable)))))
mkfwk_rule_for_static_library=

# Enables a secondary expansion of the prerequisite list for all the rules that are parsed onwards
.SECONDEXPANSION:
#   This allows using GNU Make's functions and automatic variables in the prerequisite lists

# Parses a pattern rule that (re)makes the files for the parser implementation: $(OBJDIR)*.tab.c , $(OBJDIR)*.tab.h and $(OBJDIR)*.output
$(OBJDIR)%.tab.c \
$(OBJDIR)%.tab.h \
$(OBJDIR)%.output: \
  %.y \
  | $$(call mkfwk_dirname,$$@)
ifneq ($(MUST_MAKE),)
	@$(PRINTF) '  * $(MKFWK_PRINTF_FORMAT_MSG_MUST_REMAKE_TARGET) "%s". $(MKFWK_PRINTF_FORMAT_MSG_PREREQUISITES_NEWER_THAN_TARGET): %s\n' '$@' '$?'
else
	$(if $(MKFWK_HAVE_CHECKED-YACC),,$(MKFWK_RECIPE_CHECK_INDISPENSABLE_TARGET_COMMAND-YACC))
	$(if $(VERBOSE),@$(PRINTF) '\n<<< YACC: $(MKFWK_PRINTF_FORMAT_MSG_REGENERATING_THE_.tab.c_.tab.h_.output_FILES): "%s"[.tab.c][.tab.h][.output] >>>\n' '$(OBJDIR)$*')
	$(YACC) $(YFLAGS) $($<_YFLAGS) \
 -d -v -o'$(OBJDIR)$*.tab.c' '$<'
	$(if $(VERBOSE),@$(PRINTF) '<<< $(MKFWK_PRINTF_FORMAT_MSG_DONE) >>>\n')
endif

# Parses a pattern rule that (re)makes the files for the scanner implementation: $(OBJDIR)*.lex.yy.c
$(OBJDIR)%.lex.yy.c: \
  %.l \
  | $$(call mkfwk_dirname,$$@)
ifneq ($(MUST_MAKE),)
	@$(PRINTF) '  * $(MKFWK_PRINTF_FORMAT_MSG_MUST_REMAKE_TARGET) "%s". $(MKFWK_PRINTF_FORMAT_MSG_PREREQUISITES_NEWER_THAN_TARGET): %s\n' '$@' '$?'
else
	$(if $(MKFWK_HAVE_CHECKED-LEX),,$(MKFWK_RECIPE_CHECK_INDISPENSABLE_TARGET_COMMAND-LEX))
	$(if $(VERBOSE),@$(PRINTF) '\n<<< LEX: $(MKFWK_PRINTF_FORMAT_MSG_REGENERATING_THE_.lex.yy.c_FILE): "%s" >>>\n' '$@')
	$(LEX) $(LFLAGS) $($<_LFLAGS) \
 -o'$@' '$<'
	$(if $(VERBOSE),@$(PRINTF) '<<< $(MKFWK_PRINTF_FORMAT_MSG_DONE) >>>\n')
endif

# Defines a canned recipe which is commonly used for (re)making files associated with automatic dependency generation: $(DEPDIR)*.d and $(DEPDIR)*.d.timestamp
define mkfwk_common_recipe_for_.d_files
	$(PRINTF) 'empty:\n\n%s: %c\n' '$(DEPDIR)$*$(1).d.timestamp' '\' > '$(DEPDIR)$*$(1).d.tmp.2'
	$(SED) '1s?^X:??' < '$(DEPDIR)$*$(1).d.tmp.1' >> '$(DEPDIR)$*$(1).d.tmp.2'
	$(RM) $(RMFLAGS) '$(DEPDIR)$*$(1).d.tmp.1'
	$(MV) '$(DEPDIR)$*$(1).d.tmp.2' '$(DEPDIR)$*$(1).d'
	$(TOUCH) '$(DEPDIR)$*$(1).d.timestamp'
	$(if $(VERBOSE),@$(PRINTF) ' << $(MKFWK_PRINTF_FORMAT_MSG_DONE) >>\n')
endef

# If any compilation output option was defined...
ifneq ($(GENERATE_ASSEMBLING_OUTPUT)$(GENERATE_COMPILING_OUTPUT)$(GENERATE_PREPROCESSING_OUTPUT),)
#   Defines a canned recipe which is to be appended to a CC command for also (re)making files associated with automatic dependency generation: $(DEPDIR)*.d and $(DEPDIR)*.d.timestamp
define mkfwk_appended_recipe_for_.d_files
-MMD -MF'$(DEPDIR)$*$(1).d.tmp.1' -MT'X' || { $(RM) $(RMFLAGS) '$(DEPDIR)$*$(1).d.tmp.1' ; exit 1 ; }
	$(if $(VERBOSE),@$(PRINTF) ' << $(MKFWK_PRINTF_FORMAT_MSG_REGENERATING_THE_.d_FILES): "%s"[.d][.d.timestamp] >>\n' '$(DEPDIR)$*$(1)')
	$(call mkfwk_common_recipe_for_.d_files,$(1))
	$(TOUCH) '$(OBJDIR)$*$(1)$(2)'
endef
else
# Otherwise, if no compilation output options were enabled
#   Defines a pattern rule that (re)makes files associated with automatic dependency generation: $(DEPDIR)*.d and $(DEPDIR)*.d.timestamp
define mkfwk_rule_for_.d_files
$$(DEPDIR)%$(1).d.timestamp: \
  $$$$($(3))%$(1).c \
  $$$$(DEPDIR)%$(1).d \
  | $$$$(call mkfwk_dirname,$$$$@) \
  $$$$($(4))
ifneq ($$(MUST_MAKE),)
	@$$(PRINTF) '  * $$(MKFWK_PRINTF_FORMAT_MSG_MUST_REMAKE_TARGET) "%s". $$(MKFWK_PRINTF_FORMAT_MSG_PREREQUISITES_NEWER_THAN_TARGET): %s\n' '$$@' '$$?'
else
	$$(if $$(MKFWK_HAVE_CHECKED-CC),,$$(MKFWK_RECIPE_CHECK_INDISPENSABLE_TARGET_COMMAND-CC))
	$(if $(VERBOSE),@$$(PRINTF) '\n<<< $$(MKFWK_PRINTF_FORMAT_MSG_REGENERATING_THE_.d_FILES): "%s"[.d][.d.timestamp] >>>\n' '$$(DEPDIR)$$*$(1)')
	$$(CC) $$(CPPFLAGS) $$($(2)_CPPFLAGS) $$($$*$(5)_CPPFLAGS) $$(CFLAGS) $$($(2)_CFLAGS) $$($$*$(5)_CFLAGS) $(MKFWK_BACKSLASH)
 '$$<' $(MKFWK_BACKSLASH)
 -MM -MF'$(DEPDIR)$$*$(1).d.tmp.1' -MT'X' || { $$(RM) $$(RMFLAGS) '$(DEPDIR)$$*$(1).d.tmp.1' ; exit 1 ; }
	$$(call mkfwk_common_recipe_for_.d_files,$(1))
endif
endef
#   Parses pattern rules specific to YACC ($(DEPDIR)*.tab), LEX ($(DEPDIR)*.lex.yy) and CC ($(DEPDIR)*) [.d][.d.timestamp]
$(eval $(call mkfwk_rule_for_.d_files,.tab,YACC,OBJDIR,,.y))
$(eval $(call mkfwk_rule_for_.d_files,.lex.yy,LEX,OBJDIR,MKFWK_YDEFS,.l))
$(eval $(call mkfwk_rule_for_.d_files,,CC,,,.c))
mkfwk_rule_for_.d_files=
endif

# Parses a pattern rule that "(re)makes" the makefiles with automatically generated dependencies ($(DEPDIR)*.d files), but actually has an empty recipe which does nothing.
#   GNU Make thinks the target gets made nonetheless
$(DEPDIR)%.d: ;
#    This prevents GNU Make from (re)making any included $(DEPDIR)*.d files that are out of date or don't exist once it has finished reading makefiles

# Defines a pattern rule that (re)makes object files: $(OBJDIR)*.o
define mkfwk_rule_for_.o_file
$$(OBJDIR)%$(1).o \
$(if $(GENERATE_PREPROCESSING_OUTPUT)$(GENERATE_COMPILING_OUTPUT),,$(if $(GENERATE_ASSEMBLING_OUTPUT),$$(DEPDIR)%$(1).d.timestamp)): \
  $$(if $(1)$$(GENERATE_COMPILING_OUTPUT)$$(GENERATE_PREPROCESSING_OUTPUT),$$$$(OBJDIR))%$$(if $$(GENERATE_COMPILING_OUTPUT),$(1).s,$$(if $$(GENERATE_PREPROCESSING_OUTPUT),$(1).i,$(1).c)) \
  $$(if $$(GENERATE_PREPROCESSING_OUTPUT)$$(GENERATE_COMPILING_OUTPUT),,$$(if $$(GENERATE_ASSEMBLING_OUTPUT),$$$$(DEPDIR)%$(1).d)) \
  $$(if $$(GENERATE_PREPROCESSING_OUTPUT)$$(GENERATE_COMPILING_OUTPUT)$$(if $$(GENERATE_ASSEMBLING_OUTPUT),,X),$$$$(DEPDIR)%$(1).d.timestamp) \
  | $$$$(call mkfwk_dirname,$$$$(OBJDIR)%) \
    $$(if $$(GENERATE_PREPROCESSING_OUTPUT)$$(GENERATE_COMPILING_OUTPUT),,$$(if $$(GENERATE_ASSEMBLING_OUTPUT),$$$$(call mkfwk_dirname,$$$$(DEPDIR)%))) \
    $$$$($(2))
ifneq ($$(MUST_MAKE),)
	@$$(PRINTF) '  * $$(MKFWK_PRINTF_FORMAT_MSG_MUST_REMAKE_TARGET) "%s". $$(MKFWK_PRINTF_FORMAT_MSG_PREREQUISITES_NEWER_THAN_TARGET): %s\n' '$$@' '$$?'
else
	$$(if $$(MKFWK_HAVE_CHECKED-CC),,$$(MKFWK_RECIPE_CHECK_INDISPENSABLE_TARGET_COMMAND-CC))
	$(if $(VERBOSE),@$$(PRINTF) '\n<<< $(3)CC: $$(MKFWK_PRINTF_FORMAT_MSG_REGENERATING_THE_.o_FILE): "%s" >>>\n' '$$(OBJDIR)$$*$(1).o')
	$$(CC) $(if $(GENERATE_COMPILING_OUTPUT)$(GENERATE_PREPROCESSING_OUTPUT),,$$(CPPFLAGS) $$($(4)_CPPFLAGS) $$($$*$(5)_CPPFLAGS)) $$(CFLAGS) $$($(4)_CFLAGS) $$($$*$(5)_CFLAGS) $$(ASFLAGS) $$($(4)_ASFLAGS) $$($$*$(5)_ASFLAGS) $(MKFWK_BACKSLASH)
 -c -o'$$(OBJDIR)$$*$(1).o' '$$<' $(MKFWK_BACKSLASH)
 $(if $(GENERATE_PREPROCESSING_OUTPUT)$(GENERATE_COMPILING_OUTPUT),,$(if $(GENERATE_ASSEMBLING_OUTPUT),$$(call mkfwk_appended_recipe_for_.d_files,$(1),.o))) ;
	$(if $(VERBOSE),@$$(PRINTF) '<<< $$(MKFWK_PRINTF_FORMAT_MSG_DONE) >>>\n')
endif
endef
# Parses pattern rules specific to YACC ($(OBJDIR)*.tab.o), LEX ($(OBJDIR)*.lex.yy.o) and CC ($(OBJDIR)*.o)
$(eval $(call mkfwk_rule_for_.o_file,.tab,,YACC->,YACC,.y))
$(eval $(call mkfwk_rule_for_.o_file,.lex.yy,$(if $(GENERATE_PREPROCESSING_OUTPUT)$(GENERATE_COMPILING_OUTPUT),,$(if $(GENERATE_ASSEMBLING_OUTPUT),MKFWK_YDEFS)),LEX->,LEX,.l))
$(eval $(call mkfwk_rule_for_.o_file,,,,CC,.c))
mkfwk_rule_for_.o_file=

# Defines a pattern rule that (re)makes assembly files: $(OBJDIR)*.s
define mkfwk_rule_for_.s_file
$$(OBJDIR)%$(1).s \
$(if $(GENERATE_PREPROCESSING_OUTPUT),,$(if $(GENERATE_COMPILING_OUTPUT),$$(DEPDIR)%$(1).d.timestamp)): \
  $$(if $(1)$$(GENERATE_PREPROCESSING_OUTPUT),$$$$(OBJDIR))%$$(if $$(GENERATE_PREPROCESSING_OUTPUT),$(1).i,$(1).c) \
  $$(if $$(GENERATE_PREPROCESSING_OUTPUT),,$$(if $$(GENERATE_COMPILING_OUTPUT),$$$$(DEPDIR)%$(1).d)) \
  $$(if $$(GENERATE_PREPROCESSING_OUTPUT)$$(if $$(GENERATE_COMPILING_OUTPUT),,X),$$$$(DEPDIR)%$(1).d.timestamp) \
  | $$$$(call mkfwk_dirname,$$$$(OBJDIR)%) \
    $$(if $$(GENERATE_PREPROCESSING_OUTPUT),,$$(if $$(GENERATE_COMPILING_OUTPUT),$$$$(call mkfwk_dirname,$$$$(DEPDIR)%))) \
    $$$$($(2))
ifneq ($$(MUST_MAKE),)
	@$$(PRINTF) '  * $$(MKFWK_PRINTF_FORMAT_MSG_MUST_REMAKE_TARGET) "%s". $$(MKFWK_PRINTF_FORMAT_MSG_PREREQUISITES_NEWER_THAN_TARGET): %s\n' '$$@' '$$?'
else
	$$(if $$(MKFWK_HAVE_CHECKED-CC),,$$(MKFWK_RECIPE_CHECK_INDISPENSABLE_TARGET_COMMAND-CC))
	$(if $(VERBOSE),@$$(PRINTF) '\n<<< $(3)CC: $$(MKFWK_PRINTF_FORMAT_MSG_REGENERATING_THE_.s_FILE): "%s" >>>\n' '$$(OBJDIR)$$*$(1).s')
	$$(CC) $(if $(GENERATE_PREPROCESSING_OUTPUT),,$$(CPPFLAGS) $$($(4)_CPPFLAGS) $$($$*$(5)_CPPFLAGS)) $$(CFLAGS) $$($(4)_CFLAGS) $$($$*$(5)_CFLAGS) $(MKFWK_BACKSLASH)
 -S -o'$$(OBJDIR)$$*$(1).s' '$$<' $(MKFWK_BACKSLASH)
 $(if $(GENERATE_PREPROCESSING_OUTPUT),,$(if $(GENERATE_COMPILING_OUTPUT),$$(call mkfwk_appended_recipe_for_.d_files,$(1),.s))) ;
	$(if $(VERBOSE),@$$(PRINTF) '<<< $$(MKFWK_PRINTF_FORMAT_MSG_DONE) >>>\n')
endif
endef
# Parses pattern rules specific to YACC ($(OBJDIR)*.tab.s), LEX ($(OBJDIR)*.lex.yy.s) and CC ($(OBJDIR)*.s)
$(eval $(call mkfwk_rule_for_.s_file,.tab,,YACC->,YACC,.y))
$(eval $(call mkfwk_rule_for_.s_file,.lex.yy,$(if $(GENERATE_PREPROCESSING_OUTPUT),,$(if $(GENERATE_COMPILING_OUTPUT),MKFWK_YDEFS)),LEX->,LEX,.l))
$(eval $(call mkfwk_rule_for_.s_file,,,,CC,.c))
mkfwk_rule_for_.s_file=

# Defines a pattern rule that (re)makes preprocessed files: $(OBJDIR)*.i
define mkfwk_rule_for_.i_file
$$(OBJDIR)%$(1).i \
$(if $(GENERATE_PREPROCESSING_OUTPUT),$$(DEPDIR)%$(1).d.timestamp): \
  $$(if $(1),$$$$(OBJDIR))%$(1).c \
  $$(if $$(GENERATE_PREPROCESSING_OUTPUT),$$$$(DEPDIR)%$(1).d) \
  $$(if $$(GENERATE_PREPROCESSING_OUTPUT),,$$$$(DEPDIR)%$(1).d.timestamp) \
  | $$$$(call mkfwk_dirname,$$$$(OBJDIR)%) \
    $$(if $$(GENERATE_PREPROCESSING_OUTPUT),$$$$(call mkfwk_dirname,$$$$(DEPDIR)%)) \
    $$$$($(2))
ifneq ($$(MUST_MAKE),)
	@$$(PRINTF) '  * $$(MKFWK_PRINTF_FORMAT_MSG_MUST_REMAKE_TARGET) "%s". $$(MKFWK_PRINTF_FORMAT_MSG_PREREQUISITES_NEWER_THAN_TARGET): %s\n' '$$@' '$$?'
else
	$$(if $$(MKFWK_HAVE_CHECKED-CC),,$$(MKFWK_RECIPE_CHECK_INDISPENSABLE_TARGET_COMMAND-CC))
	$(if $(VERBOSE),@$$(PRINTF) '\n<<< $(3)CC: $$(MKFWK_PRINTF_FORMAT_MSG_REGENERATING_THE_.i_FILE): "%s" >>>\n' '$$(OBJDIR)$$*$(1).i')
	$$(CC) $$(CPPFLAGS) $$($(4)_CPPFLAGS) $$($$*$(5)_CPPFLAGS) $$(CFLAGS) $$($(4)_CFLAGS) $$($$*$(5)_CFLAGS) $(MKFWK_BACKSLASH)
 -E -o'$$(OBJDIR)$$*$(1).i' '$$<' $(MKFWK_BACKSLASH)
 $(if $(GENERATE_PREPROCESSING_OUTPUT),$$(call mkfwk_appended_recipe_for_.d_files,$(1),.i)) ;
	$(if $(VERBOSE),@$$(PRINTF) '<<< $$(MKFWK_PRINTF_FORMAT_MSG_DONE) >>>\n')
endif
endef
# Parses pattern rules specific to YACC ($(OBJDIR)*.tab.i), LEX ($(OBJDIR)*.lex.yy.i) and CC ($(OBJDIR)*.i)
$(eval $(call mkfwk_rule_for_.i_file,.tab,,YACC->,YACC,.y))
$(eval $(call mkfwk_rule_for_.i_file,.lex.yy,$(if $(GENERATE_PREPROCESSING_OUTPUT),MKFWK_YDEFS),LEX->,LEX,.l))
$(eval $(call mkfwk_rule_for_.i_file,,,,CC,.c))
mkfwk_rule_for_.i_file=

# Parses a pattern rule that "(re)makes" the *.h header files, but actually has an empty recipe which does nothing
%.h: ;
#    This is to avoid errors when including the makefiles with automatically generated dependencies ($(DEPDIR)*.d files):
#      if a *.h header file no longer exists, this ensures that GNU Make won't complain that it doesn't know how to build the targets depending on it,
#      and just consider it to be out of date and 'make' it

# Defines a canned command sequence which ensures that there are no existing files which would conflict with the directory names,
#   as they would share the same pathname, making them indistinguishable to GNU Make
define mkfwk_shell_check_for_pathname_conflicts
	for PATHNAME in '$(subst $(MKFWK_SPACE),'$(MKFWK_SPACE)',$(1))' ; do \
		if [ -f "$$PATHNAME" ]; then \
			$(PRINTF) '\n<<< $(MKFWK_PRINTF_FORMAT_MSG_RENAMING_TO_SOLVE_CONFLICT): "%s" >>>\n' "$$PATHNAME" >&2 ; \
			set -x ; \
				BASEPATH=$$($(PRINTF) '%s' "$$PATHNAME" | $(SED) 's?_[0-9]\+$$??') ; \
				NUMBER=1 ; \
				while [ -e "$$BASEPATH"'_'"$$NUMBER" ] ; do \
					NUMBER=$$((NUMBER + 1)) ; \
				done ; \
				$(MV) "$$PATHNAME" "$$BASEPATH"'_'"$$NUMBER" ; \
			{ set +x ; } 2>/dev/null ; \
			$(PRINTF) '<<< $(MKFWK_PRINTF_FORMAT_MSG_DONE) >>>\n' >&2 ; \
		fi ; \
	done ;
endef

# Defines an explicit rule with independent targets that makes each target directory individually
define mkfwk_rule_for_directories
$(shell $(call mkfwk_shell_check_for_pathname_conflicts,$(1)))

$(1): \
  | $$$$(call mkfwk_dirname,$$$$@)
ifeq ($$(MKFWK_HAVE_ACTIVATED_OPTION_-t_--touch),)
ifneq ($$(MUST_MAKE),)
	@$$(PRINTF) '  * $$(MKFWK_PRINTF_FORMAT_MSG_MUST_MAKE_TARGET) "%s".\n' '$$@'
else
	$(if $(VERBOSE),@$$(PRINTF) '\n<<< $$(MKFWK_PRINTF_FORMAT_MSG_MAKING_DIRECTORY): "%s" >>>\n' '$$@')
	$$(MKDIR) '$$@'
	$(if $(VERBOSE),@$$(PRINTF) '<<< $$(MKFWK_PRINTF_FORMAT_MSG_DONE) >>>\n')
endif
else
	+$$(MKDIR) '$$@'
endif
endef

# Defines a canned sequence of commands that parses the explicit rule with independent targets that makes each target directory individually,
#   if any were passed as an argument
define mkfwk_rule_for_directories_if_any
$(if $(1),$(eval $(call mkfwk_rule_for_directories,$(1))))
endef

# Gets the target directories to be parsed as an explicit rule with independent targets that makes each target directory individually, if any were defined
$(call mkfwk_rule_for_directories_if_any,$(TARGET_DIRS))
mkfwk_shell_check_for_pathname_conflicts=
MKFWK_PRINTF_FORMAT_MSG_RENAMING_TO_SOLVE_CONFLICT=
mkfwk_rule_for_directories=
mkfwk_rule_for_directories_if_any=