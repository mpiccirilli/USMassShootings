# Load the required libraries

library(RCurl)
library(data.table)
library(ggmap)


# Links to the data files
link2013 <- "http://shootingtracker.com/tracker/2013MASTER.csv"
link2014 <- "http://shootingtracker.com/tracker/2014MASTER.csv"
link2015 <- "http://shootingtracker.com/tracker/2015CURRENT.csv"

x <- getURL(link2013)
shooting2013 <- setDT(read.csv(textConnection(x)))

x <- getURL(link2014)
shooting2014 <- setDT(read.csv(textConnection(x)))

x <- getURL(link2015)
shooting2015 <- setDT(read.csv(textConnection(x)))

names(shooting2013)
names(shooting2014)
names(shooting2015)

# The names in the files aren't uniform, need to chnage 2013's and remove
# the columns referencing an article for support of each observation
dtList = vector("list", 3)
dtList[[1]] = shooting2013[, .(date, shooter, killed, wounded, location)]
setnames(dtList[[1]], names(dtList[[1]]), c("Date", "Shooter", "Dead", "Injured", "Location"))
dtList[[2]] = shooting2014[, .(Date, Shooter, Dead, Injured, Location)]
dtList[[3]] = shooting2015[, .(Date, Shooter, Dead, Injured, Location)]

# Now join them all together
DT <- rbindlist(dtList)
sapply(DT, class)
head(DT)
DT[, c("Date","Shooter","Location") :=
     list(as.Date(Date, format="%m/%d/%Y"), as.character(Shooter), as.character(Location))]


# After prior inspection, I've found the follow misspellings
# or other slight variations of the same location and want to convert
DT[Location == "Queens, NY"]$Location <- "New York, NY"
DT[Location == "Bronx, NY"]$Location <- "New York, NY"
#DT[Location == "Brooklyn (Bushwick), NY"]$Location <- "New York, NY"
#DT[Location == "Brooklyn (Crown Heights), NY"]$Location <- "Brooklyn, NY"
DT[Location == "Chicago, Il"]$Location <- "Chicago, IL"
DT[Location == "New York (Queens), NY"]$Location <- "New York, NY"
DT[Location == "Manhattan, NY"]$Location <- "New York, NY"
DT[Location == "St Louis, MO"]$Location  <- "St. Louis, MO"
DT[Location == "St. Petersberg, FL"]$Location <- "St. Petersburg, FL"
DT[Location == "Phoenix, Az" ]$Location <- "Phoenix, AZ"
DT[Location == "Washington DC" | Location == "Washington, D.C."]$Location <- "Washington, DC"
DT[Location == "Saginaw, Mi"]$Location <- "Saginaw, MI"
DT[Location == "Cyprus, TX"]$Location <- "Cypress, TX"
DT[Location == "Dallas, Tx"]$Location <- "Dallas, TX"
DT[Location == "Englewood, Illinois"]$Location <- "Englewood, IL"
DT[Location == "Stockton, Ca"]$Location <- "Stockton, CA"
DT[Location == "Miami-Dade, FL"]$Location <- "Miami, FL"
DT[Location == "Oberlin, Ohio"]$Location <- "Oberlin, OH"
DT[Location == "Sarasota, Fl"]$Location <- "Sarasota, FL"
DT[Location == "Elgin, Il"]$Location <- "Elgin, IL"
DT[Location == " Fort Bend County, TX"]$Location <- "Fort Bend County, TX"
DT[Location == "Atlanta, Ga"]$Location <- "Atlanta, GA"
DT[Location == "Elgin, Il"]$Location <- "Elgin, IL"
DT[Location == "Rockford, Il"]$Location <- "Rockford, IL"
DT[Location == "Fort Lauderdale, Fl"]$Location <- "Fort Lauderdale, FL"
DT[Location == "Detroit, Mi"]$Location <- "Detroit, MI"
DT[Location == "Fort Wayne, In"]$Location <- "Fort Wayne, IN"
DT[Location == "Fort Worth, Tx"]$Location <- "Fort Worth, TX"
DT[Location == "Harvey, Louisiana"]$Location <- "Harvey, LA"
DT[Location == "Los Angelas, CA"]$Location <- "Los Angeles, CA"
DT[Location == "North Charlston, SC"]$Location <- "North Charleston, SC"
DT[Location == "Kansas City, Mo"]$Location <- "Kansas City, MO"
DT[Location == "Oklahoma City, Ok"]$Location <- "Oklahoma City, OK"
DT[Location == "Richmond, Ca"]$Location <- "Richmond, CA"
DT[Location == "Springfield, Ma"]$Location <- "Springfield, MA"
DT[Location == "San Juan, Puerto Rico"]$Location <- "San Juan, PR"
DT[Location == "Alturas, Ca"]$Location <- "Alturas, CA"
DT[Location == "Fairfield, Ca"]$Location <- "Fairfield, CA"
DT[Location == "Jackson, Tennessee"]$Location <- "Jackson, TN"
DT[68]$Location <- "Manhatten, KS"
DT[417]$Location <- "Sikeston, MO"
DT[Location == "Jacksonville, Fl"]$Location <- "Jacksonville, FL"
DT[Location == "Havey, Louisiana"]$Location <- "Harvey, LA"
DT[Location == "Ottawa, KA"]$Location <- "Ottawa, KS"
DT[Location == "Witchita, KA"]$Location <- "Wichita, KS"
DT[Location == "Parsons, KA"]$Location <- "Parsons, KS"
DT[Location == "Topeka, KA"]$Location <- "Topeka, KS"
DT[Location == "Winton Hills, OH"]$Location <- "Cincinnati, OH"

