:- include('framework.pl').
:- include('scheresteinpapier.pl').
:- include('mastermindRandom.pl').
:- include('morsealphabet.pl').
:- encoding(iso_latin_1).


% definiert die aktuelle situation
% m�gliche situationen sind kind, garten, arbeitszimmer, wohnzimmer, schlafzimmer, eingangsbereich, kueche, geheim
:- retractall(situation(_)).
:- dynamic situation/1.

situation(eingangsbereich).

change_situation(NewSituation) :-
	NewSituation == kind,
	situation(OldSituation),
	retract(situation(OldSituation)),
	assertz(situation(NewSituation)).

change_situation(NewSituation) :-
	not(NewSituation == kind),
	change_person('Du', NewSituation),
	situation(OldSituation),
	retract(situation(OldSituation)),
	assertz(situation(NewSituation)).


:- retractall(was_there(_)).
:- dynamic was_there/1.

was_there(eingangsbereich).

add_location(NewLocation) :-
	ort(NewLocation),
	(
		was_there(NewLocation)
		);
	(
		assertz(was_there(NewLocation))
		).
	


% definiert die personen, mit denen man interagieren kann und sich selbst
:- retractall(person(_)).
:- dynamic person/2.

person('Du', eingangsbereich).
person('Alex', wohnzimmer).
person('Beamter', eingangsbereich).

change_person(Person,NewLocation) :-
	person(Person,OldLocation),
	retract(person(Person,OldLocation)),
	assertz(person(Person,NewLocation)).


%dynamisches Pr�dikat: 
:- retractall(verdaechtigungszahl(_)).
:- dynamic verdaechtigungszahl/1.
verdaechtigungszahl(0).

set_verdaechtigung :-
	retract(verdaechtigungszahl(AlteAnzahl)),
	NeueAnzahl is AlteAnzahl+1, 
	assert(verdaechtigungszahl(NeueAnzahl)),
	(
		(
			NeueAnzahl < 3,
			writeln("Du solltest besser ueber deine Antworten nachdenken, unendlich viele Versuche hast du nicht mehr!")
			);
		(
			NeueAnzahl>=3,
			writeln("Du hast zu viele falsche Verd�chtigungen gemacht, du darfst keine mehr �u�ern."),
			writeln("Leider hast du den Fall nicht gel�st und wirst gefeuert."),
			writeln("Das Spiel ist nun beendet - schlie�e es mit 'Qu�lgeist beenden' und starte es neu f�r einen weiteren Versuch.")
			)
		).



:- retractall(vorbei(_)).
:- dynamic vorbei/1.

als_vorbei_markieren(Situation) :-
	not(vorbei(Situation)),
	assertz(vorbei(Situation)).



:- retractall(alter_antwort(_)).
:- dynamic alter_antwort/1.

alter_antwort(["8"]).

:- retractall(name_antwort(_)).
:- dynamic name_antwort/1.

name_antwort(["Ich", "hei�e", "Alex"]).



:- retractall(location_counter(_)).
:- dynamic location_counter/1.

location_counter(0).

reset_counter :-
	location_counter(Old),
	retract(location_counter(Old)),
	assertz(location_counter(0)).

increase_counter :-
	location_counter(Old),
	New is Old+1,
	retract(location_counter(Old)),
	assertz(location_counter(New)).

randomize_child :-
	(
		location_counter(3),
		reset_counter,
		alle_orte(Orte),
		random_permutation(Orte, [Location|_]),
		change_person('Alex', Location)
		);
	increase_counter.

%Wissensbasis

location(eingangsbereich, 'der Eingangsbereich').
location(eingangsbereich_beamter, 'der Eingangsbereich').
location(schlafzimmer, 'das Schlafzimmer').
location(kueche, 'die K�che').
location(garten, 'der Garten').
location(wohnzimmer, 'das Wohnzimmer').
location(arbeitszimmer, 'das Arbeitszimmer').
location(geheimgang, 'der Geheimgang').


ort(eingangsbereich).
ort(schlafzimmer).
ort(kueche).
ort(garten).
ort(wohnzimmer).
ort(arbeitszimmer).

alle_orte(Orte) :- setof(O, ort(O), Orte).

waffe1(pistole, 'eine Pistole').
waffe1(messer, 'ein Messer').
waffe1(seil, 'ein Seil').
waffe1(spaten, 'ein Spaten').
waffe1(gift, 'ein Fl�schchen mit Gift').
waffe1(pokal, 'einen Pokal').

waffe(pistole).
waffe(messer).
waffe(seil).
waffe(spaten).
waffe(gift).
waffe(pokal).

alle_waffen(Waffen) :- setof(W, waffe(W), Waffen).


taeter(vater).
taeter(mutter).
taeter(gaertner).
taeter(koch).
taeter(nachbar).
taeter(besuch).

eltern(vater).
eltern(mutter).

angestellte(gaertner).
angestellte(koch).

alle_taeter(Taeter) :- setof(T, taeter(T), Taeter).

%Mord (explizite Eingabe)
%tatort(arbeitszimmer).
%tatwaffe(seil).
%moerder(nachbar).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%randomisierter Mord
tatort(Tatort) :- alle_orte(Orte), random_permutation(Orte,[Tatort|_Rest]).
tatwaffe(Tatwaffe) :- alle_waffen(Waffen), random_permutation(Waffen, [Tatwaffe|_Rest]).
moerder(Moeder) :- alle_taeter(Taeter), random_permutation(Taeter,[Moeder|_Rest]).

%um Mord auszugeben
mord :- tatort(Ort), tatwaffe(Waffe), moerder(Moerder), 
		write('Der Taeter ist: '), writeln(Moerder), write('Der Tatort ist: '), writeln(Ort), write('Die Tatwaffe ist: '), writeln(Waffe).

lageplan :- nl,
			writeln("                LAGEPLAN             "),
			writeln("____/ _______________________________"),
			writeln("|            |           |           | \\"),
			writeln("|            |           |           |   \\"),
			writeln("|            |           |           |     \\"),
			writeln("|  Eingangs- |  Schlaf-  |  K�che    |       \\"),
			writeln("|  bereich   |  zimmer   |           |         \\"),
			writeln("|            |           |           |          |"),
			writeln("|            |____  _____|____  _____|          |"),
			writeln("|                                    |          |"),
			writeln("|                                       Garten  |"),
			writeln("|_______  ________________  _________|          |"),
			writeln("|                 |                  |          |"),
			writeln("|                 |                  |          |"),
			writeln("|    Arbeits-     |                  |         /"),
			writeln("|    zimmer       |   Wohnnzimmer    |       /"),
			writeln("|                 |                  |     /"),
			writeln("|                 |                  |   /"),
			writeln("|_________________|__________________| /"),
			nl.


verdaechtigung(A) :- 
	writeln("Ok, dann lass mal h�ren."),
	writeln("Wer ist deiner Meinung nach der M�rder?"),
	read_sentence([Moerderverdacht|_Tail]),
	(
		(
			taeter(Moerderverdacht),
			verdaechtigung2(Moerderverdacht, A)
			); 
		(
			writeln("Ich bin so gespannt, deswegen nenne den Tatverd�chtigen als erstes in deinem Satz."),
			writeln("Du kannst nur Personen verd�chtigen, die in der Liste der m�glichen T�ter auftauchen:"),
			alle_taeter(Taeterliste),
			writeln(Taeterliste),
			verdaechtigung1(A)
			)
		).

