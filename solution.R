################################################################################
###### How to get the original dataset?
###### Data file here: http://www.oecd.org/pisa/data/2015database/
################################################################################

library(tidyverse)

pisa <- read_csv("http://bit.ly/wosr_pisa_data")
pisa <- pisa %>% 
  mutate(CNT = forcats::fct_reorder(CNT, PV1SCIE))

## <- assignment operator:
## Windows/Linux: "Alt" + "-"
## Mac: "Option" + "-"

########### Task ###############################################################
## How many children got tested in each OECD country?
################################################################################

## %>% pipe operator with Ctrl/Command + Shift + Enter key combination
## with adding %>% print(n = Inf) you will be able to see the whole result set

pisa %>% 
  filter(OECD == "Yes") %>% 
  group_by(CNT) %>% 
  summarise(records = n()) %>% 
  arrange(records) %>% 
  print(n = Inf)

########### Task ##############################################################
## By age 15, students in the United Kingdom perform above the OECD average in
## science (509 score points) and reading (498 points) and
## around the OECD average in mathematics (492 points).
## 
## Task: Calculate the median result for each competence field in each OECD
## country. Store the result data frame in a variable called 'medians'
################################################################################

medians <- pisa %>% 
  filter(OECD == 'Yes') %>% 
  group_by(CNT) %>% 
  summarise(med_maths = median(PV1MATH),
            med_science = median(PV1SCIE),
            med_read = median(PV1READ)) %>% 
  arrange(-med_science) %>% 
  print(n = Inf)

########### Task ###############################################################
## Plot the median science score for each OECD country
################################################################################

ggplot(medians) +
  geom_point(aes(x = CNT, y = med_science)) +
  coord_flip()

########### Task ###############################################################
## Using boxplots, visualize the distribution of science scores in each
## OECD country
################################################################################
oecd_only <- pisa %>% filter(OECD == "Yes")

ggplot(oecd_only) +
  geom_boxplot(aes(x = CNT, y = PV1SCIE)) +
  coord_flip()

########### Task ###############################################################
## Students with an immigrant background (first or second generation) in the
## United Kingdom, as in many other OECD countries, do not perform as well in
##  science as students without an immigrant background.
##  
## Task: plot the distribution of science points in the UK based
## on the immigrant status
################################################################################

uk <- pisa %>% 
  filter(CNT == "United Kingdom")

ggplot(uk) +
  geom_boxplot(aes(x = BornInTestCountry, y = PV1SCIE)) 

########### Task ###############################################################
## In the United Kingdom, boys and girls are equally likely to score
## at Level 5 or 6, the highest levels of proficiency, in science
## (12% of boys and 10% of girls) (Table I.2.6a). Even though gender
## differences in science performance tend to be small on average,
## in 33 countries and economies, the share of top performers in
## science is larger among boys than among girls. In the United Kingdom,
## as a whole, there is no significant difference in the share of top
## performers among boys and girls (Table I.2.6a), and this is also
## true in England, Northern Ireland, Scotland and Wales (Table B2.I.3).
## 
## Task1 : Plot the distribution of science points in the UK based on gender.
## Was there any difference among the regions? 
################################################################################
ggplot(uk) +
  geom_boxplot(aes(x = Gender, y = PV1SCIE)) +
  facet_wrap(~Region)

########### Task ###############################################################
## Task 2: Plot the distribution of science points in OECD countries using 
## different colors for each gender
################################################################################

ggplot(oecd_only) +
  geom_boxplot(aes(x = CNT, y = PV1SCIE, fill = Gender)) +
  coord_flip()

########### Task ###############################################################
## Task: Plot the previous plot with
## i) white background
## ii) meaningful axis labels,
## iii)  bold fonts and
## iiii) different colors
################################################################################

ggplot(oecd_only) +
  geom_boxplot(aes(x = CNT, y = PV1SCIE, fill = Gender)) +
  coord_flip() +
  theme_bw() +
  theme(text = element_text(face = "bold")) +
  scale_fill_brewer(palette = "Set1") +
  xlab("Country") + ylab("Science score")
  
###### Task ####################################################################
## Is there any relationship between the competence areas?
## Plot the median of reading and median of mathematics for each country
## and fit a curve to the relationship!
################################################################################
ggplot(medians) +
  geom_point(aes(x = med_read, y = med_science)) +
  geom_smooth(aes(x = med_read, y = med_science))
