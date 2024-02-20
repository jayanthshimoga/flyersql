
QUESTION 1

Input: 
Calls table:
+---------+-------+----------+
| from_id | to_id | duration |
+---------+-------+----------+
| 1       | 2     | 59       |
| 2       | 1     | 11       |
| 1       | 3     | 20       |
| 3       | 4     | 100      |
| 3       | 4     | 200      |
| 3       | 4     | 200      |
| 4       | 3     | 499      |
+---------+-------+----------+
Output: 
+---------+---------+------------+----------------+
| person1 | person2 | call_count | total_duration |
+---------+---------+------------+----------------+
| 1       | 2       | 2          | 70             |
| 1       | 3       | 1          | 20             |
| 3       | 4       | 4          | 999            |
+---------+---------+------------+----------------+
Explanation: 
Users 1 and 2 had 2 calls and the total duration is 70 (59 + 11).
Users 1 and 3 had 1 call and the total duration is 20.
Users 3 and 4 had 4 calls and the total duration is 999 (100 + 200 + 200 + 499).


ANSWER 1

SELECT LEAST(from_id, to_id) as person1, GREATEST(from_id, to_id) as person2,
    COUNT(*) as call_count, SUM(duration) as total_duration FROM Calls
    GROUP BY person1, person2
    ORDER BY from_id;

# OR

SELECT 
    IF(from_id < to_id, from_id, to_id) as person1,
    IF(from_id > to_id, from_id, to_id) as person2,
    COUNT(*) as call_count, SUM(duration) as total_duration FROM Calls
    GROUP BY person1, person2
    ORDER BY from_id;

-------------------------------------------------------------------------------------------

QUESTION 2

