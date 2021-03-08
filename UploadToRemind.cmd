E:
CD \Data\Remind
REM - Need to work out how to convert students.xls to .csv automatically
REM Build the date Strings
SET Month=%date:~4,2%
SET Day=%date:~7,2%
SET Year=%date:~10,4%
SET ArchiveDate=%Month%-%Day%-%Year%

REM --------------------------------------
REM | Rename and prep the files so they can be uploaded
REM --------------------------------------

REM DELETE OLD upload Ones if they EXIST
DEL /Q teachers.csv
DEL /W enrollments.csv 

REM Rename and Combine the 2 TEACHERS USERS FILES from Skyward STU and BUS together the file teachersPreFilter.csv as a raw unsorted file.
COPY /B /Y teachers_hr.csv+teachers_stu.csv teachersPreFilter.csv

REM Rename and Combine the 2 Enrollments FILES from Skyward for classroom and Grade Level enrollments together the the combined file enrollments.csv
COPY /B /Y enrollments_Regular.csv+enrollments_GradeLevel.csv enrollments.csv

REM Rename and Combine the 2 Classes FILES - 1 from Skyward for classrooms and a static file of classes representing Grade Levels assigned to the Principal to create a combined classes.csv
COPY /B /Y classes_Regular.csv+Classes_GradeLevel_MANUAL-STATIC.csv classes.csv

REM Call PowerShell script to remove duplicate staff/teachers records, but keep the record with the phone number if one has a number and one doesn't
REM Creates step by step files for troubleshooting and research: 
REM  TeachersSorted - will all records but sorted by Teacher ID, School and phone. 
REM  Teachers.csv - The final output with duplicates removed, keeping the records with the phone number if only one has a phone number
PowerShell E:\Data\Remind\RemoveDuplicateTeachers.ps1

REM Rename and Combine the 2 STUDENT USERS FILES from Skyward STU for all schools and summer school SS000  together the file students.csv is used directly in one of the extracts for now
COPY /B /Y students_stu.csv+students_SS00.csv students.csv

REM Create the INF script with the custom dynamic file name
ECHO #Automatically abort script on errors >UploadToRemind.inf
ECHO option batch abort>>UploadToRemind.inf
ECHO #Overwrite files without confirmation>>UploadToRemind.inf
ECHO option confirm off>>UploadToRemind.inf
ECHO #Connect pre-configured connection [Remind]>>UploadToRemind.inf
ECHO open "Remind">>UploadToRemind.inf
ECHO #Upload the files>>UploadToRemind.inf - Don't enable resume support 
ECHO put "E:\Data\Remind\Schools.csv" "schools.csv">>UploadToRemind.inf
REM - rename the file as we upload it, the file teachers.csv is used directly in one of the extracts for now
ECHO put "E:\Data\Remind\teachers.csv" "teachers.csv">>UploadToRemind.inf
ECHO put "E:\Data\Remind\students.csv" "students.csv">>UploadToRemind.inf
ECHO put "E:\Data\Remind\classes.csv" "classes.csv">>UploadToRemind.inf
ECHO put "E:\Data\Remind\enrollments.csv" "enrollments.csv">>UploadToRemind.inf
ECHO #Get a list of current files to see check for good upload and any non-processed files>>UploadToRemind.inf
ECHO ls>>UploadToRemind.inf
ECHO #Close the connection>>UploadToRemind.inf
ECHO close>>UploadToRemind.inf
ECHO #Bye>>UploadToRemind.inf
ECHO exit>>UploadToRemind.inf

REM Upload the file to vendor
"C:\Program Files (x86)\WinSCP\WinSCP.exe" /console /script="E:\Data\Remind\UploadToRemind.inf"

REM Archive the files and rename them to the correct date.
REM MOVE /Y schools.csv SENT\schools_%ArchiveDate%.csv		-- Not created each day, so need to keep this static file
MOVE /Y teachers_hr.csv SENT\teachers_hr_SOURCE_%ArchiveDate%.csv
MOVE /Y teachers_stu.csv SENT\teachers_stu_SOURCE_%ArchiveDate%.csv
MOVE /Y teachersSorted.csv SENT\teachersSorted_SOURCE_%ArchiveDate%.csv
MOVE /Y teachersPreFilter.csv SENT\teachersPreFilter_SOURCE_%ArchiveDate%.csv
MOVE /Y teachers.csv SENT\teachers_%ArchiveDate%.csv
MOVE /Y students_stu.csv SENT\students_stu_SOURCE_%ArchiveDate%.csv
MOVE /Y students_SS00.csv SENT\students_SS00_SOURCE_%ArchiveDate%.csv
MOVE /Y students.csv SENT\students_%ArchiveDate%.csv
MOVE /Y classes.csv SENT\classes_%ArchiveDate%.csv
MOVE /Y classes_Regular.csv SENT\classes_Regular_%ArchiveDate%.csv
REM COPY Don't move the STATIC file
COPY /Y Classes_GradeLevel_MANUAL-STATIC.csv SENT\sClasses_GradeLevel_MANUAL-STATIC_%ArchiveDate%.csv
MOVE /Y enrollments.csv SENT\enrollments_%ArchiveDate%.csv
MOVE /Y enrollments_Regular.csv SENT\enrollments_Regular_%ArchiveDate%.csv
MOVE /Y enrollments_GradeLevel.csv SENT\enrollments_GradeLevel_%ArchiveDate%.csv
REM COPY Don't move the STATIC Schools file
COPY /Y schools.csv SENT\schools_%ArchiveDate%.csv
EXIT