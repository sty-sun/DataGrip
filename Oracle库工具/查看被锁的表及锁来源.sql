SELECT
    l.OS_USER_NAME,
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
