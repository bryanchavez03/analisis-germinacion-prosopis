install.packages(c("GerminaR", "dplyr", "car",
                   "agricolae", "corrplot", "FactoMineR", "factoextra"))
library(GerminaR)
library(dplyr)
library(car)
library(agricolae)
library(corrplot)
library(FactoMineR)
library(factoextra)
datos <- prosopis
dim (datos)
gs <- ger_summary(SeedN = "seeds", evalName = "D", 
                  factors = c("rep", "nacl", "temp"),
                  data = datos)

gs$nacl <- as.factor(gs$nacl)
gs$temp <- as.factor(gs$temp)

str(gs)

descriptivos <- gs %>%
  group_by(nacl, temp) %>%
  summarise(media = mean(grp),
            de    = sd(grp),
            cv    = sd(grp) / mean(grp) * 100,
            .groups = "drop")
print(descriptivos, n = 20)

boxplot(grp ~ nacl * temp, data = gs, las = 2, col = "grey",
        xlab = "", ylab = "Germinabilidad (%)",
        main = "grp por NaCl x Temperatura")

modelo <- aov (grp ~ nacl * temp, data = gs)
summary(modelo)

shapiro.test(residuals(modelo))
leveneTest(grp ~ nacl * temp, data = gs)

## Y Si no se cumplen: transformación arcoseno

gs$grp_t <- asin(sqrt(gs$grp / 100))
modelo_t <- aov(grp_t ~ nacl * temp, data = gs)
summary(modelo_t)
shapiro.test(residuals(modelo_t))


tukey <- HSD.test(modelo_t, c("nacl", "temp"), group = TRUE)
tukey$groups

interaction.plot(gs$nacl, gs$temp, gs$grp,
                 type = "b", pch = 19, lwd = 2,
                 col = c("blue", "orange", "darkgreen", "red"),
                 xlab = "NaCl", ylab = "Germinabilidad (%)",
                 trace.label = "Temp (°C)")


# Curva de Germinación en el tiempo 

dias <- grep("^D", names(datos), value = TRUE)
acum <- t(apply(datos[, dias], 1, cumsum)) / datos$seeds * 100
curva <- aggregate(acum, by = list(nacl = datos$nacl), FUN = mean)
matplot(0:10, t(curva[, -1]), type = "l", lwd = 2, lty = 1:5,
        col = c("blue", "orange", "darkgreen", "goldenrod", "red"),
        xlab = "Día", ylab = "Germinación acumulada (%)")
legend("bottomright", legend = paste("NaCl", curva$nacl),
       col = c("blue", "orange", "darkgreen", "goldenrod", "red"),
       lty = 1:5, lwd = 2)

## Multivariado 

vars  <- c("grs", "grp", "mgt", "mgr", "gsp", "unc", "syn", "vgt", "sdg", "cvg")
multi <- na.omit(gs[, c("nacl", vars)])
nrow(multi) # <- cuantas quedaron sin NA 

corrplot(cor(multi[, vars]), method = "number", type = "upper")

# PCA <<<<----

pca <- PCA(multi, quali.sup = 1, scale.unit = TRUE, ncp = 10, graph = FALSE)
pca$eig # <- explica varianza
pca$var$contrib[, 1:2] # <- variable que forma cada componente

fviz_eig(pca, addlabels = TRUE) # <- sedimentacion grafico
fviz_pca_var(pca, repel = TRUE) # <- circulo de varubales 
fviz_pca_ind(pca, habillage = 1,
             addEllipses = TRUE, label = "none") # <- placas coloreadas por NaCl


#MANOVA (solo variables no redundantes)
man <- manova(cbind(grp, mgt, unc, syn, sdg) ~ nacl * temp, data = gs)
summary(man, test = "Pillai")




















