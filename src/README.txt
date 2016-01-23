1.Kompilacja

Plik .erl :
erl -make

Plik .java:

javac -classpath jinterface-1.5.3.1.jar GuiNode.java
jar -cvfm guiNode.jar MANIFEST.MF GuiNode.class

Obliczanie stanu automatu komórkowego:

erl -make
erl -sname gameOfLife -setcookie cookie
main:start().

GUI:
java -jar guiNode.jar


