require 'json'
require 'pry'
require 'pry-byebug'

input_file = 'coverage/.resultset.json'
output_file = 'coverage/coverage_formatted.json'

coverage_data = JSON.parse(File.read(input_file))

simplecov_version = coverage_data["meta"]["simplecov_version"] rescue "0.22.0"
coverage = coverage_data["RSpec"]["coverage"] rescue {}
groups = coverage_data["groups"] rescue {}

formatted_data = {
  "meta" => {
    "simplecov_version" => simplecov_version
  },
  "coverage" => coverage,
  "groups" => groups
}

File.open(output_file, 'w') do |f|
  f.write(JSON.pretty_generate(formatted_data))
end

puts "Arquivo de cobertura formatado salvo em #{output_file}"