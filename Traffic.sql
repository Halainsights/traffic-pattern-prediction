CREATE DATABASE TrafficData;
USE TrafficData;

CREATE TABLE TrafficData (
    REGION VARCHAR(255),
    REGION_ID INT,
    WEST FLOAT,
    EAST FLOAT,
    SOUTH FLOAT,
    NORTH FLOAT,
    DESCRIPTION VARCHAR(255),
    CURRENT_SPEED FLOAT,
    LAST_UPDATED DATETIME
);
-- First ten rows
SELECT * FROM TrafficData LIMIT 10;
-- Time Series Analysis
SELECT
    REGION,
    AVG(CURRENT_SPEED) AS avg_speed,
    COUNT(*) AS traffic_count,
    DATE(LAST_UPDATED) AS date
FROM TrafficData
WHERE LAST_UPDATED BETWEEN '2024-01-01' AND '2024-12-31'
GROUP BY REGION, DATE(LAST_UPDATED)
ORDER BY date;

-- Traffic Volume Prediction using Historical Averages
      -- Hourly Averages for speed
SELECT 
    REGION, 
    HOUR(LAST_UPDATED) AS hour, 
    AVG(CURRENT_SPEED) AS avg_speed
FROM TrafficData
GROUP BY REGION, hour
ORDER BY REGION, hour;

	    -- Congestion Prediction
SELECT 
    REGION, 
    HOUR(LAST_UPDATED) AS hour, 
    AVG(CURRENT_SPEED) AS avg_speed,
    CASE
        WHEN AVG(CURRENT_SPEED) < 30 THEN 'High Congestion'
        WHEN AVG(CURRENT_SPEED) BETWEEN 30 AND 45 THEN 'Moderate Congestion'
        ELSE 'Low Congestion'
    END AS congestion_level
FROM TrafficData
GROUP BY REGION, hour
ORDER BY hour;

           -- Comparing with real time data
SELECT 
    REGION, 
    HOUR(LAST_UPDATED) AS hour, 
    CURRENT_SPEED, 
    AVG(CURRENT_SPEED) OVER (PARTITION BY REGION, HOUR(LAST_UPDATED)) AS historical_avg_speed,
    CASE
        WHEN CURRENT_SPEED < (AVG(CURRENT_SPEED) OVER (PARTITION BY REGION, HOUR(LAST_UPDATED)) - 5) THEN 'Congestion Likely'
        ELSE 'Normal Traffic'
    END AS congestion_prediction
FROM TrafficData
WHERE CURRENT_SPEED > 0 
AND LAST_UPDATED > NOW() - INTERVAL 1 DAY;


