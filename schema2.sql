drop database if exists pisa;
create database pisa;
use pisa;

drop table if exists school;
create table school (
	SCHOOLID nvarchar(7),
	CNT nvarchar(3), 
	SC01Q01 int,
	SC03Q01 int,
	SC05Q01 int,
	SC11Q01 int,
	SC11Q02 int,
	SC11Q03 int,
	SC13Q01 int,
	SC13Q02 int,
	SC13Q03 int,
	SC15Q01 int,
	SC15Q02 int,
	SC15Q03 int,
	SC15Q04 int,
	SC19Q01 int,
    primary key (CNT, SCHOOLID)	
);

drop table if exists parents;
create table parents (  
	CNT nvarchar(3),
	STIDSTD nvarchar(5),
	SCHOOLID nvarchar(7),
	PA02Q01 int,
	PA02Q02 int,
	PA03Q01 int,
	PA03Q02 int,
	PA03Q03 int,
	PA03Q04 int,
	PA05Q01 int,
	PA05Q02 int,
	PA05Q03 int,
	PA05Q04 int,
	PA07Q01 int,
    primary key (CNT, STIDSTD, SCHOOLID)
);

drop table if exists student;
create table student (
	id int,
	STIDSTD nvarchar(5),
    CNT nvarchar(3),
	SCHOOLID nvarchar(7),
	ST01Q01 int,
	GRADE int,
	ST04Q01 int,
	ST08Q01 int,
	ST09Q01 int,
	ST115Q01 int,
	ST11Q01 int,
	ST11Q02 int,
	ST11Q03 int,
	ST11Q04 int,
	ST11Q05 int,
	ST13Q01 int,
	ST14Q01 int,
	ST14Q02 int,
	ST14Q03 int,
	ST14Q04 int,
	ST15Q01 int,
	ST17Q01 int,
	ST18Q01 int,
	ST18Q02 int,
	ST18Q03 int,
	ST18Q04 int,
	ST19Q01 int,
	ST20Q01 int,
	ST20Q02 int,
	ST20Q03 int,
	ST25Q01 int,
	ST26Q01 int,
	ST26Q02 int,
	ST26Q03 int,
	ST26Q04 int,
	ST26Q05 int,
	ST26Q06 int,
	ST26Q07 int,
	ST26Q08 int,
	ST26Q09 int,
	ST26Q10 int,
	ST26Q11 int,
	ST26Q12 int,
	ST26Q13 int,
	ST26Q14 int,
	ST26Q15 int,
	ST26Q16 int,
	ST26Q17 int,
	ST27Q01 int,
	ST27Q02 int,
	ST27Q03 int,
	ST27Q04 int,
	ST27Q05 int,
	ST28Q01 int,
	ST29Q01 int,
	ST29Q02 int,
	ST29Q03 int,
	ST29Q04 int,
	ST29Q05 int,
	ST29Q06 int,
	ST29Q07 int,
	ST29Q08 int,
	ST46Q01 int,
	ST46Q02 int,
	ST46Q03 int,
	ST46Q04 int,
	ST46Q05 int,
	ST46Q06 int,
	ST46Q07 int,
	ST46Q08 int,
	ST46Q09 int,
	ST87Q01 int,
	ST87Q02 int,
	ST87Q03 int,
	ST87Q04 int,
	ST87Q05 int,
	ST87Q06 int,
	ST87Q07 int,
	ST87Q08 int,
	ST87Q09 int,
	ST88Q01 int,
	ST88Q02 int,
	ST88Q03 int,
	ST88Q04 int,
	ST89Q02 int,
	ST89Q03 int,
	ST89Q04 int,
	ST89Q05 int,
	ST91Q01 int,
	ST91Q02 int,
	ST91Q03 int,
	ST91Q04 int,
	ST91Q05 int,
	ST91Q06 int,
	INDEX (CNT, SCHOOLID),
    INDEX (CNT, STIDSTD, SCHOOLID)
);

drop table if exists countries;
create table countries(
	Country_Name nvarchar(50),
	Code2 nvarchar(2),
	CNT nvarchar(3),
	Code3 nvarchar(3),
	Happy_index	double,
	Income_Group nvarchar(2),	
	Exp_Educ_pct double,
	GDP_pc double,
	GINI double,
	Gov_expen_per_student_pct double,
	House_final_cons_exp_pc	double,
	Labor_force_tertiary_educ_pct double,
	index (Code2)
);


LOAD DATA LOCAL INFILE '/home/ubuntu/school_data.csv' 
INTO TABLE school 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE '/home/ubuntu/parents_data.csv' 
INTO TABLE parents
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE '/home/ubuntu/Pisa_dataset 10%.csv' 
INTO TABLE student
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE '/home/ubuntu/country.csv' 
INTO TABLE countries
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

