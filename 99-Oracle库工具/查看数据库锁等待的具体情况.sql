SELECT
    l1.sid AS waiting_sid,
    l2.sid AS blocking_sid,
    l1.wait_time,
    l1.seconds_in_wait,
    l1.event AS waiting_event,
    l2.event AS blocking_event
FROM v$session l1
         JOIN v$session l2 ON l1.blocking_session = l2.sid
WHERE l1.blocking_session IS NOT NULL;


SELECT
    s.sid,
    s.serial#,
    s.username,
    s.osuser,
    s.machine,
    s.program,
    o.object_name,
    l.locked_mode,
    DECODE(l.locked_mode,
           0, 'None',
           1, 'Null',
           2, 'Row-S (SS)',
           3, 'Row-X (SX)',
           4, 'Share (S)',
           5, 'S/Row-X (SSX)',
           6, 'Exclusive (X)',
           'Unknown') AS lock_mode_desc,
    s.sql_id,
    s.status
FROM
    v$locked_object l
        JOIN
    dba_objects o ON l.object_id = o.object_id
        JOIN
    v$session s ON l.session_id = s.sid
WHERE s.STATUS = 'ACTIVE'
ORDER BY
    o.object_name;

SELECT
    s.sid,
    s.username,
    s.machine,
    DECODE(l.type, 'TX', 'Transaction (Row Lock)', 'TM', 'DML (Table Lock)', l.type) AS lock_type,
    DECODE(l.lmode, 0, 'None', 1, 'Null', 2, 'Row-S', 3, 'Row-X', 4, 'Share', 5, 'S/Row-X', 6, 'Exclusive', 'Unknown') AS mode_held,
    DECODE(l.request, 0, 'None', 1, 'Null', 2, 'Row-S', 3, 'Row-X', 4, 'Share', 5, 'S/Row-X', 6, 'Exclusive', 'Unknown') AS mode_requested,
    o.object_name
FROM
    v$lock l
        JOIN
    v$session s ON l.sid = s.sid
        LEFT JOIN
    dba_objects o ON l.id1 = o.object_id
WHERE
    s.username IS NOT NULL AND (l.request > 0 OR l.lmode > 0)
  AND OBJECT_NAME
ORDER BY
    l.id1, l.id2;