SELECT
    s.blocking_session,
    s.sid,
    s.serial#,
    s.username,
    s.machine,
    s.program,
    s.event,
    s.seconds_in_wait,
    s.state
FROM v$session s
WHERE blocking_session IS NOT NULL;
