CREATE DATABASE IF NOT EXISTS `omop_cdm` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

/* Use the database */
USE `omop_cdm`;

CREATE TABLE IF NOT EXISTS `person` (
  `person_id` BIGINT NOT NULL,
  `gender_concept_id` BIGINT NOT NULL,
  `year_of_birth` BIGINT NOT NULL,
  `month_of_birth` BIGINT DEFAULT NULL,
  `day_of_birth` BIGINT DEFAULT NULL,
  `birth_datetime` DATETIME DEFAULT NULL,
  `race_concept_id` BIGINT DEFAULT NULL,
  `ethnicity_concept_id` BIGINT DEFAULT NULL,
  `location_id` BIGINT DEFAULT NULL,
  `provider_id` BIGINT DEFAULT NULL,
  `care_site_id` BIGINT DEFAULT NULL,
  `person_source_value` VARCHAR(50) DEFAULT NULL,
  `gender_source_value` VARCHAR(50) DEFAULT NULL,
  `gender_source_concept_id` BIGINT DEFAULT NULL,
  `race_source_value` VARCHAR(50) DEFAULT NULL,
  `race_source_concept_id` BIGINT DEFAULT NULL,
  `ethnicity_source_value` VARCHAR(50) DEFAULT NULL,
  `ethnicity_source_concept_id` BIGINT DEFAULT NULL,
  CONSTRAINT `xpk_person` PRIMARY KEY NONCLUSTERED (`person_id`)
);
ALTER TABLE person
ADD CONSTRAINT fk_person_gender_concept FOREIGN KEY (gender_concept_id)
    REFERENCES concept (concept_id),
ADD CONSTRAINT fk_person_race_concept FOREIGN KEY (race_concept_id)
    REFERENCES concept (concept_id),
ADD CONSTRAINT fk_person_ethnicity_concept FOREIGN KEY (ethnicity_concept_id)
    REFERENCES concept (concept_id),
ADD CONSTRAINT fk_person_provider FOREIGN KEY (provider_id)
    REFERENCES provider (provider_id),
ADD CONSTRAINT fk_person_care_site FOREIGN KEY (care_site_id)
    REFERENCES care_site (care_site_id);

CREATE TABLE IF NOT EXISTS `death` (
  `person_id` BIGINT NOT NULL,
  `death_date` DATETIME NOT NULL,
  `death_type_concept_id` BIGINT NOT NULL,
  `cause_concept_id` BIGINT DEFAULT NULL,
  `cause_source_value` VARCHAR(50) DEFAULT NULL,
  `cause_source_concept_id` BIGINT DEFAULT NULL,
  `cause_type_concept_id` BIGINT DEFAULT NULL,
  CONSTRAINT `xpk_death` PRIMARY KEY (`person_id`)
);
ALTER table death
ADD CONSTRAINT `fk_death_person` FOREIGN KEY (`person_id`) REFERENCES `person` (`person_id`),
 ADD CONSTRAINT `fk_death_death_type_concept` FOREIGN KEY (`death_type_concept_id`) REFERENCES `concept` (`concept_id`),
 ADD CONSTRAINT `fk_death_cause_concept` FOREIGN KEY (`cause_concept_id`) REFERENCES `concept` (`concept_id`);

