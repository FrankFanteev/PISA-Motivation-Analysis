rm(list = ls())
setwd('~/Data science masters course/T1 group project/Analysis')
library(dplyr)

# Creating students data
students <- read.csv('Pisa_dataset 10%.csv')
students$ST08Q01 <- ifelse(students$ST08Q01 == 1, 1, 0)
students$ST28Q01 <- ifelse(students$ST28Q01 <= 3, 1,
                       ifelse(students$ST28Q01 == 4, 2, 3))
studentsData <- students %>% transmute('Student' = paste(StIDStd, CNT, sep = ""),
                                  'Country' = CNT,
                                  'SchoolID' = paste(SCHOOLID, CNT, sep = ""),
                                  'InternationalGrade' = ST01Q01,
                                  'Gender' = 2-ST04Q01,
                                  'PersonalMotivation' = ST08Q01+8-2*ST09Q01+4-ST115Q01+36-ST46Q01-ST46Q02-ST46Q03-ST46Q04-ST46Q05-ST46Q06-ST46Q07-ST46Q08-ST46Q09,
                                  'PossessionsStudyDesk' = 2-ST26Q01,
                                  'PossessionsStudyOwnRoom' = 2-ST26Q02,
                                  'PossessionsStudyStudyPlace' = 2-ST26Q03,
                                  'PossessionsStudyComputer' = 2-ST26Q04,
                                  'PossessionsStudySoftware' = 2-ST26Q05,
                                  'PossessionsStudyInternet' = 2-ST26Q06,
                                  'PossessionsStudyTextbooks' = 2-ST26Q10,
                                  'PossessionsStudyTechnicalBooks' = 2-ST26Q11,
                                  'PossessionsNonStudyLiterature' = ST28Q01,
                                  'PossessionsNonStudyPoetry' = 2-ST26Q07,
                                  'PossessionsNonStudyArt' = 2-ST26Q08,
                                  'PossessionsNonStudyNoOfBooks' = 2-ST26Q09,
                                  'PossessionsNonStudyDictionary' = 2-ST26Q12,
                                  'PossessionsWealthCellPhones' = ST27Q01-1,
                                  'PossessionsWealthTVs' = ST27Q02-1,
                                  'PossessionsWealthComputers' = ST27Q03-1,
                                  'PossessionsWealthCars' = ST27Q04-1,
                                  'PossessionsWealthBathrooms' = ST27Q05-1,
                                  'PossessionsWealthDVD' = 2-ST26Q14,
                                  'Enjoyment1' = 4-ST29Q01,
                                  'Enjoyment2' = 4-ST29Q03,
                                  'Enjoyment3' = 4-ST29Q04,
                                  'Enjoyment4' = 4-ST29Q06,
                                  'MotivatingFactors1' = 4-ST29Q02,
                                  'MotivatingFactors2' = 4-ST29Q05,
                                  'MotivatingFactors3' = 4-ST29Q07,
                                  'MotivatingFactors4' = 4-ST29Q08,
                                  'AtHomeMother' = 2-ST11Q01,
                                  'AtHomeFather' = 2-ST11Q02,
                                  'AtHomeBrothers' = 2-ST11Q03,
                                  'AtHomeSisters' = 2-ST11Q04,
                                  'AtHomeGrandparents' = 2-ST11Q01,
                                  'MotherEmployed' = ifelse(ST15Q01 <= 2, 1, 0),
                                  'FatherEmployed' = ifelse(ST19Q01 <= 2, 1, 0),
                                  'MotherEducation' = 5-ST13Q01+8-ST14Q01-ST14Q02-ST14Q03-ST14Q04,
                                  'FatherEducation' = 5-ST17Q01+8-ST18Q01-ST18Q02-ST18Q03-ST18Q04,
                                  'CountryOfBirthSelf' = 2-ST20Q01,
                                  'CountryOfBirthMother' = 2-ST20Q02,
                                  'CountryOfBirthFather' = 2-ST20Q03,
                                  'LanguageAtHome' = 2-ST25Q01,
                                  'SenseOfBelonging1' = ST87Q01-1,
                                  'SenseOfBelonging2' = ST87Q04-1,
                                  'SenseOfBelonging3' = ST87Q06-1,
                                  'SenseOfBelonging4' = 4-ST87Q02,
                                  'SenseOfBelonging5' = 4-ST87Q03,
                                  'SenseOfBelonging6' = 4-ST87Q05,
                                  'SenseOfBelonging7' = 4-ST87Q07,
                                  'SenseOfBelonging8' = 4-ST87Q08,
                                  'SenseOfBelonging9' = 4-ST87Q09,
                                  'AttitudeToSchool1' = ST88Q01-1,
                                  'AttitudeToSchool2' = ST88Q02-1,
                                  'AttitudeToSchool3' = 4-ST88Q03,
                                  'AttitudeToSchool4' = 4-ST88Q04,
                                  'AttitudeToSchool5' = 4-ST89Q02,
                                  'AttitudeToSchool6' = 4-ST89Q03,
                                  'AttitudeToSchool7' = 4-ST89Q04,
                                  'AttitudeToSchool8' = 4-ST89Q05,
                                  'PerceivedControl1' = 4-ST91Q01,
                                  'PerceivedControl2' = 4-ST91Q02,
                                  'PerceivedControl3' = 4-ST91Q05,
                                  'PerceivedControl4' = ST91Q03-1,
                                  'PerceivedControl5' = ST91Q04-1,
                                  'PerceivedControl6' = ST91Q06-1)

