-- -------------------------创建交易---------------------------
-- 1. 创建一个batchNo
insert into BATCH_PAY_LOG(batch_no, oper_time, no_status)
VALUES ('250721102706', '20250721102706', 0);
-- 2. 创建一个需要创建交易的数据
-- 2.1 找一个hou_info和base_info的联立数据
select *
from HOU_INFO
         join BASE_INFO on HOU_INFO.INFO_ID = BASE_INFO.INFO_ID
where BASE_INFO.INFO_ID = '120001038728';
-- 选择 120001038728 谷荣珍 滨海新区宏苑10-1-701
-- buy_pact_no : 2009-0060885
-- 2.2 找到所属项目信息
select *
from OWNER_INFO
where INFO_ID = '120001038728'
  and SUPER_TYPE = '30';
-- super_id = '120000623350'
-- 2.3 插入counter_payment_info数据
insert into COUNTER_PAYMENT_INFO(BATCH_NO, BUY_PACT_NO, IMP_DATE, IMP_TIME, OWN_PAY, OWN_PAY_STEP, DEV_PAY,
                                 DEV_PAY_STEP, OWN_WATER_NUM, OWN_PAY_DATE, OWN_PAY_TIME, INFO_ID)
values ('250721102706', '', '20250718', '094551', 4000,
        1, 0, 1, '20220420135208000635038',
        '20250718', '094551', '120000624557');
-- 2.4 插入核心流水数据
INSERT INTO bk_hx_acct_water (id, hkbatch, acc_no, TXN_DTE, TXN_SEQ, txn_tme, txn_sig, txn_amt, flag, tran_desc)
VALUES ('999988', '250721102706;', '158001201110000869', '20201119', '1', '20250718095050', 'C', 4000.0, '0',
        'description 1');
-- 2.5 final 能够在getCounterPayDataList 中查询到
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
-- 3. 查询合同信息
SELECT *
FROM (SELECT (SELECT super_id
              FROM owner_info
              WHERE super_type = '30'
                AND info_id = hou.info_id)                   AS sect_id,
             (SELECT sect.info_code
              FROM base_info bi
                       JOIN owner_info oi
                            ON bi.info_id = oi.info_id
                       JOIN base_info sect
                            ON sect.info_id = oi.super_id
              WHERE bi.info_type = '60'
                AND oi.super_type = '30'
                AND bi.info_id = hou.info_id)                AS sect_code,
             hou.info_id,
             info.info_area,
             hou.hou_pay_type,
             pay.own_pay,
             pay.own_water_num,
             NVL(info.info_name, pay.own_name)               AS info_name,
             info.info_type,
             DECODE(pay.lift_flag, '1', '1', hou.exist_flag) AS exist_flag,
             NVL(hou.cert_type, pay.cert_type)               AS cert_type,
             NVL(hou.cert_code, pay.cert_code)               AS cert_code
      FROM hou_info hou
               JOIN base_info info
                    ON hou.info_id = info.info_id
               JOIN counter_payment_info pay
                    ON hou.buy_pact_no = pay.buy_pact_no
                        OR hou.info_id = pay.info_id
      where hou.INFO_ID = '120000624557') hip;
-- -------------------------------------------创建交易测试过程中需要恢复的oper表------------------------------------------------
begin
    delete from SECTIONS_OPER where BATCH_NO = '250721102706';
    delete from BASE_INFO_OPER where BATCH_NO = '250721102706';
    delete from BASE_ORG_MANAGEMENT_OPER where BATCH_NO = '250721102706';
    delete from OWNER_INFO_OPER where BATCH_NO = '250721102706';
    delete from HOU_INFO_OPER where BATCH_NO = '250721102706';
    delete from HOU_UNITS_OPER where BATCH_NO = '250721102706';
    delete from PAY_DETAIL where BATCH_NO = '250721102706';
    delete from PAY_SUM where BATCH_NO = '250721102706';
    delete from TRADE where BATCH_NO = '250721102706';
    delete from E_BILL_TASK where BATCH_NO = '250721102706';
    delete from ACCT_WATER where BATCH_NO = '250721102706';
    delete from REAL_ACCT_WATER where BATCH_NO = '250721102706';
    delete from FURTHER_PAYMENT_INFO where BATCH_NO = '250721102706';
    update COUNTER_PAYMENT_INFO set OWN_PAY_STEP = 1 where BATCH_NO = '250721102706';
    update BK_HX_ACCT_WATER set flag = '0' where HKBATCH like '250721102706;';

    delete from SECTIONS_OPER where BATCH_NO = '250718084638';
    delete from BASE_INFO_OPER where BATCH_NO = '250718084638';
    delete from BASE_ORG_MANAGEMENT_OPER where BATCH_NO = '250718084638';
    delete from OWNER_INFO_OPER where BATCH_NO = '250718084638';
    delete from HOU_INFO_OPER where BATCH_NO = '250718084638';
    delete from HOU_UNITS_OPER where BATCH_NO = '250718084638';
    delete from PAY_DETAIL where BATCH_NO = '250718084638';
    delete from PAY_SUM where BATCH_NO = '250718084638';
    delete from TRADE where BATCH_NO = '250718084638';
    delete from E_BILL_TASK where BATCH_NO = '250718084638';
    delete from ACCT_WATER where BATCH_NO = '250718084638';
    delete from REAL_ACCT_WATER where BATCH_NO = '250718084638';
    delete from FURTHER_PAYMENT_INFO where BATCH_NO = '250718084638';
    update COUNTER_PAYMENT_INFO set OWN_PAY_STEP = 1 where BATCH_NO = '250718084638';
    update BK_HX_ACCT_WATER set flag = '0' where HKBATCH like '%250718084638;';
end;
------------------------------------------------合同表------------------------------------------------------------------