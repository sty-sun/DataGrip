SELECT s.sid,
       l.OS_USER_NAME,
       s.serial#,
       s.username,
       s.machine,
       s.program,
       q.sql_text
FROM v$session s
         JOIN v$sql q ON s.sql_id = q.sql_id
         JOIN v$locked_object l ON l.SESSION_ID = s.SID
WHERE s.status = 'ACTIVE'
  AND s.username IS NOT NULL
ORDER BY s.last_call_et DESC;
