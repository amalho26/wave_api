# Instructions

1. Clone Repository
2. Go to the **wave_api** folder
3. Run the following commands:
   `bundle install`
   `rails db:create`
   `rails db:migrate`
4. Start the Server: `rails s`
5. Upload the CSV file using terminal: `curl -X POST -F "file=@<CSV FILE DIRECTORY>" http://localhost:<PORT>/time_report_upload`
6. Retrieve Payroll Data using terminal: `http://localhost:<PORT>/payroll_report`

# Questions

### 1. How did you test that your implementation was correct?

To ensure that my implementation was correct, I used error loggers and test outputs to make sure the right data was being passed at each step. I also tried various test cases that tested for:
 - uploading multiple files
 - uploading duplictae files
 - pay period: making sure if employee didn't have any hours worked within a pay period, not to include in payrollReport
 - combining multiple dates within same pay period for an employee


### 2. If this application was destined for a production environment, what would you add or change?

There would be several different changes if this application was destined for a production environment. 
   1) Authentication: This would be added to the API endpoints to make sure access is only granted to those who have authorization.
   2) Encryption: This would ensure that the data transmission through the API is secure.
   3) Pagination: If retrieving large amount of data, pagination would be required to ensure the payload remains manageable and not overwhelming.

### 3. What compromises did you have to make as a result of the time constraints of this challenge?

Some of the comprimises I had to make were:
   1) Code Optimization: It is really important to make sure that the code is as efficient as possible for production. This directly affects performance, scalability and resource utilization. Given the time constraints, I did my best to make sure the API is efficient by minimizing redundant computations.
   2) Schema Normalization: I noticed that employee_id and job_group could be made into a separate table which could later be joined to the time_reports table on employee_id. However, this was causing some errors whne trying to retrieve the payrollReport object when using an inner join to the tables. Based on the project requirements, it would be ok as is. However, if it were part of a bigger project, it would be important to separate the entities to make sure there aren't any unncessaery entries. 
