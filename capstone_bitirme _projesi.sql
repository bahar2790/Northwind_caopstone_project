ALTER TABLE orders ADD CONSTRAINT fk_customer 
FOREIGN KEY (customer_id)
REFERENCES customers(customer_id);

ALTER TABLE products
ADD CONSTRAINT FK_Products_Categories
FOREIGN KEY (category_id) REFERENCES categories(category_id);



ALTER TABLE territories ADD CONSTRAINT fk_region 
FOREIGN KEY (region_id)
REFERENCES region(region_id);

ALTER TABLE employeeterritories ADD CONSTRAINT fk_region 
FOREIGN KEY (territory_id)
REFERENCES territories(territory_id);

ALTER TABLE orders ADD CONSTRAINT fk_ship
FOREIGN KEY (ship_via)
REFERENCES shippers(shipper_id);


ALTER TABLE order_details ADD CONSTRAINT fk_product
FOREIGN KEY (product_id)
REFERENCES peoducts(product_id);

ALTER TABLE orders
ADD CONSTRAINT FK_Orders_Employees
FOREIGN KEY (employee_id) REFERENCES employees(employee_id);


ALTER TABLE order_details ADD CONSTRAINT fk_order 
FOREIGN KEY (order_id)
REFERENCES orders(order_id);


ALTER TABLE order_details ADD CONSTRAINT fk_product 
FOREIGN KEY (product_id)
REFERENCES products(product_id);


ALTER TABLE products ADD CONSTRAINT fk_supplier
FOREIGN KEY (supplier_id)
REFERENCES suppliers(supplier_id);

ALTER TABLE customercustomerdemo ADD CONSTRAINT fk_customer
FOREIGN KEY (customer_id)
REFERENCES customers(customer_id);


ALTER TABLE employees ADD CONSTRAINT fk_reports
FOREIGN KEY (reports_to)
REFERENCES customerdemocraphics(customer_type_id);

--Sipariş Analizi
SELECT COUNT(*) AS total_orders
FROM orders;

--Müşteri Bazlı Sipariş Sayısı
SELECT customer_id, COUNT(order_id) AS total_orders_per_customer
FROM orders
GROUP BY customer_id
ORDER BY total_orders_per_customer DESC;

--Tarih Bazlı Sipariş Yoğunluğu
SELECT DATE(order_date) AS order_day, COUNT(order_id) AS total_orders
FROM orders
GROUP BY DATE(order_date)
ORDER BY order_day;

--En Fazla Sipariş Edilen Ürün Kategorisi
SELECT c.category_name, COUNT(od.product_id) AS total_orders
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
JOIN products p ON od.product_id = p.product_id
JOIN categories c ON p.category_id = c.category_id
GROUP BY c.category_name
ORDER BY total_orders DESC
LIMIT 1;

--Müşteri Analizi
--En Çok Sipariş Veren Müşteriler
SELECT customer_id, COUNT(order_id) AS total_orders
FROM orders
GROUP BY customer_id
ORDER BY total_orders DESC
LIMIT 1;

--En Çok Ciro Sağlayan Müşteriler

SELECT o.customer_id, 
       ROUND(SUM(od.unit_price * od.quantity)::numeric, 2) AS total_revenue -- 2 ondalık basamak
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
GROUP BY o.customer_id
ORDER BY total_revenue DESC
LIMIT 10;


--SON 6 AY İÇİNDE SİPARİŞ VERMEYEN MÜŞTERİLER
SELECT 
    c.customer_id AS "CustomerID", 
    TO_CHAR(MAX(o.order_date), 'YYYY-MM') AS "LastOrderDate"
FROM 
    customers c
LEFT JOIN 
    orders o ON c.customer_id = o.customer_id
GROUP BY 
    c.customer_id
HAVING 
    MAX(o.order_date) < '1998-01-01' OR MAX(o.order_date) IS NULL;


