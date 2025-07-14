-- ============================================
-- 🏏 Cricketer Statistics Database Project
-- Author: Vaishnavi Ankush Kurhekar
-- Purpose: Analyze player and match performance
-- ============================================



Create database CricketStatsDB;
Use CricketStatsDB;
-- Cricketers Table
CREATE TABLE Cricketers (
    player_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    country VARCHAR(50),
    role VARCHAR(20), -- Batsman, Bowler, All-Rounder, Wicket-Keeper
    dob DATE
);
-- Matches Table
CREATE TABLE Matches (
    match_id INT PRIMARY KEY,
    match_date DATE NOT NULL,
    venue VARCHAR(100),
    teams VARCHAR(100), -- e.g., "India vs Australia"
    format VARCHAR(10) CHECK (format IN ('ODI', 'Test', 'T20'))
);
-- Batting Stats
CREATE TABLE BattingStats (
    stat_id INT PRIMARY KEY,
    player_id INT,
    match_id INT,
    runs INT,
    balls_faced INT,
    strike_rate DECIMAL(5,2),
    fours INT,
    sixes INT,
    dismissal_type VARCHAR(50),
    FOREIGN KEY (player_id) REFERENCES Cricketers(player_id),
    FOREIGN KEY (match_id) REFERENCES Matches(match_id)
);

-- Bowling Stats
CREATE TABLE BowlingStats (
    stat_id INT PRIMARY KEY,
    player_id INT,
    match_id INT,
    overs DECIMAL(4,1),
    wickets INT,
    runs_conceded INT,
    economy DECIMAL(4,2),
    FOREIGN KEY (player_id) REFERENCES Cricketers(player_id),
    FOREIGN KEY (match_id) REFERENCES Matches(match_id)
);
-- PlayerStats
CREATE TABLE PlayerMatchStats (
    player_id INT,
    match_id INT,
    FOREIGN KEY (player_id) REFERENCES Cricketers(player_id),
    FOREIGN KEY (match_id) REFERENCES Matches(match_id)
);

CALL GenerateDummyCricketers(20);
SELECT * FROM Cricketers;
CALL GenerateDummyMatches(15);
SELECT * FROM Matches;
SELECT player_id FROM Cricketers WHERE player_id BETWEEN 101 AND 105;
SELECT match_id FROM Matches WHERE match_id BETWEEN 201 AND 205;

