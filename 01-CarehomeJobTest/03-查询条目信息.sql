-- 1. 获取续交未创建交易的条目信息
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
-- 2. 获取续交需要入账的条目信息
SELECT pay.batch_no,
       pay.info_id,
       pay.own_pay,
       hx.acc_no,
       tr.TRAN_TYPE,
       tr.TRAN_STATUS
FROM (SELECT p.batch_no,
             p.info_id,
             p.own_pay
      FROM counter_renewal_info p
      WHERE p.own_pay_step = 2) pay
         JOIN TRADE tr
              ON tr.batch_no = pay.batch_no
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
-- 3. 获取再交款未创建交易条目信息
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
-- 4. 获取再交款未入账条目信息
select pay.batch_no,
       pay.buy_pact_no,
       pay.info_id,
       pay.sum_tran_amt,
       tr.TRAN_TYPE,
       tr.TRAN_STATUS,
       hx.acc_no
from (select p.batch_no,
             p.buy_pact_no,
             p.info_id,
             (p.own_pay + nvl(p.dev_pay, 0)) as sum_tran_amt
      from counter_payment_info p
      where p.own_pay_step = 2) pay
         join TRADE tr on tr.BATCH_NO = pay.BATCH_NO
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



insert into Role_menu(menu_id,role_id) values('ukey','3');