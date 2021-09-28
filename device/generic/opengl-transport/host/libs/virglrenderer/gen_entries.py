#!/usr/bin/env python

# Copyright 2015 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Utility functions used to parse a list of DLL entry points.
# Expected format:
#
#   <empty-line>   -> ignored
#   #<comment>     -> ignored
#   %<verbatim>    -> verbatim output for header files.
#   !<prefix>      -> prefix name for header files.
#   <return-type> <function-name> <signature> ; -> entry point declaration.
#
# Anything else is an error.

import re
import sys
import argparse

re_func = re.compile(r"""^(.*[\* ])([A-Za-z_][A-Za-z0-9_]*)\((.*)\);$""")
re_param = re.compile(r"""^(.*[\* ])([A-Za-z_][A-Za-z0-9_]*)$""")

class Entry:
    """Small class used to model a single DLL entry point."""
    def __init__(self, func_name, return_type, parameters):
        """Initialize Entry instance. |func_name| is the function name,
           |return_type| its return type, and |parameters| is a list of
           (type,name) tuples from the entry's signature.
        """
        self.func_name = func_name
        self.return_type = return_type
        self.parameters = ""
        self.vartypes = []
        self.varnames = []
        self.call = ""
        comma = ""
        for param in parameters:
            self.vartypes.append(param[0])
            self.varnames.append(param[1])
            self.parameters += "%s%s %s" % (comma, param[0], param[1])
            self.call += "%s%s" % (comma, param[1])
            comma = ", "

def banner_command(argv):
    """Return sanitized command-line description.
       |argv| must be a list of command-line parameters, e.g. sys.argv.
       Return a string corresponding to the command, with platform-specific
       paths removed."""

    # Remove path from first parameter
    argv = argv[:]
    argv[0] = "host/commands/gen-entries.py"
    return ' '.join(argv)

def parse_entries_file(lines):
    """Parse an .entries file and return a tuple of:
        entries: list of Entry instances from the file.
        prefix_name: prefix name from the file, or None.
        verbatim: list of verbatim lines from the file.
        errors: list of errors in the file, prefixed by line number.
    """
    entries = []
    verbatim = []
    errors = []
    lineno = 0
    prefix_name = None
    for line in lines:
        lineno += 1
        line = line.strip()
        if len(line) == 0:  # Ignore empty lines
            continue
        if line[0] == '#':  # Ignore comments
            continue
        if line[0] == '!':  # Prefix name
            prefix_name = line[1:]
            continue
        if line[0] == '%':  # Verbatim line copy
            verbatim.append(line[1:])
            continue
        # Must be a function signature.
        m = re_func.match(line)
        if not m:
            errors.append("%d: '%s'" % (lineno, line))
            continue

        return_type, func_name, parameters = m.groups()
        return_type = return_type.strip()
        parameters = parameters.strip()
        params = []
        failure = False
        if parameters != "void":
            for parameter in parameters.split(','):
                parameter = parameter.strip()
                m = re_param.match(parameter)
                if not m:
                    errors.append("%d: parameter '%s'" % (lineno, parameter))
                    failure = True
                    break
                else:
                    param_type, param_name = m.groups()
                    params.append((param_type.strip(), param_name.strip()))

        if not failure:
            entries.append(Entry(func_name, return_type, params))

    return (entries, prefix_name, verbatim, errors)


def gen_functions_header(entries, prefix_name, verbatim, filename, with_args):
    """Generate a C header containing a macro listing all entry points.
       |entries| is a list of Entry instances.
       |prefix_name| is a prefix-name, it will be converted to upper-case.
       |verbatim| is a list of verbatim lines that must appear before the
       macro declaration. Useful to insert #include <> statements.
       |filename| is the name of the original file.
    """
    prefix_name = prefix_name.upper()

    print "// Auto-generated with: %s" % banner_command(sys.argv)
    print "// DO NOT EDIT THIS FILE"
    print ""
    print "#ifndef %s_FUNCTIONS_H" % prefix_name
    print "#define %s_FUNCTIONS_H" % prefix_name
    print ""
    for line in verbatim:
        print line

    print "#define LIST_%s_FUNCTIONS(X) \\" % prefix_name
    for entry in entries:
        if with_args:
            print "  X(%s, %s, (%s), (%s)) \\" % \
                    (entry.return_type, entry.func_name, entry.parameters,
                     entry.call)
        else:
            print "  X(%s, %s, (%s)) \\" % \
                    (entry.return_type, entry.func_name, entry.parameters)

    print ""
    print ""
    print "#endif  // %s_FUNCTIONS_H" % prefix_name

