# module Printable
#   extend ActiveSupport::Concern
#
#   def printer_folder
#     path + "/printer"
#   end
#
#   def latest_printer_file
#     Dir.glob("#{printer_folder}/*.pdf").sort.last
#   end
#
#   def printer_file_version
#     latest_printer_file.split("_")[1].to_i
#   end
#
#   def backup_printer_file
#     target_file = printer_folder + "/section_0.pdf"
#     FileUtils.mkdir_p(printer_folder) unless File.exist?(printer_folder)
#     current_files = Dir.glob("#{printer_folder}/*.pdf")
#     if current_files.length > 0
#       target_file = printer_folder + "/section_#{current_files.length}.pdf"
#     end
#     FileUtils.cp(printer_file, target_file)
#   end
#
#   def copy_to_printer_ftp
#     backup_printer_file
#     dong_a
#     jung_ang
#     news_pdf
#     ex_pdf
#     true
#   end
#
#   def dong_a_code
#     date = issue.date
#     m = date.month.to_s.rjust(2,"0")
#     d = date.day.to_s.rjust(2,"0")
#     pg = page_number.to_s.rjust(2,"0")
#     if printer_file_version == 0
#       "NA#{m}#{d}#{pg}NB01.pdf"
#     else
#       "NA#{m}#{d}#{pg}NB0#{printer_file_version + 1}.pdf"
#     end
#   end
#
#   def dong_a
#     puts "sending it to Dong-A"
#     ip        = '210.115.142.181'
#     id        = 'naeil'
#     pw        = 'cts@'
#     Net::FTP.open(ip, id, pw) do |ftp|
#       ftp.putbinaryfile(printer_file, "/mono/#{dong_a_code}")
#     end
#   end
#
#   def jung_ang_code
#     date = issue.date
#     m = date.month.to_s.rjust(2,"0")
#     d = date.day.to_s.rjust(2,"0")
#     pg = page_number.to_s.rjust(2,"0")
#     if printer_file_version == 0
#      "zn#{m}#{d}#{pg}10001.pdf"
#     else
#      "zn#{m}#{d}#{pg}10001_#{printer_file_version}.pdf"
#     end
#   end
#
#   def jung_ang
#     puts "sending it to Jung-Ang"
#     ip        = '112.216.44.45:2121'
#     id        = 'naeil'
#     pw        = 'sodlf@2018'
#     # upload files
#     ftp = Net::FTP.new  # don't pass hostname or it will try open on default port
#     ftp.connect('112.216.44.45', '2121')  # here you can pass a non-standard port number
#     ftp.login('naeil', 'sodlf@2018')
#     # ftp.passive = true  # optional, if PASV mode is required
#     # Net::FTP.open(ip, id, pw) do |ftp|
#     ftp.putbinaryfile(printer_file, "/Naeil/#{jung_ang_code}")
#     # end
#   end
#
#   def news_pdf_code
#     yyyymd = issue.date.strftime("%Y%m%d")
#     pg = page_number.to_s.rjust(2,"0")
#     "#{yyyymd}-#{pg}.pdf"
#   end
#
#   def news_pdf
#     puts "sending it to News PDF"
#     ip        = '211.115.91.231'
#     id        = 'comp'
#     pw        = '*4141'
#     yyyymd = issue.date.strftime("%Y%m%d")
#     Net::FTP.open(ip, id, pw) do |ftp|
#       ftp.putbinaryfile(printer_file, "/NewsPDF/#{yyyymd}/#{news_pdf_code}")
#     end
#   end
#
#   def ex_pdf_code
#     jeho = issue.number
#     yymd = issue.date.strftime("%y%m%d")
#     pg = page_number.to_s.rjust(2,"0")
#     "#{jeho}-#{yymd}#{pg}.pdf"
#   end
#
#   def ex_pdf
#     puts "sending it to External PDF"
#     ip        = '211.115.91.231'
#     id        = 'comp'
#     pw        = '*4141'
#     yyyymd = issue.date.strftime("%Y%m%d")
#     Net::FTP.open(ip, id, pw) do |ftp|
#       ftp.putbinaryfile(printer_file, "/외부전송PDF/#{ex_pdf_code}")
#     end
#   end
#
#
# end
