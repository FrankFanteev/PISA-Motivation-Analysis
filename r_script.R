library(RMySQL)
library(dplyr)
library(glmnet)
library(googleVis)
library(ggplot2)
library(plotGoogleMaps)
library(tidyr)
#setwd("/home/angus/Data science masters course/T1 group project/script")

# Linking up to MySQL
#pisaDB <- dbConnect(MySQL(), user='root', password='AnguSQL', dbname='pisa', host='localhost')
pisaDB <- dbConnect(MySQL(), user='root', password='', dbname='pisa', host='localhost')

# Obtaining data from view
dbView <- dbSendQuery(pisaDB, "select * from view_analysis")
combinedData <- fetch(dbView, n=-1)

# Changing macro-economic factors to NA if 0
combinedData$Happy_index <- ifelse(combinedData$Happy_index == 0, NA, combinedData$Happy_index)
combinedData$Exp_Educ_pct <- ifelse(combinedData$Exp_Educ_pct == 0, NA, combinedData$Exp_Educ_pct)
combinedData$GDP_pc <- ifelse(combinedData$GDP_pc == 0, NA, combinedData$GDP_pc)
combinedData$GINI <- ifelse(combinedData$GINI == 0, NA, combinedData$GINI)
combinedData$Gov_expen_per_student_pct <- ifelse(combinedData$Gov_expen_per_student_pct == 0, NA, combinedData$Gov_expen_per_student_pct)
combinedData$House_final_cons_exp_pc <- ifelse(combinedData$House_final_cons_exp_pc == 0, NA, combinedData$House_final_cons_exp_pc)
combinedData$Labor_force_tertiary_educ_pct <- ifelse(combinedData$Labor_force_tertiary_educ_pct == 0, NA, combinedData$Labor_force_tertiary_educ_pct)
combinedData$AreaSize <- ifelse(combinedData$AreaSize == 7, NA, ifelse(combinedData$AreaSize == 8, NA, ifelse(combinedData$AreaSize == 9, NA, combinedData$AreaSize)))
combinedData$ClassSize <- ifelse(combinedData$ClassSize == 97, NA, ifelse(combinedData$ClassSize == 98, NA, ifelse(combinedData$ClassSize == 99, NA, combinedData$ClassSize)))
combinedData$AchievementsPubPost <- ifelse(combinedData$AchievementsPubPost == -7, NA, ifelse(combinedData$AchievementsPubPost == -6, NA, ifelse(combinedData$AchievementsPubPost == -5, NA, combinedData$AchievementsPubPost)))

# Combining and normalising relevant columns
combinedDataAddColumns <- combinedData %>% mutate(PossessionsNonStudy = PossessionsNonStudyArt+PossessionsNonStudyPoetry+PossessionsNonStudyNoOfBooks+PossessionsNonStudyLiterature+PossessionsNonStudyDictionary,
                                                  PossessionsWealth = PossessionsWealthCellPhones+PossessionsWealthTVs+PossessionsWealthComputers+PossessionsWealthCars+PossessionsWealthBathrooms+PossessionsWealthDVD,
                                                  Enjoyment = Enjoyment1+Enjoyment2+Enjoyment3+Enjoyment4,
                                                  MotivatingFactors = MotivatingFactors1+MotivatingFactors2+MotivatingFactors3+MotivatingFactors4,
                                                  SenseOfBelonging = SenseOfBelonging1+SenseOfBelonging2+SenseOfBelonging3+SenseOfBelonging4+SenseOfBelonging5+SenseOfBelonging6+SenseOfBelonging7+SenseOfBelonging8+SenseOfBelonging9,
                                                  AttitudeToSchool = AttitudeToSchool1+AttitudeToSchool2+AttitudeToSchool3+AttitudeToSchool4+AttitudeToSchool5+AttitudeToSchool6+AttitudeToSchool7+AttitudeToSchool8,
                                                  PerceivedControl = PerceivedControl1+PerceivedControl2+PerceivedControl3+PerceivedControl4+PerceivedControl5+PerceivedControl6)

