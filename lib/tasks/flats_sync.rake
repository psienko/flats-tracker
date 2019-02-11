namespace :flats_sync do
  desc "Fetches buildings and flats from karoliny.pl"
  task fetch_karoliny: :environment do
    puts 'Fetching from karoliny.pl'
    Fetchers::Karoliny::Fetcher.call
    puts "Fetched successfuly from karoliny.pl"
  end
end
