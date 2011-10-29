# -*- coding: utf-8 -*-
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
      :labels => ['Christian Lizell (107h)', 'Torbjörn Nilsson (97h)', 'Peter Hellberg (114h)', 'Krister Söderström (96h)', 'Mikael Forsberg (67h)', 'Mats Ygfors (68h)', 'Johan Beronius (146h)', 'Petter Petersson (12h)', 'Alex Robsahm (35h)'],
      :data => [107.0, 96.5, 114.0, 96.25, 67.0, 68.0, 146.25, 12.0, 35.25]
    })
  end

  get "/api/reports/time_per_project/?" do
    Yajl::Encoder.encode(settings.harvest.time_per_project.keys.map {|name| })
  end
end
