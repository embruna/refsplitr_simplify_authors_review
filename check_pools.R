# Function analyzes the Authors_review list and helps identify potential cases
# in which different authors have been incorrectly pooled in the same groupID 

check_pools <- function(df) {
  # Save column names -----------------------------
  # this will simplify the selection of columns to be returned in each step below
  original_colnames <- colnames(df)
  
  # Add columns with name combinations  -----------------------------
  # Adds columns with different combinations of first name, last name, first, middle, last initial, etc. 
  source("df_for_review_check.R")
  df<-df_for_review_check(df)
  
  # Any cases where same "Last Name" assigned to same groupID -----------------------------
  # e.g., would reveal "Bruna, Emilio", "Bruna, Enrique", and "Bruna, Roberto" incorrectly pooled in the same groupID
  # Will return two things: (1)  Last_summary & (2) Last 
  # 1) Last_summary: summary table of last names, no. of groupIDs to which each assigned, no. of records for each groupID  
  # 2) Last: dataframe of  the records with those last names with all original columns
  Last_summary <- df %>%
    group_by(groupID, last_name) %>%
    summarize(n_in_groupID = n()) %>%
    arrange(groupID) %>%
    mutate(names_in_same_groupID = n()) %>%
    filter(names_in_same_groupID > 1) %>%
    arrange(names_in_same_groupID) %>%
    arrange(names_in_same_groupID)
  Last <- semi_join(df, Last_summary, by = c("groupID")) %>% arrange(groupID, AF)
  Last <- Last %>% select(original_colnames)
  
  # Any cases where same "Last Name, First Initial" assigned to same groupID -----------------------------
  # e.g., would reveal if "Bruna, Emilio" and "Bruna, Enrique" incorrectly pooled in the same groupID
  # Will return two things: (1)  Last_F_summary & (2) Last_F
  # 1) Last_F_summary: summary table of records, no. of groupIDs to which each assigned, number of records for each groupID  
  # 2) Last_F: dataframe of all records with those "last name, first initial" with all original columns
  Last_F_summary <- df %>%
    group_by(groupID, mash_last_first_init) %>%
    summarize(n_in_groupID = n()) %>%
    arrange(groupID, mash_last_first_init) %>%
    mutate(names_in_same_groupID = n()) %>%
    filter(names_in_same_groupID > 1) %>%
    arrange(names_in_same_groupID)
  Last_F <- semi_join(df, Last_F_summary, by = c("groupID", "mash_last_first_init")) %>% arrange(groupID, AF)
  Last_F <- Last_F %>% select(original_colnames)
  # This splits the lasy name and first intial into two columns to make it easier to read when looking for errors
  names <- as.data.frame(str_split_fixed(Last_F_summary$mash_last_first_init, pattern = "\\, ", n = 2))
  Last_F_summary <- bind_cols(Last_F_summary, names) %>%
    rename(last_name = V1, first_initial = V2) %>%
    select(groupID, last_name, first_initial, n_in_groupID, names_in_same_groupID) %>%
    arrange(groupID, last_name)

  
  # Any cases where same "Last Name, First Name" assigned to same groupID -----------------------------
  # (e.g., could reveal if "Bruna, Emilio G" and "Bruna, Emilio M" incorrectly pooled in the same groupID
  # Will return two things: (1)  Last_First_summary & (2) Last_First
  # 1) Last_First_summary: summary table of records, no. of groupIDs to which each assigned, number of records for each groupID  
  # 2) Last_First: dataframe of all records with those "last name, first name" with all original columns
  Last_First_summary <- df %>%
    group_by(groupID, mash_last_first) %>%
    summarize(n_in_groupID = n()) %>%
    arrange(mash_last_first) %>%
    mutate(names_in_same_groupID = n()) %>%
    filter(names_in_same_groupID > 1) %>%
    arrange(groupID)
  Last_First <- semi_join(df, Last_First_summary, by = c("groupID", "mash_last_first")) %>% arrange(groupID, AF)
  Last_First <- Last_First %>% select(original_colnames)
  # This splits the first and last names into two columns to make it easier to read when looking for errors
  names <- as.data.frame(str_split_fixed(Last_First_summary$mash_last_first, pattern = "\\, ", n = 2))
  Last_First_summary <- bind_cols(Last_First_summary, names) %>%
    rename(last_name = V1, first_name = V2) %>%
    select(groupID, last_name, first_name, n_in_groupID, names_in_same_groupID) %>%
    arrange(groupID, last_name)

  
  # Any cases where same "Last Name, First Initial, Middle Initial" assigned to same groupID -----------------------------
  # e.g., would reveal if "Bruna, Emilio Ricardo" and "Bruna, Emilio Roberto" incorrectly pooled in the same groupID
  # Will return two things: (1)  Last_FM_summary & (2) Last_FM
  # 1) Last_FM_summary: summary table of records, no. of groupIDs to which each assigned, number of records for each groupID  
  # 2) Last_FM: dataframe of all records with those "last name, first name" with all original columns  
  Last_FM_summary <- df %>%
    group_by(groupID, mashLastFM) %>%
    summarize(n_in_groupID = n()) %>%
    arrange(mashLastFM) %>%
    mutate(names_in_same_groupID = n()) %>%
    filter(names_in_same_groupID > 1) %>%
    arrange(names_in_same_groupID)
  Last_FM <- semi_join(df, Last_FM_summary, by = c("groupID", "mashLastFM")) %>% arrange(groupID, AF)
  Last_FM <- Last_FM %>% select(original_colnames)
  # This splits the last name and first+middle initials into two columns to make it easier to read when looking for errors
  names <- as.data.frame(str_split_fixed(Last_FM_summary$mashLastFM, pattern = "\\, ", n = 2))
  Last_FM_summary <- bind_cols(Last_FM_summary, names) %>%
    rename(last_name = V1, first_mid_initials = V2) %>%
    select(groupID, last_name, first_mid_initials, n_in_groupID, names_in_same_groupID) %>%
    arrange(groupID, last_name)
  

  # Any cases where different name in the Web of Science "AF" field were assigned to the same groupID -----------------------------
  # e.g., would reveal if two different authors named "Bruna, Emilio M" incorrectly pooled in the same groupID
  # Will return two things: (1)  Last_FM_summary & (2) Last_FM
  # 1) AF_summary: summary table of records, no. of groupIDs to which each assigned, number of records for each groupID  
  # 2) AF: dataframe of all records with those "last name, first name" with all original columns  
  AF_summary <- df %>%
    group_by(groupID, AF2) %>%
    summarize(n_in_groupID = n()) %>%
    arrange(AF2) %>%
    mutate(names_in_same_groupID = n()) %>%
    filter(names_in_same_groupID > 1) %>%
    arrange(groupID)
  AF <- semi_join(df, AF_summary, by = c("groupID", "AF2")) %>% arrange(groupID, AF)
  AF <- AF %>% select(original_colnames)


  # Prepare output from function ------------------------
  # make a list of all the summary tables and dataframes
  check_pools_list <- list("Last" = Last, "Last_F" = Last_F, "Last_FM" = Last_FM, "Last_First" = Last_First, "AF" = AF, "Last_F_summary" = Last_F_summary, "Last_FM_summary" = Last_FM_summary, "Last_First_summary" = Last_First_summary, "Last_summary" = Last_summary, "AF_summary" = AF_summary)
  
  return(check_pools_list)
}
