DROP TABLE IF EXISTS sync_ai_lead;
CREATE TABLE sync_ai_lead
(
    `SYNC_ID`               INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
    `SYNC_INSERT_TS`        DATETIME(6)      NOT NULL DEFAULT NOW(6) COMMENT 'when the row was inserted',
    `SYNC_LAST_TS`          DATETIME         NOT NULL DEFAULT '1970-01-01' COMMENT 'when the row last read',
    `SYNC_OP`               TINYINT          NOT NULL COMMENT '1|2|0=insert|update|delete',
    `SYNC_STATUS`           BIT              NOT NULL DEFAULT 0 COMMENT '1: synced, 0:not synced',
    `ai_lead_id`            INT              NOT NULL DEFAULT 0 COMMENT 'to sync every possible data from ai_leads',
    `ai_lead_extra_data_id` INT              NOT NULL DEFAULT 0 COMMENT 'to sync ai_lead_extra_data.job_req_id to rep.job_req_bin',
    `ai_jobs_id`            INT              NOT NULL DEFAULT 0 COMMENT 'to sync ai_jobs_id.base_id to rep.base_id',
    `OLD_job_req_id`        VARCHAR(50)      NOT NULL DEFAULT '' COMMENT 'to sync ai_jobs_id.job_req_id to rep.job_req_id',
    `shared_to_user_id`     INT              NOT NULL DEFAULT 0 COMMENT 'to sync ai_sharing_users_id.shared_to_user_id to rep.shared_to_user_ids',
    `ai_campaign_contacts`  INT              NOT NULL DEFAULT 0 COMMENT 'to sync ai_campaign_contacts.lead_id to rep.has_campaign_contacts_perm',
    `ai_event_candidates`   INT              NOT NULL DEFAULT 0 COMMENT 'to sync ai_event_candidates.lead_id to rep.has_event_candidates_perm',
    CONSTRAINT `SYNC_ID` PRIMARY KEY (SYNC_INSERT_TS, SYNC_ID)
);
CREATE INDEX `IDX_SYNC_INS_TS` ON `sync_ai_lead` (`SYNC_INSERT_TS`, `SYNC_LAST_TS`, `SYNC_STATUS`);
CREATE INDEX `IDX_SYNC_INS_TS_COVERING` ON `sync_ai_lead` (`SYNC_INSERT_TS`, `SYNC_LAST_TS`, `SYNC_STATUS`, ai_lead_id,
                                                           ai_lead_extra_data_id, ai_jobs_id, OLD_job_req_id, shared_to_user_id,
                                                           ai_campaign_contacts, ai_event_candidates);