CREATE TABLE IF NOT EXISTS `visit_occurrence` (
  `visit_occurrence_id` BIGINT NOT NULL,
  `person_id` BIGINT NOT NULL,
  `visit_concept_id` BIGINT NOT NULL,
  `visit_start_date` DATETIME NOT NULL,
  `visit_end_date` DATETIME DEFAULT NULL,
  `visit_type_concept_id` BIGINT NOT NULL,
  `provider_id` BIGINT DEFAULT NULL,
  `care_site_id` BIGINT DEFAULT NULL,
  `visit_source_value` VARCHAR(50) DEFAULT NULL,
  `visit_source_concept_id` BIGINT DEFAULT NULL,
  `admitting_source_concept_id` BIGINT DEFAULT NULL,
  `discharge_to_concept_id` BIGINT DEFAULT NULL,
  `preceding_visit_occurrence_id` BIGINT DEFAULT NULL,
  CONSTRAINT `xpk_visit_occurrence` PRIMARY KEY NONCLUSTERED (`visit_occurrence_id`)
);
ALTER table visit_occurrence
ADD CONSTRAINT fk_visit_occurrence_person FOREIGN KEY (person_id) REFERENCES person (person_id),
   ADD CONSTRAINT fk_visit_occurrence_concept FOREIGN KEY (visit_concept_id) REFERENCES concept (concept_id),
   ADD CONSTRAINT fk_visit_occurrence_type_concept FOREIGN KEY (visit_type_concept_id) REFERENCES concept (concept_id),
   ADD CONSTRAINT fk_visit_occurrence_provider FOREIGN KEY (provider_id) REFERENCES provider (provider_id),
   ADD CONSTRAINT fk_visit_occurrence_care_site FOREIGN KEY (care_site_id) REFERENCES care_site (care_site_id),
   ADD CONSTRAINT fk_visit_occurrence_visit_source_concept FOREIGN KEY (visit_source_concept_id) REFERENCES concept (concept_id),
  ADD  CONSTRAINT fk_visit_occurrence_admitting_source_concept FOREIGN KEY (admitting_source_concept_id) REFERENCES concept (concept_id),
   ADD CONSTRAINT fk_visit_occurrence_discharge_to_concept FOREIGN KEY (discharge_to_concept_id) REFERENCES concept (concept_id),
   ADD CONSTRAINT fk_visit_occurrence_preceding_visit FOREIGN KEY (preceding_visit_occurrence_id) REFERENCES visit_occurrence (visit_occurrence_id);


CREATE TABLE IF NOT EXISTS `concept` (
  `concept_id` BIGINT NOT NULL,
  `concept_name` VARCHAR(255) NOT NULL,
  `domain_id` VARCHAR(20) NOT NULL,
  `vocabulary_id` VARCHAR(20) NOT NULL,
  `concept_class_id` VARCHAR(20) NOT NULL,
  `standard_concept` VARCHAR(1) DEFAULT NULL,
  `concept_code` VARCHAR(50) NOT NULL,
  `valid_start_date` DATE NOT NULL,
  `valid_end_date` DATE NOT NULL,
  `invalid_reason` VARCHAR(1) DEFAULT NULL,
  PRIMARY KEY (`concept_id`)
);

ALTER table concept 
ADD
CREATE TABLE IF NOT EXISTS `vocabulary` (
  `vocabulary_id` VARCHAR(20) NOT NULL,
  `vocabulary_name` VARCHAR(255) NOT NULL,
  `vocabulary_reference` VARCHAR(255) DEFAULT NULL,
  PRIMARY KEY (`vocabulary_id`)
);
ALTER table

CREATE TABLE IF NOT EXISTS `domain` (
  `domain_id` VARCHAR(20) NOT NULL,
  `domain_name` VARCHAR(255) NOT NULL,
  `domain_concept_id` BIGINT NOT NULL,
  PRIMARY KEY (`domain_id`)
);
ALTER table

CREATE TABLE IF NOT EXISTS drug_exposure (
drug_exposure_id BIGINT NOT NULL,
person_id BIGINT NOT NULL,
drug_concept_id BIGINT NOT NULL,
drug_exposure_start_date DATETIME NOT NULL,
drug_exposure_end_date DATETIME DEFAULT NULL,
verbatim_end_date VARCHAR(20) DEFAULT NULL,
drug_type_concept_id BIGINT NOT NULL,
stop_reason VARCHAR(20) DEFAULT NULL,
refills BIGINT DEFAULT NULL,
quantity DOUBLE DEFAULT NULL,
days_supply BIGINT DEFAULT NULL,
sig VARCHAR(500) DEFAULT NULL,
route_concept_id BIGINT DEFAULT NULL,
lot_number VARCHAR(50) DEFAULT NULL,
provider_id BIGINT DEFAULT NULL,
visit_occurrence_id BIGINT DEFAULT NULL,
drug_source_value VARCHAR(50) DEFAULT NULL,
drug_source_concept_id BIGINT DEFAULT NULL,
route_source_value VARCHAR(50) DEFAULT NULL,
dose_unit_source_value VARCHAR(50) DEFAULT NULL,
CONSTRAINT xpk_DRUG_EXPOSURE PRIMARY KEY NONCLUSTERED (drug_exposure_id)
);
ALTER table drug_exposure
ADD CONSTRAINT `fk_drug_exposure_person` FOREIGN KEY (`person_id`)
    REFERENCES `person` (`person_id`),
  ADD CONSTRAINT `fk_drug_exposure_concept` FOREIGN KEY (`drug_concept_id`)
    REFERENCES `concept` (`concept_id`),
  ADD CONSTRAINT `fk_drug_exposure_type_concept` FOREIGN KEY (`drug_type_concept_id`)
    REFERENCES `concept` (`concept_id`),
  ADD CONSTRAINT `fk_drug_exposure_route_concept` FOREIGN KEY (`route_concept_id`)
    REFERENCES `concept` (`concept_id`),
  ADD CONSTRAINT `fk_drug_exposure_provider` FOREIGN KEY (`provider_id`)
    REFERENCES `provider` (`provider_id`),
  ADD CONSTRAINT `fk_drug_exposure_visit_occurrence` FOREIGN KEY (`visit_occurrence_id`)
    REFERENCES `visit_occurrence` (`visit_occurrence_id`);