verdaechtigung1(A) :- 
	writeln("Wer ist deiner Meinung nach der M�rder?"),
	read_sentence([Moerderverdacht|_Tail]),
	(
		(
			taeter(Moerderverdacht),
			verdaechtigung2(Moerderverdacht, A)
			);
		(
			writeln("Ich bin so gespannt, deswegen nenne den Tatverd�chtigen als erstes in deinem Satz."),
			writeln("Du kannst nur Personen verd�chtigen, die in der Liste der m�glichen T�ter auftauchen."),
			alle_taeter(Taeterliste),
			writeln(Taeterliste),verdaechtigung1(A)
			)
		).

verdaechtigung2(Moerderverdacht, A) :- 
	writeln("Was war die Tatwaffe?"),
	read_sentence([Tatwaffeverdacht|_Tail]),
	(
		(
			waffe(Tatwaffeverdacht),
			verdaechtigung3(Moerderverdacht, Tatwaffeverdacht, A)
			);
		(
			writeln("Ich bin so gespannt, deswegen nenne die Tatwaffe als erstes in deinem Satz."),
			writeln("Du kannst nur Gegenst�nde nennen, die in der Liste der m�glichen Tatwaffen auftauchen:"),
			alle_waffen(Waffen),
			writeln(Waffen),
			verdaechtigung2(Moerderverdacht, A)
			)
		).


verdaechtigung3(Moerderverdacht, Tatwaffeverdacht, A) :- 
	writeln("Wo wurde die Putzfrau ermordet?"),
	read_sentence([Ortverdacht|_Tail]), 
	(
		location(Ortverdacht, _),
		verdaechtigungComplete(Moerderverdacht,Tatwaffeverdacht, Ortverdacht, A)
		);
	(
		writeln("Ich bin so gespannt, deswegen nenne den Tatort als erstes in deinem Satz."),
		writeln("Du kannst nur Orte nennen, die in der Liste der m�glichen Tatorte stehen:"),
		alle_orte(Orte),
		writeln(Orte),
		verdaechtigung3(Moerderverdacht,Tatwaffeverdacht, A)
		).

verdaechtigungComplete(Moerderverdacht,Tatwaffeverdacht, Ortverdacht, A) :- 
	(
		moerder(Moerderverdacht),
		tatwaffe(Tatwaffeverdacht),
		tatort(Ortverdacht),
		output(solved, A)
		);
	output(wrong_suspicion, A).


random_answer(Situation, Head) :- 
	normal(Situation),
	random_permutation([
		["Ich", denke, nicht, dass, wir, jetzt, dar�ber, reden, "sollten."],
		["Bitte", denke, nocheinmal, �ber, deinen, n�chsten, "Schritt", "nach."],
		["Willst", du, das, "Spiel", etwa, "beenden?", "Dann", musst, du, "'Qu�lgeist beenden'", "eingeben."]],
		[Head|_]).

random_answer(kind, Head) :- 
	random_permutation([
		["Hey,", du, willst, etwas, von, "mir,", stell, eine, sinnvolle, "Frage!"],
		["Darauf", will, ich, dir, gerade, nicht, "antworten."],
		["Willst", du, unser, "Gespr�ch", etwa, schon, "beenden?", "Dann", sag, das, doch, "einfach."]],
		[Head|_]).


gerichtsmediziner(Out, Loc, A) :-
	(
		was_there(eingangsbereich),
		was_there(garten),
		was_there(kueche),
		was_there(arbeitszimmer),
		was_there(wohnzimmer),
		was_there(schlafzimmer),
		gerichtsmediziner_output(Out, Loc, A)
		);
	output(Out, A).

gerichtsmediziner_output(Out, Loc, A) :-
	location(Loc, _),
	tatort(Tatort),
	tatort_tipp(Tatort, Tipp),
	nl,
	write("Als du loslaufen willst klingelt dein Handy."),
	nl,
	writeln("'Hallo?'"),
	writeln("'Guten Tag, Frank von der Gerichtsmedizin hier. "), 
	write(Tipp), writeln("'"),
	writeln("'Vielen Dank. Sonst noch etwas?'"),
	writeln("'Nein.'"),
	writeln("'Okay, vielen Dank nocheinmal - Einen sch�nen Tag Ihnen noch.'"),
	writeln("'Ebenso.'"),
	nl,
	writeln("Du legst auf und �berlegst kurz, was dieser Hinweis bedeuten kann."),
	writeln("Dann setzt du deine Suche fort."),
	output(Out, A).



tatort_tipp(wohnzimmer, "Ich wollte Ihnen nur mitteilen, dass wir in der Wunde Sofafusseln gefunden haben.").
tatort_tipp(garten, "Ich wollte Ihnen nur mitteilen, dass wir in der Wunde Grasreste gefunden haben.").
tatort_tipp(arbeitszimmer, "Ich wollte Ihnen nur mitteilen, dass wir in der Wunde Papierschnipsel - scheinbar aus einem Aktenvernichter - gefunden haben.").
tatort_tipp(eingangsbereich, "Ich wollte Ihnen nur mitteilen, dass wir in der Wunde Schlammreste gefunden haben.").
tatort_tipp(eingangsbereich_beamter, "Ich wollte Ihnen nur mitteilen, dass wir in der Wunde Schlammreste gefunden haben.").
tatort_tipp(kueche, "Ich wollte Ihnen nur mitteilen, dass wir in der Wunde Lebensmittelreste gefunden haben.").
tatort_tipp(schlafzimmer, "Ich wollte Ihnen nur mitteilen, dass wir in der Wunde Daunenfedern gefunden haben.").


beamten_gesprochen(A) :-
	situation(eingangsbereich),
	person('Du', eingangsbereich),
	person('Beamter', eingangsbereich),
	output(beamten_vergessen, A).



% Situation: normal

normal(X) :- 
	member(X, [eingangsbereich, garten, kueche, arbeitszimmer, wohnzimmer, schlafzimmer, geheimgang]).


match([wo, bin, ich], ["Dein aktueller Aufenthaltsort ist", Ort]) :-
	situation(X),
	normal(X),
	person('Du', Loc),
	location(Loc, Ort).

match([wie, geht, es, dir],["Was f�r eine langweilige Frage von dir."]) :- 
	situation(kind).

match([ok], ["Stell", ruhig, munter, weiter, "Fragen,", ich, schaue, "dann,", ob, ich, sie, dir, beantworten, "will."]) :-
	situation(kind).

match([wie, hast, du, den, mord, gesehen], ["Ich", bin, ein, "Meister", im, "Verstecken."]) :-
	situation(kind).

match([war, es, _, _], ["So", einfach, mache, ich, es, dir, "nicht!"]) :-
	situation(kind).

match([hallo], ["Hallo."]) :-
	situation(kind).

match([wo, ist, alex], [Ort]) :-
	person('Alex', Ort).

match([wo, ist, das, kind], [Ort]) :-
	person('Alex', Ort).

match(Input, Output) :-
	ask(Input, Output).

