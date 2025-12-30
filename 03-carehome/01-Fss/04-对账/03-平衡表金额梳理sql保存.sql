-- 查找贷方入账条目
SELECT *
FROM
    REAL_ACCT_WATER
WHERE
      SYS_DATE = '20251216'
  AND TRAN_FLAG = '2'
  AND REAL_NMBR = '158001201110000869';

-- 查找贷方今日的清账记录
SELECT
    AA.BATCH_NO
FROM
    HX_WATER_DIFF_CLEAR AA
        JOIN HX_WATER_DIFF_NEW BB ON AA.DIFF_ID = BB.DIFF_ID
WHERE
      AA.CLEAR_DATE = '20251216'
  AND BB.BASE_ACCT_NO = '158001201110000869'
  AND BB.DIFF_SOURCE = 'B';

-- 查找非清账条目 --19283001.41
SELECT *
FROM
    REAL_ACCT_WATER
WHERE
      SYS_DATE = '20251216'
  AND TRAN_FLAG = '2'
  AND REAL_NMBR = '158001201110000869'
  AND BATCH_NO NOT IN (SELECT
                           AA.BATCH_NO
                       FROM
                           HX_WATER_DIFF_CLEAR AA
                               JOIN HX_WATER_DIFF_NEW BB ON AA.DIFF_ID = BB.DIFF_ID
                       WHERE
                             AA.CLEAR_DATE = '20251216'
                         AND BB.BASE_ACCT_NO = '158001201110000869'
                         AND BB.DIFF_SOURCE = 'B');

-- 查看贷方非清账条目的关联关系
SELECT
    BATCH_NO
FROM
    BUSINESS_WATER_RELATION
WHERE
      TRAN_DATE != SYS_DATE
  AND BATCH_NO IN (SELECT
                       REAL_ACCT_WATER.BATCH_NO
                   FROM
                       REAL_ACCT_WATER
                   WHERE
                         SYS_DATE = '20251216'
                     AND TRAN_FLAG = '2'
                     AND REAL_NMBR = '158001201110000869'
                     AND BATCH_NO NOT IN (SELECT
                                              AA.BATCH_NO
                                          FROM
                                              HX_WATER_DIFF_CLEAR AA
                                                  JOIN HX_WATER_DIFF_NEW BB ON AA.DIFF_ID = BB.DIFF_ID
                                          WHERE
                                                AA.CLEAR_DATE = '20251216'
                                            AND BB.BASE_ACCT_NO = '158001201110000869'
                                            AND BB.DIFF_SOURCE = 'B'
                                            AND BB.CRDR = 'C'));
-- 银行这边多的流水 金额为：40709.19
SELECT *
FROM
    HX_WATER_DETAIL
WHERE
      CR_DR_MAINT_IND = 'C'
  AND TRAN_DATE = '20251216'
  AND ID NOT IN (SELECT
                     WATER_ID
                 FROM
                     HX_WATER_DIFF_NEW AA
                 WHERE
                       AA.POST_DATE = '20251216'
                   AND AA.CRDR = 'C'
                   AND AA.DIFF_SOURCE = 'B')
  AND ID NOT IN (SELECT
                     BK_ID
                 FROM
                     BUSINESS_WATER_RELATION
                 WHERE
                       TRAN_DATE = SYS_DATE
                   AND BATCH_NO IN (SELECT
                                        REAL_ACCT_WATER.BATCH_NO
                                    FROM
                                        REAL_ACCT_WATER
                                    WHERE
                                          SYS_DATE = '20251216'
                                      AND TRAN_FLAG = '2'
                                      AND REAL_NMBR = '158001201110000869'
                                      AND BATCH_NO NOT IN (SELECT
                                                               AA.BATCH_NO
                                                           FROM
                                                               HX_WATER_DIFF_CLEAR AA
                                                                   JOIN HX_WATER_DIFF_NEW BB ON AA.DIFF_ID = BB.DIFF_ID
                                                           WHERE
                                                                 AA.CLEAR_DATE = '20251216'
                                                             AND BB.BASE_ACCT_NO = '158001201110000869'
                                                             AND BB.DIFF_SOURCE = 'B'
                                                             AND BB.CRDR = 'C')));
