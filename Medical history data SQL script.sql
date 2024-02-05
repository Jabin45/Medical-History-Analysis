use project_medical_data_history;
select*from admissions;
select*from doctors;
select*from patients;
select*from province_names;

# show the first name,lastname ,gender of patients who's gender is 'm'?
select first_name,last_name,gender from patients where gender = 'M';

#show the first and last name of the patients who does not have allergies?
select first_name,last_name from patients where allergies is null;
 
 #show the first name of patients that start with the letter 'c'?
 select first_name from patients where first_name like 'c%';
 
 #show the first and last name of patients that weights within the range of 100 to 120?
 select first_name,last_name,weight from patients where weight between 100 and 200;
 
 #update the patients table for the allergies column if the patients allergies null then replace  it with 'NKA'?
 update patients set allergies = 'NKA' where allergies is null;
 
 #Show first name and last name concatenated into one column to show their full name.
 select concat(first_name,' ',last_name) as full_name from patients;
 
 #show the first name , last name and the full provience name of each patients
 select first_name ,last_name, province_name from patients join province_names on patients.province_id = province_names.province_id;
 
 # show how many patients have birth_DATE with 2010 as the birth year
 select count(*) from patients where year(birth_date) = 2010;
 
 # show the fist name ,last name and height of the greatest height
 select first_name ,last_name,height from patients order by height desc limit 1;
 
 #show the all columns for patients who have one of the following patientsId 1,45,534,879,1000
 select * from patients where patient_id in (1,45,534,879,1000);
 
 # show the total number of admissions.
 select count(diagnosis) from admissions;

 #show the all column  from admission where the patient admission date and discharged date on a same day
 select * from admissions where admission_date = discharge_date;
 
 #show total number of admission  for patient id 579
 select count(diagnosis) from admissions where patient_id = 579;
 
 #Based on the cities that our patients live in, show unique cities that are in province_id 'NS'?
 select distinct(city),province_id from patients where province_id = 'NS' group by city;
 
 #Write a query to find the first_name, last name and birth date of patients who have height more than 160 and weight more than 70
select first_name,last_name,birth_date from patients where height > 160 and weight > 70;
 
 # Show unique birth years from patients and order them by ascending.
  select birth_date,count(*) from patients group by birth_date having count(*)=1 order by birth_date asc ;
 
 #Show unique first names from the patients table which only occurs once in the list.
select first_name,count(*) from patients group by first_name having count(*)=1;
 
 #Show patient_id and first_name from patients where their first_name start and ends with 's' and is at least 6 characters long.
select patient_id, first_name from patients where first_name like 's%s' and length(first_name) >=6;

 #Show patient_id, first_name, last_name from patients whos diagnosis is 'Dementia'.   Primary diagnosis is stored in the admissions table.
 select patients.patient_id,first_name,last_name,diagnosis from patients join admissions on patients.patient_id = admissions.patient_id where diagnosis = 'Dementia';
 
 #Display every patient's first_name. Order the list by the length of each name and then by alphbetically.
 select distinct(first_name) from patients order by length(first_name),first_name;

 #Show the total amount of male patients and the total amount of female patients in the patients table. Display the two results in the same row.
 select sum(case when gender = 'M' then 1 else 0 end )as Male, sum(case when gender = 'F' then 1 else 0 end) as Female from patients ;
 
 #Show patient_id, diagnosis from admissions. Find patients admitted multiple times for the same diagnosis.
 select patient_id, diagnosis from admissions group by 1,2 having count(*)>1  ;
 
# Show the city and the total number of patients in the city. Order from most to least patients and then by city name ascending.
select city,count(distinct(patient_id)) as Patient_count from patients group by city order by patient_count desc;
select city,count(distinct(patient_id)) as Patient_count from patients group by city order by city asc;

# Show first name, last name and role of every person that is either patient or doctor. The roles are either Patient or Doctor 
select first_name,last_name,'patients' as role from patients union select first_name,last_name,'doctors' as role from doctors;

# Show all allergies ordered by popularity. Remove NULL values from query.
select allergies,count(*) from patients where allergies is not null group by allergies order by count(*) desc;

# Show all patients first_name, last_name, and birth_date who were born in the 1970s decade. Sort the list starting from the earliest birth_date.
select concat_ws(' ',first_name, last_name) full_name,birth_date from patients where year(birth_date) = 1970 order by birth_date asc;

# We want to display each patients full name in a single column. Their last_name in all upper letters must appear first, then first_name in all lower case letters. 
#Separate the last_name and first_name with a comma. Order the list by the first_name in decending order EX: SMITH,jane

select concat_ws(',',upper(last_name),first_name) as full_name from patients;

# Show the province_id(s), sum of height; where the total sum of its patients height is greater than or equal to 7,000.
select province_id, sum (height) from patients group by province_id having sum (height) >=7000 ;

# Show the difference between the largest weight and smallest weight for patients with the last name Maroni;
select last_name, (max(height)-min(height)) as Diff from patients where last_name = 'maroni' ;

# Show all of the days of the month (1-31) and how many admission_dates occurred on that day. Sort by the day with most admissions to least admissions.
select day(admission_date) ,count(diagnosis) as admissions from admissions group by day(admission_date) order by admissions desc ;

# Show all of the patients grouped into weight groups. Show the total amount of patients in each weight group. Order the list by the weight group decending.
# e.g. if they weight 100 to 109 they are placed in the 100 weight group, 110-119 = 110 weight group, etc.

SELECT
    CASE
        WHEN weight >= 0 AND weight < 50 THEN '0-49'
        WHEN weight >= 50 AND weight < 80 THEN '50-79'
        WHEN weight >= 80 AND weight < 110 THEN '80-109'
        WHEN weight >= 110 AND weight < 130 THEN '110-129'
        WHEN weight >= 130 AND weight < 150 THEN '130-149'
        ELSE 'Other'
    END AS Weight_group,
    COUNT(DISTINCT patient_id) AS patients
FROM patients
GROUP BY Weight_group
ORDER BY Weight_group DESC;


# Show patient_id, weight, height, is Obese from the patients table. Display isObese as a boolean 0 or 1. 
#Obese is defined as weight(kg)/(height(m). Weight is in units kg. Height is inunits cm.

select patient_id, weight, height, case when (weight/height)*100 >=30 then 1 else 0 end as isobese from patients;

# Show patient_id, first_name, last_name, and attending doctor specialty. Show only the
#patients who has a diagnosis as Epilepsy and the doctor first name is Lisa. Check patients, admissions, and doctors tables for required information.

select patients.patient_id, patients.first_name, patients.last_name,specialty,diagnosis,doctors.first_name as doctor from patients join admissions on patients.patient_id = admissions.patient_id join doctors on admissions.attending_doctor_id = doctors.doctor_id where diagnosis = 'epilepsy' and doctors.first_name = 'lisa';

# All patients who have gone through admissions, can see their medical documents on our site. Those patients are given a temporary password after their first admission. Show the
# patient_id and temp_password.The password must be the following, in order:
# patient_id
# the numerical length of patient&#39;s last_name
# year of patient&#39;s birth_date

select patient_id,concat(patient_id, length(last_name),year(birth_date)) as password from patients;