% muss immer als letzte match-Abfrage stehen
match(_, Answer) :- 
	situation(Situation),
	random_answer(Situation, Answer).


ask(Q, ["Dort", bist, du, doch, "bereits!"]) :- 
	situation(X),
	normal(X),
	normal(Location),
	member(Location, Q),
	person('Du', Location).


ask(Q, A) :-
	situation(X),
	normal(X),
	member(garten, Q),
	nl,
	writeln("Willst du wirklich in den Garten gehen?"),
	nl,
	read_sentence(Input),
	(
		(
			member(ja, Input),
			(
				change_situation(garten),
				add_location(garten),
				randomize_child,
				(
					(
						person('Alex', garten),
						gerichtsmediziner(garten_kind, garten, A)
						);
					gerichtsmediziner(garten, garten, A)
					)
				)
			);
		output(no, A)
		).

ask(Q, A) :-
	situation(X),
	normal(X),
	member(arbeitszimmer, Q),
	nl,
	writeln("Willst du wirklich in das Arbeitszimmer gehen?"),
	nl,
	read_sentence(Input),
	(
		(
			member(ja, Input),
			change_situation(arbeitszimmer),
			add_location(arbeitszimmer),
			randomize_child,
			(
				(
					person('Alex', arbeitszimmer),
					gerichtsmediziner(arbeitszimmer_kind, arbeitszimmer, A)
					);
				gerichtsmediziner(arbeitszimmer, arbeitszimmer, A)
				)
			);
		output(no, A)
		).

ask(Q, A) :-
	situation(X),
	normal(X),
	member(k�che, Q),
	nl,
	writeln("Willst du wirklich in die K�che gehen?"),
	nl,
	read_sentence(Input),
	(
		(
			member(ja, Input),
			change_situation(kueche),
			add_location(kueche),
			randomize_child,
			(
				(
					person('Alex', kueche),
					gerichtsmediziner(kueche_kind, kueche, A)
					);
				gerichtsmediziner(kueche, kueche, A)
				)
			);
		output(no, A)
		).

ask(Q, A) :-
	situation(X),
	normal(X),
	member(schlafzimmer, Q),
	nl,
	writeln("Willst du wirklich in das Schlafzimmer gehen?"),
	nl,
	read_sentence(Input),
	(
		(
			member(ja, Input),
			change_situation(schlafzimmer),
			add_location(schlafzimmer),
			randomize_child,
			(
				(
					person('Alex', schlafzimmer),
					gerichtsmediziner(schlafzimmer_kind, schlafzimmer, A)
					);
				gerichtsmediziner(schlafzimmer, schlafzimmer, A)
				)
			);
		output(no, A)
		).

ask(Q, A) :-
	situation(X),
	normal(X),
	member(wohnzimmer, Q),
	nl,
	writeln("Willst du wirklich in das Wohnzimmer gehen?"),
	nl,
	read_sentence(Input),
	(
		(
			member(ja, Input),
			change_situation(wohnzimmer),
			add_location(wohnzimmer),
			randomize_child,
			(
				(
					person('Alex', wohnzimmer),
					gerichtsmediziner(wohnzimmer_kind, wohnzimmer, A)
					);
				gerichtsmediziner(wohnzimmer, wohnzimmer, A)
				)
			);
		output(no, A)
		).


ask(Q, A) :-
	situation(X),
	normal(X),
	(member(eingangsbereich, Q);
		member(eingang, Q)),
	nl,
	writeln("Willst du wirklich in den Eingangsbereich gehen?"),
	nl,
	read_sentence(Input),
	(
		(
			member(ja, Input),
			(
				(
					person('Beamter', eingangsbereich),
					gerichtsmediziner(eingangsbereich_beamter, A)
					);
				(
					(
						person('Alex', eingangsbereich),
						gerichtsmediziner(eingangsbereich_kind, eingangsbereich, A)
						);
					gerichtsmediziner(eingangsbereich, eingangsbereich, A)
					)
				),
			change_situation(eingangsbereich),
			randomize_child
			);
		output(no, A)
		).


ask(Q, A) :-
	situation(X),
	normal(X),
	(
		member(geheimgang, Q);
		member(geheim, Q);
		member(gang, Q)
		),
	vorbei(morse),
	(
		(
			vorbei(geheimgang),
			output(geheimgewesen, A)
			);
		(
			nl,
			writeln("Willst du wirklich in den Geheimgang gehen?"),
			nl,
			read_sentence(Input),
			(
				(
					member(ja, Input),
					output(geheimgang, A),
					change_situation(geheimgang),
					als_vorbei_markieren(geheimgang),
					randomize_child
					);
				output(no, A)
				)
			)
		).


%%%%%%%%%%
% Umschauen in R�umen 
%%%%%%%%%%

%%%%%%%%%%%%Schlafzimmer
ask(Q,["Du", habst, die, "Bettdecke", an, und, darunter, liegt, eine, zusammengerollte, "Katze", und, "schl�ft."]) :-
	situation(schlafzimmer),
	(member(bett,Q);
		member(decke,Q);
		member(bettdecke, Q);
		member(w�lbung, Q)
		).

ask(Q,["Du", kraulst, die, "Katze", und, sie, schnurrt, zufrieden, vor, sich, "hin."]) :-
	situation(schlafzimmer),
	member(katze,Q).

ask(Q,["Du", gehst, zum, "Nachtisch", und, betrachtest, die, "Uhr", genauer, und, stellst, "fest,", dass, sie, sehr, alt, "ist.", "\nVermutlich", ein, "Erbst�ck,", daher, passt, sie, nicht, zum, modernen, "Rest", des, "Zimmers.", "\nDa", bemerkst, "du,", dass, die, "Uhr", auf, einem, dicken, "Buch", "steht."]) :-
	situation(schlafzimmer),
	(member(nachttisch,Q);
		member(tisch,Q);
		member(uhr, Q)
		).

ask(Q,["Das Buch tr�gt den Titel: Das perfekte Verbrechen."]) :-
	situation(schlafzimmer),
	member(buch,Q).

ask(Q,["Du", �ffnest, den, "Schrank", und, bist, von, der, "F�lle", an, "Klamotten", "beeindruckt -", "Hemden, Hosen, Kleider, Taschen, Schuhe, Krawatten-", in, allen, m�glichen, "Farben und Mustern.", "\nW�hrend", du, noch, ganz, fasziniert, die, "Kleidung", "begutachtest,", f�llt, die, pl�tzlich, "auf,", dass, sich, hinten, im, "Schrank", eine, versteckte, "T�re", "befindet."]) :-
	situation(schlafzimmer),
	(member(schrank,Q);
		member(kleiderschrank,Q);
		member(sschrenkt�r, Q)
		).

ask(Q,["Du versuchst die T�re zu �ffnen, du r�ttelst kr�ftig daran, doch leider beibst du dabei erfolglos."]) :-
	situation(schlafzimmer),
	(member(t�re,Q);
		member(t�r,Q);
		member(versuchen, Q) %falls jemand es nochmal versuchen will die Tuere zu oeffnen
		).

ask(Q, ["Ein Schl�ssel f�r die T�re im Schrank ist weit und breit nicht zu sehen."]) :-
	situation(schlafzimmer),
	member(schl�ssel, Q).

