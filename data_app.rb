require './harvest_api.rb'

class DataApp < Sinatra::Base
  set :root, File.dirname(__FILE__)

  configure :development do
    set :harvest, HarvestApi.new
  end

  before do
    content_type :json
  end

  get '/api/?' do
    urlPrefix = "http://#{env['HTTP_HOST']}/api"

    Yajl::Encoder.encode({
      :endpoints => {
        :examples => {
          :pie_chart => "#{urlPrefix}/examples/pie_chart"
        },
        :reports => {
          :time_per_project => "#{urlPrefix}/reports/time_per_project"
        }
      }
    })
  end

  get "/api/examples/pie_chart/?" do
    Yajl::Encoder.encode({
      :data => [564,155,499,611,322],
      :labels => ['Abc', 'Def', 'Ghi', 'Jkl', 'Mno']
    })
  end

  get "/api/reports/time_per_project/?" do
    Yajl::Encoder.encode(settings.harvest.time_per_project)
  end
end
