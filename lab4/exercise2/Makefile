CC=gcc
FLEX=flex
BI=bison
demo:
	$(BI) -d syntax.y
	$(FLEX) lex.l
	$(CC) syntax.tab.c -lfl -ly -o calc.out
clean:
	@rm -f lex.yy.c *.out *.so
