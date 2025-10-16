-- CREACIÓN DEL MODELO RELACIONAL:
-- A continuación se crearán las tablas de dimensiones necesarias para el modelo, se insertará los datos en ella, y luego se creará la tabla de hechos con su correspondiente inserción de datos.

-- CREACION TABLA DE DIMENSIONES DIM_LUGAR_VENTA:
USE venta_autos;

CREATE TABLE IF NOT EXISTS venta_autos.dim_lugar_venta (
ID INT PRIMARY KEY AUTO_INCREMENT,
Estado VARCHAR(100)
); -- Creamos la tabla de dimensiones dim_lugar_venta.

SELECT distinct lugar_venta
FROM venta_autos.registros_limpios
WHERE lugar_venta IS NOT NULL; -- validamos los diferentes estados donde se produjeron las ventas.

INSERT INTO venta_autos.dim_lugar_venta(Estado)
SELECT DISTINCT lugar_venta
FROM venta_autos.registros_limpios
WHERE lugar_venta IS NOT NULL; -- Insertamos los registros de los estados en la tabla.

-- CREACION TABLA DE DIMENSIONES DIM_ESTADO_VEHICULO:

CREATE TABLE IF NOT EXISTS venta_autos.dim_estado_vehiculo (
ID INT PRIMARY KEY AUTO_INCREMENT,
Categoria_estado_vehiculo VARCHAR(100)
); -- Creamos la tabla de dimensiones dim_estado_vehiculo.

SELECT DISTINCT estado_vehiculo_categoria
FROM venta_autos.registros_limpios
WHERE estado_vehiculo_categoria IS NOT NULL; -- Validamos las distintas categorias.

INSERT INTO venta_autos.dim_estado_vehiculo (Categoria_estado_vehiculo)
SELECT DISTINCT estado_vehiculo_categoria
FROM venta_autos.registros_limpios
WHERE estado_vehiculo_categoria IS NOT NULL; -- Insertamos los registros de las diferentes categorias en la tabla.

-- CREACION TABLA DE DIMENSIONES COLOR:
-- Hacemos un análisis de los diferentes colores que aparecen en ambas columnas:
CREATE TABLE IF NOT EXISTS venta_autos.dim_color (
ID INT PRIMARY KEY AUTO_INCREMENT,
Color VARCHAR(100)
); -- Creamos la tabla de dimensiones dim_color

SELECT DISTINCT color_exterior
FROM venta_autos.registros_limpios
WHERE color_exterior IS NOT NULL; -- Tenemos 19 colores diferentes.

SELECT DISTINCT color_interior
FROM venta_autos.registros_limpios
WHERE color_interior IS NOT NULL; -- Tenemos 16 colores diferentes

-- Comparando los colores en ambas listas tenemos que todos los colores de la columna color_interior están contenidos en la columna color_exterior, salvo el "tostado". De la columna color_exterior los colores "turquesa","rosa","lima" y "gris_oscuro" no aparecen en la columna color_interior.
-- Decidimos crear una sola tabla de dimensiones de color, que contenga todas las alternativas para ambos casos.

INSERT INTO venta_autos.dim_color (Color)
SELECT DISTINCT color_exterior
FROM venta_autos.registros_limpios
WHERE color_exterior IS NOT NULL; -- insertamos todos los colores que hay en la columna color_exterior.

INSERT INTO venta_autos.dim_color (id,Color)
VALUES (20,'tostado'); -- Insertamos el color 'tostado', que es el que faltaba.

-- CREACION TABLA DE DIMENSIONES DIM_MARCA:

CREATE TABLE IF NOT EXISTS venta_autos.dim_marca (
ID INT PRIMARY KEY AUTO_INCREMENT,
Marca VARCHAR(100)
); -- Creamos la tabla de dimensiones dim_marca

SELECT distinct marca
FROM venta_autos.registros_limpios
WHERE marca IS NOT NULL; -- validamos los diferentes marcas de coches vendidas

INSERT INTO venta_autos.dim_marca (Marca)
SELECT DISTINCT marca
FROM venta_autos.registros_limpios
WHERE marca IS NOT NULL;

-- CREACION TABLA DE DIMENSIONES DIM_MODELO:

CREATE TABLE IF NOT EXISTS venta_autos.dim_modelo (
ID INT PRIMARY KEY AUTO_INCREMENT,
Modelo VARCHAR(100)
); -- Creamos la tabla de dimensiones dim_modelo

