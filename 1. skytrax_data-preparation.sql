/* ##################################################
-----------------------------------------------------
 Review Volume, Verification & Recommendation Overview
-----------------------------------------------------
################################################## */

SELECT
    'Airline' AS review_type,
    COUNT(r.review_id) AS total_reviews,

    COUNT(DISTINCT airline_id) AS airlines_reviewed,
    NULL AS airports_reviewed,
    
    SUM(
        CASE
            WHEN r.verify = 1 THEN 1
            ELSE 0
        END
    ) AS verified_reviews,

    SUM(
        CASE
            WHEN r.verify <> 1 OR r.verify IS NULL THEN 1
            ELSE 0
        END
    ) AS not_verified_reviews,

    MIN(r.date_submitted) AS earliest_date_submitted,
    MIN(r.date_flown) AS earliest_flight_visit,
    MAX(r.date_flown) AS latest_flight_visit,

    CAST(
        ROUND(
           100.0 * SUM(CASE WHEN recommended = 1 THEN 1 ELSE 0 END)
           / NULLIF(COUNT(recommended), 0), 
           2) AS DECIMAL(10,2)
        ) AS recommended_rate_pct

FROM skytrax.airline_reviews AS r

UNION ALL

SELECT
    'Airport' AS review_type,
    COUNT(r.review_id) AS total_reviews,

    NULL AS airlines_reviewed,
    COUNT(DISTINCT airport_id) AS airports_reviewed,
    
    SUM(
        CASE
            WHEN r.verify = 1 THEN 1
            ELSE 0
        END
    ) AS verified_reviews,

    SUM(
        CASE
            WHEN r.verify <> 1 OR r.verify IS NULL THEN 1
            ELSE 0
        END
    ) AS not_verified_reviews,

    MIN(r.date_submitted) AS earliest_date_submitted,
    MIN(r.date_visit) AS earliest_flight_visit,
    MAX(r.date_visit) AS latest_flight_visit,

    CAST(
        ROUND(
           100.0 * SUM(CASE WHEN recommended = 1 THEN 1 ELSE 0 END)
           / NULLIF(COUNT(recommended), 0), 
           2) AS DECIMAL(10,2)
        ) AS recommended_rate_pct

FROM skytrax.airport_reviews AS r

UNION ALL

SELECT
    'Lounge' AS review_type,
    COUNT(r.review_id) AS total_reviews,

    COUNT(DISTINCT airline_id) AS airlines_reviewed,
    NULL AS airports_reviewed,

    SUM(
        CASE
            WHEN r.verify = 1 THEN 1 ELSE 0
        END
    ) AS verified_reviews,

    SUM(
        CASE
            WHEN r.verify <> 1 OR r.verify IS NULL THEN 1
            ELSE 0
        END
    ) AS not_verified_reviews,

    MIN(r.date_submitted) AS earliest_date_submitted,
    MIN(r.date_visit) AS earliest_flight_visit,
    MAX(r.date_visit) AS latest_flight_visit,

    CAST(
        ROUND(
           100.0 * SUM(CASE WHEN recommended = 1 THEN 1 ELSE 0 END)
           / NULLIF(COUNT(recommended), 0), 
           2) AS DECIMAL(10,2)
        ) AS recommended_rate_pct

FROM skytrax.lounge_reviews AS r

UNION ALL

SELECT
    'Seat' AS review_type,
    COUNT(r.review_id) AS total_reviews,

    COUNT(DISTINCT airline_id) AS airlines_reviewed,
    NULL AS airports_reviewed,

    SUM(
        CASE
            WHEN r.verify = 1 THEN 1
            ELSE 0
        END
    ) AS verified_reviews,

    SUM(
        CASE
            WHEN r.verify <> 1 OR r.verify IS NULL THEN 1
            ELSE 0
        END
    ) AS not_verified_reviews,

    MIN(r.date_submitted) AS earliest_date_submitted,
    MIN(r.date_flown) AS earliest_flight_visit,
    MAX(r.date_flown) AS latest_flight_visit,

    CAST(
        ROUND(
           100.0 * SUM(CASE WHEN recommended = 1 THEN 1 ELSE 0 END)
           / NULLIF(COUNT(recommended), 0), 
           2) AS DECIMAL(10,2)
        ) AS recommended_rate_pct

