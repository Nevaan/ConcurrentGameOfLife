1.Kompilacja

Plik .erl :
erl -make

Plik .java:
javac -classpath "lib" guiNode.java



Obliczanie stanu automatu komórkowego:

erl -make
erl -sname gameOfLife -setcookie cookie
main:start().

GUI:
java -jar guiNode.jar
