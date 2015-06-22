require 'rfusefs'
require 'net/http'
require 'open-uri'

class PRCD
  def initialize()
    @prcd = { "cristo" => "cri",
              "gesu" => "ges",
              "madonna" => "mad",
              "dio" => "dio",
              "madre_teresa" => "mtc",
              "papa" => "pap",
              "varie" => "vsf"
            }
    @prcd.each do |key, value|
      url = "http://www.papuasia.org/prcd/prcd_"+value+".txt"
      puts url
      @prcd[key] = []
      open(url).each_line do |r|
        @prcd[key].push(r.chomp)
      end
    end
  end
  
  def contents(path)
    @prcd.keys.push("random")
  end

  def file?(path)
    file, o = scan_path(path)
    if !file.nil? && (@prcd.has_key?(file) || file == "random") && o == nil 
      return true
    end
    return false
  end

  def size(path)
    10000
  end
  
  def read_file(path)
    file, o = scan_path(path)
    if file == "random"
      @prcd[@prcd.keys.sample].sample
    else
      @prcd[file].sample
    end
  end
end


FuseFS.start(PRCD.new, ARGV.shift)
