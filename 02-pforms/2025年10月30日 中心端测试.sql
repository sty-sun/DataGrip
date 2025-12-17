-- 查询符合条件的用户
select distinct tellers.user_id, roles.ROLE_NAME, tellers.user_name
from tellers join org_info org
on tellers.dept_id = org.org_id join users_roles ur on tellers.user_id = ur.user_id join roles on roles.role_id = ur.role_id left outer join (select user_id, ukey_id, row_number() over (partition by user_id order by createtime desc) as rn from user_ukey) latest_user_ukey on tellers.user_id = latest_user_ukey.user_id and latest_user_ukey.rn = 1 left outer join ukey u on latest_user_ukey.ukey_id = u.ukey_id
where org.org_status = '0'
  and roles.role_id <> 'ADM'
  and tellers.user_state = '1'
  and exists (select 1 from users_roles us join roles ro on us.role_id = ro.role_id where us.user_id = tellers.user_id
  and ro.role_id in (select ROLE_MENU.ROLE_ID from ROLE_MENU where MENU_ID = (select MENU_INFO.MENU_ID from MENU_INFO where MENU_NAME = '维修资金再交款')))
order by ROLE_NAME, length(user_id) desc, user_id desc;
-- 查询页面
select *
from MENU_INFO
where MENU_NAME = '方案申请主体信息变更';

-- 查询页面归哪个用户
select *
from ROLES
where ROLE_ID in (select ROLE_MENU.ROLE_ID
                  from ROLE_MENU
                  where MENU_ID = (select MENU_INFO.MENU_ID
                                   from MENU_INFO
                                   where MENU_NAME = '项目拆分合并'));