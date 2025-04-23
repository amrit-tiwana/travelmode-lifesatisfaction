/*********************************************************************************/
*** SuMo Cluster	
***
*** Association between transport mode to work/educ and life satisfaction				
***
*** Author: Amrit Tiwana		
*** 			
*** Date: April 2, 2024		
***	
/*********************************************************************************/;

/*** Set Up ***/

/* Importing data file */
PROC IMPORT OUT = WORK.SUMO
	DATAFILE = 'C:\Users\Amrit\OneDrive - University of Toronto\Desktop\SuMo Cluster\3. Data Analysis\sumo\data\sumo_fullsample.csv';
RUN;

/* Create a copy of the dataset */
DATA WORK.SUMO_COPY;
  SET WORK.SUMO;
RUN;

/* Look at the properties of the dataset */
PROC CONTENTS DATA = WORK.SUMO_COPY;
RUN;

/*** Exploratory Data Analysis ***/

/** Subset to population of interest **/

/* Subset to workers and students */
DATA WORK.SUMO_COPY;
  SET WORK.SUMO_COPY;
  WHERE Q9_6_ftemploy = 1 or Q9_6_ptemploy = 1 or Q9_6_student = 1;
RUN;

/* Look at the properties of the subsetted dataset */
PROC CONTENTS DATA = WORK.SUMO_COPY;
RUN; /* N = 1270 */

/** Explore sociodemographic variables **/

/* Age */
PROC UNIVARIATE DATA = WORK.SUMO_COPY;
  VAR Age;
  HISTOGRAM;
RUN; /* distribution looks ok; range 18 to 83 with a mean of 37.9 */

/* Political spectrum */
PROC UNIVARIATE DATA = WORK.SUMO_COPY;
  VAR Q3_8_politicalspectrum;
  HISTOGRAM;
RUN; /* range 1 to 10 with a mean of 4.7 */

/* Categorical sociodemographic variables */ 
PROC FREQ DATA = WORK.SUMO_COPY;
  TABLES 
  Q9_2_gender 
  Q3_3_1_vision_ability 
  Q3_3_2_hearing_ability 
  Q3_3_3_walking_ability 
  Q3_3_4_memory_ability 
  Q3_3_5_selfcare_ability 
  Q9_8_move_to_can; 
RUN;

DATA WORK.SUMO_COPY;
  SET WORK.SUMO_COPY;
  IF Q9_2_gender = 1 THEN Q9_2_gender = 1;
  ELSE IF Q9_2_gender = 2 THEN Q9_2_gender = 2;
  ELSE IF Q9_2_gender = 3 or Q9_2_gender = 4 THEN Q9_2_gender = 3;
  ELSE Q9_2_gender = .;
RUN;

DATA WORK.SUMO_COPY;
  SET WORK.SUMO_COPY;
  IF Q3_3_1_vision_ability = 3 OR Q3_3_1_vision_ability = 4 THEN Q3_3_disability = 1;
  ELSE IF Q3_3_2_hearing_ability = 3 OR Q3_3_2_hearing_ability = 4 THEN Q3_3_disability = 1;
  ELSE IF Q3_3_3_walking_ability = 3 OR Q3_3_3_walking_ability = 4 THEN Q3_3_disability = 1;
  ELSE IF Q3_3_4_memory_ability = 3 OR Q3_3_4_memory_ability = 4 THEN Q3_3_disability = 1;
  ELSE IF Q3_3_5_selfcare_ability = 3 OR Q3_3_5_selfcare_ability = 4 THEN Q3_3_disability = 1;
  ELSE Q3_3_disability = 0;
RUN;

DATA WORK.SUMO_COPY;
  SET WORK.SUMO_COPY;
  IF Q9_8_move_to_can = 1 THEN Q9_8_move_to_can = 1;
  ELSE IF Q9_8_move_to_can = 2 or Q9_8_move_to_can = 3 THEN Q9_8_move_to_can = 2;
  ELSE IF Q9_8_move_to_can = 4 or Q9_8_move_to_can = 5 or Q9_8_move_to_can = 6 THEN Q9_8_move_to_can = 3;
RUN;

PROC FREQ DATA = WORK.SUMO_COPY;
	TABLES
	Q9_2_gender
    Q3_3_disability
	Q9_8_move_to_can
	/ MISSING;
RUN;

/** Exploring economic variables **/

/* Household income */
DATA WORK.SUMO_COPY;
  SET WORK.SUMO_COPY;
  Q9_10_1_hhincome_num = input(Q9_10_1_hhincome, BEST12.); 
  DROP Q9_10_1_hhincome;
RUN;

PROC UNIVARIATE DATA = WORK.SUMO_COPY;
  VAR Q9_10_1_hhincome_num;
  HISTOGRAM;
RUN;

/* Categorical economic variables */ 
PROC FREQ DATA = WORK.SUMO_COPY;
  TABLES 
  Q2_1_v_personal
  Q9_12_dwelling
  Q9_5_edu
  Q9_6_ftemploy
  Q9_6_ptemploy 
  Q9_6_homemaker 
  Q9_6_unemploy 
  Q9_6_retired
  Q9_6_student
  Q9_6_unable_noassist
  Q9_6_unable_assisted
  Q9_6_NA
  Q9_3_RelationshipMember1
  Q9_3_RelationshipMember2
  Q9_3_RelationshipMember3
  Q9_3_RelationshipMember4
  Q9_3_RelationshipMember5
  Q9_3_RelationshipMember6
  Q9_3_RelationshipMember7
  Q9_3_RelationshipMember8
  Q9_3_RelationshipMember9
  Q9_3_RelationshipMember10;
RUN;

DATA WORK.SUMO_COPY;
  SET WORK.SUMO_COPY;
  IF Q9_12_dwelling = 1 or Q9_12_dwelling = 2 THEN Q9_12_dwelling = 1;
  ELSE IF Q9_12_dwelling = 3 or Q9_12_dwelling = 4 THEN Q9_12_dwelling = 2;
  ELSE IF Q9_12_dwelling = 5 or Q9_12_dwelling = 6 THEN Q9_12_dwelling = 3;
  ELSE IF Q9_12_dwelling = 7 or Q9_12_dwelling = 8 or Q9_12_dwelling = 0 THEN Q9_12_dwelling = 4;
RUN;

DATA WORK.SUMO_COPY;
  SET WORK.SUMO_COPY;
  IF Q9_5_edu = 1 or Q9_5_edu = 2  THEN Q9_5_edu = 1; 
  ELSE IF Q9_5_edu = 3 or Q9_5_edu = 4 or Q9_5_edu = 5 THEN Q9_5_edu = 2; 
  ELSE IF Q9_5_edu = 6 THEN Q9_5_edu = 3; 
RUN;

DATA WORK.SUMO_COPY;
  SET WORK.SUMO_COPY;
  IF Q9_3_RelationshipMember1 ^= "NA" AND Q9_3_RelationshipMember2 = "NA" AND Q9_3_RelationshipMember3 = "NA" AND Q9_3_RelationshipMember4 = "NA" AND Q9_3_RelationshipMember5 = "NA" AND Q9_3_RelationshipMember6 = "NA" AND Q9_3_RelationshipMember7 = "NA" AND Q9_3_RelationshipMember8 = "NA" AND Q9_3_RelationshipMember9 = "NA" AND Q9_3_RelationshipMember10 = "NA" THEN Q9_3_RelationshipMember = 2;
  ELSE IF Q9_3_RelationshipMember2 ^= "NA" AND Q9_3_RelationshipMember3 = "NA" AND Q9_3_RelationshipMember4 = "NA" AND Q9_3_RelationshipMember5 = "NA" AND Q9_3_RelationshipMember6 = "NA" AND Q9_3_RelationshipMember7 = "NA" AND Q9_3_RelationshipMember8 = "NA" AND Q9_3_RelationshipMember9 = "NA" AND Q9_3_RelationshipMember10 = "NA" THEN Q9_3_RelationshipMember = 3;
  ELSE IF Q9_3_RelationshipMember3 ^= "NA" AND Q9_3_RelationshipMember4 = "NA" AND Q9_3_RelationshipMember5 = "NA" AND Q9_3_RelationshipMember6 = "NA" AND Q9_3_RelationshipMember7 = "NA" AND Q9_3_RelationshipMember8 = "NA" AND Q9_3_RelationshipMember9 = "NA" AND Q9_3_RelationshipMember10 = "NA" THEN Q9_3_RelationshipMember = 4;
  ELSE IF Q9_3_RelationshipMember4 ^= "NA" AND Q9_3_RelationshipMember5 = "NA" AND Q9_3_RelationshipMember6 = "NA" AND Q9_3_RelationshipMember7 = "NA" AND Q9_3_RelationshipMember8 = "NA" AND Q9_3_RelationshipMember9 = "NA" AND Q9_3_RelationshipMember10 = "NA" THEN Q9_3_RelationshipMember = 5;
  ELSE IF Q9_3_RelationshipMember5 ^= "NA" AND Q9_3_RelationshipMember6 = "NA" AND Q9_3_RelationshipMember7 = "NA" AND Q9_3_RelationshipMember8 = "NA" AND Q9_3_RelationshipMember9 = "NA" AND Q9_3_RelationshipMember10 = "NA" THEN Q9_3_RelationshipMember = 6;
  ELSE IF Q9_3_RelationshipMember6 ^= "NA" AND Q9_3_RelationshipMember7 = "NA" AND Q9_3_RelationshipMember8 = "NA" AND Q9_3_RelationshipMember9 = "NA" AND Q9_3_RelationshipMember10 = "NA" THEN Q9_3_RelationshipMember = 7;
  ELSE IF Q9_3_RelationshipMember7 ^= "NA" AND Q9_3_RelationshipMember8 = "NA" AND Q9_3_RelationshipMember9 = "NA" AND Q9_3_RelationshipMember10 = "NA" THEN Q9_3_RelationshipMember = 8;
  ELSE IF Q9_3_RelationshipMember8 ^= "NA" AND Q9_3_RelationshipMember9 = "NA" AND Q9_3_RelationshipMember10 = "NA" THEN Q9_3_RelationshipMember = 9;
  ELSE IF Q9_3_RelationshipMember9 ^= "NA" AND Q9_3_RelationshipMember10 = "NA" THEN Q9_3_RelationshipMember = 10;
  ELSE IF Q9_3_RelationshipMember10 ^= "NA" THEN Q9_3_RelationshipMember = 10;
  ELSE Q9_3_RelationshipMember = 1;
RUN;

PROC FREQ DATA = WORK.SUMO_COPY;
	TABLES
	Q2_1_v_personal
	Q9_12_dwelling
    Q9_5_edu
    Q9_6_ftemploy
    Q9_6_ptemploy 
    Q9_6_student
    Q9_3_RelationshipMember
	/ MISSING;
