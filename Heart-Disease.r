library(ggplot2)
library(cowplot)
url <- "https://raw.githubusercontent.com/StatQuest/logistic_regression_demo/master/processed.cleveland.data"

data <- read.csv(url, header=FALSE)
head(data)

colnames(data) <- c(
  "age",
  "sex",# 0 = female, 1 = male
  "cp", # chest pain
  # 1 = typical angina,
  # 2 = atypical angina,
  # 3 = non-anginal pain,
  # 4 = asymptomatic
  "trestbps", # resting blood pressure (in mm Hg)
  "chol", # serum cholestoral in mg/dl
  "fbs",  # fasting blood sugar if less than 120 mg/dl, 1 = TRUE, 0 = FALSE
  "restecg", # resting electrocardiographic results
  # 1 = normal
  # 2 = having ST-T wave abnormality
  # 3 = showing probable or definite left ventricular hypertrophy
  "thalach", # maximum heart rate achieved
  "exang",   # exercise induced angina, 1 = yes, 0 = no
  "oldpeak", # ST depression induced by exercise relative to rest
  "slope", # the slope of the peak exercise ST segment
  # 1 = upsloping
  # 2 = flat
  # 3 = downsloping
  "ca", # number of major vessels (0-3) colored by fluoroscopy
  "thal", # this is short of thalium heart scan
  # 3 = normal (no cold spots)
  # 6 = fixed defect (cold spots during rest and exercise)
  # 7 = reversible defect (when cold spots only appear during exercise)
  "hd" # (the predicted attribute) - diagnosis of heart disease
  # 0 if less than or equal to 50% diameter narrowing
  # 1 if greater than 50% diameter narrowing
)
head(data)
str(data) 
data[data == "?"] <- NA
data[data$sex == 0,]$sex <- "F"
data[data$sex == 1,]$sex <- "M"
data$sex <- as.factor(data$sex)
data$cp <- as.factor(data$cp)
data$fbs <- as.factor(data$fbs)
data$restecg <- as.factor(data$restecg)
data$exang <- as.factor(data$exang)
data$slope <- as.factor(data$slope)
data$ca <- as.integer(data$ca)
data$ca <- as.factor(data$ca)
data$thal <- as.integer(data$thal)
data$thal <- as.factor(data$thal)
data$hd <- ifelse(test=data$hd == 0, yes="Healthy", no="Unhealthy")
str(data)
data$hd <- as.factor(data$hd)
str(data)
na_counts <- colSums(is.na(data))
na_counts
na_columns <- names(na_counts[na_counts > 0])
print(na_columns)
nrow(data[is.na(data$ca) | is.na(data$thal),])
data[is.na(data$ca) | is.na(data$thal),]
library(missForest)
imputed_data <- missForest(data)$ximp
sum(is.na(imputed_data))
data <- imputed_data

str(data)


xtabs(~ hd + sex, data=data)
xtabs(~ hd + cp, data=data)
xtabs(~ hd + fbs, data=data)
xtabs(~ hd + restecg, data=data)
xtabs(~ hd + exang, data=data)
xtabs(~ hd + slope, data=data)
xtabs(~ hd + ca, data=data)
xtabs(~ hd + thal, data=data)




chisq.test(table(data$hd, data$sex))
chisq.test(table(data$hd, data$cp))
chisq.test(table(data$hd, data$fbs))
chisq.test(table(data$hd, data$restecg))
chisq.test(table(data$hd, data$exang))
chisq.test(table(data$hd, data$slope))
chisq.test(table(data$hd, data$ca))
chisq.test(table(data$hd, data$thal))


library(ggplot2)

# Bar plots for categorical features vs heart disease

ggplot(data, aes(x = cp, fill = hd)) + 
  geom_bar(position = "fill") + 
  ggtitle("Chest Pain Type vs Heart Disease")

