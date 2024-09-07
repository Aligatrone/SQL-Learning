-- Afișați numele studenților care iau cea mai mare bursa acordată.
select nume, prenume from studenti where bursa = (select max(bursa) from studenti);

-- Afișați numele studenților care sunt colegi cu un student pe nume Arhire (coleg = același an si aceeași grupă).
select nume, prenume from studenti where an in (select an from studenti where nume like 'Arhire') and grupa in (select grupa from studenti where nume like 'Arhire') and nr_matricol not in (select nr_matricol from studenti where nume like 'Arhire');

-- Pentru fiecare grupă afișați numele studenților care au obținut cea mai mică notă la nivelul grupei.
select min(val), grupa, an from (select avg(valoare) as val, s.grupa, s.an from studenti s join note n on s.nr_matricol = n.nr_matricol group by s.nr_matricol, s.grupa, s.an) group by grupa, an;

-- Identificați studenții a căror medie este mai mare decât media tuturor notelor din baza de date. Afișați numele și media acestora.
select s.nume, s.prenume, avg(n.valoare) from studenti s join note n on s.nr_matricol = n.nr_matricol group by s.nr_matricol, s.nume, s.prenume having avg(n.valoare) > (select avg(valoare) from note);

-- Afișați numele și media primilor trei studenți ordonați descrescător după medie.
select * from (select s.nume, s.prenume, avg(n.valoare) from studenti s join note n on s.nr_matricol = n.nr_matricol group by s.nr_matricol, s.nume, s.prenume order by avg(n.valoare) desc) where rownum < 4;

-- Afișați numele studentului (studenților) cu cea mai mare medie precum și valoarea mediei (atenție: limitarea numărului de linii poate elimina studenții de pe poziții egale; găsiți altă soluție).
select s.nume, s.prenume, avg(n.valoare) from studenti s join note n on s.nr_matricol = n.nr_matricol group by s.nr_matricol, s.nume, s.prenume having avg(n.valoare) = ( select max(val) from (select avg(valoare) as val from note group by nr_matricol));

-- Afişaţi numele şi prenumele tuturor studenţilor care au luat aceeaşi nota ca şi Ciprian Ciobotariu la materia Logică. 
-- Excludeţi-l pe acesta din listă. (Se știe în mod cert că există un singur Ciprian Ciobotariu și că acesta are o singură notă la logică)
select s.nume, s.prenume from studenti s join note n on s.nr_matricol = n.nr_matricol join cursuri c on n.id_curs = c.id_curs where c.titlu_curs like 'Logica' and s.nume not like 'Ciobotariu' and s.prenume not like 'Ciprian' and n.valoare = (select n.valoare from studenti s join note n on s.nr_matricol = n.nr_matricol join cursuri c on n.id_curs = c.id_curs where s.nume like 'Ciobotariu' and s.prenume like 'Ciprian' and c.titlu_curs like 'Logica');

-- Din tabela studenti, afisati al cincilea prenume in ordine alfabetica.
select * from (select * from (select prenume from studenti order by prenume) where rownum < 6 order by prenume desc) where rownum < 2;

-- Punctajul unui student se calculeaza ca fiind o suma intre produsul dintre notele luate si creditele la materiile la care au fost luate notele.
-- Afisati toate informatiile studentului care este pe locul 3 in acest top.
select * from studenti where nr_matricol = (select nr_matricol from (select * from (select s.nr_matricol, sum(punctaj) medie from studenti s join (select n.nr_matricol, n.valoare * credite punctaj from note n join cursuri c on n.id_curs = c.id_curs) n on s.nr_matricol = n.nr_matricol group by s.nr_matricol order by sum(punctaj) desc) where rownum < 4 order by medie) where rownum < 2);

-- Afișați studenții care au notă maximă la o materie precum și nota și materia respectivă.
select s.nume, s.prenume, n.valoare, c.titlu_curs from studenti s join note n on s.nr_matricol = n.nr_matricol join (select id_curs, max(valoare) max_val from note group by id_curs) nmax on n.id_curs = nmax.id_curs join cursuri c on n.id_curs = c.id_curs where n.valoare = nmax.max_val;