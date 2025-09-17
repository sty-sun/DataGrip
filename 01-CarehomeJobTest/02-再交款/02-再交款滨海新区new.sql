-- ---------------------------------------------------------创建交易----------------------------------------------------
-- 1. 创建一个合同信息
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
VALUES ('2025-08051442',
        '20250805',
        '144200',
        2138686,
        2000,
        10000,
        110,
        '1',
        '1',
        '120112011001GB00087F00170013',
        '测试公司',
        '01',
        '210102196910165694',
        '12345678910',
        '天津市泰思特开发有限公司1',
        '91120112MA06UJ3P1M',
        '88717777',
        '滨海新区',
        '泰思特 ',
        '泰思特大街',
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
        'E0D67E6E-5EDF-4F40-8E7D-246E8462BFE3',
        200);

select *
from HMFMSFD.RECEIVE_CONTRACT_INFO
where BUY_PACT_NO = '2025-08011504';

-- 2. 创建一个柜面缴款信息
insert into COUNTER_PAYMENT_INFO(BATCH_NO, BUY_PACT_NO, IMP_DATE, IMP_TIME, OWN_PAY, OWN_PAY_STEP, DEV_PAY,
                                 DEV_PAY_STEP, OWN_WATER_NUM, OWN_PAY_DATE, OWN_PAY_TIME)
values ('250805050063', '2025-08051442', '20250805', '144200', 2000,
        1, 10000, 1, '20220420135208000635038',
        '20250805', '144200');

select *
from COUNTER_PAYMENT_INFO
where BATCH_NO = '250805050063';
-- 3. 创建一个核心流水信息
INSERT INTO bk_hx_acct_water (id, hkbatch, acc_no, TXN_DTE, TXN_SEQ, txn_tme, txn_sig, txn_amt, flag, tran_desc)
VALUES ('999907', 'batch_no:250805050063;', '20250508000001', '20201119', '1', '20250718095050', 'C', 12000.0, '0',
        'description 1');

delete
from BK_HX_ACCT_WATER
where ID = '999907';

-- 5. 创建一个预售系统数据
INSERT INTO PRESALE_MATE_WXZJ
(HOUSE_ID, WXZJ_DIST_ID, WXZJ_SECT_ID, STEP, UPDATE_TIME, UPDATE_TYPE, WXZJ_SECT_NAME, WXZJ_DIST_NAME)
VALUES('E0D67E6E-5EDF-4F40-8E7D-246E8462BFE3', 125, 0, '1', '20240329190902', 'auto', '泰思特', '滨海新区');

select *
from HOU_INFO
where INFO_ID = '';
------------------------------------------------------------------------------------------------------------------------
select pay.batch_no,
       pay.buy_pact_no,
       pay.info_id,
       pay.sum_tran_amt,
       hx.acc_no
from (select p.batch_no,
             p.buy_pact_no,
             p.info_id,
             (p.own_pay + nvl(p.dev_pay, 0)) as sum_tran_amt
      from counter_payment_info p
      where p.own_pay_step = 1) pay
         join (select hkbatch,
                      acc_no,
                      max(txn_tme)                                     as tranaccttime,
                      sum(decode(txn_sig, 'C', txn_amt, -1 * txn_amt)) as txn_amt
               from bk_hx_acct_water
               where flag = '0'
                 and hkbatch is not null
               group by hkbatch, acc_no) hx
              on hx.txn_amt = pay.sum_tran_amt
                  and instr(hx.hkbatch, pay.batch_no || ';') > 0;
------------------------------------------------------------------------------------------------------------------------
-- 恢复数据
begin
    DELETE FROM SECTIONS_OPER WHERE BATCH_NO = '250805050063';
    DELETE FROM BASE_INFO_OPER WHERE BATCH_NO = '250805050063';
    DELETE FROM OWNER_INFO_OPER WHERE BATCH_NO = '250805050063';
    DELETE FROM HOU_INFO_OPER WHERE BATCH_NO = '250805050063';
    DELETE FROM HOU_UNITS_OPER WHERE BATCH_NO = '250805050063';
    DELETE FROM PAY_DETAIL WHERE BATCH_NO = '250805050063';
    DELETE FROM PAY_SUM WHERE BATCH_NO = '250805050063';
    DELETE FROM TRADE WHERE BATCH_NO = '250805050063';
    DELETE FROM TRADE_BANK WHERE BATCH_NO = '250805050063';
    delete from BASE_ORG_MANAGEMENT_OPER where BATCH_NO = '250805050063';
    delete from BUSINESS_WATER_RELATION where BATCH_NO = '250805050063';
    delete from E_BILL_TASK where BATCH_NO = '250805050063';
    delete from ACCT_WATER where BATCH_NO = '250805050063';
    delete from REAL_ACCT_WATER where BATCH_NO = '250805050063';
    UPDATE COUNTER_PAYMENT_INFO SET OWN_PAY_STEP = 1 WHERE BATCH_NO = '250805050063';
    update BK_HX_ACCT_WATER set flag = '0' where HKBATCH like '%250805050063%';
end;