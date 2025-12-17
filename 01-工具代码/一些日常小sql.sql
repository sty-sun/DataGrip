-- 计算账户是否收支平衡
WITH cal AS (SELECT ((SELECT NVL(SUM(amt), 0) AS sum_amt
                      FROM acct_subject
                      WHERE fund = 100000000001
                        AND sbj_id IN (1010, 1030, 1050, 1070, 1080, 2090, 1033, 5011)) -
                     (SELECT NVL(SUM(amt), 0) AS sum_amt
                      FROM acct_subject
                      WHERE fund = 100000000001
                        AND sbj_id IN (2010, 2030, 2050, 2070, 2080, 3010, 3020, 5010))) cal
             FROM dual)
SELECT ((SELECT BAL FROM REAL_ACCT WHERE FUND = 100000000001) - (SELECT cal.cal FROM cal))
FROM dual;

-- 修改outbox使其不用重做业务即可重新进入消息队列进行消费
BEGIN
    -- 更新outbox中的消息
    UPDATE MQ_OUTBOX_MESSAGE
    SET STATUS = 0,
        MQ_MSG_ID = NULL
    WHERE ROWID IN (SELECT rid
                    FROM (SELECT ROWID                                        rid,
                                 ROW_NUMBER() OVER (ORDER BY CREATED_AT DESC) rn
                          FROM MQ_OUTBOX_MESSAGE
                          WHERE TAG LIKE '%STY%')
                    WHERE rn = 1);
    -- 删除inbox中的消息
    DELETE
    FROM MQ_INBOX_MESSAGE
    WHERE ROWID IN (SELECT rid
                    FROM (SELECT ROWID                                        rid,
                                 ROW_NUMBER() OVER (ORDER BY CREATED_AT DESC) rn
                          FROM MQ_INBOX_MESSAGE
                          WHERE TAG LIKE '%STY%')
                    WHERE rn = 1);
END;