-- Müşteri Başına Ortalama Sipariş Tutarı
SELECT o.customer_id, 
       COUNT(o.order_id) AS total_orders, 
       SUM(od.unit_price * od.quantity) / COUNT(o.order_id) AS avg_order_value
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
GROUP BY o.customer_id
ORDER BY avg_order_value DESC
LIMIT 10;

--Müşteri Bazlı Sipariş Sıklığı
SELECT o.customer_id, 
       SUM(od.unit_price * od.quantity) / NULLIF(COUNT(o.order_id), 0) AS avg_order_value
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
GROUP BY o.customer_id
ORDER BY avg_order_value DESC
LIMIT 10;

--Müşteri Bazlı Sipariş Sıklığı
SELECT customer_id, 
       COUNT(order_id) AS total_orders, 
       MAX(order_date) - MIN(order_date) AS customer_lifetime, 
       COUNT(order_id) / NULLIF(MAX(order_date) - MIN(order_date), 0) AS order_frequency
FROM orders
GROUP BY customer_id
ORDER BY total_orders DESC
;

--Toplam Ciro

SELECT ROUND(SUM(od.unit_price * od.quantity)::numeric, 2) AS total_revenue
FROM order_details od;

SELECT 
    c.country AS Country,
    COUNT(o.order_id) AS TotalOrders,
    (SUM(od.unit_price * od.quantity)::numeric, 2) AS TotalRevenue
FROM 
    customers c
LEFT JOIN 
    orders o ON c.customer_id = o.customer_id
LEFT JOIN 
    order_details od ON o.order_id = od.order_id
GROUP BY 
    c.country
ORDER BY 
    TotalOrders DESC;



--Müşteri Bazlı Ciro
SELECT o.customer_id, SUM(od.unit_price * od.quantity) AS customer_revenue
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
GROUP BY o.customer_id
ORDER BY customer_revenue DESC
LIMIT 10;


--TOPLAM İNDİRİM
SELECT TO_CHAR(ROUND(SUM(od.unit_price * od.quantity * od.discount)::numeric, 2), 'FM999,999,999.00') AS total_discount_amount
FROM order_details od;

-- Ürün Bazlı Ciro
SELECT 
    p.product_name, 
    EXTRACT(YEAR FROM o.order_date) AS order_year,
    EXTRACT(MONTH FROM o.order_date) AS order_month,
    ROUND(SUM(od.unit_price * od.quantity)::numeric, 2) AS product_revenue
FROM 
    order_details od
JOIN 
    products p ON od.product_id = p.product_id
JOIN 
    orders o ON od.order_id = o.order_id
GROUP BY 
    p.product_name, order_year, order_month
ORDER BY 
    product_revenue DESC;



--Kategori Bazlı Ciro
SELECT c.category_name, ROUND(SUM(od.unit_price * od.quantity)::numeric, 2) AS category_revenue
FROM order_details od
JOIN products p ON od.product_id = p.product_id
JOIN categories c ON p.category_id = c.category_id
GROUP BY c.category_name
ORDER BY category_revenue DESC
LIMIT 10;

--Zaman Bazlı Ciro (Aylık)
SELECT TO_CHAR(DATE_TRUNC('month', o.order_date), 'YYYY-MM-DD') AS order_month, 
       ROUND(SUM(od.unit_price * od.quantity)::numeric, 2) AS monthly_revenue
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
GROUP BY order_month
ORDER BY order_month;

--lojistik analiz
--Sipariş Teslim Süreleri
SELECT o.order_id, o.customer_id, o.order_date, o.shipped_date, 
       EXTRACT(DAY FROM AGE(o.shipped_date, o.order_date)) AS delivery_time
FROM orders o
WHERE o.shipped_date IS NOT NULL
ORDER BY delivery_time DESC;