FROM skytrax.seat_reviews AS r;

/* ==================================
   ----- PIVOT ----- 
   ================================== */

WITH review_summary AS (

    SELECT
        'Airline' AS review_type,
        COUNT(r.review_id) AS total_reviews,

        COUNT(DISTINCT r.airline_id) AS airlines_reviewed,
        NULL AS airports_reviewed,

        CAST(
            SUM(
                CASE 
                    WHEN r.verify = 1 THEN 1 
                    ELSE 0 
                END) * 100.0 / COUNT(*)
            AS DECIMAL(5,2)
        ) AS verified_pct,

        CAST(
            SUM(
                CASE
                    WHEN r.verify <> 1 OR r.verify IS NULL THEN 1
                    ELSE 0
                END
            ) * 100.0 / COUNT(*)
            AS DECIMAL(5,2)
        ) AS not_verified_pct,

        MIN(r.date_submitted) AS earliest_date_submitted,
        MIN(r.date_flown) AS earliest_flight_visit,
        MAX(r.date_flown) AS latest_flight_visit,

        CAST(
            ROUND(
               100.0 * SUM(CASE WHEN recommended = 1 THEN 1 ELSE 0 END)
               / NULLIF(COUNT(recommended), 0), 
               2) AS DECIMAL(10,2)
            ) AS recommended_rate_pct

    FROM skytrax.airline_reviews AS r

    UNION ALL

    SELECT
        'Airport' AS review_type,
        COUNT(r.review_id) AS total_reviews,

        NULL AS airlines_reviewed,
        COUNT(DISTINCT r.airport_id) AS airports_reviewed,

        CAST(
            SUM(
                CASE 
                    WHEN r.verify = 1 THEN 1 
                    ELSE 0 
                END) * 100.0 / COUNT(*)
            AS DECIMAL(5,2)
        ) AS verified_pct,

        CAST(
            SUM(
                CASE
                    WHEN r.verify <> 1 OR r.verify IS NULL THEN 1
                    ELSE 0
                END
            ) * 100.0 / COUNT(*)
            AS DECIMAL(5,2)
        ) AS not_verified_pct,

        MIN(r.date_submitted) AS earliest_date_submitted,
        MIN(r.date_visit) AS earliest_flight_visit,
        MAX(r.date_visit) AS latest_flight_visit,

        CAST(
            ROUND(
               100.0 * SUM(CASE WHEN recommended = 1 THEN 1 ELSE 0 END)
               / NULLIF(COUNT(recommended), 0), 
               2) AS DECIMAL(10,2)
            ) AS recommended_rate_pct

    FROM skytrax.airport_reviews AS r

    UNION ALL

    SELECT
        'Lounge' AS review_type,
        COUNT(r.review_id) AS total_reviews,

        COUNT(DISTINCT r.airline_id) AS airlines_reviewed,
        NULL AS airports_reviewed,

        CAST(
            SUM(
                CASE 
                    WHEN r.verify = 1 THEN 1 
                    ELSE 0 
                END) * 100.0 / COUNT(*)
            AS DECIMAL(5,2)
        ) AS verified_pct,

        CAST(
            SUM(
                CASE
                    WHEN r.verify <> 1 OR r.verify IS NULL THEN 1
                    ELSE 0
                END
            ) * 100.0 / COUNT(*)
            AS DECIMAL(5,2)
        ) AS not_verified_pct,

        MIN(r.date_submitted) AS earliest_date_submitted,
        MIN(r.date_visit) AS earliest_flight_visit,
        MAX(r.date_visit) AS latest_flight_visit,

        CAST(
            ROUND(
               100.0 * SUM(CASE WHEN recommended = 1 THEN 1 ELSE 0 END)
               / NULLIF(COUNT(recommended), 0), 
               2) AS DECIMAL(10,2)
            ) AS recommended_rate_pct

    FROM skytrax.lounge_reviews AS r

    UNION ALL

    SELECT
        'Seat' AS review_type,
        COUNT(r.review_id) AS total_reviews,

        COUNT(DISTINCT r.airline_id) AS airlines_reviewed,
        NULL AS airports_reviewed,

        CAST(
            SUM(
                CASE 
                    WHEN r.verify = 1 THEN 1 
                    ELSE 0 
                END) * 100.0 / COUNT(*)
            AS DECIMAL(5,2)
        ) AS verified_pct,

        CAST(
            SUM(
                CASE
                    WHEN r.verify <> 1 OR r.verify IS NULL THEN 1
                    ELSE 0
                END
            ) * 100.0 / COUNT(*)
            AS DECIMAL(5,2)
        ) AS not_verified_pct,

        MIN(r.date_submitted) AS earliest_date_submitted,
        MIN(r.date_flown) AS earliest_flight_visit,
        MAX(r.date_flown) AS latest_flight_visit,

        CAST(
            ROUND(
               100.0 * SUM(CASE WHEN recommended = 1 THEN 1 ELSE 0 END)
               / NULLIF(COUNT(recommended), 0), 
               2) AS DECIMAL(10,2)
            ) AS recommended_rate_pct

    FROM skytrax.seat_reviews AS r
)

