BEGIN
    MERGE INTO FSS_RECON_DETAILS D
    USING ( WITH BASE_DATA AS ( SELECT SHEET_ID,
                                       RECON_DATE,
                                       BANK_DR_BILA,
                                       BANK_CR_BILA,
                                       SYS_DR_BILA,
                                       SYS_CR_BILA,
                                       BANK_ADJ_END_BAL,
                                       SYS_ADJ_END_BAL,
                                       ROW_NUMBER() OVER (ORDER BY RECON_DATE DESC) AS RN
                                FROM FSS_RECON_DETAILS
                                WHERE ACCT_NO = '158001201110000869'
                                  AND RECON_DATE BETWEEN '20260121' AND '20260226' ),
                 REVERSE_CALC ( SHEET_ID, RN, RECON_DATE,
                                BANK_DR_BILA, BANK_CR_BILA, SYS_DR_BILA, SYS_CR_BILA,
                                BANK_END_NEW, SYS_END_NEW,
                                BANK_BEGIN_NEW, SYS_BEGIN_NEW ) AS ( SELECT SHEET_ID,
                                                                            RN,
                                                                            RECON_DATE,
                                                                            BANK_DR_BILA,
                                                                            BANK_CR_BILA,
                                                                            SYS_DR_BILA,
                                                                            SYS_CR_BILA,
                                                                            BANK_ADJ_END_BAL,
                                                                            SYS_ADJ_END_BAL,
                                                                            BANK_ADJ_END_BAL - BANK_CR_BILA + BANK_DR_BILA,
                                                                            SYS_ADJ_END_BAL - SYS_CR_BILA + SYS_DR_BILA
                                                                     FROM BASE_DATA
                                                                     WHERE RN = 1
                                                                     UNION ALL
                                                                     SELECT B.SHEET_ID,
                                                                            B.RN,
                                                                            B.RECON_DATE,
                                                                            B.BANK_DR_BILA,
                                                                            B.BANK_CR_BILA,
                                                                            B.SYS_DR_BILA,
                                                                            B.SYS_CR_BILA,
                                                                            R.BANK_BEGIN_NEW,
                                                                            R.SYS_BEGIN_NEW,
                                                                            R.BANK_BEGIN_NEW - B.BANK_CR_BILA + B.BANK_DR_BILA,
                                                                            R.SYS_BEGIN_NEW - B.SYS_CR_BILA + B.SYS_DR_BILA
                                                                     FROM REVERSE_CALC R
                                                                              JOIN BASE_DATA B ON B.RN = R.RN + 1 )
            SELECT SHEET_ID,
                   ROUND(BANK_BEGIN_NEW, 2) AS BANK_BEGIN_NEW,
                   ROUND(BANK_END_NEW, 2)   AS BANK_END_NEW,
                   ROUND(SYS_BEGIN_NEW, 2)  AS SYS_BEGIN_NEW,
                   ROUND(SYS_END_NEW, 2)    AS SYS_END_NEW
            FROM REVERSE_CALC ) RC
    ON ( D.SHEET_ID = RC.SHEET_ID )
    WHEN MATCHED THEN
        UPDATE
        SET D.BANK_BEGIN_BILA = RC.BANK_BEGIN_NEW,
            D.BANK_END_BILA   = RC.BANK_END_NEW,
            D.SYS_BEGIN_BILA  = RC.SYS_BEGIN_NEW,
            D.SYS_END_BILA    = RC.SYS_END_NEW;

    UPDATE FSS_RECON_SUM SET BILA_MATCH_FLAG = 'Y' WHERE 1 = 1;
END ;