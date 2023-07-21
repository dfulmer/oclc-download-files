require 'net/ftp'
require 'fileutils'

# FTP server credentials
FTP_HOST = ENV.fetch("FTP_HOST")
FTP_USERNAME = ENV.fetch("FTP_USERNAME")
FTP_PASSWORD = ENV.fetch("FTP_PASSWORD")

# Remote and local directories
REMOTE_DIR = '/xfer/metacoll/reports'
LOCAL_DIR = 'scratch'
PROCESSED_DIR = 'processed'

# Regular expression for file name matching
FILE_REGEX = /\.BibCrossRefReport\.txt\z/

def download_files
  ftp = Net::FTP.new(FTP_HOST)
  ftp.login(FTP_USERNAME, FTP_PASSWORD)
  ftp.chdir(REMOTE_DIR)

  files_to_download = ftp.nlst.select { |filename| filename =~ FILE_REGEX }

  FileUtils.mkdir_p(LOCAL_DIR)

  files_to_download.each do |filename|
    local_path = File.join(LOCAL_DIR, filename)
    ftp.getbinaryfile(filename, local_path)
  end

  ftp.close
end

def process_files
  downloaded_files = Dir.glob(File.join(LOCAL_DIR, "*.BibCrossRefReport.txt"))
  processed_files = Dir.glob(File.join(PROCESSED_DIR, "*.BibCrossRefReport.txt"))

  downloaded_files.each do |downloaded_file|
    filename = File.basename(downloaded_file)
    if processed_files.include?(File.join(PROCESSED_DIR, filename))
      puts "#{filename} already in processed"
      File.delete(downloaded_file)
    else
      # Process file with oclc_cross_ref_process.rb
      puts "#{filename} not already in processed"
      FileUtils.mv(downloaded_file, File.join(PROCESSED_DIR, filename))
    end
  end
end

download_files
process_files
