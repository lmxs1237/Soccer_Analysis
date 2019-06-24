library(RSQLite)
library(data.table)


csvpath = "./data/value.csv"
dbname = "./test"
tblname = "value"
## read csv
data <- fread(input = csvpath,
              sep = ",",
              header = TRUE)
## connect to database
conn <- dbConnect(drv = SQLite(), 
                  dbname = dbname)
## write table
dbWriteTable(conn = conn,
             name = tblname,
             value = data)
## list tabless
dbListTables(conn)
## disconnect
dbDisconnect(conn)
