-- 1、通过购房人单边再交款接口进行再交款
    -- 1.0、数据准备
        select BUY_PACT_NO, CERT_CODE, HOUINFO_NO, MNG_ORG_ID
        from BASE_INFO bi
                 join HOU_INFO hi on bi.INFO_ID = hi.INFO_ID
                 join (select oi.INFO_ID
                       from OWNER_INFO oi
                                join COUNTER_SECT_CONFIG csc on oi.SUPER_ID = csc.SECT_ID and SUPER_TYPE = '30') config
                      on bi.INFO_ID = config.INFO_ID
        where MNG_ORG_ID in (100, 200)
          and BUY_PACT_NO is not null
          and HOUINFO_NO is not null
          and not exists (select 1 from COUNTER_PAYMENT_INFO cpi where hi.BUY_PACT_NO = cpi.BUY_PACT_NO)
        order by BUY_PACT_NO desc;
    -- 1.1、通过接口“按购房合同号查询房产信息”
        -- 获取参数：
            -- 1: batch_no:
            -- 2: realNmbr:
    -- 1.2、插入流水数据
        INSERT INTO bk_hx_acct_water (id, hkbatch, acc_no, TXN_DTE, TXN_SEQ, txn_tme, txn_sig, txn_amt, flag, tran_desc)
        VALUES ('777766', 'batch_no:250816000065;', '158001201110000869', '20201119', '1', '20250718095050', 'C', 400.0, '0',
                'description 1');
    -- 2.1、通过接口“柜面购房人单边再交款接口（仅购房人交款）”进行柜面交款入账信息推送
    -- 3.1、定时任务入账


    -- ===================================== 数据恢复 =================================================================
        begin
            delete from COUNTER_PAYMENT_INFO where BUY_PACT_NO = '2024-9054883';

            delete from FURTHER_PAYMENT_INFO where BATCH_NO = '250816000016';
            delete from BUSINESS_WATER_RELATION where BATCH_NO = '250816000016';
            delete from REAL_ACCT_WATER where BATCH_NO = '250816000016';
            delete from ACCT_WATER where BATCH_NO = '250816000016';
            delete from E_BILL_TASK where BATCH_NO = '250816000016';
            delete from TRADE_BANK where BATCH_NO = '250816000016';
            delete from TRADE where BATCH_NO = '250816000016';
            delete from PAY_SUM where BATCH_NO = '250816000016';
            delete from PAY_DETAIL where BATCH_NO = '250816000016';
            DELETE FROM SECTIONS_OPER WHERE BATCH_NO = '250816000016';
            DELETE FROM BASE_INFO_OPER WHERE BATCH_NO = '250816000016';
            DELETE FROM BASE_ORG_MANAGEMENT_OPER WHERE BATCH_NO = '250816000016';
            DELETE FROM OWNER_INFO_OPER WHERE BATCH_NO = '250816000016';
            DELETE FROM HOU_INFO_OPER WHERE BATCH_NO = '250816000016';
            DELETE FROM HOU_UNITS_OPER WHERE BATCH_NO = '250816000016';
        end;

-- 2、通过资金部缴存创建交易入账
    -- 2.1、通过老系统创建再交款交易
    -- 2.2、在新系统中制造一笔够金额的流水
    -- 2.3、人工勾兑流水入账
-- 3、通过柜面购房人单边再交款接口（按票据号交款）接口进行交款
    -- 3.1、通过接口3211 柜面购房人单边再交款接口（按票据号交款）
        -- 3.1.1、首先查一个符合条件的房屋信息
            select hou.INFO_ID,
                   hou.DEV_BILL_CODE,
                   info.info_id,
                   hou.buy_pact_no,
                   hou.buy_money,
                   info.info_area,
                   (case when hou.hou_pay_type <> '1' and hou.hou_pay_type <> '4' then '1' else hou.hou_pay_type end) as pay_type,
                   hou.exist_flag                                                                                     as lift_flag,
                   info.info_name                                                                                     as own_name,
                   hou.cert_type,
                   hou.cert_code,
                   info.info_addr,
                   hou.HOUINFO_NO
            from ebill_info a
                     join ebill_use_info b on a.bill_id = b.bill_id
                     join (select own.info_id
                           from owner_info own
                                    join counter_sect_config cfg on own.super_id = cfg.sect_id and own.super_type = '30') config
                          on b.info_id = config.info_id
                     join base_info info on b.info_id = info.info_id
                     join hou_info hou on info.info_id = hou.info_id
            where payer_type = '1'
              and status = '0'
              and bill_type = '0'
              and DEV_BILL_CODE is not null
              and OWN_BILL_CODE is null;
            -- 获取参数 info_id: 100000438533
            -- 获取参数 dev_bill_code: 01169636-2014
            -- 获取参数 own_name:
            -- 获取参数 cert_type:
            -- 获取参数 cert_code:
        -- 3.1.2、 通过接口获取参数
            -- batch_no: 250808050291
    -- 3.2、利用3212 利用票据号进行购房人单边交款
    -- 3.3 制造一笔流水
        INSERT INTO bk_hx_acct_water (id, hkbatch, acc_no, TXN_DTE, TXN_SEQ, txn_tme, txn_sig, txn_amt, flag, tran_desc)
        VALUES ('999926', 'batch_no:250808050291;', '158001201110000869', '20201119', '1', '20250718095050', 'C', 6666.0, '0',
                'description 1');