CREATE TABLE IF NOT EXISTS procedure_occurrence (
procedure_occurrence_id BIGINT NOT NULL,
person_id BIGINT NOT NULL,
procedure_concept_id BIGINT NOT NULL,
procedure_date DATETIME NOT NULL,
procedure_type_concept_id BIGINT NOT NULL,
modifier_concept_id BIGINT DEFAULT NULL,
quantity BIGINT DEFAULT NULL,
provider_id BIGINT DEFAULT NULL,
visit_occurrence_id BIGINT DEFAULT NULL,
procedure_source_value VARCHAR(50) DEFAULT NULL,
procedure_source_concept_id BIGINT DEFAULT NULL,
CONSTRAINT xpk_procedure_occurrence PRIMARY KEY NONCLUSTERED (procedure_occurrence_id)
);
ALTER table procedure_occurrence
ADD visit_detail_id BIGINT NOT NULL,
ADD CONSTRAINT `fk_procedure_occurrence_person` FOREIGN KEY (`person_id`)
    REFERENCES `person` (`person_id`),
 ADD CONSTRAINT `fk_procedure_occurrence_concept` FOREIGN KEY (`procedure_concept_id`)
    REFERENCES `concept` (`concept_id`),
 ADD CONSTRAINT `fk_procedure_occurrence_type_concept` FOREIGN KEY (`procedure_type_concept_id`)
    REFERENCES `concept` (`concept_id`),
 ADD CONSTRAINT `fk_procedure_occurrence_modifier_concept` FOREIGN KEY (`modifier_concept_id`)
    REFERENCES `concept` (`concept_id`),
 ADD CONSTRAINT `fk_procedure_occurrence_provider` FOREIGN KEY (`provider_id`)
    REFERENCES `provider` (`provider_id`),
 ADD CONSTRAINT `fk_procedure_occurrence_visit_occurrence` FOREIGN KEY (`visit_occurrence_id`)
    REFERENCES `visit_occurrence` (`visit_occurrence_id`),
 ADD CONSTRAINT `fk_procedure_occurrence_visit_detail` FOREIGN KEY (`visit_detail_id`)
    REFERENCES `visit_detail` (`visit_detail_id`);


CREATE TABLE IF NOT EXISTS attribute_definition (
attribute_definition_id BIGINT NOT NULL AUTO_INCREMENT,
attribute_name VARCHAR(255) NOT NULL,
attribute_description VARCHAR(4000) DEFAULT NULL,
attribute_type_concept_id BIGINT NOT NULL,
attribute_syntax VARCHAR(255) DEFAULT NULL,
attribute_order BIGINT DEFAULT NULL,
attribute_example VARCHAR(255) DEFAULT NULL,
attribute_units VARCHAR(50) DEFAULT NULL,
attribute_value_as_concept_id BIGINT DEFAULT NULL,
CONSTRAINT xpk_attribute_definition PRIMARY KEY NONCLUSTERED (attribute_definition_id)
);


CREATE TABLE IF NOT EXISTS care_site (
care_site_id BIGINT NOT NULL AUTO_INCREMENT,
care_site_name VARCHAR(255) NOT NULL,
place_of_service_concept_id BIGINT DEFAULT NULL,
location_id BIGINT(20) DEFAULT NULL,
care_site_source_value VARCHAR(50) DEFAULT NULL,
place_of_service_source_value VARCHAR(50) DEFAULT NULL,
CONSTRAINT xpk_care_site PRIMARY KEY NONCLUSTERED (care_site_id)
);
ALTER table care_site
ADD CONSTRAINT `fk_place_of_service_concept_id` FOREIGN KEY (`place_of_service_concept_id`)
REFERENCES `concept` (`concept_id`);

