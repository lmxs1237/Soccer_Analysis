library(DBI)
# Create an ephemeral in-memory RSQLite database
con <- dbConnect(RSQLite::SQLite(), ":test:")

dbListTables(con)

dbWriteTable(con, "mtcars", "./data/coe.csv")
dbListTables(con)
dbReadTable(con, "mtcars")
