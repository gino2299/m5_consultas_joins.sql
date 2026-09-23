USE Ventas_Tech_DB;

--Consulta 1  Vista base del proyecto (INNER JOIN) --
SELECT 
    v.fecha_venta,
    v.id_cliente,
    p.nombre_producto,
    v.cantidad,
    v.precio_unitario,
    (v.cantidad * v.precio_unitario) AS total_venta,
    cat.nombre_categoria,
    c.ciudad,
    t.provincia,
    t.localidad
FROM ventas v
INNER JOIN cliente c 
    ON v.id_cliente = c.id_cliente
INNER JOIN productos p 
    ON v.id_producto = p.id_producto
INNER JOIN categorias cat 
    ON p.id_categoria = cat.id_categoria
INNER JOIN territorios t 
    ON c.id_territorio = t.id_territorio
ORDER BY v.fecha_venta;

--Consulta 2 Clientes sin ventas (LEFT JOIN) --

SELECT 
    c.nombre,
    c.email,
    c.fecha_registro
FROM cliente c
LEFT JOIN ventas v 
    ON c.id_cliente = v.id_cliente
WHERE v.id_cliente IS NULL;

-- La consulta va a estar vacia ya que no hay clientes que no hayan realizado compras--
-- pero voy a sumar un cliente mas para comprobar que funciona la consulta.--

INSERT INTO cliente (id_cliente, nombre, email, ciudad, fecha_registro)
VALUES (6, 'Sofía Díaz', 'sofia@mail.com', 'Salta', '2024-03-20');

UPDATE cliente 
SET ciudad = 'Mendoza' 
WHERE id_cliente = 6;

-- Consulta 3  Productos sin ventas (LEFT JOIN) --

SELECT 
    p.nombre_producto,
    cat.nombre_categoria,
    p.precio
FROM productos p
LEFT JOIN ventas v 
    ON p.id_producto = v.id_producto
INNER JOIN categorias cat 
    ON p.id_categoria = cat.id_categoria
WHERE v.id_producto IS NULL;

--Lo mismo que en la consulta 2 se encuentra vacio ya que no hay productos sin ventas --

-- Incertamos un producto nuevo para sin ventas para ver si funciona la query--
INSERT INTO productos (id_producto, nombre_producto, id_categoria, precio, stock, activo)
VALUES (7, 'Webcam Full HD', 3, 65.00, 20, 1);

--Consulta 4 — Consolidado por canal (UNION ALL)--

SELECT 
    fecha_venta, 
    (cantidad * precio_unitario) AS total, 
    'Primera Quincena' AS canal
FROM ventas
WHERE fecha_venta < '2024-03-10'

UNION ALL

SELECT 
    fecha_venta, 
    (cantidad * precio_unitario) AS total, 
    'Segunda Quincena' AS canal
FROM ventas
WHERE fecha_venta >= '2024-03-10'

-- ahora usamos el group by--

SELECT 
    canal, 
    SUM(total) AS total_por_canal
FROM (
    SELECT 
        fecha_venta, 
        (cantidad * precio_unitario) AS total, 
        'Primera Quincena' AS canal
    FROM ventas
    WHERE fecha_venta < '2024-03-10'

    UNION ALL

    SELECT 
        fecha_venta, 
        (cantidad * precio_unitario) AS total, 
        'Segunda Quincena' AS canal
    FROM ventas
    WHERE fecha_venta >= '2024-03-10'
) AS consolidado
GROUP BY canal;
