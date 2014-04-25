## Code Book for 'run_analysis.R'
# This data was processed with R(version 3.03) on a pc laptop running running windows 7.

#  Data loading:

The code assumes that the directory root of the data is in the current working directory. It assumes that the data is orgainized into files and directories with the same structure and naming that they originally had from "getdata_projectfiles_UCI HAR Dataset.zip".

The code uses all the files cotained in the root and the files directly under the "test" and "train" subdirectories. Those files are named y_test.txt, X_test.txt, y_train.txt, X_train.txt, subject_test.txt and subject_train.txt. These are the so called feature and feature label text files. Also the  activity_labels.txt file is loaded.

All these files are loaded using read.table which assumes the files are in 'csv' file format.

The values in "activity_labels" (which has two variables) is read into a table with column names "activityCode" and "activityName". 

# File data merging:

The label information in the Y_*.txt files is used to name the columns of the feature data. The activity_labels (loaded into the activityLabels data.frame) is used to give descriptive names to the activities indicated by activityCode values coming from X.train.txt and X_test.txt files.


