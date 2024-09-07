-- Afişaţi toţi studenţii care au în an cu ei măcar un coleg care să fie mai mare ca ei (vezi data naşterii). 
-- Atentie, un student s1 este mai mare daca are data_nastere mai mica decat celalat student s2.
select * 
	from studenti s1 
	where exists (select 'ceva' 
					from studenti s2 
					where s1.data_nastere > s2.data_nastere and s1.an = s2.an);

-- Afişaţi toţi studenţii care au media mai mare decât media tuturor notelor colegilor din an cu ei. Pentru aceştia afişaţi numele, prenumele şi media lor.
select s1.nume, s1.prenume, avg(n1.valoare) Media 
	from studenti s1 join note n1 on s1.nr_matricol = n1.nr_matricol 
	group by s1.nr_matricol, s1.nume, s1.prenume, s1.an 
	having avg(n1.valoare) > (select avg(n2.valoare) 
								from studenti s2 join note n2 on s2.nr_matricol = n2.nr_matricol 
								where s2.an = s1.an
								);

-- Afişaţi numele, prenumele si grupa celui mai bun student din fiecare grupa în parte.
select s1.nume, s1.prenume, s1.an, s1.grupa 
	from studenti s1 join note n1 on s1.nr_matricol = n1.nr_matricol 
	group by s1.nr_matricol, s1.an, s1.grupa, s1.nume, s1.prenume
	having (s1.an, s1.grupa, avg(n1.valoare)) in (select s2.an, s2.grupa, max(s2.medie) 
													from (select s3.an, s3.grupa, avg(n3.valoare) medie 
															from studenti s3 join note n3 on s3.nr_matricol = n3.nr_matricol 
															group by s3.nr_matricol, s3.an, s3.grupa
															) s2
													group by s2.an, s2.grupa
													);

-- Găsiţi toţi studenţii care au măcar un coleg în acelaşi an care să fi luat aceeaşi nota ca şi el la măcar o materie.
select distinct s1.nume, s1.prenume, s1.grupa, s1.an
	from studenti s1 join note n1 on s1.nr_matricol = n1.nr_matricol
	where (n1.valoare, n1.id_curs) in (select n2.valoare, n2.id_curs 
										from studenti s2 join note n2 on s2.nr_matricol = n2.nr_matricol
										where s1.an = s2.an 
											and s1.nr_matricol != s2.nr_matricol
										);

-- Afișați toți studenții care sunt singuri în grupă (nu au alți colegi în aceeași grupă).
select * 
	from studenti s1 
	where not exists (select 'ceva' 
						from studenti s2 
						where s2.an = s1.an
							and s2.grupa = s1.grupa
							and s2.nr_matricol != s1.nr_matricol
						);

-- Afișați profesorii care au măcar un coleg (profesor) ce are media notelor puse la fel ca și el.
select p.nume, p.prenume, p.medie 
	from (select p1.nume, p1.prenume, avg(n1.valoare) medie 
			from profesori p1 join didactic d1 on p1.id_prof = d1.id_prof join note n1 on d1.id_curs = n1.id_curs 
			group by p1.id_prof, p1.nume, p1.prenume
			) p
	where p.medie in (select avg(n2.valoare) medie 
						from profesori p2 join didactic d2 on p2.id_prof = d2.id_prof join note n2 on d2.id_curs = n2.id_curs
						where p2.nume != p.nume
						group by p2.id_prof, p2.nume, p2.prenume
						);

-- Fara a folosi join, afisati numele si media fiecarui student.
select (select avg(n.valoare) 
			from note n 
			where n.nr_matricol = s.nr_matricol
			) medie, s.nume, s.prenume 
	from studenti s;

-- Afisati cursurile care au cel mai mare numar de credite din fiecare an (pot exista si mai multe pe an). 
-- Rezolvati acest exercitiu si corelat si necorelat (se poate in ambele moduri). Care varianta este mai eficienta?
select c1.titlu_curs 
	from cursuri c1 
	where c1.credite = (select max(c2.credite) 
							from cursuri c2 
							where c2.an = c1.an
							);

select c1.titlu_curs 
	from cursuri c1 join (select max(c.credite) max_credite, c.an 
							from cursuri c 
							group by c.an
							) cmax on c1.an = cmax.an 
	where c1.credite = cmax.max_credite;