# refsplitr_streamlining_authors_review
Code to streamline the review of output from refsplitr's authors_clean function

One of the outputs of refsplitr's authors_clean function is a list of author name variants to review and verify have been assigned to the coreect groupID. This list gets larger as the number of references (and hence authors) gets larger. Most of these will be correctly assigned, but it can still be quite daunting. This code helps simplifyt the review process by checking for:

1) the same author being incorrectly split into >1 groupID
2) different authors being incorrectly pooled into the same groupID

It. requires the following 3 functions available in this repo.

```check_pools```

```checks_splits```

```df_for_review_check```

The code is ```code_for_finding_pools_and_splits```

The output of each function is a list. The list includes 5 dataframes built with different
combinations of names and initials. Thgese dataframes include the entire record, just as it is in
authors_review and authors_prelim.  The list also includes a summary of each dataframe, where you
can see an overview of the different names, how many name/initial combinations are pooled/split
into each groupID, and the number of records for each name name/initial combination

A few suggestions:

1) Checking for Incorrectly Split Authors (i.e., same person, different GroupID):
start with check_splits_list$AF_summary and check_splits_list$AF. These records are records of
authors with identical names in the WOS AF column that have been assigned different groupIDs.
THESE WILL ALMOST CERTAINLY HAVE TO BE CORRECTED. You may find a few more by looking over
check_splits_list$Last_FM and check_splits_list$Last_First, but only rarely.

2) Checking for Incorrectly Pooled Authors (i.e., different person, same groupID):
GENERALLY SPEAKING WE HAVE FOUND THIS TYPE OF ERROR IS EXTREMELY RARE. Most of the cases on the
list of records to be reviewed are as follows: last name, first name vs. last name, first initial
(e.g., Smith, John vs Smith J). We suggest the best way to begin is by reviewing
check_pools_list$Last_F_summary and check_pools_list$Last_FM_summary before moving on to the complete
records

