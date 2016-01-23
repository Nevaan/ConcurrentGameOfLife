Pawe� �osek

Program korzysta z biblioteki jInterface, za��czonej w paczce razem z projektem. Pozwala ona na wykonanie cz�ci 
demonstracyjnej(graficznej) napisanej w Javie (Swing). Wszysktkie poni�sze polecenia nale�y wykonywa� w folderze,
w kt�rym znajduj� si� pliki �r�d�owe.

1.Kompilacja

Plik .erl :
erl -make

Plik .java (w paczce znajduje si� skompilowany, uruchamialny jar, na wypadek problem�w z jego utworzeniem):

javac -classpath jinterface-1.5.3.1.jar GuiNode.java
jar -cvfm guiNode.jar MANIFEST.MF GuiNode.class

2. W��czanie programu

Obliczanie stanu automatu kom�rkowego:

erl -sname gameOfLife -setcookie cookie
main:start().

GUI:
java -jar guiNode.jar

Ze wzgl�du na spos�b dzia�ania programu (cz�� napisana w Erlangu oczekuje "spingowania" przez GUI), komendy nale�y
wpisywa� w podanej wy�ej kolejno�ci. 

Stan pocz�tkowy automatu zapisany jest w pliku startGrid.txt, musi by� on podany w formie pi�ciu wierszy z�o�onych z 
zer i jedynek (martwe/�ywe kom�rki),przy czym pomi�dzy kom�rkami musi by� przynajmniej jedna spacja odst�pu. 

