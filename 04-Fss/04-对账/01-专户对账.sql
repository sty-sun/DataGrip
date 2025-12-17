-------------------------------------------------------
-- 1. 专户对账主表 FSS_ACCT_RECON
-------------------------------------------------------
DROP TABLE FSS_ACCT_RECON;
CREATE TABLE FSS_ACCT_RECON
(
    RECON_ID           NUMBER(19)                    NOT NULL, -- 主键ID
    ACCT_NO            VARCHAR2(32 CHAR)             NOT NULL, -- 专户账号
    RECON_NO           VARCHAR2(32 CHAR)             NOT NULL, -- 对账编号(展示用，如 251203000001)
    RECON_DATE         CHAR(8 CHAR)                  NOT NULL, -- 对账日期时间
    RECON_TYPE         CHAR(1 CHAR)                  NOT NULL, -- 对账类型：A-自动，M-人工
    OPERATOR_CODE      VARCHAR2(32 CHAR)             NOT NULL, -- 操作员号
    OPERATOR_NAME      VARCHAR2(64 CHAR),                      -- 操作员姓名
    BANK_END_BAL       NUMBER(18, 2) DEFAULT 0       NOT NULL, -- 银行期末余额（元）
    SYS_END_BAL        NUMBER(18, 2) DEFAULT 0       NOT NULL, -- 系统期末余额（元）
    CURR_DR_MATCH_FLAG CHAR(1 CHAR)  DEFAULT 'N'     NOT NULL, -- 本期借方发生是否平账：Y-平 N-不平
    CURR_CR_MATCH_FLAG CHAR(1 CHAR)  DEFAULT 'N'     NOT NULL, -- 本期贷方发生是否平账：Y-平 N-不平
    END_MATCH_FLAG     CHAR(1 CHAR)  DEFAULT 'N'     NOT NULL, -- 期末余额是否平账：Y-平 N-不平
    REMARK             VARCHAR2(256 CHAR),                     -- 备注
    CREATE_TIME        DATE          DEFAULT SYSDATE NOT NULL, -- 创建时间
    UPDATE_TIME        DATE          DEFAULT SYSDATE NOT NULL, -- 更新时间
    CONSTRAINT PK_FSS_ACCT_RECON PRIMARY KEY (RECON_ID),
    CONSTRAINT UK_FSS_ACCT_RECON_NO UNIQUE (RECON_NO)
);

COMMENT ON TABLE FSS_ACCT_RECON IS '专户对账主表';
COMMENT ON COLUMN FSS_ACCT_RECON.RECON_ID IS '主键ID';
COMMENT ON COLUMN FSS_ACCT_RECON.ACCT_NO IS '专户账号';
COMMENT ON COLUMN FSS_ACCT_RECON.RECON_NO IS '对账编号(展示用，如 251203000001)';
COMMENT ON COLUMN FSS_ACCT_RECON.RECON_DATE IS '对账日期时间';
COMMENT ON COLUMN FSS_ACCT_RECON.RECON_TYPE IS '对账类型：A-自动，M-人工';
COMMENT ON COLUMN FSS_ACCT_RECON.OPERATOR_CODE IS '操作员号';
COMMENT ON COLUMN FSS_ACCT_RECON.OPERATOR_NAME IS '操作员姓名';
COMMENT ON COLUMN FSS_ACCT_RECON.BANK_END_BAL IS '银行期末余额（元）';
COMMENT ON COLUMN FSS_ACCT_RECON.SYS_END_BAL IS '系统期末余额（元）';
COMMENT ON COLUMN FSS_ACCT_RECON.CURR_DR_MATCH_FLAG IS '本期借方发生是否平账：Y-平 N-不平';
COMMENT ON COLUMN FSS_ACCT_RECON.CURR_CR_MATCH_FLAG IS '本期贷方发生是否平账：Y-平 N-不平';
COMMENT ON COLUMN FSS_ACCT_RECON.END_MATCH_FLAG IS '期末余额是否平账：Y-平 N-不平';
COMMENT ON COLUMN FSS_ACCT_RECON. REMARK IS '备注';
COMMENT ON COLUMN FSS_ACCT_RECON.CREATE_TIME IS '创建时间';
COMMENT ON COLUMN FSS_ACCT_RECON.UPDATE_TIME IS '更新时间';

