require 'rbconfig'

def os
  @os ||= (
    host_os = RbConfig::CONFIG['host_os']
    case host_os
    when /mswin|msys|mingw|cygwin|bccwin|wince|emc/
      :windows
    when /darwin|mac os/
      :macosx
    when /linux/
      :linux
    when /solaris|bsd/
      :unix
    else
      raise Error::WebDriverError, "unknown os: #{host_os.inspect}"
    end
  )
end

def get_dirs_from_path_env
  os_detect = os()
  case os_detect
  when :windows
    sp_char = ';'
  when :macosx
    sp_char = ':'
  when :linux
    sp_char = ':'
  when :unix
    sp_char = ':'
  else
    raise Error::WebDriverError, "unknown os: #{os_detect}"
  end
  path_ar = ENV['PATH'].split(sp_char)
  return path_ar
end

def find_files_in_dirs(path_ar, glob_pattern)
    found_ar = Array.new
    path_ar.each do |d|
        #puts "d #{d}"
        if File.directory? d 
            #puts "  DIR"
            Dir.chdir(d)
            Dir.glob(glob_pattern).each do|f|
                full_path = File.join(d, f)
                found_ar.push(full_path)
                #puts "f: #{f}"
            end
        else
            #puts "  NOT DIR"
        end
    end
    return found_ar
end
module Puppet::Parser::Functions
  newfunction(:find_virtualenvwrapper, :type => :rvalue, :doc => <<-EOS
    Returns the string of the path to virtualenvwrapper
    EOS
  ) do |arguments|

    found_ar = find_files_in_dirs(get_dirs_from_path_env(), 'virtualenvwrapper.sh')
    if found_ar.length != 1
      return false
    end
    return found_ar[0]
  end
end