RUN;

/* Create adjusted household income variable */
DATA WORK.SUMO_COPY;
  SET WORK.SUMO_COPY;
  IF MISSING(Q9_10_1_hhincome_num) OR MISSING(Q9_3_RelationshipMember) THEN adjusted_hhincome = .;
  ELSE adjusted_hhincome = ABS(Q9_10_1_hhincome_num) / sqrt(Q9_3_RelationshipMember);
RUN;

PROC UNIVARIATE DATA = WORK.SUMO_COPY;
  VAR adjusted_hhincome;
  HISTOGRAM;
RUN;

/** Exploring social/environment variables **/

/* Categorical social/environment variables */ 
PROC FREQ DATA = WORK.SUMO_COPY;
  TABLES 
Q3_10_orgparticipation
/*Q6_1_nbtrust*/
/*Q7_8_policefunding*/
Q2_6_7_unsafetraffic
Q2_6_8_unsafecrime
Q3_7_3_trustppl_nb
Q2_7_2_covid_ptransitrisky / MISSING;
RUN;

DATA WORK.SUMO_COPY;
  SET WORK.SUMO_COPY;
  IF Q3_10_orgparticipation = 4 or Q3_10_orgparticipation = 5 THEN Q3_10_orgparticipation = 1; 
  ELSE IF Q3_10_orgparticipation = 3 THEN Q3_10_orgparticipation = 2;  
  ELSE IF Q3_10_orgparticipation = 1 or Q3_10_orgparticipation = 2 THEN Q3_10_orgparticipation = 3;
  ELSE Q3_10_orgparticipation = .; 
RUN;

DATA WORK.SUMO_COPY;
  SET WORK.SUMO_COPY;
  IF Q2_6_7_unsafetraffic = 4 OR Q2_6_7_unsafetraffic = 5 THEN Q2_6_7_unsafetraffic = 1; 
  ELSE IF Q2_6_7_unsafetraffic = 3 THEN Q2_6_7_unsafetraffic = 2;  
  ELSE IF Q2_6_7_unsafetraffic = 2 THEN Q2_6_7_unsafetraffic = 3; 
  ELSE Q2_6_7_unsafetraffic = .;
RUN;

DATA WORK.SUMO_COPY;
  SET WORK.SUMO_COPY;
  IF Q2_6_8_unsafecrime = 4 OR Q2_6_8_unsafecrime = 5 THEN Q2_6_8_unsafecrime = 1; 
  ELSE IF Q2_6_8_unsafecrime = 3 THEN Q2_6_8_unsafecrime = 2;  
  ELSE IF Q2_6_8_unsafecrime = 2 THEN Q2_6_8_unsafecrime = 3; 
  ELSE Q2_6_8_unsafecrime = .;
RUN;

DATA WORK.SUMO_COPY;
  SET WORK.SUMO_COPY;
  IF Q3_7_3_trustppl_nb = 4 OR Q3_7_3_trustppl_nb = 5 THEN Q3_7_3_trustppl_nb = 1; 
  ELSE IF Q3_7_3_trustppl_nb = 3 THEN Q3_7_3_trustppl_nb = 2;  
  ELSE IF Q3_7_3_trustppl_nb = 1 OR Q3_7_3_trustppl_nb = 2 THEN Q3_7_3_trustppl_nb = 3; 
  ELSE Q3_7_3_trustppl_nb = .;
RUN;

DATA WORK.SUMO_COPY;
  SET WORK.SUMO_COPY;
  IF Q2_7_2_covid_ptransitrisky = 4 OR Q2_7_2_covid_ptransitrisky = 5 THEN Q2_7_2_covid_ptransitrisky = 1; 
  ELSE IF Q2_7_2_covid_ptransitrisky = 3 THEN Q2_7_2_covid_ptransitrisky = 2;  
  ELSE IF Q2_7_2_covid_ptransitrisky = 1 OR Q2_7_2_covid_ptransitrisky = 2 THEN Q2_7_2_covid_ptransitrisky = 3;
  ELSE Q2_7_2_covid_ptransitrisky = .; 
RUN;

PROC FREQ DATA = WORK.SUMO_COPY;
  TABLES 
Q3_10_orgparticipation
Q2_6_7_unsafetraffic
Q2_6_8_unsafecrime
Q3_7_3_trustppl_nb
Q2_7_2_covid_ptransitrisky / MISSING;
RUN;

/** Exploring exposure variable **/

/* Create frequency tables of exposure variables */ 
PROC FREQ DATA = WORK.SUMO_COPY;
  TABLES 
Q2_2_1_work_edu_car
Q2_2_1_work_edu_ptransit
Q2_2_1_work_edu_bike
Q2_2_1_work_edu_walk
Q2_2_1_work_edu_remote
Q2_2_1_work_edu_taxi
Q2_2_1_work_edu_other
Q2_2_1_work_edu_NA;
RUN;

PROC FREQ DATA=WORK.SUMO_COPY;
TABLES Q2_2_1_work_edu_car * Q2_2_1_work_edu_ptransit * Q2_2_1_work_edu_bike * Q2_2_1_work_edu_walk * Q2_2_1_work_edu_remote * Q2_2_1_work_edu_taxi * Q2_2_1_work_edu_other * Q2_2_1_work_edu_NA / LIST MISSING;
RUN;

DATA WORK.SUMO_COPY;
SET WORK.SUMO_COPY;
IF Q2_2_1_work_edu_car = 1 and Q2_2_1_work_edu_ptransit = 0 and Q2_2_1_work_edu_bike = 0 and Q2_2_1_work_edu_walk = 0 and Q2_2_1_work_edu_remote = 0 and Q2_2_1_work_edu_taxi = 0 and Q2_2_1_work_edu_other = 0 and Q2_2_1_work_edu_NA = 0 THEN transport_mode = 1;
ELSE IF Q2_2_1_work_edu_car = 0 and Q2_2_1_work_edu_ptransit = 1 and Q2_2_1_work_edu_bike = 0 and Q2_2_1_work_edu_walk = 0 and Q2_2_1_work_edu_remote = 0 and Q2_2_1_work_edu_taxi = 0 and Q2_2_1_work_edu_other = 0 and Q2_2_1_work_edu_NA = 0 THEN transport_mode = 2;
ELSE IF Q2_2_1_work_edu_car = 0 and Q2_2_1_work_edu_ptransit = 1 and Q2_2_1_work_edu_bike = 0 and Q2_2_1_work_edu_walk = 0 and Q2_2_1_work_edu_remote = 0 and Q2_2_1_work_edu_taxi = 1 and Q2_2_1_work_edu_other = 0 and Q2_2_1_work_edu_NA = 0 THEN transport_mode = 2; 
ELSE IF Q2_2_1_work_edu_car = 0 and Q2_2_1_work_edu_ptransit = 0 and Q2_2_1_work_edu_bike = 0 and Q2_2_1_work_edu_walk = 0 and Q2_2_1_work_edu_remote = 0 and Q2_2_1_work_edu_taxi = 1 and Q2_2_1_work_edu_other = 0 and Q2_2_1_work_edu_NA = 0 THEN transport_mode = 2; 
ELSE IF Q2_2_1_work_edu_car = 0 and Q2_2_1_work_edu_ptransit = 0 and Q2_2_1_work_edu_bike = 1 and Q2_2_1_work_edu_walk = 0 and Q2_2_1_work_edu_remote = 0 and Q2_2_1_work_edu_taxi = 0 and Q2_2_1_work_edu_other = 0 and Q2_2_1_work_edu_NA = 0 THEN transport_mode = 3;
ELSE IF Q2_2_1_work_edu_car = 0 and Q2_2_1_work_edu_ptransit = 0 and Q2_2_1_work_edu_bike = 0 and Q2_2_1_work_edu_walk = 1 and Q2_2_1_work_edu_remote = 0 and Q2_2_1_work_edu_taxi = 0 and Q2_2_1_work_edu_other = 0 and Q2_2_1_work_edu_NA = 0 THEN transport_mode = 3;
ELSE IF Q2_2_1_work_edu_car = 0 and Q2_2_1_work_edu_ptransit = 0 and Q2_2_1_work_edu_bike = 1 and Q2_2_1_work_edu_walk = 1 and Q2_2_1_work_edu_remote = 0 and Q2_2_1_work_edu_taxi = 0 and Q2_2_1_work_edu_other = 0 and Q2_2_1_work_edu_NA = 0 THEN transport_mode = 3;
ELSE IF Q2_2_1_work_edu_car = 0 and Q2_2_1_work_edu_ptransit = 0 and Q2_2_1_work_edu_bike = 0 and Q2_2_1_work_edu_walk = 0 and Q2_2_1_work_edu_remote = 1 and Q2_2_1_work_edu_taxi = 0 and Q2_2_1_work_edu_other = 0 and Q2_2_1_work_edu_NA = 0 THEN transport_mode = 4;
ELSE IF Q2_2_1_work_edu_car = 0 and Q2_2_1_work_edu_ptransit = 0 and Q2_2_1_work_edu_bike = 0 and Q2_2_1_work_edu_walk = 0 and Q2_2_1_work_edu_remote = 0 and Q2_2_1_work_edu_taxi = 0 and Q2_2_1_work_edu_other = 0 and Q2_2_1_work_edu_NA = 1 THEN transport_mode = .;
ELSE IF Q2_2_1_work_edu_car = 0 and Q2_2_1_work_edu_ptransit = 0 and Q2_2_1_work_edu_bike = 0 and Q2_2_1_work_edu_walk = 0 and Q2_2_1_work_edu_remote = 0 and Q2_2_1_work_edu_taxi = 0 and Q2_2_1_work_edu_other = 1 and Q2_2_1_work_edu_NA = 0 THEN transport_mode = .; 
ELSE IF Q2_2_1_work_edu_car = 0 and Q2_2_1_work_edu_ptransit = 0 and Q2_2_1_work_edu_bike = 0 and Q2_2_1_work_edu_walk = 0 and Q2_2_1_work_edu_remote = 1 and Q2_2_1_work_edu_taxi = 0 and Q2_2_1_work_edu_other = 0 and Q2_2_1_work_edu_NA = 1 THEN transport_mode = .;
ELSE IF Q2_2_1_work_edu_car = 0 and Q2_2_1_work_edu_ptransit = 0 and Q2_2_1_work_edu_bike = 0 and Q2_2_1_work_edu_walk = 0 and Q2_2_1_work_edu_remote = 0 and Q2_2_1_work_edu_taxi = 1 and Q2_2_1_work_edu_other = 1 and Q2_2_1_work_edu_NA = 0 THEN transport_mode = .;
ELSE IF Q2_2_1_work_edu_car = 0 and Q2_2_1_work_edu_ptransit = 1 and Q2_2_1_work_edu_bike = 0 and Q2_2_1_work_edu_walk = 0 and Q2_2_1_work_edu_remote = 0 and Q2_2_1_work_edu_taxi = 0 and Q2_2_1_work_edu_other = 1 and Q2_2_1_work_edu_NA = 0 THEN transport_mode = .;
ELSE IF Q2_2_1_work_edu_car = 1 and Q2_2_1_work_edu_ptransit = 0 and Q2_2_1_work_edu_bike = 0 and Q2_2_1_work_edu_walk = 0 and Q2_2_1_work_edu_remote = 0 and Q2_2_1_work_edu_taxi = 0 and Q2_2_1_work_edu_other = 1 and Q2_2_1_work_edu_NA = 0 THEN transport_mode = .; 
ELSE IF Q2_2_1_work_edu_car = 1 and Q2_2_1_work_edu_ptransit = 0 and Q2_2_1_work_edu_bike = 0 and Q2_2_1_work_edu_walk = 0 and Q2_2_1_work_edu_remote = 0 and Q2_2_1_work_edu_taxi = 1 and Q2_2_1_work_edu_other = 1 and Q2_2_1_work_edu_NA = 0 THEN transport_mode = .;
ELSE IF Q2_2_1_work_edu_car = 1 and Q2_2_1_work_edu_ptransit = 1 and Q2_2_1_work_edu_bike = 0 and Q2_2_1_work_edu_walk = 0 and Q2_2_1_work_edu_remote = 0 and Q2_2_1_work_edu_taxi = 0 and Q2_2_1_work_edu_other = 1 and Q2_2_1_work_edu_NA = 0 THEN transport_mode = .;
ELSE transport_mode = 5;
RUN;

