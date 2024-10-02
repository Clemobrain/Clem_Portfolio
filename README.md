# MY PROJECT

# BIG DATA TOOLS AND TECHNIQUES  
**STUDENT ID:** @00713171

---

### MSC DATA SCIENCE  
School of Computing, Science & Engineering  
University of Salford, Manchester.

---

### AIRIOHUODION CLEMENT  
**APRIL 02, 2024**

---

# TASK ONE

## ABSTRACT  
The goal of this job is to get a thorough grasp of large data systems through the exploration of particular subjects that highlight the interaction between theory and real-world applications. It entails employing well-liked big data tools and methodologies in addition to having competence with common data analysis tasks including loading, cleaning, analyzing, and producing reports. It is essential to be proficient with Python, SQL, or Linux terminal commands in order to pass this test.

---

## INTRODUCTION  
In my capacity as an AI engineer and data scientist given the opportunity to investigate more about clinical trials, I’ve carefully examined the dataset that is given me. Several important topics are intended to be addressed by this investigation, which skillfully uses visuals to bolster findings.  

First, I’ll look at the total number of studies in the dataset, making sure to explicitly account for different research. The types of research that are here will next be discussed, with each type listed with its corresponding frequency in order of least to most frequent. I’ll also include the top 5 conditions found in the dataset along with their corresponding frequencies.  

I’ll also look for sponsors, paying special attention to non-pharmaceutical businesses. I’ll count the number of clinical studies that the top 10 sponsors outside the pharmaceutical industry have supported. Etc.


# DATAFRAME Implementation

---

### Figure 1.4.0

The ‘Conditions’ column is divided according to the delimiter that is defined for the specified file root (which is kept in `conditions_delimiter`). It then splits the resultant array into several rows, each of which has a single condition. This guarantees that any condition in a row that includes multiple conditions separated by the designed delimiter will have its own row.

Then I counted the instances of each condition and organized the DataFrame based on the ‘conditions’ column, after which I ordered the result in descending using `.orderby`. 

In order to achieve the desired result, I filtered out unfilled conditions and displayed the top 5 rows without truncating the data.
