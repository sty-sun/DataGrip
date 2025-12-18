-- 合并账户！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！
--1、修改 分户账户归属
update acct set real_nmbr='158001201110000869' where real_nmbr IN ('358001201110005366','358001201110016871','358001201110016107') and acct_type in ('570','571') and acct_status='0';

--2、修改在途交易申请 账户
update trade_bank tb set des_real_nmbr='158001201110000869' where des_real_nmbr in ('358001201110005366','358001201110016871','358001201110016107') and batch_no in (select batch_no from trade where  tran_status not in ('10JiaoYiWanCheng','11JiaoYiCheXiao'));

--3、修改 商品房维修资金本金户 158001201110000869

--3.1修改商品住宅 余额、可用余额
update real_acct set  use_bal=(select sum(use_bal) from acct where acct_type in ('570','571') and acct_status<>'2' ),bal=bal+(select sum(bal) from real_acct where owner='100' and real_nmbr in ('358001201110005366','358001201110016871','358001201110016107') ) where owner='100' and fund='100000000001' and real_nmbr='158001201110000869';

--3.2修改商品住宅科目 其它收入总额
update acct_subject set amt=amt+(select sum(decode(sbj_flag,2,amt,-1*amt)) from acct_subject  where fund  in  ('100000000003','100000000004','100000000005')  and sbj_level='1') where fund='100000000001' and sbj_id='1050';

--3.3增加商品住宅流水  账户调整  其它收入总额
Insert into REAL_ACCT_WATER
(BATCH_NO, FUND, SUB_WATER, TRAN_DATE, TRAN_TIME,
 SYS_DATE, SYS_TIME, TRAN_FLAG, TRAN_TYPE, TRAN_AMT,
 END_BAL, LAST_BAL, IS_CANCEL, TRAN_ACTION, OWNER,
 SECT_ID, SBJ_ID, ACCT_TYPE, ACCT_STATUS, USE_BAL,
 BAL, INT_BASE, INT_FIX, CREATE_DATE, LAST_CLEAR,
 LAST_UPDATE, LAST_DAYBAL, PARENT_FUND, REAL_NMBR, BANK_BAL,
 STR_REMARK)
Values
    (substr(to_char(SYSDATE, 'YYYYMMDD'),3)||'999999' , 100000000001, 1, to_char(SYSDATE, 'YYYYMMDD'), '164737',
     to_char(SYSDATE, 'YYYYMMDD'), '164737', '2', '3150', (select sum(bal) from real_acct where owner='100' and fund in  ('100000000003','100000000004','100000000005')) ,
     0, 0, '0', 'cun', 100,
     '', 1050, '210', '0', 0,
     0, 0, 0, to_char(SYSDATE, 'YYYYMMDD'), to_char(SYSDATE, 'YYYYMMDD'),
     to_char(SYSDATE, 'YYYYMMDD'), 0, 0, '158001201110000869', 0,
     '账户合并');

--4、修改 原有住宅维修资金本金户
--4.1增加原有住宅流水 账户调整  其他支出总额
Insert into REAL_ACCT_WATER
(BATCH_NO, FUND, SUB_WATER, TRAN_DATE, TRAN_TIME,
 SYS_DATE, SYS_TIME, TRAN_FLAG, TRAN_TYPE, TRAN_AMT,
 END_BAL, LAST_BAL, IS_CANCEL, TRAN_ACTION, OWNER,
 SECT_ID, SBJ_ID, ACCT_TYPE, ACCT_STATUS, USE_BAL,
 BAL, INT_BASE, INT_FIX, CREATE_DATE, LAST_CLEAR,
 LAST_UPDATE, LAST_DAYBAL, PARENT_FUND, REAL_NMBR, BANK_BAL,
 STR_REMARK)
Values
    (substr(to_char(SYSDATE, 'YYYYMMDD'),3)||'999999' , 100000000003, 1, to_char(SYSDATE, 'YYYYMMDD'), '164737',
     to_char(SYSDATE, 'YYYYMMDD'), '164737', '1', '3150', (select sum(bal) from real_acct where owner='100' and fund in  ('100000000003')) ,
     0, 0, '0', 'qu', 100,
     '', 2050, '210', '0', 0,
     0, 0, 0, to_char(SYSDATE, 'YYYYMMDD'), to_char(SYSDATE, 'YYYYMMDD'),
     to_char(SYSDATE, 'YYYYMMDD'), 0, 0, '358001201110005366', 0,
     '账户合并');

--4.2 修改 原有住宅 账户状态为注销  清空可用余额、余额
update real_acct set acct_status='2' ,use_bal=use_bal-use_bal,bal=bal-bal where owner='100' and fund='100000000003' and real_nmbr='358001201110005366';

