# ================================
# 		    	REQUIRE
# ================================
require 'nokogiri'
require 'open-uri'
require 'json'
require 'pry'
require "google_drive"
require 'csv'
require 'dotenv'

# DOTENV
Dotenv.load('.env')

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
	10.times do |i|
		name_town = a[i].text 
    url_suffix = a[i]['href'].delete_prefix(".")
    url_town = "http://annuaire-des-mairies.com#{url_suffix}"
    mail_town = get_townhall_email(url_town)
    townhall_hash = {name_town => mail_town}
    @townhalls[name_town] = mail_town
  end
end


	# Méthode d'instance afin d'enregistrer les données dans un fichier .JSON
	# ------------------------------------------------------------------------------
	def save_as_JSON
		File.open("db/email.JSON","w") do |f|
	  f.write(JSON.pretty_generate(@townhalls))
	end

	end

	# Méthode d'instance afin d'enregistrer les données dans une Google Spreadsheet
	# ------------------------------------------------------------------------------
	def save_as_spreadsheet
		session = GoogleDrive::Session.from_config("config.json")
		ws = session.spreadsheet_by_key("1lPJ_i18h4x0YKqVWLM4aXKqYqrctVGsC4ed_PaY_pPY").worksheets[0]

		ws[1,1] = "Liste des coordonnées des mairies du 95"
		ws[2,1] = "Mairie"
		ws[2,2] = "Email"
		ws.save
		i = 3
		@townhalls.each do |key, value| 
			ws[i,1] = key
			ws[i,2] = value
			ws.save
			i += 1
		end

		puts "Les résultats ont été enregistrées dans la Google Spreadsheet suivante :"
		puts 'https://docs.google.com/spreadsheets/d/1lPJ_i18h4x0YKqVWLM4aXKqYqrctVGsC4ed_PaY_pPY/edit?usp=sharing'
	end

	# Méthode d'instance afin d'enregistrer les données dans un fichier .csv
	# ------------------------------------------------------------------------------
	def save_as_csv
		CSV.open("db/email.csv", "w") do |csv| 
			@townhalls.to_a.each do|elem|
				csv << elem
			end 
		end
	end

end

def perform
	# scrap = Scrapper.new("http://annuaire-des-mairies.com/val-d-oise.html")
	# scrap.get_data
	# scrap.save_as_spreadsheet
end

perform