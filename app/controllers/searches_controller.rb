class SearchesController < ApplicationController

  @@title = Array.new
  @@domains = Array.new
  @@links = Array.new
  @@searches_defined = Array.new
  @@results_defined = Array.new
  @@name = String.new
  @@keywords = String.new
  @@id = -1
  @@daemon = String.new

  def new
    @search = Search.new(search_params)
  end

  def create
    @search = Search.new(search_params)
    @search.save

    @@id = @search.id
    puts @@id
    @@name = search_params[:query][:name]
    @@keywords = search_params[:query][:keywords]

    puts @@keywords

    puts "::::::::::::::::::"
    puts current_user.email

    createSearch()

  end

  def index

    @tot = 0
    @@searches_defined = []
    @@total_results = 0

    if File.exist?("searches.txt")

      if !File.read("searches.txt").empty?
        File.read("searches.txt").each_line do |line|
          @@searches_defined << line.split(";")
        end
      end

    end

    Dir.chdir("/home/telmo/OSINT/Osint/results")
    Dir.foreach("/home/telmo/OSINT/Osint/results/") do |file|

      next if file == '.' or file == '..'

      puts Dir.pwd

      File.read(file).each_line do |line|
        @@results_defined << line.split(";")
      end

      @tot = @@results_defined.length
      puts @tot.to_s + "@@@@@"
      @@results_defined

    end

    Dir.chdir("/home/telmo/OSINT/Osint")

  end

  def bot
  end

  def save

    @name = params[:name]

  end

  def start

    @name = params[:name]
    @keywords = params[:keywords]
    @id_run = params[:id]

    timer = Rufus::Scheduler.new

    @@daemon = timer.every("60s") do

      Thread.new{
        run(@name, @keywords)
      }

    end

    redirect_to action: "index"

  end

  def stop

    #tmp = Rufus::Scheduler.new

    #tmp2 = tmp.job(@@daemon)

    #tmp2.kill

    #if(@@daemon.running?)
    #  @@daemon.kill
    #end

    redirect_to action: "index" and return

  end

  def show
    @results = Search.find(params[:id])
  end

  helper_method :title_results
  helper_method :domains_results
  helper_method :links_results
  helper_method :searches
  helper_method :results
  helper_method :id_value
  helper_method :name_run
  helper_method :keywords_run
  helper_method :key
  helper_method :total

  def total
    @@total_results
  end

  def title_results
    @@title
  end

  def domains_results
    @@domains
  end

  def links_results
    @@links
  end

  def searches
    @@searches_defined
  end

  def results
    @@results_defined
  end

  def id_value
    @@id
  end

  def name_run
    @@name
  end

  def keywords_run
    @@name
  end

  def key
    @@keywords
  end

  def run(name, keywords) # Run Searches

    require 'capybara/dsl'

    @sources = Array.new

    if !File.read("sources.txt").empty?
      File.read("sources.txt").each_line do |line|
        @sources << line
      end
    end

    @sources.each do |f|
      puts f
    end

    headless = Headless.new
    #headless.start
    
    @id_run = params[:id]

    # Login
    @session = Capybara::Session.new(:selenium)
    @session.driver.browser.manage.window.maximize
    @session.visit('http://localhost:3000')
    @session.fill_in 'user_email', with: "telmo.reinas@gmail.com"
    @session.fill_in 'user_password', with: "oyasuminasai_4"
    @session.find_button("Sign in").click

    @session.find(:xpath, "//a[@href='/searches']").click

    removeEntry(@session, headless)

    @session.find(:xpath, "//a[@href='/searches/new']").click

    @session.fill_in 'search_name', with: params[:name]
    @session.fill_in 'search_query', with: params[:keywords]
    @session.select("Google Search", :from => 'search[provider]')
    @session.fill_in 'search_options_site', with: "www.exploit-db.com"
    @session.fill_in 'search_options_days_to_search', with: "15"
    @session.find_button("Create Search").click

    # Run Search

    @session.find('a', :text => "Run Now", exact: true).click

    removeResults(@session, @id_run, headless)

  end

  def createSearch()

    @str = @@name + ";" + @@keywords + ";" + @@id.to_s

    File.open("searches.txt", "a") do |f|
      f.puts(@str)
    end

    redirect_to action: "index" and return

  end

  def removeEntry(s, h)

    @session = s

    while @session.first(:css, ".button.tiny.alert") != nil do

      @session.first(:css, ".button.tiny.alert").click
      @session.driver.browser.switch_to.alert.accept

    end

  end

  def removeResults(s, id, h)

    require 'capybara/dsl'

    @results = Array.new

    @session = s
    @id_run = id
    headless = h

    sleep(10.seconds)

    @session.visit('http://localhost:3000')
    @session.all('table#results_table>tbody tr').each do |tr|

      count = 0

      tr.all('td').each do |s|

        count += 1

        if count == 3

          @@title << s.text

        end

        if count == 5

          @@domains << s.text

        end

        if count == 6

          s.all('a').each { |a| @@links << a[:href] }

        end

      end

    end

    @@title.each_with_index do |item, index|

      @str = item + ";" + @@domains[index] + ";" + @@links[index] + "\n"

      if !Dir.exists?('results')
        Dir.mkdir('results')
      end

      File.open("results/" + @id_run.to_s + ".txt", "a+") do |f|

        f.each do |line|
          @results << line
        end

      end

      if !@results.include?(@str)

        File.open("results/" + @id_run.to_s + ".txt", "a+") do |f|

          f.puts(@str)

        end

      end

      @results.clear

    end

    if !File.read("results/" + @id_run.to_s + ".txt").empty?
      AlertMailer.sample_email(current_user).deliver_now
    end

    if @session.check('select_all')
      @session.find_button("Delete Results").click
      @session.driver.browser.switch_to.alert.accept
    end

    removeSearches(@session, headless)

  end

  def removeSearches(s, h)

    require 'capybara/dsl'

    @session = s
    headless = h

    @session.visit('http://localhost:3000')

    @session.find(:xpath, "//a[@href='/searches']").click

    while @session.first(:css, ".button.tiny.alert") != nil do

      @session.first(:css, ".button.tiny.alert").click
      @session.driver.browser.switch_to.alert.accept

    end

    abc = @session.first(:css, ".button.tiny.alert").nil?

    headless.destroy

    @session.driver.browser.quit

    redirect_to action: "index" and return

  end

  private

  def search_params
    params.require(:search).permit({ query: [:name, :keywords] })
  end


end