-------------------------------------------------------
-- 2. 日终平衡表主表 FSS_DAILY_BAL_SHEET
-------------------------------------------------------
DROP TABLE FSS_DAILY_BAL_SHEET;
CREATE TABLE FSS_DAILY_BAL_SHEET
(
    SHEET_ID           NUMBER(19)                    NOT NULL, -- 主键ID
    RECON_ID           NUMBER(19)                    NOT NULL, -- 来源对账ID
    ACCT_NO            VARCHAR2(32)                  NOT NULL, -- 专户账号
    ACCT_NAME          VARCHAR2(128),                          -- 专户名称
    ORG_ID             VARCHAR2(32),                           -- 管理机构ID
    RECON_DATE         CHAR(8)                       NOT NULL, -- 对账日期 YYYYMMDD
    -----------------------//实账平衡//-----------------------
    ---------------------------银行---------------------------
    BANK_BEGIN_BAL     NUMBER(18, 2) DEFAULT 0       NOT NULL, -- 银行期初余额
    BANK_DR_AMT        NUMBER(18, 2) DEFAULT 0       NOT NULL, -- 本期借方金额（银行）
    BANK_CR_AMT        NUMBER(18, 2) DEFAULT 0       NOT NULL, -- 本期贷方金额（银行）
    BANK_END_BAL       NUMBER(18, 2) DEFAULT 0       NOT NULL, -- 银行期末余额
    ---------------------------系统---------------------------
    SYS_BEGIN_BAL      NUMBER(18, 2) DEFAULT 0       NOT NULL, -- 系统期初余额
    SYS_DR_AMT         NUMBER(18, 2) DEFAULT 0       NOT NULL, -- 系统本期借方金额
    SYS_CR_AMT         NUMBER(18, 2) DEFAULT 0       NOT NULL, -- 系统本期贷方金额
    SYS_END_BAL        NUMBER(18, 2) DEFAULT 0       NOT NULL, -- 系统期末余额
    --------------------//双边发生额平衡//--------------------
    ---------------------------银行---------------------------
    BANK_BEGIN_BILA    NUMBER(18, 2) DEFAULT 0       NOT NULL, -- 银行双边期初余额
    BANK_PEND_DR_AMT   NUMBER(18, 2) DEFAULT 0       NOT NULL, -- 挂账借方金额（银行侧）
    BANK_PEND_CR_AMT   NUMBER(18, 2) DEFAULT 0       NOT NULL, -- 挂账贷方金额（银行侧）
    BANK_CLEAR_DR_AMT  NUMBER(18, 2) DEFAULT 0       NOT NULL, -- 清账借方金额（银行侧）
    BANK_CLEAR_CR_AMT  NUMBER(18, 2) DEFAULT 0       NOT NULL, -- 清账贷方金额（银行侧）
    BANK_DR_BILA       NUMBER(18, 2) DEFAULT 0       NOT NULL, -- 银行本期借方发生额
    BANK_CR_BILA       NUMBER(18, 2) DEFAULT 0       NOT NULL, -- 银行本期贷方发生额
    BANK_END_BILA      NUMBER(18, 2) DEFAULT 0       NOT NULL, -- 银行双边期末余额
    ---------------------------系统---------------------------
    SYS_BEGIN_BILA     NUMBER(18, 2) DEFAULT 0       NOT NULL, -- 系统双边期初余额
    SYS_PEND_DR_AMT    NUMBER(18, 2) DEFAULT 0       NOT NULL, -- 系统挂账借方金额
    SYS_PEND_CR_AMT    NUMBER(18, 2) DEFAULT 0       NOT NULL, -- 系统挂账贷方金额
    SYS_CLEAR_DR_AMT   NUMBER(18, 2) DEFAULT 0       NOT NULL, -- 系统清账借方金额
    SYS_CLEAR_CR_AMT   NUMBER(18, 2) DEFAULT 0       NOT NULL, -- 系统清账贷方金额
    SYS_DR_BILA        NUMBER(18, 2) DEFAULT 0       NOT NULL, -- 系统本期借方发生额
    SYS_CR_BILA        NUMBER(18, 2) DEFAULT 0       NOT NULL, -- 系统本期贷方发生额
    SYS_END_BILA       NUMBER(18, 2) DEFAULT 0       NOT NULL, -- 系统双边期末余额
    -----------------------//调整平衡//-----------------------
    ---------------------------银行---------------------------
    BANK_ADJ_BEGIN_BAL NUMBER(18, 2) DEFAULT 0       NOT NULL, -- 银行调整前余额
    BANK_ADJ_END_BAL   NUMBER(18, 2) DEFAULT 0       NOT NULL, -- 银行调整后余额
    ---------------------------系统---------------------------
    SYS_ADJ_BEGIN_BAL  NUMBER(18, 2) DEFAULT 0       NOT NULL, -- 系统调整前余额
    SYS_ADJ_END_BAL    NUMBER(18, 2) DEFAULT 0       NOT NULL, -- 系统调整后余额
    ---------------------------总结---------------------------
    BALANCE_FLAG       CHAR(1)       DEFAULT 'N'     NOT NULL, -- 是否平衡 Y/N
    BALANCE_DIFF_AMT   NUMBER(18, 2) DEFAULT 0       NOT NULL, -- 调整后余额差额（银行-系统）
    -----------------------//其他字段//-----------------------
    REMARK             VARCHAR2(512),                          -- 备注说明
    CREATE_TIME        DATE          DEFAULT SYSDATE NOT NULL, -- 创建时间
    CREATE_USER        VARCHAR2(32),                           -- 创建人
    UPDATE_TIME        DATE,                                   -- 最后更新时间
    UPDATE_USER        VARCHAR2(32),                           -- 最后更新人
    CONSTRAINT PK_FSS_DAILY_BAL_SHEET PRIMARY KEY (SHEET_ID),
    CONSTRAINT UK_FSS_DAILY_BAL_1 UNIQUE (ACCT_NO, RECON_DATE)
);

