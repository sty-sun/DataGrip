-- 1、通过柜面续交接口推送入账
-- 1.1、首先查询有哪些需要续交的用户
-- 实际是从结存单里面看到info_id
select INFO_CODE
from BASE_INFO bo
         join NOTIFY_CUIJIAO_INFO nci on bo.INFO_ID = nci.INFO_ID
where RENEWAL_STATUS = 0;

select *
from BASE_INFO B
where B.INFO_ID = '120000513030';
-- 获取参数 info_id：120000511849
-- 1.2、通过3301接口获取需要续交用户信息
-- 获取参数 batch_no: 250808050293
-- 获取参数 own_name: 李伟
-- 获取参数 cert_type & cert_code: 01 120107197908164558
-- 获取参数 realNmbr: 20250508000001
-- 1.3、创建流水
INSERT INTO bk_hx_acct_water (id, hkbatch, acc_no, TXN_DTE, TXN_SEQ, txn_tme, txn_sig, txn_amt, flag, tran_desc)
VALUES ('7777774', 'batch_no:250816000008;', '158001201110000869', '20201119', '1', '20250718095050', 'C', 1234.0, '0',
        'description 1');
-- 1.4、通过3302接口进行续交交款

-- 启动定时入账任务


------------------------------------------------------------------------------------------------------------------------
SELECT pay.batch_no,
       pay.info_id,
       pay.own_pay,
       hx.acc_no
FROM (SELECT p.batch_no,
             p.info_id,
             p.own_pay
      FROM counter_renewal_info p
      WHERE p.own_pay_step = 1) pay
         JOIN (SELECT hkbatch,
                      acc_no,
                      MAX(txn_tme)                                 AS tranaccttime,
                      SUM(DECODE(txn_sig, 'C', txn_amt, -txn_amt)) AS txn_amt
               FROM bk_hx_acct_water
               WHERE flag = '0'
                 AND hkbatch IS NOT NULL
               GROUP BY hkbatch, acc_no) hx
              ON hx.txn_amt = pay.own_pay
                  AND INSTR(hx.hkbatch, pay.batch_no || ';') > 0;

select *
from TRADE
where BATCH_NO = '250808050293';

select *
from BUSINESS_WATER_RELATION B
where B.BATCH_NO = '250814050611';

select *
from ACCT
where FUND = '120000513030';

-- =========================================恢复代码====================================================================
begin
    update notify_cuijiao_info set batch_no = null where info_id = '120001673975' and status = '1';

    delete from COUNTER_PAYMENT_INFO where BATCH_NO = '250816000008';

    DELETE FROM SECTIONS_OPER WHERE BATCH_NO = '250816000008';
    DELETE FROM BASE_INFO_OPER WHERE BATCH_NO = '250816000008';
    DELETE FROM BASE_ORG_MANAGEMENT_OPER WHERE BATCH_NO = '250816000008';
    DELETE FROM OWNER_INFO_OPER WHERE BATCH_NO = '250816000008';
    DELETE FROM HOU_INFO_OPER WHERE BATCH_NO = '250816000008';
    DELETE FROM HOU_UNITS_OPER WHERE BATCH_NO = '250816000008';
    DELETE FROM PAY_DETAIL WHERE BATCH_NO = '250816000008';
    DELETE FROM PAY_SUM WHERE BATCH_NO = '250816000008';
    DELETE FROM TRADE WHERE BATCH_NO = '250816000008';
    DELETE FROM TRADE_BANK WHERE BATCH_NO = '250816000008';
    DELETE FROM ACCT_WATER WHERE BATCH_NO = '250816000008';
    DELETE FROM REAL_ACCT_WATER WHERE BATCH_NO = '250816000008';
    DELETE FROM E_BILL_TASK WHERE BATCH_NO = '250816000008';
    DELETE FROM BUSINESS_WATER_RELATION WHERE BATCH_NO = '250816000008';
    UPDATE NOTIFY_CUIJIAO_INFO SET RENEWAL_STATUS = 0 WHERE BATCH_NO = '250816000008';
end;