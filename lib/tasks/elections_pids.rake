desc "f3/f4 pid mapping"
namespace :tufts do

desc "import_elections_table"
  task import_elections_table: :environment do
    row_count = 0

    CSV.foreach("/home/hydradm/tdl/import_f4_elections.txt", :headers => true, :header_converters => :symbol, encoding: "ISO8859-1:utf-8") do |row|
      f4_pid = row[0]
      f3_pid = row[1] 
      begin
        ElectionsPidMapping.create!(f3_pid: f3_pid, f4_id: f4_pid)
      rescue ActiveRecord::RecordNotUnique => rnu
         puts "Record not unique: #{f3_pid}"
      end
    end
  end
end
