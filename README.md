# Bonus Section


### 1️ What is PostgreSQL?

PostgreSQL একটি অত্যন্ত শক্তিশালী ওপেন-সোর্স রিলেশনাল ডাটাবেস। এটি এন্টারপ্রাইজ-লেভেল ডাটা হ্যান্ডলিং থেকে শুরু করে ছোট অ্যাপ্লিকেশন সবকিছুতে ব্যবহার করা যায়। এটি অনেক অ্যাডভান্সড ফিচার যেমন: কমপ্লেক্স কুয়েরি অপটিমাইজেশন, JSON ডাটা সাপোর্ট, টেবিল ইনহেরিটেন্স, এবং কাস্টম ফাংশন তৈরির সুবিধা দেয়।

---

### 2️ What is the purpose of a database schema in PostgreSQL?

ডাটাবেস স্কিমা হলো একটি লজিক্যাল কন্টেইনার যা রিলেটেড টেবিল, ভিউ, এবং অন্যান্য ডাটাবেস অবজেক্ট একসাথে রাখে। উদাহরণস্বরূপ:

```sql
CREATE SCHEMA bookstore;
CREATE TABLE bookstore.books (
    id SERIAL PRIMARY KEY,
    title VARCHAR(100)
);
```

স্কিমা ব্যবহারের সুবিধাগুলো:

- একই নামের টেবিল আলাদা স্কিমায় রাখা যায়
- ডাটাবেস অরগানাইজড থাকে
- সিকিউরিটি বেটার হয়

```sql
-- উদাহরণ: দুইটা আলাদা স্কিমা
CREATE SCHEMA inventory;
CREATE SCHEMA accounting;

-- দুই স্কিমায় একই নামের টেবিল
CREATE TABLE inventory.products (...);
CREATE TABLE accounting.products (...);
```

---

### 3️ Explain the Primary Key and Foreign Key concepts in PostgreSQL?

**Primary Key:**

- এটি টেবিলের প্রতিটি Row কে uniquely চিহ্নিত করে
- কখনই duplicate হতে পারে না
- NULL হতে পারে না
- প্রতিটি টেবিলে শুধুমাত্র একটি Primary Key থাকে

**Foreign Key:**

- এটি একটি টেবিলকে অন্য টেবিলের সাথে সম্পর্ক যুক্ত করে
- অন্য টেবিলের Primary Key কে রেফারেন্স করে
- একটি টেবিলে একাধিক Foreign Key থাকতে পারে
- NULL হতে পারে
- Referential Integrity মেইনটেইন করে

উদাহরণ:

```sql
CREATE TABLE books (
    book_id SERIAL PRIMARY KEY,     -- Primary Key
);

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,    -- Primary Key
    book_id INTEGER REFERENCES books(book_id),  -- Foreign Key
);
```

---

### 4️ What is the difference between the VARCHAR and CHAR data types?

VARCHAR এবং CHAR দুটোই টেক্সট স্টোর করে, তবে তাদের স্টোরেজ পদ্ধতি আলাদা:

**VARCHAR:**

- ভ্যারিয়েবল লেংথ ডাটা টাইপ
- শুধুমাত্র প্রয়োজনীয় স্পেস ব্যবহার করে
- স্টোরেজ এফিসিয়েন্ট
- লেংথ পরিবর্তনশীল হলে এটি বেস্ট চয়েস
- ইনডেক্সিং এ একটু স্লো

**CHAR:**

- ফিক্সড লেংথ ডাটা টাইপ
- সর্বদা নির্দিষ্ট সাইজের স্পেস নেয়
- কম এফিসিয়েন্ট স্টোরেজ
- নির্দিষ্ট লেংথের ডাটার জন্য ভালো
- কম্প্যারিজন অপারেশনে ফাস্টার

---

### 5️ Explain the purpose of the WHERE clause in a SELECT statement?

WHERE ক্লজ SQL এর একটি গুরুত্বপূর্ণ অংশ যা দিয়ে আমরা স্পেসিফিক কন্ডিশন অনুযায়ী ডাটা খুঁজে বের করি। যেমন:

