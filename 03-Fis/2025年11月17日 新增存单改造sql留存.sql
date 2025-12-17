-- 总金额 保管完成、已到期
select nvl(sum(deposit_amt)/1000000, 0) as deposit_amt_all
from Increment_Deposit_Info
where acct_code = '158001201110000869'
  and real_deposit_end_date <= '20251130'
  and real_deposit_end_date > = '20251114'
  and bus_type = '1'
  and deposit_status in ('8', '15')
order by real_deposit_end_date desc;
-- 一年期 保管完成、已到期
select nvl(sum(deposit_amt), 0) as deposit_amt
from Increment_Deposit_Info
where acct_code = '158001201110000869'
  and real_deposit_end_date <= '20251130'
  and real_deposit_end_date > = '20251114'
  and bus_type = '1'
  and deposit_status in ('8', '15')
  and deposit_term = '3'
order by real_deposit_end_date desc;
-- 三年期 保管完成、已到期
select nvl(sum(deposit_amt), 0) as deposit_amt
from Increment_Deposit_Info
where acct_code = '158001201110000869'
  and real_deposit_end_date <= '20251130'
  and real_deposit_end_date > = '20251114'
  and bus_type = '1'
  and deposit_status in ('8', '15')
  and deposit_term = '5'
order by real_deposit_end_date desc;
-- 一年期 + 三年期
select nvl(sum(deposit_amt)/1000000, 0) as deposit_amt
from Increment_Deposit_Info
where acct_code = '158001201110000869'
  and real_deposit_end_date <= '20251130'
  and real_deposit_end_date > = '20251114'
  and bus_type = '1'
  and deposit_status in ('8', '15')
  and deposit_term in ('3', '5')
order by real_deposit_end_date desc;

-- 一年期、三年期、五年期的存单金额及其比例 已支取、期限变更前
select deposit_term, sum(deposit_amt) / 10000 as group_total, round(sum(deposit_amt) / sum(sum(deposit_amt)) over () * 100, 2) as pzhanbi
from increment_deposit_info
where acct_code = '158001201110000869'
  and bus_type = '1'
  and deposit_status not in ('17', '9')
group by deposit_term;