%%%%%%%%%%%%Wohnzimmer
ask(Q, ["Das bequeme wei�e Sofa sieht wie frisch gereinigt aus, kein noch so kleiner Fleck ist zu sehen."]) :-
	situation(wohnzimmer),
	(member(sofa,Q);
		member(kissen,Q);
		member(sofaecke,Q)
		).

ask(Q, ["Von hier hat man den gesamten Garten gut im �berblick.", "\nDie Fensterscheiben sind so get�nt, dass man gut raus schauen kann, aber niemand vom Garten reinschauen kann."]) :-
	situation(wohnzimmer),
	member(fenster, Q).

ask(Q, ["Du schaust dir die B�cher an - eine Brockhaus Enzyklop�die, ein Atlas, ein paar Romane, hier und dort ein Kinderbuch - nicht weiter interessant."]) :-
	situation(wohnzimmer),
	(member(b�cherwand,Q);
		member(b�cher,Q);
		member(buch,Q);
		member(b�cherregal, Q)
		).

ask(Q, ["Ein Buch zu lesen ist jetzt keine gute Idee, du musst einen Fall l�sen, sonst bist du deinen Job los."]) :-
	situation(wohnzimmer),
	member(lesen, Q).


ask(Q, A) :-
	situation(wohnzimmer),
	(member(gem�lde, Q);
		member(bild, Q)
		),
	writeln("Auf dem Bild sind 2 Reiter auf Pferden zu sehen."),
	nl,
	(
		(
			vorbei(morse),
			output(geheimbekannt, A)
			);
		output(geheimunbekannt, A)
		).


%%%%%%%%%%%%%%Geheimgang

ask(Q,["Du gehst n�her heran, b�ckst dich und hebst einen blutverschmierten Gegenstand auf.", "\nEs ist:", Wort]):-
	situation(geheimgang),
	(member(boden, Q);
		member(gegenstand, Q);
		member(liegen, Q);
		member(liegt, Q)
		),
	tatwaffe(Waffe),
	waffe1(Waffe,Wort).


ask(Q, A) :-
	situation(geheimgang),
	member(raus, Q),
	change_situation(schlafzimmer),
	nl,
	writeln("Du gehst den Gang weiter entlang und am Ende ist eine T�r. Diese l�sst sich von dieser Seite problemlos ohne Schl�ssel �ffnen."),
	output(schlafzimmer, A).
%%%%%%%%%%%%%%%

ask(Q, A) :-
	person('Beamter', eingangsbereich),
	situation(eingangsbereich),
	(
		member(beamter, Q);
		member(beamten, Q);
		member(polizisten, Q);
		member(polizist, Q)
		),
	nl,
	writeln("Willst du den Beamten ansprechen?"),
	nl,
	read_sentence(Input),
	(
		(
			member(ja, Input),
			output(beamter, A),
			change_situation(beamter)
			);
		output(no, A)
		).

ask(Q, A) :-
	situation(beamter),
	(
		(
			member(t�ter, Q);
			member(m�rder, Q);
			member(info, Q);
			member(infos, Q);
			member(information, Q);
			member(informationen, Q)
			),
		nl,
		writeln("Ich kann Ihnen nicht sagen wer den Mord tats�chlich begangen hat, aber ich kann Ihnen folgendes sagen:"),
		output(taeter_info, A)
	 );
	(
		(
			member(tatverd�chtigen, Q);
			member(tatverd�chtige, Q);
			member(tatverd�chtiger, Q)
			),
		output(taeter_info, A)
		),
	retract(person('Beamter', _)).

ask(Q, A) :-
	situation(beamter),
	(member(beenden, Q);
		member(tschuess, Q);
	 	member(gehen, Q);
	 	member(ende, Q);
	 	member(wiedersehen, Q);
	 	member(danke, Q)
	 	),
	nl,
	writeln("Kann ich Ihnen sonst noch behilflich sein?"),
	nl,
	read_sentence(Input),
	(
		(
			(
				member(nein, Input);
				member(danke, Input)),
			person('Du', Location),
			change_situation(Location),
			output(gespraech_ende, A));
		output(beamter_stay, A)
		).



% Gespr�ch beginnen
ask(Q, A) :-
	person('Alex', Location),
	situation(Location), 
	(
		member(kind, Q);
		member(alex, Q)
		),
	nl,
	writeln("Willst du das Kind ansprechen?"),
	nl,
	read_sentence(Input),
	(
		(
			member(ja, Input),
			output(kind, A),
			change_situation(kind)
			);
		output(no, A)
		).
%wenn ales nicht in dem Zimmer ist, du aber versuchst ihn anzusprechen
ask(Q, ["Das Kind ist nicht in diesem Raum, such es erstmal, bevor du es ansprichst."]) :-
	person('Alex', Location),
	not(situation(Location)), 
	(
		member(kind, Q);
		member(alex, Q)
		).

ask(Q, A) :-
	situation(kind),
	member(hinweis, Q),
	nl,
	writeln("Willst du einen Hinweis von mir?"),
	nl,
	read_sentence(Input),
	(
		(
			(
				(
					member(ja, Input),
					member(bitte, Input)
					);
				member(bitte, Input)
				),
			(
				(
					vorbei(scheresteinpapier),
					output(no_hinweis, A)
					);
				(
					(
						moerder(T),
						eltern(T),
						scheresteinpapier(A,eltern)
						);
					scheresteinpapier(A,sonstige)
					),
				als_vorbei_markieren(scheresteinpapier)
				)
			);
		(
			(
				member(ja, Input)
				),
			not(member(bitte, Input)),
			output(no_bitte, A)
			);
		output(no, A)
		).


ask(Q, A) :-
	situation(kind),
	member(tipp, Q),
	nl,
	writeln("Willst du einen Tipp von mir?"),
	nl,
	read_sentence(Input),
	(
		(
			(
				(
					member(ja, Input),
					member(bitte, Input)
					);
				member(bitte, Input)
				),
			(
				(
					vorbei(mastermind),
					output(no_tipp, A)
					);
				(
					(
						moerder(T),
						angestellte(T),
						mastermind(A, angestellter)
						);
					mastermind(A, sonstige)
					),
				als_vorbei_markieren(mastermind)
				)
			);
		(
			(
				member(ja, Input)
				),
			not(member(bitte, Input)
				),
			output(no_bitte, A)
			);
		output(no, A)
		).



ask(Q, A) :-
	situation(kind),
	(
		member(hilfe, Q);
		member(helfen, Q);
		member(hilfestellung, Q)
		),
	nl,
	writeln("Brauchst du meine Hilfe?"),
	nl,
	read_sentence(Input),
	(
		(
			(
				(
					member(ja, Input),
					member(bitte, Input)
					);
				member(bitte, Input)
				),
			(
				(
					vorbei(morse),
					output(no_hilfe, A)
					);
				(
					morsen(A),
					als_vorbei_markieren(morse)
					)
				)
			);
		(
			(
				member(ja, Input)
				),
			not(member(bitte, Input)
				),
			output(no_bitte, A)
			);
		output(no, A)
		).

ask(Q, A) :-
	situation(kind),
	(member(rat, Q);
		member(ratschlag, Q)
		),
	(moerder(gaertner), output(falscher_rat1, A);
		output(falscher_rat2,A)).