/*CREATE TABLE IF NOT EXISTS cdm_source (
cdm_source_id BIGINT NOT NULL AUTO_INCREMENT,
cdm_source_name VARCHAR(255) NOT NULL,
cdm_source_abbreviation VARCHAR(25) DEFAULT NULL,
cdm_holder VARCHAR(255) NOT NULL,
source_description VARCHAR(4000) DEFAULT NULL,
source_documentation_reference VARCHAR(255) DEFAULT NULL,
CONSTRAINT xpk_cdm_source PRIMARY KEY NONCLUSTERED (cdm_source_id)
);

ALTER table*/


CREATE TABLE IF NOT EXISTS cohort (
cohort_definition_id BIGINT NOT NULL AUTO_INCREMENT,
cohort_name VARCHAR(255) NOT NULL,
cohort_description VARCHAR(4000) DEFAULT NULL,
definition_type_concept_id BIGINT NOT NULL,
cohort_definition TEXT NOT NULL,
subject_id BIGINT DEFAULT NULL,
cohort_start_date DATETIME DEFAULT NULL,
cohort_end_date DATETIME DEFAULT NULL,
CONSTRAINT xpk_cohort PRIMARY KEY NONCLUSTERED (cohort_definition_id)
);

ALTER table cohort
ADD CONSTRAINT `fk_cohort_cohort_definition` FOREIGN KEY (`cohort_definition_id`) REFERENCES `cohort_definition` (`cohort_definition_id`),
 ADD CONSTRAINT `fk_cohort_person` FOREIGN KEY (`subject_id`) REFERENCES `person` (`person_id`);


CREATE TABLE IF NOT EXISTS cohort_attribute (
cohort_definition_id BIGINT NOT NULL,
attribute_name VARCHAR(255) NOT NULL,
attribute_value VARCHAR(4000) DEFAULT NULL,
CONSTRAINT xpk_cohort_attribute PRIMARY KEY NONCLUSTERED (cohort_definition_id, attribute_name),
CONSTRAINT fk_cohort_attribute_cohort_definition_id FOREIGN KEY (cohort_definition_id) REFERENCES cohort (cohort_definition_id)
);

ALTER TABLE cohort_attribute
ADD CONSTRAINT `fk_cohort_attribute_cohort_definition` FOREIGN KEY (`cohort_definition_id`) REFERENCES `cohort_definition` (`cohort_definition_id`);

CREATE TABLE IF NOT EXISTS cohort_definition (
cohort_definition_id BIGINT NOT NULL AUTO_INCREMENT,
cohort_definition_name VARCHAR(255) NOT NULL,
cohort_definition_description VARCHAR(4000) DEFAULT NULL,
definition_type_concept_id BIGINT NOT NULL,
cohort_definition TEXT NOT NULL,
cohort_initiation_date DATETIME DEFAULT NULL,
cohort_inclusion_rule TEXT DEFAULT NULL,
cohort_exclusion_rule TEXT DEFAULT NULL,
CONSTRAINT xpk_cohort_definition PRIMARY KEY NONCLUSTERED (cohort_definition_id)
);

ALTER TABLE cohort_definition
ADD CONSTRAINT fk_cohort_definition_person FOREIGN KEY (cohort_definition_id) REFERENCES person (person_id);


CREATE TABLE IF NOT EXISTS visit_detail (
visit_detail_id BIGINT NOT NULL AUTO_INCREMENT,
person_id BIGINT NOT NULL,
visit_occurrence_id BIGINT NOT NULL,
visit_detail_concept_id BIGINT NOT NULL,
visit_detail_start_datetime DATETIME NOT NULL,
visit_detail_end_datetime DATETIME DEFAULT NULL,
visit_detail_type_concept_id BIGINT NOT NULL,
provider_id BIGINT DEFAULT NULL,
care_site_id BIGINT DEFAULT NULL,
visit_detail_source_value VARCHAR(50) DEFAULT NULL,
visit_detail_source_concept_id BIGINT DEFAULT NULL,
CONSTRAINT xpk_visit_detail PRIMARY KEY NONCLUSTERED (visit_detail_id)
);

