-- Scrieți o interogare pentru a afișa data de azi. Etichetați coloana "Astazi".
select sysdate "Astazi" from dual;

-- Pentru fiecare student afișați numele, data de nastere si numărul de luni între data curentă și data nașterii.
select nume, data_nastere, months_between(current_date, data_nastere) from studenti;

-- Afișați ziua din săptămână în care s-a născut fiecare student.
select to_char(data_nastere, 'day') from studenti;

-- Utilizând functia de concatenare, obțineți pentru fiecare student textul 'Elevul <prenume> este in grupa <grupa>'.
select concat(concat('Elevul ', prenume), concat(' este in grupa ', grupa)) from studenti;

-- Afisati valoarea bursei pe 10 caractere, completand valoarea numerica cu caracterul $.
select lpad(nvl(bursa, 0), 10, '$') from studenti;

-- Pentru profesorii al căror nume începe cu B, afișați numele cu prima litera mică si restul mari, precum și lungimea (nr. de caractere a) numelui.
select concat(lower(substr(nume, 1, 1)), upper(substr(nume, 2))), length(trim(nume)) from profesori where nume like 'B%';

-- Pentru fiecare student afișați numele, data de nastere, data la care studentul urmeaza sa isi sarbatoreasca ziua de nastere si prima zi de duminică de dupa.
select nume, data_nastere, add_months(data_nastere, floor(months_between(current_date, data_nastere) / 12 + 1) * 12) from studenti;

-- Ordonați studenții care nu iau bursă în funcție de luna cand au fost născuți; se va afișa doar numele, prenumele și luna corespunzătoare datei de naștere.
select nume, prenume, to_char(data_nastere, 'mm') from studenti order by to_char(data_nastere, 'mm');

-- Pentru fiecare student afișati numele, valoarea bursei si textul: 'premiul 1' pentru valoarea 450, 'premiul 2' pentru valoarea 350, 'premiul 3' pentru valoarea 250 și 'mentiune' pentru cei care nu iau bursa. Pentru cea de a treia coloana dati aliasul "Premiu".
select nume, bursa, decode(nvl(bursa, 0), 450, 'premiul 1', 350, 'premiul 2', 250, 'premiul 3', 'mentiune') "Premiu" from studenti;

-- Afişaţi numele tuturor studenților înlocuind apariţia literei i cu a şi apariţia literei a cu i.
select translate(nume, 'ai', 'ia') from studenti;

-- Afișați pentru fiecare student numele, vârsta acestuia la data curentă sub forma '<x> ani <y> luni și <z> zile' (de ex '19 ani 3 luni și 2 zile') și numărul de zile până își va sărbători (din nou) ziua de naștere.
select nume, concat(floor((current_date - data_nastere) / 365), ' ani ')||concat(floor(months_between(current_date, data_nastere))-floor(months_between(current_date, data_nastere) / 12) * 12, ' luni ')||concat(floor(current_date - add_months(data_nastere, floor(months_between(current_date, data_nastere)))), ' zile') "Varsta", floor(add_months(data_nastere, ceil(floor(current_date - data_nastere) / 365) * 12) - current_date) "Zile pana la aniversare" from studenti;

-- Presupunând că în următoarea lună bursa de 450 RON se mărește cu 10%, cea de 350 RON cu 15% și cea de 250 RON cu 20%, afișați pentru fiecare student numele acestuia, data corespunzătoare primei zile din luna urmatoare și valoarea bursei pe care o va încasa luna următoare. Pentru cei care nu iau bursa, se va afisa valoarea 0.
select nume, trunc(add_months(current_date, 1), 'month'), decode(bursa, 450, bursa * 1.1, 350, bursa * 1.15, 250, bursa * 1.2, 0) from studenti;

-- Pentru studentii bursieri (doar pentru ei) afisati numele studentului si bursa in stelute: fiecare steluta valoreaza 50 RON. In tabel, alineati stelutele la dreapta.
select nume, trim(rpad(' ', floor(bursa / 50) + 1, '*')) from studenti where bursa is not null;