-- ===========================数据准备===========================
-- 1. 配置表定义
drop table ORG_EBILL_CONFIG;
-- auto-generated definition
create table ORG_EBILL_CONFIG
(
    ORG_EBILL_CONFIG_ID NUMBER(19) not null
        constraint SYS_C006803
            primary key
        constraint SYS_C006797
            check ("ORG_EBILL_CONFIG_ID" is not null),
    EBILL_CODE          NUMBER(19)
        constraint SYS_C006798
            check ("EBILL_CODE" is not null),
    ORG_ID              NUMBER(19)
        constraint SYS_C006799
            check ("ORG_ID" is not null),
    EBILL_NAME          VARCHAR2(180),
    EBILL_URL           VARCHAR2(2000)
        constraint SYS_C006800
            check ("EBILL_URL" is not null),
    EBILL_ACCOUNT       VARCHAR2(80)
        constraint SYS_C006801
            check ("EBILL_ACCOUNT" is not null),
    EBILL_REGION        VARCHAR2(30)
        constraint SYS_C006802
            check ("EBILL_REGION" is not null),
    EBILL_DEPTCODE      VARCHAR2(1200),
    APP_ID              VARCHAR2(512),
    VERSION             CHAR(3),
    IS_DEL              CHAR default '0',
    KEY                 VARCHAR2(128),
    PLACE_CODE          CHAR(10)
)
/
-- 2. 配置表信息插入
insert into ORG_EBILL_CONFIG (ORG_EBILL_CONFIG_ID, EBILL_CODE, ORG_ID, EBILL_NAME, EBILL_URL, EBILL_ACCOUNT, EBILL_REGION, EBILL_DEPTCODE, APP_ID, VERSION, IS_DEL, KEY, PLACE_CODE)
values (1, 002010001, 200, '滨海电子票', 'http://10.10.30.32:30000/saas-industry/api/standard/', 'a', '120000', '043037', 'TJSBHXQZFHJSWYH841332', '1.0', 0, '61768932079865098268681164', '001');
-- ===========================正式操作===========================
-- 1. 查找滨海新区的分户
select bi.*, bi2.INFO_NAME
from BASE_INFO bi
         left join OWNER_INFO oi on bi.INFO_ID = oi.INFO_ID
         left join base_info bi2 on oi.SUPER_ID = bi2.INFO_ID
where oi.SUPER_TYPE = 20
  and bi2.INFO_NAME = '滨海新区';
-- 120000623380
-- 2. 找openStatus = 2 -> 已获取url和图片的开票任务
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
  and OPEN_STATUS = '2'
order by BATCH_NO desc;
-- info_id:100002043463
-- batch_no:251217002679
-- 3. 更改分户mng_org_id
update BASE_INFO
set MNG_ORG_ID = 200
where INFO_ID = '100002043463';
-- 4. 更改ebilltask状态
update E_BILL_TASK
set OPEN_STATUS = '0'
where INFO_ID = '100002043463';
-- 5. 更新trade的mngOrgId 因为默认全更改为了100
update TRADE
set MNG_ORG_ID = 200
where BATCH_NO = '251217002639';
-- 6. 删除e_bill_info和e_bill_use_info信息
select *
from EBILL_USE_INFO
where INFO_ID = '100002043463';
delete
from EBILL_INFO
where BILL_ID in (select EBILL_USE_INFO.BILL_ID
                  from EBILL_USE_INFO
                  where INFO_ID = '100002043463');
delete
from EBILL_USE_INFO
where BILL_ID in (select BILL_ID
                  from EBILL_USE_INFO
                  where INFO_ID = '100002043463');
-- 7. 更新hou_info中关于电子票的字段
update HOU_INFO
set IS_EBILL       = 0,
    DEV_EBILL_CODE = null,
    OWN_EBILL_CODE = null
where info_id = '100002043463';
