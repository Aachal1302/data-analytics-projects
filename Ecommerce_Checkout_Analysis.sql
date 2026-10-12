-- Create the sessions table
CREATE TABLE sessions (
    session_id VARCHAR(20) PRIMARY KEY,
    customer_id VARCHAR(20),
    session_date DATE,
    device_type VARCHAR(20),
    customer_type VARCHAR(20),
    location VARCHAR(50),
    traffic_channel VARCHAR(30),
    campaign_type VARCHAR(30)
);

SELECT * FROM sessions
LIMIT 5;

-- Check the total number of rows in the sessions table
SELECT COUNT(*) AS total_rows
FROM sessions;





-- Create the checkout funnel table
CREATE TABLE checkout_funnel (
    session_id VARCHAR(20) PRIMARY KEY,
    visited_website INT,
    viewed_product INT,
    added_to_cart INT,
    checkout_started INT,
    purchase_completed INT,
    direct_purchase INT
);


SELECT * FROM checkout_funnel
LIMIT 5;

-- Check the total number of rows in the checkout funnel table
SELECT COUNT(*) AS total_rows
FROM checkout_funnel;





-- Create the pricing and order details table
CREATE TABLE pricing_order_details (
    order_id VARCHAR(20) PRIMARY KEY,
    customer_id VARCHAR(20),
    product_id VARCHAR(20),
    product_category VARCHAR(30),
    price DECIMAL(10,2),
    quantity INT,
    discount DECIMAL(5,2),
    shipping_cost DECIMAL(10,2),
    payment_method VARCHAR(30),
    order_status VARCHAR(20),
    order_date DATE,
    shipping_days INT,
    revenue DECIMAL(12,2)
);

SELECT * FROM pricing_order_details
LIMIT 5

-- Check the total number of rows in the pricing_order_details table
SELECT COUNT(*) AS total_rows
FROM pricing_order_details;


-- Check that every checkout session has a matching session record
SELECT COUNT(*) AS unmatched_sessions
FROM checkout_funnel f
LEFT JOIN sessions s
    ON f.session_id = s.session_id
WHERE s.session_id IS NULL;





--Business Question 1 — Checkout Funnel

-- Sub-question 1: Count sessions that reached each funnel stage
SELECT
    SUM(visited_website) AS website_visits,
    SUM(viewed_product) AS product_views,
    SUM(added_to_cart) AS added_to_cart,
    SUM(direct_purchase) AS direct_purchases,
    SUM(checkout_started) AS checkout_started,
    SUM(purchase_completed) AS purchases
FROM checkout_funnel;


-- Sub-question 2: Which stage has the highest drop-off rate?
SELECT
    -- Website → Product
    SUM(visited_website) - SUM(viewed_product) AS website_to_product_drop,
    ROUND(
        (SUM(visited_website) - SUM(viewed_product)) * 100.0
        / SUM(visited_website), 2
    ) AS website_to_product_drop_rate,

    -- Product → Action (Cart OR Direct Purchase)
    SUM(viewed_product)
        - SUM(added_to_cart)
        - SUM(direct_purchase) AS product_stage_drop,
    ROUND(
        (
            SUM(viewed_product)
            - SUM(added_to_cart)
            - SUM(direct_purchase)
        ) * 100.0
        / SUM(viewed_product), 2
    ) AS product_stage_drop_rate,

    -- Cart → Checkout
    SUM(added_to_cart) - SUM(checkout_started) AS cart_to_checkout_drop,
    ROUND(
        (SUM(added_to_cart) - SUM(checkout_started)) * 100.0
        / SUM(added_to_cart), 2
    ) AS cart_to_checkout_drop_rate,

    -- Checkout → Purchase
    SUM(checkout_started) - SUM(purchase_completed) AS checkout_to_purchase_drop,
    ROUND(
        (SUM(checkout_started) - SUM(purchase_completed)) * 100.0
        / SUM(checkout_started), 2
    ) AS checkout_to_purchase_drop_rate

FROM checkout_funnel;





-- Business Problem 2 — Pricing / Shipping Cost

-- Sub-question 1: Calculate the average shipping cost
SELECT
    ROUND(AVG(shipping_cost), 2) AS average_shipping_cost
FROM pricing_order_details;