INSERT INTO BattingStats (stat_id, player_id, match_id, runs, balls_faced, strike_rate, fours, sixes, dismissal_type) VALUES
(301, 101, 201, 85, 70, 121.43, 8, 2, 'Caught'),
(302, 102, 202, 45, 38, 118.42, 4, 1, 'Bowled'),
(303, 103, 203, 120, 150, 80.00, 15, 1, 'Not Out'),
(304, 104, 204, 60, 50, 120.00, 6, 2, 'LBW'),
(305, 105, 205, 30, 25, 120.00, 3, 0, 'Caught'),
(306, 106, 206, 10, 15, 66.67, 1, 0, 'Bowled'),
(307, 107, 207, 95, 80, 118.75, 9, 3, 'Caught'),
(308, 108, 208, 55, 45, 122.22, 5, 2, 'LBW'),
(309, 109, 209, 100, 90, 111.11, 10, 4, 'Not Out'),
(310, 110, 210, 20, 18, 111.11, 2, 0, 'Caught'),
(311, 111, 211, 75, 60, 125.00, 7, 2, 'Bowled'),
(312, 112, 212, 40, 35, 114.29, 4, 1, 'Caught'),
(313, 113, 213, 65, 55, 118.18, 6, 2, 'LBW'),
(314, 114, 214, 90, 85, 105.88, 9, 3, 'Not Out'),
(315, 115, 215, 15, 12, 125.00, 1, 0, 'Caught');
SELECT * FROM BattingStats;
SELECT match_id FROM Matches ORDER BY match_id;
INSERT INTO BowlingStats (stat_id, player_id, match_id, overs, wickets, runs_conceded, economy) VALUES
(401, 101, 201, 10.0, 3, 45, 4.50),
(402, 102, 202, 4.0, 2, 28, 7.00),
(403, 103, 203, 15.0, 1, 60, 4.00),
(404, 104, 204, 8.0, 4, 32, 4.00),
(405, 105, 205, 6.0, 2, 40, 6.67),
(406, 106, 206, 10.0, 5, 25, 2.50),
(407, 107, 207, 7.0, 1, 35, 5.00),
(408, 108, 208, 9.0, 3, 42, 4.67),
(409, 109, 209, 5.0, 0, 30, 6.00),
(410, 110, 210, 6.0, 2, 36, 6.00),
(411, 111, 211, 10.0, 4, 40, 4.00),
(412, 112, 212, 8.0, 3, 38, 4.75),
(413, 113, 213, 6.0, 2, 33, 5.50),
(414, 114, 214, 7.0, 1, 29, 4.14),
(415, 115, 215, 5.0, 2, 27, 5.40);
SELECT * FROM BowlingStats;
UPDATE Cricketers SET country = 'India', role = 'Batsman' WHERE player_id = 101;
---- Basic Queries-----
-- 1 List All Cricketers
SELECT * FROM Cricketers;
-- 2 Find Players from India
SELECT name FROM  Cricketers where country = 'India';
-- 3 Count Total Matches
SELECT Count(*) As total_Matches from Cricketers;
-- 4. Get All T20 Matches
Select * from Matches where format = 'T20';
-- 5 Count Players by Country
select country, count(*) AS total_players from Cricketers Group by Country;
-- 6 Show Matches Played in January 2023
Select Match_id, match_date, teams from Matches Where match_date between '2023-01-01' AND '2023-01-31';
------------------------------- INTERMEDIATE QUERIES ----------------------------------
-- 1  Total Runs by Each Player
SELECT b.player_id,c.name, SUM(b.runs) AS total_runs
FROM BattingStats b
JOIN 
    Cricketers c ON b.player_id = c.player_id
GROUP BY 
    b.player_id
ORDER BY 
    total_runs DESC;
-- 2 Average Strike Rate by Player
SELECT c.name, ROUND(AVG(b.strike_rate), 2) AS avg_strike_rate
FROM BattingStats b
JOIN 
    Cricketers c ON b.player_id = c.player_id
GROUP BY b.player_id
ORDER BY avg_strike_rate DESC;

-- 3 Most Wickets by Bowler
SELECT c.name, SUM(bs.wickets) AS total_wickets
FROM BowlingStats bs
JOIN 
    Cricketers c ON bs.player_id = c.player_id
GROUP BY bs.player_id
ORDER BY total_wickets DESC;
-- 4 Show each player's batting performance with their name
SELECT c.name, b.runs, b.balls_faced, b.strike_rate
FROM BattingStats b
JOIN 
    Cricketers c ON b.player_id = c.player_id;
-- 5 Total Runs by each country
SELECT c.country, SUM(b.runs) AS total_country_runs
FROM BattingStats b
JOIN 
    Cricketers c ON b.player_id = c.player_id
GROUP BY c.country
ORDER BY total_country_runs DESC;
-- 6 Show Match-Wise Player Performance
SELECT m.match_id, m.teams, c.name AS player_name, b.runs, bs.wickets
FROM Matches m
JOIN 
    BattingStats b ON m.match_id = b.match_id
JOIN 
    BowlingStats bs ON m.match_id = bs.match_id AND b.player_id = bs.player_id
    
JOIN 
    Cricketers c ON b.player_id = c.player_id;
-- 7  Players with 2+ Innings and Avg Strike Rate > 100
SELECT c.player_id, c.name, COUNT(*) AS innings, ROUND(AVG(b.strike_rate), 2) AS avg_strike_rate
FROM BattingStats b
JOIN 
    Cricketers c ON b.player_id = c.player_id