combinedDataAddColumns$Happy_index <- (combinedDataAddColumns$Happy_index - mean(combinedDataAddColumns$Happy_index, na.rm = TRUE))/sd(combinedDataAddColumns$Happy_index, na.rm = TRUE)
combinedDataAddColumns$Exp_Educ_pct <- (combinedDataAddColumns$Exp_Educ_pct - mean(combinedDataAddColumns$Exp_Educ_pct, na.rm = TRUE))/sd(combinedDataAddColumns$Exp_Educ_pct, na.rm = TRUE)
combinedDataAddColumns$GDP_pc <- (combinedDataAddColumns$GDP_pc - mean(combinedDataAddColumns$GDP_pc, na.rm = TRUE))/sd(combinedDataAddColumns$GDP_pc, na.rm = TRUE)
combinedDataAddColumns$GINI <- (combinedDataAddColumns$GINI - mean(combinedDataAddColumns$GINI, na.rm = TRUE))/sd(combinedDataAddColumns$GINI, na.rm = TRUE)
combinedDataAddColumns$Gov_expen_per_student_pct <- (combinedDataAddColumns$Gov_expen_per_student_pct - mean(combinedDataAddColumns$Gov_expen_per_student_pct, na.rm = TRUE))/sd(combinedDataAddColumns$Gov_expen_per_student_pct, na.rm = TRUE)
combinedDataAddColumns$House_final_cons_exp_pc <- (combinedDataAddColumns$House_final_cons_exp_pc - mean(combinedDataAddColumns$House_final_cons_exp_pc, na.rm = TRUE))/sd(combinedDataAddColumns$House_final_cons_exp_pc, na.rm = TRUE)
combinedDataAddColumns$Labor_force_tertiary_educ_pct <- (combinedDataAddColumns$Labor_force_tertiary_educ_pct - mean(combinedDataAddColumns$Labor_force_tertiary_educ_pct, na.rm = TRUE))/sd(combinedDataAddColumns$Labor_force_tertiary_educ_pct, na.rm = TRUE)

combinedDataAddColumns$PersonalMotivation <- (combinedDataAddColumns$PersonalMotivation - mean(combinedDataAddColumns$PersonalMotivation, na.rm = TRUE))/sd(combinedDataAddColumns$PersonalMotivation, na.rm = TRUE)
combinedDataAddColumns$MotherEducation <- (combinedDataAddColumns$MotherEducation - mean(combinedDataAddColumns$MotherEducation, na.rm = TRUE))/sd(combinedDataAddColumns$MotherEducation, na.rm = TRUE)
combinedDataAddColumns$FatherEducation <- (combinedDataAddColumns$FatherEducation - mean(combinedDataAddColumns$FatherEducation, na.rm = TRUE))/sd(combinedDataAddColumns$FatherEducation, na.rm = TRUE)
combinedDataAddColumns$PossessionsNonStudy <- (combinedDataAddColumns$PossessionsNonStudy - mean(combinedDataAddColumns$PossessionsNonStudy, na.rm = TRUE))/sd(combinedDataAddColumns$PossessionsNonStudy, na.rm = TRUE)
combinedDataAddColumns$PossessionsWealth <- (combinedDataAddColumns$PossessionsWealth - mean(combinedDataAddColumns$PossessionsWealth, na.rm = TRUE))/sd(combinedDataAddColumns$PossessionsWealth, na.rm = TRUE)
combinedDataAddColumns$Enjoyment <- (combinedDataAddColumns$Enjoyment - mean(combinedDataAddColumns$Enjoyment, na.rm = TRUE))/sd(combinedDataAddColumns$Enjoyment, na.rm = TRUE)
combinedDataAddColumns$MotivatingFactors <- (combinedDataAddColumns$MotivatingFactors - mean(combinedDataAddColumns$MotivatingFactors, na.rm = TRUE))/sd(combinedDataAddColumns$MotivatingFactors, na.rm = TRUE)
combinedDataAddColumns$SenseOfBelonging <- (combinedDataAddColumns$SenseOfBelonging - mean(combinedDataAddColumns$SenseOfBelonging, na.rm = TRUE))/sd(combinedDataAddColumns$SenseOfBelonging, na.rm = TRUE)
combinedDataAddColumns$AttitudeToSchool <- (combinedDataAddColumns$AttitudeToSchool - mean(combinedDataAddColumns$AttitudeToSchool, na.rm = TRUE))/sd(combinedDataAddColumns$AttitudeToSchool, na.rm = TRUE)
combinedDataAddColumns$PerceivedControl <- (combinedDataAddColumns$PerceivedControl - mean(combinedDataAddColumns$PerceivedControl, na.rm = TRUE))/sd(combinedDataAddColumns$PerceivedControl, na.rm = TRUE)

combinedDataAddColumns$AreaSize <- (combinedDataAddColumns$AreaSize - mean(combinedDataAddColumns$AreaSize, na.rm = TRUE))/sd(combinedDataAddColumns$AreaSize, na.rm = TRUE)
combinedDataAddColumns$ClassSize <- (combinedDataAddColumns$ClassSize - mean(combinedDataAddColumns$ClassSize, na.rm = TRUE))/sd(combinedDataAddColumns$ClassSize, na.rm = TRUE)

