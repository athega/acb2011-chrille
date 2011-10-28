require "harvested"
require "date"

class HarvestApi
  attr_reader :client

  def initialize
    @client = Harvest.hardy_client(ENV['HARVEST_DOMAIN'], ENV['HARVEST_USER'], ENV['HARVEST_PASSWORD'])
  end

  def users
    puts "Users:"
    @client.users.all.each {|u| p u }
  end

  def projects
    @projects ||= @client.projects.all.select { |project| project.active? && project.billable? }
  end

  def time_per_project
    @time_per_project ||= begin
      project_time = {}
      now = Date.today
      start_date = Date.new(now.year, now.month, 1)
      end_date = Date.new(now.year, now.next_month.month-1, -1)

      projects.each { |project|  
        project_time[project.name] = 0
 
        @client.reports.time_by_project(project, start_date, end_date, { :billable => true }).each { |entry|
          project_time[project.name] += entry.hours.to_f
        }
      }

      project_data = {:labels => [], :data => []}
      project_time.keys.each { |name|
        if project_time[name] > 0
          project_data[:labels] << "#{name} (#{project_time[name].round}h)"
          project_data[:data] << project_time[name]
        end
      }

      project_data
    end
  end
end
