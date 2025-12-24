select sum(abs(TRAN_AMT))
from HX_WATER_DETAIL
where TRAN_DATE = '20251216'
  and CR_DR_MAINT_IND = 'D'
  and BASE_ACCT_NO in ('158001201110000869');

select sum(NEW_DIFF_AMT - CLEARED_AMT)
from HX_WATER_DIFF_NEW
where TRAN_DATE = '20251216'
  and CRDR = 'D'
  and BASE_ACCT_NO in ('158001201110000869');

select *
from HX_WATER_DIFF_NEW
where TRAN_DATE = '20251216'
  and CRDR = 'D'
  and BASE_ACCT_NO in ('158001201110000869');

select *
from HX_WATER_DETAIL
where TRAN_DATE = '20251216'
  and CR_DR_MAINT_IND = 'D'
  and ID not in (select WATER_ID
                 from HX_WATER_DIFF_NEW
                 where TRAN_DATE = '20251216'
                   and CRDR = 'D'
                   and BASE_ACCT_NO in ('158001201110000869'));


select *
from REAL_ACCT_WATER
where SYS_DATE = '20251216'
  and REAL_NMBR in ('158001201110000869')
  and TRAN_FLAG = '1'; -- 251212000630

select *
from BUSINESS_WATER_RELATION
where BATCH_NO = '251212000630';

select *
from HX_WATER_DETAIL
where ID = '600275';

select *
from HX_WATER_DIFF_NEW
where BATCH_NO = '251212000630';

select *
from HX_WATER_DIFF_CLEAR
where DIFF_ID = '61009946577731584';

select sum((n.new_diff_amt - nvl(c.cleared_amt_eod, 0)))
from hx_water_diff_new n
         left join (select diff_id, sum(clear_amt) as cleared_amt_eod
                    from hx_water_diff_clear
                    where clear_date <= :bizDate
                    group by diff_id) c
                   on c.diff_id = n.diff_id
where n.post_date = :bizDate
  and n.CRDR = 'C'
  and n.BASE_ACCT_NO = '158001201110000869';

select *
from hx_water_diff_new n
         left join (select diff_id, sum(clear_amt) as cleared_amt_eod
                    from hx_water_diff_clear
                    where clear_date <= :bizDate
                    group by diff_id) c
                   on c.diff_id = n.diff_id
where n.post_date = :bizDate
  and n.BASE_ACCT_NO = '158001201110000869';


select n.*, (n.NEW_DIFF_AMT - nvl(c.CLEARED_AMT_EOD, 0)) as remainAmt
from HX_WATER_DIFF_NEW n
         left join (select DIFF_ID, sum(CLEAR_AMT) as CLEARED_AMT_EOD from HX_WATER_DIFF_CLEAR where 1 = 1 and CLEAR_DATE <= '20251216' group by DIFF_ID) c on c.DIFF_ID = n.DIFF_ID
where 1 = 1
  and n.POST_DATE >= '20251216'
  and n.POST_DATE <= '20251216'
  and n.BASE_ACCT_NO = '158001201110000869'
  and n.DIFF_SOURCE = 'B';


select n.*, (n.NEW_DIFF_AMT - nvl(c.CLEARED_AMT_EOD, 0)) as remainAmt
from HX_WATER_DIFF_NEW n
         left join (select DIFF_ID, sum(CLEAR_AMT) as CLEARED_AMT_EOD from HX_WATER_DIFF_CLEAR where 1 = 1 and CLEAR_DATE <= '20251216' group by DIFF_ID) c on c.DIFF_ID = n.DIFF_ID
where 1 = 1
  and n.POST_DATE >= '20251216'
  and n.POST_DATE <= '20251216'
  and n.BASE_ACCT_NO = '158001201110000869'
  and n.DIFF_SOURCE = 'T';


select sum(TRAN_AMT)
from HX_WATER_DETAIL
where TRAN_DATE = '20251216'
  and CR_DR_MAINT_IND = 'C'
  and BASE_ACCT_NO in ('158001201110000869');

select distinct BATCH_NO
from REAL_ACCT_WATER
where SYS_DATE = '20251216'
  and REAL_NMBR in ('158001201110000869')
  and TRAN_FLAG = '2';


select *
from HX_WATER_DETAIL aa
where ID not in (select distinct bb.BK_ID
                 from BUSINESS_WATER_RELATION bb
                 where bb.BATCH_NO in (select distinct cc.BATCH_NO
                                       from REAL_ACCT_WATER cc
                                       where SYS_DATE = '20251216'
                                         and REAL_NMBR in ('158001201110000869')
                                         and TRAN_FLAG = '2')
                   and bb.CREATE_DATE = '20251216')
  and aa.TRAN_DATE = '20251216'
  and aa.BASE_ACCT_NO = '158001201110000869'
  and aa.ID not in (select WATER_ID from HX_WATER_DIFF_NEW dd where dd.POST_DATE = '20251216' and dd.BASE_ACCT_NO = '158001201110000869' and dd.DIFF_SOURCE = 'B');



select sum(remainAmt)
from (select n.*, (n.NEW_DIFF_AMT - nvl(c.CLEARED_AMT_EOD, 0)) as remainAmt
      from HX_WATER_DIFF_NEW n
               left join (select DIFF_ID, sum(CLEAR_AMT) as CLEARED_AMT_EOD from HX_WATER_DIFF_CLEAR where 1 = 1 and CLEAR_DATE <= '20251216' group by DIFF_ID) c on c.DIFF_ID = n.DIFF_ID
      where 1 = 1
        and n.POST_DATE >= '20251216'
        and n.POST_DATE <= '20251216'
        and n.BASE_ACCT_NO = '158001201110000869'
        and n.DIFF_SOURCE = 'B'
        and n.CRDR = 'C');



select *
from REAL_ACCT_WATER cc
where cc.BATCH_NO not in (select distinct BATCH_NO
                          from BUSINESS_WATER_RELATION aa
                          where BK_ID in (select ID
                                          from HX_WATER_DETAIL bb
                                          where TRAN_DATE = '20251216'
                                            and CR_DR_MAINT_IND = 'C'
                                            and BASE_ACCT_NO in ('158001201110000869')))
  and SYS_DATE = '20251216'
  and REAL_NMBR in ('158001201110000869')
  and TRAN_FLAG = '2';

select *
from BUSINESS_WATER_RELATION
where BATCH_NO = '251216000296';

select *
from HX_WATER_DETAIL
where ID = '600011';

select *
from HX_WATER_DIFF_NEW
where WATER_ID = '600011';

select *
from HX_WATER_DIFF_CLEAR aa
         join HX_WATER_DIFF_NEW bb on aa.DIFF_ID = bb.DIFF_ID
where 1 = 1
  and aa.CLEAR_DATE >= '20251216'
  and aa.CLEAR_DATE <= '20251216'
  and aa.BASE_ACCT_NO = '158001201110000869'
  and bb.DIFF_SOURCE = 'T';