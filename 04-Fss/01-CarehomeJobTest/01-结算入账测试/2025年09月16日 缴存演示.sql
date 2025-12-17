-- 续交

-- 修改 结存单下载pdf链接
BEGIN
    UPDATE SYS_PARA
    SET PARA_VALUE = 'https://wxzj.tjzfbz.com.cn/yijubao/master/mbl/api/webapp/sys/sysfileinfo/getPdfFileWeb'
    WHERE PARA_NAME = 'APP_PDF_PATH';

    -- 提交事务（如果您的数据库连接设置为自动提交，则可省略）
    -- COMMIT;

    -- 使用 DBMS_OUTPUT 显示影响了多少行
    DBMS_OUTPUT.PUT_LINE('更新了 ' || SQL%ROWCOUNT || ' 行数据。');

    -- 可以根据行数进行逻辑判断
    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('警告：未找到 PARA_NAME 为 "APP_PDF_PATH" 的记录，可能配置项不存在。');
    ELSIF SQL%ROWCOUNT > 1 THEN
        DBMS_OUTPUT.PUT_LINE('警告：更新了多条记录，请检查 PARA_NAME 字段唯一性。');
    ELSE
        DBMS_OUTPUT.PUT_LINE('配置项 APP_PDF_PATH 更新成功。');
    END IF;
END;
-- 还原
UPDATE SYS_PARA
SET PARA_VALUE = 'https://wxzj.tjzfbz.com.cn/yijubao/master/mbl/api/pforms/sys/sysfileinfo/getPdfFileWeb'
WHERE PARA_NAME = 'APP_PDF_PATH';


SELECT *
FROM BASE_INFO bi
         JOIN NOTIFY_CUIJIAO_INFO nci ON bi.INFO_ID = nci.INFO_ID
WHERE RENEWAL_STATUS = 0
  AND IMP_DATE >= '20250101'
  AND bi.MNG_ORG_ID = 100
  AND STATUS = 1
  AND bi.INFO_ID NOT IN ('120000709610');
-- 再交款
-- 1. 双边交款（开发商和购房人都尚未进行交款）
-- sql语句含义为：找到可以进行柜面交款的项目下有购房合同号（也就是已售出的房子）且未进行过柜面交款的房子的购房合同号、证件号、房屋唯一编码以及资金管理单位
SELECT BUY_PACT_NO, CERT_TYPE, CERT_CODE, DEV_PAY, OWN_PAY, EXIST_FLAG
FROM RECEIVE_CONTRACT_INFO rci
WHERE NOT EXISTS(SELECT *
                 FROM HOU_INFO hi
                 WHERE hi.BUY_PACT_NO = rci.BUY_PACT_NO)
  AND BUY_PACT_NO NOT IN
      ('2025-9080347', '2025-9080344', '2025-9091352', '2025-9091348', '2025-9091339', '2025-9091331', '2025-9091330',
       '2025-9097434')
  AND DEV_PAY = 0
  AND OWN_PAY = 0
ORDER BY BUY_PACT_NO DESC;

-- 2. 电子票
SELECT info.info_code,
       hou.DEV_BILL_CODE,
       hou.DEV_EBILL_CODE,
       hou.OWN_BILL_CODE,
       hou.OWN_EBILL_CODE,
       hou.CERT_CODE,
       hou.EXIST_FLAG
FROM base_info info
         JOIN hou_info hou ON info.info_id = hou.info_id
         JOIN (SELECT own.info_id
               FROM owner_info own
                        JOIN counter_sect_config cfg ON own.super_id = cfg.sect_id AND own.super_type = '30') config
              ON info.info_id = config.info_id
WHERE (hou.DEV_BILL_CODE IS NOT NULL OR hou.DEV_EBILL_CODE IS NOT NULL)
  AND (hou.OWN_BILL_CODE IS NULL AND hou.OWN_EBILL_CODE IS NULL)
  AND (DEV_BILL_CODE NOT IN
       ('00485742-2014', '00485532-2014', '00485533-2014', '00485530-2014', '00485534-2014', '00485674-2014',
        '00485697-2014', '00485681-2014', '00485707-2014', '00485861-2014', '00485560-2014', '00485585-2014',
        '2025-9091368', '00485586-2014', '00485716-2014', '00485738-2014', '00485760-2014', '00485763-2014'))
  AND hou.dev_bill_code IN (SELECT bill_code
                            FROM bill_info a
                                     JOIN bill_use_info b ON
                                a.bill_id = b.bill_id
                                     JOIN (SELECT own.info_id
                                           FROM owner_info own
                                                    JOIN counter_sect_config cfg ON
                                               own.super_id = cfg.sect_id
                                                   AND own.super_type = '30') config ON
                                b.info_id = config.info_id
                                     JOIN base_info info ON
                                b.info_id = info.info_id
                                     JOIN hou_info hou ON
                                info.info_id = hou.info_id
                            WHERE bill_status NOT IN ('3')
                              AND payer_type = '1');


-- 3.资金部缴存——开发商已交、购房人未交、产权人变更
SELECT rci.OWN_NAME AS own_name,  --
       bi.INFO_NAME AS info_name, -- 产权人
       bi.INFO_ID,
       rci.*
FROM RECEIVE_CONTRACT_INFO rci
         JOIN HOU_INFO hi ON hi.BUY_PACT_NO = rci.BUY_PACT_NO
         JOIN BASE_INFO bi ON bi.INFO_ID = hi.INFO_ID
WHERE rci.OWN_NAME <> bi.INFO_NAME
  AND NOT EXISTS(SELECT *
                 FROM ACCT_WATER
                 WHERE OWNER = bi.INFO_ID
                   AND sbj_id IN ('1010'));

-- 数据验证
-- 1. 再交款进行前，展示资金账户科目金额以及流水明细
-- 2. 再交款进行后，展示分户明细中的流水是否新增了，科目金额是否增加了
-- 3. 再交款进行后，E_BILL_TASK表中是否有了购房人和开发商的电子票相关信息，金额是否正确
SELECT *
FROM E_BILL_TASK
WHERE BATCH_NO = '';
-- 4. 流水信息中绑定的业务信息是否正确


BEGIN
    dbms_output.put_line('Hello, World!');
END;