PMMean <- mean(studentsData$PersonalMotivation)
PMsd <- sd(studentsData$PersonalMotivation)
studentsData$PersonalMotivation <- (studentsData$PersonalMotivation - PMMean)/PMsd

# Creating schools data
schools <- read.csv('school_data.csv')
schoolsData <- schools %>% transmute('SchoolID' = paste(SCHOOLID, CNT, sep = ""),
                                     'AreaSize' = SC03Q01,
                                     'ClassSize' = SC05Q01,
                                     'AchPubPost' = 2-SC19Q01)
names(schools)
# Joining data
combinedData <- merge(studentsData, schoolsData, by="SchoolID")
combinedData <- filter(combinedData, AreaSize != 'NA', ClassSize < 10, AchPubPost != 'NA')

# Correlation matrix
install.packages('corrplot')
library(corrplot)
corrData <- combinedData %>% select(Gender,
                PossessionsStudyDesk,
                PossessionsStudyOwnRoom,
                PossessionsStudyStudyPlace,
                PossessionsStudyComputer,
                PossessionsStudySoftware,
                PossessionsStudyInternet,
                PossessionsStudyTextbooks,
                PossessionsStudyTechnicalBooks,
                PossessionsNonStudyLiterature,
                PossessionsNonStudyDictionary,
                PossessionsWealthBathrooms,
                Enjoyment1,
                Enjoyment2,
                Enjoyment3,
                Enjoyment4,
                MotivatingFactors1,
                MotivatingFactors2,
                MotivatingFactors3,
                MotivatingFactors4,
                AtHomeMother,
                AtHomeFather,
                AtHomeBrothers,
                AtHomeSisters,
                SenseOfBelonging3,
                SenseOfBelonging5,
                SenseOfBelonging6,
                SenseOfBelonging7,
                SenseOfBelonging8,
                SenseOfBelonging9,
                AttitudeToSchool1,
                AttitudeToSchool2,
                AttitudeToSchool3,
                AttitudeToSchool4,
                AttitudeToSchool5,
                AttitudeToSchool6,
                AttitudeToSchool7,
                AttitudeToSchool8,
                PerceivedControl1,
                PerceivedControl2,
                PerceivedControl3,
                PerceivedControl4,
                PerceivedControl5,
                PerceivedControl6)

names(corrData) <- c('Gender',
                  '',
                  '',
                  '',
                  'PossessionsStudy',
                  '',
                  '',
                  '',
                  '',
                  'PossessionsNonStudy',
                  '',
                  '',
                  'Enjoyment',
                  '',
                  '',
                  '',
                  'MotivatingFactors',
                  '',
                  '',
                  '',
                  'HomeSituation',
                  '',
                  '',
                  '',
                  'SenseOfBelonging',
                  '',
                  '',
                  '',
                  '',
                  '',
                  'AttitudeToSchool',
                  '',
                  '',
                  '',
                  '',
                  '',
                  '',
                  '',
                  'PerceivedControl',
                  '',
                  '',
                  '',
                  '',
                  '')

