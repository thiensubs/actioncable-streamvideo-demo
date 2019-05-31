class CamsController < ApplicationController
  def create
    r= rand(1..1000)
    directory_name = "#{Rails.root}/public/cam/"
    Dir.mkdir(directory_name) unless File.exists?(directory_name)
    FileUtils.rm_rf(Dir.glob("#{directory_name}*"))
    File.open("#{directory_name}#{r}.png", 'wb') do |f|
      f.write(params[:image].read)
    end
    CamJob.perform_later(r, params[:channel])
  end

end
