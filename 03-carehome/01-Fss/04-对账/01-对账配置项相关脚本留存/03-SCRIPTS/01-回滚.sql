-- =========================
-- 0) 参数（先改这里）
-- =========================
DEFINE p_acct_no     = '你的专户账号';
DEFINE p_rollback_dt = '20260201';
-- yyyyMMdd，回滚到该日（保留该日）
-- 先看影响行数
SELECT 'FSS_RECON_SUM' AS TBL, COUNT(*) AS CNT
FROM FSS_RECON_SUM R
WHERE R.ACCT_NO = '&p_acct_no'
  AND R.RECON_DATE > '&p_rollback_dt'
UNION ALL
SELECT 'FSS_RECON_DETAILS', COUNT(*)
FROM FSS_RECON_DETAILS D
WHERE EXISTS ( SELECT 1
               FROM FSS_RECON_SUM R
               WHERE R.RECON_ID = D.RECON_ID
                 AND R.ACCT_NO = '&p_acct_no'
                 AND R.RECON_DATE > '&p_rollback_dt' )
UNION ALL
SELECT 'FSS_BALANCE_CFG_SNP', COUNT(*)
FROM FSS_BALANCE_CFG_SNP S
WHERE EXISTS ( SELECT 1
               FROM FSS_RECON_DETAILS D
                        JOIN FSS_RECON_SUM R ON R.RECON_ID = D.RECON_ID
               WHERE D.SHEET_ID = S.SHEET_ID
                 AND R.ACCT_NO = '&p_acct_no'
                 AND R.RECON_DATE > '&p_rollback_dt' )
UNION ALL
SELECT 'FSS_BALANCE_CFG_LOG', COUNT(*)
FROM FSS_BALANCE_CFG_LOG L
WHERE L.ACCT_NO = '&p_acct_no'
  AND L.BIZ_DATE > '&p_rollback_dt';
-- =========================
-- 1) 可选备份（强烈建议）
--    表名后缀请改成你自己的批次号，避免重名
-- =========================
CREATE TABLE BAK_RECON_SUM_20260201 AS
SELECT *
FROM FSS_RECON_SUM
WHERE ACCT_NO = '&p_acct_no'
  AND RECON_DATE > '&p_rollback_dt';
CREATE TABLE BAK_RECON_DETAILS_20260201 AS
SELECT D.*
FROM FSS_RECON_DETAILS D
WHERE EXISTS ( SELECT 1
               FROM FSS_RECON_SUM R
               WHERE R.RECON_ID = D.RECON_ID
                 AND R.ACCT_NO = '&p_acct_no'
                 AND R.RECON_DATE > '&p_rollback_dt' );
CREATE TABLE BAK_CFG_SNP_20260201 AS
SELECT S.*
FROM FSS_BALANCE_CFG_SNP S
WHERE EXISTS ( SELECT 1
               FROM FSS_RECON_DETAILS D
                        JOIN FSS_RECON_SUM R ON R.RECON_ID = D.RECON_ID
               WHERE D.SHEET_ID = S.SHEET_ID
                 AND R.ACCT_NO = '&p_acct_no'
                 AND R.RECON_DATE > '&p_rollback_dt' );
CREATE TABLE BAK_CFG_20260201 AS
SELECT *
FROM FSS_BALANCE_CFG
WHERE ACCT_NO = '&p_acct_no';
CREATE TABLE BAK_CFG_LOG_20260201 AS
SELECT *
FROM FSS_BALANCE_CFG_LOG
WHERE ACCT_NO = '&p_acct_no'
  AND BIZ_DATE > '&p_rollback_dt';
-- =========================
-- 2) 执行回滚
-- =========================
DECLARE
    V_ACCT_NO      VARCHAR2(64) := '&p_acct_no';
    V_ROLLBACK_DT  VARCHAR2(8)  := '&p_rollback_dt';
    V_REF_SHEET_ID NUMBER;