SELECT distinct modelo
FROM venta_autos.registros_limpios
WHERE modelo IS NOT NULL; -- validamos los diferentes modelos de coches vendidos

INSERT INTO venta_autos.dim_modelo (Modelo)
SELECT distinct modelo
FROM venta_autos.registros_limpios
WHERE modelo IS NOT NULL;

-- CREACION TABLA DE DIMENSIONES DIM_TIPO_CARROCERIA:

CREATE TABLE IF NOT EXISTS venta_autos.dim_tipo_carroceria (
ID INT PRIMARY KEY AUTO_INCREMENT,
Tipo_carroceria VARCHAR(100)
); -- Creamos la tabla de dimensiones dim_tipo_carroceria

SELECT distinct tipo_carroceria
FROM venta_autos.registros_limpios
WHERE tipo_carroceria IS NOT NULL; -- validamos los diferentes tipos de carrocerías

INSERT INTO venta_autos.dim_tipo_carroceria (Tipo_carroceria)
SELECT distinct tipo_carroceria
FROM venta_autos.registros_limpios
WHERE tipo_carroceria IS NOT NULL;

-- CREACION TABLA DE DIMENSIONES DIM_CAJA:
CREATE TABLE IF NOT EXISTS venta_autos.dim_caja (
ID INT PRIMARY KEY AUTO_INCREMENT,
Caja VARCHAR(100)
); -- Creamos la tabla de dimensiones dim_caja.

SELECT distinct caja
FROM venta_autos.registros_limpios
WHERE caja IS NOT NULL; -- validamos los diferentes tipos de carrocerías

INSERT INTO venta_autos.dim_caja (Caja)
SELECT distinct caja
FROM venta_autos.registros_limpios
WHERE caja IS NOT NULL; 

-- CREACION DE TABLA DE HECHOS hechos_registros:

CREATE TABLE IF NOT EXISTS venta_autos.hechos_registros (
ID_venta INT PRIMARY KEY AUTO_INCREMENT,
anio_fabricacion INT,
id_marca INT,
id_modelo INT,
id_tipo_carroceria INT,
id_caja INT,
id_lugar_venta INT,
id_estado_vehiculo INT,
kilometraje BIGINT,
id_color_exterior INT,
id_color_interior INT,
valor_mercado_usd BIGINT,
valor_venta_usd BIGINT,
fecha_venta DATE,
FOREIGN KEY (id_marca) REFERENCES dim_marca(ID),
FOREIGN KEY (id_modelo) REFERENCES dim_modelo(ID),
FOREIGN KEY (id_tipo_carroceria) REFERENCES dim_tipo_carroceria(ID),
FOREIGN KEY (id_caja) REFERENCES dim_caja(ID),
FOREIGN KEY (id_lugar_venta) REFERENCES dim_lugar_venta(ID),
FOREIGN KEY (id_estado_vehiculo) REFERENCES dim_estado_vehiculo(ID),
FOREIGN KEY (id_color_exterior) REFERENCES dim_color(ID),
FOREIGN KEY (id_color_interior) REFERENCES dim_color(ID)
); -- Creamos la tabla de hechos con sus correspondientes claves foraneas y clave primaria.

INSERT INTO venta_autos.hechos_registros (
  anio_fabricacion,
  id_marca,
  id_modelo,
  id_tipo_carroceria,
  id_caja,
  id_lugar_venta,
  id_estado_vehiculo,
  kilometraje,
  id_color_exterior,
  id_color_interior,
  valor_mercado_usd,
  valor_venta_usd,
  fecha_venta
)
SELECT
  rl.anio,
  dma.ID,
  dmo.ID,
  dtc.ID,
  dc.ID,
  dlv.ID,
  dev.ID,
  rl.kilometros,
  dce.ID,
  dci.ID,
  rl.valor_mercado_usd,
  rl.valor_venta_usd,
  rl.fecha_venta_nuevo