/* Create frequency of expoaure variable */
PROC FREQ DATA = WORK.SUMO_COPY;
  TABLES 
transport_mode / MISSING;
RUN;

/* Create dummy variables for transport_mode */
DATA WORK.SUMO_COPY;
    SET WORK.SUMO_COPY;
    car = (transport_mode = 1);
    ptransit = (transport_mode = 2);
    active = (transport_mode = 3);
    remote = (transport_mode = 4);
    multi = (transport_mode = 5);
RUN;

/* Create frequency tables of exposure variables */ 
PROC FREQ DATA = WORK.SUMO_COPY;
  TABLES 
car
ptransit
active
remote
multi;
RUN;

DATA WORK.SUMO_COPY;
SET WORK.SUMO_COPY;
IF Q2_2_1_work_edu_car = 1 and Q2_2_1_work_edu_ptransit = 0 and Q2_2_1_work_edu_bike = 0 and Q2_2_1_work_edu_walk = 0 and Q2_2_1_work_edu_remote = 0 and Q2_2_1_work_edu_taxi = 0 and Q2_2_1_work_edu_other = 0 and Q2_2_1_work_edu_NA = 0 THEN transport_mode1 = 1;
ELSE IF Q2_2_1_work_edu_car = 0 and Q2_2_1_work_edu_ptransit = 1 and Q2_2_1_work_edu_bike = 0 and Q2_2_1_work_edu_walk = 0 and Q2_2_1_work_edu_remote = 0 and Q2_2_1_work_edu_taxi = 0 and Q2_2_1_work_edu_other = 0 and Q2_2_1_work_edu_NA = 0 THEN transport_mode1 = 2;
ELSE IF Q2_2_1_work_edu_car = 0 and Q2_2_1_work_edu_ptransit = 1 and Q2_2_1_work_edu_bike = 0 and Q2_2_1_work_edu_walk = 0 and Q2_2_1_work_edu_remote = 0 and Q2_2_1_work_edu_taxi = 1 and Q2_2_1_work_edu_other = 0 and Q2_2_1_work_edu_NA = 0 THEN transport_mode1 = 2; 
ELSE IF Q2_2_1_work_edu_car = 0 and Q2_2_1_work_edu_ptransit = 0 and Q2_2_1_work_edu_bike = 0 and Q2_2_1_work_edu_walk = 0 and Q2_2_1_work_edu_remote = 0 and Q2_2_1_work_edu_taxi = 1 and Q2_2_1_work_edu_other = 0 and Q2_2_1_work_edu_NA = 0 THEN transport_mode1 = 2; 
ELSE IF Q2_2_1_work_edu_car = 0 and Q2_2_1_work_edu_ptransit = 0 and Q2_2_1_work_edu_bike = 1 and Q2_2_1_work_edu_walk = 0 and Q2_2_1_work_edu_remote = 0 and Q2_2_1_work_edu_taxi = 0 and Q2_2_1_work_edu_other = 0 and Q2_2_1_work_edu_NA = 0 THEN transport_mode1 = 3;
ELSE IF Q2_2_1_work_edu_car = 0 and Q2_2_1_work_edu_ptransit = 0 and Q2_2_1_work_edu_bike = 0 and Q2_2_1_work_edu_walk = 1 and Q2_2_1_work_edu_remote = 0 and Q2_2_1_work_edu_taxi = 0 and Q2_2_1_work_edu_other = 0 and Q2_2_1_work_edu_NA = 0 THEN transport_mode1 = 3;
ELSE IF Q2_2_1_work_edu_car = 0 and Q2_2_1_work_edu_ptransit = 0 and Q2_2_1_work_edu_bike = 1 and Q2_2_1_work_edu_walk = 1 and Q2_2_1_work_edu_remote = 0 and Q2_2_1_work_edu_taxi = 0 and Q2_2_1_work_edu_other = 0 and Q2_2_1_work_edu_NA = 0 THEN transport_mode1 = 3;
ELSE IF Q2_2_1_work_edu_car = 0 and Q2_2_1_work_edu_ptransit = 0 and Q2_2_1_work_edu_bike = 0 and Q2_2_1_work_edu_walk = 0 and Q2_2_1_work_edu_remote = 1 and Q2_2_1_work_edu_taxi = 0 and Q2_2_1_work_edu_other = 0 and Q2_2_1_work_edu_NA = 0 THEN transport_mode1 = 4;
ELSE IF Q2_2_1_work_edu_car = 0 and Q2_2_1_work_edu_ptransit = 0 and Q2_2_1_work_edu_bike = 0 and Q2_2_1_work_edu_walk = 0 and Q2_2_1_work_edu_remote = 0 and Q2_2_1_work_edu_taxi = 0 and Q2_2_1_work_edu_other = 0 and Q2_2_1_work_edu_NA = 1 THEN transport_mode1 = .;
ELSE IF Q2_2_1_work_edu_car = 0 and Q2_2_1_work_edu_ptransit = 0 and Q2_2_1_work_edu_bike = 0 and Q2_2_1_work_edu_walk = 0 and Q2_2_1_work_edu_remote = 0 and Q2_2_1_work_edu_taxi = 0 and Q2_2_1_work_edu_other = 1 and Q2_2_1_work_edu_NA = 0 THEN transport_mode1 = .; 
ELSE IF Q2_2_1_work_edu_car = 0 and Q2_2_1_work_edu_ptransit = 0 and Q2_2_1_work_edu_bike = 0 and Q2_2_1_work_edu_walk = 0 and Q2_2_1_work_edu_remote = 1 and Q2_2_1_work_edu_taxi = 0 and Q2_2_1_work_edu_other = 0 and Q2_2_1_work_edu_NA = 1 THEN transport_mode1 = .;
ELSE IF Q2_2_1_work_edu_car = 0 and Q2_2_1_work_edu_ptransit = 0 and Q2_2_1_work_edu_bike = 0 and Q2_2_1_work_edu_walk = 0 and Q2_2_1_work_edu_remote = 0 and Q2_2_1_work_edu_taxi = 1 and Q2_2_1_work_edu_other = 1 and Q2_2_1_work_edu_NA = 0 THEN transport_mode1 = .;
ELSE IF Q2_2_1_work_edu_car = 0 and Q2_2_1_work_edu_ptransit = 1 and Q2_2_1_work_edu_bike = 0 and Q2_2_1_work_edu_walk = 0 and Q2_2_1_work_edu_remote = 0 and Q2_2_1_work_edu_taxi = 0 and Q2_2_1_work_edu_other = 1 and Q2_2_1_work_edu_NA = 0 THEN transport_mode1 = .;
ELSE IF Q2_2_1_work_edu_car = 1 and Q2_2_1_work_edu_ptransit = 0 and Q2_2_1_work_edu_bike = 0 and Q2_2_1_work_edu_walk = 0 and Q2_2_1_work_edu_remote = 0 and Q2_2_1_work_edu_taxi = 0 and Q2_2_1_work_edu_other = 1 and Q2_2_1_work_edu_NA = 0 THEN transport_mode1 = .; 
ELSE IF Q2_2_1_work_edu_car = 1 and Q2_2_1_work_edu_ptransit = 0 and Q2_2_1_work_edu_bike = 0 and Q2_2_1_work_edu_walk = 0 and Q2_2_1_work_edu_remote = 0 and Q2_2_1_work_edu_taxi = 1 and Q2_2_1_work_edu_other = 1 and Q2_2_1_work_edu_NA = 0 THEN transport_mode1 = .;
ELSE IF Q2_2_1_work_edu_car = 1 and Q2_2_1_work_edu_ptransit = 1 and Q2_2_1_work_edu_bike = 0 and Q2_2_1_work_edu_walk = 0 and Q2_2_1_work_edu_remote = 0 and Q2_2_1_work_edu_taxi = 0 and Q2_2_1_work_edu_other = 1 and Q2_2_1_work_edu_NA = 0 THEN transport_mode1 = .;
ELSE IF Q2_2_1_work_edu_car = 1 and Q2_2_1_work_edu_ptransit = 1 and Q2_2_1_work_edu_bike = 0 and Q2_2_1_work_edu_walk = 0 and Q2_2_1_work_edu_remote = 0 and Q2_2_1_work_edu_taxi = 0 and Q2_2_1_work_edu_other = 0 and Q2_2_1_work_edu_NA = 0 THEN transport_mode1 = 5;
ELSE IF Q2_2_1_work_edu_car = 1 and Q2_2_1_work_edu_ptransit = 0 and Q2_2_1_work_edu_bike = 0 and Q2_2_1_work_edu_walk = 0 and Q2_2_1_work_edu_remote = 0 and Q2_2_1_work_edu_taxi = 1 and Q2_2_1_work_edu_other = 0 and Q2_2_1_work_edu_NA = 0 THEN transport_mode1 = 5;
ELSE IF Q2_2_1_work_edu_car = 1 and Q2_2_1_work_edu_ptransit = 1 and Q2_2_1_work_edu_bike = 0 and Q2_2_1_work_edu_walk = 0 and Q2_2_1_work_edu_remote = 0 and Q2_2_1_work_edu_taxi = 1 and Q2_2_1_work_edu_other = 0 and Q2_2_1_work_edu_NA = 0 THEN transport_mode1 = 5;
ELSE IF Q2_2_1_work_edu_car = 1 and Q2_2_1_work_edu_ptransit = 0 and Q2_2_1_work_edu_bike = 0 and Q2_2_1_work_edu_walk = 1 and Q2_2_1_work_edu_remote = 0 and Q2_2_1_work_edu_taxi = 0 and Q2_2_1_work_edu_other = 0 and Q2_2_1_work_edu_NA = 0 THEN transport_mode1 = 6;
ELSE IF Q2_2_1_work_edu_car = 1 and Q2_2_1_work_edu_ptransit = 0 and Q2_2_1_work_edu_bike = 1 and Q2_2_1_work_edu_walk = 0 and Q2_2_1_work_edu_remote = 0 and Q2_2_1_work_edu_taxi = 0 and Q2_2_1_work_edu_other = 0 and Q2_2_1_work_edu_NA = 0 THEN transport_mode1 = 6;
ELSE IF Q2_2_1_work_edu_car = 1 and Q2_2_1_work_edu_ptransit = 0 and Q2_2_1_work_edu_bike = 1 and Q2_2_1_work_edu_walk = 1 and Q2_2_1_work_edu_remote = 0 and Q2_2_1_work_edu_taxi = 0 and Q2_2_1_work_edu_other = 0 and Q2_2_1_work_edu_NA = 0 THEN transport_mode1 = 6;
ELSE IF Q2_2_1_work_edu_car = 0 and Q2_2_1_work_edu_ptransit = 1 and Q2_2_1_work_edu_bike = 0 and Q2_2_1_work_edu_walk = 1 and Q2_2_1_work_edu_remote = 0 and Q2_2_1_work_edu_taxi = 0 and Q2_2_1_work_edu_other = 0 and Q2_2_1_work_edu_NA = 0 THEN transport_mode1 = 7;
ELSE IF Q2_2_1_work_edu_car = 0 and Q2_2_1_work_edu_ptransit = 1 and Q2_2_1_work_edu_bike = 1 and Q2_2_1_work_edu_walk = 0 and Q2_2_1_work_edu_remote = 0 and Q2_2_1_work_edu_taxi = 0 and Q2_2_1_work_edu_other = 0 and Q2_2_1_work_edu_NA = 0 THEN transport_mode1 = 7;
ELSE IF Q2_2_1_work_edu_car = 0 and Q2_2_1_work_edu_ptransit = 1 and Q2_2_1_work_edu_bike = 0 and Q2_2_1_work_edu_walk = 1 and Q2_2_1_work_edu_remote = 0 and Q2_2_1_work_edu_taxi = 1 and Q2_2_1_work_edu_other = 0 and Q2_2_1_work_edu_NA = 0 THEN transport_mode1 = 7;
ELSE IF Q2_2_1_work_edu_car = 0 and Q2_2_1_work_edu_ptransit = 0 and Q2_2_1_work_edu_bike = 1 and Q2_2_1_work_edu_walk = 1 and Q2_2_1_work_edu_remote = 0 and Q2_2_1_work_edu_taxi = 1 and Q2_2_1_work_edu_other = 0 and Q2_2_1_work_edu_NA = 0 THEN transport_mode1 = 7;
ELSE IF Q2_2_1_work_edu_car = 0 and Q2_2_1_work_edu_ptransit = 1 and Q2_2_1_work_edu_bike = 1 and Q2_2_1_work_edu_walk = 1 and Q2_2_1_work_edu_remote = 0 and Q2_2_1_work_edu_taxi = 0 and Q2_2_1_work_edu_other = 0 and Q2_2_1_work_edu_NA = 0 THEN transport_mode1 = 7;
ELSE IF Q2_2_1_work_edu_car = 1 and Q2_2_1_work_edu_ptransit = 0 and Q2_2_1_work_edu_bike = 0 and Q2_2_1_work_edu_walk = 0 and Q2_2_1_work_edu_remote = 1 and Q2_2_1_work_edu_taxi = 0 and Q2_2_1_work_edu_other = 0 and Q2_2_1_work_edu_NA = 0 THEN transport_mode1 = 8;
ELSE IF Q2_2_1_work_edu_car = 0 and Q2_2_1_work_edu_ptransit = 1 and Q2_2_1_work_edu_bike = 0 and Q2_2_1_work_edu_walk = 0 and Q2_2_1_work_edu_remote = 1 and Q2_2_1_work_edu_taxi = 0 and Q2_2_1_work_edu_other = 0 and Q2_2_1_work_edu_NA = 0 THEN transport_mode1 = 9;
ELSE IF Q2_2_1_work_edu_car = 0 and Q2_2_1_work_edu_ptransit = 0 and Q2_2_1_work_edu_bike = 0 and Q2_2_1_work_edu_walk = 0 and Q2_2_1_work_edu_remote = 1 and Q2_2_1_work_edu_taxi = 1 and Q2_2_1_work_edu_other = 0 and Q2_2_1_work_edu_NA = 0 THEN transport_mode1 = 9;
ELSE IF Q2_2_1_work_edu_car = 0 and Q2_2_1_work_edu_ptransit = 1 and Q2_2_1_work_edu_bike = 0 and Q2_2_1_work_edu_walk = 0 and Q2_2_1_work_edu_remote = 1 and Q2_2_1_work_edu_taxi = 1 and Q2_2_1_work_edu_other = 0 and Q2_2_1_work_edu_NA = 0 THEN transport_mode1 = 9;
ELSE IF Q2_2_1_work_edu_car = 1 and Q2_2_1_work_edu_ptransit = 1 and Q2_2_1_work_edu_bike = 0 and Q2_2_1_work_edu_walk = 1 and Q2_2_1_work_edu_remote = 0 and Q2_2_1_work_edu_taxi = 0 and Q2_2_1_work_edu_other = 0 and Q2_2_1_work_edu_NA = 0 THEN transport_mode1 = 10;
ELSE IF Q2_2_1_work_edu_car = 1 and Q2_2_1_work_edu_ptransit = 1 and Q2_2_1_work_edu_bike = 1 and Q2_2_1_work_edu_walk = 0 and Q2_2_1_work_edu_remote = 0 and Q2_2_1_work_edu_taxi = 0 and Q2_2_1_work_edu_other = 0 and Q2_2_1_work_edu_NA = 0 THEN transport_mode1 = 10;
ELSE IF Q2_2_1_work_edu_car = 1 and Q2_2_1_work_edu_ptransit = 1 and Q2_2_1_work_edu_bike = 1 and Q2_2_1_work_edu_walk = 1 and Q2_2_1_work_edu_remote = 0 and Q2_2_1_work_edu_taxi = 0 and Q2_2_1_work_edu_other = 0 and Q2_2_1_work_edu_NA = 0 THEN transport_mode1 = 10;
ELSE IF Q2_2_1_work_edu_car = 1 and Q2_2_1_work_edu_ptransit = 1 and Q2_2_1_work_edu_bike = 1 and Q2_2_1_work_edu_walk = 0 and Q2_2_1_work_edu_remote = 0 and Q2_2_1_work_edu_taxi = 1 and Q2_2_1_work_edu_other = 0 and Q2_2_1_work_edu_NA = 0 THEN transport_mode1 = 10;
ELSE IF Q2_2_1_work_edu_car = 1 and Q2_2_1_work_edu_ptransit = 1 and Q2_2_1_work_edu_bike = 0 and Q2_2_1_work_edu_walk = 1 and Q2_2_1_work_edu_remote = 0 and Q2_2_1_work_edu_taxi = 1 and Q2_2_1_work_edu_other = 0 and Q2_2_1_work_edu_NA = 0 THEN transport_mode1 = 10;
ELSE IF Q2_2_1_work_edu_car = 1 and Q2_2_1_work_edu_ptransit = 1 and Q2_2_1_work_edu_bike = 1 and Q2_2_1_work_edu_walk = 1 and Q2_2_1_work_edu_remote = 0 and Q2_2_1_work_edu_taxi = 1 and Q2_2_1_work_edu_other = 0 and Q2_2_1_work_edu_NA = 0 THEN transport_mode1 = 10;
ELSE IF Q2_2_1_work_edu_car = 0 and Q2_2_1_work_edu_ptransit = 0 and Q2_2_1_work_edu_bike = 0 and Q2_2_1_work_edu_walk = 1 and Q2_2_1_work_edu_remote = 1 and Q2_2_1_work_edu_taxi = 0 and Q2_2_1_work_edu_other = 0 and Q2_2_1_work_edu_NA = 0 THEN transport_mode1 = 11;
ELSE IF Q2_2_1_work_edu_car = 0 and Q2_2_1_work_edu_ptransit = 1 and Q2_2_1_work_edu_bike = 0 and Q2_2_1_work_edu_walk = 1 and Q2_2_1_work_edu_remote = 1 and Q2_2_1_work_edu_taxi = 0 and Q2_2_1_work_edu_other = 0 and Q2_2_1_work_edu_NA = 0 THEN transport_mode1 = 11;
ELSE IF Q2_2_1_work_edu_car = 0 and Q2_2_1_work_edu_ptransit = 1 and Q2_2_1_work_edu_bike = 1 and Q2_2_1_work_edu_walk = 0 and Q2_2_1_work_edu_remote = 1 and Q2_2_1_work_edu_taxi = 0 and Q2_2_1_work_edu_other = 0 and Q2_2_1_work_edu_NA = 0 THEN transport_mode1 = 11;
ELSE IF Q2_2_1_work_edu_car = 0 and Q2_2_1_work_edu_ptransit = 0 and Q2_2_1_work_edu_bike = 1 and Q2_2_1_work_edu_walk = 1 and Q2_2_1_work_edu_remote = 1 and Q2_2_1_work_edu_taxi = 1 and Q2_2_1_work_edu_other = 0 and Q2_2_1_work_edu_NA = 0 THEN transport_mode1 = 11;
ELSE IF Q2_2_1_work_edu_car = 0 and Q2_2_1_work_edu_ptransit = 1 and Q2_2_1_work_edu_bike = 0 and Q2_2_1_work_edu_walk = 1 and Q2_2_1_work_edu_remote = 1 and Q2_2_1_work_edu_taxi = 1 and Q2_2_1_work_edu_other = 0 and Q2_2_1_work_edu_NA = 0 THEN transport_mode1 = 11;
ELSE IF Q2_2_1_work_edu_car = 1 and Q2_2_1_work_edu_ptransit = 0 and Q2_2_1_work_edu_bike = 0 and Q2_2_1_work_edu_walk = 0 and Q2_2_1_work_edu_remote = 1 and Q2_2_1_work_edu_taxi = 1 and Q2_2_1_work_edu_other = 0 and Q2_2_1_work_edu_NA = 0 THEN transport_mode1 = 11;
ELSE IF Q2_2_1_work_edu_car = 1 and Q2_2_1_work_edu_ptransit = 0 and Q2_2_1_work_edu_bike = 0 and Q2_2_1_work_edu_walk = 1 and Q2_2_1_work_edu_remote = 1 and Q2_2_1_work_edu_taxi = 0 and Q2_2_1_work_edu_other = 0 and Q2_2_1_work_edu_NA = 0 THEN transport_mode1 = 11;
ELSE IF Q2_2_1_work_edu_car = 1 and Q2_2_1_work_edu_ptransit = 1 and Q2_2_1_work_edu_bike = 0 and Q2_2_1_work_edu_walk = 0 and Q2_2_1_work_edu_remote = 1 and Q2_2_1_work_edu_taxi = 0 and Q2_2_1_work_edu_other = 0 and Q2_2_1_work_edu_NA = 0 THEN transport_mode1 = 11;
ELSE IF Q2_2_1_work_edu_car = 1 and Q2_2_1_work_edu_ptransit = 0 and Q2_2_1_work_edu_bike = 0 and Q2_2_1_work_edu_walk = 1 and Q2_2_1_work_edu_remote = 1 and Q2_2_1_work_edu_taxi = 1 and Q2_2_1_work_edu_other = 0 and Q2_2_1_work_edu_NA = 0 THEN transport_mode1 = 11;
ELSE IF Q2_2_1_work_edu_car = 1 and Q2_2_1_work_edu_ptransit = 0 and Q2_2_1_work_edu_bike = 1 and Q2_2_1_work_edu_walk = 1 and Q2_2_1_work_edu_remote = 1 and Q2_2_1_work_edu_taxi = 0 and Q2_2_1_work_edu_other = 0 and Q2_2_1_work_edu_NA = 0 THEN transport_mode1 = 11;
ELSE IF Q2_2_1_work_edu_car = 1 and Q2_2_1_work_edu_ptransit = 1 and Q2_2_1_work_edu_bike = 0 and Q2_2_1_work_edu_walk = 0 and Q2_2_1_work_edu_remote = 1 and Q2_2_1_work_edu_taxi = 1 and Q2_2_1_work_edu_other = 0 and Q2_2_1_work_edu_NA = 0 THEN transport_mode1 = 11;
ELSE IF Q2_2_1_work_edu_car = 1 and Q2_2_1_work_edu_ptransit = 1 and Q2_2_1_work_edu_bike = 0 and Q2_2_1_work_edu_walk = 1 and Q2_2_1_work_edu_remote = 1 and Q2_2_1_work_edu_taxi = 0 and Q2_2_1_work_edu_other = 0 and Q2_2_1_work_edu_NA = 0 THEN transport_mode1 = 11;
ELSE IF Q2_2_1_work_edu_car = 1 and Q2_2_1_work_edu_ptransit = 1 and Q2_2_1_work_edu_bike = 1 and Q2_2_1_work_edu_walk = 0 and Q2_2_1_work_edu_remote = 1 and Q2_2_1_work_edu_taxi = 0 and Q2_2_1_work_edu_other = 0 and Q2_2_1_work_edu_NA = 0 THEN transport_mode1 = 11;
ELSE IF Q2_2_1_work_edu_car = 1 and Q2_2_1_work_edu_ptransit = 1 and Q2_2_1_work_edu_bike = 0 and Q2_2_1_work_edu_walk = 1 and Q2_2_1_work_edu_remote = 1 and Q2_2_1_work_edu_taxi = 1 and Q2_2_1_work_edu_other = 0 and Q2_2_1_work_edu_NA = 0 THEN transport_mode1 = 11;
ELSE IF Q2_2_1_work_edu_car = 1 and Q2_2_1_work_edu_ptransit = 1 and Q2_2_1_work_edu_bike = 1 and Q2_2_1_work_edu_walk = 1 and Q2_2_1_work_edu_remote = 1 and Q2_2_1_work_edu_taxi = 0 and Q2_2_1_work_edu_other = 0 and Q2_2_1_work_edu_NA = 0 THEN transport_mode1 = 11;
ELSE IF Q2_2_1_work_edu_car = 1 and Q2_2_1_work_edu_ptransit = 1 and Q2_2_1_work_edu_bike = 1 and Q2_2_1_work_edu_walk = 1 and Q2_2_1_work_edu_remote = 1 and Q2_2_1_work_edu_taxi = 1 and Q2_2_1_work_edu_other = 0 and Q2_2_1_work_edu_NA = 0 THEN transport_mode1 = 11;
ELSE transport_mode1 = .;
RUN;