--Tedarikçi Performansı
SELECT s.company_name, 
       FLOOR(AVG(o.shipped_date - o.order_date)) AS avg_days,
       ROUND((AVG(o.shipped_date - o.order_date) - FLOOR(AVG(o.shipped_date - o.order_date))) * 24, 2) AS avg_hours
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
JOIN products p ON od.product_id = p.product_id
JOIN suppliers s ON p.supplier_id = s.supplier_id
WHERE o.shipped_date IS NOT NULL
GROUP BY s.company_name
ORDER BY avg_days, avg_hours;

--sadec gün şeklinde 
SELECT s.company_name AS shipper_name,
       o.ship_city AS city,
       FLOOR(AVG(o.shipped_date - o.order_date)) AS avg_delivery_time_days
FROM orders o
JOIN shippers s ON o.ship_via = s.shipper_id
WHERE o.shipped_date IS NOT NULL  -- Sadece gönderilmiş siparişler
GROUP BY s.company_name, o.ship_city
ORDER BY avg_delivery_time_days ASC;


--Bölge Bazlı Sipariş Dağılımı
SELECT o.ship_city, COUNT(o.order_id) AS total_orders
FROM orders o
GROUP BY o.ship_city
ORDER BY total_orders DESC
LIMIT 10;

--Taşıma Maliyetleri
SELECT o.order_id, 
       o.freight, 
       o.ship_city, 
       s.company_name AS shipper_name
FROM orders o
JOIN shippers s ON o.ship_via = s.shipper_id
ORDER BY o.freight desc
limit 10;


--firmaların ortalama teslim süreleri
SELECT s.company_name AS shipper_name, 
       ROUND(AVG(o.shipped_date - o.order_date), 2) AS avg_delivery_time
FROM orders o
JOIN shippers s ON o.ship_via = s.shipper_id
WHERE o.shipped_date IS NOT NULL 
  AND o.order_date IS NOT NULL 
  AND o.shipped_date > o.order_date  -- Negatif farkları hariç tut
GROUP BY s.company_name
HAVING ROUND(AVG(o.shipped_date - o.order_date), 2) > 0  -- Sadece pozitif ortalamalar
ORDER BY avg_delivery_time ASC;

--KARGO FIRMALARININ TOPLAM SİPARİŞ SAYISI

SELECT s.company_name, COUNT(o.order_id) AS total_orders
FROM orders o
JOIN shippers s ON o.ship_via = s.shipper_id
GROUP BY s.company_name
ORDER BY total_orders DESC;

--KARGO FĞRMALARININ ORTALAMA TESLİMAT SÜRESİ VE MALİYETİ
SELECT 
    o.order_id, 
    o.freight, 
    o.ship_city, 
    s.company_name AS shipper_name,
    (o.shipped_date - o.order_date) AS delivery_time -- Tam gün teslimat süresi
FROM 
    orders o
JOIN 
    shippers s ON o.ship_via = s.shipper_id
WHERE 
    o.shipped_date IS NOT NULL 
    AND o.order_date IS NOT NULL 
    AND o.shipped_date > o.order_date  -- Negatif farkları hariç tut
ORDER BY 
    o.freight DESC;
--Ürün analizi
-- En Çok Satan Ürünler
SELECT p.product_name, SUM(od.quantity) AS total_quantity_sold
FROM order_details od
JOIN products p ON od.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_quantity_sold DESC;

--Ürün Bazında Toplam Gelir
SELECT p.product_name, ROUND(SUM(od.unit_price * od.quantity)::numeric, 2) AS total_revenue
FROM order_details od
JOIN products p ON od.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_revenue DESC;


--ÜRÜN İNDRİRİM ORANLARI
SELECT DISTINCT p.product_name, od.discount
FROM order_details od
JOIN products p ON od.product_id = p.product_id
WHERE od.discount > 0;

--Stok Durumu Düşük Ürünler
SELECT product_name, unit_in_stock
FROM products
WHERE unit_in_stock < 10
ORDER BY unit_in_stock ASC;

