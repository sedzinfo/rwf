# Score Multiple Thurstonian IRT Response Patterns (MAP / EBM)

Scores many respondents at once using Thurstonian IRT parameters and
returns MAP (empirical Bayes modal) latent trait estimates for each row
in patterns.

In simple terms: this function applies score_tirt_pattern to every
respondent, after first checking and aligning item columns so they match
lambda row order.

## Usage

``` r
score_tirt(patterns, lambda, theta_diag, tau, Psi, nu = NULL)
```

## Arguments

- patterns:

  A matrix or data.frame of response patterns (rows = respondents,
  columns = pair / items).

- lambda:

  Loading matrix (rows = pair / items, columns = latent traits).

- theta_diag:

  Numeric vector of residual variances aligned to rows of lambda.

- tau:

  Numeric vector of thresholds aligned to rows of lambda.

- Psi:

  Latent covariance matrix (traits x traits).

- nu:

  Optional numeric vector of indicator intercepts aligned to rows of
  lambda. If NULL, zeros are used in score_tirt_pattern.

## Value

A numeric matrix of latent scores: rows correspond to respondents in
patterns, columns correspond to traits in colnames(lambda).

## Details

Name alignment is the key safeguard: when both rownames(lambda) and
colnames(patterns) are present, patterns is reordered to match lambda
row order before scoring.

If required lambda names are missing from patterns, the function stops
with an informative error. If names are unavailable, positional
alignment is assumed and a warning is issued.

## Examples

``` r
library(thurstonianIRT)
data("triplets")
# define the blocks of items
blocks <-
  set_block(c("i1", "i2", "i3"), traits = c("t1", "t2", "t3"),
            signs = c(1, 1, 1)) +
  set_block(c("i4", "i5", "i6"), traits = c("t1", "t2", "t3"),
            signs = c(-1, 1, 1)) +
  set_block(c("i7", "i8", "i9"), traits = c("t1", "t2", "t3"),
            signs = c(1, 1, -1)) +
  set_block(c("i10", "i11", "i12"), traits = c("t1", "t2", "t3"),
            signs = c(1, -1, 1))
# generate the data to be understood by 'thurstonianIRT'
triplets_long <- make_TIRT_data(
  data = triplets, blocks = blocks, direction = "larger",
  format = "pairwise", family = "bernoulli", range = c(0, 1)
)
# fit the data using lavaan
fit <- fit_TIRT_lavaan(triplets_long)
pars <- extract_tirt_params(fit)
patterns<-as.matrix(triplets)
score_tirt(patterns,lambda=pars$lambda,theta_diag=pars$theta_diag,
           tau=pars$tau,Psi=pars$Psi,nu=NULL)
#> Error: cannot open file 'C:/Users/dzach/AppData/Local/R/win-library/4.6/rwf/R/rwf.rdb': No such file or directory
# Check same scores from thurstonianIRT package
triplets_long <- make_TIRT_data(data = triplets,
                                blocks = blocks, 
                                direction = "larger",
                                format = "pairwise", 
                                family = "bernoulli", 
                                range = c(0, 1))
scores_thurstonianIRT<-predict(fit)
scores<-score_tirt(patterns,lambda=pars$lambda,theta_diag=pars$theta_diag,
        tau=pars$tau,Psi=pars$Psi,nu=NULL)
#> Warning: restarting interrupted promise evaluation
#> Error: cannot open file 'C:/Users/dzach/AppData/Local/R/win-library/4.6/rwf/R/rwf.rdb': No such file or directory
head(reshape2::recast(scores_thurstonianIRT,formula=id~trait,id.var=1:2))
#>   id  trait1   trait2   trait3
#> 1  1  0.2996 -1.20767  0.14264
#> 2  2 -0.9155  0.85794  0.64017
#> 3  3 -0.6305  1.34407  0.87695
#> 4  4 -0.9523 -0.40027  0.06206
#> 5  5  0.9106 -0.01306 -0.10390
#> 6  6  0.5347 -0.65726 -1.49623
head(scores)
#> Error: object 'scores' not found
```
