# Function analyzes the Authors_review list and helps identify potential cases
# in which the same author has been incorrectly split into multiple groupID 
check_splits <- function(df) {
  
  # Save column names -----------------------------
  # this will simplify the selection of columns to be returned in each step below
  original_colnames <- colnames(df)

  # Add columns with name combinations  -----------------------------
  # Adds columns with different combinations of first name, last name, first, middle, last initial, etc. 
  source("df_for_review_check.R")
  df<-df_for_review_check(df)
  
  # Any cases where identical "Last Name" assigned to >1 groupID -----------------------------
  # Will return two things: (1)  Last_summary & (2) Last 
  # 1) Last_summary: summary table of last names, groupIDs to which each assigned, no. of records for each groupID  
  # 2) Last: dataframe of  the records with those last names with all original columns
  Last_summary <- df %>%  
    group_by(last_name, groupID) %>%
    summarize(n_in_groupID = n()) %>%
    arrange(last_name) %>%
    mutate(groupIDs_with_same_name = n()) %>%
    filter(groupIDs_with_same_name > 1)
  Last <- semi_join(df, Last_summary, by = c("groupID", "last_name")) %>% arrange(AF, groupID)
  Last <- Last %>% select(original_colnames)
  
  # Any cases where identical "Last Name, First Initial" assigned >1 groupID -----------------------------
  # Will return two things: (1)  Last_F_summary & (2) Last_F
  # 1) Last_F_summary: summary table of records, no. of groupIDs to which each assigned, number of records for each groupID  
  # 2) Last_F: dataframe of all records with those "last name, first initial" with all original columns
  Last_F_summary <- df %>%
    group_by(mash_last_first_init, groupID) %>%
    summarize(n_in_groupID = n()) %>%
    arrange(mash_last_first_init) %>%
    mutate(groupIDs_with_same_name = n()) %>%
    filter(groupIDs_with_same_name > 1)
  Last_F <- semi_join(df, Last_F_summary, by = c("groupID", "mash_last_first_init")) %>% arrange(AF, groupID)
  Last_F <- Last_F %>% select(original_colnames)
  # This splits the last name and first initial into two columns to make it easier to read when looking for errors
  names <- as.data.frame(str_split_fixed(Last_F_summary$mash_last_first_init, pattern = "\\, ", n = 2))
  Last_F_summary <- bind_cols(Last_F_summary, names) %>%
    rename(last_name = V1, first_initial = V2) %>%
    ungroup() %>%
    select(groupID, last_name, first_initial, n_in_groupID, groupIDs_with_same_name)

  # Any cases where identical "Last Name, First Name" assigned to >1 groupID -----------------------------
    # Will return two things: (1)  Last_First_summary & (2) Last_First
  # 1) Last_First_summary: summary table of records, no. of groupIDs to which each assigned, number of records for each groupID  
  # 2) Last_First: dataframe of all records with those "last name, first name" with all original columns
  Last_First_summary <- df %>%
    group_by(mash_last_first, groupID) %>%
    summarize(n_in_groupID = n()) %>%
    arrange(mash_last_first) %>%
    mutate(groupIDs_with_same_name = n()) %>%
    filter(groupIDs_with_same_name > 1)
  Last_First <- semi_join(df, Last_First_summary, by = c("groupID", "mash_last_first")) %>% arrange(mash_last_first, groupID)
  Last_First <- Last_First %>% select(original_colnames)
  # This splits the first and last names into two columns to make it easier to read when looking for errors
  names <- as.data.frame(str_split_fixed(Last_First_summary$mash_last_first, pattern = "\\, ", n = 2))
  Last_First_summary <- bind_cols(Last_First_summary, names) %>%
    rename(last_name = V1, first_name = V2) %>%
    ungroup() %>%
    select(groupID, last_name, first_name, n_in_groupID, groupIDs_with_same_name)

  # Any cases where identical "Last Name, First Initial, Middle Initial" assigned to >1 groupID -----------------------------
  # Will return two things: (1)  Last_FM_summary & (2) Last_FM
  # 1) Last_FM_summary: summary table of records, no. of groupIDs to which each assigned, number of records for each groupID  
  # 2) Last_FM: dataframe of all records with those "last name, first name" with all original columns  
  Last_FM_summary <- df %>%
    group_by(mashLastFM, groupID) %>%
    summarize(n_in_groupID = n()) %>%
    arrange(mashLastFM) %>%
    mutate(groupIDs_with_same_name = n()) %>%
    filter(groupIDs_with_same_name > 1)
  Last_FM <- semi_join(df, Last_FM_summary, by = c("groupID", "mashLastFM")) %>% arrange(mashLastFM, groupID)
  Last_FM <- Last_FM %>% select(original_colnames)
  # This splits the last name and first+middle initials into two columns to make it easier to read when looking for errors
  names <- as.data.frame(str_split_fixed(Last_FM_summary$mashLastFM, pattern = "\\, ", n = 2))
  Last_FM_summary <- bind_cols(Last_FM_summary, names) %>%
    rename(last_name = V1, first_mid_initials = V2) %>%
    ungroup() %>%
    select(groupID, last_name, first_mid_initials, n_in_groupID, groupIDs_with_same_name)

  # Any cases where identical name in the Web of Science "AF" field assigned to >1 groupID -----------------------------
  # Will return two things: (1)  Last_FM_summary & (2) Last_FM
  # 1) AF_summary: summary table of records, no. of groupIDs to which each assigned, number of records for each groupID  
  # 2) AF: dataframe of all records with those "last name, first name" with all original columns  
  AF_summary <- df %>%
    group_by(AF2, groupID) %>%
    summarize(n_in_groupID = n()) %>%
    arrange(AF2) %>%
    mutate(groupIDs_with_same_name = n()) %>%
    filter(groupIDs_with_same_name > 1)
  AF <- semi_join(df, AF_summary, by = c("groupID", "AF2")) %>% arrange(AF, groupID)
  AF <- AF %>% select(original_colnames)



  # Prepare output from function ------------------------
  # make a list of all the summary tables and dataframes
   check_splits_list <- list("Last" = Last, "Last_F" = Last_F, "Last_FM" = Last_FM, "Last_First" = Last_First, "AF" = AF, "Last_F_summary" = Last_F_summary, "Last_FM_summary" = Last_FM_summary, "Last_First_summary" = Last_First_summary, "Last_summary" = Last_summary, "AF_summary" = AF_summary)
   
  return(check_splits_list)
}
