# Filename: main.mk / v2024.03.25-001, part of gcc-bison-flex-GNUmakefile
# GNU Make framework for building, executing and debugging C language projects, including those involving C source code generation from Lex-like and/or Yacc-like tools
# For more information and getting the most recent clean template, visit <https://github.com/fernandodanielmaqueda/gcc-bison-flex-GNUmakefile>

# Copyright (C) 2022-2024 Fernando Daniel Maqueda <https://github.com/fernandodanielmaqueda/>
# This makefile is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
# This makefile is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
# You should have received a copy of the GNU General Public License along with this. If not, see <https://www.gnu.org/licenses/>.

# Pushes a word (in this case the character '1') to this "stack" variable, thus incrementing the "current depth"
#   Current depth
#         =
#   Times this main.mk makefile was included
#         -
#   Times the unexpanded canned directives of the (yet-to-be-defined) MKFWK_FOOTER variable were parsed
MKFWK_DEPTH_STACK+=1
#   It is necessary to keep a track of the "current depth" to ensure that the *.mk footer makefiles of the
#     GNU Make framework only get included once - in the top-level makefile, and not in the "deeper" makefiles

# This variable is set to the subdirectory where the last makefile including this other makefile so far is located, relative to the top-level makefile
#   If empty, indicates that it is in the same directory as the top-level makefile
MKFWK_LAST_INCLUDING_DIR:=$(filter-out ./,$(dir $(lastword $(wordlist 2,$(words $(MAKEFILE_LIST)),X $(MAKEFILE_LIST)))))

#### Beginning of the include guard to prevent the rest of the file from being parsed more than once
ifeq ($(MKFWK_HEADER_PARSED),)
MKFWK_HEADER_PARSED=X

# Defines a variable which always evaluates to the subdirectory where the last included makefile so far is located, relative to the top-level makefile
#   If empty, indicates that it is in the same directory as the top-level makefile
MKFWK_LAST_INCLUDED_DIR=$(filter-out ./,$(dir $(lastword $(MAKEFILE_LIST))))

# Note: when using the MKFWK_LAST_INCLUDING_DIR and MKFWK_LAST_INCLUDED_DIR variables, parsing them should be immediate and not deferred,
#   since their expansion might differ depending where they are evaluated

# Prevents GNU Make from even considering to remake this very same makefile, as that isn't necessary, thus optimizing startup time
.PHONY: $(MKFWK_LAST_INCLUDED_DIR)main.mk

### Beginning of the global definitions section (you should put all of those here)

# Subdirectory where the *.mk header makefiles of the GNU Make framework to be included are located.
#   If left empty indicates that they are in the directory of the top-level makefile. By default: $(MKFWK_LAST_INCLUDED_DIR)header/
MKFWK_HEADER_DIR:=$(MKFWK_LAST_INCLUDED_DIR)header/
# Subdirectory where the *.mk footer makefiles of the GNU Make framework to be included are located.
#   If left empty indicates that they are in the directory of the top-level makefile. By default: $(MKFWK_LAST_INCLUDED_DIR)footer/
MKFWK_FOOTER_DIR:=$(MKFWK_LAST_INCLUDED_DIR)footer/
# Subdirectory where the locale directory of the GNU Make framework is located.
#   If left empty indicates that it is in the directory of the top-level makefile. By default: $(MKFWK_LAST_INCLUDED_DIR)lang/
MKFWK_LANG_DIR:=$(MKFWK_LAST_INCLUDED_DIR)lang/
# Subdirectory where the *.mk language-specific code makefiles of the GNU Make framework to be included are located.
#   By default: en_US/
MKFWK_CODE_DIR:=en_US/

# Subdirectory where resulting programs and libraries shall be placed.
#   If left empty uses the directory of the top-level makefile. By default: bin/
BINDIR:=bin/
# Subdirectory where intermediate CC, YACC and LEX files shall be placed.
#   If left empty uses the directory of the top-level makefile. By default: obj/
OBJDIR:=obj/
# Subdirectory where files associated with automatic dependency generation (*.d and *.d.timestamp files) shall be placed.
#   If left empty uses the directory of the top-level makefile. By default: .deps/
DEPDIR:=.deps/

# Here you can explicitly set the default goal, rather it to be the first target in the makefile
#   (not counting targets whose names start with '.' unless they also contain one or more '/')
.DEFAULT_GOAL:=all

## Beginning of the sub-section of options of the GNU Make framework
##   You can either change their default values here or override them from the command-line

# Option to enable/disable printing the targets that must be (re)made along with their newer dependendencies (all of them if the target doesn't exist), instead of actually (re)making them
MUST_MAKE=

# Option to enable/disable including the makefiles with automatically generated dependencies ($(DEPDIR)*.d files)
INCLUDE_DEPS=X

# Option to enable/disable globally passing the set warning options to CC, YACC and LEX, respectively
CC_WARNINGS=X
YACC_WARNINGS=X
LEX_WARNINGS=X

# Option to enable/disable globally passing the set debug options to CC, YACC and LEX, respectively
CC_DEBUG=X
YACC_DEBUG=
LEX_DEBUG=

