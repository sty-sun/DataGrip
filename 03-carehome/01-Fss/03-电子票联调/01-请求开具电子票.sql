-- ===========================数据准备===========================
-- 1. 配置表定义
DROP TABLE ORG_EBILL_CONFIG;
-- auto-generated definition
CREATE TABLE ORG_EBILL_CONFIG
(
    ORG_EBILL_CONFIG_ID NUMBER(19) NOT NULL
        CONSTRAINT SYS_C006803
            PRIMARY KEY
        CONSTRAINT SYS_C006797
            CHECK ("ORG_EBILL_CONFIG_ID" IS NOT NULL),
    EBILL_CODE          NUMBER(19)
        CONSTRAINT SYS_C006798
            CHECK ("EBILL_CODE" IS NOT NULL),
    ORG_ID              NUMBER(19)
        CONSTRAINT SYS_C006799
            CHECK ("ORG_ID" IS NOT NULL),
    EBILL_NAME          VARCHAR2(180),
    EBILL_URL           VARCHAR2(2000)
        CONSTRAINT SYS_C006800
            CHECK ("EBILL_URL" IS NOT NULL),
    EBILL_ACCOUNT       VARCHAR2(80)
        CONSTRAINT SYS_C006801
            CHECK ("EBILL_ACCOUNT" IS NOT NULL),
    EBILL_REGION        VARCHAR2(30)
        CONSTRAINT SYS_C006802
            CHECK ("EBILL_REGION" IS NOT NULL),
    EBILL_DEPTCODE      VARCHAR2(1200),
    APP_ID              VARCHAR2(512),
    VERSION             CHAR(3),
    IS_DEL              CHAR DEFAULT '0',
    KEY                 VARCHAR2(128),
    PLACE_CODE          CHAR(10)
)
/
-- 2. 配置表信息插入
INSERT INTO
    ORG_EBILL_CONFIG (ORG_EBILL_CONFIG_ID, EBILL_CODE, ORG_ID, EBILL_NAME, EBILL_URL, EBILL_ACCOUNT, EBILL_REGION, EBILL_DEPTCODE, APP_ID, VERSION, IS_DEL, KEY, PLACE_CODE)
VALUES (1, 002010001, 200, '滨海电子票', 'http://10.10.30.32:30000/saas-industry/api/standard/', 'a', '120000', '043037', 'TJSBHXQZFHJSWYH841332', '1.0', 0, '61768932079865098268681164', '001');
-- ===========================正式操作===========================
-- 1. 查找滨海新区的分户
SELECT
    BI.*,
    BI2.INFO_NAME
FROM
    BASE_INFO BI
        LEFT JOIN OWNER_INFO OI ON BI.INFO_ID = OI.INFO_ID
        LEFT JOIN BASE_INFO BI2 ON OI.SUPER_ID = BI2.INFO_ID
WHERE
      OI.SUPER_TYPE = 20
  AND BI2.INFO_NAME = '河东区';
-- 120000621304
-- 2. 找openStatus = 2 -> 已获取url和图片的开票任务
WITH
    CTS AS (SELECT
                BI.*,
                BI2.INFO_NAME
            FROM
                BASE_INFO BI
                    LEFT JOIN OWNER_INFO OI ON BI.INFO_ID = OI.INFO_ID
                    LEFT JOIN BASE_INFO BI2 ON OI.SUPER_ID = BI2.INFO_ID
            WHERE
                  OI.SUPER_TYPE = 20
              AND BI2.INFO_NAME = '河东区')
SELECT *
FROM
    E_BILL_TASK
WHERE
      INFO_ID IN (SELECT
                      INFO_ID
                  FROM
                      E_BILL_TASK)
  AND OPEN_STATUS = '2'
ORDER BY BATCH_NO DESC;
-- info_id:100002044634
-- batch_no:251222001117
-- 3. 更改分户mng_org_id
UPDATE BASE_INFO
SET
    MNG_ORG_ID = 200
WHERE
    INFO_ID = '100002043463';
-- 4. 更改ebilltask状态
SELECT *
FROM
    E_BILL_TASK
WHERE
    BATCH_NO = '251222001117';

UPDATE E_BILL_TASK
SET
    OPEN_STATUS = '0'
WHERE
      BATCH_NO = '251222001117'
  AND PAYER_TYPE = '2';
-- 5. 更新trade的mngOrgId 因为默认全更改为了100
UPDATE TRADE
SET
    MNG_ORG_ID = 200
WHERE
    BATCH_NO = '251217002639';
-- 6. 删除e_bill_info和e_bill_use_info信息
SELECT *
FROM
    EBILL_USE_INFO
WHERE
    INFO_ID = '100002043463';

DELETE
FROM
    EBILL_INFO
WHERE
    BILL_ID IN (SELECT
                    EBILL_USE_INFO.BILL_ID
                FROM
                    EBILL_USE_INFO
                WHERE
                      INFO_ID = '100002044634'
                  AND PAYER_TYPE = '2');

DELETE
FROM
    EBILL_USE_INFO
WHERE
    BILL_ID IN (SELECT
                    BILL_ID
                FROM
                    EBILL_USE_INFO
                WHERE
                      INFO_ID = '100002044634'
                  AND PAYER_TYPE = '2');
-- 7. 更新hou_info中关于电子票的字段
UPDATE HOU_INFO
SET
    IS_EBILL       = 0,
    DEV_EBILL_CODE = NULL,
    OWN_EBILL_CODE = NULL
WHERE
    INFO_ID = '100002044634';

SELECT *
FROM
    E_BILL_TASK
WHERE
    BATCH_NO = '251222001117';

DELETE FROM EBILL_INFO WHERE BUS_NO = '251222001117100002044634227020';

SELECT * FROM E_BILL_TASK WHERE BATCH_NO = '251222001117';