/* Create frequency of expoaure variable */
PROC FREQ DATA = WORK.SUMO_COPY;
  TABLES 
transport_mode1 / MISSING;
RUN;

PROC SQL;
    DELETE FROM WORK.SUMO_COPY
    WHERE transport_mode1 = .;
QUIT;

/* Create dummy variables for transport_mode */
DATA WORK.SUMO_COPY;
    SET WORK.SUMO_COPY;
    car1 = (transport_mode1 = 1);
    ptransit1 = (transport_mode1 = 2);
    active1 = (transport_mode1 = 3);
    remote1 = (transport_mode1 = 4);
    car_transit1 = (transport_mode1 = 5);
	car_active1 = (transport_mode1 = 6);
	transit_active1 = (transport_mode1 = 7);
	car_transit_active1 = (transport_mode1 = 8);
	car_remote1 = (transport_mode1 = 9);
	transit_remote1 = (transport_mode1 = 10);
	remote_multi1 = (transport_mode1 = 11);
RUN;

/* Create frequency tables of exposure variables */ 
PROC FREQ DATA = WORK.SUMO_COPY;
  TABLES 
car1
ptransit1
active1
remote1
car_transit1
car_active1
transit_active1
car_transit_active1
car_remote1
transit_remote1
remote_multi1;
RUN;

