__author__ = 'jszheng'

import sys
from antlr4 import *
from antlr4.InputStream import InputStream

from grammars.ExprLexer import ExprLexer
from grammars.ExprParser import ExprParser

if __name__ == '__main__':
    parser = ExprParser(None)
    parser.buildParseTrees = False

    line = sys.stdin.readline()
    lineno = 1

    while line != '':
        line = line.strip()
        #print(lineno, line)

        istream = InputStream(line + "\n")
        lexer = ExprLexer(istream)
        lexer.line = lineno
        lexer.column = 0
        token_stream = CommonTokenStream(lexer)
        parser.setInputStream(token_stream)
        parser.stat()

        line = sys.stdin.readline()
        lineno += 1