corrMat <- cor(corrData, method = "pearson")

corrplot(corrMat, method = "circle", tl.cex = 0.6, tl.srt = 50, tl.col = "burlywood4")

# Testing model
model <- lm(PersonalMotivation ~ ., data = combinedData[,5:ncol(combinedData)])
model$coefficients

# Lasso
library(glmnet)
yMotivation <- combinedData[,6]
XVariables <- as.matrix(combinedData[,c(5,26:(ncol(combinedData)))])

lassoFit <- glmnet(XVariables, yMotivation)
lassoFit
plot(lassoFit)
cvLasso <- cv.glmnet(XVariables, yMotivation)
plot(cvLasso)
coef(lassoFit, s = 0.1)

# Adding additional columns to data
combinedDataAddColumns <- combinedData %>% mutate(PossessionsNonStudy = PossessionsNonStudyArt+PossessionsNonStudyPoetry+PossessionsNonStudyNoOfBooks+PossessionsNonStudyLiterature+PossessionsNonStudyDictionary,
                                                  PossessionsWealth = PossessionsWealthCellPhones+PossessionsWealthTVs+PossessionsWealthComputers+PossessionsWealthCars+PossessionsWealthBathrooms+PossessionsWealthDVD,
                                                  Enjoyment = Enjoyment1+Enjoyment2+Enjoyment3+Enjoyment4,
                                                  MotivatingFactors = MotivatingFactors1+MotivatingFactors2+MotivatingFactors3+MotivatingFactors4,
                                                  SenseOfBelonging = SenseOfBelonging1+SenseOfBelonging2+SenseOfBelonging3+SenseOfBelonging4+SenseOfBelonging5+SenseOfBelonging6+SenseOfBelonging7+SenseOfBelonging8+SenseOfBelonging9,
                                                  AttitudeToSchool = AttitudeToSchool1+AttitudeToSchool2+AttitudeToSchool3+AttitudeToSchool4+AttitudeToSchool5+AttitudeToSchool6+AttitudeToSchool7+AttitudeToSchool8,
                                                  PerceivedControl = PerceivedControl1+PerceivedControl2+PerceivedControl3+PerceivedControl4+PerceivedControl5+PerceivedControl6)

combinedDataAddColumns$PossessionsNonStudy <- (combinedDataAddColumns$PossessionsNonStudy - mean(combinedDataAddColumns$PossessionsNonStudy))/sd(combinedDataAddColumns$PossessionsNonStudy)
combinedDataAddColumns$PossessionsWealth <- (combinedDataAddColumns$PossessionsWealth - mean(combinedDataAddColumns$PossessionsWealth))/sd(combinedDataAddColumns$PossessionsWealth)
combinedDataAddColumns$Enjoyment <- (combinedDataAddColumns$Enjoyment - mean(combinedDataAddColumns$Enjoyment))/sd(combinedDataAddColumns$Enjoyment)
combinedDataAddColumns$MotivatingFactors <- (combinedDataAddColumns$MotivatingFactors - mean(combinedDataAddColumns$MotivatingFactors))/sd(combinedDataAddColumns$MotivatingFactors)
combinedDataAddColumns$SenseOfBelonging <- (combinedDataAddColumns$SenseOfBelonging - mean(combinedDataAddColumns$SenseOfBelonging))/sd(combinedDataAddColumns$SenseOfBelonging)
combinedDataAddColumns$AttitudeToSchool <- (combinedDataAddColumns$AttitudeToSchool - mean(combinedDataAddColumns$AttitudeToSchool))/sd(combinedDataAddColumns$AttitudeToSchool)
combinedDataAddColumns$PerceivedControl <- (combinedDataAddColumns$PerceivedControl - mean(combinedDataAddColumns$PerceivedControl))/sd(combinedDataAddColumns$PerceivedControl)

library(ggplot2)
ggplot(data = combinedDataAddColumns[1:15000,], aes(x = combinedDataAddColumns$PersonalMotivation[1:15000], y = combinedDataAddColumns$Enjoyment[1:15000], colour = 'red', alpha = 0.001)) +
  geom_jitter() + ylab('Enjoyment') + xlab('Motivation') + theme(legend.position='none')

