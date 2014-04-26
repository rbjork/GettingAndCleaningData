# Description of Code run_analysis.R

## Load text files code

The code begins by loading all the 'txt' files containing the values of computed features of sensor data and all the files that label the features(column names), activityLabels(maps activityCode of activity at time of measurement to activity name) and featureLabels which is the code of the activity that occurred at the time of measurement. Also is computed are the features giving the means and standard deviations values.
Variable names in code:
	* FeatureFile: files name containing list of features names in data set
	* features: data.frame of features loaded from feature file above
	* featureChar: this is the character vector conversion of features values
	* desiredFeatures: the computed features that are means or standard deviations
	* activityLabels: maps the six activity codes to 6 activity names.
	* subjectTrainLabels: the subject code of the person from which the row feature data is recorded
	* trainLabels: row values of activity labels
	* trainData: data.frame containing the features values computed from sensor data

After trainData and labels are loaded the desired features(mean and std's) are selected from trainData using the desiredFeatures character vector, and trainData is reassigned to this reduced columns dataset.


## Adding labels code
	Columns of activityCode and subjectCode are grafted onto trainData.
	Activity labels are then merged into the trainData using the activityCode above and activityLabels data.

## Test Data is loaded:
	Train data is loaded in manner identical to trainData above
	
## Merging training and test sets together
	The test data is appended to training data and assigned to variable "appendedData". 

## Computing the mean valuse of each subjects activity features
	Within the nested for loops the means are computed for the featues of each subjects activity.
	The begining of the outer for loop selects rows of the dataSet "appenedData" belonging the currently indexed subject. The the innner loops selects all the rows with a recording for a particular activity type and computes the mean - used R's 'colMeans method. 
	The data.frame 'meanActivityValues' is used to accumulate the values

## outputing tidy data.
	After all the means are computed the columns are reordered so that subject and and activity name are the first two columns of the data set.

## Write out to 'csv' file
	The data set is written out to 'tidy.csv'.