--4、3修改 原有住宅维修资金本金户 科目 其他支出总额
update acct_subject set amt=amt+(select sum(decode(sbj_flag,2,amt,-1*amt)) from acct_subject  where fund='100000000003' and sbj_level='1') where fund='100000000003' and sbj_id='2050';

--5、修改 非住宅维修资金本金户
--5.1增加非住宅流水 账户调整  其他支出总额
Insert into REAL_ACCT_WATER
(BATCH_NO, FUND, SUB_WATER, TRAN_DATE, TRAN_TIME,
 SYS_DATE, SYS_TIME, TRAN_FLAG, TRAN_TYPE, TRAN_AMT,
 END_BAL, LAST_BAL, IS_CANCEL, TRAN_ACTION, OWNER,
 SECT_ID, SBJ_ID, ACCT_TYPE, ACCT_STATUS, USE_BAL,
 BAL, INT_BASE, INT_FIX, CREATE_DATE, LAST_CLEAR,
 LAST_UPDATE, LAST_DAYBAL, PARENT_FUND, REAL_NMBR, BANK_BAL,
 STR_REMARK)
Values
    (substr(to_char(SYSDATE, 'YYYYMMDD'),3)||'999999' , 100000000004, 1, to_char(SYSDATE, 'YYYYMMDD'), '164737',
     to_char(SYSDATE, 'YYYYMMDD'), '164737', '1', '3150', (select sum(bal) from real_acct where owner='100' and fund in  ('100000000004')) ,
     0, 0, '0', 'qu', 100,
     '', 2050, '210', '0', 0,
     0, 0, 0, to_char(SYSDATE, 'YYYYMMDD'), to_char(SYSDATE, 'YYYYMMDD'),
     to_char(SYSDATE, 'YYYYMMDD'), 0, 0, '358001201110016871', 0,
     '账户合并');

--5.2 修改 非住宅账户状态为注销  清空可用余额、余额
update real_acct set acct_status='2' ,use_bal=use_bal-use_bal,bal=bal-bal where owner='100' and fund='100000000004' and real_nmbr='358001201110016871';

-- 5.3修改 非住宅维修资金本金户 科目 其他支出总额
update acct_subject set amt=amt+(select sum(decode(sbj_flag,2,amt,-1*amt)) from acct_subject  where fund='100000000004' and sbj_level='1') where fund='100000000004' and sbj_id='2050';

--6、修改 合作建房维修资金本金户
--6.1增加合作建房流水 账户调整  其他支出总额
Insert into REAL_ACCT_WATER
(BATCH_NO, FUND, SUB_WATER, TRAN_DATE, TRAN_TIME,
 SYS_DATE, SYS_TIME, TRAN_FLAG, TRAN_TYPE, TRAN_AMT,
 END_BAL, LAST_BAL, IS_CANCEL, TRAN_ACTION, OWNER,
 SECT_ID, SBJ_ID, ACCT_TYPE, ACCT_STATUS, USE_BAL,
 BAL, INT_BASE, INT_FIX, CREATE_DATE, LAST_CLEAR,
 LAST_UPDATE, LAST_DAYBAL, PARENT_FUND, REAL_NMBR, BANK_BAL,
 STR_REMARK)
Values
    (substr(to_char(SYSDATE, 'YYYYMMDD'),3)||'999999' , 100000000005, 1, to_char(SYSDATE, 'YYYYMMDD'), '164737',
     to_char(SYSDATE, 'YYYYMMDD'), '164737', '1', '3150', (select sum(bal) from real_acct where owner='100' and fund in  ('100000000005')) ,
     0, 0, '0', 'qu', 100,
     '', 2050, '210', '0', 0,
     0, 0, 0, to_char(SYSDATE, 'YYYYMMDD'), to_char(SYSDATE, 'YYYYMMDD'),
     to_char(SYSDATE, 'YYYYMMDD'), 0, 0, '358001201110016107', 0,
     '账户合并');

--6.2 修改 合作建房账户状态为注销  清空可用余额、余额
update real_acct set acct_status='2' ,use_bal=use_bal-use_bal,bal=bal-bal where owner='100' and fund='100000000005' and real_nmbr='358001201110016107';

--6.3 修改 非住宅维修资金本金户 科目 其他支出总额
update acct_subject set amt=amt+(select sum(decode(sbj_flag,2,amt,-1*amt)) from acct_subject  where fund='100000000005' and sbj_level='1') where fund='100000000005' and sbj_id='2050';

-- 2.