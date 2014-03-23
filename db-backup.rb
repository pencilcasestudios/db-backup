if ARGV[0] && ARGV[1] && ARGV[2] && ARGV[3]
	username = ARGV[0]
	database_name = ARGV[1]
	password = ARGV[2]
        s3_bucket_name = ARGV[3]

	dump_filename = Time.now.strftime("#{database_name.downcase}-%Y%m-%H.sql")

	backup_file_path = "~/Projects/Backups/#{database_name}"

	`mkdir -p #{backup_file_path}`
	`mysqldump --verbose -u #{username} -p#{password} #{database_name} > #{backup_file_path}/#{dump_filename}`
	`gzip --force --verbose #{backup_file_path}/#{dump_filename}`
	`s3cmd --encrypt --verbose put #{backup_file_path}/#{dump_filename}.gz s3://#{s3_bucket_name}`
else
	puts "Usage: #{__FILE__} <username> <database> <password> <s3bucket>"
end
