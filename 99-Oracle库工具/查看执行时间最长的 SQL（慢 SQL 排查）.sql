-- 查看执行时间最长的 SQL（慢 SQL 排查）
SELECT *
FROM (SELECT sql_id,
             executions,
             ROUND(elapsed_time / 1000000, 2)                                                  AS total_sec,
             ROUND((elapsed_time / executions) / 1000000, 2)                                   AS avg_sec_per_exec,
             sql_text,
             ROW_NUMBER() OVER (ORDER BY ROUND((elapsed_time / executions) / 1000000, 2) DESC) AS rn
      FROM v$sql
      WHERE executions > 0)
WHERE rn <= 20;
