-- ²éÑ¯Ëø¶¨×´Ì¬
SELECT
    l.session_id sid,
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
FROM
    v$locked_object l,
    dba_objects o,
    v$session s
WHERE
    l.object_id = o.object_id
  AND l.session_id = s.sid
ORDER BY
    o.object_name;

-- ÇÐ¶Ï
ALTER SYSTEM KILL SESSION '965,4385';
