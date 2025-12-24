-- =========================== 查询流水 ==========================
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
-- =========================== 查询流水与挂账的对应关系 ==========================

select *  --  nvl(sum(abs(TRAN_AMT)), 0) as totalAmt
from REAL_ACCT_WATER
where TRAN_FLAG = '1'
  and SYS_DATE = '20251216'
  and REAL_NMBR in ('158001201110000869', '358001201110005366', '358001201110016871', '358001201110016107')
  and BATCH_NO not in (select aa.BATCH_NO
                       from HX_WATER_DIFF_NEW aa
                       where aa.CLEAR_STATUS in ('0', '1')
                         and aa.POST_DATE >= '20251216'
                         and aa.POST_DATE <= '20251216'
                         and aa.BASE_ACCT_NO = '158001201110000869'
                         and aa.DIFF_SOURCE = 'T');

select *
from REAL_ACCT_WATER
where TRAN_FLAG = '1'
  and SYS_DATE = '20251216'
  and REAL_NMBR in ('158001201110000869', '358001201110005366', '358001201110016871', '358001201110016107');

select nvl(sum(abs(TRAN_AMT)), 0) as totalAmt
from REAL_ACCT_WATER
where TRAN_FLAG = '1'
  and SYS_DATE = '20251216'
  and REAL_NMBR in ('158001201110000869', '358001201110005366', '358001201110016871', '358001201110016107');

select * --  nvl(sum(abs(TRAN_AMT)), 0) as totalAmt
from HX_WATER_DIFF_NEW aa
where aa.CLEAR_STATUS in ('0', '1')
  and aa.POST_DATE >= '20251216'
  and aa.POST_DATE <= '20251216'
  and aa.BASE_ACCT_NO = '158001201110000869'
  and aa.DIFF_SOURCE = 'T';

select *  --  nvl(sum(abs(TRAN_AMT)), 0) as totalAmt
from REAL_ACCT_WATER
where TRAN_FLAG = '1'
  and SYS_DATE = '20251216'
  and REAL_NMBR in ('158001201110000869', '358001201110005366', '358001201110016871', '358001201110016107')
  and BATCH_NO not in (select aa.BATCH_NO
                       from HX_WATER_DIFF_NEW aa
                       where aa.CLEAR_STATUS in ('0', '1')
                         and aa.POST_DATE >= '20251216'
                         and aa.POST_DATE <= '20251216'
                         and aa.BASE_ACCT_NO = '158001201110000869'
                         and aa.DIFF_SOURCE = 'T');
-- =========================== 查询挂账清账 ==========================
insert into HMFMSFD.FSS_DAILY_BAL_ADJ_ITEM_CFG (CFG_ID, ACCT_NO, SIDE_TYPE, ADJ_TYPE, ITEM_CODE, ITEM_NAME, DEFAULT_AMT, EFFECT_START_DATE, EFFECT_END_DATE, REASON, DISPLAY_ORDER, IS_DEL, CREATE_TIME,
                                                CREATE_USER, UPDATE_TIME, UPDATE_USER)
values (1, '158001201110000869', 'B', 'S', 'BK_FIX', '银行长期应减-历史差额冲减', 26019652.63, '20251217', '20991231', '历史差额冲减（长期有效配置，按对账口径固定扣减）', 1, '0',
        timestamp '2025-12-18 15:47:02', 'system', null, null);
-- 银行侧贷方清账（T0 前，应减）
insert into fss_daily_bal_adj_item_cfg
(cfg_id, acct_no, side_type, adj_type, item_code, item_name, default_amt,
 effect_start_date, effect_end_date, reason, is_del, display_order,
 create_time, create_user, update_time, update_user)
values (2, '158001201110000869', 'B', 'S', 'BANK_CLR_BEFORE_CR', '银行清账(T0前)-贷方', 0.00,
        '20251216', 20991231, 'T0前清账贷方金额（展示+应减）', 'N', 2,
        sysdate, 'system', sysdate, 'system');

-- 银行侧借方清账（T0 前，应加）
insert into fss_daily_bal_adj_item_cfg
(cfg_id, acct_no, side_type, adj_type, item_code, item_name, default_amt,
 effect_start_date, effect_end_date, reason, is_del, display_order,
 create_time, create_user, update_time, update_user)
values (3, '158001201110000869', 'B', 'A', 'BANK_CLR_BEFORE_DR', '银行清账(T0前)-借方', 0.00,
        '20251216', 20991231, 'T0前清账借方金额（展示+应加）', 'N', 2,
        sysdate, 'system', sysdate, 'system');

-- 系统侧贷方清账（T0 前，应减）
insert into fss_daily_bal_adj_item_cfg
(cfg_id, acct_no, side_type, adj_type, item_code, item_name, default_amt,
 effect_start_date, effect_end_date, reason, is_del, display_order,
 create_time, create_user, update_time, update_user)
values (4, '158001201110000869', 'S', 'S', 'SYS_CLR_BEFORE_CR', '系统清账(T0前)-贷方', 0.00,
        '20251216', 20991231, 'T0前清账贷方金额（展示+应减）', 'N', 1,
        sysdate, 'system', sysdate, 'system');

-- 系统侧借方清账（T0 前，应加）
insert into fss_daily_bal_adj_item_cfg
(cfg_id, acct_no, side_type, adj_type, item_code, item_name, default_amt,
 effect_start_date, effect_end_date, reason, is_del, display_order,
 create_time, create_user, update_time, update_user)
values (5, '158001201110000869', 'S', 'A', 'SYS_CLR_BEFORE_DR', '系统清账(T0前)-借方', 0.00,
        '20251216', 20991231, 'T0前清账借方金额（展示+应加）', 'N', 1,
        sysdate, 'system', sysdate, 'system');