/** Exploring outcome variables **/

/* Create histogram of continous outcome variables */
PROC UNIVARIATE DATA = WORK.SUMO_COPY;
  VAR 
  Q3_6_1_life_satisf 
  Q3_6_2_health_satisf
  Q3_6_3_work_satisf
  Q3_6_4_personaltime_satisf
  Q3_6_5_finance_satisf
  Q2_4_nb_satisf;
  HISTOGRAM;
RUN;

PROC UNIVARIATE DATA = WORK.SUMO_COPY;
  VAR Q3_4_1_overallhealth;
  WHERE Q3_4_1_overallhealth < 6;
  HISTOGRAM;
RUN;

DATA WORK.SUMO_COPY;
  SET WORK.SUMO_COPY;
  IF Q3_4_1_overallhealth = 1 THEN Q3_4_1_overallhealth = 1; 
  ELSE IF Q3_4_1_overallhealth = 2 THEN Q3_4_1_overallhealth = 2;  
  ELSE IF Q3_4_1_overallhealth = 3 THEN Q3_4_1_overallhealth = 3;
  ELSE IF Q3_4_1_overallhealth = 4 THEN Q3_4_1_overallhealth = 4;
  ELSE IF Q3_4_1_overallhealth = 5 THEN Q3_4_1_overallhealth = 5;
  ELSE Q3_4_1_overallhealth = .; 
RUN;

PROC UNIVARIATE DATA = WORK.SUMO_COPY;
  VAR Q3_4_2_physicalhealth;
  WHERE Q3_4_2_physicalhealth < 6;
  HISTOGRAM;
RUN;

DATA WORK.SUMO_COPY;
  SET WORK.SUMO_COPY;
  IF Q3_4_2_physicalhealth = 1 THEN Q3_4_2_physicalhealth = 1; 
  ELSE IF Q3_4_2_physicalhealth = 2 THEN Q3_4_2_physicalhealth = 2;  
  ELSE IF Q3_4_2_physicalhealth = 3 THEN Q3_4_2_physicalhealth = 3;
  ELSE IF Q3_4_2_physicalhealth = 4 THEN Q3_4_2_physicalhealth = 4;
  ELSE IF Q3_4_2_physicalhealth = 5 THEN Q3_4_2_physicalhealth = 5;
  ELSE Q3_4_2_physicalhealth = .; 
RUN;

PROC UNIVARIATE DATA = WORK.SUMO_COPY;
  VAR Q3_4_3_mentalhealth;
  WHERE Q3_4_3_mentalhealth < 6;
  HISTOGRAM;
RUN;

DATA WORK.SUMO_COPY;
  SET WORK.SUMO_COPY;
  IF Q3_4_3_mentalhealth = 1 THEN Q3_4_3_mentalhealth = 1; 
  ELSE IF Q3_4_3_mentalhealth = 2 THEN Q3_4_3_mentalhealth = 2;  
  ELSE IF Q3_4_3_mentalhealth = 3 THEN Q3_4_3_mentalhealth = 3;
  ELSE IF Q3_4_3_mentalhealth = 4 THEN Q3_4_3_mentalhealth = 4;
  ELSE IF Q3_4_3_mentalhealth = 5 THEN Q3_4_3_mentalhealth = 5;
  ELSE Q3_4_3_mentalhealth = .; 
RUN;

/* Create frequency tables of outcome variables */ 
PROC FREQ DATA = WORK.SUMO_COPY;
  TABLES 
Q3_6_1_life_satisf
Q3_6_2_health_satisf
Q3_6_3_work_satisf
Q3_6_4_personaltime_satisf
Q3_6_5_finance_satisf
Q2_4_nb_satisf
Q3_4_1_overallhealth
Q3_4_2_physicalhealth
Q3_4_3_mentalhealth;
RUN;

/*** Missing data ***/

/* Create frequency of auxilary variables */
PROC FREQ DATA = WORK.SUMO_COPY;
  TABLES 
Q9_4_RacialCategory
Q9_12_dwelling
Q9_9_move_to_scarb
Q9_7_engfluency
NIA 
Q9_14_tcostdiff / MISSING;
RUN;

DATA WORK.SUMO_COPY;
  SET WORK.SUMO_COPY;
  IF Q9_4_RacialCategory = 99 or Q9_4_RacialCategory = "NA" THEN Q9_4_RacialCategory = .; 
RUN;