-- 查看是否挂账 -> 没有挂账
SELECT *
FROM
    HX_WATER_DIFF_NEW
WHERE
    WATER_ID = '600057';
-- 查看是否有关联关系
SELECT *
FROM
    BUSINESS_WATER_RELATION
WHERE
    BK_ID = '600057';

SELECT
    SUM(TRAN_AMT) -- 1730.69
FROM
    REAL_ACCT_WATER
WHERE
      TRAN_FLAG = '2'
  AND SYS_DATE = '20251216'
  AND REAL_NMBR = '158001201110000869'
  AND BATCH_NO IN (SELECT
                       BATCH_NO
                   FROM
                       BUSINESS_WATER_RELATION
                   WHERE
                         TRAN_DATE != SYS_DATE
                     AND BATCH_NO IN (SELECT
                                          REAL_ACCT_WATER.BATCH_NO
                                      FROM
                                          REAL_ACCT_WATER
                                      WHERE
                                            SYS_DATE = '20251216'
                                        AND TRAN_FLAG = '2'
                                        AND REAL_NMBR = '158001201110000869'
                                        AND BATCH_NO NOT IN (SELECT
                                                                 AA.BATCH_NO
                                                             FROM
                                                                 HX_WATER_DIFF_CLEAR AA
                                                                     JOIN HX_WATER_DIFF_NEW BB ON AA.DIFF_ID = BB.DIFF_ID
                                                             WHERE
                                                                   AA.CLEAR_DATE = '20251216'
                                                               AND BB.BASE_ACCT_NO = '158001201110000869'
                                                               AND BB.DIFF_SOURCE = 'B'
                                                               AND BB.CRDR = 'C')));

-- 38,978.5

--=================================================================================================
--! 银行
--? 入账
SELECT *
FROM
    HX_WATER_DETAIL
WHERE
      TRAN_DATE = '20251216'
  AND CR_DR_MAINT_IND = 'C'
  AND BASE_ACCT_NO = '158001201110000869';
--? 挂账
SELECT *
FROM
    HX_WATER_DETAIL HWD
WHERE
    EXISTS(SELECT
               1
           FROM
               HX_WATER_DIFF_NEW HWDN
           WHERE
                 HWD.ID = HWDN.WATER_ID
             AND HWDN.POST_DATE = '20251216'
             AND HWDN.CRDR = 'C'
             AND HWDN.DIFF_SOURCE = 'B'
             AND HWDN.BASE_ACCT_NO = '158001201110000869');
--? 清账
SELECT *
FROM
    HX_WATER_DETAIL HWD
WHERE
    EXISTS(SELECT
               1
           FROM
               HX_WATER_DIFF_NEW HWDN
                   JOIN HX_WATER_DIFF_CLEAR HWDC ON HWDN.DIFF_ID = HWDC.DIFF_ID
           WHERE
                 HWD.ID = HWDN.WATER_ID
             AND HWDC.CLEAR_DATE = '20251216'
             AND HWDN.CRDR = 'C'
             AND HWDN.DIFF_SOURCE = 'T'
             AND HWDN.POST_DATE < '20251216'
             AND HWDN.BASE_ACCT_NO = '158001201110000869');
--? 被清的流水
SELECT *
FROM
    HX_WATER_DETAIL HWD
WHERE
    EXISTS(SELECT
               1
           FROM
               HX_WATER_DIFF_NEW HWDN
                   JOIN HX_WATER_DIFF_CLEAR HWDC ON HWDN.DIFF_ID = HWDC.DIFF_ID
           WHERE
                 HWD.ID = HWDN.WATER_ID
             AND HWDC.CLEAR_DATE = '20251216'
             AND HWDN.CRDR = 'C'
             AND HWDN.DIFF_SOURCE = 'B'
             AND HWDN.POST_DATE < '20251216'
             AND HWDN.BASE_ACCT_NO = '158001201110000869');
--? 清账对应的入账流水
SELECT *
FROM
    REAL_ACCT_WATER RW
