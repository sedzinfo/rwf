# Recoding and stacking data

## Description

This shows the output of recoding functions from the package rwf. The
functions stack a list of data frames into one data frame, reverse-score
a vector (for example reverse-keyed Likert items), turn
multiple-response answers into binary dummy columns, and collapse rare
factor levels into a single “Other” level. Each section gives the rule
the function applies.

Installation instructions for rwf can be found
[here](https://github.com/sedzinfo/rwf)

The code can be found
[here](https://github.com/sedzinfo/rwf/blob/main/rwf/R/FUNCTIONS_RECODE.R)

## Notation

x_1,\dots,x_n are the values of the input vector and \mathbf{1}\[\cdot\]
is 1 when the condition is true and 0 otherwise. \|S\| is the number of
elements of a set S.

## flatten_list

Stacks the elements of a list L=\\L_1,\dots,L_K\\ into one data frame.
Each element L_k is converted to a data frame with n_k rows, the data
frames are placed under each other, and a `.id` column records the name
of the element each row came from:

\text{rows}=\sum\_{k=1}^{K}n_k,\qquad
\texttt{.id}\_i=\operatorname{name}(L_k)\\ \text{ for every row } i
\text{ that comes from } L_k

Columns with the same name are matched; a column missing from an element
is filled with `NA`.

``` r

results <- list(sample_a = data.frame(mean = 10.2, sd = 1.1, n = 30),
                sample_b = data.frame(mean = 11.8, sd = 1.4, n = 25),
                sample_c = data.frame(mean = 9.7, sd = 0.9, n = 41))
flatten_list(results)
```

    ##        .id mean  sd  n
    ## 1 sample_a 10.2 1.1 30
    ## 2 sample_b 11.8 1.4 25
    ## 3 sample_c  9.7 0.9 41

Vectors become one-column data frames:

``` r

flatten_list(list(group1 = 1:3, group2 = 4:5))
```

    ##      .id x
    ## 1 group1 1
    ## 2 group1 2
    ## 3 group1 3
    ## 4 group2 4
    ## 5 group2 5

## swap

Reverse-scores a vector by mirroring its distinct observed values. With
v\_{(1)}\<v\_{(2)}\<\dots\<v\_{(m)} the m distinct non-missing values in
sorted order, each value is replaced by the value at the mirrored
position:

x_i=v\_{(r)}\\ \Rightarrow\\ x_i'=v\_{(m+1-r)}

When the observed values are all the consecutive integers from a to b,
this is the usual reverse-scoring formula:

x_i'=a+b-x_i

Missing values stay missing, and the result has the same class as the
input (numeric, integer or character).

``` r

likert <- c(1, 2, 3, 4, 5, 5, 4, 1)
swap(likert)
```

    ## [1] 5 4 3 2 1 1 2 5

``` r

all.equal(swap(likert), 1 + 5 - likert)
```

    ## [1] TRUE

Only the **observed** values are mirrored, not the full scale. If a 1–5
item has no answers of 4, the observed values are 1, 2, 3, 5: 1 and 5
swap, 2 and 3 swap, and a+b-x no longer applies:

``` r

likert_gap <- c(1, 2, 3, 5, 5)
swap(likert_gap)
```

    ## [1] 5 3 2 1 1

``` r

6 - likert_gap
```

    ## [1] 5 4 3 1 1

Numbers are sorted by value and text alphabetically, so text categories
are mirrored in alphabetical order, not in their meaning:

``` r

swap(c("low", "mid", "high", "low"))
```

    ## [1] "low"  "high" "mid"  "low"

## dummy_arrange

Turns multiple-response answers into binary dummy columns. Each element
i holds one or more responses separated by commas, giving a set S_i (an
empty element gives S_i=\varnothing). The columns are all responses
given by anyone, sorted as text:

\mathcal{K}=\bigcup\_{i=1}^{n}S_i,\qquad D\_{ik}=\mathbf{1}\left\[k\in
S_i\right\],\quad i=1,\dots,n,\quad k\in\mathcal{K}

Row sums give the number of responses each person chose,
\sum\_{k}D\_{ik}=\|S_i\|, and column sums give how often each response
was chosen. The function returns the 1s and 0s as text, so convert them
to numbers before summing:

``` r

answers <- c("Email,Phone", "Phone", "Post,Email,Phone", "", "Email")
dummies <- dummy_arrange(answers)
dummies
```

    ##   Email Phone Post
    ## 1     1     1    0
    ## 2     0     1    0
    ## 3     1     1    1
    ## 4     0     0    0
    ## 5     1     0    0

``` r

dummies <- data.frame(lapply(dummies, as.numeric))
rowSums(dummies)
```

    ## [1] 2 1 3 0 1

``` r

colSums(dummies)
```

    ## Email Phone  Post 
    ##     3     3     1

Single responses work the same way. Because columns are sorted as text,
numeric responses sort as `1`, `10`, `2`:

``` r

dummy_arrange(c("1,10", "2", "10,2"))
```

    ##   1 10 2
    ## 1 1  1 0
    ## 2 0  0 1
    ## 3 0  1 1

`generate_multiple_response_vector` from rwf simulates multiple-response
data; `gsub` removes the spaces after the commas:

``` r

set.seed(1)
responses <- gsub(" ", "", generate_multiple_response_vector(responses = c("Agree", "Hi", "All"), responded = 1:3, length = 6), fixed = TRUE)
responses
```

    ## [1] "All"          "Hi"           "All"          "Hi,All,Agree" "Agree,All,Hi" "Hi,All"

``` r

dummy_arrange(responses)
```

    ##   Agree All Hi
    ## 1     0   1  0
    ## 2     0   0  1
    ## 3     0   1  0
    ## 4     1   1  1
    ## 5     1   1  1
    ## 6     0   1  1

## drop_levels

Collapses rare levels of each factor into a single level `"Other"` and
removes unused levels. With
n\_\ell=\sum\_{i=1}^{n}\mathbf{1}\[x_i=\ell\] the frequency of level
\ell and c = `minimum_frequency`:

x_i'=\begin{cases}\text{"Other"} & n\_{x_i}\le c\\ x_i &
n\_{x_i}\>c\end{cases}

Levels with no observations (n\_\ell=0\le c) are removed. All factor
columns are processed, or only the columns in `factor_index`; other
columns are left unchanged.

``` r

df <- data.frame(id = 1:12,
                 city = factor(c(rep("Athens", 6), rep("Patras", 3), rep("Volos", 2), "Chania"),
                               levels = c("Athens", "Patras", "Volos", "Chania", "Larissa")),
                 group = factor(rep(c("x", "y"), 6)))
table(df$city)
```

    ## 
    ##  Athens  Patras   Volos  Chania Larissa 
    ##       6       3       2       1       0

With c=2, Volos (2) and Chania (1) become “Other” and the empty level
Larissa is removed:

``` r

table(drop_levels(df, factor_index = 2, minimum_frequency = 2)$city)
```

    ## 
    ## Athens Patras  Other 
    ##      6      3      3

The comparison is \le, so with c=3 Patras (exactly 3) is collapsed too:

``` r

table(drop_levels(df, factor_index = 2, minimum_frequency = 3)$city)
```

    ## 
    ## Athens  Other 
    ##      6      6

Without `factor_index`, every factor is processed. With c=6 no level of
either factor has more than 6 cases (Athens and both levels of `group`
have exactly 6), so each factor collapses into a single “Other” level:

``` r

result <- drop_levels(df, minimum_frequency = 6)
table(result$city)
```

    ## 
    ## Other 
    ##    12

``` r

table(result$group)
```

    ## 
    ## Other 
    ##    12