def gen_dll_wrapper(entries, prefix_name, verbatim, filename):
    """Generate a C source file that contains functions that act as wrappers
       for entry points located in another shared library. This allows the
       code that calls these functions to perform lazy-linking to system
       libraries.
       |entries|, |prefix_name|, |verbatim| and |filename| are the same as
       for gen_functions_header() above.
    """
    upper_name = prefix_name.upper()

    ENTRY_PREFIX = "__dll_"

    print "// Auto-generated with: %s" % banner_command(sys.argv)
    print "// DO NOT EDIT THIS FILE"
    print ""
    print "#include <dlfcn.h>"
    for line in verbatim:
        print line

    print ""
    print "///"
    print "///  W R A P P E R   P O I N T E R S"
    print "///"
    print ""
    for entry in entries:
        ptr_name = ENTRY_PREFIX + entry.func_name
        print "static %s (*%s)(%s) = 0;" % \
                (entry.return_type, ptr_name, entry.parameters)

    print ""
    print "///"
    print "///  W R A P P E R   F U N C T I O N S"
    print "///"
    print ""

    for entry in entries:
        print "%s %s(%s) {" % \
                (entry.return_type, entry.func_name, entry.parameters)
        ptr_name = ENTRY_PREFIX + entry.func_name
        if entry.return_type != "void":
            print "  return %s(%s);" % (ptr_name, entry.call)
        else:
            print "  %s(%s);" % (ptr_name, entry.call)
        print "}\n"

    print ""
    print "///"
    print "///  I N I T I A L I Z A T I O N   F U N C T I O N"
    print "///"
    print ""

    print "int %s_dynlink_init(void* lib) {" % prefix_name
    for entry in entries:
        ptr_name = ENTRY_PREFIX + entry.func_name
        print "  %s = (%s(*)(%s))dlsym(lib, \"%s\");" % \
                (ptr_name,
                 entry.return_type,
                 entry.parameters,
                 entry.func_name)
        print "  if (!%s) return -1;" % ptr_name
    print "  return 0;"
    print "}"


def gen_windows_def_file(entries):
    """Generate a windows DLL .def file. |entries| is a list of Entry instances.
    """
    print "EXPORTS"
    for entry in entries:
        print "    %s" % entry.func_name


def gen_unix_sym_file(entries):
    """Generate an ELF linker version file. |entries| is a list of Entry
       instances.
    """
    print "VERSION {"
    print "\tglobal:"
    for entry in entries:
        print "\t\t%s;" % entry.func_name
    print "\tlocal:"
    print "\t\t*;"
    print "};"

def gen_symbols(entries, underscore):
    """Generate a list of symbols from |entries|, a list of Entry instances.
       |underscore| is a boolean. If True, then prepend an underscore to each
       symbol name.
    """
    prefix = ""
    if underscore:
        prefix = "_"
    for entry in entries:
        print "%s%s" % (prefix, entry.func_name)

def parse_file(filename, lines, mode):
    """Generate one of possible outputs from |filename|. |lines| must be a list
       of text lines from the file, and |mode| is one of the --mode option
       values.
    """
    entries, prefix_name, verbatim, errors = parse_entries_file(lines)
    if errors:
        for error in errors:
            print >> sys.stderr, "ERROR: %s:%s" % (filename, error)
        sys.exit(1)

    if not prefix_name:
        prefix_name = "unknown"

    if mode == 'def':
        gen_windows_def_file(entries)
    elif mode == 'sym':
        gen_unix_sym_file(entries)
    elif mode == 'wrapper':
        gen_dll_wrapper(entries, prefix_name, verbatim, filename)
    elif mode == 'symbols':
        gen_symbols(entries, False)
    elif mode == '_symbols':
        gen_symbols(entries, True)
    elif mode == 'functions':
        gen_functions_header(entries, prefix_name, verbatim, filename, False)
    elif mode == 'funcargs':
        gen_functions_header(entries, prefix_name, verbatim, filename, True)


# List of valid --mode option values.
mode_list = [
    'def', 'sym', 'wrapper', 'symbols', '_symbols', 'functions', 'funcargs'
]

# Argument parsing.
parser = argparse.ArgumentParser(
    formatter_class=argparse.RawDescriptionHelpFormatter,
    description="""\
A script used to parse an .entries input file containing a list of function
declarations, and generate various output files depending on the value of
the --mode option, which can be:

  def        Generate a windows DLL .def file.
  sym        Generate a Unix .so linker script.
  wrapper    Generate a C source file containing wrapper functions.
  symbols    Generate a simple list of symbols, one per line.
  _symbols   Generate a simple list of symbols, prefixed with _.
  functions  Generate a C header containing a macro listing all functions.
  funcargs   Like 'functions', but adds function call arguments to listing.

""")
parser.add_argument("--mode", help="Output mode", choices=mode_list)
parser.add_argument("--output", help="output file")
parser.add_argument("file", help=".entries file path")

args = parser.parse_args()

if not args.mode:
    print >> sys.stderr, "ERROR: Please use --mode=<name>, see --help."
    sys.exit(1)

if args.output:
    sys.stdout = open(args.output, "w+")

if args.file == '--':
    parse_file("<stdin>", sys.stdin, args.mode)
else:
    parse_file(args.file, open(args.file), args.mode)
