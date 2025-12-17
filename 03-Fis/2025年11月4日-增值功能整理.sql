# 存单查询&冲正存单查询：
## 涉及到的表：
-- increment_deposit_info：增值存单表
-- increment_new_correct_info：季度计提冲正记录表
-- increment_bus_status：存单表
-- increment_code_info：存单代码信息表
-- increment_rate_adjust：利息调整记录表
-- ------------------------------------------------
-- tellers：
## 功能整理：
### 存单查询：
#### 涉及角色（每种举例一个）：
-- INSERT INTO HMFMSFD.TELLERS (USER_ID, USER_NAME, ROLE_NAME) VALUES ('6762', '银行增值操作员', '银行增值业务录入人员');
-- INSERT INTO HMFMSFD.TELLERS (USER_ID, USER_NAME, ROLE_NAME) VALUES ('5832', '李津', '中心查询');
-- INSERT INTO HMFMSFD.TELLERS (USER_ID, USER_NAME, ROLE_NAME) VALUES ('139', '刘彬', '中心资金管理部出纳(初核)');
-- INSERT INTO HMFMSFD.TELLERS (USER_ID, USER_NAME, ROLE_NAME) VALUES ('112', '张媛', '中心资金管理部会计(复核)');
-- INSERT INTO HMFMSFD.TELLERS (USER_ID, USER_NAME, ROLE_NAME) VALUES ('11002', '高雅君', '中心资金管理部增值业务人员');
#### 操作：
-- 1. 查询 --> 存在筛选条件：账户名称、存款编号、开始日、截止日、业务类型、存单状态、存单存期
-- --> 总共有两个查询：
-- --> 1. 查询存单总数及存单金额总计 --> 根据登录的用户id拼接查询的数据源sql语句 --> id in (109, 139) 只能查询自己相关的记录、 id in (11, 12, 104, 6) 查询所有状态不等于“已支取”(YiZhiQu) 的记录、其他id无权限 where 1=0
-- --> 2. 查询详细的列表信息         --> 根据登录的用户id拼接查询的数据源sql语句 --> id in (109, 139) 只能查询自己相关的记录、 id in (11, 12, 104, 6) 查询所有状态不等于“已支取”(YiZhiQu) 的记录、其他id无权限 where 1=0
-- 2. 导出 --> 导出成excel
-- 3. 现存存单存款结构统计表 --> 从增值存单表 increment_deposit_info 中，统计指定账户下各存期（deposit_term）的存款金额与占比，用于生成“分年期存款结构分析”。
### 冲正存单查询：
#### 涉及角色（每种举例一个）：
-- INSERT INTO HMFMSFD.TELLERS (USER_ID, USER_NAME, ROLE_NAME) VALUES ('6762', '银行增值操作员', '银行增值业务录入人员');
#### 操作：
-- 1. 查询 --> 存在筛选条件：账户名称、账户编号、存款编号
-- --> 从季度计提冲正记录表 increment_new_correct_info 中，根据账户名称、账户编号、存款编号等条件分页查询存款更正记录列表
-- =====================================================================================================================================================================================================
# 利息收入测算:
## 涉及到的表：
-- increment_measure_interest：利息收益测算表
-- increment_deposit_info：增值存单表
-- increment_acct_info：维修资金专户信息表
## 涉及角色：
-- INSERT INTO HMFMSFD.TELLERS (USER_ID, USER_NAME, ROLE_NAME) VALUES ('6762', '银行增值操作员', '银行增值业务录入人员');
-- INSERT INTO HMFMSFD.TELLERS (USER_ID, USER_NAME, ROLE_NAME) VALUES ('104', '代红', '中心资金管理部会计(复核)');
-- INSERT INTO HMFMSFD.TELLERS (USER_ID, USER_NAME, ROLE_NAME) VALUES ('11002', '高雅君', '中心资金管理部增值业务人员');
## 操作：
### 列表展示： --> 根据指定的查询条件（账户号、账户名称、结息截止日期）从利息收益测算表 increment_measure_interest 中查询符合条件的利息测算记录
### 详情查询： --> 利息收入测算明细 --> 实际为获得利息测算历史纪录
### 测算信息录入：--> 录入信息后计算出利息写入库中
-- =====================================================================================================================================================================================================
# 业主利息支付估算
## 涉及到的表：
-- owner_calculation_info：业主利息测算信息表
-- owner_calculation_detail：业主利息测算明细表
-- owner_estimate_detail：业主估算明细表
-- base_info
-- sys_para
-- acct
-- hou_info
## 涉及到的角色：
-- INSERT INTO HMFMSFD.TELLERS (USER_ID, USER_NAME, ROLE_NAME) VALUES ('15807', '中心资金管理部增值业务人员2', '中心资金管理部增值业务人员');
## 操作：
### 列表展示：    -->
### 业主利息估算: --> 对某类账户进行利息测算，并将测算结果保存到 owner_estimate_detail 业主估算明细表中
--                --> 利息公式： 利息=(余额+归集金额/2)×利率×天数/(360×100)
-- =====================================================================================================================================================================================================
# 增值利率查询
## 涉及到的表：
-- rate_info：利率管理表
## 角色：
-- INSERT INTO HMFMSFD.TELLERS (USER_ID, USER_NAME, ROLE_NAME) VALUES ('117', '王婧', '中心资金管理部会计(复核)');
-- INSERT INTO HMFMSFD.TELLERS (USER_ID, USER_NAME, ROLE_NAME) VALUES ('11002', '高雅君', '中心资金管理部增值业务人员');
## 功能
-- 查询：--> 按日期和利率期限查询
-- 导出
-- =====================================================================================================================================================================================================
# 增值利率调整
## 涉及的表
-- rate_info：利率管理表
-- rate_detail：利率调整表
-- trade
-- menu_info
## 角色
-- INSERT INTO HMFMSFD.TELLERS (USER_ID, USER_NAME, ROLE_NAME) VALUES ('117', '王婧', '中心资金管理部会计(复核)');
-- INSERT INTO HMFMSFD.TELLERS (USER_ID, USER_NAME, ROLE_NAME) VALUES ('15808', '银行增值业务录入人员', '银行增值业务录入人员');
-- INSERT INTO HMFMSFD.TELLERS (USER_ID, USER_NAME, ROLE_NAME) VALUES ('6762', '银行增值操作员', '银行增值业务录入人员');
## 功能
-- 列表展示
-- 新增、删除、撤销审核、提交审核、审核通过（更新到主表）、撤销审核通过、发送银行、审核退回
-- =====================================================================================================================================================================================================
# 增值利率统计报表
## 涉及的表

## 角色
-- INSERT INTO HMFMSFD.TELLERS (USER_ID, USER_NAME, ROLE_NAME) VALUES ('112', '张媛', '中心资金管理部会计(复核)');
## 功能
-- 1. 计算增值收益率、打印.

-- 2. 利率变动显示、打印