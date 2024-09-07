-- Afișați numărul de studenți din fiecare an.
select count(*), an 
	from studenti 
	group by an;

-- Afișați numărul de studenți din fiecare grupă a fiecărui an de studiu. Ordonați crescător după anul de studiu și după grupă.
select count(*), an, grupa 
	from studenti 
	group by an, grupa 
	order by an, grupa;

-- Afișați numărul de studenți din fiecare grupă a fiecărui an de studiu și specificați câți dintre aceștia sunt bursieri.
select count(*), an, grupa, count(bursa) 
	from studenti 
	group by an, grupa;

-- Afișați suma totală cheltuită de facultate pentru acordarea burselor.
select sum(bursa) 
	from studenti;

-- Afișați valoarea bursei/cap de student (se consideră că studentii care nu sunt bursieri primesc 0 RON);
-- altfel spus: cât se cheltuiește în medie pentru un student?
select avg(nvl(bursa, 0)) 
	from studenti;

-- Afișați numărul de note de fiecare fel (câte note de 10, câte de 9,etc.). Ordonați descrescător după valoarea notei.
select valoare, count(*) 
	from note 
	group by valoare 
	order by valoare desc;

-- Afișați numărul de note pus în fiecare zi a săptămânii. Ordonați descrescător după numărul de note.
select count(*), to_char(data_notare, 'DAY') 
	from note 
	group by to_char(data_notare, 'DAY') 
	order by count(*) desc;

-- Afișați numărul de note pus în fiecare zi a săptămânii. Ordonați crescător după ziua saptamanii: Sunday, Monday, etc.
select count(*), to_char(data_notare, 'DAY') 
	from note 
	group by to_char(data_notare, 'DAY') 
	order by to_char(data_notare, 'DAY');

-- Afișați pentru fiecare elev care are măcar o notă, numele și media notelor sale. Ordonați descrescător după valoarea mediei.
select s.nume, s.prenume, avg(n.valoare) 
	from studenti s join note n on s.nr_matricol = n.nr_matricol 
	group by s.nr_matricol, nume, prenume 
	order by avg(n.valoare) desc;

-- Modificați interogarea anterioară pentru a afișa și elevii fără nici o notă. Media acestora va fi null.
select s.nume, s.prenume, avg(n.valoare) 
	from studenti s left join note n on s.nr_matricol = n.nr_matricol 
	group by s.nr_matricol, nume, prenume 
	order by avg(n.valoare) desc;

-- Modificați interogarea anterioară pentru a afișa pentru elevii fără nici o notă media 0.
select s.nume, s.prenume, nvl(avg(n.valoare), 0) 
	from studenti s left join note n on s.nr_matricol = n.nr_matricol 
	group by s.nr_matricol, nume, prenume 
	order by avg(n.valoare) desc;

-- Modificati interogarea de mai sus pentru a afisa doar studentii cu media mai mare ca 8.
select s.nume, s.prenume, nvl(avg(n.valoare), 0) 
	from studenti s left join note n on s.nr_matricol = n.nr_matricol 
	group by s.nr_matricol, nume, prenume 
	having avg(n.valoare) > 8 
	order by avg(n.valoare) desc;

-- Afișați numele, cea mai mare notă, cea mai mică notă și media doar pentru acei studenti care au primit doar note mai mari sau egale cu 7
-- (au cea mai mică notă mai mare sau egală cu 7).
select s.nume, s.prenume, max(n.valoare), min(n.valoare), avg(n.valoare) 
	from studenti s join note n on s.nr_matricol = n.nr_matricol 
	group by s.nr_matricol, s.nume, s.prenume 
	having min(n.valoare) >=7;

-- Afișați numele și mediile studenților care au cel puțin un număr de 3 note puse în catalog.
select s.nume, s.prenume, avg(n.valoare) 
	from studenti s join note n on s.nr_matricol = n.nr_matricol 
	group by s.nr_matricol, s.nume, s.prenume 
	having count(n.valoare) >= 3;

-- Afișați numele și mediile studenților care au cel puțin un număr de 3 note diferite puse în catalog.
select s.nume, s.prenume, avg(n.valoare) 
	from studenti s join note n on s.nr_matricol = n.nr_matricol 
	group by s.nr_matricol, s.nume, s.prenume 
	having count(distinct n.valoare) >= 3;

-- Afișați numele și mediile studenților din grupa A2 anul 3.
select s.nume, s.prenume, avg(n.valoare) 
	from studenti s join note n on s.nr_matricol = n.nr_matricol 
	where s.grupa like 'A2' and s.an = 3 
	group by s.nr_matricol, s.nume, s.prenume;

-- Afișați cea mai mare medie obținută de vreun student. Puteți să afișați și numărul matricol al studentului care are acea medie maximală ? Argumentați.
select max(avg(n.valoare)) 
	from studenti s join note n on s.nr_matricol = n.nr_matricol 
	group by s.nr_matricol, s.nume, s.prenume;

-- Un profesor este iubit de studenti daca pune note mai mari (adica media notelor sale este mai mare).
-- Afisati toti profesorii in ordinea preferintelor studentilor impreuna cu mediile notelor puse de ei scrise cu doua zecimale.
select p.nume, trunc(avg(n.valoare), 2) 
	from profesori p join didactic d on p.id_prof = d.id_prof join note n on d.id_curs = n.id_curs 
	group by p.id_prof, p.nume, p.prenume 
	order by avg(n.valoare) desc;

-- Afisati numarul de restantieri generati de FIECARE profesor (tip: 1 cu 2 restantieri, 4 cu 1 restantier, 11 cu 0 restantieri)
select count(*)||' cu '||val||decode(val, 1, ' restantier', ' restantieri') 
	from (select p.id_prof, count(n.valoare) val 
			from profesori p left join didactic d on p.id_prof = d.id_prof left join (select id_curs, decode(valoare, 4, '4', '') valoare 
																						from note
																						) n on d.id_curs = n.id_curs 
			group by p.id_prof
			) 
	group by val;