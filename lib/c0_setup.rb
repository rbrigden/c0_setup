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
		if to_do.include? "cc0"
			if install_cc0
				result.push "successfully installed cc0"
			else
				result.push "failed to install cc0"
			end
		else
			result.push "cc0 is already installed somewhere, remove it and retry if broken"
		end
		if to_do.include? "coin"
			if install_coin
				result.push "successfully installed coin"
			else
				result.push "failed to install coin"
			end
		else
			result.push "cc0 is already installed somewhere, remove it and retry if broken"
		end
		return result
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
			File.new ".bashrc" unless File.exist? ".bashrc"
			File.open(".bashrc", "a") do |file|
				file.puts "export PATH=$PATH:~/.c0"
			end
			in_path = File.open(".bashrc", "r").read.include? "export PATH=$PATH:~/.c0"
			return (in_path and Dir.exist? ".c0")
		end
	end

	def install_cc0
	# copy the cc0 binary to "~/.c0"
		user = File.expand_path("~")
		Dir.chdir(File.dirname __dir__) do
			if get_os == "darwin"
				FileUtils.cp("./cc0_mac", "#{user}/.c0/cc0")
			elsif get_os == "linux"
				FileUtils.cp("./cc0_linux", "#{user}/.c0/cc0")
			end	
		end
		return File.exist?("#{user}/.c0/cc0")
	end

	def install_coin
	# copy the coin binary to "~/.c0"
		user = File.expand_path("~")
		Dir.chdir(File.dirname __dir__) do
			if get_os == "darwin"
				FileUtils.cp("./coin_mac", "#{user}/.c0/coin")
			elsif get_os == "linux"
				FileUtils.cp("./coin_linux", "#{user}/.c0/coin")
			end	
		end
		return File.exist?("#{user}/.c0/coin")
	end

	def which(cmd)
	# check for the presence of a binary in $PATH
		exts = ENV['PATHEXT'] ? ENV['PATHEXT'].split(';') : ['']
		ENV['PATH'].split(File::PATH_SEPARATOR).each do |path|
			exts.each do |ext|
				exe = File.join(path, "#{cmd}#{ext}")
				return exe if File.executable?(exe) && !File.directory?(exe)
			end
		end
		return nil
	end

	
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