SELECT
    metric,

    MAX(CASE WHEN review_type = 'Airline' THEN value END) AS airline,
    MAX(CASE WHEN review_type = 'Airport' THEN value END) AS airport,
    MAX(CASE WHEN review_type = 'Lounge' THEN value END) AS lounge,
    MAX(CASE WHEN review_type = 'Seat' THEN value END) AS seat

FROM (

    SELECT review_type, 'Total Reviews' AS metric,
           CAST(total_reviews AS VARCHAR) AS value
    FROM review_summary

    UNION ALL

    SELECT review_type, 'Airlines Reviewed',
           CAST(airlines_reviewed AS VARCHAR)
    FROM review_summary

    UNION ALL

    SELECT review_type, 'Airports Reviewed',
           CAST(airports_reviewed AS VARCHAR)
    FROM review_summary

    UNION ALL

    SELECT review_type, 'Verified Reviews %',
           CAST(verified_pct AS VARCHAR)
    FROM review_summary

    UNION ALL

    SELECT review_type, 'Not Verified Reviews %',
           CAST(not_verified_pct AS VARCHAR)
    FROM review_summary

    UNION ALL

    SELECT review_type, 'Earliest Date Submitted',
           CAST(earliest_date_submitted AS VARCHAR)
    FROM review_summary

    UNION ALL

    SELECT review_type, 'Earliest Flight/Visit',
           CAST(earliest_flight_visit AS VARCHAR)
    FROM review_summary

    UNION ALL

    SELECT review_type, 'Latest Flight/Visit',
           CAST(latest_flight_visit AS VARCHAR)
    FROM review_summary

    UNION ALL

    SELECT review_type, 'Recommended Rate',
           CAST(recommended_rate_pct AS VARCHAR)
    FROM review_summary

) AS unpivoted

GROUP BY metric

ORDER BY
    CASE metric
        WHEN 'Total Reviews' THEN 1
        WHEN 'Airlines Reviewed' THEN 2
        WHEN 'Airports Reviewed' THEN 3
        WHEN 'Verified Reviews %' THEN 4
        WHEN 'Not Verified Reviews %' THEN 5
        WHEN 'Earliest Date Submitted' THEN 6
        WHEN 'Earliest Flight/Visit' THEN 7
        WHEN 'Latest Flight/Visit' THEN 8
        WHEN 'Recommended Rate' THEN 9
    END;

/* #########################################
--------------------------------------------
AIRLINE CUSTOMER EXPERIENCE ANALYSIS
--------------------------------------------
######################################### */

