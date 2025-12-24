-- 0.数据准备
INSERT INTO HMFMSFD.FSS_DATA_PERMISSION (DP_ID, USER_ID, REAL_NMBR, DESCRIPTION, ISDEL, CREATE_BY, UPDATE_BY,
                                         CREATE_TIME, UPDATE_TIME, MNG_ORG_ID)
VALUES (1, 1, '158001201110000869', '1', 0, ' ', ' ', NULL, NULL, 100);
-- 1.1 将查到的数据插入到15的库中
-- 需要注意的是，有一个是1月之前创建但是在1月之后才有的，batch_no: 241226001365
INSERT INTO TRADE
SELECT t.*
FROM TRADE@DB_LINK_15_17 t
WHERE t.TRAN_TYPE = 3110
  AND t.TRAN_STATUS <> '11JiaoYiCheXiao'
  AND t.reg_date >= 20250101
  AND NOT EXISTS (SELECT 1
                  FROM TRADE l
                  WHERE l.BATCH_NO = t.BATCH_NO);

-- 1.2 将trade表更新为在途交易
UPDATE TRADE
SET TRAN_STATUS  = '09ZaiTuJiaoYi',
    FINISH_TIME  = NULL,
    FINISH_DATE  = NULL,
    SYS_DATE     = NULL,
    SYS_TIME     = NULL,
    MNG_ORG_ID   = 100,
    MNG_ORG_NAME = '天津市住房保障服务中心'
WHERE BATCH_NO IN (SELECT t.BATCH_NO
                   FROM TRADE@DB_LINK_15_17 t
                   WHERE t.TRAN_TYPE = 3110
                     AND t.TRAN_STATUS <> '11JiaoYiCheXiao'
                     AND t.reg_date >= 20250101);
-- 2.1 插入trade_bank表
INSERT INTO TRADE_BANK
SELECT *
FROM TRADE_BANK@DB_LINK_15_17
WHERE BATCH_NO IN (SELECT t.BATCH_NO
                   FROM TRADE@DB_LINK_15_17 t
                   WHERE t.TRAN_TYPE = 3110
                     AND t.TRAN_STATUS <> '11JiaoYiCheXiao'
                     AND t.SYS_DATE >= 20250101
                     AND t.BATCH_NO <> 241226001365);
-- 2.2 更新trade_bank表中所有不为0869的账号
UPDATE TRADE_BANK
SET DES_REAL_NMBR = 158001201110000869
WHERE BATCH_NO IN (SELECT t.BATCH_NO
                   FROM TRADE@DB_LINK_15_17 t
                   WHERE t.TRAN_TYPE = 3110
                     AND t.TRAN_STATUS <> '11JiaoYiCheXiao'
                     AND t.SYS_DATE >= 20250101)
  AND DES_REAL_NMBR <> 158001201110000869;
-- 3. 插入操作表数据
INSERT INTO BASE_INFO_OPER
SELECT b.*, 100 AS MNG_ORG_ID
FROM BASE_INFO_OPER@DB_LINK_15_17 b
WHERE b.BATCH_NO IN (SELECT t.BATCH_NO
                     FROM TRADE@DB_LINK_15_17 t
                     WHERE t.TRAN_TYPE = 3110
                       AND t.TRAN_STATUS <> '11JiaoYiCheXiao'
                       AND t.SYS_DATE >= 20250101
                       AND t.BATCH_NO <> 241226001365);

INSERT INTO HOU_INFO_OPER
SELECT b.*
FROM HOU_INFO_OPER@DB_LINK_15_17 b
WHERE b.BATCH_NO IN (SELECT t.BATCH_NO
                     FROM TRADE@DB_LINK_15_17 t
                     WHERE t.TRAN_TYPE = 3110
                       AND t.TRAN_STATUS <> '11JiaoYiCheXiao'
                       AND t.SYS_DATE >= 20250101
                       AND t.BATCH_NO <> 241226001365);

INSERT INTO HOU_UNITS_OPER
SELECT b.*
FROM HOU_UNITS_OPER@DB_LINK_15_17 b
WHERE b.BATCH_NO IN (SELECT t.BATCH_NO
                     FROM TRADE@DB_LINK_15_17 t
                     WHERE t.TRAN_TYPE = 3110
                       AND t.TRAN_STATUS <> '11JiaoYiCheXiao'
                       AND t.SYS_DATE >= 20250101
                       AND t.BATCH_NO <> 241226001365);

-- 4. 插入pay_detail数据
INSERT INTO PAY_DETAIL
SELECT a.*
FROM (SELECT *
      FROM PAY_DETAIL@DB_LINK_15_17
      WHERE BATCH_NO IN (SELECT t.BATCH_NO
                         FROM TRADE@DB_LINK_15_17 t
                         WHERE t.TRAN_TYPE = 3110
                           AND t.TRAN_STATUS <> '11JiaoYiCheXiao'
                           AND t.SYS_DATE >= 20250101
                           AND t.BATCH_NO <> 241226001365)) a;
-- 插入pay_sum
INSERT INTO PAY_SUM
SELECT a.*, 0 AS IS_AUTO_ENTRYACCT
FROM (SELECT *
      FROM PAY_SUM@DB_LINK_15_17
      WHERE BATCH_NO IN (SELECT t.BATCH_NO
                         FROM TRADE@DB_LINK_15_17 t
                         WHERE t.TRAN_TYPE = 3110
                           AND t.TRAN_STATUS <> '11JiaoYiCheXiao'
                           AND t.SYS_DATE >= 20250101
                           AND t.BATCH_NO <> 241226001365)) a;
-- 将1月1日之前的交易更新为人工勾兑类型
UPDATE PAY_SUM
SET IS_AUTO_ENTRYACCT = 0
WHERE BATCH_NO = '241226001365';