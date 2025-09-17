INSERT INTO HMFMSFD.RECEIVE_CONTRACT_INFO (BUY_PACT_NO,
                                           IMP_DATE,
                                           IMP_TIME,
                                           BUY_MONEY,
                                           OWN_PAY,
                                           DEV_PAY,
                                           INFO_AREA,
                                           EXIST_FLAG,
                                           PAY_TYPE,
                                           REALMS_ID,
                                           OWN_NAME,
                                           CERT_TYPE,
                                           CERT_CODE,
                                           OWN_LINK_TEL,
                                           DEV_NAME,
                                           DEV_CODE,
                                           DEV_LINK_TEL,
                                           ORG_NAME,
                                           SECT_NAME,
                                           INFO_ADDR,
                                           ORIGINAL_UNIT_CODE,
                                           UNIT_CODE,
                                           UNIT_SUPER_FLAG,
                                           ORIGINAL_DOOR_CODE,
                                           DOOR_CODE,
                                           DOOR_SUPER_FLAG,
                                           ORIGINAL_ROOM_CODE,
                                           ROOM_CODE,
                                           ROOM_SUPER_FLAG,
                                           CODE_REPEAT_FLAG,
                                           OWN_GROUP_NUM,
                                           DEV_GROUP_NUM,
                                           INFO_ID,
                                           CONTRACT_STATUS,
                                           INVALID_TIME,
                                           HOUINFO_NO,
                                           MNG_ORG_ID)
VALUES ('2025-08061042',
        '20250805',
        '144200',
        2138686,
        2000,
        0,
        110,
        '1',
        '1',
        '120112011001GB00087F00170013',
        '测试公司14',
        '01',
        '210102196910165694',
        '12345678910',
        '天津市测试开发有限公司108',
        '91120112MA06UJ3P6M',
        '88717777',
        '滨海新区',
        '测试14',
        '测试大街14',
        '1号楼',
        '1',
        '0',
        '1',
        '1',
        '0',
        '9999',
        '9999',
        '0',
        NULL,
        NULL,
        NULL,
        NULL,
        '0',
        NULL,
        'CCE1A4B8-8C7D-48CD-A8C1-ABC020D1AE1A',
        200);

select *
from HOU_INFO
where INFO_ID = '120000955418';

INSERT INTO PRESALE_MATE_WXZJ
(HOUSE_ID, WXZJ_DIST_ID, WXZJ_SECT_ID, STEP, UPDATE_TIME, UPDATE_TYPE, WXZJ_SECT_NAME, WXZJ_DIST_NAME)
VALUES ('CCE1A4B8-8C7D-48CD-A8C1-ABC020D1AE1A', 0, 0, '1', '20240329190902', 'auto', '测试14', '滨海新区');

select *
from COUNTER_PAYMENT_INFO
where BATCH_NO = '250806050125';

INSERT INTO bk_hx_acct_water (id, hkbatch, acc_no, TXN_DTE, TXN_SEQ, txn_tme, txn_sig, txn_amt, flag, tran_desc)
VALUES ('999922', 'batch_no:250806050130;', '20250508000001', '20201119', '1', '20250718095050', 'C', 3000.0, '0',
        'description 1');

------------------------------------------------------------------------------------------------------------------------
-- 1. 首先是插入一个合同信息
-- 2. 插入预售数据
-- 3. 插入柜面交款记录以及
-- 3. 在前端创建交易

select *
from BK_HX_ACCT_WATER
where HKBATCH like '%250806050125%';