COMMENT ON TABLE FSS_DAILY_BAL_SHEET IS '日终平衡表主表-合并了对账明细表';
COMMENT ON COLUMN FSS_DAILY_BAL_SHEET.SHEET_ID IS '主键ID';
COMMENT ON COLUMN FSS_DAILY_BAL_SHEET. RECON_ID IS '来源对账ID';
COMMENT ON COLUMN FSS_DAILY_BAL_SHEET.ACCT_NO IS '专户账号';
COMMENT ON COLUMN FSS_DAILY_BAL_SHEET.ACCT_NAME IS '专户名称';
COMMENT ON COLUMN FSS_DAILY_BAL_SHEET.ORG_ID IS '管理机构ID';
COMMENT ON COLUMN FSS_DAILY_BAL_SHEET.RECON_DATE IS '对账日期 YYYYMMDD';
COMMENT ON COLUMN FSS_DAILY_BAL_SHEET. BANK_BEGIN_BAL IS '银行期初余额';
COMMENT ON COLUMN FSS_DAILY_BAL_SHEET.BANK_DR_AMT IS '本期借方金额（银行）';
COMMENT ON COLUMN FSS_DAILY_BAL_SHEET. BANK_CR_AMT IS '本期贷方金额（银行）';
COMMENT ON COLUMN FSS_DAILY_BAL_SHEET. BANK_END_BAL IS '银行期末余额';
COMMENT ON COLUMN FSS_DAILY_BAL_SHEET.SYS_BEGIN_BAL IS '系统期初余额';
COMMENT ON COLUMN FSS_DAILY_BAL_SHEET.SYS_DR_AMT IS '系统本期借方金额';
COMMENT ON COLUMN FSS_DAILY_BAL_SHEET.SYS_CR_AMT IS '系统本期贷方金额';
COMMENT ON COLUMN FSS_DAILY_BAL_SHEET.SYS_END_BAL IS '系统期末余额';
COMMENT ON COLUMN FSS_DAILY_BAL_SHEET.BANK_BEGIN_BILA IS '银行双边期初余额';
COMMENT ON COLUMN FSS_DAILY_BAL_SHEET.BANK_PEND_DR_AMT IS '挂账借方金额（银行侧）';
COMMENT ON COLUMN FSS_DAILY_BAL_SHEET.BANK_PEND_CR_AMT IS '挂账贷方金额（银行侧）';
COMMENT ON COLUMN FSS_DAILY_BAL_SHEET.BANK_CLEAR_DR_AMT IS '清账借方金额（银行侧）';
COMMENT ON COLUMN FSS_DAILY_BAL_SHEET.BANK_CLEAR_CR_AMT IS '清账贷方金额（银行侧）';
COMMENT ON COLUMN FSS_DAILY_BAL_SHEET. BANK_DR_BILA IS '银行本期借方发生额';
COMMENT ON COLUMN FSS_DAILY_BAL_SHEET.BANK_CR_BILA IS '银行本期贷方发生额';
COMMENT ON COLUMN FSS_DAILY_BAL_SHEET.BANK_END_BILA IS '银行双边期末余额';
COMMENT ON COLUMN FSS_DAILY_BAL_SHEET.SYS_BEGIN_BILA IS '系统双边期初余额';
COMMENT ON COLUMN FSS_DAILY_BAL_SHEET.SYS_PEND_DR_AMT IS '系统挂账借方金额';
COMMENT ON COLUMN FSS_DAILY_BAL_SHEET.SYS_PEND_CR_AMT IS '系统挂账贷方金额';
COMMENT ON COLUMN FSS_DAILY_BAL_SHEET.SYS_CLEAR_DR_AMT IS '系统清账借方金额';
COMMENT ON COLUMN FSS_DAILY_BAL_SHEET.SYS_CLEAR_CR_AMT IS '系统清账贷方金额';
COMMENT ON COLUMN FSS_DAILY_BAL_SHEET.SYS_DR_BILA IS '系统本期借方发生额';
COMMENT ON COLUMN FSS_DAILY_BAL_SHEET. SYS_CR_BILA IS '系统本期贷方发生额';
COMMENT ON COLUMN FSS_DAILY_BAL_SHEET.SYS_END_BILA IS '系统双边期末余额';
COMMENT ON COLUMN FSS_DAILY_BAL_SHEET.BANK_ADJ_BEGIN_BAL IS '银行调整前余额';
COMMENT ON COLUMN FSS_DAILY_BAL_SHEET.BANK_ADJ_END_BAL IS '银行调整后余额';
COMMENT ON COLUMN FSS_DAILY_BAL_SHEET. SYS_ADJ_BEGIN_BAL IS '系统调整前余额';
COMMENT ON COLUMN FSS_DAILY_BAL_SHEET.SYS_ADJ_END_BAL IS '系统调整后余额';
COMMENT ON COLUMN FSS_DAILY_BAL_SHEET.BALANCE_FLAG IS '是否平衡 Y/N';
COMMENT ON COLUMN FSS_DAILY_BAL_SHEET. BALANCE_DIFF_AMT IS '调整后余额差额（银行-系统）';
COMMENT ON COLUMN FSS_DAILY_BAL_SHEET.REMARK IS '备注说明';
COMMENT ON COLUMN FSS_DAILY_BAL_SHEET.CREATE_TIME IS '创建时间';
COMMENT ON COLUMN FSS_DAILY_BAL_SHEET. CREATE_USER IS '创建人';
COMMENT ON COLUMN FSS_DAILY_BAL_SHEET.UPDATE_TIME IS '最后更新时间';
COMMENT ON COLUMN FSS_DAILY_BAL_SHEET. UPDATE_USER IS '最后更新人';

