
DROP TRIGGER IF EXISTS `leads_d`;
DELIMITER $$
CREATE
    TRIGGER `leads_d` AFTER DELETE ON `ai_leads`
    FOR EACH ROW BEGIN
    INSERT INTO sync_ai_lead (SYNC_OP, ai_lead_id) VALUES (0, OLD.id);
END; $$
DELIMITER ;
-- ---------------------------------------------------------------------------------------------------------------------
DROP TRIGGER IF EXISTS `leads_i`;
DELIMITER $$
CREATE
    TRIGGER `leads_i` AFTER INSERT ON `ai_leads`
    FOR EACH ROW BEGIN
    INSERT INTO sync_ai_lead (SYNC_OP, ai_lead_id) VALUES (1, NEW.id);
END; $$
DELIMITER ;
-- ---------------------------------------------------------------------------------------------------------------------
DROP TRIGGER IF EXISTS leads_u;
DELIMITER $$
CREATE TRIGGER `leads_u` AFTER UPDATE ON `ai_leads`
    FOR EACH ROW BEGIN
    INSERT INTO sync_ai_lead (SYNC_OP, ai_lead_id) VALUES (2, NEW.id);
END; $$
DELIMITER ;
-- ---------------------------------------------------------------------------------------------------------------------
-- ---------------------------------------------------------------------------------------------------------------------
DROP TRIGGER IF EXISTS `leads_extra_d`;
DELIMITER $$
CREATE
    TRIGGER `leads_extra_d` AFTER DELETE ON `ai_lead_extra_data`
    FOR EACH ROW BEGIN
    INSERT INTO sync_ai_lead (SYNC_OP, ai_lead_id, ai_lead_extra_data_id) VALUES (0, OLD.lead_id, OLD.id);
END; $$
DELIMITER ;
-- ---------------------------------------------------------------------------------------------------------------------
DROP TRIGGER IF EXISTS `leads_extra_i`;
DELIMITER $$
CREATE
    TRIGGER `leads_extra_i` AFTER INSERT ON `ai_lead_extra_data`
    FOR EACH ROW BEGIN
    INSERT INTO sync_ai_lead (SYNC_OP, ai_lead_id, ai_lead_extra_data_id) VALUES (1, NEW.lead_id, NEW.id);
END; $$
DELIMITER ;
-- ---------------------------------------------------------------------------------------------------------------------
DROP TRIGGER IF EXISTS leads_extra_u;
DELIMITER $$
CREATE TRIGGER `leads_extra_u` AFTER UPDATE ON `ai_lead_extra_data`
    FOR EACH ROW BEGIN
    INSERT INTO sync_ai_lead (SYNC_OP, ai_lead_id, ai_lead_extra_data_id) VALUES (2, NEW.lead_id, NEW.id);
END; $$
DELIMITER ;
-- ---------------------------------------------------------------------------------------------------------------------
-- ---------------------------------------------------------------------------------------------------------------------
DROP TRIGGER IF EXISTS `jobs_d`;
DELIMITER $$
CREATE
    TRIGGER `jobs_d` AFTER DELETE ON `ai_jobs`
    FOR EACH ROW BEGIN
    IF (OLD.job_req_id <> '' OR OLD.job_req_id IS NOT NULL)
    THEN
        INSERT INTO sync_ai_lead (SYNC_OP, ai_jobs_id, OLD_job_req_id) VALUES (0, OLD.id, OLD.job_req_id);
    END IF;
END; $$
DELIMITER ;
-- ---------------------------------------------------------------------------------------------------------------------
DROP TRIGGER IF EXISTS `jobs_i`;
DELIMITER $$
CREATE
    TRIGGER `jobs_i` AFTER INSERT ON `ai_jobs`
    FOR EACH ROW BEGIN
    IF (NEW.job_req_id <> '' OR NEW.job_req_id IS NOT NULL)
    THEN
        INSERT INTO sync_ai_lead (SYNC_OP, ai_jobs_id, OLD_job_req_id) VALUES (1, NEW.id, NEW.job_req_id);
    END IF;
