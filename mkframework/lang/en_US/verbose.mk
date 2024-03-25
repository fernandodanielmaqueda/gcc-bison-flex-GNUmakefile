# Filename: verbose.mk / v2024.03.25-001, part of gcc-bison-flex-GNUmakefile
# English (United States) language-specific makefile containing verbose printing messages
# Copyright (C) 2022-2024 Fernando Daniel Maqueda <https://github.com/fernandodanielmaqueda/>
# You should have received a copy of the GNU General Public License along with this. If not, see <https://www.gnu.org/licenses/>.

# NOTE: avoid using single quotes (') whenever possible as they need to be escaped as '\'' for the shell, but not for GNU Make's $(error ...) and $(info ...) functions

# Prevents GNU Make from even considering to remake this very same makefile, as that isn't necessary, thus optimizing startup time
.PHONY: $(MKFWK_LANG_DIR)$(MKFWK_LOCALE_DIR)verbose.mk

MKFWK_MSG_FOR_ON=Enabled
MKFWK_MSG_FOR_OFF=Disabled

MKFWK_PRINTF_FORMAT_MSG_PATHNAME=Pathname
MKFWK_PRINTF_FORMAT_MSG_INSTALLED_VERSION=Version

MKFWK_PRINTF_FORMAT_MSG_REMOVING=Removing
MKFWK_PRINTF_FORMAT_MSG_REMOVING_DIRECTORY=Removing the directory (only if it is empty, not in use, etc.)

define MKFWK_PRINTF_STRINGS_MSG_NOTE_YACC_DEBUGGING
'NOTE: the YYDEBUG macro has been defined with a non-zero integer value thus compiling YACC debugging facilities' \
'In order to debug YACC, the variable int yydebug must also have a non-zero integer value at runtime' \
'A way to achieve this is to insert the following code inside main() before invoking yyparse()'
endef

MKFWK_PRINTF_FORMAT_MSG_INIT_TARGET-cleandeps=Clean the files associated with automatic dependency generation
MKFWK_PRINTF_FORMAT_MSG_INIT_TARGET-mostlyclean=Clean the programs and compilation output files
MKFWK_PRINTF_FORMAT_MSG_INIT_TARGET-clean=Clean the library files
MKFWK_PRINTF_FORMAT_MSG_INIT_TARGET-distclean=Nothing set to be cleaned
MKFWK_PRINTF_FORMAT_MSG_INIT_TARGET-realclean=Nothing set to be cleaned
MKFWK_PRINTF_FORMAT_MSG_INIT_TARGET-clobber=Nothing set to be cleaned
MKFWK_PRINTF_FORMAT_MSG_INIT_TARGET-maintainer-clean=Clean the YACC-and-LEX-generated files
MKFWK_PRINTF_FORMAT_MSG_INIT_TARGET-cleandirs=Remove the target directories

MKFWK_PRINTF_FORMAT_MSG_THE_FILE=the file
MKFWK_PRINTF_FORMAT_MSG_THE_PROGRAM=the program
MKFWK_PRINTF_FORMAT_MSG_THE_LIBRARY_FILE=the library file
MKFWK_PRINTF_FORMAT_MSG_THE_COMPILATION_OUTPUT_FILE=the compilation output file
MKFWK_PRINTF_FORMAT_MSG_THE_.d_ASSOCIATED_FILE=the file associated with automatic dependency generation
MKFWK_PRINTF_FORMAT_MSG_THE_LEX_GENERATED_FILE=the LEX-generated file
MKFWK_PRINTF_FORMAT_MSG_THE_YACC_GENERATED_FILE=the YACC-generated file

MKFWK_PRINTF_FORMAT_MSG_EXCEPTION_PROGRAM_DOES_NOT_EXIST=EXCEPTION: The target program does not exist
MKFWK_PRINTF_FORMAT_MSG_MUST_BE_BUILT_FIRST=It must be built first
MKFWK_PRINTF_FORMAT_MSG_RELATIVE_PATH=Relative path

MKFWK_PRINTF_FORMAT_MSG_INIT_TARGET-run=Run the target program in this window
MKFWK_PRINTF_FORMAT_MSG_DO_TARGET-run=Running the target program

MKFWK_PRINTF_FORMAT_MSG_INIT_TARGET-gdb=Debug the target program in this window through a command line interface (CLI)
MKFWK_PRINTF_FORMAT_MSG_DO_TARGET-gdb=Debugging the target program

MKFWK_PRINTF_FORMAT_MSG_INIT_TARGET-valgrind=Run the corresponding Valgrind tool in this window with the target program
MKFWK_PRINTF_FORMAT_MSG_DO_TARGET-valgrind=Running with the target program

MKFWK_PRINTF_FORMAT_MSG_THE_ALREADY_EXISTING_PROGRAM=the already existing program

MKFWK_PRINTF_FORMAT_MSG_REGENERATING_THE_PROGRAM=(Re)generating the program
MKFWK_PRINTF_FORMAT_MSG_REGENERATING_THE_LIBRARY_FILE=(Re)generating the library file
MKFWK_PRINTF_FORMAT_MSG_REPLACING_ARCHIVE=Replacing/Adding object file(s) into the archive
MKFWK_PRINTF_FORMAT_MSG_EXECUTING_RANLIB=Updating the symbol table of the archive
MKFWK_PRINTF_FORMAT_MSG_REGENERATING_THE_.d_FILES=(Re)generating the files associated with automatic dependency generation
MKFWK_PRINTF_FORMAT_MSG_REGENERATING_THE_.tab.c_.tab.h_.output_FILES=(Re)generating the files for the parser implementation
MKFWK_PRINTF_FORMAT_MSG_REGENERATING_THE_.lex.yy.c_FILE=(Re)generating the C source file for the scanner implementation
MKFWK_PRINTF_FORMAT_MSG_REGENERATING_THE_.i_FILE=(Re)generating the preprocessed file
MKFWK_PRINTF_FORMAT_MSG_REGENERATING_THE_.s_FILE=(Re)generating the assembly file
MKFWK_PRINTF_FORMAT_MSG_REGENERATING_THE_.o_FILE=(Re)generating the object file

MKFWK_PRINTF_FORMAT_MSG_MAKING_DIRECTORY=Making the directory