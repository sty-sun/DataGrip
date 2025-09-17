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
VALUES ('2025-08061820',
        '20250805',
        '144200',
        2138686,
        2000,
        0,
        110,
        '1',
        '1',
        '120112011001GB00087F00170013',
        '测试公司15',
        '01',
        '123456789123456789',
        '12345678910',
        '天津市测试开发有限公司109',
        '91120112MA06UJ3P6M',
        '88717777',
        '滨海新区',
        '测试15',
        '测试大街15',
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
        'E0D67E6E-5EDF-4F40-8E7D-246E8462BF20',
        200);

INSERT INTO PRESALE_MATE_WXZJ
(HOUSE_ID, WXZJ_DIST_ID, WXZJ_SECT_ID, STEP, UPDATE_TIME, UPDATE_TYPE, WXZJ_SECT_NAME, WXZJ_DIST_NAME)
VALUES ('E0D67E6E-5EDF-4F40-8E7D-246E8462BF20', 0, 0, '1', '20240329190902', 'auto', '测试15', '滨海新区');


INSERT INTO bk_hx_acct_water (id, hkbatch, acc_no, TXN_DTE, TXN_SEQ, txn_tme, txn_sig, txn_amt, flag, tran_desc)
VALUES ('999924', 'batch_no:250806050148;', '20250508000001', '20201119', '1', '20250718095050', 'C', 66666.0, '0',
        'description 1');

delete
from BK_HX_ACCT_WATER
where ID = '999923';

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
select *
from FURTHER_PAYMENT_INFO
where BATCH_NO = '250806101544';

select *
from COUNTER_PAYMENT_INFO
where BATCH_NO = '250806101544';