ask(Q,A):-
	situation(kind),
	vorbei(morse),
	(
		(
			vorbei(geheimgang),
			output(geheimgewesen, A)
			);
		(
			(
				member(folge, Q);
				member(folgen, Q);
				member(mitkommen, Q)
				),
			change_situation(wohnzimmer),
			change_person('Alex', wohnzimmer),
			output(folgen, A)
			)
		).


ask(Q, ["Ich", "wei�", "selber,", dass, das, Word, "ist!"]) :-
	situation(kind),
	normal(Location),
	member(Location, Q),
	person('Du', Location),
	location(Location, Word).


ask(Q, ["Nein,", das, hier, ist, nicht, Word, "-", das, sieht, man, "doch."]) :-
	situation(kind),
	normal(Location),
	member(Location, Q),
	not(person('Du', Location)),
	location(Location, Word).

ask(Q,["Bitte,", ich, beende, jetzt, das, "Gespr�ch,", ich, will, lieber, "spielen."]) :-
	situation(kind),
	member(danke, Q),
	person('Du', Location),
	change_situation(Location).

ask(Q, A) :-
	situation(kind),
	(
		member(beenden, Q);
		member(tschuess, Q);
		member(gehen, Q);
		member(ende, Q);
		member(wiedersehen, Q)
		),
	nl,
	writeln("Willst du unser Gespr�ch etwa einfach so beenden?"),
	nl,
	read_sentence(Input),
	(
		(
			member(ja, Input),
			person('Du', Location),
			change_situation(Location),
			output(gespraech_ende, A)
			);
		output(no, A)
		).

ask(Q, A) :-
	situation(kind),
	(
		member(alt, Q);
		member(alter, Q)
		),
	nl,
	writeln("Willst du etwa wissen wie alt ich bin?"),
	nl,
	read_sentence(Input),
	(
		(
			member(ja, Input),
			alter_antwort(A),
			retract(alter_antwort(A)
				),
			assertz(alter_antwort(["Das", habe, ich, dir, doch, bereits, "gesagt."]))
			);
		output(no, A)
		).


ask(Q,A) :-
	situation(kind),
	(
		member(name, Q);
		member(hei�t, Q);
		member(heisst, Q)
		),
	nl,
	writeln("Willst du meinen Namen wissen?"),
	nl,
	read_sentence(Input),
	(
		(
			member(ja, Input),
			name_antwort(A),
			retract(name_antwort(A)),
			assertz(name_antwort(["Kannst", du, dir, nichtmal, meinen, "Namen", "merken?"]))
			);
		output(no, A)
		).

%wollen wir hier nciiht auch Situation beamter zulassen? so nach dem motto: was koennen sie ueber das opfer sagen: er sagt dann haalt nur Opfer ist Putzfrau, weis nciht mehr
ask(Q,["Das", "Opfer", ist, die, "Putzfrau", der, "Familie."]) :-
	situation(X),
	normal(X),
	member(opfer, Q).


ask(Q, []) :- 
	situation(X),
	normal(X),
	member(lageplan, Q),
	lageplan.


ask(Q, []) :- 
	situation(X),
	normal(X),
	(
		member(tatorte, Q);
		member(r�ume, Q)
		),
	nl,
	writeln("Alle R�ume im Haus kommen als Tatort in Frage:"),
	lageplan.


ask(Q, A) :-
	(
		member(verd�chtigung, Q);
		member(verd�chtige, Q);
		member(verd�chtigter, Q);
		member(verd�chtig, Q);
		member(t�ter, Q)
		),
	nl,
	writeln("M�chtest du eine Verd�chtigung �u�ern?"),
	nl,
	read_sentence(Input),
	(
		(
			member(ja, Input),
			verdaechtigungszahl(Anzahl),
			Anzahl < 3,
			verdaechtigung(A),
			set_verdaechtigung
			);
		output(no, A)
		).

ask(Q, A) :-
	(
		situation(eingangsbereich);
		situation(eingangsbereich_beamter)
		),
	member(kommode, Q),
	output(kommode, A).

ask(Q, A) :-
	(
		situation(eingangsbereich);
		situation(eingangsbereich_beamter)
		),
	(
		member(garderobe, Q);
		member(jacken, Q);
		member(schuhe, Q)
		),
	output(garderobe, A).


ask(Q, A) :-
	situation(garten),
	member(hecke, Q),
	output(hecke, A).

ask(Q, A) :-
	situation(garten),
	(
		member(blumenbeet, Q);
		member(beet, Q)
		),
	output(blumenbeet, A).

ask(Q, A) :-
	situation(garten),
	(
		member(apfelbaum, Q);
		member(baum, Q)
		),
	output(apfelbaum, A).

ask(Q, A) :-
	situation(garten),
	(
		member(sitzecke, Q);
		member(holzbank, Q);
		member(holzb�nke, Q);
		member(grillschale, Q)
		),
	output(sitzecke, A).


ask(Q, A) :-
	situation(arbeitszimmer),
	(
		member(schreibtisch, Q);
		member(tisch, Q);
		member(stuhl, Q);
		member(schreibtischstuhl, Q);
		member(m�lleimer, Q)
		),
	output(schreibtisch, A).

ask(Q, A) :-
	situation(arbeitszimmer),
	(
		member(schrank, Q);
		member(schrankwand, Q);
		member(ordner, Q);
		member(dvds, Q);
		member(dvd, Q)
		),
	output(schrankwand, A).

ask(Q, A) :-
	situation(arbeitszimmer),
	member(aktenvernichter, Q),
	output(aktenvernichter, A).

ask(Q, A) :-
	situation(arbeitszimmer),
	(
		member(bilder, Q);
		member(kalender, Q);
		member(wand, Q)
		),
	output(bilderkalender, A).

ask(Q, A) :-
	situation(arbeitszimmer),
	(
		member(scheibe, Q);
		member(darts, Q);
		member(dart, Q);
		member(dartscheibe, Q);
		member(bild, Q)
		),
	output(dartscheibe, A).


ask(Q, A) :-
	situation(kueche),
	(	
		member(k�hlschrank, Q);
		member(schrank, Q);
		member(schrankwand, Q);
		member(k�chenschrank, Q)
		),
	output(kuechenschrank, A).

ask(Q, A) :-
	situation(kueche),
	(	
		member(essensreste, Q);
		member(reste, Q);
		member(essen, Q)
		),
	output(essensreste, A).

ask(Q, A) :-
	situation(kueche),
	(	
		member(herd, Q);
		member(kuechenzeile, Q);
		member(arbeitsfl�che, Q)
		),
	output(kuechenzeile, A).


output(garten,
	["Du gehst in den Garten.",
	"\n\nEr ist wundersch�n und man sieht, dass diese Familie einen G�rtner haben muss.",
	"\nEine rechteckig gestutzte Hecke sch�tzt das Innere vor neugierigen Blicken.",
	"\nAu�erdem gibt es ein gro�es, buntes Blumenbeet und einen riesigen Apfelbaum.",
	"\n\nDas Highlight des Gartens ist aber klar die gro�e Sitzecke mit Holzb�nken und einer Grillschale,",
	"\nin der es scheinbar vor Kurzem noch gebrannt hatte."]
	).