SELECT    
    a.airline_name,

    CONCAT(
        COALESCE(ar.origin_city, 'N/A'),
        ' -> ',
        COALESCE(ar.destination_city, 'N/A')
    ) AS route,    
    
    CASE
        WHEN transit_city is null THEN 'Direct'
        ELSE 'Transit'
    END AS flight_type,
     
    ar.aircraft,
    ar.seat_type,
    ar.type_of_traveller,

    COUNT(*) AS total_reviews,

        SUM(
            CASE
                WHEN verify = 1 THEN 1
                ELSE 0
            END
        ) AS verified_reviews,

        SUM(
            CASE
                WHEN verify <> 1 OR verify IS NULL THEN 1
                ELSE 0
            END
        ) AS not_verified_reviews,

    CAST(
        SUM(CASE WHEN ar.recommended = 1 THEN 1 ELSE 0 END)
        * 100.0
        / COUNT(*)
        AS DECIMAL(5,2)
    ) AS rcm_rate,

    CAST(
        ROUND(
            AVG(CAST(ar.seat_comfort AS DECIMAL(10,2))),
            2
        ) AS DECIMAL(10,2)
    ) AS avg_seat,

    CAST(
        ROUND(
            AVG(CAST(ar.cabin_staff_service AS DECIMAL(10,2))),
            2
        ) AS DECIMAL(10,2)
    ) AS avg_cabin_staff,

    CAST(
        ROUND(
            AVG(CAST(ar.food_and_beverages AS DECIMAL(10,2))),
            2
        ) AS DECIMAL(10,2)
    ) AS avg_food,

    CAST(
        ROUND(
            AVG(CAST(ar.inflight_entertainment AS DECIMAL(10,2))),
            2
        ) AS DECIMAL(10,2)
    ) AS avg_entertainment,

    CAST(
        ROUND(
            AVG(CAST(ar.ground_service AS DECIMAL(10,2))),
            2
        ) AS DECIMAL(10,2)
    ) AS avg_ground,

    CAST(
        ROUND(
            AVG(CAST(ar.wifi_and_connectivity AS DECIMAL(10,2))),
            2
        ) AS DECIMAL(10,2)
    ) AS avg_wifi

FROM skytrax.airline_reviews ar
INNER JOIN skytrax.airlines a 
    ON a.airline_id = ar.airline_id

GROUP BY 
    a.airline_name,

    CONCAT(
            COALESCE(ar.origin_city, 'N/A'),
            ' -> ',
            COALESCE(ar.destination_city, 'N/A')
    ),

    CASE
        WHEN transit_city is null THEN 'Direct'
        ELSE 'Transit'
    END,

    ar.aircraft,
    ar.seat_type,
    ar.type_of_traveller

HAVING COUNT(*) >= 10
ORDER BY a.airline_name, total_reviews;

/* #########################################
--------------------------------------------
AIRPORT CUSTOMER EXPERIENCE ANALYSIS
--------------------------------------------
######################################### */

SELECT 
    a.airport_name,
    pr.nationality,
    pr.experience_at_airport,
    pr.type_of_traveller,

    COUNT(*) AS total_reviews,

        SUM(
            CASE
                WHEN verify = 1 THEN 1
                ELSE 0
            END
        ) AS verified_reviews,

        SUM(
            CASE
                WHEN verify <> 1 OR verify IS NULL THEN 1
                ELSE 0
            END
        ) AS not_verified_reviews,

    CAST(
        SUM(CASE WHEN pr.recommended = 1 THEN 1 ELSE 0 END)
        * 100.0
        / COUNT(*)
        AS DECIMAL(5,2)
    ) AS rcm_rate,

    CAST(
        ROUND(
            AVG(CAST(pr.queuing_times AS DECIMAL(10,2))),
            2
        ) AS DECIMAL(10,2)
    ) AS avg_queuing_times,

    CAST(
        ROUND(
            AVG(CAST(pr.terminal_cleanliness AS DECIMAL(10,2))),
            2
        ) AS DECIMAL(10,2)
    ) AS avg_terminal_cleanliness,

    CAST(
        ROUND(
            AVG(CAST(pr.terminal_seating AS DECIMAL(10,2))),
            2
        ) AS DECIMAL(10,2)
    ) AS avg_terminal_seating,

    CAST(
        ROUND(
            AVG(CAST(pr.terminal_signs AS DECIMAL(10,2))),
            2
        ) AS DECIMAL(10,2)
    ) AS avg_terminal_signs,

    CAST(
        ROUND(
            AVG(CAST(pr.food_beverages AS DECIMAL(10,2))),
            2
        ) AS DECIMAL(10,2)
    ) AS avg_food_beverages,

    CAST(
        ROUND(
            AVG(CAST(pr.airport_shopping AS DECIMAL(10,2))),
            2
        ) AS DECIMAL(10,2)
    ) AS avg_airport_shopping,

    CAST(
        ROUND(
            AVG(CAST(pr.airport_staff AS DECIMAL(10,2))),
            2
        ) AS DECIMAL(10,2)
    ) AS avg_airport_staff,

    CAST(
        ROUND(
            AVG(CAST(pr.wifi_connectivity AS DECIMAL(10,2))),
            2
        ) AS DECIMAL(10,2)
    ) AS avg_wifi_connectivity