--Ürünlerin Kategorilere Göre Dağılımı
SELECT c.category_name, COUNT(p.product_id) AS number_of_products
FROM products p
JOIN categories c ON p.category_id = c.category_id
GROUP BY c.category_name
ORDER BY number_of_products DESC;

--5. En Yüksek Fiyatlı Ürünler
SELECT product_name, unit_price
FROM products
ORDER BY unit_price DESC


--ÜRÜN BAŞINA İNDİRİM MİKTARI
SELECT p.product_name, 
       p.unit_price, 
       od.discount,
       ROUND(CAST(p.unit_price * (1 - od.discount) AS numeric), 2) AS discounted_price
FROM products p
LEFT JOIN order_details od ON p.product_id = od.product_id
WHERE od.discount > 0;


--ülkelere göre sipariş analizi


select ship_city, count(order_id) as order_count
from orders
group by ship_city
order by order_count desc;



--Ülkelere Göre Toplam Sipariş Sayısı
select ship_country, count(order_id) as order_count
from orders
group by ship_country
order by order_count desc;



--Ülkelere Göre Sipariş Adedi ve Toplam Satış Tutarı
SELECT c.country, COUNT(o.order_id) AS total_orders, SUM(od.quantity * od.unit_price) AS total_sales
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_details od ON o.order_id = od.order_id
GROUP BY c.country
ORDER BY total_sales DESC;

--Çalışan Başına Sipariş Sayısı
SELECT e.employee_id, e.first_name, e.last_name, COUNT(o.order_id) AS total_orders
FROM employees e
JOIN orders o ON e.employee_id = o.employee_id
GROUP BY e.employee_id, e.first_name, e.last_name
ORDER BY total_orders DESC;
--Çalışan Başına Toplam Satış Tutarı

SELECT e.employee_id, e.first_name, e.last_name, 
       ROUND(SUM(od.quantity * od.unit_price)::numeric, 2) AS total_sales
FROM employees e
JOIN orders o ON e.employee_id = o.employee_id
JOIN order_details od ON o.order_id = od.order_id
GROUP BY e.employee_id, e.first_name, e.last_name
ORDER BY total_sales DESC;


--En Çok Sipariş Alan Çalışanlar
SELECT e.employee_id, e.first_name, e.last_name, COUNT(o.order_id) AS total_orders
FROM employees e
JOIN orders o ON e.employee_id = o.employee_id
GROUP BY e.employee_id, e.first_name, e.last_name
ORDER BY total_orders DESC
LIMIT 5;

--Çalışanların Bölgelere Göre Satış Performansı
SELECT e.employee_id, e.first_name, e.last_name, t.territory_description, SUM(od.quantity * od.unit_price) AS total_sales
FROM employees e
JOIN employeeterritories et ON e.employee_id = et.employee_id
JOIN territories t ON et.territory_id = t.territory_id
JOIN orders o ON e.employee_id = o.employee_id
JOIN order_details od ON o.order_id = od.order_id
GROUP BY e.employee_id, e.first_name, e.last_name, t.territory_description
ORDER BY total_sales DESC;
--ÇALIŞANLARIN ÜLKE SATIŞ DAĞILIMI
select e.employee_id, e.first_name,e.last_name,o.ship_country, ROUND(SUM(od.unit_price * od.quantity)::numeric, 2) as total_sales
from employees e
join orders o on e.employee_id = o.employee_id
join order_details od on o.order_id = od.order_id
group by e.employee_id, e.first_name, e.last_name, o.ship_country
order by total_sales desc;