output(garten_kind,
	["Du gehst in den Garten.",
	"\n\nEr ist wundersch�n und man sieht, dass diese Familie einen G�rtner haben muss.",
	"\nEine rechteckig gestutzte Hecke sch�tzt das Innere vor neugierigen Blicken.",
	"\nAu�erdem gibt es ein gro�es, buntes Blumenbeet und einen riesigen Apfelbaum.",
	"\n\nDas Highlight des Gartens ist aber klar die gro�e Sitzecke mit Holzb�nken und einer Grillschale,",
	"\nin der es scheinbar vor Kurzem noch gebrannt hatte.",
	"\n\nDas Kind rennt wie ein Verr�ckter um den Baum herum."]
	).

output(hecke,
	["Du machst ein paar Schritte in Richtung der Hecke, merkst aber schnell, dass es dort keine Informationen zu holen gibt."]
	).

output(blumenbeet,
	["Du gehst zum Blumenbeet und l�sst deinen Blick dar�ber wandern.",
	"\n\nDir f�llt auf, dass der G�rtner in letzter Zeit sehr viele Rosen gepflanzt hatte.",
	"\nM�glicherweise hatte das einen bestimmten Hintergrund, wie etwa eine neue Liebe?"]
	).

output(apfelbaum,
	["Du gehst zum Apfelbaum und bemerkst sofort die Schnitzerei im Baum.",
	"\nOffensichtlich ist hier ein Herz mit dem Namen der Putzfrau und dem eines Mannes eingraviert.",
	"\nDer m�nnliche Name wurde allerdings zu Teilen entfernt und ist nichtmehr klar zu erkennen."]
	).

output(sitzecke,
	["Du gehst zur Sitzecke und nimmst sie genau unter die Lupe.",
	"\n\nDie Holzb�nke verbergen keine Informationen, doch in der Asche in der Grillschale liegen einige verbrannte Briefe.",
	"\nDu liest dir die Briefe durch, zumindest das was davon �brig geblieben ist.",
	"\n\nEs handelt sich um Liebesbriefe, doch am Ende scheint es Streit gegeben zu haben.",
	"\nEin Absender oder Empf�nger l�sst sich aber nicht entdecken."]
	).

output(arbeitszimmer, 
	["Du betrittst das Arbeitszimmer.", 
	"\n\nEs ist offensichtlich dass dies das Reich des Vaters ist.",
	"\nDas  Zimmer ist sp�rlich eingerichtet - lediglich eine Schrankwand voll mit Ordnern und DVDs und",
	"\nein Schreibtisch sowie ein Stuhl finden sich hier.",
	"\n\nEin Aktenvernichter, der neben dem Schreibtisch steht, muss vor kurzem umgekippt sein, denn �berall im Zimmer finden sich kleine Papierschnipsel.",
	"\n\nAn der Wand h�ngt neben einigen Bildern und einem Kalender auch eine Dartscheibe, in der noch einige Darts stecken.",
	"\nDie Dartscheibe scheint mit einem Foto geschm�ckt zu sein, auf das offensichtlich mehrfach gezielt wurde."]
	).

output(arbeitszimmer_kind, 
	["Du betrittst das Arbeitszimmer.", 
	"\n\nEs ist offensichtlich dass dies das Reich des Vaters ist.",
	"\nDas  Zimmer ist sp�rlich eingerichtet - lediglich eine Schrankwand voll mit Ordnern und DVDs und",
	"\nein Schreibtisch sowie ein Stuhl finden sich hier.",
	"\n\nEin Aktenvernichter, der neben dem Schreibtisch steht, muss vor kurzem umgekippt sein, denn �berall im Zimmer finden sich kleine Papierschnipsel.",
	"\n\nAn der Wand h�ngt neben einigen Bildern und einem Kalender auch eine Dartscheibe, in der noch einige Darts stecken.",
	"\nDie Dartscheibe scheint mit einem Foto geschm�ckt zu sein, auf das offensichtlich mehrfach gezielt wurde.",
	"\n\nDas Kind steht in der Mitte des Raumes und wirft Papierk�gelchen in den M�lleimer neben dem Schreibtisch."]
	).

output(schrankwand,
	["Du gehst zur Schrankwand und schaust, ob du dort etwas Interessantes findest.",
	"\n\nDie DVDs sind uninteressant - doch in einem der Ordner steht, dass der Lohn der Putzfrau im letzten Monat drastisch gek�rzt wurde.",
	"\nM�glicherweise kam es dadurch zum Streit?"]
	).

output(schreibtisch,
	["Du begutachtest den Schreibtisch und seine Umgebung.",
	"\n\nDer Computer ist aus und mit einem Passwort gesch�tzt - allerdings darfst du auf ihn eh nicht zugreifen ohne Gerichtsbeschluss.",
	"\nDer Rest des Schreibtisches ist sehr ordentlich und liefert auch keine weiteren Informationen."]
	).

output(aktenvernichter,
	["Der Aktenvernichter wurde scheinbar aus Versehen �ber den Boden ausgeleert.",
	"\nDa die Akten geschreddert wurden finden sich hier auch keine Informationen."]
	).

output(bilderkalender,
	["Die Bilder an der Wand sind lediglich Standard-Fotografien.",
	"\n\nDer Kalender jedoch ist interessant.",
	"\nScheinbar ist der Vater erst vor wenigen Tagen von einer Berufsreise aus Miami zur�ckgekommen.",
	"\n\nAu�erdem ist heute ein Besuch mit dem Titel 'Alternative' notiert worden."]
	).

output(dartscheibe,
	["Du gehst zur Dartscheibe und erkennst beim n�herkommen die Person auf dem Bild.",
	"\nEs scheint wohl der Nachbar zu sein, dessen Bild an der Dartscheibe h�ngt."]
	).

output(kueche, 
	["Du betrittst die K�che.",
	"\n\nDer Raum ist beinahe quadratisch mit einer gro�en K�chenzeile auf der gegen�berliegenden und einer Schrankwand mit K�hlschrank auf der linken Seite.",
	"\nEin Fenster zum Garten sorgt f�r viel Licht und einen sch�nen Ausblick auf den Garten.",
	"\n\nDie letzte Person, die hier gekocht hat, scheint nicht sehr ordentlich gewesen zu sein,",
	"\nden �berall liegen noch Reste der Mahlzeit herum."]).

output(kueche_kind, 
	["Du betrittst die K�che.",
	"\n\nDer Raum ist beinahe quadratisch mit einer gro�en K�chenzeile auf der gegen�berliegenden und einer Schrankwand mit K�hlschrank auf der linken Seite.",
	"\nEin Fenster zum Garten sorgt f�r viel Licht und einen sch�nen Ausblick auf den Garten.",
	"\n\nDie letzte Person, die hier gekocht hat, scheint nicht sehr ordentlich gewesen zu sein,",
	"\nden �berall liegen noch Reste der Mahlzeit herum.",
	"\n\nDas Kind steht am Fenster und schaut in den Garten."]).