# Find the number of times each location pops up
DT[, LocationFreq := .N, by = Location]

# Create a variable of each state abbreviation:
DT[, State := substr(DT$Location,
                      start = nchar(DT$Location)-1,
                      stop = nchar(DT$Location))]
table(DT$State)
DT[, StateFreq := .N, by = State ]

# Create columns for the year, month, month-year,
# and the total number of victims (adding the killed + injured)
DT[, c("year", "month", "monthYear", "nVictims") :=
     list(year(Date), month(Date), paste0(month(Date), "-", year(Date)),Dead+Injured)]

# Here we're find the total number of victims by month-year, and by state
DT[, nMonthYearVictims := sum(nVictims), by = monthYear]
DT[, nVictimsPerState := sum(nVictims), by = State]

# We can take a look at the number of Victims per Monty by Year
ggplot(unique(DT[,.(year, month, monthYear, nMonthYearVictims)]),
       aes(x=factor(month), y=nMonthYearVictims)) +
  geom_bar(stat="identity") +
  facet_wrap(~year) + ggtitle("Number of Victims Per Month By Year")



# Top 10 State
top10StateVicts = unique(DT[, .(State, nVictimsPerState)])[
  order(-nVictimsPerState)][1:10][
    ,State := factor(State, levels = State[1:10])]


top10StateYear = unique(DT[State %in% top10StateVicts$State,
           .(year, State, nVictims)][
             ,nVictByYear := sum(nVictims), by=.(year, State) ][
               ,nVictims:=NULL][, State := factor(State, levels = top10StateVicts$State)] )

ggplot(top10StateYear, aes(x=factor(State), y=nVictByYear, fill = factor(year))) +
  geom_bar(stat="identity") + ggtitle("Top 10 States with the most victims")



DT[, nVictimsPerLocation := sum(nVictims), by = Location]
DT[, nVictimsPerIncident := nVictimsPerLocation / LocationFreq]

# Now let's plot this stuff on a map
# We'll need to get the lon-lat coordinates
# As of 10/3/2015, there are 504 unique locations
# and this takes approximately 2 minutes
uniqueLocations <- unique(DT$Location)
coords <- suppressMessages(geocode(uniqueLocations))

locationCoords = data.table(Location = uniqueLocations,
                            lon = coords$lon,
                            lat = coords$lat, key="Location")

# Bring in the lat-lon coordinates
setkey(DT, Location)
DT = locationCoords[DT]

### Make the map
myMap <- suppressMessages(get_map(location = 'united states',
                                zoom = 4, source = 'google'))

# Plot two maps, not sure if there's going to be any noticable difference
# 1) avg number of victims per incident at each location
# 2) total number of victims at each location

forMap1 <- unique( DT[, .(lon, lat, nVictimsPerIncident)] )
p1 <- suppressMessages( ggmap(myMap) +
                          geom_point(aes(x=lon, y=lat),
                                     data = forMap1,
                                     size=forMap1$nVictimsPerIncident,
                                     colour="red",
                                     alpha=.5) +
                                     ggtitle("Avg Number of Victims Per Incident & Location"))
print(p1)


forMap2 <- unique( DT[, .(lon, lat, nVictimsPerLocation)] )
p2 <- suppressMessages( ggmap(myMap) +
                          geom_point(aes(x=lon, y=lat),
                                     data = forMap2,
                                     size=forMap2$nVictimsPerLocation,
                                     colour="red",
                                     alpha=.5) +
                          ggtitle("Total Number of Victims Per Location"))
print(p2)