CREATE INDEX IDX_FSS_DAILY_BAL_SHEET_DATE ON FSS_DAILY_BAL_SHEET (RECON_DATE);

-------------------------------------------------------
-- 3. 日终对账平衡表调整明细表 FSS_DAILY_BAL_ADJ_ITEM
-------------------------------------------------------
DROP TABLE FSS_DAILY_BAL_ADJ_ITEM;
CREATE TABLE FSS_DAILY_BAL_ADJ_ITEM
(
    ITEM_ID       NUMBER(19)              NOT NULL, -- 主键ID
    SHEET_ID      NUMBER(19)              NOT NULL, -- 所属平衡表ID
    SIDE_TYPE     CHAR(1)                 NOT NULL, -- 所属侧：B-银行 S-系统
    ADJ_TYPE      CHAR(1)                 NOT NULL, -- 调整类型：A-应加 S-应减
    ITEM_CODE     VARCHAR2(32)            NOT NULL, -- 调整项编码（配置表）
    ITEM_NAME     VARCHAR2(128)           NOT NULL, -- 调整项名称
    AMOUNT        NUMBER(18, 2) DEFAULT 0 NOT NULL, -- 调整金额
    CFG_ID        NUMBER(19),                       -- 来源配置ID
    REASON        VARCHAR2(256),                    -- 调整原因
    DISPLAY_ORDER NUMBER(10)    DEFAULT 0 NOT NULL, -- 显示顺序
    CONSTRAINT PK_FSS_DAILY_BAL_ADJ_ITEM PRIMARY KEY (ITEM_ID)
);

