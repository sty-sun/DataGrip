SELECT
    s.sid, s.serial#, s.username, s.machine, s.program,
    o.owner, o.object_name, lo.locked_mode
FROM v$locked_object lo
         JOIN dba_objects o ON o.object_id = lo.object_id
         JOIN v$session s ON s.sid = lo.session_id
WHERE o.object_name = 'EBILL_INFO';


-- ==================================================================================
-- 查询锁定状态
SELECT l.session_id,
       sid,
       s.serial#,
       l.locked_mode,
       l.oracle_username,
       s.user#,
       s.status,
       s.machine,
       s.program,
       s.osuser,
       o.object_name,
       o.object_type
FROM v$locked_object l,
     dba_objects o,
     v$session s
WHERE l.object_id = o.object_id
  AND l.session_id = s.sid
ORDER BY o.object_name;

-- 切断
ALTER SYSTEM KILL SESSION '774,12489';

-- 查看有哪些机器锁着哪些表
SELECT l.OS_USER_NAME,
       l.session_id AS sid,
       s.serial#,
       s.username,
       s.machine,
       s.program,
       o.object_name,
       o.object_type,
       l.locked_mode
FROM v$locked_object l
         JOIN all_objects o ON l.object_id = o.object_id
         JOIN v$session s ON l.session_id = s.sid
ORDER BY s.machine, o.object_name;
-- | LOCKED_MODE | 锁类型说明                    |
-- | ----------- | ------------------------------|
-- | 0           | None（无锁）                  |
-- | 1           | Null (N)                      |
-- | 2           | Row-S (RS): 行共享（SS）      |
-- | 3           | Row-X (RX): 行排他（SX）      |
-- | 4           | Share (S)                     |
-- | 5           | S/Row-X (SSX): 共享行排他     |
-- | 6           | Exclusive (X): 排他锁（最强） |

SELECT s.sid,
       l.OS_USER_NAME,
       s.serial#,
       s.username,
       s.machine,
       s.program,
       s.status,
       s.event,
       ll.type,
       ll.id1,
       ll.id2,
       s.sql_id,
       q.sql_text
FROM v$lock ll
         JOIN v$locked_object l ON l.SESSION_ID = ll.SID
         JOIN v$session s ON ll.sid = s.sid
         LEFT JOIN v$sql q ON s.sql_id = q.sql_id
WHERE s.username IS NOT NULL
ORDER BY s.machine, s.sid;

SELECT l.OS_USER_NAME,
       blocking_session,
       sid,
       serial#,
       wait_class,
       event,
       seconds_in_wait,
       state,
       machine,
       program
FROM v$session s
         JOIN v$locked_object l ON l.SESSION_ID = s.SID
WHERE blocking_session IS NOT NULL;