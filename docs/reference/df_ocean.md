# Big Five Personality Test Dataset

This dataset contains responses to an interactive online Big Five
personality test conducted around 2012. Participants rated themselves on
50 personality statements, and also provided demographic and technical
metadata. Responses were collected with informed consent, and missing
data is coded as 0.

## Usage

``` r
df_ocean
```

## Format

A data frame with 19719 rows and 57 variables:

- race:

  Race / ethnic background (1–13, 0=missing)

- age:

  Age (integer; only responses from participants 13 and older included)

- engnat:

  Is English your native language? (1=Yes, 2=No, 0=missing)

- gender:

  1=Male, 2=Female, 3=Other, 0=missing

- hand:

  Dominant writing hand: 1=Right, 2=Left, 3=Both, 0=missing

- source:

  How participant came to the test site: 1=Internal link, 2=Google,
  3=Facebook, 4=.edu site, 6=Other / unknown

- country:

  Two-letter ISO country code (e.g., "US", "GB")

- E1:

  I am the life of the party.

- E2:

  I don't talk a lot.

- E3:

  I feel comfortable around people.

- E4:

  I keep in the background.

- E5:

  I start conversations.

- E6:

  I have little to say.

- E7:

  I talk to a lot of different people at parties.

- E8:

  I don't like to draw attention to myself.

- E9:

  I don't mind being the center of attention.

- E10:

  I am quiet around strangers.

- N1:

  I get stressed out easily.

- N2:

  I am relaxed most of the time.

- N3:

  I worry about things.

- N4:

  I seldom feel blue.

- N5:

  I am easily disturbed.

- N6:

  I get upset easily.

- N7:

  I change my mood a lot.

- N8:

  I have frequent mood swings.

- N9:

  I get irritated easily.

- N10:

  I often feel blue.

- A1:

  I feel little concern for others.

- A2:

  I am interested in people.

- A3:

  I insult people.

- A4:

  I sympathize with others' feelings.

- A5:

  I am not interested in other people's problems.

- A6:

  I have a soft heart.

- A7:

  I am not really interested in others.

- A8:

  I take time out for others.

- A9:

  I feel others' emotions.

- A10:

  I make people feel at ease.

- C1:

  I am always prepared.

- C2:

  I leave my belongings around.

- C3:

  I pay attention to details.

- C4:

  I make a mess of things.

- C5:

  I get chores done right away.

- C6:

  I often forget to put things back in their proper place.

- C7:

  I like order.

- C8:

  I shirk my duties.

- C9:

  I follow a schedule.

- C10:

  I am exacting in my work.

- O1:

  I have a rich vocabulary.

- O2:

  I have difficulty understanding abstract ideas.

- O3:

  I have a vivid imagination.

- O4:

  I am not interested in abstract ideas.

- O5:

  I have excellent ideas.

- O6:

  I do not have a good imagination.

- O7:

  I am quick to understand things.

- O8:

  I use difficult words.

- O9:

  I spend time reflecting on things.

- O10:

  I am full of ideas.

## Source

Collected via an online personality test with informed consent (~2012).
Downloaded from Kaggle.com by the user Lucas Greenwell. see
<https://www.kaggle.com/datasets/lucasgreenwell/ocean-five-factor-personality-test-responses>

## Details

Personality items were rated on a five-point Likert scale: \#'
1=Disagree, 3=Neutral, 5=Agree. Missed=0.

**race** Chosen from a drop down menu. 1=Mixed Race, 2=Arctic (Siberian,
Eskimo), 3=Caucasian (European), 4=Caucasian (Indian), 5=Caucasian
(Middle East), 6=Caucasian (North African, Other), 7=Indigenous
Australian, 8=Native American, 9=North East Asian (Mongol, Tibetan,
Korean Japanese, etc), 10=Pacific (Polynesian, Micronesian, etc),
11=South East Asian (Chinese, Thai, Malay, Filipino, etc), 12=West
African, Bushmen, Ethiopian, 13=Other (0=missed) **age** Entered as text
(individuals reporting age \< 13 were not recorded) **engnat** Response
to "is English your native language?". 1=Yes, 2=No (0=missed) **gender**
Chosen from a drop down menu. 1=Male, 2=Female, 3=Other (0=missed)
**hand** "What hand do you use to write with?". 1=Right, 2=Left, 3=Both
(0=missed)

