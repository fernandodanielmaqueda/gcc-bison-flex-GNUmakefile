# Filename: GNUmakefile / v2024.03.25-001, part of gcc-bison-flex-GNUmakefile

# Includes the main.mk makefile of the GNU Make framework. If couldn't be found, it shall fail
include mkframework/main.mk

# Prevents GNU Make from even considering to remake this very same makefile, as that isn't necessary, thus optimizing startup time
.PHONY: $(MKFWK_LAST_INCLUDING_DIR)GNUmakefile

## This is an example for a single program set to be made and placed into $(BINDIR)

# Basename for the program
program1:=myprogram

# Space-separated basenames of the programs to be made and placed into BINDIR
BIN_PROGRAMS+=$(program1)

#   Subdirectory to search for source files for the program. Alternatively, it can be left empty to use the current directory. By default: src/
$(program1)_SRCDIR:=src/
#   Checks that the set directory above exists
$(call mkfwk_make_check_set_directory_existence,$(program1)_SRCDIR)
#   Finds source files under the set directory above
$(program1)_FIND_SOURCES:=$(shell $(FIND) $(if $($(program1)_SRCDIR),'$($(program1)_SRCDIR)',.) -type f \( \( -name '*.c' ! -name '*.tab.c' ! -name '*.lex.yy.c' \) -o \( -name '*.y' -o -name '*.l' \) \) -print | $(SED) -e 's?^\./??' -e 's?^?$(MKFWK_LAST_INCLUDING_DIR)?' ;)
#     Note: By default, the *find* command does recursive searchs. If you want a max depth of 1, you may add: ! -path '.' -prune
#   Sets the found source files as the program's source files
$(program1)_SOURCES:=$($(program1)_FIND_SOURCES)
#   Sets the program's linking order. You may add the -l and -L linking flags here
$(program1)_LDADD:=$($(program1)_SOURCES)

$(info sources:$($(program1)_SOURCES))

# Add here the options to be passed to CC for the preprocessing phase for $(program1)
$(program1)_CPPFLAGS=
# Add here the options to be passed to CC for $(program1)
$(program1)_CFLAGS=
# Add here the options to be passed to CC for the assembling phase for $(program1)
$(program1)_ASFLAGS=
# Add here the options to be passed to CC for the linking phase for $(program1)
$(program1)_LDFLAGS=

# Subdirectory to search for *.h header files.
#   Alternatively, it can be left empty to use the current directory. By default: $($(program1)_SRCDIR)
$(program1)_INCLUDEDIR:=$($(program1)_SRCDIR)
# Checks that the set directory above exists
$(call mkfwk_make_check_set_directory_existence,$(program1)_INCLUDEDIR)
# Finds *.h header files and produces -I'dir' options correspondingly
$(program1)_FIND_-I_FLAGS:=\
$(sort $(shell $(FIND) $(if $($(program1)_SRCDIR),'$($(program1)_INCLUDEDIR)',.) -type f -name '*.h' -print | $(SED) -e 's?^\./??' -e 's?^?$(MKFWK_LAST_INCLUDING_DIR)?' -e 's?[^/]*$$??' -e 's?/$$??' -e "s?^?-I'?" -e "s?\$$?'?" -e "s?^-I''\$$?-I'.'?" ;)) \
$(shell $(PRINTF) '%s\n' '$(subst $(SPACE),'$(SPACE)',$(patsubst %.y,$(OBJDIR)%,$(filter %.y,$($(program1)_SOURCES))))' | $(SED) -e 's?[^/]*$$??' -e 's?/$$??' -e "s?^?-I'?" -e "s?\$$?'?" -e "s?^-I''\$$?-I'.'?" ;)
# Adds the produced -I'dir' options to be passed to CC for the preprocessing phase for $(program1)
$(program1)_CPPFLAGS+=$($(program1)_FIND_-I_FLAGS)

# Subdirectory to search for library files (lib*.a and lib*.so files).
#   Alternatively, it can be left empty to use the current directory. By default: $($(program1)_SRCDIR)
$(program1)_LIBDIR:=$($(program1)_SRCDIR)
# Checks that the set directory above exists
$(call mkfwk_make_check_set_directory_existence,$(program1)_LIBDIR)
# Finds library files and produces -L'dir' options correspondingly
$(program1)_FIND_-L_FLAGS:=\
$(sort $(shell $(FIND) $(if $($(program1)_SRCDIR),'$($(program1)_LIBDIR)',.) -type f \( -name 'lib*.a' -o -name 'lib*.so' \) -print | $(SED) -e 's?^\./??' -e 's?^?$(MKFWK_LAST_INCLUDING_DIR)?' -e 's?[^/]*$$??' -e 's?/$$??' -e "s?^?-L'?" -e "s?\$$?'?" -e "s?^-L''\$$?-L'.'?" ;))
# Adds the produced -L'dir' options to be passed to CC for the linking phase for $(program1)
$(program1)_LDFLAGS+=$($(program1)_FIND_-L_FLAGS)

##

# Parses the unexpanded canned directives of the MKFWK_FOOTER variable defined by the GNU Make framework
$(eval $(value MKFWK_FOOTER))