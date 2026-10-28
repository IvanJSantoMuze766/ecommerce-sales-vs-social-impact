-- =====================================================================
-- PROYECTO: Análisis de Impacto - Redes Sociales vs. Ventas Reales
-- OBJETIVO: Evaluar si el engagement en redes se traduce en conversiones
-- =====================================================================

-- 1. Vista general: Comparando impresiones y likes contra conversiones reales de compra
SELECT 
    c.nombre_campana,
    c.red_social,
    c.presupuesto_invertido,
    m.total_likes,
    m.total_impresiones,
    v.carritos_comprados,
    v.ingresos_totales_generados,
    -- Calculando el Retorno de Inversión (ROI) y Costo por Adquisición (CPA)
    ROUND(v.ingresos_totales_generados / c.presupuesto_invertido, 2) AS roi_campana,
    ROUND(c.presupuesto_invertido / NULLIF(v.carritos_comprados, 0), 2) AS costo_por_adquisicion
FROM 
    campanas_marketing c
JOIN 
    metricas_redes m ON c.id_campana = m.id_campana
JOIN 
    ventas_ecommerce v ON c.id_campana = v.id_campana
ORDER BY 
    roi_campana DESC;

-- 2. Filtrando campañas "humo": Alto volumen de likes pero baja conversión de ventas
SELECT 
    nombre_campana,
    total_likes,
    ingresos_totales_generados
FROM 
    campanas_marketing c
JOIN 
    metricas_redes m ON c.id_campana = m.id_campana
JOIN 
    ventas_ecommerce v ON c.id_campana = v.id_campana
WHERE 
    m.total_likes > 5000 -- Campañas muy populares en redes
    AND v.ingresos_totales_generados < 1000 -- Pero con ventas pobres
ORDER BY 
    total_likes DESC;
