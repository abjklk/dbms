--queries continued
--for each pharma retrieve total no. of distinct drugs sold out

select * from pharmacy;
select * from sells;

select spname,count(*)
from sells,pharmacy
where pharmacy.phar_name=spname
group by phar_name;

--retrieve patient name patient id and total no. of drugs prescribed for all patients to whom more than 1 drug is prescribed.
select pname,pid
from patient
where exists (select pid,count(tradename)
from prescription
group by pid
having count(tradename)>0);


--retrieve name of pharmacy which dont have any contract
select phar_name
from pharmacy
where not exists (select cpharma_name
                  from contract
                  );