--En Başarılı Satış Temsilcisi
SELECT e.employee_id, e.first_name, e.last_name,  ROUND(SUM(od.unit_price * od.quantity)::numeric, 2) AS total_sales
FROM employees e
JOIN orders o ON e.employee_id = o.employee_id
JOIN order_details od ON o.order_id = od.order_id
GROUP BY e.employee_id, e.first_name, e.last_name
ORDER BY total_sales DESC
LIMIT 1;
--ÇALIŞAN SATIŞ TUTARI VE ÜLKESİ
SELECT e.employee_id, 
       e.first_name, 
       e.last_name, 
       c.Country, 
       ROUND(SUM(od.quantity * od.unit_price)::numeric, 2) AS total_sales
FROM employees e
JOIN orders o ON e.employee_id = o.employee_id
JOIN order_details od ON o.order_id = od.order_id
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY e.employee_id, e.first_name, e.last_name, c.Country
ORDER BY e.employee_id, total_sales DESC;

--TOPLAM İNDİRİM
SELECT TO_CHAR(ROUND(SUM(od.unit_price * od.quantity * od.discount)::numeric, 2), 'FM999,999,999.00') AS total_discount_amount
FROM order_details od;

--RFM ANALİZİ
--Recency

select max(order_date)
from orders;
--"1998-05-06"

	WITH recency AS (
    SELECT o.customer_id,
           MAX(o.order_date) AS max_order_date,
           '1998-05-06'::date - MAX(o.order_date) AS days_since_last_order
    FROM orders o
    WHERE o.shipped_date IS NOT NULL
    GROUP BY o.customer_id
),
frequency AS (
    SELECT o.customer_id,
           COUNT(o.order_id) AS order_frequency
    FROM orders o
    WHERE o.shipped_date IS NOT NULL
    GROUP BY o.customer_id
),
monetary AS (
    SELECT o.customer_id,
           SUM(od.unit_price * od.quantity) AS monetary
    FROM orders o
    JOIN order_details od ON o.order_id = od.order_id
    WHERE o.shipped_date IS NOT NULL
    GROUP BY o.customer_id
),
rfm AS (
    SELECT COALESCE(r.customer_id, f.customer_id, m.customer_id) AS customer_id,
           COALESCE(r.days_since_last_order, 0) AS days_since_last_order,
           COALESCE(f.order_frequency, 0) AS order_frequency,
           COALESCE(m.monetary, 0) AS monetary
    FROM recency r
    FULL OUTER JOIN frequency f ON r.customer_id = f.customer_id
    FULL OUTER JOIN monetary m ON r.customer_id = m.customer_id
),
rfm_scores AS (
    SELECT customer_id,
           CASE 
               WHEN days_since_last_order <= 30 THEN 5
               WHEN days_since_last_order <= 60 THEN 4
               WHEN days_since_last_order <= 90 THEN 3
               WHEN days_since_last_order <= 120 THEN 2
               ELSE 1
           END AS recency_score,
           CASE 
               WHEN order_frequency >= 10 THEN 5
               WHEN order_frequency >= 5 THEN 4
               WHEN order_frequency >= 3 THEN 3
               WHEN order_frequency >= 1 THEN 2
               ELSE 1
           END AS frequency_score,
           CASE 
               WHEN monetary >= 1000 THEN 5
               WHEN monetary >= 500 THEN 4
               WHEN monetary >= 100 THEN 3
               WHEN monetary >= 50 THEN 2
               ELSE 1
           END AS monetary_score
    FROM rfm
),
rfm_segments AS (
    SELECT customer_id,
           recency_score,
           frequency_score,
           monetary_score,
           (recency_score + frequency_score + monetary_score) AS total_score,
           CASE 
               WHEN (recency_score + frequency_score + monetary_score) >= 12 THEN 'VIP Customer'
               WHEN (recency_score + frequency_score + monetary_score) >= 9 THEN 'Loyal Customer'
               WHEN (recency_score + frequency_score + monetary_score) >= 6 THEN 'New Customer'
               ELSE 'At Risk Customer'
           END AS segment
    FROM rfm_scores
)
SELECT *
FROM rfm_segments
ORDER BY total_score DESC;


