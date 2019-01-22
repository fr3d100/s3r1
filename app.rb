require 'bundler'
Bundler.require

$:.unshift File.expand_path("./../lib", __FILE__)
require 'app/scrapper'

# Méthode utilisée afin de choisir le format d'option voulue par l'utilisateur
def choose_export_format
	choice = 0 

	puts "=============================================================="
	puts "    *****  Bienvenue dans notre supper Scrapper  *****"  
	puts "=============================================================="
	puts ""
	puts "=============================================================="
	puts "Veuillez choisir le format d'export des données à scrapper :"
	puts " > 1 - format JSON"
	puts " > 2 - format Google Spreadsheet"
	puts " > 3 - format CSV"
	puts "=============================================================="
	print "> "
	choice = gets.chomp.to_i

	# Tant que l'utilisateur ne saisi pas une option valide, on lui redemande son choix
	while not (choice == 1 || choice == 2 ||choice == 3)
		puts "Vous devez choisir une option disponible"
		print "> "
		choice = gets.chomp.to_i 
	end	

	# On retourne le choix de l'utilisateur
	return choice

end

# Applique le bon format d'export en fonction du choix de l'utilisateur
def export_data(option)
	scrap = Scrapper.new("http://annuaire-des-mairies.com/val-d-oise.html")
	puts""
	puts"> Vos données sont en cours d'extraction, veuillez attendre ..."
	scrap.get_data
	puts ""
	if option == 1
		puts "> Vous avez choisi le format JSON"
		scrap.save_as_JSON
	elsif option == 2
		puts "> Vous avez choisi le format Google Spreadsheet"
		scrap.save_as_spreadsheet
	else
		puts "> Vous avez choisi le format CSV"
		scrap.save_as_csv
	end
	puts ""
	puts "=============================================================="
	puts "     Le scrapper a extrait vos données avec succès ! ♥‿♥"
	puts "=============================================================="

end

# Méthode perform de app.rb
def perform
	export_data(choose_export_format)
end


perform