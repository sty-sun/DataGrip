-- 不要使用加密锁登录
update SYS_PARA set PARA_VALUE = 'false' where PARA_NAME = 'NEED_EPASS';
-- 使用加密锁登录
update SYS_PARA set PARA_VALUE = 'true' where PARA_NAME = 'NEED_EPASS';