On this page users were also asked to confirm that their answers were
accurate and could be used for research. Participants who did not were
not recorded). Some values were calculated from technical information.

**country** The participant's technical location. ISO country code.
**source** How the participant came to the test. Based on HTTP Referrer.
1=from another page on the test website, 2=from google, 3=from facebook,
4=from any url with ".edu" in its domain name (e.g. xxx.edu,
xxx.edu.au), 6=other source, or HTTP Referer not provided.

In psychological trait theory, the Big Five personality traits, also
known as the five-factor model (FFM) and the OCEAN model, is a suggested
taxonomy, or grouping, for personality traits, developed from the 1980s
onwards. When factor analysis (a statistical technique) is applied to
personality survey data, some words used to describe aspects of
personality are often applied to the same person. For example, someone
described as conscientious is more likely to be described as "always
prepared" rather than "messy". This theory is based therefore on
semantic associations between words and not on neuropsychological
experiments. This theory uses descriptors of common language and
suggests five broad dimensions commonly used to describe the human
personality and psyche.

The theory identifies five factors:

- **Openness to experience (O)** (inventive / curious vs. consistent /
  cautious)

- **Conscientiousness (C)** (efficient / organized vs. extravagant /
  careless)

- **Extraversion (E)** (outgoing / energetic vs. solitary / reserved)

- **Agreeableness (A)** (friendly / compassionate vs. challenging /
  callous)

- **Neuroticism (N)** (sensitive / nervous vs. resilient / confident)

The five factors are represented using the acronyms OCEAN or CANOE.
Beneath each proposed global factor, there are a number of correlated
and more specific primary factors. For example, extroversion is
typically associated with qualities such as gregariousness,
assertiveness, excitement-seeking, warmth, activity, and positive
emotions. Family life and the way someone was raised will affect these
traits. Twin studies and other research have shown that about half of
the variation between individuals results from their genetics and half
from their environments. Researchers have found conscientiousness,
extroversion, openness to experience, and neuroticism to be relatively
stable from childhood through adulthood.

Items are grouped by Big Five traits:

- **Extraversion (E)**: E1 to E10

- **Neuroticism (N)**: N1 to N10

- **Agreeableness (A)**: A1 to A10

- **Conscientiousness (C)**: C1 to C10

- **Openness (O)**: O1 to O10

Negatively keyed items are: E2, E4, E6, E8, E10, N2, N4, A1, A3, A5, A7,
C2, C4, C6, C8, O2, O4, O6. These should be reverse-coded prior to
scoring.

## Examples