ALTER table visit_detail
MODIFY visit_detail_concept_id BIGINT NOT NULL,
ADD CONSTRAINT `fk_visit_detail_visit_occurrence` FOREIGN KEY (`visit_occurrence_id`)
    REFERENCES `visit_occurrence` (`visit_occurrence_id`),
 ADD CONSTRAINT `fk_visit_detail_concept` FOREIGN KEY (`visit_detail_concept_id`)
    REFERENCES `concept` (`concept_id`),
 ADD CONSTRAINT `fk_visit_detail_type_concept` FOREIGN KEY (`visit_detail_type_concept_id`)
    REFERENCES `concept` (`concept_id`),
 ADD CONSTRAINT `fk_visit_detail_provider` FOREIGN KEY (`provider_id`)
    REFERENCES `provider` (`provider_id`),
 ADD CONSTRAINT `fk_visit_detail_care_site` FOREIGN KEY (`care_site_id`)
    REFERENCES `care_site` (`care_site_id`);

CREATE TABLE IF NOT EXISTS specimen (
specimen_id BIGINT NOT NULL AUTO_INCREMENT,
person_id BIGINT NOT NULL,
specimen_concept_id BIGINT NOT NULL,
specimen_type_concept_id BIGINT NOT NULL,
specimen_date DATETIME NOT NULL,
quantity DECIMAL(18,6) DEFAULT NULL,
unit_concept_id BIGINT DEFAULT NULL,
anatomic_site_concept_id BIGINT DEFAULT NULL,
disease_status_concept_id BIGINT DEFAULT NULL,
specimen_source_id BIGINT DEFAULT NULL,
specimen_source_value VARCHAR(50) DEFAULT NULL,
unit_source_value VARCHAR(50) DEFAULT NULL,
anatomic_site_source_value VARCHAR(50) DEFAULT NULL,
disease_status_source_value VARCHAR(50) DEFAULT NULL,
CONSTRAINT xpk_specimen PRIMARY KEY NONCLUSTERED (specimen_id)
);

ALTER table specimen

ADD CONSTRAINT `fk_specimen_person` FOREIGN KEY (`person_id`)
    REFERENCES `person` (`person_id`),
 ADD CONSTRAINT `fk_specimen_concept` FOREIGN KEY (`specimen_concept_id`)
    REFERENCES `concept` (`concept_id`),
 ADD CONSTRAINT `fk_specimen_type_concept` FOREIGN KEY (`specimen_type_concept_id`)
    REFERENCES `concept` (`concept_id`),
 ADD CONSTRAINT `fk_specimen_unit_concept` FOREIGN KEY (`unit_concept_id`)
    REFERENCES `concept` (`concept_id`),
 ADD CONSTRAINT `fk_specimen_anatomic_site_concept` FOREIGN KEY (`anatomic_site_concept_id`)
    REFERENCES `concept` (`concept_id`),
 ADD CONSTRAINT `fk_specimen_disease_status_concept` FOREIGN KEY (`disease_status_concept_id`)
    REFERENCES `concept` (`concept_id`);

CREATE TABLE IF NOT EXISTS provider (
  provider_id BIGINT NOT NULL,
  provider_name VARCHAR(255),
  npi VARCHAR(20),
  dea VARCHAR(20),
  specialty_concept_id BIGINT,
  care_site_id BIGINT,
  year_of_birth INTEGER,
  gender_concept_id BIGINT,
  provider_source_value VARCHAR(50),
  specialty_source_value VARCHAR(50),
  gender_source_value VARCHAR(50),
  PRIMARY KEY (provider_id),
  FOREIGN KEY (specialty_concept_id) REFERENCES concept (concept_id),
  FOREIGN KEY (care_site_id) REFERENCES care_site (care_site_id),
  FOREIGN KEY (gender_concept_id) REFERENCES concept (concept_id)
);

ALTER TABLE provider
ADD CONSTRAINT `fk_provider_specialty_concept` FOREIGN KEY (`specialty_concept_id`) REFERENCES `concept` (`concept_id`),
ADD CONSTRAINT `fk_provider_care_site` FOREIGN KEY (`care_site_id`) REFERENCES `care_site` (`care_site_id`);