GROUP BY b.player_id
HAVING innings >= 2 AND avg_strike_rate > 100
ORDER BY avg_strike_rate DESC;

-- 8 All-Rounders with Runs and Wicket
SELECT c.name,SUM(b.runs) AS total_runs,SUM(bs.wickets) AS total_wickets
FROM Cricketers c
LEFT JOIN 
    BattingStats b ON c.player_id = b.player_id
LEFT JOIN 
    BowlingStats bs ON c.player_id = bs.player_id
WHERE c.role = 'All-Rounder'
GROUP BY c.player_id
ORDER BY total_runs DESC, total_wickets DESC;


------------------------------ ADVANCE QUERIES --------------------------------------------
-- 1  Top Scorer in Each MatcH
SELECT m.match_id,m.teams,c.name AS top_scorer,b.runs
FROM BattingStats b
JOIN 
    Cricketers c ON b.player_id = c.player_id
JOIN 
    Matches m ON b.match_id = m.match_id
WHERE b.runs = (
        SELECT MAX(runs)
        FROM BattingStats
        WHERE match_id = m.match_id
    );
    
    -- 2 Best Bowling Performance (Most Wickets in a Match)
    SELECT m.match_id,m.teams,c.name AS top_bowler,bs.wickets
FROM BowlingStats bs
JOIN 
    Cricketers c ON bs.player_id = c.player_id
JOIN 
    Matches m ON bs.match_id = m.match_id
WHERE bs.wickets = (
        SELECT MAX(wickets)
        FROM BowlingStats
        WHERE match_id = m.match_id
    );
    -- 3  Dismissal Type Frequency by Country
SELECT c.country,b.dismissal_type,COUNT(*) AS frequency
FROM BattingStats b
JOIN 
    Cricketers c ON b.player_id = c.player_id
GROUP BY c.country, b.dismissal_type
ORDER BY c.country, frequency DESC;
-------------------------------- STORED PROCEDURE ------------------------------
-- create a stored procedure that generates a full player report dynamically
DELIMITER //

CREATE PROCEDURE GetFullPlayerReport(IN pid INT)
BEGIN
    -- Player Info
    SELECT c.name AS player_name,c.country,c.role,c.dob
    FROM Cricketers c
    WHERE c.player_id = pid;

    -- Batting Summary
    SELECT 
        COUNT(*) AS innings_played,
        SUM(runs) AS total_runs,
        ROUND(AVG(strike_rate), 2) AS avg_strike_rate,
        SUM(fours) AS total_fours,
        SUM(sixes) AS total_sixes
    FROM BattingStats
    WHERE player_id = pid;

    -- Bowling Summary
    SELECT 
        COUNT(*) AS matches_bowled,
        SUM(wickets) AS total_wickets,
        ROUND(AVG(economy), 2) AS avg_economy,
        SUM(runs_conceded) AS total_runs_conceded
    FROM BowlingStats
    WHERE player_id = pid;
END //

DELIMITER ;

CALL GetFullPlayerReport(101);
--------------------------------------- VIEW ------------------------------------
-- Build a view that summarizes each player’s batting and bowling performance in one place.
CREATE VIEW PlayerPerformanceSummary AS
SELECT c.player_id,c.name AS player_name,c.country,c.role,
    
    -- Batting Summary
    COALESCE(SUM(b.runs), 0) AS total_runs,
    ROUND(COALESCE(AVG(b.strike_rate), 0), 2) AS avg_strike_rate,
    COUNT(b.stat_id) AS innings_played,
    
    -- Bowling Summary
    COALESCE(SUM(bs.wickets), 0) AS total_wickets,
    ROUND(COALESCE(AVG(bs.economy), 0), 2) AS avg_economy,
    COUNT(bs.stat_id) AS matches_bowled

FROM Cricketers c
LEFT JOIN 
    BattingStats b ON c.player_id = b.player_id
LEFT JOIN 
    BowlingStats bs ON c.player_id = bs.player_id
GROUP BY c.player_id;

SELECT * FROM PlayerPerformanceSummary;