DATA WORK.SUMO_COPY;
    SET WORK.SUMO_COPY;
    Q9_4_RacialCategory_num = input(Q9_4_RacialCategory, ?? best32.);
	DROP Q9_4_RacialCategory;
RUN;

/* Create frequency of auxilary variables */
PROC FREQ DATA = WORK.SUMO_COPY;
  TABLES 
Q9_4_RacialCategory_num
Q9_12_dwelling
Q9_9_move_to_scarb
Q9_7_engfluency
NIA 
Q9_14_tcostdiff / MISSING;
RUN;

/* Examine missing data patterns */
PROC MI DATA = WORK.SUMO_COPY;
VAR 
/* sociodemographic variables */
Age 
Q3_8_politicalspectrum 
Q3_3_disability
Q9_2_gender
Q9_8_move_to_can
/* economic variables */
Q2_1_v_personal 
adjusted_hhincome 
Q9_5_edu 
Q9_6_ftemploy 
Q9_6_ptemploy 
Q9_6_student 
/* social variables */
Q2_6_7_unsafetraffic 
Q2_6_8_unsafecrime 
Q3_7_3_trustppl_nb
Q2_7_2_covid_ptransitrisky 
Q3_10_orgparticipation 
/* exposure variable */
transport_mode
car
ptransit
active
remote
multi
transport_mode1
car1
ptransit1
active1
remote1
car_transit1
car_active1
transit_active1
car_transit_active1
car_remote1
transit_remote1
remote_multi1
/* outcome variables */
Q3_6_1_life_satisf 
Q3_6_2_health_satisf 
Q3_6_3_work_satisf 
Q3_6_4_personaltime_satisf 
Q3_6_5_finance_satisf 
Q2_4_nb_satisf 
Q3_4_1_overallhealth 
Q3_4_2_physicalhealth 
Q3_4_3_mentalhealth 
/* auxilary variables */
Q9_10_1_hhincome_num 
Q9_4_RacialCategory_num 
Q9_12_dwelling 
Q9_9_move_to_scarb 
Q9_7_engfluency 
Q9_14_tcostdiff
NIA;
ODS SELECT MISSPATTERN;
RUN;

/* Imputation phase */
PROC MI DATA = WORK.SUMO_COPY NIMPUTE = 10 OUT = WORK.SUMO_COPY_MI SEED = 54321;
CLASS
Q3_8_politicalspectrum 
Q3_3_disability
Q9_2_gender
Q9_8_move_to_can
Q2_1_v_personal  
Q9_5_edu 
Q9_6_ftemploy 
Q9_6_ptemploy 
Q9_6_student 
Q2_6_7_unsafetraffic 
Q2_6_8_unsafecrime 
Q3_7_3_trustppl_nb
Q2_7_2_covid_ptransitrisky 
Q3_10_orgparticipation 
transport_mode
car
ptransit
active
remote
multi
transport_mode1
car1
ptransit1
active1
remote1
car_transit1
car_active1
transit_active1
car_transit_active1
car_remote1
transit_remote1
remote_multi1
Q3_6_1_life_satisf 
Q3_6_2_health_satisf 
Q3_6_3_work_satisf 
Q3_6_4_personaltime_satisf 
Q3_6_5_finance_satisf 
Q2_4_nb_satisf 
Q3_4_1_overallhealth 
Q3_4_2_physicalhealth 
Q3_4_3_mentalhealth 
Q9_12_dwelling 
Q9_9_move_to_scarb 
Q9_7_engfluency 
Q9_14_tcostdiff
NIA;
FCS NBITER = 100
REG
(Age 
adjusted_hhincome
Q9_10_1_hhincome_num 
Q9_4_RacialCategory_num)
LOGISTIC
(Q3_8_politicalspectrum 
Q3_3_disability
Q9_2_gender
Q9_8_move_to_can
Q2_1_v_personal 
Q9_5_edu 
Q9_6_ftemploy 
Q9_6_ptemploy 
Q9_6_student 
Q2_6_7_unsafetraffic 
Q2_6_8_unsafecrime 
Q3_7_3_trustppl_nb
Q2_7_2_covid_ptransitrisky 
Q3_10_orgparticipation 
transport_mode
car
ptransit
active
remote
multi
transport_mode1
car1
ptransit1
active1
remote1
car_transit1
car_active1
transit_active1
car_transit_active1
car_remote1
transit_remote1
remote_multi1
Q3_6_1_life_satisf 
Q3_6_2_health_satisf 
Q3_6_3_work_satisf 
Q3_6_4_personaltime_satisf 
Q3_6_5_finance_satisf 
Q2_4_nb_satisf 
Q3_4_1_overallhealth 
Q3_4_2_physicalhealth 
Q3_4_3_mentalhealth 
Q9_12_dwelling 
Q9_9_move_to_scarb 
Q9_7_engfluency 
Q9_14_tcostdiff
NIA);
VAR
/* sociodemographic variables */
Age 
Q3_8_politicalspectrum 
Q3_3_disability
Q9_2_gender
Q9_8_move_to_can
/* economic variables */
Q2_1_v_personal 
adjusted_hhincome 
Q9_5_edu 
Q9_6_ftemploy 
Q9_6_ptemploy 
Q9_6_student 
/* social variables */
Q2_6_7_unsafetraffic 
Q2_6_8_unsafecrime 
Q3_7_3_trustppl_nb
Q2_7_2_covid_ptransitrisky 
Q3_10_orgparticipation 
/* exposure variable */
transport_mode
car
ptransit
active
remote
multi
transport_mode1
car1
ptransit1
active1
remote1
car_transit1
car_active1
transit_active1
car_transit_active1
car_remote1
transit_remote1
remote_multi1
/* outcome variables */
Q3_6_1_life_satisf 
Q3_6_2_health_satisf 
Q3_6_3_work_satisf 
Q3_6_4_personaltime_satisf 
Q3_6_5_finance_satisf 
Q2_4_nb_satisf 
Q3_4_1_overallhealth 
Q3_4_2_physicalhealth 
Q3_4_3_mentalhealth 
/* auxilary variables */
Q9_10_1_hhincome_num 
Q9_4_RacialCategory_num 
Q9_12_dwelling 
Q9_9_move_to_scarb 
Q9_7_engfluency 
Q9_14_tcostdiff
NIA;
RUN;

DATA WORK.SUMO_COPY_MI2;
    SET WORK.SUMO_COPY_MI;
    WHERE _Imputation_ = 10;
RUN;

/*** Table 1 ***/

/* Age */
PROC UNIVARIATE DATA = WORK.SUMO_COPY_MI2;
  VAR Age;
  HISTOGRAM;
RUN;

PROC UNIVARIATE DATA = WORK.SUMO_COPY_MI2;
  CLASS transport_mode;
  VAR Age;
  HISTOGRAM;
RUN;

/* Political spectrum */
PROC UNIVARIATE DATA = WORK.SUMO_COPY_MI2;
  VAR Q3_8_politicalspectrum;
  HISTOGRAM;
RUN; 

PROC UNIVARIATE DATA = WORK.SUMO_COPY_MI;
  CLASS transport_mode;
  VAR Q3_8_politicalspectrum;
  HISTOGRAM;
RUN;

/* Categorical sociodemographic variables */ 
PROC FREQ DATA = WORK.SUMO_COPY_MI2;
	TABLES
	Q9_2_gender
    Q3_3_disability
	Q9_8_move_to_can
	/ MISSING;
RUN;

PROC FREQ DATA=WORK.SUMO_COPY_MI2;
  TABLES transport_mode * Q9_2_gender / MISSING;
RUN;

PROC FREQ DATA=WORK.SUMO_COPY_MI2;
  TABLES transport_mode * Q3_3_disability / MISSING;
RUN;

PROC FREQ DATA=WORK.SUMO_COPY_MI2;
  TABLES transport_mode * Q9_8_move_to_can / MISSING;
RUN;

/* Adjusted household income */ 
PROC UNIVARIATE DATA = WORK.SUMO_COPY_MI2;
  VAR adjusted_hhincome;
  HISTOGRAM;
RUN;

PROC UNIVARIATE DATA = WORK.SUMO_COPY_MI2;
  CLASS transport_mode;
  VAR adjusted_hhincome;
  HISTOGRAM;
RUN;

/* Categorical economic variables */ 
PROC FREQ DATA = WORK.SUMO_COPY_MI2;
	TABLES
	Q2_1_v_personal
	Q9_12_dwelling
    Q9_5_edu
    Q9_6_ftemploy
    Q9_6_ptemploy 
    Q9_6_student
	/ MISSING;
RUN;

PROC FREQ DATA=WORK.SUMO_COPY_MI2;
  TABLES transport_mode * Q2_1_v_personal / MISSING;
RUN;

PROC FREQ DATA=WORK.SUMO_COPY_MI2;
  TABLES transport_mode * Q9_5_edu / MISSING;
RUN;

PROC FREQ DATA=WORK.SUMO_COPY_MI2;
  TABLES transport_mode * Q9_6_ftemploy / MISSING;
RUN;

PROC FREQ DATA=WORK.SUMO_COPY_MI2;
  TABLES transport_mode * Q9_6_ptemploy / MISSING;
RUN;

PROC FREQ DATA=WORK.SUMO_COPY_MI2;
  TABLES transport_mode * Q9_6_student / MISSING;
RUN;

/* Categorical social/environment variables */
PROC FREQ DATA = WORK.SUMO_COPY_MI2;
  TABLES 
Q3_10_orgparticipation
/*Q6_1_nbtrust*/
/*Q7_8_policefunding*/
Q2_6_7_unsafetraffic
Q2_6_8_unsafecrime
Q3_7_3_trustppl_nb
Q2_7_2_covid_ptransitrisky / MISSING;
RUN;

PROC FREQ DATA=WORK.SUMO_COPY_MI2;
  TABLES transport_mode * Q3_10_orgparticipation / MISSING;
RUN;

PROC FREQ DATA=WORK.SUMO_COPY_MI2;
  TABLES transport_mode * Q2_6_7_unsafetraffic / MISSING;
RUN;

PROC FREQ DATA=WORK.SUMO_COPY_MI2;
  TABLES transport_mode * Q2_6_8_unsafecrime / MISSING;
RUN;

PROC FREQ DATA=WORK.SUMO_COPY_MI2;
  TABLES transport_mode * Q3_7_3_trustppl_nb / MISSING;
RUN;

PROC FREQ DATA=WORK.SUMO_COPY_MI2;
  TABLES transport_mode * Q2_7_2_covid_ptransitrisky / MISSING;
RUN;

