library(stringr)
library(RMySQL)

MySQL_Username <- "XXXXXXXXXX"
MySQL_Password <- "XXXXXXXXXX"

JA_Data <- read.csv("https://raw.githubusercontent.com/juddanderman/cuny-data-607/master/Project3/linkedin-profiles-skills.csv", encoding="UTF-8", na.strings=c("","NA"), stringsAsFactors = F)
JA_Data <- cbind("LinkedIn", JA_Data[ , c(10,3,4,2,5,6)], NA)
JA_Data[ , 2] <- tolower(JA_Data[ , 2])
JA_Data[ , 2] <- iconv(JA_Data[ , 2], from = "latin1", to = "UTF-8")
JA_Data <- unique(JA_Data)
JA_Data$ID <- seq.int(nrow(JA_Data))
colnames(JA_Data) <- c("Source","Skill","Title","Location","Name","School","Degree","Company","Record_ID")
t(head(JA_Data, 1))

KC_Data <- read.csv("https://raw.githubusercontent.com/cunyauthor/Project3/master/API_Job.csv", encoding="UTF-8", na.strings=c("","NA"), stringsAsFactors = F)
KC_Data <- KC_Data[KC_Data[ , 1] != "count",] # Remove heading rows
KC_Data <- KC_Data[!is.na(KC_Data[ , 5]),] # Remove rows with blank skills
KC_Data <- cbind(Source = "KDnuggets+Dice", KC_Data[ , c(5,7,9)], NA, NA, NA, KC_Data[ , 8])
KC_Data[ , 2]  <- as.character(str_extract_all(KC_Data[ , 2] , "l\\=\\S+\\&c"))
KC_Data[ , 2]  <- str_replace_all(KC_Data[ , 2] , "(l\\=|\\&c)", "")
KC_Data[ , 2]  <- str_replace_all(KC_Data[ , 2] , "\\+", " ")
KC_Data$ID <- seq.int(nrow(KC_Data))
colnames(KC_Data) <- c("Source","Skill","Title","Location","Name","School","Degree","Company","Record_ID")
t(head(KC_Data, 1))

Dice_Freq <- read.csv("https://raw.githubusercontent.com/juddanderman/cuny-data-607/master/Project3/dice-listings-skills.csv", encoding="UTF-8", na.strings=c("","NA"), stringsAsFactors = F, row.names = 1)
Dice_Freq[ , 1] <- iconv(Dice_Freq[ , 1], from = "latin1", to = "UTF-8")
colnames(Dice_Freq) <- c("Skill","Count","Frequency")
t(head(Dice_Freq, 1))

connection <- dbConnect(MySQL(), user=MySQL_Username, password=MySQL_Password)

dbSendQuery(connection, 'CREATE SCHEMA IF NOT EXISTS Skills;')
dbSendQuery(connection, 'USE Skills;')
dbSendQuery(connection, 'DROP TABLE IF EXISTS tbl_LinkedIn;')
dbSendQuery(connection, 'DROP TABLE IF EXISTS tbl_KDnuggets_Dice;')
dbSendQuery(connection, 'DROP TABLE IF EXISTS tbl_Skill_Freq;')

dbWriteTable(connection, "tbl_LinkedIn", JA_Data, append = TRUE, row.names = FALSE)
dbSendQuery(connection, "ALTER TABLE tbl_LinkedIn
            MODIFY COLUMN Record_id MEDIUMINT NOT NULL,
            MODIFY COLUMN Source VARCHAR(25) NOT NULL,
            MODIFY COLUMN Skill VARCHAR(50) NOT NULL,
            MODIFY COLUMN Title VARCHAR(250) NULL,
            MODIFY COLUMN Location VARCHAR(50) NULL,
            MODIFY COLUMN Name VARCHAR(50) NULL,
            MODIFY COLUMN School VARCHAR(75) NULL,
            MODIFY COLUMN Degree VARCHAR(100) NULL,
            MODIFY COLUMN Company VARCHAR(50) NULL,
            ADD PRIMARY KEY (Record_id);")

dbWriteTable(connection, "tbl_KDnuggets_Dice", KC_Data, append = TRUE, row.names = FALSE)
dbSendQuery(connection, "ALTER TABLE tbl_KDnuggets_Dice
            MODIFY COLUMN Record_id MEDIUMINT NOT NULL,
            MODIFY COLUMN Source VARCHAR(25) NOT NULL,
            MODIFY COLUMN Skill VARCHAR(50) NOT NULL,
            MODIFY COLUMN Title VARCHAR(250) NULL,
            MODIFY COLUMN Location VARCHAR(50) NULL,
            MODIFY COLUMN Name VARCHAR(50) NULL,
            MODIFY COLUMN School VARCHAR(75) NULL,
            MODIFY COLUMN Degree VARCHAR(100) NULL,
            MODIFY COLUMN Company VARCHAR(50) NULL,
            ADD PRIMARY KEY (Record_id);")

dbWriteTable(connection, "tbl_Skill_Freq", Dice_Freq, append = TRUE, row.names = FALSE)
dbSendQuery(connection, "ALTER TABLE tbl_Skill_Freq
            MODIFY COLUMN Skill VARCHAR(50) NOT NULL,
            MODIFY COLUMN Count INT NOT NULL,
            MODIFY COLUMN Frequency DOUBLE NOT NULL,
            ADD PRIMARY KEY (Skill);")

All_Data <- dbGetQuery(connection, "SELECT * FROM 
                       (SELECT * FROM tbl_linkedin UNION
                       SELECT * FROM tbl_KDnuggets_Dice) AS A
                       LEFT JOIN tbl_Skill_Freq AS B
                       ON A.Skill = B.Skill
                       ORDER BY A.Source, A.Skill, A.Title")

dbSendQuery(connection, 'DROP TABLE tbl_LinkedIn;')
dbSendQuery(connection, 'DROP TABLE tbl_KDnuggets_Dice;')
dbSendQuery(connection, 'DROP TABLE tbl_Skill_Freq;')
dbSendQuery(connection, 'DROP SCHEMA Skills;')
connection <- dbConnect(MySQL(), user=MySQL_Username, password=MySQL_Password)
dbDisconnect(connection)