WHERE
    EXISTS(SELECT
               1
           FROM
               HX_WATER_DIFF_NEW HWDN
                   JOIN HX_WATER_DIFF_CLEAR HWDC ON HWDN.DIFF_ID = HWDC.DIFF_ID
           WHERE
                 RW.BATCH_NO = HWDC.BATCH_NO
             AND HWDC.CLEAR_DATE = '20251216'
             AND HWDN.CRDR = 'C'
             AND HWDN.DIFF_SOURCE = 'B'
             AND HWDN.POST_DATE < '20251216'
             AND HWDN.BASE_ACCT_NO = '158001201110000869');


-- ===
SELECT *
FROM
    (SELECT
         HWD.*,
         CASE
             WHEN EXISTS (SELECT
                              1
                          FROM
                              HX_WATER_DIFF_NEW HWDN
                                  JOIN HX_WATER_DIFF_CLEAR HWDC
                                       ON HWDN.DIFF_ID = HWDC.DIFF_ID
                          WHERE
                                HWDN.WATER_ID = HWD.ID
                            AND HWDC.CLEAR_DATE = '20251216'
                            AND HWDN.DIFF_SOURCE = 'T'
                            AND HWDN.POST_DATE < '20251216'
                            AND HWDN.BASE_ACCT_NO = '158001201110000869'
                            AND HWDN.CRDR = HWD.CR_DR_MAINT_IND)
                 THEN '清系统账'
             WHEN EXISTS (SELECT
                              1
                          FROM
                              HX_WATER_DIFF_NEW HWDN
                          WHERE
                                HWDN.WATER_ID = HWD.ID
                            AND HWDN.POST_DATE = '20251216'
                            AND HWDN.DIFF_SOURCE = 'B'
                            AND HWDN.BASE_ACCT_NO = '158001201110000869'
                            AND HWDN.CRDR = HWD.CR_DR_MAINT_IND)
                 THEN CASE HWD.CR_DR_MAINT_IND
                          WHEN 'C'
                              THEN '挂账-贷方'
                          WHEN 'D'
                              THEN '挂账-借方'
                          ELSE '挂账'
                      END
             WHEN EXISTS (SELECT
                              1
                          FROM
                              BUSINESS_WATER_RELATION BWR
                          WHERE
                                BWR.BK_ID = HWD.ID
                            AND BWR.TRAN_DATE = BWR.SYS_DATE
                            AND BWR.TRAN_DATE = '20251216')
                 THEN CASE HWD.CR_DR_MAINT_IND
                          WHEN 'C'
                              THEN '双边入账-贷方'
                          WHEN 'D'
                              THEN '双边入账-借方'
                          ELSE '挂账'
                      END
             ELSE '未挂账也未建立关联关系'
         END AS BIZ_TYPE
     FROM
         HX_WATER_DETAIL HWD
     WHERE
           HWD.TRAN_DATE = '20251216'
       AND HWD.BASE_ACCT_NO = '158001201110000869'
       AND HWD.CR_DR_MAINT_IND = 'C') ANSWER
WHERE
    ANSWER.BIZ_TYPE = '未挂账也未建立关联关系';

SELECT
    HWD.*,
    CASE
        WHEN EXISTS (SELECT
                         1
                     FROM
                         HX_WATER_DIFF_NEW HWDN
                             JOIN HX_WATER_DIFF_CLEAR HWDC ON HWDN.DIFF_ID = HWDC.DIFF_ID
                     WHERE
                           HWD.ID = HWDN.WATER_ID
                       AND HWDC.CLEAR_DATE = '20251216'
                       AND HWDN.CRDR = 'C'
                       AND HWDN.DIFF_SOURCE = 'T'
                       AND HWDN.POST_DATE < '20251216'
                       AND HWDN.BASE_ACCT_NO = '158001201110000869')
            THEN '清系统账'
        WHEN EXISTS (SELECT
                         1
                     FROM
                         HX_WATER_DIFF_NEW HWDN
                     WHERE
                           HWD.ID = HWDN.WATER_ID
                       AND HWDN.POST_DATE = '20251216'
                       AND HWDN.CRDR = 'C'
                       AND HWDN.DIFF_SOURCE = 'B'
                       AND HWDN.BASE_ACCT_NO = '158001201110000869')
            THEN CASE
                     WHEN HWD.CR_DR_MAINT_IND = 'C'
                         THEN '挂账-贷方'
                     WHEN HWD.CR_DR_MAINT_IND = 'D'
                         THEN '挂账-借方'
                     ELSE '挂账'
                 END
        WHEN EXISTS (SELECT
                         1
                     FROM
                         BUSINESS_WATER_RELATION BWR
                     WHERE
                           BWR.BK_ID = HWD.ID
                       AND BWR.TRAN_DATE = BWR.SYS_DATE
                       AND BWR.TRAN_DATE = '20251216')
            THEN CASE
                     WHEN HWD.CR_DR_MAINT_IND = 'C'
                         THEN '双边入账-贷方'
                     WHEN HWD.CR_DR_MAINT_IND = 'D'
                         THEN '双边入账-借方'
                 END
        ELSE '未建立关联关系也未挂账'
    END AS 账务类型
