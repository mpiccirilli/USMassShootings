This shows some visualizatios of the mass shootings in the United States since 2013. 

The data used was found here:  http://shootingtracker.com/wiki/Main_Page

The distribution of mass shootings by year
![nMonthYear](https://github.com/mpiccirilli/USMassShootings/blob/master/plots/nVictimsByMonthAndYear.jpg)


Instead of plotting the total number of victims for each city, I've taken the average number of victims per incident in each city. 
![mapPlot](https://github.com/mpiccirilli/USMassShootings/blob/master/plots/usaMap.jpg)


Since we can't see much there, we can break it down to the top 10 states.
![top10States](https://github.com/mpiccirilli/USMassShootings/blob/master/plots/Top10States.jpg)


To get a bit more granular, we can look at the the most victimous cities. Here are the top 10:
```{r}
             Location nVictimsPerLocation
 1:      Chicago, IL                 239
 2:      Detroit, MI                 105
 3:  New Orleans, LA                 102
 4:   Washington, DC                  83
 5:        Miami, FL                  83
 6:    St. Louis, MO                  79
 7:     Brooklyn, NY                  75
 8:      Houston, TX                  67
 9:    Baltimore, MD                  66
10: Philadelphia, PA                  62

```
![top10Location](https://github.com/mpiccirilli/USMassShootings/blob/master/plots/top10Location.jpg)


Interestingly, California is the state with the most victims of mass shootings however none of its cities appears in the top 10 amongst cities. Let's take a look. 

Let's find the top cities in California.  We can see that LA just misses the top 10 cities. Philly, which is in 10th above, has a few more than LA at 62 victims. 
```{r}
              Location LocationFreq nVictimsPerLocation       lon      lat
  1:   Los Angeles, CA           13                  58 -118.2484 33.97395
  2:        Fresno, CA            8                  45 -119.7349 36.86260
  3:      Stockton, CA            9                  45 -121.2908 37.95770
  4:       Oakland, CA            8                  35 -122.2238 37.78603
  5:    Sacramento, CA            7                  35 -121.5554 38.38046
  6:    Long Beach, CA            5                  21 -118.1681 33.80345
  7: San Francisco, CA            4                  21 -122.7278 37.78483
  8:       Vallejo, CA            4                  21 -122.1359 38.24489
  9:   Bakersfield, CA            4                  17 -119.0206 35.38434
 10:       Modesto, CA            3                  16 -121.0168 37.66946
```
![caliPlot](https://github.com/mpiccirilli/USMassShootings/blob/master/plots/caliMap.jpg)


