
require 'mechanize'

def performSearch

  a = Mechanize.new

  #Enter Index Page and Login
  index = a.get('http://127.0.0.1:3000')

  form = index.form
  form['user[email]'] = "telmo.reinas@gmail.com"
  form['user[password]'] = "oyasuminasai_4"

  form.submit form.button

  #Enter Searches Page
  searches = a.get('http://127.0.0.1:3000')
  search_page = searches.link_with(:text => /Searches/).click

  #Enter New Search Page
  new_search = a.get(searches)
  new_search_page = new_search.link_with(:text => /New Search/).click

  #Create New Search
  new_s = a.get(new_search)

  form = new_s.form
  form['search[name]'] = "abcde"
  form['search[query]'] = "fedora"
  form.field_with(:name => "search[provider]").option_with(:value => "SearchProvider::Google").click
  form['search[options][site]'] = "www.exploit-db.com"
  form['search[options][days_to_search]'] = 15

  form.submit form.button

  #Enter Searches Page
  new_search = a.get(new_s)
  run_searches = new_search.link_with(:text => /Searches/).click

  #Run All Searches
  b = a.get(new_search)
  run_page = b.link_with(:text => /Run All Searches/).click

  #pp b

end