ggplot(data = combinedDataAddColumns[1:5000,], aes(x = combinedDataAddColumns$PersonalMotivation[1:5000], y = combinedDataAddColumns$SenseOfBelonging[1:5000], colour = 'red', alpha = 0.001)) +
  geom_jitter() + ylab('Sense of Belonging') + xlab('Motivation') + theme(legend.position='none')

hist(combinedDataAddColumns$PersonalMotivation, breaks = 100, col = 'blue')
plot(combinedDataAddColumns$PersonalMotivation, combinedDataAddColumns$PossessionsStudyOwnRoom)
# Creating function to extract variables for regression
Xselector <- function(data) {
  data %>% select(Gender,
                 PossessionsStudyDesk,
                 PossessionsStudyOwnRoom,
                 PossessionsStudyStudyPlace,
                 PossessionsStudyComputer,
                 PossessionsStudySoftware,
                 PossessionsStudyInternet,
                 PossessionsStudyTextbooks,
                 PossessionsStudyTechnicalBooks,
                 PossessionsNonStudy,
                 PossessionsWealth,
                 Enjoyment,
                 MotivatingFactors,
                 AtHomeMother,
                 AtHomeFather,
                 AtHomeBrothers,
                 AtHomeSisters,
                 SenseOfBelonging,
                 AttitudeToSchool,
                 PerceivedControl)
}

# Running MLE on selected variables (nb: s is lambda so 0 means MLE)
fit <- glmnet(as.matrix(Xselector(combinedDataAddColumns)),
       as.matrix(select(combinedDataAddColumns, PersonalMotivation)))
fit
coefs <- coef(fit, s=0)
coefs
coefs1 <- as.double(unlist(coef(fit, s=0)))
labels <- unlist(labels(as.matrix(Xselector(combinedDataAddColumns)))[2])
coefs2 <- coefs[2:length(coefs)]
write.csv(cbind(labels, coefs2), 'coefs.csv')
coefs3 <- read.csv('coefs.csv')
coefs3[["sign"]] = ifelse(coefs3[["coefs2"]] >= 0, "positive", "negative")

ggplot(coefs3, aes(x = labels, y = coefs2, fill = sign)) +
  geom_bar(stat="identity") +
  ylab("Weight") +
  xlab("Factor") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1), legend.position="none") +
  scale_fill_manual(values = c("positive" = "springgreen", "negative" = "tomato3"))

# splitting data by country
countryData <- split(combinedDataAddColumns, combinedDataAddColumns$Country)
obsPerCountry <- lapply(countryData, nrow)
unlist(obsPerCountry)

# Regression by country (nb: use s = 0 for MLE)
glmnetFit <- function(someData) {
  y <- as.matrix(select(someData, PersonalMotivation))
  X <- as.matrix(Xselector(someData))
  glmnet(X, y)
}

glmnetCoef <- function(someData) {
  y <- as.matrix(select(someData, PersonalMotivation))
  X <- as.matrix(Xselector(someData))
  fitTemp <- glmnet(X, y, alpha = 1)
  coef(fitTemp, s=0)
}

countryLassoFit <- lapply(countryData, glmnetFit)
countryCoefs <- lapply(countryData, glmnetCoef)

