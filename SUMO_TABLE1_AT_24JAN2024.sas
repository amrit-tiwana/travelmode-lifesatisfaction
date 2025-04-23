 /*********************************************************************************/
*** SuMo Cluster Table 1
***
*** Association between transport mode to work/educ and life satisfaction				
***
*** Author: Amrit Tiwana		
*** 			
*** Date: March 7, 2024		
***	
/*********************************************************************************/;

/* Age */
PROC UNIVARIATE DATA = WORK.SUMO_COPY;
  VAR Age;
  HISTOGRAM;
RUN;

PROC UNIVARIATE DATA = WORK.SUMO_COPY;
  CLASS transport_mode;
  VAR Age;
  HISTOGRAM;
RUN;

/* Political spectrum */
PROC UNIVARIATE DATA = WORK.SUMO_COPY;
  VAR Q3_8_politicalspectrum;
  HISTOGRAM;
RUN; 

PROC UNIVARIATE DATA = WORK.SUMO_COPY;
  CLASS transport_mode;
  VAR Q3_8_politicalspectrum;
  HISTOGRAM;
RUN;

/* Categorical sociodemographic variables */ 
PROC FREQ DATA = WORK.SUMO_COPY;
	TABLES
	Q9_2_gender
    Q3_3_disability
	Q9_8_move_to_can
	/ MISSING;
RUN;

PROC FREQ DATA=WORK.SUMO_COPY;
  TABLES transport_mode * Q9_2_gender / MISSING;
RUN;

PROC FREQ DATA=WORK.SUMO_COPY;
  TABLES transport_mode * Q3_3_disability / MISSING;
RUN;

PROC FREQ DATA=WORK.SUMO_COPY;
  TABLES transport_mode * Q9_8_move_to_can / MISSING;
RUN;

/* Adjusted household income */ 
PROC UNIVARIATE DATA = WORK.SUMO_COPY;
  VAR adjusted_hhincome;
  HISTOGRAM;
RUN;

PROC UNIVARIATE DATA = WORK.SUMO_COPY;
  CLASS transport_mode;
  VAR adjusted_hhincome;
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
    Q9_6_student
	/ MISSING;
RUN;

PROC FREQ DATA=WORK.SUMO_COPY;
  TABLES transport_mode * Q2_1_v_personal / MISSING;
RUN;

PROC FREQ DATA=WORK.SUMO_COPY;
  TABLES transport_mode * Q9_5_edu / MISSING;
RUN;

PROC FREQ DATA=WORK.SUMO_COPY;
  TABLES transport_mode * Q9_6_ftemploy / MISSING;
RUN;

PROC FREQ DATA=WORK.SUMO_COPY;
  TABLES transport_mode * Q9_6_ptemploy / MISSING;
RUN;

PROC FREQ DATA=WORK.SUMO_COPY;
  TABLES transport_mode * Q9_6_student / MISSING;
RUN;

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

PROC FREQ DATA=WORK.SUMO_COPY;
  TABLES transport_mode * Q3_10_orgparticipation / MISSING;
RUN;

PROC FREQ DATA=WORK.SUMO_COPY;
  TABLES transport_mode * Q2_6_7_unsafetraffic / MISSING;
RUN;

PROC FREQ DATA=WORK.SUMO_COPY;
  TABLES transport_mode * Q2_6_8_unsafecrime / MISSING;
RUN;

PROC FREQ DATA=WORK.SUMO_COPY;
  TABLES transport_mode * Q3_7_3_trustppl_nb / MISSING;
RUN;

PROC FREQ DATA=WORK.SUMO_COPY;
  TABLES transport_mode * Q2_7_2_covid_ptransitrisky / MISSING;
RUN;

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
  CLASS transport_mode;
  VAR 
  Q3_6_1_life_satisf;
  HISTOGRAM;
RUN;

PROC UNIVARIATE DATA = WORK.SUMO_COPY;
  CLASS transport_mode;
  VAR 
  Q3_6_2_health_satisf;
  HISTOGRAM;
RUN;

PROC UNIVARIATE DATA = WORK.SUMO_COPY;
  CLASS transport_mode;
  VAR 
  Q3_6_3_work_satisf;
  HISTOGRAM;
RUN;

PROC UNIVARIATE DATA = WORK.SUMO_COPY;
  CLASS transport_mode;
  VAR 
  Q3_6_4_personaltime_satisf;
  HISTOGRAM;
RUN;

PROC UNIVARIATE DATA = WORK.SUMO_COPY;
  CLASS transport_mode;
  VAR 
  Q3_6_5_finance_satisf;
  HISTOGRAM;
RUN;

PROC UNIVARIATE DATA = WORK.SUMO_COPY;
  CLASS transport_mode;
  VAR 
  Q2_4_nb_satisf;
  HISTOGRAM;
RUN;

PROC UNIVARIATE DATA = WORK.SUMO_COPY;
  VAR 
  Q3_4_1_overallhealth
  Q3_4_2_physicalhealth
  Q3_4_3_mentalhealth;
  HISTOGRAM;
RUN;

PROC UNIVARIATE DATA = WORK.SUMO_COPY;
  CLASS transport_mode;
  VAR 
  Q3_4_1_overallhealth;
  HISTOGRAM;
RUN;

PROC UNIVARIATE DATA = WORK.SUMO_COPY;
  CLASS transport_mode;
  VAR 
  Q3_4_3_mentalhealth;
  HISTOGRAM;
RUN;

PROC UNIVARIATE DATA = WORK.SUMO_COPY;
  CLASS transport_mode;
  VAR 
  Q3_4_2_physicalhealth;
  HISTOGRAM;
RUN;
