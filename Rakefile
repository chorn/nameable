require 'bundler/gem_tasks'
require 'digest/sha2'

task default: %w[build]

desc "Update checksums for gems in ./pkg"
task :checksums do
  Dir.glob('pkg/*.gem').each do |gem|
    checksum = Digest::SHA512.new.hexdigest(File.read(gem))
    File.open("#{gem.gsub(/pkg/, 'checksums')}.sha512", 'w' ) {|f| f.write(checksum) }
  end
end