# Lasso regression on whole dataset
wholeWorldData <- combinedDataAddColumns[complete.cases(combinedDataAddColumns[,c(-5, -8)]),c(-5, -8)]
yMotivation <- wholeWorldData[,12]
XVariables <- as.matrix(wholeWorldData[,c(4:8,11,13:20,40:52,76:85)])

worldFit <- glmnet(XVariables, yMotivation)
worldCoefs <- coef(worldFit, s=0.015)

finalWorldXVariables <- as.matrix(wholeWorldData[,c(4:6,8,11,15:19,40:43,45:48,52,77,79:85)])
finalWorld <- glmnet(finalWorldXVariables, yMotivation)
finalWorldCoefs <- as.matrix(coef(finalWorld, s=0))
write.csv(finalWorldCoefs, "finalWorldCoefs.csv")
finalWorldCoefs <- read.csv("finalWorldCoefs.csv")
finalWorldCoefs[["sign"]] <- ifelse(finalWorldCoefs[["X1"]] >= 0, "positive", "negative")
finalWorldCoefs <- finalWorldCoefs[2:nrow(finalWorldCoefs),]
finalWorldCoefs[["label"]] <- c("Country happiness index", "Country GDP pc", "Country GINI", "Country education level",
                               "Gender", "Possessions - study place", "Possessions - computer", "Possessions - software", "Possessions - internet", "Possessions - textbooks",
                               "At home mother", "At home father", "At home brothers", "At home sisters", "Mother employed", "Father employed", "Mother education", "Father education", "Foreign language at home",
                               "Class size", "Literature, art, poetry...", "Wealth", "Enjoyment", "Motivating factors", "Sense of belonging", "Attitude to school", "Perceived control")

worldCoefsBarchart <- ggplot(finalWorldCoefs, aes(x = finalWorldCoefs$label, y = finalWorldCoefs$X1, fill = sign)) +
  geom_bar(stat="identity") +
  ggtitle("Factors which affect students' motivation") +
  ylab("Influence on motivation") +
  xlab("Factors") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1), legend.position="none") +
  scale_fill_manual(values = c("positive" = "springgreen", "negative" = "tomato3"))

png(filename="worldCoefsBarchart.png")
plot(worldCoefsBarchart)
dev.off()

# Creating function to extract variables for regression by country (i.e. excludes macro variables)
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

coefs <- coef(fit, s=0)

# splitting data by country
countryData <- split(combinedDataAddColumns, combinedDataAddColumns$Code2)

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

# Creating table of coefficients for each country
countryCoefsTable <- cbind(countryCoefs$AL,
                           countryCoefs$AE,
                           countryCoefs$AU,
                           countryCoefs$AT,
                           countryCoefs$BE,
                           countryCoefs$BG,
                           countryCoefs$BR,
                           countryCoefs$CA,
                           countryCoefs$CH,
                           countryCoefs$CL,
                           countryCoefs$CR,
                           countryCoefs$CZ,
                           countryCoefs$DE,
                           countryCoefs$DK,
                           countryCoefs$ES,
                           countryCoefs$EE,
                           countryCoefs$FI,
                           countryCoefs$GB,
                           countryCoefs$GR,
                           countryCoefs$HK,
                           countryCoefs$HR,
                           countryCoefs$HU,
                           countryCoefs$IE,
                           countryCoefs$IS,
                           countryCoefs$IT,
                           countryCoefs$KZ,
                           countryCoefs$LI,
                           countryCoefs$LT,
                           countryCoefs$LU,
                           countryCoefs$LV,
                           countryCoefs$MO,
                           countryCoefs$MY,
                           countryCoefs$NL,
                           countryCoefs$NO,
                           countryCoefs$NZ,
                           countryCoefs$PE,
                           countryCoefs$PL,
                           countryCoefs$PT,
                           countryCoefs$QA,
                           countryCoefs$RU,
                           countryCoefs$RO,
                           countryCoefs$SG,
                           countryCoefs$SK,
                           countryCoefs$SI,
                           countryCoefs$TN,
                           countryCoefs$US)

finalOutput <- as.data.frame(as.matrix(t(countryCoefsTable)))
finalOutput$country <- names(countryData) 

# output html heatmaps to be included in app
geoGender <- gvisGeoChart(finalOutput, locationvar =  "country", colorvar= "Gender")
cat(geoGender$html$chart, file = "genderHeatmap.html")

geoStudyDesk <- gvisGeoChart(finalOutput, locationvar =  "country", colorvar= "PossessionsStudyDesk")
cat(geoStudyDesk$html$chart, file = "studyDeskHeatmap.html")