FROM skytrax.airport_reviews pr
INNER JOIN skytrax.airports a 
    ON a.airport_id = pr.airport_id

GROUP BY 
    a.airport_name, 
    pr.nationality,
    pr.experience_at_airport,
    pr.type_of_traveller

HAVING COUNT(*) >= 10
ORDER BY a.airport_name;

/* #########################################
--------------------------------------------
LOUNGE CUSTOMER EXPERIENCE ANALYSIS
--------------------------------------------
######################################### */

/* Lounge names were standardized to consolidate obvious naming variations, while the original 
raw values were retained. Invalid or non-lounge values were excluded from lounge-level analysis. */

SELECT 
    a.airline_name,
    lr.airport,
    lr.lounge_name,
    lr.type_of_lounge,
    lr.type_of_traveller,
    lr.nationality,

    COUNT(*) AS total_reviews,

        SUM(
            CASE
                WHEN verify = 1 THEN 1
                ELSE 0
            END
        ) AS verified_reviews,

        SUM(
            CASE
                WHEN verify <> 1 OR verify IS NULL THEN 1
                ELSE 0
            END
        ) AS not_verified_reviews,

    CAST(
        SUM(CASE WHEN lr.recommended = 1 THEN 1 ELSE 0 END)
        * 100.0
        / COUNT(*)
        AS DECIMAL(5,2)
    ) AS rcm_rate,

    CAST(
        ROUND(
            AVG(CAST(lr.comfort AS DECIMAL(10,2))),
            2
        ) AS DECIMAL(10,2)
    ) AS avg_comfort,

    CAST(
        ROUND(
            AVG(CAST(lr.cleanliness AS DECIMAL(10,2))),
            2
        ) AS DECIMAL(10,2)
    ) AS avg_cleanliness,

    CAST(
        ROUND(
            AVG(CAST(lr.bar_and_beverages AS DECIMAL(10,2))),
            2
        ) AS DECIMAL(10,2)
    ) AS avg_bar_and_beverages,

    CAST(
        ROUND(
            AVG(CAST(lr.catering AS DECIMAL(10,2))),
            2
        ) AS DECIMAL(10,2)
    ) AS avg_catering,

    CAST(
        ROUND(
            AVG(CAST(lr.washrooms AS DECIMAL(10,2))),
            2
        ) AS DECIMAL(10,2)
    ) AS avg_washrooms,

    CAST(
        ROUND(
            AVG(CAST(lr.wifi_connectivity AS DECIMAL(10,2))),
            2
        ) AS DECIMAL(10,2)
    ) AS avg_wifi,

    CAST(
        ROUND(
            AVG(CAST(lr.staff_service AS DECIMAL(10,2))),
            2
        ) AS DECIMAL(10,2)
    ) AS avg_staff_service

FROM skytrax.lounge_reviews lr
INNER JOIN skytrax.airlines a 
    ON a.airline_id = lr.airline_id

