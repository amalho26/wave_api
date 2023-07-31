Rails.application.routes.draw do

  post '/time_report_upload', to: 'time_reports#upload'
  get '/payroll_report', to: 'time_reports#show'
end