-- Sub-question 2: Compare average shipping cost by order status
SELECT
    order_status,
    COUNT(*) AS total_orders,
    ROUND(AVG(shipping_cost), 2) AS average_shipping_cost
FROM pricing_order_details
GROUP BY order_status
ORDER BY average_shipping_cost DESC;


-- Sub-question 3: Compare order status across shipping cost groups
SELECT
    CASE
        WHEN shipping_cost < 125 THEN 'Lower Shipping Cost'
        ELSE 'Higher Shipping Cost'
    END AS shipping_cost_group,
    order_status,
    COUNT(*) AS total_orders
FROM pricing_order_details
GROUP BY shipping_cost_group, order_status
ORDER BY shipping_cost_group, total_orders DESC;



--Business Problem 3 — Payment Method & Order Outcomes

-- Sub-question 1: Count orders by payment method
SELECT
    payment_method,
    COUNT(*) AS total_orders
FROM pricing_order_details
GROUP BY payment_method
ORDER BY total_orders DESC;


-- Sub-question 2: Compare order status by payment method
SELECT
    payment_method,
    order_status,
    COUNT(*) AS total_orders
FROM pricing_order_details
GROUP BY payment_method, order_status
ORDER BY payment_method, total_orders DESC;


-- Sub-question 3: Calculate cancellation and return rates by payment method
SELECT
    payment_method,
    COUNT(*) AS total_orders,
    ROUND(
        SUM(CASE WHEN order_status = 'Cancelled' THEN 1 ELSE 0 END) * 100.0
        / COUNT(*), 2
    ) AS cancellation_rate,
    ROUND(
        SUM(CASE WHEN order_status = 'Returned' THEN 1 ELSE 0 END) * 100.0
        / COUNT(*), 2
    ) AS return_rate
FROM pricing_order_details
GROUP BY payment_method
ORDER BY cancellation_rate DESC;




--Business Problem 4 — Device Type & Checkout Behavior.

-- Sub-question 1: Count sessions by device type
SELECT
    device_type,
    COUNT(*) AS total_sessions
FROM sessions
GROUP BY device_type
ORDER BY total_sessions DESC;


-- Sub-question 2: Calculate purchase conversion rate by device
SELECT
    s.device_type,
    COUNT(*) AS total_sessions,
    SUM(f.purchase_completed) AS purchases,
    ROUND(
        SUM(f.purchase_completed) * 100.0 / COUNT(*), 2
    ) AS purchase_conversion_rate
FROM sessions s
JOIN checkout_funnel f
    ON s.session_id = f.session_id
GROUP BY s.device_type
ORDER BY purchase_conversion_rate DESC;


-- Sub-question 3: Compare checkout funnel stages by device type
SELECT
    s.device_type,
    SUM(f.added_to_cart) AS added_to_cart,
    SUM(f.checkout_started) AS checkout_started,
    SUM(f.purchase_completed) AS purchases
FROM sessions s
JOIN checkout_funnel f
    ON s.session_id = f.session_id
GROUP BY s.device_type
ORDER BY s.device_type;


-- Sub-question 4: Calculate checkout drop-off rates by device type
SELECT
    s.device_type,
    SUM(f.added_to_cart) AS added_to_cart,
    SUM(f.checkout_started) AS checkout_started,
    SUM(f.purchase_completed) AS purchases,

    ROUND(
        (SUM(f.added_to_cart) - SUM(f.checkout_started)) * 100.0
        / NULLIF(SUM(f.added_to_cart), 0), 2
    ) AS cart_to_checkout_drop_rate,

    ROUND(
        (SUM(f.checkout_started) - SUM(f.purchase_completed)) * 100.0
        / NULLIF(SUM(f.checkout_started), 0), 2
    ) AS checkout_to_purchase_drop_rate

FROM sessions s
JOIN checkout_funnel f
    ON s.session_id = f.session_id
GROUP BY s.device_type
ORDER BY s.device_type;


-- Sub-question 5 : Compare purchase conversion between new and returning customers
SELECT
    s.customer_type,
    COUNT(*) AS total_sessions,
    SUM(f.purchase_completed) AS purchases,
    ROUND(
        SUM(f.purchase_completed) * 100.0 / COUNT(*), 2
    ) AS purchase_conversion_rate
