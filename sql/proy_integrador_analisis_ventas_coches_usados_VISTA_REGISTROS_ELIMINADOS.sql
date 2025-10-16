-- Crear una vista de registros eliminados:
CREATE OR REPLACE VIEW venta_autos.registros_eliminados AS
SELECT r.*
FROM venta_autos.registros r
LEFT JOIN venta_autos.registros_limpios rl ON r.id_venta = rl.id_venta
WHERE rl.id_venta IS NULL; -- Esta vista contiene todos los registros que estaban en la tabla original (registros) pero no quedaron en registros_limpios

-- Para verificar la totalidad de los registros eliminados: 
SELECT COUNT(*) FROM venta_autos.registros_eliminados;
-- Total: 8427 registros (26 registros con tipo_carroceria = 'Navitgation' y 8401 registros con lugar_venta IN ('qc', 'ab', 'on', 'pr', 'ns')
