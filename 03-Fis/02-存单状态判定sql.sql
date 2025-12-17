-- 存入审批中
select fii.RECEIPT_CODE,
       fii.RECEIPT_AMT,
       fii.DEPOSIT_PERIOD,
       fii.RATE,
       fii.BEGIN_DATE,
       fii.END_DATE,
       tb.DES_REAL_NMBR,
       tb.DES_BRANCH_NAME
from FIS_INCREMENT_INFO fii
         left join TRADE t
                   on fii.BATCH_NO = t.BATCH_NO
         left join TRADE_BANK tb
                   on t.BATCH_NO = tb.BATCH_NO
where fii.RECEIPT_STATUS = '0'
  and t.TRAN_STATUS != '44YiRuK';
-- 正常存续中
select fii.RECEIPT_CODE,
       fii.RECEIPT_AMT,
       fii.DEPOSIT_PERIOD,
       fii.RATE,
       fii.BEGIN_DATE,
       fii.END_DATE,
       tb.DES_REAL_NMBR,
       tb.DES_BRANCH_NAME
from FIS_INCREMENT_INFO fii
         left join trade t on fii.BATCH_NO = t.BATCH_NO
         left join TRADE_BANK tb
                   on t.BATCH_NO = tb.BATCH_NO
where fii.RECEIPT_STATUS = '0'
  and t.TRAN_STATUS = '44YiRuK'
  and END_DATE > sysdate;
-- 已到期
select fii.RECEIPT_CODE,
       fii.RECEIPT_AMT,
       fii.DEPOSIT_PERIOD,
       fii.RATE,
       fii.BEGIN_DATE,
       fii.END_DATE,
       tb.DES_REAL_NMBR,
       tb.DES_BRANCH_NAME
from FIS_INCREMENT_INFO fii
         left join TRADE t on fii.BATCH_NO = t.BATCH_NO
         left join TRADE_BANK tb
                   on t.BATCH_NO = tb.BATCH_NO
where fii.RECEIPT_STATUS = '0'
  and t.TRAN_STATUS = '44YiRuK'
  and END_DATE <= sysdate
  and not exists(select 1 from TRADE t2 where fii.BATCH_NO = t2.ORIGIN_BATCH_NO);
-- 支取审批中
select fii.RECEIPT_CODE,
       fii.RECEIPT_AMT,
       fii.DEPOSIT_PERIOD,
       fii.RATE,
       fii.BEGIN_DATE,
       fii.END_DATE,
       tb.DES_REAL_NMBR,
       tb.DES_BRANCH_NAME
from FIS_INCREMENT_INFO fii
         left join TRADE t on fii.BATCH_NO = t.BATCH_NO
         left join TRADE_BANK tb
                   on t.BATCH_NO = tb.BATCH_NO
where fii.RECEIPT_STATUS = '0'
  and t.TRAN_STATUS = '44YiRuK'
  and exists(select 1 from TRADE t2 where fii.BATCH_NO = t2.ORIGIN_BATCH_NO and t2.TRAN_STATUS != '44YiRuK');
-- 已支取
select fii.RECEIPT_CODE,
       fii.RECEIPT_AMT,
       fii.DEPOSIT_PERIOD,
       fii.RATE,
       fii.BEGIN_DATE,
       fii.END_DATE,
       tb.DES_REAL_NMBR,
       tb.DES_BRANCH_NAME
from FIS_INCREMENT_INFO fii
         left join TRADE t on fii.BATCH_NO = t.BATCH_NO
         left join TRADE_BANK tb
                   on t.BATCH_NO = tb.BATCH_NO
where fii.RECEIPT_STATUS in ('1', '2');

