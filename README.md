# refsplitr_streamlining_authors_review
Code to streamline the review of output from refsplitr's authors_clean function



Becuase there is always some unceartainty in disambiguation (e.g., is Emilio Bruna *really* the same person as E. Bruna?) refsplitr flags and provides the opportunity to review a subset of groupID assignments and make any necessary corrections: the ```authors$review``` output of the ```authors_clean()``` function is a dataframe with the complete records for author name variants that refsplitr has assigned to the same groupID. Most of these will be correctly assigned, but because the dataframe of name variants to review gets larger as the number of references (and hence authors) gets larger it can eventually become quite daunting. This repository is code to simplify the process of reviewing the ```authors$review``` dataframe by dividing it into more manageable subgroups. It does so with functious that use different combinatons of author names and initials to check for cases where:

   1) the same author appears to have been incorrectly split into >1 groupID numbers
   
   2) different authors appears to have been incorrectly pooled under the same groupID

To use these tools you need the following files from this repository:

   1) function ```check_pools.R```

   2) function ```checks_splits.R```

   3) function ```df_for_review_check.R```

   4) R script ```code_for_finding_pools_and_splits.R```.

**Instructions**

1) put the functions in your Rstudio project or working directory. 

2) After executing the ```authors_clean()``` function, execute the code in ```code_for_finding_pools_and_splits.R```. Be sure to modify the ```source("check_splits.R")``` as needed ```source("check_pools.R")``` if the functions are located somewhere other than the working directory or the same folder as your Rstudio project. (for example, if you create a folder called "functions" in your RStudio project you would modify as follows ```source("./functions/check_splits.R")```.

3) The output of ```checks_splits.R``` and ```"check_pools.R"``` are lists. Each list includes 5 dataframes built with different combinations of last names and first/middle last names and initials. These dataframes include the entire record for each author, just as it is in ```authors$review``` and ```authors$prelim```.  The lists also include summary tables of each dataframe, which provide an overview of the different names pooled in a single groupID (or different groupIDs intto which a single name has been split), how many name/initial combinations are pooled/split into each groupID, and the number of author records for each name/initial combination. The different output of these functions will include more or fewer names as the combinations of names and initials becomes more or less stringent; it is possible that there will be no name/initial combinations with groupID numbers that are the same (for pooled) or different (for splits). These are the combinations, from most to least stringent (approximately): 

     - ```$AF```: name as in the AF column of the Web of Science record
     - ```$Last_FM```: Last Name, First Initial and Middle Initial
     - ```$Last_First```: Last Name, First Name
     - ```$Last_F```: Last Name, First Initial
     - ```$Last```: Last Name

  
4) **Checking for Incorrectly Split Authors (i.e., the same person incorrectly assigned to >1 groupID):**

    *We recommend starting with ```check_splits_list$AF_summary```  and ```check_splits_list$AF``` .* These are records of    authors with       identical names in the Web of Science AF column that have been assigned different groupIDs. Our tests indicate this is very unlikley unless there are >5000 authors in the dataset, and even then the number of authors incorrectly split is extremely small (e.g., ~15 people in a test dataset with over 50,000 authors). However, there will almost certainly be a few of these in such larger datasets because of the way that resplitr's disambiguation makes decisions about groupings. People with identical names split into different groupIDs can be seen in ```check_splits_list$Last_FM``` and ``` check_splits_list$Last_First``` (though note it is possible these are actually different authors with identical names). The remaining dataframes are increasingly less stringent, and so will include name/initial combinations that are in fact different authors. An example is below. 

5) **Checking for Incorrectly Pooled Authors (i.e., different person, same groupID):**

    *We suggest to start by reviwiewing the ```check_pools_list$Last_F_summary``` and ```check_pools_list$Last_FM_summary``` before moving on to the less stringent name combinations.* Our analyses of test datasets with ~50,000 authors indicate these cases are rare. Many of these cases will be for cases where one author uses last name, first name  and the other uses last name, first initial (e.g., Bruna, Emilio vs. Bruna, E). 

6) Once any errors have been found, correct the ```authors$review``` output as instructed in the refsplitr vignette and use ```authors_refine()``` to incorporate the corrections in the list of authors. 






>**Example of the ```check_splits()``` output for different name/initial combinations.**

1) The following would be the output in the (highly unlikley) scenario that a dataset included the following 5 authors with very similar names and in which one of them was incorrectly split into two groupIDs:  

   - Bruna, Emilio M. (assigned to groupID=21)
   - Bruna, Emilio M. (same person but incorrectly assigned to groupID=34 instead of groupID=21)
   - Bruna, Emilio R. (assigned to groupID=564)
   - Bruna, Enrique M. (assigned to group=45)
   - Bruna, Jorge C. (assigned to group=45).

  ```check_splits_list$AF```: returns Bruna, Emilio M. (groupID=21) and Bruna, Emilio M. (groupID=34) 
  
  ```check_splits_list$Last_FM```: returns Bruna, Emilio M. (groupID=21), Bruna, Emilio M. (groupID=34), and Bruna, Enrique M. (group=45).
  
  ```check_splits_list$Last_First```: returns Bruna, Emilio M. (groupID=21), Bruna, Emilio M. (groupID=34), and Bruna, Emilio R. (groupID=564) 
  
  ```check_splits_list$Last_F```: returns Bruna, Emilio M. (groupID=21), Bruna, Emilio M. (groupID=34), Bruna, Emilio R. (groupID=564), and Bruna, Enrique M. (group=45).
  
  ```check_splits_list$Last```: returns Bruna, Emilio M. (groupID=21), Bruna, Emilio M. (groupID=34), and Bruna, Emilio R. (groupID=564), Bruna, Enrique M. (group=45), and Bruna, Jorge C. (group=45).

The less stringent name/initial combinations did not reveal any additional cases where the same author was incoreectly split into different groupIDs. ***This will usually be the case.*** 

2) An example where ```check_splits_list$AF``` wouldn't return the different groupIDs for an incorrectly split authoris the following (highly unlikely) situation: 

   - Bruna, Emilio M. (groupID=21)
   - Bruna, E M (same person but incorrectly assigned to groupID=98 instead of groupID=21)
   - Bruna, Emilio (same person but incorrectly assigned to groupID=852 instead of groupID=21)

  ```check_splits_list$AF```: none returned  
  
  ```check_splits_list$Last_FM```: returns Bruna, Emilio M. (groupID=21) and Bruna,  E M (groupID=98)
  
  ```check_splits_list$Last_First```: returns Bruna, Emilio M. (groupID=21), Bruna, Emilio (groupID=852)
  
  ```check_splits_list$Last_F```: returns Bruna, Emilio M. (groupID=21), Bruna, E M (groupID=98), Bruna, Emilio (groupID=852).

In this case only the least stringent combination included all three name variants used by the author AND not identified as refsplitr as the same author using the other criteria in the record (ORCIDID, email, address, etc.) ***Cases such as these are likely extremely rare***, but we provide these outputs to allow users to search for them anyway. 


