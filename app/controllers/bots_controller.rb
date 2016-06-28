class BotsController < ApplicationController

  def new
    @bt = Bot.new(bot_params)
  end

  def create

    actual_dir = Dir.pwd

    parent_dir = File.expand_path("..", Dir.pwd)

    Dir.chdir parent_dir

    bot_dir = File.expand_path("Logbot-master", Dir.pwd)

    Dir.chdir bot_dir

    config_file = File.read("logbot.rb")

    chan = bot_params[:query][:channel]
    server = bot_params[:query][:server]
    nick = bot_params[:query][:nick]

    new_contents = config_file.gsub(/#[a-zA-Z]+/, chan)
    new_contents = new_contents.gsub(/([irc]+[.][a-z]+[.][a-z]+)/, server)
    new_contents = new_contents.gsub(/([|] ["]\w+["])/, '|' + ' "' + nick + '"')

    File.open("logbot.rb", "w") do |f|
      f.write(new_contents)
    end

    Dir.chdir parent_dir

    %x('./StartBot.sh')

    sleep(5.seconds)

    link = "http://localhost:5000/channel/" + bot_params[:query][:channel]

    redirect_to link.delete('#')

  end

  def index
  end

  def show
  end


  private

  def bot_params
    params.require(:bot).permit({ query: [:server, :nick, :channel, :keywords] })
  end

end