drop view if exists view_analysis;
create view view_analysis as
select countries.Code2, student.CNT as country, countries.Income_Group, 
countries.Happy_index, countries.Exp_Educ_pct, countries.GDP_pc, countries.GINI, countries.Gov_expen_per_student_pct, 
countries.House_final_cons_exp_pc, countries.Labor_force_tertiary_educ_pct,
	concat(student.StIDStd, student.CNT) as student,
	student.ST01Q01 as InternationalGrade,
	2-ST04Q01 as Gender,
	ST08Q01+8-2*ST09Q01+4-ST115Q01+36-ST46Q01-ST46Q02-ST46Q03-ST46Q04-ST46Q05-ST46Q06-ST46Q07-ST46Q08-ST46Q09 as PersonalMotivation,
	2-ST26Q01 as PossessionsStudyDesk,
	2-ST26Q02 as PossessionsStudyOwnRoom,
	2-ST26Q03 as PossessionsStudyStudyPlace,
	2-ST26Q04 as PossessionsStudyComputer,
	2-ST26Q05 as PossessionsStudySoftware,
	2-ST26Q06 as PossessionsStudyInternet,
	2-ST26Q10 as PossessionsStudyTextbooks,
	2-ST26Q11 as PossessionsStudyTechnicalBooks,
	ST28Q01 as PossessionsNonStudyLiterature,
	2-ST26Q07 as PossessionsNonStudyPoetry,
	2-ST26Q08 as PossessionsNonStudyArt,
	2-ST26Q09 as PossessionsNonStudyNoOfBooks,
	2-ST26Q12 as PossessionsNonStudyDictionary,
	ST27Q01-1 as PossessionsWealthCellPhones,
	ST27Q02-1 as PossessionsWealthTVs,
	ST27Q03-1 as PossessionsWealthComputers,
	ST27Q04-1 as PossessionsWealthCars,
	ST27Q05-1 as PossessionsWealthBathrooms,
	2-ST26Q14 as PossessionsWealthDVD,
	4-ST29Q01 as Enjoyment1,
	4-ST29Q03 as Enjoyment2,
	4-ST29Q04 as Enjoyment3,
	4-ST29Q06 as Enjoyment4,
	4-ST29Q02 as MotivatingFactors1,
	4-ST29Q05 as MotivatingFactors2,
	4-ST29Q07 as MotivatingFactors3,
	4-ST29Q08 as MotivatingFactors4,
	2-ST11Q01 as AtHomeMother,
	2-ST11Q02 as AtHomeFather,
	2-ST11Q03 as AtHomeBrothers,
	2-ST11Q04 as AtHomeSisters,
	2-ST11Q01 as AtHomeGrandparents,
	case when ST15Q01<=2 then 1 else 0 end as MotherEmployed,
	case when ST19Q01<=2 then 1 else 0 end as FatherEmployed,
	5-ST13Q01+8-ST14Q01-ST14Q02-ST14Q03-ST14Q04 as MotherEducation,
	5-ST17Q01+8-ST18Q01-ST18Q02-ST18Q03-ST18Q04 as FatherEducation,
	2-ST20Q01 as CountryOfBirthSelf,
	2-ST20Q02 as CountryOfBirthMother,
	2-ST20Q03 as CountryOfBirthFather,
	2-ST25Q01 as LanguageAtHome,
	ST87Q01-1 as SenseOfBelonging1,
	ST87Q04-1 as SenseOfBelonging2,
	ST87Q06-1 as SenseOfBelonging3,
	4-ST87Q02 as SenseOfBelonging4,
	4-ST87Q03 as SenseOfBelonging5,
	4-ST87Q05 as SenseOfBelonging6,
	4-ST87Q07 as SenseOfBelonging7,
	4-ST87Q08 as SenseOfBelonging8,
	4-ST87Q09 as SenseOfBelonging9,
	ST88Q01-1 as AttitudeToSchool1,
	ST88Q02-1 as AttitudeToSchool2,
	4-ST88Q03 as AttitudeToSchool3,
	4-ST88Q04 as AttitudeToSchool4,
	4-ST89Q02 as AttitudeToSchool5,
	4-ST89Q03 as AttitudeToSchool6,
	4-ST89Q04 as AttitudeToSchool7,
	4-ST89Q05 as AttitudeToSchool8,
	4-ST91Q01 as PerceivedControl1,
	4-ST91Q02 as PerceivedControl2,
	4-ST91Q05 as PerceivedControl3,
	ST91Q03-1 as PerceivedControl4,
	ST91Q04-1 as PerceivedControl5,
	ST91Q06-1 as PerceivedControl6,
    SC03Q01 as AreaSize,
	school.SC05Q01 as ClassSize,
	2-school.SC19Q01 as AchievementsPubPost
from student LEFT JOIN countries on countries.CNT=student.CNT LEFT JOIN school on (school.CNT=student.CNT and school.SCHOOLID=student.SCHOOLID);


drop view if exists view_countries;
create view view_countries as
SELECT code2, country, Income_Group, Happy_index, Exp_Educ_pct, GDP_pc, GINI, Gov_expen_per_student_pct, 
House_final_cons_exp_pc, Labor_force_tertiary_educ_pct, 
AVG(Gender) AS Gender, 
AVG(PersonalMotivation) AS PersonalMotivation,
AVG(PossessionsStudyStudyPlace) as PossessionsStudyStudyPlace,
AVG(PossessionsStudyComputer) as PossessionsStudyComputer, 
AVG(PossessionsStudyInternet) as PossessionsStudyInternet
FROM view_analysis
GROUP BY code2, country, Income_Group, Happy_index, Exp_Educ_pct, GDP_pc, GINI, Gov_expen_per_student_pct, 
House_final_cons_exp_pc, Labor_force_tertiary_educ_pct;


-- alter table student add constraint	
--    FOREIGN KEY (CNT, SCHOOLID) REFERENCES school(CNT, SCHOOLID) ON UPDATE CASCADE ON DELETE RESTRICT;
-- alter table student add constraint   
-- 	FOREIGN KEY (CNT, STIDSTD, SCHOOLID) REFERENCES parents(CNT, STIDSTD, SCHOOLID) ON UPDATE CASCADE ON DELETE RESTRICT;
