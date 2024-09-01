-- Scrieți o interogare pentru a afișa numele, prenumele, anul de studiu si data nașterii pentru toți studenții.
select nume, prenume, an, data_nastere from studenti;

-- Scrieți și executați o interogare pentru a afișa în mod unic valorile burselor.
select distinct bursa from studenti;

-- Afișați numele concatenat cu prenumele urmat de virgulă și anul de studiu. Ordonați crescător după anul de studiu. Denumiți coloana “Studenți pe ani de studiu”.
select nume||prenume||','||an "Studenti pe ani de studiu" from studenti ORDER BY an;

-- Afișați numele, prenumele și data de naștere a studenților născuți între 1 ianuarie 1995 si 10 iunie 1997. Ordonați descendent după anul de studiu.
select nume, prenume, data_nastere from studenti where data_nastere between '01/01/1995' and '10/06/1997' order by an desc;

-- Afișați numele și prenumele precum și anii de studiu pentru toți studenții născuți în 1995.
select nume, prenume, an from studenti where data_nastere like '%1995';

-- Afișați studenții (toate informațiile pentru aceștia) care nu iau bursă.
select * from studenti where bursa is null;

-- Afișați studenții (nume și prenume) care iau bursă și sunt în anii 2 și 3 de studiu. Ordonați alfabetic ascendent după nume și descendent după prenume.
select nume, prenume from studenti where bursa is not null and an in (2, 3) order by nume, prenume desc;

-- Afișați studenții care iau bursă, precum și valoarea bursei dacă aceasta ar fi mărită cu 15%.
select nume, prenume, bursa * 1.5 from studenti where bursa is not null;

-- Afișați studenții al căror nume începe cu litera P și sunt în anul 1 de studiu.
select * from studenti where nume like 'P%' and an = 1;

-- Afișați toate informațiile despre studenții care au două apariții ale literei “a” în prenume.
select * from studenti where nume like '%a%a%';

-- Afișați toate informațiile despre studenții al căror prenume este “Alexandru”, “Ioana” sau “Marius”.
select * from studenti where prenume in ('Alexandru', 'Ioana', 'Marius');

-- Afișați studenții bursieri din semianul A.
select * from studenti where bursa is not null and grupa like 'A_';

-- Afișați toate informatiile despre studentii ale caror prenume contine EXACT o singura data litera 'a' (se ignora litera 'A' de la inceputul unor prenume).
select * from studenti where prenume like '%a%' and prenume not like '%a%a%';

-- Afişaţi numele şi prenumele profesorilor a căror prenume se termină cu litera "n" (întrebare capcană).
select nume, prenume from profesori where prenume like '%n' or prenume like '%n %';