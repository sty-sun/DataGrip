select MT_CODE as 设施设备类型编号, MT_NAME as 设施设备类型名称
from M_object_type
where mt_id = '1123';

select MI_CODE as 维修项目编码, MI_NAME as 维修项目名称, MI_REMARK as 维修项目备注
from m_object_item a
         join m_object_type b on a.mt_id = b.mt_id
where a.mt_id = '1123'
  and a.mi_status = '0'
order by a.mi_id asc;

select *
from MO_TYPE_ATTR
where mt_id = '1123'
  and mta_status = '0';

select MT_CODE as 设施设备类型编号, MT_NAME as 设施设备类型名称,  MI_CODE as 维修项目编码, MI_NAME as 维修项目名称, MI_REMARK as 维修项目备注, MTA_CODE as 属性编号, MTA_NAME as 属性名称, MTA_LENGTH as 属性长度, case when MTA_MUST_FLAG = '0' then '否' else '是' end as 是否必输, MTA_REMARK as 设施设备类型属性备注
from m_object_item a
         join m_object_type b on a.mt_id = b.mt_id
         join MO_TYPE_ATTR c on c.MT_ID = a.MT_ID
where a.mi_status = '0'
    and c.mta_status = '0'
order by a.mi_id asc;

WITH type_tree AS (
    SELECT
        t.mt_id,
        t.mt_parentid,
        t.mt_code,
        t.mt_name,
        LEVEL AS lvl,
        SYS_CONNECT_BY_PATH(t.mt_code, '/') AS path_sort
    FROM m_object_type t
    WHERE t.mt_status = '0'
    START WITH t.mt_parentid = 0
    CONNECT BY NOCYCLE PRIOR t.mt_id = t.mt_parentid
    ORDER SIBLINGS BY t.mt_code
),
     unioned AS (
         -- 1) 类型行：展示“一级/二级/三级...设施设备”
         SELECT
             tt.path_sort,
             1 AS sort1,
             0 AS sort2,
             CASE tt.lvl
                 WHEN 1 THEN '一级设施设备'
                 WHEN 2 THEN '二级设施设备'
                 WHEN 3 THEN '三级设施设备'
                 ELSE TO_CHAR(tt.lvl) || '级设施设备'
                 END AS section_name,
             tt.mt_code AS code,
             LPAD(' ', (tt.lvl - 1) * 2, ' ') || tt.mt_name AS name,
             CAST(NULL AS NUMBER) AS attr_length,
             CAST(NULL AS VARCHAR2(8)) AS must_flag,
             tt.mt_id
         FROM type_tree tt

         UNION ALL

         -- 2) 维修项目：紧跟在该类型下面
         SELECT
             tt.path_sort,
             2 AS sort1,
             i.mi_id AS sort2,
             '维修项目' AS section_name,
             i.mi_code AS code,
             LPAD(' ', tt.lvl * 2, ' ') || i.mi_name AS name,
             CAST(NULL AS NUMBER) AS attr_length,
             CAST(NULL AS VARCHAR2(8)) AS must_flag,
             tt.mt_id
         FROM type_tree tt
                  JOIN m_object_item i ON i.mt_id = tt.mt_id
         WHERE i.mi_status = '0'
     )
SELECT
    section_name AS 展示区块,
    name         AS 名称
FROM unioned
ORDER BY
    path_sort,
    sort1,
    sort2;

SELECT
    l1.mt_code || ' ' || l1.mt_name AS 一级设施设备,
    l2.mt_code || ' ' || l2.mt_name AS 二级设施设备,
    i.mi_code  || ' ' || i.mi_name  AS 维修项目
FROM m_object_type l1
         JOIN m_object_type l2
              ON l2.mt_parentid = l1.mt_id
                  AND l2.mt_status   = '0'
         LEFT JOIN m_object_item i
                   ON i.mt_id     = l2.mt_id
                       AND i.mi_status = '0'
WHERE l1.mt_parentid = 0
  AND l1.mt_status   = '0'
ORDER BY
    l1.mt_code,
    l2.mt_code,
    i.mi_id;