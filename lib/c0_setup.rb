# an unofficial setup utility for C0, a subset of C used to teach 15-122 @ CMU
# should work on unix/bsd (linux/mac)

require 'fileutils'
require 'rbconfig'

class C0Setup

	# do the setup yo
	def setup
		to_do = check_precedence()
		result = []
		if to_do.include? "runpath"
			if create_runpath
				result.push "successfully created runpath"
			else
				result.push "failed to create runpath"
				return result
			end
		else
			result.push ".c0 folder already exists, remove it and retry if broken"
			return result
		end
		if to_do.include? "cc0" and to_do.include? "coin"
			if install_lib
				result.push "successfully installed cc0 and coin"
			else
				result.push "failed to install cc0 and coin"
			end
		else	
			result.push "coin or cc0 is already installed somewhere, remove it and retry if broken"
		end

	end

	# check for things that don't exist yet
	def check_precedence
		Dir.chdir(File.expand_path("~")) do
			not_yet = []
			if which("cc0").nil?
				not_yet.push("cc0") 
			end
			if which("coin").nil?
				not_yet.push("coin") 
			end
			if !Dir.exist?(".c0")
				not_yet.push("runpath")
			end
			return not_yet
		end
	end

	# create folder for binaries and set executable path
	def create_runpath
		Dir.chdir(File.expand_path("~")) do
			Dir.mkdir ".c0"
			File.new("#{File.expand_path("~")}/.bashrc", "w+") unless File.exist? ".bashrc"
			File.open(".bashrc", "a") do |file|
				file.puts "export PATH=$PATH:~/.c0/bin"
			end
			in_path = File.open(".bashrc", "r").read.include? "export PATH=$PATH:~/.c0/bin"
			return (in_path and Dir.exist? ".c0")
		end
	end
	# copy the c0 lib to "~/.c0" (OS specific)
	def install_lib
		user = File.expand_path("~")
		if get_os == "darwin"
			`tar -xvzf #{File.expand_path(File.dirname __dir__)}/c0_mac.tar.gz -C #{user}/.c0`
		elsif get_os == "linux"
			`tar -xvzf #{File.expand_path(File.dirname __dir__)}/c0_linux.tar.gz -C #{user}/.c0`
		end	
		return (File.exist?("#{user}/.c0/bin/cc0") and File.exist?("#{user}/.c0/bin/coin"))
	end

	
	# check for the presence of a binary in $PATH
	def which(cmd)
		exts = ENV['PATHEXT'] ? ENV['PATHEXT'].split(';') : ['']
		ENV['PATH'].split(File::PATH_SEPARATOR).each do |path|
			exts.each do |ext|
				exe = File.join(path, "#{cmd}#{ext}")
				return exe if File.executable?(exe) && !File.directory?(exe)
			end
		end
		return nil
	end

	# figure out the os
	def get_os
		result = ""
		os = RbConfig::CONFIG['host_os']
		if os.downcase.include?('linux')
  			result = 'linux'
		elsif os.downcase.include?('darwin')
  			result = 'darwin'
  		end
  		return result
  	end

end
