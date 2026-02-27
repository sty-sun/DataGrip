SELECT
    s.sid,
    s.serial#,
    s.username,
    s.status,
    s.osuser,
    s.machine,
    s.program,
    s.module,
    s.logon_time,
    s.sql_id,
    q.sql_text
FROM v$session s
         LEFT JOIN v$sql q ON s.sql_id = q.sql_id
WHERE s.username IS NOT NULL
ORDER BY s.logon_time DESC;
