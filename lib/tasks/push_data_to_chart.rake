require 'io/console'
task :push_data => :environment do
 
  while true
    # || input !='\q'
    ChartJob.perform_later()
    sleep 1
    # input = STDIN.gets
  end
  
end