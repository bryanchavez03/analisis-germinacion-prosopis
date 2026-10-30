# Análisis de germinación de *Prosopis juliflora*

Análisis univariado y multivariado del efecto de la salinidad (NaCl) y la temperatura sobre la germinación de semillas de *Prosopis juliflora*, desarrollado en R.

## Datos

Dataset `prosopis` del paquete [GerminaR](https://CRAN.R-project.org/package=GerminaR), basado en Miranda et al. (2013).

- **Diseño:** completamente al azar con arreglo factorial 5 × 4
- **Factores:** NaCl (0; 0.5; 1; 1.5; 2) y temperatura (25, 30, 35 y 40 °C)
- **Repeticiones:** 4 por tratamiento (80 unidades experimentales, 50 semillas cada una)
- **Evaluación:** conteo diario de semillas germinadas (días 0 a 10)

## Análisis

**Univariado (germinabilidad, grp %)**
- Estadística descriptiva por tratamiento
- ANOVA factorial y verificación de supuestos (Shapiro-Wilk, Levene)
- Transformación arcoseno y prueba de Tukey
- Gráfico de interacción y curvas de germinación acumulada

**Multivariado (10 índices de germinación: grs, grp, mgt, mgr, gsp, unc, syn, vgt, sdg, cvg)**
- Matriz de correlación
- Análisis de Componentes Principales (PCA)
- MANOVA

## Requisitos

```r
install.packages(c("GerminaR", "dplyr", "car", "agricolae",
                   "corrplot", "FactoMineR", "factoextra"))
```

## Principales resultados

- La interacción NaCl × temperatura fue significativa (p < 0.001): la germinabilidad solo cae cuando la salinidad alta se combina con temperaturas de 35–40 °C.
- Los dos primeros componentes del PCA explican el 82 % de la variación: el CP1 (67.1 %) representa la velocidad y sincronía de la germinación, y el CP2 (14.9 %) la cantidad de semillas germinadas.

## Referencia

Miranda, R. Q., Correia, R. M., Almeida-Cortez, J. S., & Pompelli, M. F. (2013). Germination of *Prosopis juliflora* (Sw.) D.C. seeds at different osmotic potentials and temperatures. *Plant Species Biology, 29*(3), E9–E20. https://doi.org/10.1111/1442-1984.12025

## Autor

Bryan Chávez Velaisosa — Ingeniería Agronómica, UNTRM