# Option to enable/disable the automatic (re)generation of intermediate files with the preprocessed source code output after the preprocessing phase (*.i preprocessed files)
GENERATE_PREPROCESSING_OUTPUT=
# Option to enable/disable the automatic (re)generation of intermediate files with the assembly code output after the compilation phase (*.s assembly files)
GENERATE_COMPILING_OUTPUT=
# Option to enable/disable the automatic (re)generation of intermediate object files after the assembly phase (*.o object files)
GENERATE_ASSEMBLING_OUTPUT=X

# Option to enable/disable the regeneration of intermediate target files if they got removed
REGENERATE_INTERMEDIATES=X

# Option to enable/disable printing verbose messages
VERBOSE=X

# Option to enable/disable startup checks
STARTUP_CHECKS=X

# Option to enable/disable runtime checks
RUNTIME_CHECKS=X

# The program targeted to run, and/or debug, and the arguments to pass to it, respectively.
#   For the former, by default it is set to the first program set to be made and placed into BINDIR
TARGET_PROGRAM=$(BINDIR)$(firstword $(BIN_PROGRAMS))$(EXEEXT)
TARGET_PROGRAM_ARGS=

## Ending of the sub-section of options of the GNU Make framework

# Pathname to the C compiler, to the parser generator and to the scanner generator to be used, respectively.
#   By default: gcc , bison and flex , correspondingly.
CC=gcc
YACC=bison
LEX=flex

# Pathname to the archive-maintainer program to be used and the options to pass to it, respectively.
#   For the former, by default: ar
AR=ar
ARFLAGS=-r -v

# Pathname to the archive index generator to be used, if any.
#   By default: ranlib
RANLIB=ranlib

# Pathname to the debugger to be used and the options to pass to it, respectively.
#   For the former, by default: gdb
GDB=gdb
GDBFLAGS=

# Pathname to Valgrind and the options to pass to it, respectively.
#   For the former, by default: valgrind
VALGRIND=valgrind
VALGRIND_FLAGS=--verbose
# The Valgrind tools to define targets for
VALGRIND_TOOLS=none memcheck helgrind
#   Other Valgrind tools are: cachegrind , callgrind , drd , massif , dhat , lackey , exp-bbv , etc.
# The options to pass to each respective tool, correspondingly
VALGRIND_NONE_FLAGS=
VALGRIND_MEMCHECK_FLAGS=--leak-check=full --track-origins=yes
VALGRIND_HELGRIND_FLAGS=

# Option to output version information and exit (commmonly --version , -v or -V) in the corresponding programs
CC_VERSION_FLAG=--version
YACC_VERSION_FLAG=--version
LEX_VERSION_FLAG=--version
AR_VERSION_FLAG=-V
RANLIB_VERSION_FLAG=--version
GDB_VERSION_FLAG=--version
VALGRIND_VERSION_FLAG=--version

# Add here the options to be globally passed to CC for the preprocessing phase
CPPFLAGS=

# Add here the options to be globally passed to CC for the preprocessing phase exclusively when compiling the
#   C source files (*.c files), the YACC-generated C source files (*.tab.c files) and the LEX-generated C source files (*.lex.yy.c files), respectively
CC_CPPFLAGS=
YACC_CPPFLAGS=
LEX_CPPFLAGS=

# Add here the options to be globally passed to CC, YACC, and LEX, respectively.
CFLAGS=-std=c99 -O0
YFLAGS=--report=state --report=itemset --report=lookahead
LFLAGS=

# Add here the options to be globally passed to CC exclusively when compiling the
#   C source files (*.c files), the YACC-generated C source files (*.tab.c files) and the LEX-generated C source files (*.lex.yy.c files), respectively
CC_CFLAGS=
YACC_CFLAGS=
LEX_CFLAGS=

# Add here the options to be globally passed to CC for the assembling phase
ASFLAGS=

# Add here the options to be globally passed to CC for the assembly phase exclusively when compiling the
#   C source files (*.c files), the YACC-generated C source files (*.tab.c files) and the LEX-generated C source files (*.lex.yy.c files), respectively
CC_ASFLAGS=
YACC_ASFLAGS=
LEX_ASFLAGS=

# Add here the options to be globally passed to CC for the linking phase
#   You should add the -llibrary options in the LDLIBS variable, and the rest of them in the LDFLAGS variable
#   Note: if YACC (*.y files) or LEX (*.l files) source code files are present in the project, the -ly and/or -lfl options already get added accordingly,
#     so that the libraries liby.a and libfl.a (or liby.so and libfl.so, typically) are searched and processed.
#     If the linker couldn't find a library, you should add an -L'dir' option indicating the directory containing it in the LDFLAGS variable.
LDFLAGS=
LDLIBS=-lm

# Defines the options to be passed to CC when CC_WARNINGS is enabled/disabled
ifneq ($(CC_WARNINGS),)
#   Add here the options to be passed to CC when CC_WARNINGS is enabled
CFLAGS+=-Wall -Wpedantic
else
#   Add here the options to be passed to CC when CC_WARNINGS is disabled
CFLAGS+=
endif

