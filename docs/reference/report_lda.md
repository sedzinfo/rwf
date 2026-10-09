# Report for MASS::lda

Report for MASS::lda

## Usage

``` r
report_lda(model, file = NULL)
```

## Arguments

- model:

  object from MASS::lda

- file:

  output filename

## Examples

``` r
model<-MASS::lda(case~.,data=infert)
result<-report_lda(model=model)
result<-report_lda(model=model,file="lda")
model<-MASS::lda(Species~.,data=iris)
result<-report_lda(model=model,file="lda")
```