GROUP BY 
    a.airline_name,
    lr.airport,
    lr.lounge_name,
    lr.type_of_lounge,
    lr.type_of_traveller,
    lr.nationality

HAVING COUNT(*) >= 10
ORDER BY a.airline_name;

/* #########################################
--------------------------------------------
SEAT CUSTOMER EXPERIENCE ANALYSIS
--------------------------------------------
######################################### */

SELECT 
    a.airline_name,
    s.aircraft_type,
    s.seat_layout,  
    s.type_of_traveller,      
    s.nationality,

    COUNT(*) AS total_reviews,

        SUM(
            CASE
                WHEN verify = 1 THEN 1
                ELSE 0
            END
        ) AS verified_reviews,

        SUM(
            CASE
                WHEN verify <> 1 OR verify IS NULL THEN 1
                ELSE 0
            END
        ) AS not_verified_reviews,

    CAST(
        SUM(CASE WHEN s.recommended = 1 THEN 1 ELSE 0 END)
        * 100.0
        / COUNT(*)
        AS DECIMAL(5,2)
    ) AS rcm_rate,

    CAST(
        ROUND(
            AVG(CAST(s.seat_legroom AS DECIMAL(10,2))),
            2
        ) AS DECIMAL(10,2)
    ) AS avg_seat_legroom,

    CAST(
        ROUND(
            AVG(CAST(s.seat_recline AS DECIMAL(10,2))),
            2
        ) AS DECIMAL(10,2)
    ) AS avg_seat_recline,

    CAST(
        ROUND(
            AVG(CAST(s.seat_width AS DECIMAL(10,2))),
            2
        ) AS DECIMAL(10,2)
    ) AS avg_seat_width,

    CAST(
        ROUND(
            AVG(CAST(s.aisle_space AS DECIMAL(10,2))),
            2
        ) AS DECIMAL(10,2)
    ) AS avg_aisle_space,

    CAST(
        ROUND(
            AVG(CAST(s.seat_storage AS DECIMAL(10,2))),
            2
        ) AS DECIMAL(10,2)
    ) AS avg_seat_storage,

    CAST(
        ROUND(
            AVG(CAST(s.power_supply AS DECIMAL(10,2))),
            2
        ) AS DECIMAL(10,2)
    ) AS avg_power_supply,

    CAST(
        ROUND(
            AVG(CAST(s.viewing_tv_screen AS DECIMAL(10,2))),
            2
        ) AS DECIMAL(10,2)
    ) AS avg_viewing_tv_screen,

    CAST(
        ROUND(
            AVG(CAST(s.sleep_comfort AS DECIMAL(10,2))),
            2
        ) AS DECIMAL(10,2)
    ) AS avg_sleep_comfort,

    CAST(
        ROUND(
            AVG(CAST(s.sitting_comfort AS DECIMAL(10,2))),
            2
        ) AS DECIMAL(10,2)
    ) AS avg_sitting_comfort,

    CAST(
        ROUND(
            AVG(CAST(s.seat_bed_width AS DECIMAL(10,2))),
            2
        ) AS DECIMAL(10,2)
    ) AS avg_seat_bed_width,

    CAST(
        ROUND(
            AVG(CAST(s.seat_bed_length AS DECIMAL(10,2))),
            2
        ) AS DECIMAL(10,2)
    ) AS avg_seat_bed_length,

    CAST(
        ROUND(
            AVG(CAST(s.seat_privacy AS DECIMAL(10,2))),
            2
        ) AS DECIMAL(10,2)
    ) AS avg_seat_privacy

FROM skytrax.seat_reviews s
INNER JOIN skytrax.airlines a 
    ON a.airline_id = s.airline_id

GROUP BY 
    a.airline_name,
    s.aircraft_type,
    s.seat_layout,  
    s.type_of_traveller,      
    s.nationality

HAVING COUNT(*) >= 10
ORDER BY a.airline_name;

/* #########################################
--------------------------------------------

--------------------------------------------
######################################### */









