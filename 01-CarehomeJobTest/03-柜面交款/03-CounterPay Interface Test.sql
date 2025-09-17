-- 3301 --------------------------------按业主结存单续交码查询续交维修资金----------------------------------------------
select *
from NOTIFY_CUIJIAO_INFO;


-- 3302 --------------------------柜面购房人单边再交款接口（仅购房人交款）----------------------------------------------
-- 选择 120000692770
select *
from BASE_INFO
where MNG_ORG_ID = 200
  and INFO_TYPE = 60;

select *
from BASE_INFO
where INFO_ID = '120000692770';

-- houseId = 108191001016001011020
-- 2B94B03F-4A26-4A2F-8881-FFA9521F2301
select *
from HOU_INFO
where INFO_ID = '120000692770';

INSERT INTO HMFMSFD.BK_HX_ACCT_WATER (ID, WTR_NUM, ACC_NO, TXN_DTE, TXN_SEQ, TXN_SIG, TXN_AMT, HKBATCH, ACC_BAL,
                                      VCH_TYP, VCH_CDE, ABS_CDE, ABS_TXT, OPP_NO, ORG_NO, TXN_CDE, TXN_TME, OPP_NAM,
                                      CRT_DATE, CRT_TIME, FLAG, BATCH_NO, REMARK, WTR_TYP, USED_AMT, AVAILABLE_AMT,
                                      SUB_SEQ_NO, DOCUMENT_TYPE, DOCUMENT_ID, CLIENT_NO, CLIENT_TYPE, CH_CLIENT_NAME,
                                      PROD_TYPE, ACCT_CCY, ACCT_SEQ_NO, ACCT_STATUS, ACCT_BRANCH, ACCT_DESC,
                                      OTH_ACCT_DESC, OTH_BRANCH, OTH_BANK_NAME, OTH_BANK_CODE, REFERENCE,
                                      REVERSAL_TRAN_TYPE, TRAN_TYPE, CCY, TRAN_EVENT_TYPE, SOURCE_TYPE, TRAN_DESC,
                                      OTH_ACCT_CCY, TERMINAL_ID, AREA_CODE, CASH_ITEM, TRAN_STATUS, BATCH_NO_BANK,
                                      USER_ID, AUTH_USER_ID, APPR_USER_ID, TRAN_TIMESTAMP, CASH_RMTNC_FLG,
                                      CONTRA_DOCUMENT, CONTRA_DOCUMENT_ID, CASH_FLAG, OTH_TRAN_ADDR, FEE_AMT,
                                      IN_OUT_TRANSFER_TYPE, ACCT_CLASS, CYCLE_FLAG, NARRATIVE_CODE, LAST_BALANCE,
                                      DIRECTION, PAY_CHNNL_TP, IS_AGENCY_FAILURE_BACK_FLAG)
VALUES (998800, 'test998800', '20250508000001', '20250717', 2372, 'C', 1000.00, 'batch_no:250725001163;', 2000.00,
        null, null, null, '其他', '9048015130200001', null, null, '111111', '老旧小区柜面测试', null, null, '1', null,
        null, null, 1000.00, 0.00, null, null, '11120110000177113T', '200003402313', null, null, null, null, null, null,
        null, '天津市东丽区房地产管理局', null, null, '天津银行东丽支行', '313110040485', null, null, null, 'CNY', null,
        null, null, null, null, null, null, null, null, '13027', null, null, null, 'CA', null, null, null, null, null,
        null, null, null, null, null, null, null, null);