COMMENT ON TABLE FSS_DAILY_BAL_ADJ_ITEM IS '日终对账平衡表调整明细表';
COMMENT ON COLUMN FSS_DAILY_BAL_ADJ_ITEM.ITEM_ID IS '主键ID';
COMMENT ON COLUMN FSS_DAILY_BAL_ADJ_ITEM.SHEET_ID IS '所属平衡表ID';
COMMENT ON COLUMN FSS_DAILY_BAL_ADJ_ITEM. SIDE_TYPE IS '所属侧：B-银行 S-系统';
COMMENT ON COLUMN FSS_DAILY_BAL_ADJ_ITEM.ADJ_TYPE IS '调整类型：A-应加 S-应减';
COMMENT ON COLUMN FSS_DAILY_BAL_ADJ_ITEM.ITEM_CODE IS '调整项编码（配置表）';
COMMENT ON COLUMN FSS_DAILY_BAL_ADJ_ITEM.ITEM_NAME IS '调整项名称';
COMMENT ON COLUMN FSS_DAILY_BAL_ADJ_ITEM.AMOUNT IS '调整金额';
COMMENT ON COLUMN FSS_DAILY_BAL_ADJ_ITEM. CFG_ID IS '来源配置ID';
COMMENT ON COLUMN FSS_DAILY_BAL_ADJ_ITEM.REASON IS '调整原因';
COMMENT ON COLUMN FSS_DAILY_BAL_ADJ_ITEM. DISPLAY_ORDER IS '显示顺序';

