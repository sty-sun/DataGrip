-- 创建交易 - 200滨海新区 ----------------------------------------------------------------------------------------------
-- 1. 创建一个申请编号
insert into BATCH_PAY_LOG
values ('250722104259', '20250722104259', 0);
-- 2. 创建一个合同信息
INSERT INTO HMFMSFD.RECEIVE_CONTRACT_INFO (BUY_PACT_NO, IMP_DATE, IMP_TIME, BUY_MONEY, OWN_PAY, DEV_PAY, INFO_AREA,
                                           EXIST_FLAG, PAY_TYPE, REALMS_ID, OWN_NAME, CERT_TYPE, CERT_CODE,
                                           OWN_LINK_TEL, DEV_NAME, DEV_CODE, DEV_LINK_TEL, ORG_NAME, SECT_NAME,
                                           INFO_ADDR, ORIGINAL_UNIT_CODE, UNIT_CODE, UNIT_SUPER_FLAG,
                                           ORIGINAL_DOOR_CODE, DOOR_CODE, DOOR_SUPER_FLAG, ORIGINAL_ROOM_CODE,
                                           ROOM_CODE, ROOM_SUPER_FLAG, CODE_REPEAT_FLAG, OWN_GROUP_NUM, DEV_GROUP_NUM,
                                           INFO_ID, CONTRACT_STATUS, INVALID_TIME, HOUINFO_NO, MNG_ORG_ID)
VALUES ('9999-9999999', '99999999', '999999', 9999999.00, 66666.00, 33333.00, 999.99, '1', '1',
        '120112011001GB00087F99999999', '测试人员', '01', '123456789123456789', '12345678910',
        '测试市测试房地产开发有限公司', '91120112MA06UCESHI', '99999999', '测试区', '测试府',
        '测试1路与测试2道交口测试府9号楼-9-999', '9号楼', '9', '0', '1', '1', '0', '9999', '9999', '0', null, null,
        null, null, '0', null, null, null);
-- 3. 创建一个柜面缴款信息
insert into COUNTER_PAYMENT_INFO(BATCH_NO, BUY_PACT_NO, IMP_DATE, IMP_TIME, OWN_PAY, OWN_PAY_STEP, DEV_PAY,
                                 DEV_PAY_STEP, OWN_WATER_NUM, OWN_PAY_DATE, OWN_PAY_TIME)
values ('250722104259', '9999-9999999', '20250718', '094551', 4000,
        1, 0, 1, '20220420135208000635038',
        '20250718', '094551');
-- 4. 创建一个核心流水信息
INSERT INTO bk_hx_acct_water (id, hkbatch, acc_no, TXN_DTE, TXN_SEQ, txn_tme, txn_sig, txn_amt, flag, tran_desc)
VALUES ('999980', '250722104259;', '158001201110000869', '20201119', '1', '20250718095050', 'C', 4000.0, '0',
        'description 1');

------------------------------------------------------------------------------------------------------------------------
begin
    delete from SECTIONS_OPER where BATCH_NO = '250722104259';
    delete from BASE_INFO_OPER where BATCH_NO = '250722104259';
    delete from BASE_ORG_MANAGEMENT_OPER where BATCH_NO = '250722104259';
    delete from OWNER_INFO_OPER where BATCH_NO = '250722104259';
    delete from HOU_INFO_OPER where BATCH_NO = '250722104259';
    delete from HOU_UNITS_OPER where BATCH_NO = '250722104259';
    delete from PAY_DETAIL where BATCH_NO = '250722104259';
    delete from PAY_SUM where BATCH_NO = '250722104259';
    delete from TRADE where BATCH_NO = '250722104259';
    delete from E_BILL_TASK where BATCH_NO = '250722104259';
    delete from ACCT_WATER where BATCH_NO = '250722104259';
    delete from REAL_ACCT_WATER where BATCH_NO = '250722104259';
    delete from FURTHER_PAYMENT_INFO where BATCH_NO = '250722104259';
    update COUNTER_PAYMENT_INFO set OWN_PAY_STEP = 1 where BATCH_NO = '250722104259';
    update BK_HX_ACCT_WATER set flag = '0' where HKBATCH like '250722104259;';
end;