/* Create histogram of continous outcome variables */
PROC UNIVARIATE DATA=WORK.SUMO_COPY_MI2;
  VAR 
  Q3_6_1_life_satisf 
  Q3_6_2_health_satisf
  Q3_6_3_work_satisf
  Q3_6_4_personaltime_satisf
  Q3_6_5_finance_satisf
  Q2_4_nb_satisf;
  HISTOGRAM;
RUN;

PROC UNIVARIATE DATA=WORK.SUMO_COPY_MI2;
  CLASS transport_mode1;
  VAR 
  Q3_6_1_life_satisf;
  HISTOGRAM;
RUN;

PROC UNIVARIATE DATA=WORK.SUMO_COPY_MI2;
  CLASS transport_mode1;
  VAR 
  Q3_6_2_health_satisf;
  HISTOGRAM;
RUN;

PROC UNIVARIATE DATA=WORK.SUMO_COPY_MI2;
  CLASS transport_mode1;
  VAR 
  Q3_6_3_work_satisf;
  HISTOGRAM;
RUN;

PROC UNIVARIATE DATA=WORK.SUMO_COPY_MI2;
  CLASS transport_mode1;
  VAR 
  Q3_6_4_personaltime_satisf;
  HISTOGRAM;
RUN;

PROC UNIVARIATE DATA=WORK.SUMO_COPY_MI2;
  CLASS transport_mode1;
  VAR 
  Q3_6_5_finance_satisf;
  HISTOGRAM;
RUN;

PROC UNIVARIATE DATA=WORK.SUMO_COPY_MI2;
  CLASS transport_mode1;
  VAR 
  Q2_4_nb_satisf;
  HISTOGRAM;
RUN;

PROC UNIVARIATE DATA=WORK.SUMO_COPY_MI2;
  VAR 
  Q3_4_1_overallhealth
  Q3_4_2_physicalhealth
  Q3_4_3_mentalhealth;
  HISTOGRAM;
RUN;

PROC UNIVARIATE DATA=WORK.SUMO_COPY_MI2;
  CLASS transport_mode1;
  VAR 
  Q3_4_1_overallhealth;
  HISTOGRAM;
RUN;

PROC UNIVARIATE DATA=WORK.SUMO_COPY_MI2;
  CLASS transport_mode1;
  VAR 
  Q3_4_3_mentalhealth;
  HISTOGRAM;
RUN;

PROC UNIVARIATE DATA=WORK.SUMO_COPY_MI2;
  CLASS transport_mode1;
  VAR 
  Q3_4_2_physicalhealth;
  HISTOGRAM;
RUN;

/*** Univariate analyses ***/

/* Age */
PROC REG DATA=WORK.SUMO_COPY;
   MODEL Q3_6_1_life_satisf = Age / VIF;
RUN; /* <.0001 */

/* Political ideology */
PROC REG DATA=WORK.SUMO_COPY;
   MODEL Q3_6_1_life_satisf = Q3_8_politicalspectrum / VIF;
RUN; /* 0.0528 */

/* Disability */
PROC REG DATA=WORK.SUMO_COPY;
   MODEL Q3_6_1_life_satisf = Q3_3_disability / VIF;
RUN; /* <.0001 */

/* Sex */
PROC REG DATA=WORK.SUMO_COPY;
   MODEL Q3_6_1_life_satisf = Q9_2_gender / VIF;
RUN; /* 0.1320 */

/* Immigration status */
PROC REG DATA=WORK.SUMO_COPY;
   MODEL Q3_6_1_life_satisf = Q9_8_move_to_can / VIF;
RUN; /* 0.4410 */

/* Car ownership */
PROC REG DATA=WORK.SUMO_COPY;
   MODEL Q3_6_1_life_satisf = Q2_1_v_personal / VIF;
RUN; /* 0.0249 */

/* Household income */
PROC REG DATA=WORK.SUMO_COPY;
   MODEL Q3_6_1_life_satisf = Q9_10_1_hhincome_num / VIF;
RUN; /* <.0001 */

/* Household type */
PROC REG DATA=WORK.SUMO_COPY;
   MODEL Q3_6_1_life_satisf = Q9_12_dwelling / VIF;
RUN; /* 0.0466 */

/* Household members */
PROC REG DATA=WORK.SUMO_COPY;
   MODEL Q3_6_1_life_satisf = Q9_3_RelationshipMembers / VIF;
RUN; /* 0.0008 */

/* Educational attainment */
PROC REG DATA=WORK.SUMO_COPY;
   MODEL Q3_6_1_life_satisf = Q9_5_edu / VIF;
RUN; /* 0.0145 */

/* Educational attainment */
PROC REG DATA=WORK.SUMO_COPY;
   MODEL Q3_6_1_life_satisf = Q9_5_edu / VIF;
RUN; /* 0.0145 */

/* Unsafe traffic */
PROC REG DATA=WORK.SUMO_COPY;
   MODEL Q3_6_1_life_satisf = Q2_6_7_unsafetraffic / VIF;
RUN; /* 0.0010 */

/* Unsafe crime */
PROC REG DATA=WORK.SUMO_COPY;
   MODEL Q3_6_1_life_satisf = Q2_6_8_unsafecrime / VIF;
RUN; /* 0.0002 */

/* Trust people in neighborhood */
PROC REG DATA=WORK.SUMO_COPY;
   MODEL Q3_6_1_life_satisf = Q3_7_3_trustppl_nb / VIF;
RUN; /* <.0001 */

/* Believe COVID-19 risk is high on public transit */
PROC REG DATA=WORK.SUMO_COPY;
   MODEL Q3_6_1_life_satisf = Q2_7_2_covid_ptransitrisky / VIF;
RUN; /* 0.1141 */

/* Transportation mode */
PROC REG DATA=WORK.SUMO_COPY;
   MODEL Q3_6_1_life_satisf = car / VIF;
RUN; /* 0.0170 */

PROC REG DATA=WORK.SUMO_COPY;
   MODEL Q3_6_1_life_satisf = ptransit / VIF;
RUN; /* 0.4348 */

PROC REG DATA=WORK.SUMO_COPY;
   MODEL Q3_6_1_life_satisf = active / VIF;
RUN; /* 0.5322 */

PROC REG DATA=WORK.SUMO_COPY;
   MODEL Q3_6_1_life_satisf = remote / VIF;
RUN; /* 0.9249 */

PROC REG DATA=WORK.SUMO_COPY;
   MODEL Q3_6_1_life_satisf = multi / VIF;
RUN; /* 0.0600 */

PROC REG DATA=WORK.SUMO_COPY;
   MODEL Q3_6_1_life_satisf = Q3_4_1_overallhealth / VIF;
RUN; /* <.0001 */

/*** Complete Case Analysis ***/

/* Linear regression */
PROC REG DATA=WORK.SUMO_COPY_MI2;
   MODEL Q3_6_1_life_satisf = ptransit active remote multi;
RUN;

PROC REG DATA=WORK.SUMO_COPY_MI2;
   MODEL Q3_6_1_life_satisf = car1 ptransit1 active1 remote1 car_transit1 car_active1 transit_active1 car_transit_active1 car_remote1 transit_remote1 remote_multi1;
RUN;

/* ANOVA */
PROC GLM DATA=WORK.SUMO_COPY;
   CLASS transport_mode1;
   MODEL Q3_6_1_life_satisf = transport_mode;
RUN; /* 0.1410 */

/* LIFE SATISFACTION */

/* Unadjusted Model */
TITLE "MULTIPLE IMPUTATION LINEAR REGRESSION LIFE SATISFACTION UNADJUSTED";
PROC REG DATA = SUMO_COPY_MI;
MODEL Q3_6_1_life_satisf = ptransit active remote multi;
BY _imputation_;
ODS OUTPUT ParameterEstimates = A_SUMO;
RUN;

PROC MIANALYZE PARMS = WORK.A_SUMO;
MODELEFFECTS intercept ptransit active remote multi;
RUN;

/* Adjusted Model 1 */
TITLE "MULTIPLE IMPUTATION LINEAR REGRESSION LIFE SATISFACTION ADJUSTED MODEL 1";
PROC REG DATA = SUMO_COPY_MI;
MODEL Q3_6_1_life_satisf = ptransit active remote multi Age Q9_2_gender;
BY _imputation_;
ODS OUTPUT ParameterEstimates = A_SUMO;
RUN;

PROC MIANALYZE PARMS = WORK.A_SUMO;
MODELEFFECTS intercept ptransit active remote multi Age Q9_2_gender;
RUN;

/* Adjusted Model 2 */
TITLE "MULTIPLE IMPUTATION LINEAR REGRESSION LIFE SATISFACTION ADJUSTED MODEL 2";
PROC REG DATA = SUMO_COPY_MI;
MODEL Q3_6_1_life_satisf = ptransit active remote multi Age Q3_8_politicalspectrum Q3_3_disability Q9_2_gender 
      Q9_8_move_to_can Q2_1_v_personal adjusted_hhincome Q9_5_edu Q9_6_ftemploy Q9_6_ptemploy Q9_6_student;
BY _imputation_;
ODS OUTPUT ParameterEstimates = A_SUMO;
RUN;

PROC MIANALYZE PARMS = WORK.A_SUMO;
MODELEFFECTS intercept ptransit active remote multi Age Q3_8_politicalspectrum Q3_3_disability Q9_2_gender 
      Q9_8_move_to_can Q2_1_v_personal adjusted_hhincome Q9_5_edu Q9_6_ftemploy Q9_6_ptemploy Q9_6_student;
RUN;

/* Adjusted Model 3 */
TITLE "MULTIPLE IMPUTATION LINEAR REGRESSION LIFE SATISFACTION ADJUSTED MODEL 3";
PROC REG DATA = SUMO_COPY_MI;
MODEL Q3_6_1_life_satisf = ptransit active remote multi Age Q3_8_politicalspectrum Q3_3_disability Q9_2_gender 
      Q9_8_move_to_can Q2_1_v_personal adjusted_hhincome Q9_5_edu Q9_6_ftemploy Q9_6_ptemploy Q9_6_student
      Q2_6_7_unsafetraffic Q2_6_8_unsafecrime Q3_7_3_trustppl_nb Q2_7_2_covid_ptransitrisky Q3_10_orgparticipation;
BY _imputation_;
ODS OUTPUT ParameterEstimates = A_SUMO;
RUN;

PROC MIANALYZE PARMS = WORK.A_SUMO;
MODELEFFECTS intercept ptransit active remote multi Age Q3_8_politicalspectrum Q3_3_disability Q9_2_gender 
      Q9_8_move_to_can Q2_1_v_personal adjusted_hhincome Q9_5_edu Q9_6_ftemploy Q9_6_ptemploy Q9_6_student
      Q2_6_7_unsafetraffic Q2_6_8_unsafecrime Q3_7_3_trustppl_nb Q2_7_2_covid_ptransitrisky Q3_10_orgparticipation;