countryCoefsTable <- cbind(countryCoefs$ALB,
                           countryCoefs$ARE,
                           countryCoefs$AUS,
                           countryCoefs$AUT,
                           countryCoefs$BEL,
                           countryCoefs$BGR,
                           countryCoefs$BRA,
                           countryCoefs$CAN,
                           countryCoefs$CHE,
                           countryCoefs$CHL,
                           countryCoefs$CRI,
                           countryCoefs$CZE,
                           countryCoefs$DEU,
                           countryCoefs$DNK,
                           countryCoefs$ESP,
                           countryCoefs$EST,
                           countryCoefs$FIN,
                           countryCoefs$GBR,
                           countryCoefs$GRC,
                           countryCoefs$HKG,
                           countryCoefs$HRV,
                           countryCoefs$HUN,
                           countryCoefs$IRL,
                           countryCoefs$ISL,
                           countryCoefs$ITA,
                           countryCoefs$KAZ,
                           countryCoefs$LIE,
                           countryCoefs$LTU,
                           countryCoefs$LUX,
                           countryCoefs$LVA,
                           countryCoefs$MAC,
                           countryCoefs$MYS,
                           countryCoefs$NLD,
                           countryCoefs$NOR,
                           countryCoefs$NZL,
                           countryCoefs$PER,
                           countryCoefs$POL,
                           countryCoefs$PRT,
                           countryCoefs$QAT,
                           countryCoefs$QCN,
                           countryCoefs$QRS,
                           countryCoefs$ROU,
                           countryCoefs$RUS,
                           countryCoefs$SGP,
                           countryCoefs$SVK,
                           countryCoefs$SVN,
                           countryCoefs$TUN,
                           countryCoefs$USA)
countryCoefsTable
finalOutput <- cbind(names(countryData),as.matrix(t(countryCoefsTable)))
head(finalOutput)



#######################################################
# Some old stuff/additional playing around (might not work any more)...
# Ridge
RidgeFit <- glmnet(XVariables, yMotivation, alpha = 0)
RidgeFit
plot(RidgeFit)
cvRidge <- cv.glmnet(XVariables, yMotivation)
plot(cvRidge)
coef(RidgeFit, s = 0.1)

# Lasso regression by country
glmnetFit <- function(someData) {
  y <- someData[,6]
  X <- as.matrix(someData[,c(5,7:ncol(someData))])
  glmnet(X, y)
}

glmnetCoef <- function(someData) {
  y <- someData[,6]
  X <- as.matrix(someData[,c(5,7:ncol(someData))])
  fitTemp <- glmnet(X, y, alpha = 1)
  coef(fitTemp, s=0.1)
}

countryLassoFit <- lapply(countryData, glmnetFit)
countryLassoCoefs <- lapply(countryData, glmnetCoef)

countryCoefsTable <- cbind(countryLassoCoefs$ALB,
                                countryLassoCoefs$ARE,
                                countryLassoCoefs$AUS,
                                countryLassoCoefs$AUT,
                                countryLassoCoefs$BEL,
                                countryLassoCoefs$BGR,
                                countryLassoCoefs$BRA,
                                countryLassoCoefs$CAN,
                                countryLassoCoefs$CHE,
                                countryLassoCoefs$CHL,
                                countryLassoCoefs$CRI,
                                countryLassoCoefs$CZE,
                                countryLassoCoefs$DEU,
                                countryLassoCoefs$DNK,
                                countryLassoCoefs$ESP,
                                countryLassoCoefs$EST,
                                countryLassoCoefs$FIN,
                                countryLassoCoefs$GBR,
                                countryLassoCoefs$GRC,
                                countryLassoCoefs$HKG,
                                countryLassoCoefs$HRV,
                                countryLassoCoefs$HUN,
                                countryLassoCoefs$IRL,
                                countryLassoCoefs$ISL,
                                countryLassoCoefs$ITA,
                                countryLassoCoefs$KAZ,
                                countryLassoCoefs$LIE,
                                countryLassoCoefs$LTU,
                                countryLassoCoefs$LUX,
                                countryLassoCoefs$LVA,
                                countryLassoCoefs$MAC,
                                countryLassoCoefs$MYS,
                                countryLassoCoefs$NLD,
                                countryLassoCoefs$NOR,
                                countryLassoCoefs$NZL,
                                countryLassoCoefs$PER,
                                countryLassoCoefs$POL,
                                countryLassoCoefs$PRT,
                                countryLassoCoefs$QAT,
                                countryLassoCoefs$QCN,
                                countryLassoCoefs$QRS,
                                countryLassoCoefs$ROU,
                                countryLassoCoefs$RUS,
                                countryLassoCoefs$SGP,
                                countryLassoCoefs$SVK,
                                countryLassoCoefs$SVN,
                                countryLassoCoefs$TUN,
                                countryLassoCoefs$USA)

countryLassoCoefsTable <- as.matrix(countryLassoCoefsTable)

# MLE per country
lmfunction <- function(someData) {
  lm(PersonalMotivation ~ )
}
