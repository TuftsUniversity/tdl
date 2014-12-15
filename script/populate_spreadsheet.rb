#!/usr/bin/env ruby
require "rubygems"
require "google/api_client"
require "google_drive"
require "active_fedora"
require 'optparse'
require 'rubydora'
require 'csv'

def test_dca_admin object
  # example of a GOOD admin stream
  #<admin xmlns:local="http://nils.lib.tufts.edu/dcaadmin/" xmlns:ac="http://purl.org/dc/dcmitype/">
  # example of a bad admin stream from last pre-mira batches
  # <admin xmlns="http://nils.lib.tufts.edu/dcaadmin/" xmlns:ac="http://purl.org/dc/dcmitype/">
  # example of a bad admin stream from a really old object
  # <dca_admin:admin xmlns:admin="http://nils.lib.tufts.edu/admin/" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dca_admin="http://nils.lib.tufts.edu/dca_admin/" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:xlink="http://www.w3.org/TR/xlink"/>
  if object.datastreams['DCA-ADMIN'].ng_xml.to_s[/<admin xmlns=\"http:\/\/nils.lib.tufts.edu\/dcaadmin\/\" xmlns:ac=\"http:\/\/purl.org\/dc\/dcmitype\/\">/]
    "Namespacing"
  elsif object.datastreams['DCA-ADMIN'].ng_xml.to_s[/<admin xmlns:local=\"http:\/\/nils.lib.tufts.edu\/dcaadmin\/\" xmlns:ac=\"http:\/\/purl.org\/dc\/dcmitype\/\">/]
    "Up to Date"
  else
    "Needs Updating"
  end

end

options = {}
optparse = OptionParser.new do |opts|
  opts.banner = 'Usage: populate spreadsheet [options]'

  options[:hydra_home] = nil
  opts.on('-h PATH', '--hydra_home PATH', 'Load the Hydra instance at this path') do |v|
    if File.exist?(File.join(v, 'config', 'environment.rb'))
      options[:hydra_home] = v
    else
      puts("#{v} does not appear to be a valid rails home")
      exit
    end #end else
  end #end hydra_home


  options[:dry_run] = 'false'
  opts.on('-d dry', '--dry-run dry', 'Dry Run') do |dry|
    options[:dry_run] = dry.to_s
  end

  opts.on('-n NAME', '--sourcename NAME', 'Source PIDs File') do |v|
    if File.exist?(v)
      options[:source_name] = v
    else
      puts("#{v} does not appear to be a valid file of pids")
      exit
    end
  end

end #end_opts
optparse.parse!()
raise OptionParser::MissingArgument if options[:source_name].nil?


# Authorizes with OAuth and gets an access token.
p "#{options[:dry_run]}"
unless options[:dry_run] == 'true'
  client = Google::APIClient.new
  auth = client.authorization
  auth.client_id = "719962928916-rug01epoed7j3k4kvdjbbl5o46gg5k1f.apps.googleusercontent.com"
  auth.client_secret = "ze82kcl1Iky_7c5JTb9z7F8i"
  auth.scope =
      "https://www.googleapis.com/auth/drive " +
          "https://docs.google.com/feeds/ " +
          "https://docs.googleusercontent.com/ " +
          "https://spreadsheets.google.com/feeds/"
  auth.redirect_uri = "urn:ietf:wg:oauth:2.0:oob"
  print("1. Open this page:\n%s\n\n" % auth.authorization_uri)
  print("2. Enter the authorization code shown in the page: ")
  auth.code = $stdin.gets.chomp
  auth.fetch_access_token!
  access_token = auth.access_token
  system'clear'
  print "Save your access token\n\n"
  print access_token
  print "\nSave your refresh token\n\n"
  print auth.refresh_token
  # Creates a session.
  session = GoogleDrive.login_with_oauth(access_token)

  ws = session.spreadsheet_by_key("1redjOUBPBny8HIKfGlXRlQ5IjdjuzDQFHhvLaMjI654").worksheets[0]

  # Gets content of A2 cell.
  #p ws[2, 1]  #==> "hoge"
end



@hydra_home = options[:hydra_home]

if @hydra_home
  Dir.chdir(@hydra_home)
  require File.join(@hydra_home, 'config', 'environment.rb')
else
  puts('The --hydra_home PATH option is mandatory. Please provide the path to the root of a valid Hydra instance.')
  exit 1
end

objects = CSV.read(options[:source_name])

#objects = ActiveFedora::Base.all
csv_out = nil
csv_out = CSV.open('state_of_objects.csv', 'w') if options[:dry_run] == 'true'

objects.each_with_index do |row, index|
    pid = row[0]
    next if pid.nil?

    begin
      object = TuftsBase.find(pid, :cast => false)
      ws[index+2, 1] = object.pid unless options[:dry_run] == 'true'
      ws[index+2,2] = object.state unless options[:dry_run] == 'true'
      dca_admin_status = test_dca_admin object
      ws[index+2,3] = dca_admin_status unless options[:dry_run] == 'true'
      if options[:dry_run] == 'true'
        csv_out << [object.pid,object.state,test_dca_admin(object)]
      end
      puts "#{object.pid} has state #{object.state} and #{dca_admin_status}"
    rescue NoMethodError 
       ws[index+2, 1] = pid unless options[:dry_run] == 'true'
       ws[index+2,3] = "No AF Model"  unless options[:dry_run] == 'true'
       if options[:dry_run] == 'true'
         csv_out << [pid,'','No AF Model']
       end
       puts "#{object.pid} has state #{object.state} and model not recognized"
    rescue Rubydora::FedoraInvalidRequest
       ws[index+2, 1] = pid unless options[:dry_run] == 'true'
       ws[index+2,3] = "Bad Datastream"  unless options[:dry_run] == 'true'
       if options[:dry_run] == 'true'
         csv_out << [pid,'','Bad Datastream']
       end
       puts "#{object.pid} has state #{object.state} and datastream unreachable in fedora"
    rescue ActiveFedora::ObjectNotFoundError
       ws[index+2, 1] = pid unless options[:dry_run] == 'true'
       ws[index+2,3] = "Object is in MIRA but not TDL"  unless options[:dry_run] == 'true'
       if options[:dry_run] == 'true'
         csv_out << [pid,'','Object is in MIRA but not TDL']
       end
       puts "#{pid} is in MIRA but not in TDL, need to handle elsewhere or index in TDL"
    end
    if options[:dry_run] == 'true'
      csv_out.flush
    else
      ws.save if index % 50 == 0
    end
end

if options[:dry_run] == 'true'
  csv_out.close

















#MISC NOTES
#=========================================================
# Changes content of cells.
# Changes are not sent to the server until you call ws.save().
#ws[2, 1] = "foo"
#ws[2, 2] = "bar"
#ws.save()

# Dumps all cells.
#for row in 1..ws.num_rows
#  for col in 1..ws.num_cols
#    p ws[row, col]
#  end
#end

# Yet another way to do so.
#p ws.rows #==> [["fuga", ""], ["foo", "bar]]

# Reloads the worksheet to get changes by other clients.
#ws.reload()

# Gets list of remote files.
#for file in session.files
#  p file.title
#end

# Uploads a local file.
#session.upload_from_file("/path/to/hello.txt", "hello.txt", :convert => false)

# Downloads to a local file.
#file = session.file_by_title("hello.txt")
#file.download_to_file("/path/to/hello.txt")

# Updates content of the remote file.
#jjfile.update_from_file("/path/to/hello.txt")
#Example to read/write spreadsheets:

# Same as the code above to get access_token...

# Creates a session.
#session = GoogleDrive.login(access_token)

# First worksheet of
# https://docs.google.com/spreadsheet/ccc?key=pz7XtlQC-PYx-jrVMJErTcg
