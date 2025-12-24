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
