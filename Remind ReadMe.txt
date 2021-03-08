
Files are created from Skyward from 4:00 - 4:45 PM, sending should happen at or after 5 PM daily
Note: Once files are uploaded they disappear almost immediately from the host side... 

The source files 'teachers_hr.csv' from Skyward Business and 'teachers_stu.csv' from Skyward Student
 are combined into a single teachers.csv the duplicate records are filtered out with a powershell script 'RemoveDuplicateTeachers.ps1' prior to sending.
The source files 'students_stu.csv' from Skyward Student for regular schools and 'stduents_SS00.csv' from Skyward Student for summer school are combined into a single students.csv prior to sending.

sftp://sftp-rostering.remind.com port 22
ID: ocean-blue-1568833915783387034
PWD: Tu8ks7RVDjK5qEKFUuqL7VqBKsjyumt3