output(kuechenzeile,
	["Du betrachtest Herd, Waschbecken und Arbeitsfl�che n�her.",
	"\n\nAuch hier finden sich �berall Essensreste, scheinbar irgendetwas mit Tomaten.",
	"\nAnsonsten finden sich hier allerdings keine Hinweise auf die zu untersuchenden Geschehnisse."]
	).

output(kuechenschrank,
	["Du untersuchst die Schrankwand und den K�hlschrank.",
	"\n\nIn den Schr�nken stehen lediglich Teller, sonstiges Geschirr und Gew�rze.",
	"\n\nIm K�hlschrank aber findest du etwas interessantes:",
	"\nEin Teil des Essens ist mit einer nachricht versehen worden, adressiert an die Putzfrau.",
	"\nDarin beschwert sich die Hausherrin dar�ber, dass die Putzfrau zu viel Platz im K�hlschrank verbraucht.",
	"\nDies erscheint jedoch nicht wie ein Mordmotiv - oder?"]
	).

output(essensreste,
	["Scheinbar handelt es sich bei den Essensresten gr��tenteils um Tomatenso�e, mehr ist hier nicht zu erkennen."]
	).


output(schlafzimmer, 
	["Du betrittst das Schlafzimmer.",
	"\n\nEs ist klar dass die Mutter bei dessen Einrichtung die Finger im Spiel hatte.",
	"\nDas ganze Zimmer ist liebevoll mit Dekoartikeln  geschm�ckt," ,
	"\ndie Uhr auf dem Nachttisch scheint aber �berhaupt nicht ins Bild zu passen.",
	"\nEin Kleiderschrank steht an der Wand gegen�ber von der T�r.",
	"\nDie Daunendecke liegt s�uberlich gefaltet auf dem Bett,", 
	"\nin der Mitte erkennt man - bei genauem Hinsehen - eine leichte W�lbung."]
	).

output(schlafzimmer_kind, 
	["Du betrittst das Schlafzimmer.",
	"\n\nEs ist klar dass die Mutter bei dessen Einrichtung die Finger im Spiel hatte.",
	"\nDas ganze Zimmer ist liebevoll mit Dekoartikeln  geschm�ckt," ,
	"\ndie Uhr auf dem Nachttisch scheint aber �berhaupt nicht ins Bild zu passen.",
	"\nEin Kleiderschrank steht an der Wand gegen�ber von der T�r.",
	"\nDie Daunendecke liegt s�uberlich gefaltet auf dem Bett,", 
	"\nin der Mitte erkennt man - bei genauem Hinsehen - eine leichte W�lbung.",
	"\n\nDas Kind sitz auf dem Bett und stupst immer wieder leicht in die W�lbung."]
	).


%Gemaelde ist Eingang zu Geheimgang
%wenn morsen not true, dann "Das Bild sieht irgendwie so aus als wuerde es ein Geheimnis verbrgen, aber ich kann es nciht erkennen"
%nach morsen: morsen true: "Wusste ich doch, dass hier etwas hintersteckt, aber mit dem Eigang zum Geheimgang hatte ich nciht gerechnet."
%willst du in geheimgang gehen?
output(wohnzimmer, 
	["Du betrittst das Wohnzimmer.",
	"\n\nEs ist das sch�nste Zimmer des Hauses, mit einer Sofaecke und einem gro�en bodentiefen Fenster, durch das man einen Blick auf den ganzen Garten hat.", 
	"\nEine riesige B�cherwand ziert die L�ngsseite.",
	"\nDas beeindruckende, prunkvolle Gem�lde an der Wand direkt �ber dem Sofa zieht dich sofort in seinen Bann."]
	).

output(wohnzimmer_kind, 
	["Du betrittst das Wohnzimmer.",
	"\n\nEs ist das sch�nste Zimmer des Hauses, mit einer Sofaecke und einem gro�en bodentiefen Fenster, durch das man einen Blick auf den ganzen Garten hat.", 
	"\nEine riesige B�cherwand ziert die L�ngsseite.",
	"\nDas beeindruckende, prunkvolle Gem�lde an der Wand direkt �ber dem Sofa zieht dich sofort in seinen Bann.",
	"\n\nDas Kind steht vor dem Sofa und starrt auf das Gem�lde."]
	).

output(eingangsbereich, 
	["Du betrittst den Eingangsbereich.", 
	"\n\nDas einzige M�belst�ck hier ist eine Kommode, auf der die ganzen Schl�ssel der Familie sowie die neueste Post zu liegen scheint.",
	"\nIn der Garderobe finden sich auf den ersten Blick nur einige Jacken und Schuhe, die viele Schlammspuren hinterlassen haben.",
	"\n\nDas Licht an der Decke flackert nerv�s."]
	).

output(eingangsbereich_kind, 
	["Du betrittst den Eingangsbereich.", 
	"\n\nDas einzige M�belst�ck hier ist eine Kommode, auf der die ganzen Schl�ssel der Familie sowie die neueste Post zu liegen scheint.",
	"\nIn der Garderobe finden sich auf den ersten Blick nur einige Jacken und Schuhe, die viele Schlammspuren hinterlassen haben.",
	"\n\nDas Licht an der Decke flackert nerv�s.",
	"\n\nDas Kind steht in der Mitte des des Eingangsbereiches und schaut nach oben zum Deckenlicht."]
	).

output(eingangsbereich_beamter, 
	["Du betrittst den Eingangsbereich.",
	"\n\nDort steht ein weiterer Beamter und schreibt etwas in sein Notizbuch.", 
	"\n\nEr steht neben einer Kommode, auf der die ganzen Schl�ssel der Familie sowie die neueste Post zu liegen scheint.",
	"\nIn der Garderobe finden sich auf den ersten Blick nur einige Jacken und Schuhe, die viele Schlammspuren hinterlassen haben.",
	"\n\nDas Licht an der Decke flackert nerv�s."]
	).

output(kommode,
	["Du betrachtest die Kommode n�her.",
	"\n\nInsgesamt 3 Schl�sselbunde liegen dort - allerdings sind sie schwer zuzuordnen, da an keinem Schl�sselanh�nger h�ngen.",
	"\nDie Post ist da schon informativer - drei der Briefe sind an die Mutter adressiert und scheinen von der Steuerbeh�rde zu kommen.",
	"\nZudem liegt dort noch eine Postkarte f�r die Mutter aus Miami, deren Inhalt zwar etwas verschl�sselt erscheint, eindeutig aber anz�glicher Natur ist.",
	"\nDer Absender nennt seinen Namen nicht - theoretisch k�nnte es auch der Vater sein, aber wer wei�?",
	"\n\nDer Rest der Post ist lediglich Werbung."]).

output(garderobe,
	["Du trittst n�her an die Garderobe heran und durchsuchst Schuhe und Jacken.",
	"\n\nDie Schuhe helfen nicht weiter, sie sind lediglich dreckig.",
	"\nIn einer der Jacken jedoch findest du einen an den Vater addressierten Zettel.",
	"\nDarin beschwert sich ein Nachbar �ber die Putzfrau, weil diese den Abfall scheinbar oftmals bei ihm",
	"\nin den Garten wirft, um nicht bis zu den M�lltonnen gehen zu m�ssen."]
	).