BEGIN
    -- 2.1 找“回滚日(含)最近一次 Auto 对账”的快照 sheet_id，作为 cfg 恢复基准
    BEGIN
        SELECT SHEET_ID
        INTO V_REF_SHEET_ID
        FROM ( SELECT D.SHEET_ID
               FROM FSS_RECON_SUM R
                        JOIN FSS_RECON_DETAILS D ON D.RECON_ID = R.RECON_ID
               WHERE R.ACCT_NO = V_ACCT_NO
                 AND R.RECON_TYPE = 'A'
                 AND R.RECON_DATE <= V_ROLLBACK_DT
               ORDER BY R.RECON_DATE DESC, R.UPDATE_TIME DESC, R.RECON_ID DESC )
        WHERE ROWNUM = 1;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            V_REF_SHEET_ID := NULL;
    END;
    -- 2.2 删回滚日之后的对账生成数据（先子后父）
    DELETE
    FROM FSS_BALANCE_CFG_SNP S
    WHERE EXISTS ( SELECT 1
                   FROM FSS_RECON_DETAILS D
                            JOIN FSS_RECON_SUM R ON R.RECON_ID = D.RECON_ID
                   WHERE D.SHEET_ID = S.SHEET_ID
                     AND R.ACCT_NO = V_ACCT_NO
                     AND R.RECON_DATE > V_ROLLBACK_DT );
    DELETE
    FROM FSS_RECON_DETAILS D
    WHERE EXISTS ( SELECT 1
                   FROM FSS_RECON_SUM R
                   WHERE R.RECON_ID = D.RECON_ID
                     AND R.ACCT_NO = V_ACCT_NO
                     AND R.RECON_DATE > V_ROLLBACK_DT );
    DELETE
    FROM FSS_RECON_SUM R
    WHERE R.ACCT_NO = V_ACCT_NO
      AND R.RECON_DATE > V_ROLLBACK_DT;
    -- 2.3 清理回滚日之后cfg日志（可选，但建议）
    DELETE
    FROM FSS_BALANCE_CFG_LOG L
    WHERE L.ACCT_NO = V_ACCT_NO
      AND L.BIZ_DATE > V_ROLLBACK_DT;
    -- 2.4 恢复 cfg.default_amt 到“基准快照”
    IF V_REF_SHEET_ID IS NOT NULL THEN
        MERGE INTO FSS_BALANCE_CFG C
        USING ( SELECT CFG_ID, AMOUNT
                FROM FSS_BALANCE_CFG_SNP
                WHERE SHEET_ID = V_REF_SHEET_ID ) S
        ON ( C.CFG_ID = S.CFG_ID AND C.ACCT_NO = V_ACCT_NO AND C.IS_DEL = '0' )
        WHEN MATCHED THEN
            UPDATE
            SET C.DEFAULT_AMT = S.AMOUNT,
                C.UPDATE_TIME = SYSDATE,
                C.UPDATE_USER = 'rollback_test';
    END IF;
    COMMIT;
END;
/
-- =========================
-- 3) 回滚后校验
-- =========================
-- 3.1 回滚日之后应为 0
SELECT COUNT(*) AS CNT
FROM FSS_RECON_SUM
WHERE ACCT_NO = '&p_acct_no'
  AND RECON_DATE > '&p_rollback_dt';
-- 3.2 cfg与基准快照是否一致（0=一致）
WITH REF AS ( SELECT SHEET_ID
              FROM ( SELECT D.SHEET_ID
                     FROM FSS_RECON_SUM R
                              JOIN FSS_RECON_DETAILS D ON D.RECON_ID = R.RECON_ID
                     WHERE R.ACCT_NO = '&p_acct_no'
                       AND R.RECON_TYPE = 'A'
                       AND R.RECON_DATE <= '&p_rollback_dt'
                     ORDER BY R.RECON_DATE DESC, R.UPDATE_TIME DESC, R.RECON_ID DESC )
              WHERE ROWNUM = 1 )
SELECT COUNT(*) AS MISMATCH_CNT
FROM FSS_BALANCE_CFG C
         JOIN FSS_BALANCE_CFG_SNP S ON S.CFG_ID = C.CFG_ID
         JOIN REF R ON R.SHEET_ID = S.SHEET_ID
WHERE C.ACCT_NO = '&p_acct_no'
  AND C.IS_DEL = '0'
  AND NVL(C.DEFAULT_AMT, 0) <> NVL(S.AMOUNT, 0);