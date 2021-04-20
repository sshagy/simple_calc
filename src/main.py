# This is a sample Python script.

# Press ⌃R to execute it or replace it with your code.
# Press Double ⇧ to search everywhere for classes, files, tool windows, actions, and settings.
from antlr4 import *
from grammars.calculatorLexer import calculatorLexer
from grammars.calculatorParser import calculatorParser


def main(name):
    # Use a breakpoint in the code line below to debug your script.
    print(f'Hi, {name}')  # Press ⌘F8 to toggle the breakpoint.
    # input_stream = FileStream('1+1>1')
    input_stream = InputStream('1+1>1')
    lexer = calculatorLexer(input_stream)
    stream = CommonTokenStream(lexer)
    parser = calculatorParser(stream)
    tree = parser.startRule()
    print(tree)

# Press the green button in the gutter to run the script.
if __name__ == '__main__':
    main('PyCharm')

# See PyCharm help at https://www.jetbrains.com/help/pycharm/
