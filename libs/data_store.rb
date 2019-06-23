require "csv"
require "fileutils"

class DataStore
  PATH = "data"
  FILE = "store.csv"

  def initialize
    mode = "wb"
    if File.exist?("#{PATH}/#{FILE}")
      mode = "ab"
    end
    @csv = CSV.open("#{PATH}/#{FILE}", mode)
  end

  def save(data)
    data.each { |row| @csv << row }
  end

  class << self
    def read
      CSV.foreach("#{PATH}/#{FILE}") do |row|
        yield(row)
      end
    end

    def backup(given_path)
      FileUtils.cp("#{PATH}/#{FILE}", "#{given_path}/#{FILE}.bkp")
    end

    def restore(given_path)
      FileUtils.cp("#{given_path}/#{FILE}.bkp", "#{PATH}/#{FILE}")
    end

    private

    def copy(src, dest)
      FileUtils.cp(src, dest)
    end
  end
end