ggplot(data, aes(x = thal, fill = hd)) + 
  geom_bar(position = "fill") + 
  ggtitle("Thalium Scan vs Heart Disease")

# Add more if useful, e.g.:
ggplot(data, aes(x = slope, fill = hd)) + 
  geom_bar(position = "fill") + 
  ggtitle("Slope vs Heart Disease")




wilcox.test(age ~ hd, data = data)
wilcox.test(trestbps ~ hd, data = data)
wilcox.test(chol ~ hd, data = data)
wilcox.test(thalach ~ hd, data = data)
wilcox.test(oldpeak ~ hd, data = data)


# Boxplots of numeric variables by heart disease status
ggplot(data, aes(x = hd, y = age)) + 
  geom_boxplot() + 
  ggtitle("Age by Heart Disease Status")

ggplot(data, aes(x = hd, y = chol)) + 
  geom_boxplot() + 
  ggtitle("Cholesterol by Heart Disease Status")

ggplot(data, aes(x = hd, y = oldpeak)) + 
  geom_boxplot() + 
  ggtitle("Oldpeak by Heart Disease Status")

# Density plots for numeric variables by class

ggplot(data, aes(x = thalach, fill = hd)) + 
  geom_density(alpha = 0.5) + 
  ggtitle("Max Heart Rate by Heart Disease Status")


kruskal.test(age ~ cp, data = data)
kruskal.test(trestbps ~ cp, data = data)
kruskal.test(chol ~ thal, data = data)





# Correlation heatmap of numeric features
library(corrplot)
numeric_data <- data[, sapply(data, is.numeric)]
cor_matrix <- cor(numeric_data)
corrplot(cor_matrix, method = "color", type = "upper")




numeric_data <- data[, sapply(data, is.numeric)]
scaled_data <- scale(numeric_data)
pca_result <- prcomp(scaled_data, center = TRUE, scale. = TRUE)
summary(pca_result)
plot(pca_result, type = "l") 
biplot(pca_result, scale = 0)



library(MASS)
lda_result <- lda(hd ~ age + trestbps + chol + thalach + oldpeak, data = data)
lda_result
plot(lda_result)







# _____________________________________________________






logistic <- glm(hd ~ ., data=data, family="binomial")
summary(logistic)

logistic2 <- glm(hd ~ . - fbs, data = data, family = "binomial")
summary(logistic2)

logistic3 <- glm(hd ~ . - fbs - thal, data = data, family = "binomial")
summary(logistic3)


logistic4 <- glm(hd ~ . - fbs - thal - restecg, data = data, family = "binomial")
summary(logistic4)

logistic5 <- glm(hd ~ . - fbs - thal - restecg - cp, data = data, family = "binomial")
summary(logistic5)

logistic6 <- glm(hd ~ . - fbs - thal - restecg - cp - slope, data = data, family = "binomial")
summary(logistic6)

logistic7 <- glm(hd ~ . - fbs - thal - restecg - cp - slope - chol, data = data, family = "binomial")
summary(logistic7)



# Choice = logistic2

ll.null <- logistic2$null.deviance/-2
ll.proposed <- logistic2$deviance/-2
(ll.null - ll.proposed) / ll.null
1 - pchisq(2*(ll.proposed - ll.null), df=(length(logistic2$coefficients)-1))
predicted.data <- data.frame(
  probability.of.hd=logistic2$fitted.values,
  hd=data$hd)
predicted.data <- predicted.data[
  order(predicted.data$probability.of.hd, decreasing=FALSE),]
predicted.data$rank <- 1:nrow(predicted.data)
p <- ggplot(data=predicted.data, aes(x=rank, y=probability.of.hd)) +
  geom_point(aes(color=hd), alpha=1, shape=4, stroke=2) +
  xlab("Index") +
  ylab("Predicted probability of getting heart disease")

print(p)  # This explicitly renders the plot in the R session

ggsave("heart_disease_probabilities.pdf", plot = p)
