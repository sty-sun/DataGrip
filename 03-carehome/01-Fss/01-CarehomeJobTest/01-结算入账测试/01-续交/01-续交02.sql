-----------------------------------创建交易---------------------------------------------------
-- 1. 定义一个batchNo
insert into BATCH_PAY_LOG
values ('250728092728', '20250728092728', '0');

insert into BATCH_PAY_LOG
values ('250801170910', '20250801170910', '0');

-- 2. 有效的未续交的催缴信息  120000709612
select *
from NOTIFY_CUIJIAO_INFO
where STATUS = '1'
  and RENEWAL_STATUS = '0'
  and DIST_NAME like '%滨海%';
-- 查看某个催缴信息绑定的申请编号
select *
from NOTIFY_CUIJIAO_INFO
where INFO_ID = '120000592800'
  and STATUS = '1'
  and RENEWAL_STATUS = '0';

-- 3. 调用3302接口
-- 4. 查看是否成功
select *
from COUNTER_RENEWAL_INFO
where OWN_PAY_STEP = 1
  and INFO_ID = '120000592800';


-- 5.插入核心流水表
INSERT INTO bk_hx_acct_water (id, hkbatch, acc_no, TXN_DTE, TXN_SEQ, txn_tme, txn_sig, txn_amt, flag, tran_desc)
VALUES ('999900', '250728092728;', '20250508000001', '20250728', '1', '20250728095215', 'C', 1000.0, '0',
        'description 1');

-- 7. 查询
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
-- 8. 制造锁定的payment_info信息


------------------------------------建立交易部分代码----------------------------------------------
BEGIN
    DELETE FROM SECTIONS_OPER WHERE BATCH_NO = '250728092728';
    DELETE FROM BASE_INFO_OPER WHERE BATCH_NO = '250728092728';
    DELETE FROM OWNER_INFO_OPER WHERE BATCH_NO = '250728092728';
    DELETE FROM HOU_INFO_OPER WHERE BATCH_NO = '250728092728';
    DELETE FROM HOU_UNITS_OPER WHERE BATCH_NO = '250728092728';
    DELETE FROM PAY_DETAIL WHERE BATCH_NO = '250728092728';
    DELETE FROM PAY_SUM WHERE BATCH_NO = '250728092728';
    DELETE FROM TRADE WHERE BATCH_NO = '250728092728';
    DELETE FROM TRADE_BANK WHERE BATCH_NO = '250728092728';
    delete from BASE_ORG_MANAGEMENT_OPER where BATCH_NO = '250728092728';
    delete from BUSINESS_WATER_RELATION where BATCH_NO = '250728092728';
    delete from E_BILL_TASK where BATCH_NO = '250728092728';
    delete from ACCT_WATER where BATCH_NO = '250728092728';
    delete from REAL_ACCT_WATER where BATCH_NO = '250728092728';
    UPDATE COUNTER_RENEWAL_INFO SET OWN_PAY_STEP = 1 WHERE BATCH_NO = '250728092728';
    UPDATE NOTIFY_CUIJIAO_INFO SET RENEWAL_STATUS = 0 WHERE BATCH_NO = '250728092728';
    update BK_HX_ACCT_WATER set flag = '0' where HKBATCH like '%250728092728%';
END;
-------------------------------------入账-------------------------------------------------
-- 1. 创建payment_info数据 --> 已删除 <--
-- 2.

-- 恢复
begin
    delete from TRADE_LOG where BATCH_NO = '250728092728';
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

---------------------------------------------查看账户余额收支是否平衡---------------------------------------------------
-- 查看acctbal
select fund,
       owner,
       acct_type,
       acct_status,
       use_bal,
       bal,
       int_base,
       int_fix,
       create_date,
       last_clear,
       last_update,
       last_daybal,
       parent_fund,
       real_nmbr,
       acct_remark
from acct
where fund = 120000592800;
-- 查看贷方
select nvl(sum(amt), 0) as sum_amt
from acct_subject
where fund = 120000592800
  and sbj_id in (1010, 1030, 1050, 1070, 1061, 1033);
-- 查看借方
select nvl(sum(amt), 0) as sum_amt
from acct_subject
where fund = 120000592800
  and sbj_id in (2010, 2030, 2050, 2070, 3020, 2071);


