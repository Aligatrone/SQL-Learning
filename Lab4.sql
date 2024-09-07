-- Afişaţi studenţii şi notele pe care le-au luat si profesorii care le-au pus acele note.
select s.nume, n.valoare, p.nume 
	from studenti s join note n on n.nr_matricol = s.nr_matricol join didactic d on d.id_curs = n.id_curs join profesori p on p.id_prof = d.id_prof;

-- Afisati studenţii care au luat nota 10 la materia 'BD'. Singurele valori pe care aveţi voie să le hardcodaţi în interogare sunt valoarea notei (10) şi numele cursului ('BD').
select s.nume 
	from studenti s join note n on s.nr_matricol = n.nr_matricol join cursuri c on c.id_curs = n.id_curs 
	where n.valoare = 10 and c.titlu_curs like 'BD';

-- Afisaţi profesorii (numele şi prenumele) impreuna cu cursurile pe care fiecare le ţine.
select p.nume, p.prenume, c.titlu_curs 
	from profesori p join didactic d on p.id_prof = d.id_prof join cursuri c on c.id_curs = d.id_curs;

-- Modificaţi interogarea de la punctul 3 pentru a fi afişaţi şi acei profesori care nu au încă alocat un curs.
select p.nume, p.prenume, c.titlu_curs 
	from profesori p left join didactic d on p.id_prof = d.id_prof left join cursuri c on c.id_curs = d.id_curs;

-- Modificaţi interogarea de la punctul 3 pentru a fi afişate acele cursuri ce nu au alocate încă un profesor.
select p.nume, p.prenume, c.titlu_curs 
	from profesori p join didactic d on p.id_prof = d.id_prof right join cursuri c on c.id_curs = d.id_curs;

-- Modificaţi interogarea de la punctul 3 astfel încât să fie afişaţi atat profesorii care nu au nici un curs alocat cât şi cursurile care nu sunt încă predate de nici un profesor.
select p.nume, p.prenume, c.titlu_curs 
	from profesori p full join didactic d on p.id_prof = d.id_prof full join cursuri c on c.id_curs = d.id_curs;

-- In tabela studenti există studenţi care s-au nascut în aceeasi zi a săptămânii. De exemplu, Cobzaru George şi Pintescu Andrei s-au născut amândoi într-o zi de marti. 
-- Construiti o listă cu studentii care s-au născut in aceeaşi zi grupându-i doi câte doi în ordine alfabetică a numelor 
-- (de exemplu in rezultat va apare combinatia Cobzaru-Pintescu dar nu va apare şi Pintescu-Cobzaru).
-- Lista va trebui să conţină doar numele de familie a celor doi împreună cu ziua în care cei doi s-au născut.
-- Evident, dacă există şi alţi studenti care s-au născut marti, vor apare si ei in combinatie cu cei doi amintiţi mai sus.
-- Lista va fi ordonată în funcţie de ziua săptămânii în care s-au născut si, în cazul în care sunt mai mult de trei studenţi născuţi în aceeaşi zi, rezultatele vor fi ordonate şi după numele primei persoane din listă.
select s1.nume||'-'||s2.nume, to_char(s1.data_nastere, 'day') 
	from studenti s1 join studenti s2 on s1.nume < s2.nume and to_char(s1.data_nastere, 'day') = to_char(s2.data_nastere, 'day') 
	order by s1.data_nastere - next_day(s1.data_nastere, 'luni'), s1.nume, s2.nume;

-- Sa se afiseze, pentru fiecare student, numele colegilor care au luat nota mai mare ca ei la fiecare dintre cursuri. 
-- Formulati rezultatele ca propozitii (de forma "Popescu Gigel a luat nota mai mare ca Vasilescu Ionel la materia BD."). 
-- Dati un nume corespunzator coloanei [pont: interogarea trebuie să returneze 118 rânduri].
select s1.nume||' '||s1.prenume||' a luat nota mai mare ca '||s2.nume||' '||s2.prenume||' la materia '||c1.titlu_curs 
	from studenti s1 join note n1 on s1.nr_matricol = n1.nr_matricol join cursuri c1 on n1.id_curs = c1.id_curs, studenti s2 join note n2 on s2.nr_matricol = n2.nr_matricol join cursuri c2 on n2.id_curs = c2.id_curs 
	where n1.valoare > n2.valoare and n1.id_curs = n2.id_curs;

-- Afisati studentii doi cate doi impreuna cu diferenta de varsta dintre ei. 
-- Sortati in ordine crescatoare in functie de aceste diferente. Aveti grija sa nu comparati un student cu el insusi.
select s1.nume, s2.nume, s1.data_nastere - s2.data_nastere 
	from studenti s1 join studenti s2 on s1.nr_matricol != s2.nr_matricol 
	order by s1.data_nastere - s2.data_nastere;

-- Afisati posibilele prietenii dintre studenti si profesori. Un profesor si un student se pot imprieteni daca numele lor de familie are acelasi numar de litere.
select s.nume, p.nume 
	from studenti s join profesori p on length(s.nume) = length(trim(p.nume));

-- Afisati denumirile cursurilor la care s-au pus note cel mult egale cu 8 (<=8).
select distinct c.titlu_curs 
	from cursuri c join note n on c.id_curs = n.id_curs 
minus 
select distinct c.titlu_curs 
	from cursuri c join note n on c.id_curs = n.id_curs 
	where n.valoare > 8;

-- Afisati numele studentilor care au toate notele mai mari ca 7 sau egale cu 7.
select s.nume, s.prenume 
	from studenti s 
minus 
select s.nume, s.prenume 
	from studenti s join note n on s.nr_matricol = n.nr_matricol 
	where n.valoare < 7;

-- Sa se afiseze studentii care au luat nota 7 sau nota 10 la OOP intr-o zi de marti.
select s.nume, s.prenume, to_char(n.data_notare, 'day') 
	from studenti s join note n on s.nr_matricol = n.nr_matricol join cursuri c on n.id_curs = c.id_curs 
	where n.valoare in (7, 10) and c.titlu_curs like 'OOP' and to_char(n.data_notare, 'day') = 'marti';

-- O sesiune este identificata prin luna si anul in care a fost tinuta.
-- Scrieti numele si prenumele studentilor ce au promovat o anumita materie, cu notele luate de acestia si sesiunea in care a fost promovata materia.
-- Formatul ce identifica sesiunea este "LUNA, AN", fara alte spatii suplimentare (De ex. "JUNE, 2015" sau "FEBRUARY, 2014").
-- In cazul in care luna in care s-a tinut sesiunea a avut mai putin de 30 de zile afisati simbolul "+" pe o coloana suplimentara,
-- indicand faptul ca acea sesiune a fost mai grea (avand mai putine zile), in caz contrar (cand luna are mai mult de 29 de zile) valoarea coloanei va fi null.
select s.nume, s.prenume, n.valoare, trim(to_char(n.data_notare, 'MONTH'))||','||to_char(data_notare, 'yyyy') "Sesiunea", decode(round(data_notare, 'MONTH') - trunc(data_notare, 'MONTH') - 30, 0, '+', '') 
	from studenti s join note n on s.nr_matricol = n.nr_matricol 
	where n.valoare > 5;