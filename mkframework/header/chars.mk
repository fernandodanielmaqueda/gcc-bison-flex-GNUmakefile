# Filename: chars.mk / v2024.03.25-001, part of gcc-bison-flex-GNUmakefileN
# Makefile containing character definitions
# Copyright (C) 2022-2024 Fernando Daniel Maqueda <https://github.com/fernandodanielmaqueda/>
# You should have received a copy of the GNU General Public License along with this. If not, see <https://www.gnu.org/licenses/>.

# Prevents GNU Make from even considering to remake this very same makefile, as that isn't necessary, thus optimizing startup time
.PHONY: $(MKFWK_HEADER_DIR)chars.mk

# Defines a variable containing nothing
MKFWK_BLANK:=

# Defines a variable containing a single space to be used as the first argument of a function
MKFWK_SPACE:=$(subst ',,' ')

# Defines a variable containing a tab character
MKFWK_TAB:=$(subst ',,'	')

# Defines a variable containing a hash to be used inside GNU Make's macro references and/or function invocations
MKFWK_HASH:=\#

# Defines a variable containing a percentage sign for GNU Make not to parse them as a parameter separator
MKFWK_COMMA:=,

# Defines a variable containing a percentage sign for GNU Make not to parse them as a stem in implicit rules
MKFWK_PERCENTAGE_SIGN:=%

# Defines a variable containing a semicolon for GNU Make not to parse them incorrectly in implicit rules
MKFWK_SEMICOLON:=;

# Defines a variable containing a backslash for GNU Make not to parse them as a line splitting
MKFWK_BACKSLASH:=$(subst ',,'\')

# Defines a variable containing a newline for separating recipe lines in some situations,
#   e.g. when using $(foreach ...) in conjuntion with $(call ...) with canned recipes
define MKFWK_NEWLINE


endef