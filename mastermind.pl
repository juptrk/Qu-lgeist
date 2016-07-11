
:- encoding(iso_latin_1).
code(264).

check_code(Input,Schritt) :- (code(Input), writeln("Du hast den Code geknackt."),
					writeln("Na sch�n, hier ein Tipp zum Fall: Der M�rder ist KEIN Angestellter in unserem Haus."));
					(Schritt = 2, writeln("Leider falsch. Ohne Tipp schaffst du es ja nie:"), 
						writeln("Alle 3 Zahlen sind Vielfache von 2."), mastermind1(Schritt));
					(Schritt = 5, writeln("Leider falsch. Hier noch ein Tipp:"), writeln("Die mittlere Zahl ist au�erdem noch durch 3 teilbar."), 
						mastermind1(Schritt));
					(Schritt = 8, writeln("Leider falsch. Mein letzter Tipp f�r dich:"), 
						writeln("Wenn du die erste und die letzte Zahl addierst, dann erh�ltst du die mittlere Zahl."), 
						mastermind1(Schritt)); %dann sind nur noch diese zwei Kombis m�glich: 264 und 462
					(writeln("Leider falsch."), mastermind1(Schritt)). %alle andere Zust�nde

mastermind :- writeln("Ich habe mir einen Code ausgedacht, er besteht aus 3 Zahlen (0-9)."),
			writeln("Jede Zahl darf nur einmal vorkommen."),
			writeln("Du err�tst meinen 3-stelligen Code nie. Was ist deine Idee?"),
			read_sentence([Input|_Tail]), check_code(Input,0).

mastermind1(Schritt) :- SchrittNeu is Schritt + 1, writeln("Los rate nochmal, 3-stellig ist der Code."),
read_sentence([Input|_Tail]), check_code(Input,SchrittNeu).