FROM sessions s
JOIN checkout_funnel f
    ON s.session_id = f.session_id
GROUP BY s.customer_type
ORDER BY purchase_conversion_rate DESC;



--Business Problem 5 — Customer Type & Purchase Behavior

-- Sub-question 1:Compare checkout funnel stages between new and returning customers
SELECT
    s.customer_type,
    COUNT(*) AS total_sessions,
    SUM(f.added_to_cart) AS added_to_cart,
    SUM(f.checkout_started) AS checkout_started,
    SUM(f.purchase_completed) AS purchases
FROM sessions s
JOIN checkout_funnel f
    ON s.session_id = f.session_id
GROUP BY s.customer_type
ORDER BY s.customer_type;


-- Sub-question 2: Compare checkout drop-off rates between new and returning customers
SELECT
    s.customer_type,

    ROUND(
        (SUM(f.added_to_cart) - SUM(f.checkout_started)) * 100.0
        / NULLIF(SUM(f.added_to_cart), 0), 2
    ) AS cart_to_checkout_drop_rate,

    ROUND(
        (SUM(f.checkout_started) - SUM(f.purchase_completed)) * 100.0
        / NULLIF(SUM(f.checkout_started), 0), 2
    ) AS checkout_to_purchase_drop_rate

FROM sessions s
JOIN checkout_funnel f
    ON s.session_id = f.session_id
GROUP BY s.customer_type
ORDER BY s.customer_type;


--Sub-question 3:  Compare purchase conversion between new and returning customers
SELECT
    s.customer_type,
    COUNT(*) AS total_sessions,
    SUM(f.purchase_completed) AS purchases,
    ROUND(
        SUM(f.purchase_completed) * 100.0 / COUNT(*), 2
    ) AS purchase_conversion_rate
FROM sessions s
JOIN checkout_funnel f
    ON s.session_id = f.session_id
GROUP BY s.customer_type
ORDER BY purchase_conversion_rate DESC;


--Sub-question 4:  Compare customer types across different devices
SELECT
    s.customer_type,
    s.device_type,
    COUNT(*) AS total_sessions,
    SUM(f.purchase_completed) AS purchases,
    ROUND(
        SUM(f.purchase_completed) * 100.0 / COUNT(*), 2
    ) AS purchase_conversion_rate
FROM sessions s
JOIN checkout_funnel f
    ON s.session_id = f.session_id
GROUP BY s.customer_type, s.device_type
ORDER BY s.customer_type, s.device_type;




--Business Problem 6 — Location & Traffic Channel Performance

-- Sub-question 1:  Compare customer sessions and purchases by location
SELECT
    s.location,
    COUNT(*) AS total_sessions,
    SUM(f.purchase_completed) AS purchases
FROM sessions s
JOIN checkout_funnel f
    ON s.session_id = f.session_id
GROUP BY s.location
ORDER BY total_sessions DESC;


-- Sub-question 2: Which locations have the highest purchase conversion rate?
SELECT
    s.location,
    COUNT(*) AS total_sessions,
    SUM(f.purchase_completed) AS purchases,
    ROUND(
        SUM(f.purchase_completed) * 100.0 / COUNT(*), 2
    ) AS purchase_conversion_rate
FROM sessions s
JOIN checkout_funnel f
    ON s.session_id = f.session_id
GROUP BY s.location
ORDER BY purchase_conversion_rate DESC;


-- Sub-question 3: Compare traffic channels by sessions and purchases
SELECT
    s.traffic_channel,
    COUNT(*) AS total_sessions,
    SUM(f.purchase_completed) AS purchases
FROM sessions s
JOIN checkout_funnel f
    ON s.session_id = f.session_id
GROUP BY s.traffic_channel
ORDER BY total_sessions DESC;


-- Sub-question 4: Which traffic channels have the highest purchase conversion rate?
SELECT
    s.traffic_channel,
    COUNT(*) AS total_sessions,
    SUM(f.purchase_completed) AS purchases,
    ROUND(
        SUM(f.purchase_completed) * 100.0 / COUNT(*), 2
    ) AS purchase_conversion_rate
FROM sessions s
JOIN checkout_funnel f
    ON s.session_id = f.session_id
GROUP BY s.traffic_channel
ORDER BY purchase_conversion_rate DESC;