# Defines the options to be passed to YACC when YACC_WARNINGS is enabled/disabled
ifneq ($(YACC_WARNINGS),)
#   Add here the options to be passed to YACC when YACC_WARNINGS is enabled
YFLAGS+=-Wall
else
#   Add here the options to be passed to YACC when YACC_WARNINGS is disabled
YFLAGS+=
endif

# Defines the options to be passed to LEX when LEX_WARNINGS is enabled/disabled
ifneq ($(LEX_WARNINGS),)
#   Add here the options to be passed to LEX when LEX_WARNINGS is enabled
LFLAGS+=
else
#   Add here the options to be passed to LEX when LEX_WARNINGS is disabled
LFLAGS+=
endif

# Defines the options to be passed to CC when CC_DEBUG is enabled/disabled
ifneq ($(CC_DEBUG),)
#   Add here the options to be passed to CC when CC_DEBUG is enabled
CFLAGS+=-g3
else
#   Add here the options to be passed to CC when CC_DEBUG is disabled
CFLAGS+=
endif

# Defines the options to be passed to YACC when YACC_DEBUG is enabled/disabled
ifneq ($(YACC_DEBUG),)
#   Add here the options to be passed to YACC when YACC_DEBUG is enabled
YFLAGS+=-t
#   When YACC_DEBUG is enabled, adds this -D option to be passed to CC for the preprocessing phase exclusively when compiling the YACC-generated C source files (*.tab.c files)
#     so that the YYDEBUG macro is defined in a non-zero integer value thus YACC debugging facilities are compiled
YACC_CPPFLAGS+=-DYYDEBUG=1
else
#   Add here the options to be passed to YACC when YACC_DEBUG is disabled
YFLAGS+=
#   When YACC_DEBUG is enabled, adds this -D option to be passed to CC for the preprocessing phase exclusively when compiling the YACC-generated C source files (*.tab.c files)
#     so that the YYDEBUG macro is defined in a zero integer value thus YACC debugging facilities are not compiled
YACC_CPPFLAGS+=-DYYDEBUG=0
endif

# Defines the options to be passed to LEX when LEX_DEBUG is enabled/disabled
ifneq ($(LEX_DEBUG),)
#   Add here the options to be passed to LEX when LEX_DEBUG is enabled
LFLAGS+=-d
else
#   Add here the options to be passed to LEX when LEX_DEBUG is disabled
LFLAGS+=
endif

### Ending of the global definitions section

# Includes the language-specific makefiles. If any couldn't be found, it shall fail
include $(MKFWK_LANG_DIR)$(MKFWK_CODE_DIR)unskippable.mk $(if $(MUST_MAKE),$(MKFWK_LANG_DIR)$(MKFWK_CODE_DIR)must_make.mk,$(if $(VERBOSE),$(MKFWK_LANG_DIR)$(MKFWK_CODE_DIR)verbose.mk)) $(if $(RUNTIME_CHECKS),$(MKFWK_LANG_DIR)$(MKFWK_CODE_DIR)runtime_checks.mk) $(if $(STARTUP_CHECKS),$(MKFWK_LANG_DIR)$(MKFWK_CODE_DIR)startup_checks.mk)
MKFWK_LANG_DIR=
MKFWK_CODE_DIR=

# Includes the space-separated list of *.mk header makefiles in the established order. If any couldn't be found, it shall fail
include $(MKFWK_HEADER_DIR)chars.mk $(MKFWK_HEADER_DIR)core.mk $(MKFWK_HEADER_DIR)sysconfig.mk
MKFWK_HEADER_DIR=

# Defines canned directives to be parsed at the footer of the user's project makefiles
define MKFWK_FOOTER

# "Pops" a word from the "stack" variable, thus decrementing the current "depth"
MKFWK_DEPTH_STACK:=$(wordlist 2,$(words $(MKFWK_DEPTH_STACK)),X $(MKFWK_DEPTH_STACK))
#   Note: in this case is not necessary to check if the "stack" is empty before attempting to "pop" from it.
#     This is because the main.mk makefile needs to be included in order for this MKFWK_FOOTER variable
#     to be defined in the first place (which guarantees that the "stack" won't be empty the first time we "pop"),
#     and we also clear the MKFWK_FOOTER variable once the "stack" gets empty

# Only once the "stack" variable has gotten empty (meaning we should currently be in the top-level makefile)...
ifeq ($(MKFWK_DEPTH_STACK),)
#   Includes the space-separated list of *.mk footer makefiles of the GNU Make framework in the established order. If any couldn't be found, it shall fail
include $(MKFWK_FOOTER_DIR)base.mk $(MKFWK_FOOTER_DIR)central.mk $(MKFWK_FOOTER_DIR)cleaning.mk $(MKFWK_FOOTER_DIR)executing.mk $(MKFWK_FOOTER_DIR)making.mk $(MKFWK_FOOTER_DIR)void.mk
#   Clears the MKFWK_FOOTER variable
MKFWK_FOOTER=
MKFWK_FOOTER_DIR=
MKFWK_LAST_INCLUDED_DIR=
endif

endef

endif
#### Ending of the include guard