insert into carehome_sys.sys_menu (menu_id, name, perms, path, level, component, parent_id, icon, hidden, sort_order, status, sub_sys, tran_type, ext_info, keep_alive, embedded, menu_type, be_new,
                                   create_by, create_time, update_by, update_time, isdel, remark, tenant_id)
values (1749003132984, '拉取流水', 'pull_hxAcctWater', null, null, null, 9947, 'iconfont icon-xitongrizhi', 0, 1, null, 'web', null, null, 1, 0, 1, null, 'admin', '2025-12-04 09:30:48', 'admin',
        '2025-12-04 09:31:02', 0, null, 1);

INSERT INTO carehome_sys.sys_role_menu (role_id, menu_id) VALUES (1001, 1749003132984);
INSERT INTO carehome_sys.sys_role_menu (role_id, menu_id) VALUES (10023, 1749003132984);