-- 前情提要：17库是2025年10月11日的库，15是2025年1月2日的库，通过将17库里的数据导入到15库中进行入账，对入账代码进行测试
-- 结果在测试人工勾兑再交款入账的时候，发现有个没有交易清册，但确实是有，发现原来是分户的info_id发生了变化
-- 1. 在17库中根据数据查出来的分户info_id = 100001938589
-- 2. 根据房屋唯一编码查看15库中的info_id 发生了变化 -> 102987936338
-- noinspection SqlResolve
select *
from base_info
where info_id in (select info_id
                  from hou_info
                  where houinfo_no = (select houinfo_no
                                      from hou_info@db_link_15_17
                                      where info_id = 100001938589));