```sql
SELECT title, published_year
FROM books
WHERE published_year < 2000;
```

---

### 6️ What are the LIMIT and OFFSET clauses used for?

LIMIT এবং OFFSET ক্লজ পেজিনেশনের জন্য ব্যবহৃত হয়। এটি বড় ডাটাসেট থেকে নির্দিষ্ট সংখ্যক Row রিটার্ন করতে সাহায্য করে:

- LIMIT: কতগুলো Row দেখাবে তা নির্ধারণ করে
- OFFSET: কত নাম্বার Row থেকে শুরু করবে তা বলে দেয়

উদাহরণ:

```sql
-- টপ ৫টি দামি বই
SELECT title, price
FROM books
ORDER BY price DESC
LIMIT 5;

-- দ্বিতীয় পেজের ডাটা (প্রতি পেজে ১০টি করে আইটেম)
SELECT * FROM books
LIMIT 10 OFFSET 10;  -- ১১-২০ নং Row

-- লাস্ট ৫টি কাস্টমার
SELECT * FROM customers
ORDER BY joined_date DESC
LIMIT 5;
```

---

### 7️ How can you modify data using UPDATE statements?

UPDATE স্টেটমেন্ট দিয়ে টেবিলের এক্সিস্টিং ডাটা মডিফাই করা যায়। এটি খুবই শক্তিশালী কমান্ড, তাই WHERE ক্লজ দিয়ে সতর্কতার সাথে ব্যবহার করা উচিত:

```sql
-- সিঙ্গেল কলাম আপডেট
UPDATE books
SET stock = 10
WHERE stock = 0;

-- মাল্টিপল কলাম আপডেট
UPDATE books
SET
    price = price * 1.1,
    stock = stock + 5
WHERE published_year < 2000;
```

---

### 8️ What is the significance of the JOIN operation, and how does it work in PostgreSQL?

JOIN অপারেশন দুই বা ততোধিক টেবিল থেকে ডাটা একত্রিত করে। PostgreSQL এ বিভিন্ন ধরনের JOIN আছে:

- INNER JOIN (JOIN): দুই টেবিলের মিল থাকা ডাটা
- LEFT JOIN: বাম টেবিলের সব ডাটা + ডান টেবিলের মিল থাকা ডাটা
- RIGHT JOIN: ডান টেবিলের সব ডাটা + বাম টেবিলের মিল থাকা ডাটা
- FULL JOIN: দুই টেবিলের সব ডাটা

```sql
SELECT c.name, b.title, o.order_date
FROM orders o
JOIN customers c ON o.customer_id = c.id
JOIN books b ON o.book_id = b.id;

-- LEFT JOIN: সব কাস্টমার, অর্ডার না থাকলেও
SELECT c.name, COUNT(o.id) as total_orders
FROM customers as c
LEFT JOIN orders as o ON c.id = o.customer_id
GROUP BY c.name;
```

---

### 9️ Explain the GROUP BY clause and its role in aggregation operations?

GROUP BY ক্লজ সিমিলার ভ্যালুগুলোকে একত্রিত করে এবং তাদের উপর ক্যালকুলেশন করে। যেমন:

```sql
SELECT author, COUNT(*) as book_count, AVG(price) as avg_price
FROM books
GROUP BY author;
```

---

### 10 How can you calculate aggregate functions like COUNT(), SUM(), and AVG() in PostgreSQL?

Aggregate ফাংশনগুলো ডাটা অ্যানালাইসিসের জন্য অত্যন্ত গুরুত্বপূর্ণ। এগুলো দিয়ে বড় ডাটাসেট থেকে সামারি ইনফরমেশন বের করা যায়:

- COUNT(): Row গণনা করে
- SUM(): যোগফল বের করে
- AVG(): গড় মান বের করে
- MAX(): সর্বোচ্চ মান বের করে
- MIN(): সর্বনিম্ন মান বের করে

বিভিন্ন ধরনের ব্যবহার:

```sql
SELECT
    COUNT(*) as total_books,
    SUM(price) as total_value,
    AVG(price) as average_price,
    MAX(price) as highest_price,
    MIN(price) as lowest_price
FROM books;
```
