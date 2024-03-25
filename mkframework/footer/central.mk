# Filename: central.mk / v2024.03.25-001, part of gcc-bison-flex-GNUmakefile
# Makefile containing the central target for appearing first
# Copyright (C) 2022-2024 Fernando Daniel Maqueda <https://github.com/fernandodanielmaqueda/>
# You should have received a copy of the GNU General Public License along with this. If not, see <https://www.gnu.org/licenses/>.

# Prevents GNU Make from even considering to remake this very same makefile, as that isn't necessary, thus optimizing startup time
.PHONY: $(MKFWK_FOOTER_DIR)central.mk

# Defines intermediate targets explicitly
MKFWK_INTERMEDIATE_TARGETS=\
  $(shell $(PRINTF) '%s\n' '$(subst $(MKFWK_SPACE),'$(MKFWK_SPACE)',$(filter %.c %.y %.l,$(foreach prefix,BIN,$(foreach primary,PROGRAMS LIBRARIES SOLIBRARIES,$(foreach variable,$($(prefix)_$(primary)),$($(variable)_SOURCES))))))' | $(SED) \
    -e '/\.c$$/ s?\(.*\)\.c$$?$(if $(GENERATE_PREPROCESSING_OUTPUT),$(OBJDIR)\1.i) $(if $(GENERATE_COMPILING_OUTPUT),$(OBJDIR)\1.s) $(if $(GENERATE_ASSEMBLING_OUTPUT),$(OBJDIR)\1.o) $(if $(INCLUDE_DEPS),,$(DEPDIR)\1.d)?' \
    -e '/\.y$$/ s?\(.*\)\.y$$?$(OBJDIR)\1.tab.c $(OBJDIR)\1.tab.h $(OBJDIR)\1.output $(if $(GENERATE_PREPROCESSING_OUTPUT),$(OBJDIR)\1.tab.i) $(if $(GENERATE_COMPILING_OUTPUT),$(OBJDIR)\1.tab.s) $(if $(GENERATE_ASSEMBLING_OUTPUT),$(OBJDIR)\1.tab.o) $(if $(INCLUDE_DEPS),,$(DEPDIR)\1.tab.d)?' \
    -e '/\.l$$/ s?\(.*\)\.l$$?$(OBJDIR)\1.lex.yy.c $(if $(GENERATE_PREPROCESSING_OUTPUT),$(OBJDIR)\1.lex.yy.i) $(if $(GENERATE_COMPILING_OUTPUT),$(OBJDIR)\1.lex.yy.s) $(if $(GENERATE_ASSEMBLING_OUTPUT),$(OBJDIR)\1.lex.yy.o) $(if $(INCLUDE_DEPS),,$(DEPDIR)\1.lex.yy.d)?' \
  ;)

# Defines the 'all' target depending on whether the REGENERATE_INTERMEDIATES option is enabled/disabled
.PHONY: all
ifneq ($(REGENERATE_INTERMEDIATES),)
#   Explicit rule to (re)build all programs, libraries and also intermediate files
all: \
  $(MKFWK_INTERMEDIATE_TARGETS) \
  $(foreach prefix,BIN,$(foreach primary,LIBRARIES SOLIBRARIES,$(foreach variable,$($(prefix)_$(primary)),$($(prefix)DIR)$(variable)))) \
  $(foreach prefix,BIN,$(foreach primary,PROGRAMS,$(foreach variable,$($(prefix)_$(primary)),$($(prefix)DIR)$(variable)$(EXEEXT)))) ;
ifneq ($(MUST_MAKE),)
	@$(PRINTF) '  * $(MKFWK_PRINTF_FORMAT_MSG_MUST_MAKE_TARGET) "%s". $(MKFWK_PRINTF_FORMAT_MSG_PREREQUISITES_NEWER_THAN_TARGET): %s\n' '$@' '$?'
endif
else
#   Explicit rule to (re)build all programs and libraries only
all: \
  $(foreach prefix,BIN,$(foreach primary,LIBRARIES SOLIBRARIES,$(foreach variable,$($(prefix)_$(primary)),$($(prefix)DIR)$(variable)))) \
  $(foreach prefix,BIN,$(foreach primary,PROGRAMS,$(foreach variable,$($(prefix)_$(primary)),$($(prefix)DIR)$(variable)$(EXEEXT)))) ;
ifneq ($(MUST_MAKE),)
	@$(PRINTF) '  * $(MKFWK_PRINTF_FORMAT_MSG_MUST_MAKE_TARGET) "%s". $(MKFWK_PRINTF_FORMAT_MSG_PREREQUISITES_NEWER_THAN_TARGET): %s\n' '$@' '$?'
endif
#   The targets which .SECONDARY depends on are treated as intermediate files, except that they are never automatically deleted
.SECONDARY: $(MKFWK_INTERMEDIATE_TARGETS) $(TARGET_DIRS)
endif