FROM venta_autos.registros_limpios rl
LEFT JOIN venta_autos.dim_marca dma ON rl.marca = dma.Marca
LEFT JOIN venta_autos.dim_modelo dmo ON rl.modelo = dmo.Modelo
LEFT JOIN venta_autos.dim_tipo_carroceria dtc ON rl.tipo_carroceria = dtc.Tipo_carroceria
LEFT JOIN venta_autos.dim_caja dc ON rl.caja = dc.Caja
LEFT JOIN venta_autos.dim_lugar_venta dlv ON rl.lugar_venta = dlv.Estado
LEFT JOIN venta_autos.dim_estado_vehiculo dev ON rl.estado_vehiculo_categoria = dev.Categoria_estado_vehiculo
LEFT JOIN venta_autos.dim_color dce ON rl.color_exterior = dce.Color
LEFT JOIN venta_autos.dim_color dci ON rl.color_interior = dci.Color
WHERE  rl.id_venta BETWEEN 1 AND 200000
ORDER BY rl.id_venta; -- Cargamos lor primeros 200.000 registros. 

INSERT INTO venta_autos.hechos_registros (
  anio_fabricacion,
  id_marca,
  id_modelo,
  id_tipo_carroceria,
  id_caja,
  id_lugar_venta,
  id_estado_vehiculo,
  kilometraje,
  id_color_exterior,
  id_color_interior,
  valor_mercado_usd,
  valor_venta_usd,
  fecha_venta
)
SELECT
  rl.anio,
  dma.ID,
  dmo.ID,
  dtc.ID,
  dc.ID,
  dlv.ID,
  dev.ID,
  rl.kilometros,
  dce.ID,
  dci.ID,
  rl.valor_mercado_usd,
  rl.valor_venta_usd,
  rl.fecha_venta_nuevo
FROM venta_autos.registros_limpios rl
LEFT JOIN venta_autos.dim_marca dma ON rl.marca = dma.Marca
LEFT JOIN venta_autos.dim_modelo dmo ON rl.modelo = dmo.Modelo
LEFT JOIN venta_autos.dim_tipo_carroceria dtc ON rl.tipo_carroceria = dtc.Tipo_carroceria
LEFT JOIN venta_autos.dim_caja dc ON rl.caja = dc.Caja
LEFT JOIN venta_autos.dim_lugar_venta dlv ON rl.lugar_venta = dlv.Estado
LEFT JOIN venta_autos.dim_estado_vehiculo dev ON rl.estado_vehiculo_categoria = dev.Categoria_estado_vehiculo
LEFT JOIN venta_autos.dim_color dce ON rl.color_exterior = dce.Color
LEFT JOIN venta_autos.dim_color dci ON rl.color_interior = dci.Color
WHERE  rl.id_venta BETWEEN 200001 AND 400000
ORDER BY rl.id_venta; -- Cargamos hasta el registro 400.000. 

INSERT INTO venta_autos.hechos_registros (
  anio_fabricacion,
  id_marca,
  id_modelo,
  id_tipo_carroceria,
  id_caja,
  id_lugar_venta,
  id_estado_vehiculo,
  kilometraje,
  id_color_exterior,
  id_color_interior,
  valor_mercado_usd,
  valor_venta_usd,
  fecha_venta
)
SELECT
  rl.anio,
  dma.ID,
  dmo.ID,
  dtc.ID,
  dc.ID,
  dlv.ID,
  dev.ID,
  rl.kilometros,
  dce.ID,
  dci.ID,
  rl.valor_mercado_usd,
  rl.valor_venta_usd,
  rl.fecha_venta_nuevo
FROM venta_autos.registros_limpios rl
LEFT JOIN venta_autos.dim_marca dma ON rl.marca = dma.Marca
LEFT JOIN venta_autos.dim_modelo dmo ON rl.modelo = dmo.Modelo
LEFT JOIN venta_autos.dim_tipo_carroceria dtc ON rl.tipo_carroceria = dtc.Tipo_carroceria
LEFT JOIN venta_autos.dim_caja dc ON rl.caja = dc.Caja
LEFT JOIN venta_autos.dim_lugar_venta dlv ON rl.lugar_venta = dlv.Estado
LEFT JOIN venta_autos.dim_estado_vehiculo dev ON rl.estado_vehiculo_categoria = dev.Categoria_estado_vehiculo
LEFT JOIN venta_autos.dim_color dce ON rl.color_exterior = dce.Color
LEFT JOIN venta_autos.dim_color dci ON rl.color_interior = dci.Color
WHERE  rl.id_venta BETWEEN 400001 AND 550410
ORDER BY rl.id_venta; -- Cargamos la ultima tanda de registros.




