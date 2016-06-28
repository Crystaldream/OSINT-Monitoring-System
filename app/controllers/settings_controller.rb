class SettingsController < ApplicationController

  def new
  end

  def index

  end

  def create

    @source = params[:source][:link]

    File.open("sources.txt", "a") do |f|
      f.puts(@source)
    end

    redirect_to action: "index"

  end

  def source_params
    params.require(:source).permit([:link])
  end

end
