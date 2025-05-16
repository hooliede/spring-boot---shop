
/* spring.sql.init.mode=always */

/* 초기 데이터 */
/* category */
INSERT INTO category (id, category_name) VALUES (1, '모니터');
INSERT INTO category (id, category_name) VALUES (2, 'TV');

/* attribute */
INSERT INTO attribute (attribute_id, attribute_name) VALUES (1, '해상도');
INSERT INTO attribute (attribute_id, attribute_name) VALUES (2, '주사율');

/* product */
INSERT INTO product (product_code, product_name, manufacturer, price, stock, category_id) 
VALUES ('P001', '게이밍 모니터', 'LG', 500000, 20, 1);

/* product_attribute */
-- ✅ 올바른 `INSERT` 쿼리
INSERT INTO product_attribute (attribute_id, product_code, attribute_value) VALUES (1, 'P001', '1920x1080');
INSERT INTO product_attribute (attribute_id, product_code, attribute_value) VALUES (2, 'P001', '144hz');
INSERT INTO product_attribute (attribute_id, product_code, attribute_value) VALUES (3, 'P001', '300cd/m2');
INSERT INTO product_attribute (attribute_id, product_code, attribute_value) VALUES (10, 'P001', '2.5kg');


/* category_attribute */
INSERT INTO category_attribute (category_id, attribute_id) VALUES (1, 1);
INSERT INTO category_attribute (category_id, attribute_id) VALUES (1, 2);
INSERT INTO category_attribute (category_id, attribute_id) VALUES (1, 3);
INSERT INTO category_attribute (category_id, attribute_id) VALUES (1, 10);

INSERT INTO category_attribute (category_id, attribute_id) VALUES (2, 1);
INSERT INTO category_attribute (category_id, attribute_id) VALUES (2, 4);
INSERT INTO category_attribute (category_id, attribute_id) VALUES (2, 2);
INSERT INTO category_attribute (category_id, attribute_id) VALUES (2, 10);