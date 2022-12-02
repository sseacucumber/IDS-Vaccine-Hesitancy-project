###### Medicare Data 2012-21 unsmoothed actual ######
# final table is master_table.csv

# reading in each table (only has fips, county, state, and analysis_value--renamed mmd_flu_year)
# YOU MUST CTRL+F AND REMOVE ALL ' FROM .CSV BEFORE RUNNING (you can open csv in R)
flu12 = read.table("clean_mmd_flu12.csv", header=T, sep=",")
flu13 = read.table("clean_mmd_flu13.csv", header=T, sep=",")
flu14 = read.table("clean_mmd_flu14.csv", header=T, sep=",")
flu15 = read.table("clean_mmd_flu15.csv", header=T, sep=",")
flu16 = read.table("clean_mmd_flu16.csv", header=T, sep=",")
flu17 = read.table("clean_mmd_flu17.csv", header=T, sep=",")
flu18 = read.table("clean_mmd_flu18.csv", header=T, sep=",")
flu19 = read.table("clean_mmd_flu19.csv", header=T, sep=",")
flu20 = read.table("clean_mmd_flu20.csv", header=T, sep=",")
flu21 = read.table("clean_mmd_flu21.csv", header=T, sep=",")

# each iteration adds a new year of data to the table
master = merge(flu12, flu13, by="fips", all=T)
master[is.na(master)] = -99999
master = subset(master, select=-c(5,6))

master = merge(master, flu14, by="fips", all=T)
master[is.na(master)] = -99999
master = subset(master, select=-c(6,7))

master = merge(master, flu15, by="fips", all=T)
master[is.na(master)] = -99999
master = subset(master, select=-c(7,8))

master = merge(master, flu16, by="fips", all = T)
master[is.na(master)] = -99999
master = subset(master, select=-c(8,9))

master = merge(master, flu17, by="fips", all=T)
master[is.na(master)] = -99999
master = subset(master, select=-c(9,10))

master = merge(master, flu18, by='fips', all=T)
master[is.na(master)] = -99999
master = subset(master, select=-c(10,11))

master = merge(master, flu19, by="fips", all=T)
master[is.na(master)] = -99999
master = subset(master, select=-c(11,12))

master = merge(master, flu20, by="fips", all=T)
master[is.na(master)] = -99999
master = subset(master, select=-c(12,13))

master = merge(master, flu21, by="fips", all=T)
master[is.na(master)] = -99999
master = subset(master, select=-c(13,14))

# ensures that data was added correctly, ran after each merge
colnames(master)
for (i in 1:nrow(master)) {
  if (master[i,2] != master[i,13]) {
    print(i)
  }
}


# double checks accuracy of fips
for (i in 1:nrow(master_table)) {
  if (master_table$state.x[3] != "PUERTO RICO") {
    if (master_table$county.x[i] != fips_info(master_table$fips[i])[3]) {
      print(i)
    }
  }
}


# exports the master table as a .csv file
write.csv(master, file="desktop")


master_table = read.table("master_table.csv", header=T, sep=",")
pr_mt = which(master_table$state.x=="PUERTO RICO")
master_table = master_table[-pr_mt,]
#colnames(master_table)[2] = "county"


########################### Adding 2019 Census Data ###########################
############### DP05
dp05_19 = read.table("cleaned_dp05_2019.csv", header=T, sep=",")
dp05_19 = subset(dp05_19, select=-c(1))

# deletes Puerto Rico data
pr_dp = which(dp05_19$state.2019=="Puerto Rico")
dp05_19 = dp05_19[-pr_dp,]


# merge data tables on fips
master_table = merge(master_table, dp05_19, by="fips", all=T)


############### DP02
dp02_19 = read.table("cleaned_dp02_2019.csv", header=T, sep=",")
dp02_19 = subset(dp02_19, select=-c(1))
master_table = merge(master_table, dp02_19, by="fips", all=T)