CREATE TABLE IF NOT EXISTS measurement (
measurement_id BIGINT NOT NULL,
  person_id BIGINT NOT NULL,
  measurement_concept_id BIGINT NOT NULL,
  measurement_date DATE NOT NULL,
  measurement_datetime DATETIME NULL,
  measurement_time TIME NULL,
  value_as_number FLOAT NULL,
  value_as_concept_id BIGINT NULL,
  unit_concept_id BIGINT NOT NULL,
  range_low FLOAT NULL,
  range_high FLOAT NULL,
  provider_id BIGINT NULL,
  visit_detail_id BIGINT NOT NULL,
  measurement_source_value VARCHAR(50) NULL,
  measurement_source_concept_id BIGINT NULL,
  unit_source_value VARCHAR(50) NULL,
  value_source_value VARCHAR(50) NULL,
  CONSTRAINT pk_measurement PRIMARY KEY NONCLUSTERED (measurement_id),
  CONSTRAINT fk_measurement_person FOREIGN KEY (person_id)
    REFERENCES person (person_id),
  CONSTRAINT fk_measurement_concept FOREIGN KEY (measurement_concept_id)
    REFERENCES concept (concept_id),
  CONSTRAINT fk_measurement_value_concept FOREIGN KEY (value_as_concept_id)
    REFERENCES concept (concept_id),
  CONSTRAINT fk_measurement_unit_concept FOREIGN KEY (unit_concept_id)
    REFERENCES concept (concept_id),
  CONSTRAINT fk_measurement_provider FOREIGN KEY (provider_id)
    REFERENCES provider (provider_id),
  CONSTRAINT fk_measurement_visit_detail FOREIGN KEY (visit_detail_id)
    REFERENCES visit_detail (visit_detail_id)
);

CREATE TABLE IF NOT EXISTS condition_occurrence (
  condition_occurrence_id BIGINT NOT NULL AUTO_INCREMENT,
  person_id BIGINT NOT NULL,
  condition_concept_id BIGINT NOT NULL,
  condition_start_date DATETIME NOT NULL,
  condition_end_date DATETIME DEFAULT NULL,
  condition_type_concept_id BIGINT NOT NULL,
  stop_reason VARCHAR(20) DEFAULT NULL,
  provider_id BIGINT DEFAULT NULL,
  visit_occurrence_id BIGINT DEFAULT NULL,
  condition_source_value VARCHAR(50) DEFAULT NULL,
  condition_source_concept_id BIGINT DEFAULT NULL,
  condition_status_source_value VARCHAR(50) DEFAULT NULL,
  condition_status_concept_id BIGINT DEFAULT NULL,
  CONSTRAINT xpk_condition_occurrence PRIMARY KEY NONCLUSTERED (condition_occurrence_id)
);

ALTER table condition_occurrence
ADD CONSTRAINT `fk_condition_occurrence_person` FOREIGN KEY (`person_id`)
    REFERENCES `person` (`person_id`),
 ADD CONSTRAINT `fk_condition_occurrence_condition_concept` FOREIGN KEY (`condition_concept_id`)
    REFERENCES `concept` (`concept_id`),
 ADD CONSTRAINT `fk_condition_occurrence_condition_type_concept` FOREIGN KEY (`condition_type_concept_id`)
    REFERENCES `concept` (`concept_id`),
 ADD CONSTRAINT `fk_condition_occurrence_provider` FOREIGN KEY (`provider_id`)
    REFERENCES `provider` (`provider_id`),
 ADD CONSTRAINT `fk_condition_occurrence_visit_occurrence` FOREIGN KEY (`visit_occurrence_id`)
    REFERENCES `visit_occurrence` (`visit_occurrence_id`);

CREATE TABLE IF NOT EXISTS observation (
    observation_id BIGINT NOT NULL AUTO_INCREMENT,
    person_id BIGINT NOT NULL,
    observation_concept_id BIGINT NOT NULL,
    observation_date DATETIME NOT NULL,
    observation_type_concept_id BIGINT NOT NULL,
    value_as_number DOUBLE DEFAULT NULL,
    value_as_string VARCHAR(500) DEFAULT NULL,
    value_as_concept_id BIGINT DEFAULT NULL,
    qualifier_concept_id BIGINT DEFAULT NULL,
    unit_concept_id BIGINT DEFAULT NULL,
    provider_id BIGINT DEFAULT NULL,
    visit_occurrence_id BIGINT DEFAULT NULL,
    observation_source_value VARCHAR(50) DEFAULT NULL,
    observation_source_concept_id BIGINT DEFAULT NULL,
    unit_source_value VARCHAR(50) DEFAULT NULL,
    qualifier_source_value VARCHAR(50) DEFAULT NULL,
    value_source_value VARCHAR(500) DEFAULT NULL,
    CONSTRAINT xpk_observation PRIMARY KEY NONCLUSTERED (observation_id)
);

