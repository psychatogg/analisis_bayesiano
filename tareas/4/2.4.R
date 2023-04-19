library(ggplot2)
yPred_1 <- extract(fit1,"yPred")
## Empleo los últimos 10 valores de la última iteración
yPred_1 <- yPred_1[[1]]
yPred_1 <- yPred_1[2000,1:10]
yPred_2 <- extract(fit2,"yPred")
yPred_2 <- yPred_2[[1]]
yPred_2 <- yPred_2[2000,1:10]

data_1 <- as.data.frame( cbind(x,y,yPred_1))
data_2 <- as.data.frame(cbind(x,y,yPred_2))





ggplot(data_1, aes(x, y)) + 
	geom_point(aes(color = "y")) + 
	geom_line(aes(color = "y")) +
	geom_point(aes(x, yPred_1, color = "yPred")) +
	scale_color_manual(name = "Grupos", 
										 values = c("y" = "black", "yPred" = "red")) +
	labs(color = "Leyenda") + 
	ggtitle("Modelo 1")
	



ggplot(data_2, aes(x, y)) + 
	geom_point(aes(color = "y")) + 
	geom_line(aes(color = "y")) +
	geom_point(aes(x, yPred_2, color = "yPred")) +
	scale_color_manual(name = "Grupos", 
										 values = c("y" = "black", "yPred" = "red")) +
	labs(color = "Leyenda") +
	ggtitle("Modelo 2")
	