-- 合并起来
select *
from (select fii.RECEIPT_CODE,
             fii.RECEIPT_AMT,
             fii.DEPOSIT_PERIOD,
             fii.RATE,
             fii.BEGIN_DATE,
             fii.END_DATE,
             tb.DES_REAL_NMBR,
             tb.DES_BRANCH_NAME,
             '存入审批中' as STATE_NAME
      from FIS_INCREMENT_INFO fii
               left join TRADE t
                         on fii.BATCH_NO = t.BATCH_NO
               left join TRADE_BANK tb
                         on t.BATCH_NO = tb.BATCH_NO
      where fii.RECEIPT_STATUS = '0'
        and t.TRAN_STATUS != '44YiRuK'

      union all

      select fii.RECEIPT_CODE,
             fii.RECEIPT_AMT,
             fii.DEPOSIT_PERIOD,
             fii.RATE,
             fii.BEGIN_DATE,
             fii.END_DATE,
             tb.DES_REAL_NMBR,
             tb.DES_BRANCH_NAME,
             '正常存续中' as STATE_NAME
      from FIS_INCREMENT_INFO fii
               left join TRADE t
                         on fii.BATCH_NO = t.BATCH_NO
               left join TRADE_BANK tb
                         on t.BATCH_NO = tb.BATCH_NO
      where fii.RECEIPT_STATUS = '0'
        and t.TRAN_STATUS = '44YiRuK'
        and fii.END_DATE > to_char(sysdate, 'yyyyMMdd')

      union all

      select fii.RECEIPT_CODE,
             fii.RECEIPT_AMT,
             fii.DEPOSIT_PERIOD,
             fii.RATE,
             fii.BEGIN_DATE,
             fii.END_DATE,
             tb.DES_REAL_NMBR,
             tb.DES_BRANCH_NAME,
             '已到期' as STATE_NAME
      from FIS_INCREMENT_INFO fii
               left join TRADE t
                         on fii.BATCH_NO = t.BATCH_NO
               left join TRADE_BANK tb
                         on t.BATCH_NO = tb.BATCH_NO
      where fii.RECEIPT_STATUS = '0'
        and t.TRAN_STATUS = '44YiRuK'
        and fii.END_DATE <= to_char(sysdate, 'yyyyMMdd')
        and not exists (select 1
                        from TRADE t2
                        where fii.BATCH_NO = t2.ORIGIN_BATCH_NO)

      union all

      select fii.RECEIPT_CODE,
             fii.RECEIPT_AMT,
             fii.DEPOSIT_PERIOD,
             fii.RATE,
             fii.BEGIN_DATE,
             fii.END_DATE,
             tb.DES_REAL_NMBR,
             tb.DES_BRANCH_NAME,
             '支取审批中' as STATE_NAME
      from FIS_INCREMENT_INFO fii
               left join TRADE t
                         on fii.BATCH_NO = t.BATCH_NO
               left join TRADE_BANK tb
                         on t.BATCH_NO = tb.BATCH_NO
      where fii.RECEIPT_STATUS = '0'
        and t.TRAN_STATUS = '44YiRuK'
        and exists (select 1
                    from TRADE t2
                    where fii.BATCH_NO = t2.ORIGIN_BATCH_NO
                      and t2.TRAN_STATUS != '44YiRuK')

      union all

      select fii.RECEIPT_CODE,
             fii.RECEIPT_AMT,
             fii.DEPOSIT_PERIOD,
             fii.RATE,
             fii.BEGIN_DATE,
             fii.END_DATE,
             tb.DES_REAL_NMBR,
             tb.DES_BRANCH_NAME,
             '已支取' as STATE_NAME
      from FIS_INCREMENT_INFO fii
               left join TRADE t
                         on fii.BATCH_NO = t.BATCH_NO
               left join TRADE_BANK tb
                         on t.BATCH_NO = tb.BATCH_NO
      where fii.RECEIPT_STATUS in ('1', '2'))
order by RECEIPT_CODE desc;


select distinct ra.REAL_NMBR, ra.OWNER, ra.ACCT_TYPE, ra.ACCOUNT_NAME
from REAL_ACCT ra
         left join FSS_DATA_PERMISSION fdp on ra.REAL_NMBR = fdp.REAL_NMBR
where ACCT_TYPE in (210, 211)
  and fdp.USER_ID = 1;


-- 存入审批中
select *
from FIS_INCREMENT_INFO
where RECEIPT_STATUS = 0;
-- 正常存续中
select *
from FIS_INCREMENT_INFO
where RECEIPT_STATUS = 1;
-- 已到期
select *
from FIS_INCREMENT_INFO fii
where RECEIPT_STATUS = 1
  and not exists(select *
                 from TRADE t
                 where t.ORIGIN_BATCH_NO = fii.BATCH_NO);
-- 支取审批中
select *
from FIS_INCREMENT_INFO fii
where RECEIPT_STATUS = 1
  and exists(select *
             from trade t
             where t.ORIGIN_BATCH_NO = fii.BATCH_NO
               and t.TRAN_STATUS != '10JiaoYiWanCheng');
-- 已支取
select *
from FIS_INCREMENT_INFO fii
where RECEIPT_STATUS = 2;