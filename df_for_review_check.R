#This function prepares the dataframe with the diffrent name and initial combinations used 
# by check_pools and check_splits
df_for_review_check <- function(df) {
  
  df$AF2 <- df$AF # AF2 is the name one that gets manipulated to do the comparisons
  
  df$AF2 <- gsub("[.]", "", df$AF2) # removes the periods
  df$AF2 <- tolower(df$AF2) # convert to lower case
  df$AF2 <- gsub("do ", "do", df$AF2) # removes space to ensure last name
  df$AF2 <- gsub("dos ", "dos", df$AF2) # removes space to ensure last name
  df$AF2 <- gsub("del ", "del", df$AF2) # removes space to ensure last name
  df$AF2 <- gsub("de ", "de", df$AF2) # removes space to ensure last name
  df$AF2 <- gsub("da ", "da", df$AF2) # removes space to ensure last name
  df$AF2 <- gsub("van ", "van", df$AF2) # removes space to ensure last name
  df$AF2 <- gsub("[-]", "", df$AF2) # removes space to ensure last name
  df$AF2 <- gsub("[.]", "", df$AF2) # removes space to ensure last name
  # df$AF2<-gsub(" ", "",df$AF2) # removes space to ensure last name
  
  # SPLIT BY 1st space or comma tp get last name in one column, and then first plus any middle in the next
  split_last_names <- as.data.frame(str_split_fixed(df$AF2, pattern = "\\, ", n = 2)) # splits at the first comma
  # str_split_fixed generates a new matrix, so after saving as a df I have to bind it to original df
  df <- bind_cols(df, split_last_names) 
  df <- rename(df, "last_name" = V1, "first_middle_name" = V2) # then rename those columns
  df$char_last_name <- nchar(as.character(df$last_name))
  df$char_first_middle_name <- nchar(as.character(df$first_middle_name))
  # new data frame of those with 2 characters in first and middle name
  df2 <- filter(df, char_first_middle_name == 2)
  # remove these with 2 characters from df data frame (will rejoin later)
  df <- df[!(df$char_first_middle_name == 2), ] 
  
  df_initials <- as.data.frame(str_split_fixed(as.character(df$first_middle_name), " ", n = 2))
  df <- bind_cols(df, df_initials)
  df2_initials <- as.data.frame(str_split_fixed(as.character(df2$first_middle_name), "", n = 2))
  df2 <- bind_cols(df2, df2_initials)
  
  df <- rbind(df, df2)
  
  df <- rename(df, "first_name" = V1, "middle_name" = V2) # then rename those columns
  df$first_name <- gsub("[,]", "", df$first_name)
  df$first_name <- gsub("[,]", "", df$first_name) # removes the periods
  df$first_initial <- substring(df$first_name, 1, 1) # select the first initial of the first/middle names or initials
  df$mid_initial <- substring(df$middle_name, 1, 1) # select the first initial of the first/middle names or initials
  
  # paste the last name and first name together
  df$mash_last_first <- paste(df$last_name, df$first_name, sep = ", ")
  df$mash_last_first <- trimws(df$mash_last_first)
  # paste the last name and first initial together
  df$mash_last_first_init <- paste(df$last_name, df$first_initial, sep = ", ")
  df$mash_last_first_init <- trimws(df$mash_last_first_init)
  # paste the last name, first name, middle initial
  df$mashlast_first_middle <- paste(df$mash_last_first, df$mid_initial, sep = " ")
  df$mashlast_first_middle <- trimws(df$mashlast_first_middle)
  # paste the last name, first name, middle initial
  df$mashLastFM <- paste(df$first_initial, df$mid_initial, sep = " ")
  df$mashLastFM <- paste(df$last_name, df$mashLastFM, sep = ", ")
  df$mashLastFM <- trimws(df$mashLastFM)
  df_edited<-df
  return(df_edited)
}
