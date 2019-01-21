# ================================
# 		    	REQUIRE
# ================================
require 'nokogiri'
require 'open-uri'
require 'json'
require 'pry'

# ================================
# 			SCRAPPER CLASS
# ================================
class Scrapper

# --------------------------------
# 			Attributs de l'instance
# --------------------------------
	attr_accessor :url, :townhalls

# --------------------------------
#  initialisation de l'instance
# --------------------------------
	def initialize(url_to_scrap)
		@url = url_to_scrap
		@townhalls = {}
	end

# --------------------------------
# 		Méthodes d'instance
# --------------------------------

# Méthode des données d'une mairies sur la base de son URL
# ------------------------------------------------------------------------------
def get_townhall_email(townhall_url) 
	doc = Nokogiri::HTML(open(townhall_url))
  mail = doc.xpath('/html/body/div/main/section[2]/div/table/tbody/tr[4]/td[2]').text
	return mail
end


# Méthode de récupération des données dans un hash
# ------------------------------------------------------------------------------
def get_data
	doc = Nokogiri::HTML(open(@url))
	a = doc.css('tr//a.lientxt')

	# a.length.times do |i|
	2.times do |i|
		name_town = a[i].text 
    url_suffix = a[i]['href'].delete_prefix(".")
    url_town = "http://annuaire-des-mairies.com#{url_suffix}"
    puts url_town
    mail_town = get_townhall_email(url_town)
    townhall_hash = {name_town => mail_town}
    @townhalls[name_town] = mail_town
  end
end


# Méthode d'instance afin d'enregistrer les données dans un fichier .JSON
# ------------------------------------------------------------------------------
	def save_as_JSON
		# Création d'un fichier JSON
		File.open("email.JSON","w") do |f|
    f.write(JSON.pretty_generate(@townhalls))
  end

	end

# Méthode d'instance afin d'enregistrer les données dans une Google Spreadsheet
# ------------------------------------------------------------------------------
	def save_as_spreadsheet

	end

# Méthode d'instance afin d'enregistrer les données dans un fichier .csv
# ------------------------------------------------------------------------------
	def save_as_csv

	end

end

def perform
	scrap = Scrapper.new("http://annuaire-des-mairies.com/val-d-oise.html")
	scrap.get_data
	scrap.save_as_JSON
end

perform