-- ===================================== 数据恢复 =================================================================
begin
    delete from COUNTER_PAYMENT_INFO where BATCH_NO = '250816000038';

    delete from FURTHER_PAYMENT_INFO where BATCH_NO = '250816000038';
    delete from BUSINESS_WATER_RELATION where BATCH_NO = '250816000038';
    delete from REAL_ACCT_WATER where BATCH_NO = '250816000038';
    delete from ACCT_WATER where BATCH_NO = '250816000038';
    delete from E_BILL_TASK where BATCH_NO = '250816000038';
    delete from TRADE_BANK where BATCH_NO = '250816000038';
    delete from TRADE where BATCH_NO = '250816000038';
    delete from PAY_SUM where BATCH_NO = '250816000038';
    delete from PAY_DETAIL where BATCH_NO = '250816000038';
    DELETE FROM SECTIONS_OPER WHERE BATCH_NO = '250816000038';
    DELETE FROM BASE_INFO_OPER WHERE BATCH_NO = '250816000038';
    DELETE FROM BASE_ORG_MANAGEMENT_OPER WHERE BATCH_NO = '250816000038';
    DELETE FROM OWNER_INFO_OPER WHERE BATCH_NO = '250816000038';
    DELETE FROM HOU_INFO_OPER WHERE BATCH_NO = '250816000038';
    DELETE FROM HOU_UNITS_OPER WHERE BATCH_NO = '250816000038';
end;

-- 4. 根据柜面双边全部交款接口（购房人和开发商交款）推送入账
    -- 4.1、数据准备：

    -- 4.3、通过接口“按购房合同号查询房产信息”
        -- 获取参数：
        -- 1: batch_no: 250808050300
        -- 2: realNmbr: 20250508000001
    -- 4.4、插入流水数据
        INSERT INTO bk_hx_acct_water (id, hkbatch, acc_no, TXN_DTE, TXN_SEQ, txn_tme, txn_sig, txn_amt, flag, tran_desc)
        VALUES ('999928', 'batch_no:250808050300;', '20250508000001', '20201119', '1', '20250718095050', 'C', 8888.0, '0',
                'description 1');

begin
    delete from COUNTER_PAYMENT_INFO where BATCH_NO = '250816000042';

    delete from FURTHER_PAYMENT_INFO where BATCH_NO = '250816000042';
    delete from BUSINESS_WATER_RELATION where BATCH_NO = '250816000042';
    delete from REAL_ACCT_WATER where BATCH_NO = '250816000042';
    delete from ACCT_WATER where BATCH_NO = '250816000042';
    delete from E_BILL_TASK where BATCH_NO = '250816000042';
    delete from TRADE_BANK where BATCH_NO = '250816000042';
    delete from TRADE where BATCH_NO = '250816000042';
    delete from PAY_SUM where BATCH_NO = '250816000042';
    delete from PAY_DETAIL where BATCH_NO = '250816000042';
    DELETE FROM SECTIONS_OPER WHERE BATCH_NO = '250816000042';
    DELETE FROM BASE_INFO_OPER WHERE BATCH_NO = '250816000042';
    DELETE FROM BASE_ORG_MANAGEMENT_OPER WHERE BATCH_NO = '250816000042';
    DELETE FROM OWNER_INFO_OPER WHERE BATCH_NO = '250816000042';
    DELETE FROM HOU_INFO_OPER WHERE BATCH_NO = '250816000042';
    DELETE FROM HOU_UNITS_OPER WHERE BATCH_NO = '250816000042';
end;

------------------------------------------------------------------------------------------------------------------------
select pay.batch_no,
       pay.buy_pact_no,
       pay.info_id,
       pay.sum_tran_amt,
       hx.acc_no
from (select p.batch_no,
             p.buy_pact_no,
             p.info_id,
             (p.own_pay + nvl(p.dev_pay, 0)) as sum_tran_amt
      from counter_payment_info p
      where p.own_pay_step = 1) pay
         join (select hkbatch,
                      acc_no,
                      max(txn_tme)                                     as tranaccttime,
                      sum(decode(txn_sig, 'C', txn_amt, -1 * txn_amt)) as txn_amt
               from bk_hx_acct_water
               where flag = '0'
                 and hkbatch is not null
               group by hkbatch, acc_no) hx
              on hx.txn_amt = pay.sum_tran_amt
                  and instr(hx.hkbatch, pay.batch_no || ';') > 0;

select *
from COUNTER_PAYMENT_INFO
where BATCH_NO = '250808050300';

select *
from BK_HX_ACCT_WATER B
where B .HKBATCH like '%250808050300%';

begin
    delete from SECTIONS_OPER where BATCH_NO = '250815056027';
    delete from BASE_INFO_OPER where BATCH_NO = '250815056027';
    delete from BASE_ORG_MANAGEMENT_OPER where BATCH_NO = '250815056027';
    delete from OWNER_INFO_OPER where BATCH_NO = '250815056027';
    delete from HOU_INFO_OPER where BATCH_NO = '250815056027';
    delete from HOU_UNITS_OPER where BATCH_NO = '250815056027';
    delete from PAY_DETAIL where BATCH_NO = '250815056027';
    delete from PAY_SUM where BATCH_NO = '250815056027';
    delete from TRADE where BATCH_NO = '250815056027';
    delete from E_BILL_TASK where BATCH_NO = '250815056027';
    delete from ACCT_WATER where BATCH_NO = '250815056027';
    delete from REAL_ACCT_WATER where BATCH_NO = '250815056027';
    delete from FURTHER_PAYMENT_INFO where BATCH_NO = '250815056027';
    update COUNTER_PAYMENT_INFO set OWN_PAY_STEP = 1 where BATCH_NO = '250815056027';
    update BK_HX_ACCT_WATER set flag = '0' where HKBATCH like '250815056027;';
end;

select dt.*, acct.real_nmbr from PAY_DETAIL dt join acct on dt.fund = acct.fund  where dt.batch_no = '250815056027';