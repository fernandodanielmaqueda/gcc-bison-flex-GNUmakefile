# Filename: sysconfig.mk / v2024.03.25-001, part of gcc-bison-flex-GNUmakefile
# Makefile containing configurations according to the current running system
# Copyright (C) 2022-2024 Fernando Daniel Maqueda <https://github.com/fernandodanielmaqueda/>
# You should have received a copy of the GNU General Public License along with this. If not, see <https://www.gnu.org/licenses/>.

# Prevents GNU Make from even considering to remake this very same makefile, as that isn't necessary, thus optimizing startup time
.PHONY: $(MKFWK_HEADER_DIR)sysconfig.mk

# By default, no extension at all is used as the executable extension
EXEEXT=

# Detects whether the operating system is Windows or not
#   based on that if it is, Windows defines an environment variable (Windows Environment Variable) named 'OS,' typically set to the value 'Windows_NT' nowadays.
ifeq ($(OS),Windows_NT)
#   In Windows, *.exe is used as the executable extension
EXEEXT=.exe
endif