``` r
data(df_ocean)
head(df_ocean)
#>   race age engnat gender hand source country E1 E2 E3 E4 E5 E6 E7 E8 E9 E10 N1 N2 N3 N4 N5 N6 N7 N8 N9 N10 A1 A2 A3 A4 A5 A6 A7 A8 A9 A10 C1 C2 C3 C4 C5 C6 C7 C8 C9 C10 O1 O2 O3 O4 O5 O6 O7 O8 O9 O10
#> 1    3  53      1      1    1      1      US  4  2  5  2  5  1  4  3  5   1  1  5  2  5  1  1  1  1  1   1  1  5  1  5  2  3  1  5  4   5  4  1  5  1  5  1  4  1  4   5  4  1  3  1  5  1  4  2  5   5
#> 2   13  46      1      2    1      1      US  2  2  3  3  3  3  1  5  1   5  2  3  4  2  3  4  3  2  2   4  1  3  3  4  4  4  2  3  4   3  4  1  3  2  3  1  5  1  4   4  3  3  3  3  2  3  3  1  3   2
#> 3    1  14      2      2    1      1      PK  5  1  1  4  5  1  1  5  5   1  5  1  5  5  5  5  5  5  5   5  5  1  5  5  1  5  1  5  5   5  4  1  5  1  5  1  5  1  5   5  4  5  5  1  5  1  5  5  5   5
#> 4    3  19      2      2    1      1      RO  2  5  2  4  3  4  3  4  4   5  5  4  4  2  4  5  5  5  4   5  2  5  4  4  3  5  3  4  4   3  3  3  4  5  1  4  5  4  2   3  4  3  5  2  4  2  5  2  5   5
#> 5   11  25      2      2    1      2      US  3  1  3  3  3  1  3  1  3   5  3  3  3  4  3  3  3  3  3   4  5  5  3  5  1  5  1  5  5   5  3  1  5  3  3  1  1  3  3   3  3  1  1  1  3  1  3  1  5   3
#> 6   13  31      1      2    1      2      US  1  5  2  4  1  3  2  4  1   5  1  5  4  5  1  4  4  1  5   2  2  2  3  4  3  4  3  5  5   3  2  5  4  3  3  4  5  3  5   3  4  2  1  3  3  5  5  4  5   3

# Compute Big Five average scores (after reverse scoring)
# library(dplyr)
# df_ocean <- df_ocean %>% mutate(E=rowMeans(select(., E1:E10), na.rm=TRUE))
data(df_ocean)
head(df_ocean)
#>   race age engnat gender hand source country E1 E2 E3 E4 E5 E6 E7 E8 E9 E10 N1 N2 N3 N4 N5 N6 N7 N8 N9 N10 A1 A2 A3 A4 A5 A6 A7 A8 A9 A10 C1 C2 C3 C4 C5 C6 C7 C8 C9 C10 O1 O2 O3 O4 O5 O6 O7 O8 O9 O10
#> 1    3  53      1      1    1      1      US  4  2  5  2  5  1  4  3  5   1  1  5  2  5  1  1  1  1  1   1  1  5  1  5  2  3  1  5  4   5  4  1  5  1  5  1  4  1  4   5  4  1  3  1  5  1  4  2  5   5
#> 2   13  46      1      2    1      1      US  2  2  3  3  3  3  1  5  1   5  2  3  4  2  3  4  3  2  2   4  1  3  3  4  4  4  2  3  4   3  4  1  3  2  3  1  5  1  4   4  3  3  3  3  2  3  3  1  3   2
#> 3    1  14      2      2    1      1      PK  5  1  1  4  5  1  1  5  5   1  5  1  5  5  5  5  5  5  5   5  5  1  5  5  1  5  1  5  5   5  4  1  5  1  5  1  5  1  5   5  4  5  5  1  5  1  5  5  5   5
#> 4    3  19      2      2    1      1      RO  2  5  2  4  3  4  3  4  4   5  5  4  4  2  4  5  5  5  4   5  2  5  4  4  3  5  3  4  4   3  3  3  4  5  1  4  5  4  2   3  4  3  5  2  4  2  5  2  5   5
#> 5   11  25      2      2    1      2      US  3  1  3  3  3  1  3  1  3   5  3  3  3  4  3  3  3  3  3   4  5  5  3  5  1  5  1  5  5   5  3  1  5  3  3  1  1  3  3   3  3  1  1  1  3  1  3  1  5   3
#> 6   13  31      1      2    1      2      US  1  5  2  4  1  3  2  4  1   5  1  5  4  5  1  4  4  1  5   2  2  2  3  4  3  4  3  5  5   3  2  5  4  3  3  4  5  3  5   3  4  2  1  3  3  5  5  4  5   3
```
