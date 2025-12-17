-- 查找滨海新区的分户
select bi.*, bi2.INFO_NAME
from BASE_INFO bi
left join OWNER_INFO oi on bi.INFO_ID = oi.INFO_ID
left join base_info bi2 on oi.SUPER_ID = bi2.INFO_ID
where oi.SUPER_TYPE = 20
  and bi2.INFO_NAME = '滨海新区'; -- 120000623380

with cts as (select bi.*, bi2.INFO_NAME
             from BASE_INFO bi
                      left join OWNER_INFO oi on bi.INFO_ID = oi.INFO_ID
                      left join base_info bi2 on oi.SUPER_ID = bi2.INFO_ID
             where oi.SUPER_TYPE = 20
               and bi2.INFO_NAME = '滨海新区')
select *
from E_BILL_TASK
where INFO_ID in (select INFO_ID
                  from E_BILL_TASK)
order by BATCH_NO desc;

select *
from E_BILL_TASK ebt
         left join BASE_INFO bi on ebt.INFO_ID = bi.INFO_ID
where MNG_ORG_ID = 200
order by BATCH_NO desc;

-- 251212000886,2270,100002042150,2,2,刘树震,宝平街道南关大街303号铭邸世家融园3号楼-1-701,,34652.00,1,251212000886100002042150227020,,12990219,0001011018,15003654581,,,20251212174756
-- 251212000882,2270,100002042150,1,2,天津如昊金地房地产开发有限公司,宝平街道南关大街303号铭邸世家融园3号楼-1-701,91120224MA06F6HN7L,51978.00,1,251212000882100002042150227010,,12990219,0001011017,15003654580,,,20251212174403
-- 251212000882 开发商
-- 251212000886 购房人
select *
from E_BILL_TASK
where BATCH_NO = '251031000899';
-- -------------------- 请求开票的数据变动 --------------------
-- 更改分户mng_org_id
update BASE_INFO
set MNG_ORG_ID = 200
where INFO_ID = '100002042150';
-- 更改ebilltask状态
update E_BILL_TASK
set OPEN_STATUS = '0'
where BATCH_NO = '251212000882';
update E_BILL_TASK
set OPEN_STATUS = '0'
where BATCH_NO = '251212000886';
-- 更新trade的mngOrgId 因为默认全更改为了100
update TRADE
set MNG_ORG_ID = 200
where BATCH_NO = '251212000882';
update TRADE
set MNG_ORG_ID = 200
where BATCH_NO = '251212000886';
-- 删除e_bill_info

-- 删除e_bill_use_info


select *
from E_BILL_TASK
where batch_no = '251212000882'
  and info_id = '100002042150'
  and tran_type = '2270'
  and payer_type = '1'
  and open_status in ('0', '3');


select *
from BASE_INFO
where INFO_ID = '100002042150';

insert into ORG_EBILL_CONFIG (ORG_EBILL_CONFIG_ID, EBILL_CODE, ORG_ID, EBILL_NAME, EBILL_URL, EBILL_ACCOUNT, EBILL_REGION, EBILL_DEPTCODE, APP_ID, VERSION, IS_DEL, KEY, PLACE_CODE)
values (1, 002010001, 200, '滨海电子票', 'http://10.10.30.32:30000/saas-industry/api/standard/', 'a','120000','043037','TJSBHXQZFHJSWYH841332','1.0', 0, '61768932079865098268681164','001' );