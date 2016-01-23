Pawe³ £osek

Program korzysta z biblioteki jInterface, za³¹czonej w paczce razem z projektem. Pozwala ona na wykonanie czêœci 
demonstracyjnej(graficznej) napisanej w Javie (Swing). Wszysktkie poni¿sze polecenia nale¿y wykonywaæ w folderze,
w którym znajduj¹ siê pliki Ÿród³owe.

1.Kompilacja

Plik .erl :
erl -make

Plik .java (w paczce znajduje siê skompilowany, uruchamialny jar, na wypadek problemów z jego utworzeniem):

javac -classpath jinterface-1.5.3.1.jar GuiNode.java
jar -cvfm guiNode.jar MANIFEST.MF GuiNode.class

2. W³¹czanie programu

Obliczanie stanu automatu komórkowego:

erl -sname gameOfLife -setcookie cookie
main:start().

GUI:
java -jar guiNode.jar

Ze wzglêdu na sposób dzia³ania programu (czêœæ napisana w Erlangu oczekuje "spingowania" przez GUI), komendy nale¿y
wpisywaæ w podanej wy¿ej kolejnoœci. 

Stan pocz¹tkowy automatu zapisany jest w pliku startGrid.txt, musi byæ on podany w formie piêciu wierszy z³o¿onych z 
zer i jedynek (martwe/¿ywe komórki),przy czym pomiêdzy komórkami musi byæ przynajmniej jedna spacja odstêpu. 

