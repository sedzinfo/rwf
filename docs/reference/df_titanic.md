# Titanic Dataset

A dataset containing information about passengers on the Titanic.

## Usage

``` r
df_titanic
```

## Format

A data frame with the following variables:

- PassengerId:

  Unique identifier for each passenger

- survived:

  Survival status (0=No, 1=Yes)

- pclass:

  Passenger class (1=1st, 2=2nd, 3=3rd)

- name:

  Name of the passenger

- sex:

  Gender of the passenger

- age:

  Age of the passenger

- sibsp:

  Number of siblings / spouses aboard the Titanic

- parch:

  Number of parents / children aboard the Titanic

- ticket:

  Ticket number

- fare:

  Passenger fare

- cabin:

  Cabin number

- embarked:

  Port of embarkation (C=Cherbourg; Q=Queenstown; S=Southampton)

- boat:

  Lifeboat number

- body:

  Body number

- home.dest:

  Home destination

## Examples

``` r
data(df_titanic)
head(df_titanic)
#>   PassengerId survived pclass                                            name    sex     age sibsp parch ticket     fare   cabin embarked boat body                       home.dest
#> 1           1        1      1                   Allen, Miss. Elisabeth Walton female 29.0000     0     0  24160 211.3375      B5        S    2   NA                    St Louis, MO
#> 2           2        1      1                  Allison, Master. Hudson Trevor   male  0.9167     1     2 113781 151.5500 C22 C26        S   11   NA Montreal, PQ / Chesterville, ON
#> 3           3        0      1                    Allison, Miss. Helen Loraine female  2.0000     1     2 113781 151.5500 C22 C26        S        NA Montreal, PQ / Chesterville, ON
#> 4           4        0      1            Allison, Mr. Hudson Joshua Creighton   male 30.0000     1     2 113781 151.5500 C22 C26        S       135 Montreal, PQ / Chesterville, ON
#> 5           5        0      1 Allison, Mrs. Hudson J C (Bessie Waldo Daniels) female 25.0000     1     2 113781 151.5500 C22 C26        S        NA Montreal, PQ / Chesterville, ON
#> 6           6        1      1                             Anderson, Mr. Harry   male 48.0000     0     0  19952  26.5500     E12        S    3   NA                    New York, NY
```
