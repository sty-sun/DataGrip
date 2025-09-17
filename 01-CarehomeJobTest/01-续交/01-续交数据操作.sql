-----------------------------------创建交易---------------------------------------------------
-- 1. 查询哪个batchNo能用
select *
from BATCH_PAY_LOG
where NO_STATUS = '0';

-- 2. 有效的未续交的催缴信息
select *
from NOTIFY_CUIJIAO_INFO
where STATUS = '1'
  and RENEWAL_STATUS = '0';
-- 查看某个催缴信息绑定的申请编号
select *
from NOTIFY_CUIJIAO_INFO
where INFO_ID = '120002180928'
  and STATUS = '1'
  and RENEWAL_STATUS = '0';

-- 3. 调用3302接口
-- 4. 查看是否成功
select *
from COUNTER_RENEWAL_INFO
where OWN_PAY_STEP = 1
  and INFO_ID = '120002180928';

-- 5.插入trade表信息
INSERT INTO TRADE (BATCH_NO, TRAN_TYPE, TRAN_STATUS, REG_OPERID, REG_OPERNAME, REG_DATE, REG_TIME, FINISH_DATE,
                   FINISH_TIME, SYS_TIME, SYS_DATE, TRAN_AMT, TRAN_AREA, TRAN_COUNT, SECT_ID, SECT_NAME, CRT_ORG_ID,
                   DIST_ID, ID, REQ_NOTIFY_NO, RES_NOTIFY_NO, TRAN_MODE, TRAN_GROUP, ORIGIN_BATCH_NO, TRADE_SRC,
                   OTR_REMARK, IS_SUBTRACT, MNG_ORG_ID)
VALUES ('250716144104', '3113', '00BianJi', '116', '张媛(收件)', '20140825', '093445', '20140826', '141725',
        NULL, NULL, 4000.00, 0.00, 1, 120000271853, '宇阳公寓', 100, 106, NULL, NULL, NULL, '1', NULL, NULL, NULL,
        NULL, NULL, NULL);

-- 6.插入核心流水表
INSERT INTO bk_hx_acct_water (id, hkbatch, acc_no, TXN_DTE, TXN_SEQ, txn_tme, txn_sig, txn_amt, flag, tran_desc)
VALUES ('999997', '250716144104;', '158001201110000869', '20201119', '1', '20201119163003', 'C', 4000.0, '0',
        'description 1');

-- 7. 查询
SELECT pay.batch_no,
       pay.info_id,
       pay.own_pay,
       tr.tran_type,
       tr.tran_status,
       hx.acc_no
FROM (SELECT p.batch_no,
             p.info_id,
             p.own_pay
      FROM counter_renewal_info p
      WHERE p.own_pay_step = 1) pay
         JOIN trade tr
              ON pay.batch_no = tr.batch_no
                  and tr.TRAN_TYPE = '3113'
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


------------------------------------建立交易部分代码----------------------------------------------
BEGIN
    DELETE FROM SECTIONS_OPER WHERE BATCH_NO = '250716144104';
    DELETE FROM BASE_INFO_OPER WHERE BATCH_NO = '250716144104';
    DELETE FROM OWNER_INFO_OPER WHERE BATCH_NO = '250716144104';
    DELETE FROM HOU_INFO_OPER WHERE BATCH_NO = '250716144104';
    DELETE FROM HOU_UNITS_OPER WHERE BATCH_NO = '250716144104';
    DELETE FROM PAY_DETAIL WHERE BATCH_NO = '250716144104';
    DELETE FROM PAY_SUM WHERE BATCH_NO = '250716144104';
    DELETE FROM TRADE WHERE BATCH_NO = '250716144104';
    DELETE FROM TRADE_BANK WHERE BATCH_NO = '250716144104';
    UPDATE COUNTER_RENEWAL_INFO SET OWN_PAY_STEP = 1 WHERE BATCH_NO = '250716144104';
    UPDATE NOTIFY_CUIJIAO_INFO SET RENEWAL_STATUS = 0 WHERE BATCH_NO = '250716144104';

    DELETE FROM SECTIONS_OPER WHERE BATCH_NO = '220509444459';
    DELETE FROM BASE_INFO_OPER WHERE BATCH_NO = '220509444459';
    DELETE FROM OWNER_INFO_OPER WHERE BATCH_NO = '220509444459';
    DELETE FROM HOU_INFO_OPER WHERE BATCH_NO = '220509444459';
    DELETE FROM HOU_UNITS_OPER WHERE BATCH_NO = '220509444459';
    DELETE FROM PAY_DETAIL WHERE BATCH_NO = '220509444459';
    DELETE FROM PAY_SUM WHERE BATCH_NO = '220509444459';
    DELETE FROM TRADE WHERE BATCH_NO = '220509444459';
    DELETE FROM TRADE_BANK WHERE BATCH_NO = '220509444459';
    UPDATE COUNTER_RENEWAL_INFO SET OWN_PAY_STEP = 1 WHERE BATCH_NO = '220509444459';
    UPDATE NOTIFY_CUIJIAO_INFO SET RENEWAL_STATUS = 0 WHERE BATCH_NO = '220509444459';
END;
-------------------------------------入账-------------------------------------------------
-- 1. 创建payment_info数据
select *
from PAYMENT_INFO
where PAYMENT_NO in ('999999', '999998');
-- 2.

-- 恢复
begin
    delete from TRADE_LOG where BATCH_NO = '250716144104';
    delete from TRADE_LOG where BATCH_NO = '220509444459';
end;
-- 备份
select fund, sbj_id, amt, cnt, sbj_flag, sbj_level
from acct_subject
where (fund = 120002180928 and sbj_id = 1033);

select *
from ACCT_SUBJECT
where FUND = 120000709610;

select *
from ACCT_SUBJECT alias
where alias.SBJ_ID = 1033;
-----------------------

