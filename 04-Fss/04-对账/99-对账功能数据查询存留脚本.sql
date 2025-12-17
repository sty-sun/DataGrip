-- 查询某日银行流水发生额总额
select sum(abs(TRAN_AMT))
from HX_WATER_DETAIL
where TRAN_DATE = '20251207'
  and CR_DR_MAINT_IND = 'C';
-- 查询某日贷方清账金额
select sum(abs(CLEAR_AMT))
from HX_WATER_DIFF_CLEAR
where TRAN_DATE = '20251207'
  and CRDR = 'C';
-- 查询列表
select *
from HX_WATER_DIFF_CLEAR
where TRAN_DATE = '20251207'
  and CRDR = 'C';
-- 查询某日系统流水金额

select *
from REAL_ACCT_WATER
where REAL_NMBR like '%0869'
  and SYS_DATE = '20251206';