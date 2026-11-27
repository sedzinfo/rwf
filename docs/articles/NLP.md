# Natural language processing

## Description

This shows the output of functions from the package rwf that may be used
in Natural Language Processing (NLP). The functions clean text, remove
stopwords, tag parts of speech, compute text similarity between
documents, and calculate word and character statistics.

Installation instructions for rwf can be found
[here](https://github.com/sedzinfo/rwf)

The code can be found
[here](https://github.com/sedzinfo/rwf/blob/main/rwf/R/ML_NLP.R)

## Clear text

``` r

text1<-"word_one word_two word_three"
text2<-"word_three word_four word_six"
text3<-"All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessary, making this the first true generator on the Internet."
text4<-"It uses a dictionary of over 200 Latin words, combined with a handful of model sentence structures, to generate Lorem Ipsum which looks reasonable."
text5<-"The generated Lorem Ipsum is therefore always free from repetition, injected humour, or non-characteristic words etc."
text<-c(text1,text2,text3,text4,text5)
clear_text(text)
```

    ## [1] "word one word two word three"                                                                                                                     
    ## [2] "word three word four word six"                                                                                                                    
    ## [3] "all the lorem ipsum generators on the internet tend to repeat predefined chunks as necessary making this the first true generator on the internet"
    ## [4] "it uses a dictionary of over latin words combined with a handful of model sentence structures to generate lorem ipsum which looks reasonable"     
    ## [5] "the generated lorem ipsum is therefore always free from repetition injected humour or non characteristic words etc"

## Remove stopwords

``` r

text1<-"word_one word_two word_three"
text2<-"word_three word_four word_six"
text3<-"All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessary, making this the first true generator on the Internet."
text4<-"It uses a dictionary of over 200 Latin words, combined with a handful of model sentence structures, to generate Lorem Ipsum which looks reasonable."
text5<-"The generated Lorem Ipsum is therefore always free from repetition, injected humour, or non-characteristic words etc."
stopwords<-stopwords::stopwords("english")
text<-c(text1,text2,text3,text4,text5)
clear_stopwords(text,stopwords=stopwords)
```

    ## [1] "word one word two word three"                                                                                    
    ## [2] "word three word four word six"                                                                                   
    ## [3] "all lorem ipsum generators internet tend repeat predefined chunks necessary making first true generator internet"
    ## [4] "it uses dictionary latin words combined handful model sentence structures generate lorem ipsum looks reasonable" 
    ## [5] "the generated lorem ipsum therefore always free repetition injected humour non characteristic words etc"

## Part of Speech tagging

``` r

text1<-"word_one word_two word_three"
text2<-"word_three word_four word_six"
text3<-"All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessary, making this the first true generator on the Internet."
text4<-"It uses a dictionary of over 200 Latin words, combined with a handful of model sentence structures, to generate Lorem Ipsum which looks reasonable."
text5<-"The generated Lorem Ipsum is therefore always free from repetition, injected humour, or non-characteristic words etc."
text<-c(text1,text2,text3,text4,text5)
tag_pos(text)
```

    ## $POStagged
    ## [1] "word_one/NN word_two/VBD word_three/CD word_three/CD word_four/NN word_six/NN All/DT the/DT Lorem/NNP Ipsum/NNP generators/NNS on/IN the/DT Internet/NNP tend/VB to/TO repeat/VB predefined/VBN chunks/NNS as/IN necessary/JJ ,/, making/VBG this/DT the/DT first/JJ true/JJ generator/NN on/IN the/DT Internet/NNP ./. It/PRP uses/VBZ a/DT dictionary/NN of/IN over/IN 200/CD Latin/JJ words/NNS ,/, combined/VBN with/IN a/DT handful/NN of/IN model/NN sentence/NN structures/NNS ,/, to/TO generate/VB Lorem/NNP Ipsum/NNP which/WDT looks/VBZ reasonable/JJ ./. The/DT generated/VBD Lorem/NNP Ipsum/NNP is/VBZ therefore/RB always/RB free/JJ from/IN repetition/NN ,/, injected/VBD humour/NN ,/, or/CC non-characteristic/JJ words/NNS etc/FW ./."
    ## 
    ## $POStags
    ##  [1] "NN"  "VBD" "CD"  "CD"  "NN"  "NN"  "DT"  "DT"  "NNP" "NNP" "NNS" "IN"  "DT"  "NNP" "VB"  "TO"  "VB"  "VBN" "NNS" "IN"  "JJ"  ","   "VBG" "DT"  "DT"  "JJ"  "JJ"  "NN"  "IN"  "DT"  "NNP" "."  
    ## [33] "PRP" "VBZ" "DT"  "NN"  "IN"  "IN"  "CD"  "JJ"  "NNS" ","   "VBN" "IN"  "DT"  "NN"  "IN"  "NN"  "NN"  "NNS" ","   "TO"  "VB"  "NNP" "NNP" "WDT" "VBZ" "JJ"  "."   "DT"  "VBD" "NNP" "NNP" "VBZ"
    ## [65] "RB"  "RB"  "JJ"  "IN"  "NN"  ","   "VBD" "NN"  ","   "CC"  "JJ"  "NNS" "FW"  "."

## Text Similarity

``` r

text1<-"word_one word_two word_three"
text2<-"word_three word_four word_six"
text3<-"All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessary, making this the first true generator on the Internet."
text4<-"It uses a dictionary of over 200 Latin words, combined with a handful of #' model sentence structures, to generate Lorem Ipsum which looks reasonable."
text5<-"The generated Lorem Ipsum is therefore always free from repetition, injected humour, or non-characteristic words etc."
text<-c(text1,text2,text3,text4,text5)
text<-unlist(strsplit(text,split=" "))
text1<-unlist(strsplit(text1,split=" "))
text2<-unlist(strsplit(text2,split=" "))
text3<-unlist(strsplit(text3,split=" "))
text4<-unlist(strsplit(text4,split=" "))
text5<-unlist(strsplit(text5,split=" "))
compute_text_similarity(text1,text1)
```

    ##   tversky intersect intersect_weight setdiff1 setdiff2 lengtht1 lengtht2
    ## 1       1         3                3        0        0        3        3

``` r

compute_text_similarity(text1,text2)
```

    ##     tversky intersect intersect_weight setdiff1 setdiff2 lengtht1 lengtht2
    ## 1 0.3333333         1                1        2        2        3        3

``` r

compute_text_similarity(text1,text3)
```

    ##   tversky intersect intersect_weight setdiff1 setdiff2 lengtht1 lengtht2
    ## 1       0         0                0        3       20        3       24

``` r

compute_text_similarity(text1,text4)
```

    ##   tversky intersect intersect_weight setdiff1 setdiff2 lengtht1 lengtht2
    ## 1       0         0                0        3       23        3       25

## Text Statistics

``` r

text<-"There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable."
stat_word_char(text)
```

    ##   words mean_char  sd_char max_char min_char spell_error
    ## 1    32   5.21875 2.802469       10        1           4
