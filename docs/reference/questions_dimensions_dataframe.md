# Build a question-to-dimension mapping table

Returns a data frame that maps each question to its dimension, including
questionrder, short dimension name, and full dimension description.
Useful for documenting scoring keys and validating test structure.

## Usage

``` r
questions_dimensions_dataframe(
  key,
  dimensions,
  elaborate_dimensions,
  questions
)
```

## Arguments

- key:

  Integer vector. Each element indicates which dimension the
  corresponding question belongs to. Values must be consecutive integers
  starting from 1 up to the number of dimensions.

- dimensions:

  Character vector. Short dimension names, one per dimension. Length
  must equal `max(key)`.

- elaborate_dimensions:

  Character vector. Full dimension descriptions, one per dimension.
  Length must equal `max(key)`.

- questions:

  Character vector. Question labels in the same order as `key`. Length
  must equal `length(key)`.

## Value

A data frame with one row per question and four columns:

- ORDER:

  The question's position index within its dimension.

- DIMENSION:

  The short dimension name the question belongs to.

- ELABORATE DIMENSION:

  The full dimension description.

- QUESTION:

  The question label.

## See also

[`questions_by_keys`](https://sedzinfo.github.io/rwf/reference/questions_by_keys.md)

## Examples

``` r
key <- c(1, 2, 3, 4, 5, 1, 2, 3, 4, 5)
dimensions <- paste0("Dimension", 1:10)
elaborate_dimensions <- paste0("Elaborated_Dimension", 1:10)
questions <- paste0("Question", 1:65)
questions_dimensions_dataframe(key, dimensions, elaborate_dimensions, questions)
#>    ORDER  DIMENSION   ELABORATE DIMENSION   QUESTION
#> 1      1 Dimension1 Elaborated_Dimension1  Question1
#> 2      6 Dimension1 Elaborated_Dimension1  Question6
#> 3      2 Dimension2 Elaborated_Dimension2  Question2
#> 4      7 Dimension2 Elaborated_Dimension2  Question7
#> 5      3 Dimension3 Elaborated_Dimension3  Question3
#> 6      8 Dimension3 Elaborated_Dimension3  Question8
#> 7      4 Dimension4 Elaborated_Dimension4  Question4
#> 8      9 Dimension4 Elaborated_Dimension4  Question9
#> 9      5 Dimension5 Elaborated_Dimension5  Question5
#> 10    10 Dimension5 Elaborated_Dimension5 Question10
```
