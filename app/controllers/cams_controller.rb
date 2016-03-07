class CamsController < ApplicationController
  def create
    r= rand(1..1000)
    FileUtils.rm_rf(Dir.glob("#{Rails.root}/public/cam/*"))
    File.open("#{Rails.root}/public/cam/#{r}.png", 'wb') do |f|
      f.write(params[:image].read)
    end
    CamJob.perform_later(r)
  end

end