geoStudyOwnRoom <- gvisGeoChart(finalOutput, locationvar =  "country", colorvar= "PossessionsStudyOwnRoom")
cat(geoStudyOwnRoom$html$chart, file = "studyOwnRoomHeatmap.html")

geoStudyPlace <- gvisGeoChart(finalOutput, locationvar =  "country", colorvar= "PossessionsStudyStudyPlace")
cat(geoStudyPlace$html$chart, file = "studyPlaceHeatMap.html")

geoStudyComputer <- gvisGeoChart(finalOutput, locationvar =  "country", colorvar= "PossessionsStudyComputer")
cat(geoStudyComputer$html$chart, file = "studyComputerHeatMap.html")

geoStudySoftware <- gvisGeoChart(finalOutput, locationvar =  "country", colorvar= "PossessionsStudySoftware")
cat(geoStudySoftware$html$chart, file = "studySoftwareHeatMap.html")

geoStudyInternet <- gvisGeoChart(finalOutput, locationvar =  "country", colorvar= "PossessionsStudyInternet")
cat(geoStudyInternet$html$chart, file = "studyInternetHeatMap.html")

geoStudyTextbooks <- gvisGeoChart(finalOutput, locationvar =  "country", colorvar= "PossessionsStudyTextbooks")
cat(geoStudyTextbooks$html$chart, file = "studyTextbooksHeatMap.html")

geoArtLit <- gvisGeoChart(finalOutput, locationvar =  "country", colorvar= "PossessionsNonStudy")
cat(geoArtLit$html$chart, file = "artLitHeatMap.html")

geoWealth <- gvisGeoChart(finalOutput, locationvar =  "country", colorvar= "PossessionsWealth")
cat(geoWealth$html$chart, file = "wealthHeatMap.html")

geoEnjoyment <- gvisGeoChart(finalOutput, locationvar =  "country", colorvar= "Enjoyment")
cat(geoEnjoyment$html$chart, file = "enjoymentHeatMap.html")

geoMotivatingFactors <- gvisGeoChart(finalOutput, locationvar =  "country", colorvar= "MotivatingFactors")
cat(geoMotivatingFactors$html$chart, file = "motivatingFactorsHeatMap.html")

geoAtHomeMother <- gvisGeoChart(finalOutput, locationvar =  "country", colorvar= "AtHomeMother")
cat(geoAtHomeMother$html$chart, file = "atHomeMotherHeatMap.html")

geoAtHomeFather <- gvisGeoChart(finalOutput, locationvar =  "country", colorvar= "AtHomeFather")
cat(geoAtHomeFather$html$chart, file = "atHomeFatherHeatMap.html")

geoAtHomeBrothers <- gvisGeoChart(finalOutput, locationvar =  "country", colorvar= "AtHomeBrothers")
cat(geoAtHomeBrothers$html$chart, file = "atHomeBrothersHeatMap.html")

geoAtHomeSisters <- gvisGeoChart(finalOutput, locationvar =  "country", colorvar= "AtHomeSisters")
cat(geoAtHomeSisters$html$chart, file = "atHomeSistersHeatMap.html")

geoSenseOfBelonging <- gvisGeoChart(finalOutput, locationvar =  "country", colorvar= "SenseOfBelonging")
cat(geoSenseOfBelonging$html$chart, file = "senseOfBelongingHeatMap.html")

geoAttitudeToSchool <- gvisGeoChart(finalOutput, locationvar =  "country", colorvar= "AttitudeToSchool")
cat(geoAttitudeToSchool$html$chart, file = "attitudeToSchoolHeatMap.html")

geoPerceivedControl <- gvisGeoChart(finalOutput, locationvar =  "country", colorvar= "PerceivedControl")
cat(geoPerceivedControl$html$chart, file = "perceivedControlHeatMap.html")

# output table html for app
tableData <- (gather(finalOutput, "Factor", "Coefficient", 2:21))[,2:4]

tableOutput <- gvisTable(tableData, 
                      options=list(page='enable', pageSize=20, width=500))

cat(tableOutput$html$chart, file = "table.html")


########## DATA VIEW ###########

dbView2 <- dbSendQuery(pisaDB, "select * from view_countries")
combinedData <- fetch(dbView2, n=-1)

#combinedData <- read.csv("/home/viviana/Dropbox/Data Science/01 Data Warehousing and Business Intelligence/Practical_Project/data/2012/csv/country_view.csv", header= T, sep = ",", stringsAsFactors = F)

