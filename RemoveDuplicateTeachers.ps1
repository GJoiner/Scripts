 
E:
CD E:\Data\Remind
# Sort by teacher ID, School ID, then phone so that when there is one record with phone and one without the phone will be the last record
Import-CSV 'teachersPreFilter.csv' | Sort-Object teacher_id,school_id,teacher_mobile_phone | Export-Csv 'TeachersSorted.csv' -NoTypeInformation
# Remove duplicates, removed the first duplicate so if there are 2 records and only one has the phone number the first without the phone # will be removed.
# Leaves records for each school, so keeps records for summer school, Soar, virtual etc.
Import-CSV 'TeachersSorted.csv' | Sort-Object teacher_id,school_id -Unique | Export-Csv 'teachers.csv' -NoTypeInformation