-------------------------------------------------------
-- 4. 日平衡表调整项目配置表 FSS_DAILY_BAL_ADJ_ITEM_CFG
-------------------------------------------------------
DROP TABLE FSS_DAILY_BAL_ADJ_ITEM_CFG;
CREATE TABLE FSS_DAILY_BAL_ADJ_ITEM_CFG
(
    CFG_ID            NUMBER(19)                    NOT NULL, -- 主键ID
    ACCT_NO           VARCHAR2(32 CHAR)             NOT NULL, -- 专户账号
    SIDE_TYPE         CHAR(1)                       NOT NULL, -- 所属侧：B-银行流水 S-维修资金系统
    ADJ_TYPE          CHAR(1)                       NOT NULL, -- 调整类型：A-应加 S-应减
    ITEM_CODE         VARCHAR2(32)                  NOT NULL, -- 项目编码（系统内部编码）
    ITEM_NAME         VARCHAR2(128)                 NOT NULL, -- 项目名称（如清户利息、户卡未到账）
    DEFAULT_AMT       NUMBER(18, 2) DEFAULT 0       NOT NULL, -- 默认金额（0表示运行时计算）
    EFFECT_START_DATE CHAR(8)                       NOT NULL, -- 生效开始日期 YYYYMMDD
    EFFECT_END_DATE   CHAR(8),                                -- 生效结束日期 YYYYMMDD，可为空
    REASON            VARCHAR2(256),                          -- 原因说明
    DISPLAY_ORDER     NUMBER(10)    DEFAULT 0       NOT NULL, -- 显示顺序
    IS_DEL            CHAR(1)       DEFAULT '0'     NOT NULL, -- 是否删除：0-未删除，1-已删除
    CREATE_TIME       DATE          DEFAULT SYSDATE NOT NULL, -- 创建时间
    CREATE_USER       VARCHAR2(32),                           -- 创建人
    UPDATE_TIME       DATE,                                   -- 最后更新时间
    UPDATE_USER       VARCHAR2(32),                           -- 最后更新人
    CONSTRAINT PK_FSS_DAILY_BAL_ADJ_ITEM_CFG PRIMARY KEY (CFG_ID),
    CONSTRAINT UK_FSS_DAILY_ADJ_ITEM_CFG UNIQUE (SIDE_TYPE, ADJ_TYPE, ITEM_CODE)
);

COMMENT ON TABLE FSS_DAILY_BAL_ADJ_ITEM_CFG IS '日平衡表调整项目配置表';
COMMENT ON COLUMN FSS_DAILY_BAL_ADJ_ITEM_CFG.CFG_ID IS '主键ID';
COMMENT ON COLUMN FSS_DAILY_BAL_ADJ_ITEM_CFG.ACCT_NO IS '专户账号';
COMMENT ON COLUMN FSS_DAILY_BAL_ADJ_ITEM_CFG.SIDE_TYPE IS '所属侧：B-银行流水 S-维修资金系统';
COMMENT ON COLUMN FSS_DAILY_BAL_ADJ_ITEM_CFG.ADJ_TYPE IS '调整类型：A-应加 S-应减';
COMMENT ON COLUMN FSS_DAILY_BAL_ADJ_ITEM_CFG.ITEM_CODE IS '项目编码（系统内部编码）';
COMMENT ON COLUMN FSS_DAILY_BAL_ADJ_ITEM_CFG.ITEM_NAME IS '项目名称（如清户利息、户卡未到账）';
COMMENT ON COLUMN FSS_DAILY_BAL_ADJ_ITEM_CFG.DEFAULT_AMT IS '默认金额（0表示运行时计算）';
COMMENT ON COLUMN FSS_DAILY_BAL_ADJ_ITEM_CFG.EFFECT_START_DATE IS '生效开始日期 YYYYMMDD';
COMMENT ON COLUMN FSS_DAILY_BAL_ADJ_ITEM_CFG. EFFECT_END_DATE IS '生效结束日期 YYYYMMDD，可为空';
COMMENT ON COLUMN FSS_DAILY_BAL_ADJ_ITEM_CFG. REASON IS '原因说明';
COMMENT ON COLUMN FSS_DAILY_BAL_ADJ_ITEM_CFG.DISPLAY_ORDER IS '显示顺序';
COMMENT ON COLUMN FSS_DAILY_BAL_ADJ_ITEM_CFG.IS_DEL IS '是否删除：0-未删除，1-已删除';
COMMENT ON COLUMN FSS_DAILY_BAL_ADJ_ITEM_CFG.CREATE_TIME IS '创建时间';
COMMENT ON COLUMN FSS_DAILY_BAL_ADJ_ITEM_CFG.CREATE_USER IS '创建人';
COMMENT ON COLUMN FSS_DAILY_BAL_ADJ_ITEM_CFG.UPDATE_TIME IS '最后更新时间';
COMMENT ON COLUMN FSS_DAILY_BAL_ADJ_ITEM_CFG.UPDATE_USER IS '最后更新人';