RUN;

/* PERCIEVED MENTAL HEALTH */

/* Unadjusted Model */
TITLE "MULTIPLE IMPUTATION LINEAR REGRESSION MH UNADJUSTED";
PROC REG DATA = SUMO_COPY_MI;
MODEL Q3_4_3_mentalhealth = ptransit active remote multi;
BY _imputation_;
ODS OUTPUT ParameterEstimates = A_SUMO;
RUN;

PROC MIANALYZE PARMS = WORK.A_SUMO;
MODELEFFECTS intercept ptransit active remote multi;
RUN;

/* Adjusted Model 1 */
TITLE "MULTIPLE IMPUTATION LINEAR REGRESSION MH ADJUSTED MODEL 1";
PROC REG DATA = SUMO_COPY_MI;
MODEL Q3_4_3_mentalhealth = ptransit active remote multi Age Q9_2_gender;
BY _imputation_;
ODS OUTPUT ParameterEstimates = A_SUMO;
RUN;

PROC MIANALYZE PARMS = WORK.A_SUMO;
MODELEFFECTS intercept ptransit active remote multi Age Q9_2_gender;
RUN;

/* Adjusted Model 2 */
TITLE "MULTIPLE IMPUTATION LINEAR REGRESSION MH ADJUSTED MODEL 2";
PROC REG DATA = SUMO_COPY_MI;
MODEL Q3_4_3_mentalhealth = ptransit active remote multi Age Q3_8_politicalspectrum Q3_3_disability Q9_2_gender 
      Q9_8_move_to_can Q2_1_v_personal adjusted_hhincome Q9_5_edu Q9_6_ftemploy Q9_6_ptemploy Q9_6_student;
BY _imputation_;
ODS OUTPUT ParameterEstimates = A_SUMO;
RUN;

PROC MIANALYZE PARMS = WORK.A_SUMO;
MODELEFFECTS intercept ptransit active remote multi Age Q3_8_politicalspectrum Q3_3_disability Q9_2_gender 
      Q9_8_move_to_can Q2_1_v_personal adjusted_hhincome Q9_5_edu Q9_6_ftemploy Q9_6_ptemploy Q9_6_student;
RUN;

/* Adjusted Model 3 */
TITLE "MULTIPLE IMPUTATION LINEAR REGRESSION MH ADJUSTED MODEL 3";
PROC REG DATA = SUMO_COPY_MI;
MODEL Q3_4_3_mentalhealth = ptransit active remote multi Age Q3_8_politicalspectrum Q3_3_disability Q9_2_gender 
      Q9_8_move_to_can Q2_1_v_personal adjusted_hhincome Q9_5_edu Q9_6_ftemploy Q9_6_ptemploy Q9_6_student
      Q2_6_7_unsafetraffic Q2_6_8_unsafecrime Q3_7_3_trustppl_nb Q2_7_2_covid_ptransitrisky Q3_10_orgparticipation;
BY _imputation_;
ODS OUTPUT ParameterEstimates = A_SUMO;
RUN;

PROC MIANALYZE PARMS = WORK.A_SUMO;
MODELEFFECTS intercept ptransit active remote multi Age Q3_8_politicalspectrum Q3_3_disability Q9_2_gender 
      Q9_8_move_to_can Q2_1_v_personal adjusted_hhincome Q9_5_edu Q9_6_ftemploy Q9_6_ptemploy Q9_6_student
      Q2_6_7_unsafetraffic Q2_6_8_unsafecrime Q3_7_3_trustppl_nb Q2_7_2_covid_ptransitrisky Q3_10_orgparticipation;
RUN;

/* PERCIEVED PHYSICAL HEALTH */

/* Unadjusted Model */
TITLE "MULTIPLE IMPUTATION LINEAR REGRESSION PH UNADJUSTED";
PROC REG DATA = SUMO_COPY_MI;
MODEL Q3_4_2_physicalhealth = ptransit active remote multi;
BY _imputation_;
ODS OUTPUT ParameterEstimates = A_SUMO;
RUN;

PROC MIANALYZE PARMS = WORK.A_SUMO;
MODELEFFECTS intercept ptransit active remote multi;
RUN;

/* Adjusted Model 1 */
TITLE "MULTIPLE IMPUTATION LINEAR REGRESSION PH ADJUSTED MODEL 1";
PROC REG DATA = SUMO_COPY_MI;
MODEL Q3_4_2_physicalhealth = ptransit active remote multi Age Q9_2_gender;
BY _imputation_;
ODS OUTPUT ParameterEstimates = A_SUMO;
RUN;

PROC MIANALYZE PARMS = WORK.A_SUMO;
MODELEFFECTS intercept ptransit active remote multi Age Q9_2_gender;
RUN;

/* Adjusted Model 2 */
TITLE "MULTIPLE IMPUTATION LINEAR REGRESSION PH ADJUSTED MODEL 2";
PROC REG DATA = SUMO_COPY_MI;
MODEL Q3_4_2_physicalhealth = ptransit active remote multi Age Q3_8_politicalspectrum Q3_3_disability Q9_2_gender 
      Q9_8_move_to_can Q2_1_v_personal adjusted_hhincome Q9_5_edu Q9_6_ftemploy Q9_6_ptemploy Q9_6_student;
BY _imputation_;
ODS OUTPUT ParameterEstimates = A_SUMO;
RUN;

PROC MIANALYZE PARMS = WORK.A_SUMO;
MODELEFFECTS intercept ptransit active remote multi Age Q3_8_politicalspectrum Q3_3_disability Q9_2_gender 
      Q9_8_move_to_can Q2_1_v_personal adjusted_hhincome Q9_5_edu Q9_6_ftemploy Q9_6_ptemploy Q9_6_student;
RUN;

/* Adjusted Model 3 */
TITLE "MULTIPLE IMPUTATION LINEAR REGRESSION PH ADJUSTED MODEL 3";
PROC REG DATA = SUMO_COPY_MI;
MODEL Q3_4_2_physicalhealth = ptransit active remote multi Age Q3_8_politicalspectrum Q3_3_disability Q9_2_gender 
      Q9_8_move_to_can Q2_1_v_personal adjusted_hhincome Q9_5_edu Q9_6_ftemploy Q9_6_ptemploy Q9_6_student
      Q2_6_7_unsafetraffic Q2_6_8_unsafecrime Q3_7_3_trustppl_nb Q2_7_2_covid_ptransitrisky Q3_10_orgparticipation;
BY _imputation_;
ODS OUTPUT ParameterEstimates = A_SUMO;
RUN;

PROC MIANALYZE PARMS = WORK.A_SUMO;
MODELEFFECTS intercept ptransit active remote multi Age Q3_8_politicalspectrum Q3_3_disability Q9_2_gender 
      Q9_8_move_to_can Q2_1_v_personal adjusted_hhincome Q9_5_edu Q9_6_ftemploy Q9_6_ptemploy Q9_6_student
      Q2_6_7_unsafetraffic Q2_6_8_unsafecrime Q3_7_3_trustppl_nb Q2_7_2_covid_ptransitrisky Q3_10_orgparticipation;
RUN;

/* WORK SATISFACTION */

/* Unadjusted Model */
TITLE "MULTIPLE IMPUTATION LINEAR REGRESSION WORK SATISFACTION UNADJUSTED";
PROC REG DATA = SUMO_COPY_MI;
MODEL Q3_6_3_work_satisf = ptransit active remote multi;
BY _imputation_;
ODS OUTPUT ParameterEstimates = A_SUMO;
RUN;

PROC MIANALYZE PARMS = WORK.A_SUMO;
MODELEFFECTS intercept ptransit active remote multi;
RUN;

/* Adjusted Model 1 */
TITLE "MULTIPLE IMPUTATION LINEAR REGRESSION WORK SATISFACTION ADJUSTED MODEL 1";
PROC REG DATA = SUMO_COPY_MI;
MODEL Q3_6_3_work_satisf = ptransit active remote multi Age Q9_2_gender;
BY _imputation_;
ODS OUTPUT ParameterEstimates = A_SUMO;
RUN;

PROC MIANALYZE PARMS = WORK.A_SUMO;
MODELEFFECTS intercept ptransit active remote multi Age Q9_2_gender;
RUN;

/* Adjusted Model 2 */
TITLE "MULTIPLE IMPUTATION LINEAR REGRESSION WORK SATISFACTION ADJUSTED MODEL 2";
PROC REG DATA = SUMO_COPY_MI;
MODEL Q3_6_3_work_satisf = ptransit active remote multi Age Q3_8_politicalspectrum Q3_3_disability Q9_2_gender 
      Q9_8_move_to_can Q2_1_v_personal adjusted_hhincome Q9_5_edu Q9_6_ftemploy Q9_6_ptemploy Q9_6_student;
BY _imputation_;
ODS OUTPUT ParameterEstimates = A_SUMO;
RUN;

PROC MIANALYZE PARMS = WORK.A_SUMO;
MODELEFFECTS intercept ptransit active remote multi Age Q3_8_politicalspectrum Q3_3_disability Q9_2_gender 
      Q9_8_move_to_can Q2_1_v_personal adjusted_hhincome Q9_5_edu Q9_6_ftemploy Q9_6_ptemploy Q9_6_student;
RUN;

/* Adjusted Model 3 */
TITLE "MULTIPLE IMPUTATION LINEAR REGRESSION WORK SATISFACTION ADJUSTED MODEL 3";
PROC REG DATA = SUMO_COPY_MI;
MODEL Q3_6_3_work_satisf = ptransit active remote multi Age Q3_8_politicalspectrum Q3_3_disability Q9_2_gender 
      Q9_8_move_to_can Q2_1_v_personal adjusted_hhincome Q9_5_edu Q9_6_ftemploy Q9_6_ptemploy Q9_6_student
      Q2_6_7_unsafetraffic Q2_6_8_unsafecrime Q3_7_3_trustppl_nb Q2_7_2_covid_ptransitrisky Q3_10_orgparticipation;
BY _imputation_;
ODS OUTPUT ParameterEstimates = A_SUMO;
RUN;

PROC MIANALYZE PARMS = WORK.A_SUMO;
MODELEFFECTS intercept ptransit active remote multi Age Q3_8_politicalspectrum Q3_3_disability Q9_2_gender 
      Q9_8_move_to_can Q2_1_v_personal adjusted_hhincome Q9_5_edu Q9_6_ftemploy Q9_6_ptemploy Q9_6_student
      Q2_6_7_unsafetraffic Q2_6_8_unsafecrime Q3_7_3_trustppl_nb Q2_7_2_covid_ptransitrisky Q3_10_orgparticipation;
RUN;