FROM
    HX_WATER_DETAIL HWD
WHERE
      HWD.TRAN_DATE = '20251216'
  AND HWD.CR_DR_MAINT_IND = 'C'
  AND HWD.BASE_ACCT_NO = '158001201110000869';


WITH
    CLEAR_SET AS (SELECT DISTINCT
                      HWDN.WATER_ID
                  FROM
                      HX_WATER_DIFF_NEW HWDN
                          JOIN HX_WATER_DIFF_CLEAR HWDC ON HWDN.DIFF_ID = HWDC.DIFF_ID
                  WHERE
                        HWDC.CLEAR_DATE = '20251216'
                    AND HWDN.DIFF_SOURCE = 'T'
                    AND HWDN.POST_DATE < '20251216'
                    AND HWDN.BASE_ACCT_NO = '158001201110000869'),
    PENDING_SET AS (SELECT DISTINCT
                        WATER_ID
                    FROM
                        HX_WATER_DIFF_NEW
                    WHERE
                          POST_DATE = '20251216'
                      AND CRDR = 'C'
                      AND DIFF_SOURCE = 'B'
                      AND BASE_ACCT_NO = '158001201110000869'),
    BILATERAL_SET AS (SELECT DISTINCT
                          BK_ID
                      FROM
                          BUSINESS_WATER_RELATION
                      WHERE
                            TRAN_DATE = '20251216'
                        AND TRAN_DATE = SYS_DATE)
SELECT
    HWD.*,
    CASE
        WHEN CS.WATER_ID IS NOT NULL
            THEN DECODE(HWD.CR_DR_MAINT_IND, 'D', '清系统账-贷方', 'C', '清系统账-借方', '清系统账')
        WHEN PS.WATER_ID IS NOT NULL
            THEN DECODE(HWD.CR_DR_MAINT_IND, 'C', '挂账-贷方', 'D', '挂账-借方', '挂账')
        WHEN BS.BK_ID IS NOT NULL
            THEN DECODE(HWD.CR_DR_MAINT_IND, 'D', '双边入账-贷方', 'C', '双边入账-借方', '清系统账')
        ELSE '未建立关联关系也未挂账'
    END AS REC_TYPE
FROM
    HX_WATER_DETAIL HWD
        LEFT JOIN CLEAR_SET CS ON HWD.ID = CS.WATER_ID
        LEFT JOIN PENDING_SET PS ON HWD.ID = PS.WATER_ID
        LEFT JOIN BILATERAL_SET BS ON HWD.ID = BS.BK_ID
WHERE
      HWD.TRAN_DATE = '20251216'
  AND HWD.CR_DR_MAINT_IND = 'C'
  AND HWD.BASE_ACCT_NO = '158001201110000869';

-- ===

--! 系统
--? 入账
SELECT *
FROM
    ACCT_WATER
WHERE
      REAL_NMBR = '158001201110000869'
  AND TRAN_FLAG = '1'
  AND SYS_DATE = '20251216';
--? 挂账
SELECT *
FROM
    ACCT_WATER AW
WHERE
      TRAN_FLAG = '1'
  AND REAL_NMBR = '158001201110000869'
  AND SYS_DATE = '20251216'
  AND BATCH_NO IN (SELECT AA.BATCH_NO FROM HX_WATER_DIFF_NEW AA WHERE AA.POST_DATE = '20251216' AND AA.CRDR = 'D')
  AND NOT EXISTS (SELECT
                      1
                  FROM
                      BUSINESS_WATER_RELATION BR
                  WHERE
                        BR.BATCH_NO = AW.BATCH_NO
                    AND AW.SUB_WATER = BR.SUB_WATER
                    AND CASE WHEN BR.TRAN_DATE >= BR.SYS_DATE THEN BR.TRAN_DATE ELSE BR.SYS_DATE END = '20251216');
