# Plot thurstonian icc

Plot icc curves, computed with the compute_icc_thurstonian function, for
binary thurstonian coded items for a single dimension

## Usage

``` r
plot_icc_thurstonian(mydata, title = "Item Characteristic Curve")
```

## Arguments

- mydata:

  dataframe from compute_icc_thurstonian function

- title:

  plot title

## Examples

``` r
gamma<-c(0.556,-1.253,-1.729,0.618,0.937,0.295,-0.672,-1.127,-0.446,0.632,1.147,0.498)
psi<-c(2.172,1.883,2.055,1.869,2.231,2.100,1.762,1.803,1.565,1.892,1.794,1.686)
lambda<-c(1.082,1.082,-1.297,-1.297,0.802,0.802,1.083,1.083)
gamma<-gamma[response_dimension(c(1:12),3,c(1,2))]
psi<-psi[response_dimension(c(1:12),3,c(1,2))]
eta<-seq(-6,6,by=1)
result<-compute_icc_thurstonian(eta=eta,gamma=gamma,lambda=lambda,psi=psi,plot=TRUE)
plot_icc_thurstonian(result$icc)
```