END; $$
DELIMITER ;
-- ---------------------------------------------------------------------------------------------------------------------
DROP TRIGGER IF EXISTS jobs_u;
DELIMITER $$
CREATE TRIGGER `jobs_u` AFTER UPDATE ON `ai_jobs`
    FOR EACH ROW BEGIN
    IF OLD.job_req_id <> NEW.job_req_id
    THEN
        INSERT INTO sync_ai_lead (SYNC_OP, ai_jobs_id, OLD_job_req_id) VALUES (2, NEW.id, NEW.job_req_id);
    END IF;
END; $$
DELIMITER ;
-- ---------------------------------------------------------------------------------------------------------------------
-- ---------------------------------------------------------------------------------------------------------------------
DROP TRIGGER IF EXISTS `jobs_d`;
DELIMITER $$
CREATE
    TRIGGER `jobs_d` AFTER DELETE ON `ai_campaign_contacts`
    FOR EACH ROW BEGIN
    IF OLD.is_test = 1
    THEN
        INSERT INTO sync_ai_lead (SYNC_OP, ai_lead_id, ai_campaign_contacts) VALUES (0, OLD.lead_id, OLD.id);
    END IF;
END; $$
DELIMITER ;
-- ---------------------------------------------------------------------------------------------------------------------
DROP TRIGGER IF EXISTS `jobs_i`;
DELIMITER $$
CREATE
    TRIGGER `jobs_i` AFTER INSERT ON `ai_campaign_contacts`
    FOR EACH ROW BEGIN
    IF NEW.is_test = 1
    THEN
        INSERT INTO sync_ai_lead (SYNC_OP, ai_lead_id, ai_campaign_contacts) VALUES (1, NEW.lead_id, NEW.id);
    END IF;
END; $$
DELIMITER ;
-- ---------------------------------------------------------------------------------------------------------------------
DROP TRIGGER IF EXISTS jobs_u;
DELIMITER $$
CREATE TRIGGER `jobs_u` AFTER UPDATE ON `ai_campaign_contacts`
    FOR EACH ROW BEGIN
    IF NEW.is_test <> OLD.is_test
    THEN
        INSERT INTO sync_ai_lead (SYNC_OP, ai_lead_id, ai_campaign_contacts) VALUES (2, NEW.lead_id, NEW.id);
    END IF;
END; $$
DELIMITER ;
-- ---------------------------------------------------------------------------------------------------------------------
-- ---------------------------------------------------------------------------------------------------------------------
DROP TRIGGER IF EXISTS `jobs_d`;
DELIMITER $$
CREATE
    TRIGGER `jobs_d` AFTER DELETE ON `ai_event_candidates`
    FOR EACH ROW BEGIN
    INSERT INTO sync_ai_lead (SYNC_OP, ai_lead_id, ai_event_candidates) VALUES (0, OLD.lead_id, OLD.id);
END; $$
DELIMITER ;
-- ---------------------------------------------------------------------------------------------------------------------
DROP TRIGGER IF EXISTS `jobs_i`;
DELIMITER $$
CREATE
    TRIGGER `jobs_i` AFTER INSERT ON `ai_event_candidates`
    FOR EACH ROW BEGIN
    INSERT INTO sync_ai_lead (SYNC_OP, ai_lead_id, ai_event_candidates) VALUES (1, NEW.lead_id, NEW.id);
END; $$
DELIMITER ;
-- ---------------------------------------------------------------------------------------------------------------------
DROP TRIGGER IF EXISTS jobs_u;
DELIMITER $$
CREATE TRIGGER `jobs_u` AFTER UPDATE ON `ai_event_candidates`
    FOR EACH ROW BEGIN
    IF NEW.lead_id <> OLD.lead_id
    THEN
        INSERT INTO sync_ai_lead (SYNC_OP, ai_lead_id, ai_event_candidates) VALUES (2, OLD.lead_id, NEW.id);
    END IF;
END; $$
DELIMITER ;
