require 'csv'
require 'action_view'
include ActionView::Helpers::NumberHelper #only need helper for specific instance
class TimeReportsController < ApplicationController

  def upload
    uploaded_io = params[:file]
    name = uploaded_io.original_filename
    report_id = name.split('-').last.to_i

    #check to see if report has already been uploaded
    if Report.exists?(report_id: report_id)
      render json: { error: 'File Upload failed - Report already uploaded.' }, status: :conflict
      return
    end

    #read data from CSV file
    csv = CSV.parse(uploaded_io.read, headers: true)

    #writre the contents of the CSV file into database
    csv.each do |row|
      # Create the TimeReport record with the relevant data
      time_report_params = {
        date: row['date'],
        hours_worked: row['hours worked'],
        employee_id: row['employee id'],
        job_group: row['job group']
      }
      TimeReport.create(time_report_params)
    end
    #add Report ID to database to make sure no duplicates arise
    Report.create(
      report_id: report_id
    )

    render json: { success: true }
  end

  def show

    time_reports = TimeReport.all.map(&:attributes)

    #group data
    grouped_reports = time_reports.group_by do |report|
      "#{report['employee_id']}-#{report['job_group']}-#{period(report['date'])}"
    end

    employee_reports = grouped_reports.map do |key, group|
      #assign the relevant data and parse the date object
      employee_id, job_group, pay_period = key.split('-', 3)
      pay_period_parsed =  JSON.parse(pay_period)
      start_date, end_date = pay_period_parsed['start_date'], pay_period_parsed['end_date']

      #calculate total hours worked in the pay period and calculate total amount paid
      total_hours_worked = group.sum {  |h| h['hours_worked'] }
      hourly_wage = job_group == 'A' ? 20.0 : 30.0
      amount_paid = total_hours_worked * hourly_wage

      #create hash for employee's data for each pay period
      {
        employeeId: employee_id,
        payPeriod: {
          startDate: start_date,
          endDate: end_date
        },
        amountPaid: number_to_currency(amount_paid)
      }
    end

    #sort the reports by employee id and pay period
    employee_reports.sort_by! { |report| [report[:employeeId], report[:payPeriod][:startDate]] }

    payroll_report = { payrollReport: { employeeReports: employee_reports } }
    render json: JSON.pretty_generate(payroll_report)

  end


  private
  #calculates whether the date is in the first pay period of the month, or the last
  def period(date)

    start_date = date.day <= 15 ? date.beginning_of_month : date.beginning_of_month+15.days
    end_date = date.day <= 15 ? start_date+14.days : date.end_of_month

    { start_date: start_date.strftime('%Y-%m-%d'), end_date: end_date.strftime('%Y-%m-%d') }.to_json
  end
end