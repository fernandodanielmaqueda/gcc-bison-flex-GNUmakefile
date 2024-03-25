# Filename: void.mk / v2024.03.25-001, part of gcc-bison-flex-GNUmakefile
# Makefile which overrides some make's built-ins to enhance performance
# Copyright (C) 2022-2024 Fernando Daniel Maqueda <https://github.com/fernandodanielmaqueda/>
# You should have received a copy of the GNU General Public License along with this. If not, see <https://www.gnu.org/licenses/>.

# Prevents GNU Make from even considering to remake this very same makefile, as that isn't necessary, thus optimizing startup time
.PHONY: $(MKFWK_FOOTER_DIR)void.mk

# Sets the suffix list explicitly using only the suffixes needed in this particular makefile
.SUFFIXES:
#   This is because different make programs have incompatible suffix lists and implicit rules, and this sometimes creates confusion or misbehavior

## Cancels these built-in/predefined implicit rules, as they won't be used, thus optimizing execution time

%.w:

%.c: %.w

(%): %

%.out: %

%.c: %.w %.ch

%.tex: %.w %.ch

%:: %,v
#%: %,v

%:: RCS/%,v
#%: RCS/%,v

%:: RCS/%
#%: RCS/%

%:: s.%
#%: s.%

%:: SCCS/s.%
#%: SCCS/s.%

## Clears unused variables to free memory

mkfwk_make_check_set_directory_existence=
mkfwk_make_msg_error_set_directory_not_found=
HAVE_ACTIVATED_OPTION_-t_--touch:=

MUST_MAKE=
INCLUDE_DEPS=
GENERATE_PREPROCESSING_OUTPUT=
GENERATE_COMPILING_OUTPUT=
GENERATE_ASSEMBLING_OUTPUT=
REGENERATE_INTERMEDIATES=

SUFFIXES:=
CPP=
AS=
LD=
CXX=
OBJC=
FC=
F77=
GET=
CO=
PC=
MAKEINFO=
M2C=
LINT=
CTANGLE=
TANGLE=
TEX=
TEXI2DVI=
CWEAVE=
WEAVE=
COFLAGS=
F77FLAGS=
OUTPUT_OPTION=
PREPROCESS.F=
PREPROCESS.r=
PREPROCESS.S=
CHECKOUT,v=
COMPILE.c=
COMPILE.C=
COMPILE.cc=
COMPILE.cpp=
COMPILE.def=
COMPILE.f=
COMPILE.F=
COMPILE.m=
COMPILE.mod=
COMPILE.p=
COMPILE.r=
COMPILE.s=
COMPILE.S=
LINK.c=
LINK.C=
LINK.cc=
LINK.cpp=
LINK.f=
LINK.F=
LINK.m=
LINK.o=
LINK.p=
LINK.r=
LINK.s=
LINK.S=
LINT.c=
LEX.m=
LEX.l=
YACC.m=
YACC.y=

##