--? 清账
SELECT *
FROM
    ACCT_WATER AW
WHERE
      TRAN_FLAG = '1'
  AND REAL_NMBR = '158001201110000869'
  AND SYS_DATE = '20251216'
  AND BATCH_NO NOT IN (SELECT AA.BATCH_NO FROM HX_WATER_DIFF_NEW AA WHERE AA.POST_DATE = '20251216' AND AA.CRDR = 'D')
  AND EXISTS (SELECT
                  1
              FROM
                  BUSINESS_WATER_RELATION BR
              WHERE
                    BR.BATCH_NO = AW.BATCH_NO
                AND AW.SUB_WATER = BR.SUB_WATER
                AND CASE WHEN BR.TRAN_DATE >= BR.SYS_DATE THEN BR.TRAN_DATE ELSE BR.SYS_DATE END = '20251216');
-- ===
WITH
    PENDING_BATCH AS (SELECT DISTINCT
                          BATCH_NO,
                          CRDR
                      FROM
                          HX_WATER_DIFF_NEW
                      WHERE
                          POST_DATE = '20251216'),
    VALID_RELATION AS (SELECT DISTINCT
                           BATCH_NO,
                           SUB_WATER
                       FROM
                           BUSINESS_WATER_RELATION
                       WHERE
                             CASE
                                 WHEN TRAN_DATE > SYS_DATE
                                     THEN TRAN_DATE
                                 ELSE SYS_DATE
                             END = '20251216'
                         AND TRAN_DATE <> SYS_DATE),
    BILATERAL_SET AS (SELECT DISTINCT
                          BATCH_NO,
                          SUB_WATER
                      FROM
                          BUSINESS_WATER_RELATION
                      WHERE
                            TRAN_DATE = '20251216'
                        AND TRAN_DATE = SYS_DATE)
SELECT *
FROM
    (SELECT
         AW.*,
         PB.BATCH_NO  AS PBBATCH_NO,
         VR.BATCH_NO  AS VRBATCH_NO,
         BS.BATCH_NO  AS BSBATCH_NO,
         BS.SUB_WATER AS BSSUB_WATER,
         CASE
             WHEN PB.BATCH_NO IS NOT NULL AND VR.BATCH_NO IS NULL AND BS.BATCH_NO IS NULL
                 THEN DECODE(AW.TRAN_FLAG, '1', '挂账-借方', '2', '挂账-贷方', '挂账')
             WHEN PB.BATCH_NO IS NULL AND VR.BATCH_NO IS NOT NULL AND BS.BATCH_NO IS NULL
                 THEN DECODE(AW.TRAN_FLAG, '1', '清账-借方', '2', '清账-贷方', '清账')
             WHEN BS.BATCH_NO IS NOT NULL
                 THEN DECODE(AW.TRAN_FLAG, '1', '双边入账-借方', '2', '双边入账-贷方', '双边入账')
             ELSE '未建立关联关系也未挂账'
         END          AS REC_TYPE
     FROM
         ACCT_WATER AW
             LEFT JOIN PENDING_BATCH PB
                       ON AW.BATCH_NO = PB.BATCH_NO
                           AND CASE
                                   WHEN PB.CRDR = 'D'
                                       THEN '1'
                                   WHEN PB.CRDR = 'C'
                                       THEN '2'
                               END = AW.TRAN_FLAG
             LEFT JOIN VALID_RELATION VR
                       ON AW.BATCH_NO = VR.BATCH_NO
                           AND AW.SUB_WATER = VR.SUB_WATER
             LEFT JOIN BILATERAL_SET BS
                       ON AW.BATCH_NO = BS.BATCH_NO
                           AND AW.SUB_WATER = BS.SUB_WATER) T
WHERE
      T.REAL_NMBR = '158001201110000869'
  AND T.SYS_DATE = '20251216'
  AND T.TRAN_FLAG = '2'
  AND T.BATCH_NO = '251212000630';
-- ===
-- =================================================================================================