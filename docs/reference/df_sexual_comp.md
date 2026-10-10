# Sexual Compatibility Data

Responses from 3,376 participants to a 10-item sexual compatibility
questionnaire. The dataset is used as a teaching example in the
researchpy Python statistics tutorials. The exact item wording is not
publicly documented by the original source.

## Usage

``` r
df_sexual_comp
```

## Format

A data frame with 3376 rows and 13 variables. Each of Q1-Q10 is rated on
a 0-4 scale; `score` is the unweighted sum (range 0-40). Note: age value
999 is a missing-data code; gender codes 0 and 3 are rare and likely
represent missing or other responses.

- Q1:

  Sexual compatibility item 1 (0-4)

- Q2:

  Sexual compatibility item 2 (0-4)

- Q3:

  Sexual compatibility item 3 (0-4)

- Q4:

  Sexual compatibility item 4 (0-4)

- Q5:

  Sexual compatibility item 5 (0-4)

- Q6:

  Sexual compatibility item 6 (0-4)

- Q7:

  Sexual compatibility item 7 (0-4)

- Q8:

  Sexual compatibility item 8 (0-4)

- Q9:

  Sexual compatibility item 9 (0-4)

- Q10:

  Sexual compatibility item 10 (0-4)

- score:

  Total scale score (sum of Q1-Q10, range 0-40)

- gender:

  Gender (1=Male, 2=Female; 0 and 3 = missing / other)

- age:

  Age in years (999 = missing)

## Source

researchpy Data-sets repository
(<https://github.com/researchpy/Data-sets>)

## Examples

``` r
data(df_sexual_comp)
head(df_sexual_comp)
#>   Q1 Q2 Q3 Q4 Q5 Q6 Q7 Q8 Q9 Q10 score gender age
#> 1  1  1  2  1  1  4  2  3  3   1    19      1  41
#> 2  2  1  1  1  1  2  1  2  1   2    14      1  50
#> 3  2  1  1  1  1  4  1  1  1   2    15      1  23
#> 4  2  1  1  1  1  4  1  1  1   4    17      1  42
#> 5  1  1  1  1  1  2  1  1  1   1    11      2  36
#> 6  2  3  2  1  2  4  1  4  4   1    24      1  29
```