# Changing macro-economic factors to NA if 0
combinedData$Happy_index <- ifelse(combinedData$Happy_index == 0, NA, round(combinedData$Happy_index,2))
combinedData$Exp_Educ_pct <- ifelse(combinedData$Exp_Educ_pct == 0, NA, round(combinedData$Exp_Educ_pct,2))
combinedData$GDP_pc <- ifelse(combinedData$GDP_pc == 0, NA, combinedData$GDP_pc)
combinedData$GINI <- ifelse(combinedData$GINI == 0, NA, combinedData$GINI)
combinedData$Gov_expen_per_student_pct <- ifelse(combinedData$Gov_expen_per_student_pct == 0, NA, round(combinedData$Gov_expen_per_student_pct,2))
combinedData$House_final_cons_exp_pc <- ifelse(combinedData$House_final_cons_exp_pc == 0, NA, round(combinedData$House_final_cons_exp_pc,2))
combinedData$Labor_force_tertiary_educ_pct <- ifelse(combinedData$Labor_force_tertiary_educ_pct == 0, NA, round(combinedData$Labor_force_tertiary_educ_pct,2))

combinedDataAddColumns$Happy_index <- (combinedDataAddColumns$Happy_index - mean(combinedDataAddColumns$Happy_index, na.rm = TRUE))/sd(combinedDataAddColumns$Happy_index, na.rm = TRUE)
combinedDataAddColumns$Exp_Educ_pct <- (combinedDataAddColumns$Exp_Educ_pct - mean(combinedDataAddColumns$Exp_Educ_pct, na.rm = TRUE))/sd(combinedDataAddColumns$Exp_Educ_pct, na.rm = TRUE)
combinedDataAddColumns$GDP_pc <- (combinedDataAddColumns$GDP_pc - mean(combinedDataAddColumns$GDP_pc, na.rm = TRUE))/sd(combinedDataAddColumns$GDP_pc, na.rm = TRUE)
combinedDataAddColumns$GINI <- (combinedDataAddColumns$GINI - mean(combinedDataAddColumns$GINI, na.rm = TRUE))/sd(combinedDataAddColumns$GINI, na.rm = TRUE)
combinedDataAddColumns$Gov_expen_per_student_pct <- (combinedDataAddColumns$Gov_expen_per_student_pct - mean(combinedDataAddColumns$Gov_expen_per_student_pct, na.rm = TRUE))/sd(combinedDataAddColumns$Gov_expen_per_student_pct, na.rm = TRUE)
combinedDataAddColumns$House_final_cons_exp_pc <- (combinedDataAddColumns$House_final_cons_exp_pc - mean(combinedDataAddColumns$House_final_cons_exp_pc, na.rm = TRUE))/sd(combinedDataAddColumns$House_final_cons_exp_pc, na.rm = TRUE)
combinedDataAddColumns$Labor_force_tertiary_educ_pct <- (combinedDataAddColumns$Labor_force_tertiary_educ_pct - mean(combinedDataAddColumns$Labor_force_tertiary_educ_pct, na.rm = TRUE))/sd(combinedDataAddColumns$Labor_force_tertiary_educ_pct, na.rm = TRUE)

combinedDataAddColumns$PersonalMotivation <- (combinedDataAddColumns$PersonalMotivation - mean(combinedDataAddColumns$PersonalMotivation, na.rm = TRUE))/sd(combinedDataAddColumns$PersonalMotivation, na.rm = TRUE)

combinedData$year <- 2012

load(url("http://www.fabioveronesi.net/Blog/polygons.RData"))  

polygons@data = data.frame(polygons@data, combinedData[match(polygons@data[,'ISO2'], combinedData[,'code2']),])

polygons.plot <- polygons[,c("GDP.capita","Income_Group", "GINI","Happy_index", "Exp_Educ_pct", "Gov_expen_per_student_pct", "House_final_cons_exp_pc", "Labor_force_tertiary_educ_pct","NAME")]  
polygons.plot <- polygons.plot[polygons.plot$NAME!="Antarctica",]  
names(polygons.plot) <- c("GDP per capita","Income group", "GINI","Happy Index", "Expenditure on education (%GDP)", "Government Expenditure per student (%GDP pc)", "Household final consuption per capita", "Labor force with tertiary education (%)","Country Name")  


#To add this to an existing HTML page  
map <- plotGoogleMaps(polygons.plot,zoom=2,fitBounds=F,filename="Map_GoogleMaps_small.html",layerName="Economic Data",map="GoogleMap",mapCanvas="Map",map.width="800px",map.height="600px",control.width="200px",control.height="600px")  

Motion=gvisMotionChart(combinedData, 
                       idvar="country", timevar="year")
plot(Motion)
cat(unlist(Motion$html), file="motion.html")
