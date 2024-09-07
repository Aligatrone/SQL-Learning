-- Cum poate fi utilizată o secvență la inserare?
-- Răspundeți creând o secvență care sa vă ajute sa inserați noi cursuri cu id unic, cu intrari consecutive crescătoare cu pasul 1. 
-- Inserati 3 cursuri noi cu id-ul generat de secventa.
create sequence generator_id_curs
	increment by 1
	start with 30
	maxvalue 32;

insert into cursuri values (generator_id_curs.nextval, 'Probabilistica', 1, 2, 4);
insert into cursuri values (generator_id_curs.nextval, 'Game Design', 3, 2, 5);
insert into cursuri values (generator_id_curs.nextval, 'Grafica', 3, 2, 4);

-- Actualizati valoarea bursei pentru studentii care au măcar o notă de 10. Acestia vor primi ca bursa 500RON.
update studenti s
	set bursa = 500 
	where exists (select 'ceva' 
					from studenti s1 join note n1 on s1.nr_matricol = n1.nr_matricol 
					where s1.nr_matricol = s.nr_matricol and n1.valoare = 10
					);

-- Toti studentii primesc o bursa egala cu 100*media notelor lor. Efectuati modificarile necesare.
update studenti s
	set bursa = (select 100 * avg(n1.valoare) 
					from studenti s1 join note n1 on s1.nr_matricol = n1.nr_matricol 
					where s.nr_matricol = s1.nr_matricol
					);
					
-- Stergeti toti studentii care nu au nici o nota.
delete from studenti s
	where not exists (select 'ceva' 
						from studenti s1 join note n1 on s1.nr_matricol = n1.nr_matricol 
						where s1.nr_matricol = s.nr_matricol
						);

-- Executati comanda ROLLBACK. Creati apoi o tabelă care să stocheze numele, prenumele, bursa si mediile studentilor.
rollback;

create table medii as 
	select s.nume, s.prenume, s.bursa, avg(n.valoare) medie
		from studenti s left join note n on s.nr_matricol = n.nr_matricol 
		group by s.nr_matricol, s.nume, s.prenume, s.bursa;

-- Adăugați constrângerile de tip cheie primară pentru tabelele Studenti, Profesori, Cursuri.
alter table studenti add constraint 
	pk_studenti primary key (nr_matricol);
alter table profesori add constraint 
	pk_profesori primary key (id_prof);
alter table cursuri add constraint 
	pk_cursuri primary key (id_curs);

-- Adăugați constrângerile referențiale pentru tabelele Note și Didactic. 
-- La ștergerea unui profesor din tabela Profesori, în tabela Didactic id-ul profesorului șters va deveni null. 
-- La stergerea unui curs din tabela Cursuri, in tabela Didactic va fi stearsă înregistrarea care referențiază cursul șters. 
-- Scrieți comenzi de ștergere înregistrări pentru tabelele referențiate și studiați comportamentul.
alter table didactic add constraint
     fk_didactic_profesori foreign key (id_prof) 
           references profesori(id_prof) on delete set null;
		   
alter table didactic add constraint
     fk_didactic_cursuri foreign key (id_curs) 
           references cursuri(id_curs) on delete cascade;
		   
alter table note add constraint
     fk_note_studenti foreign key (nr_matricol) 
           references studenti(nr_matricol) on delete cascade;
		   
alter table note add constraint
     fk_note_cursuri foreign key (id_curs) 
           references cursuri(id_curs) on delete set null;

-- Impuneți constrângerea ca un student să nu aibă mai mult de o notă la un curs.
alter table note add constraint 
	nota_unica unique(nr_matricol, id_curs);

-- Impuneți constrângerea ca valoarea notei să fie cuprinsă între 1 și 10.
alter table note add constraint
	interval_nota check(valoare between 1 and 10);
	
-- Asigurati-va că începeți o nouă tranzacție.
select 1 from dual;

-- Ștergeți toate înregistrările din tabela Profesori.
delete from profesori;

-- Inserați un profesor.
insert into profesori values ('p1', 'Moruz', 'Alexandru', 'Lect');

-- Marcați starea curentă ca 's1'.
savepoint s1;

-- Schimbați numele profesorului inserat.
update profesori 
	set nume = 'Frasinaru'
	where nume = 'Moruz';

-- Vizualizați datele.
select * from profesori;

-- Reveniți la starea s1.
rollback to savepoint s1;

-- Vizualizați datele.
select * from profesori;

-- Reveniția la starea de dinaintea ștergerii.
rollback;