output(geheimgang,
	["Du bist in einem Gang, da du kaum etwas sehen kannst, machst du erstmal deine Taschenlampe an.",
	"\nLangsam leuchtest du mit dem Lichtkegel den Gang ab, hier gibt es kaum was.",
	"\nDu l�ufst weiter, da entdeckst du etwas vor dir auf dem Boden."]
	).

output(taeter_info, 
	["Unsere", "Tatverd�chtigen", sind, diese, sechs, "Personen:",
	"\n\nDer", "Vater:", "Er", ist, 39, "Jahre", alt, und, ein, echter, "Workaholic.",
	"\nEr", hat, seine, "Frau", schon, "l�nger", im, "Verdacht,", "eine", "Aff�re", mit, einem, "Freund", oder, "Angestellten", zu, "haben.",
	"\n\nDie", "Mutter:", "Sie", ist, 32, "Jahre", alt, und, im, "Moment", unzufrieden, mit, ihrem, "Leben.",
	"\nSie", hat, ihre, "Arbeit", "f�r", die, "Familie", "aufgegeben,", doch, ihr, "Ehemann", ist, selten, zuhause, und, das, gemeinsame, "Kind", ist, sehr, "anstrengend.",
	"\nDennoch", beteuert, "sie,", immer, treu, gewesen, zu, "sein.",
	"\n\nDer", "G�rtner:", "Er", ist, 27, "Jahre", alt, und, stammt, "urspr�nglich", aus, "Mexiko.",
	"\nEr", ist, sehr, "gutaussehend,", macht, viel, "Sport", und, ist, vorallem, morgens, im, "Haus,", weshalb, der, "Ehemann", ihn, als, erstes, einer, "Aff�re", mit, seiner, "Frau", "verd�chtigte.",
	"\nMan", hat, dennoch, das, "Gef�hl,", dass, ihm, der, "Job", hier, viel, "Spa�", macht, und, er, ihn, auf, keine, "Fall", verlieren, "will.",
	"\n\nDer", "Koch:", "Er", ist, 59, "Jahre", alt, und, arbeitet, schon, seit, vielen, "Jahren", "f�r", den, "Mann", und, seine, "Familie.",
	"\nAllerdings", ist, er, nicht, mehr, so, oft, im, "Haus,", da, er, etwas, gegen, dass, "restliche,", aus, dem, "Ausland", stammende, "Personal", "hat.",
	"\n\nDer", "Nachbar:", "Er", ist, 34, "Jahre", "alt,", nicht, verheiratet, und, wohnt, erst, seit, einem, "Jahr", "nebenan.",
	"\nIn", letzter, "Zeit", scheint, sich, die, "Mutter", "oft", mit, ihm, zu, "treffen,", weshalb, der, "Ehemann", auch, ihn, bereits, als, "m�gliche", "Aff�re", in, "Betracht", gezogen, "hatte.",
	"\nSeit", ein, paar, "Monaten", "h�ufen", sich, bei, ihm, aber, die, "Besuche", einer, anderen, "Frau,", weshalb, der, "Ehemann", diesen, "Gedanken", bereits, verworfen, "hat.",
	"\n\nDer", "Besuch:", "Er", ist, die, "gro�e", "Unbekannte", auf, unserer, "Liste.",
	"\nEr", muss, ein, "Freund", des, "Ehemannes", gewesen, "sein -", dieser, jedoch, wollte, dazu, vor, seiner, "Frau", nichts, "sagen.",
	"\nM�glicherweise", handelt, es, sich, um, einen, "Privatdetektiv?"]
	).

output(gespraech_ende, 
	["Du", beendest, das, "Gespraech."]
	).

output(kind, 
	["Du", gehst, zu, dem, "Kind", und, beginnst, ein, "Gespraech."]
	).

output(beamter, 
	["Du", sprichst, den, "Beamten", im, "Eingangsbereich", "an.",
	"\n\n'Guten", "Tag!", "Was", "k�nnen", "Sie", mir, "�ber", unseren, "Fall", "erz�hlen?'",
	"\n'Ich", denke, "nicht,", dass, ich, mehr, "wei�", als, "Sie -", ich, bin, gerade, "dabei,", mir, die, "Informationen", "�ber", die, "Tatverd�chtigen", "aufzuschreiben.'"]
	).

output(no, 
	["Okay,", dann, eben, "nicht."]
	).

output(no_hinweis, 
	["Einen", weiteren, "Hinweis", musst, du, dir, erst, "erarbeiten."]
	).

output(no_tipp, 
	["Ich", gebe, dir, jetzt, keinen, weiteren, "Tipp."]
	).

output(no_hilfe, 
	["Ich", habe, gerade, keine, "Lust", dir, zu, "helfen."]
	).

output(falscher_rat1,
	["Ich gebe dir keinen Rat, aber lass uns lieber etwas singen.",
	"\nDie Putzfrau ist tot, die Putzfrau ist tot, sie kann nicht mehr Putzen tralala, tralala, sie kann nicht mehr putzen tralala tralala."]
	).

output(falscher_rat2,
	["Ich gebe dir keinen Rat, aber lass uns lieber etwas singen.",
	"\nDer M�rder war wieder der G�rtner und er plant schon den n�chsten Coup.",
	"\nDer M�rder ist immer der G�rtner und er schl�gt erbarmungslos zu."]
	).

output(no_bitte, 
	["Ohne", "Bitte", geht, hier, "garnichts -" , "Deine", "Eltern", haben, bei, der, "Erziehung", ja, mal, voll, "versagt."]
	).

output(help, 
	["Ich", hoffe, ich, konnte, dir, "helfen."]
	).

output(nothing, 
	[]
	).

output(solved, 
	["Du", hast, den, "Fall", "gel�st,", herzlichen, "Gl�ckwunsch!","\nBeende", das, "Programm", mit, "'Qu�lgeist beenden'."]
	).

output(wrong_suspicion, ["Dieser", "Verdacht", ist, leider, "falsch,", versuche, es, "sp�ter", "nochmal!", "Du", hast, noch, Anzahl, "Verd�chtigungsversuche", "�brig."]) :-
	verdaechtigungszahl(AlteAnzahl),
	Anzahl is 2 - AlteAnzahl.

output(beamter_stay, 
	["Okay,", was, wollen, sie, "wissen?"]
	).

output(geheimunbekannt,
	["Irgendwas ist an dem Geb�lde merkw�rdig, aber du kannst nicht herausfinden was."]
	).

output(geheimbekannt,
	["Hinter dem Geb�lde versteckt sich der versteckte Eingang zum Geheimgang."]
	).


output(folgen,
	["Du folgst Alex ins Wohnzimmer, dort geht er zielstrebig zu dem Gem�lde �ber dem Sofa. \nEr dr�ck einen Knopf im Rahmen, der aussieht wie ein Zierstein, das Bild klappt zur Seite und legt den Eingang zu einem Geheimgang frei. \n'Geh rein, das wird dir bei dem Fall helfen, au�er du gruselst dich zu arg.'"]
	).

output(geheimgewesen,
	["Du entscheidest dich dazu nicht nochmal in den Geheimgang zu gehen."]
	).

output(beamten_vergessen, 
	["Sicher dass du bereits alle Informationen des Beamten im Eingangsbereich erhalten hast?",
	"\n\nBleiben wir doch erstmal noch ein bisschen hier."]
	).