ALTER table observation
 ADD CONSTRAINT `fk_observation_person` FOREIGN KEY (`person_id`)
    REFERENCES `person` (`person_id`),
 ADD CONSTRAINT `fk_observation_concept` FOREIGN KEY (`observation_concept_id`)
    REFERENCES `concept` (`concept_id`),
 ADD CONSTRAINT `fk_observation_type_concept` FOREIGN KEY (`observation_type_concept_id`)
    REFERENCES `concept` (`concept_id`),
 ADD CONSTRAINT `fk_observation_value_concept` FOREIGN KEY (`value_as_concept_id`)
    REFERENCES `concept` (`concept_id`),
 ADD CONSTRAINT `fk_observation_qualifier_concept` FOREIGN KEY (`qualifier_concept_id`)
    REFERENCES `concept` (`concept_id`),
 ADD CONSTRAINT `fk_observation_unit_concept` FOREIGN KEY (`unit_concept_id`)
    REFERENCES `concept` (`concept_id`),
 ADD CONSTRAINT `fk_observation_provider` FOREIGN KEY (`provider_id`)
    REFERENCES `provider` (`provider_id`),
 ADD CONSTRAINT `fk_observation_visit_occurrence` FOREIGN KEY (`visit_occurrence_id`)
    REFERENCES `visit_occurrence` (`visit_occurrence_id`);

CREATE TABLE IF NOT EXISTS note (
    note_id BIGINT NOT NULL AUTO_INCREMENT,
    person_id BIGINT NOT NULL,
    note_date DATETIME NOT NULL,
    note_type_concept_id BIGINT NOT NULL,
    note_text LONGTEXT NOT NULL,
    provider_id BIGINT DEFAULT NULL,
    visit_occurrence_id BIGINT DEFAULT NULL,
    note_source_value VARCHAR(50) DEFAULT NULL,
    note_source_concept_id BIGINT DEFAULT NULL,
    CONSTRAINT xpk_note PRIMARY KEY NONCLUSTERED (note_id)
);

ALTER TABLE note
ADD visit_detail_id BIGINT NOT NULL,
ADD CONSTRAINT `fk_note_person` FOREIGN KEY (`person_id`) REFERENCES `person` (`person_id`),
ADD CONSTRAINT `fk_note_type` FOREIGN KEY (`note_type_concept_id`) REFERENCES `concept` (`concept_id`),
ADD CONSTRAINT `fk_note_provider` FOREIGN KEY (`provider_id`) REFERENCES `provider` (`provider_id`),
ADD CONSTRAINT `fk_note_visit_occurrence` FOREIGN KEY (`visit_occurrence_id`) REFERENCES `visit_occurrence` (`visit_occurrence_id`),
ADD CONSTRAINT `fk_note_visit_detail` FOREIGN KEY (`visit_detail_id`) REFERENCES `visit_detail` (`visit_detail_id`);


CREATE TABLE IF NOT EXISTS note_nlp (
    note_nlp_id BIGINT NOT NULL AUTO_INCREMENT,
    note_id BIGINT NOT NULL,
    section_concept_id BIGINT DEFAULT NULL,
    snippet LONGTEXT NOT NULL,
    offset BIGINT NOT NULL,
    lexical_variant VARCHAR(500) NOT NULL,
    note_nlp_concept_id BIGINT DEFAULT NULL,
    note_nlp_source_concept_id BIGINT DEFAULT NULL,
    note_nlp_source_value VARCHAR(50) DEFAULT NULL,
    note_nlp_datetime DATETIME DEFAULT NULL,
    CONSTRAINT xpk_note_nlp PRIMARY KEY NONCLUSTERED (note_nlp_id),
    CONSTRAINT fk_note FOREIGN KEY (note_id) REFERENCES note (note_id)
);

ALTER table note_nlp
ADD CONSTRAINT `fk_note_nlp_note` FOREIGN KEY (`note_id`) REFERENCES `note` (`note_id`),
 ADD CONSTRAINT `fk_note_nlp_concept` FOREIGN KEY (`note_nlp_concept_id`) REFERENCES `concept` (`concept_id`),
 ADD CONSTRAINT `fk_note_nlp_source_concept` FOREIGN KEY (`note_nlp_source_concept_id`) REFERENCES `concept` (`concept_id`);


