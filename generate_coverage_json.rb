require 'json'
require 'simplecov'
require 'pry'
require 'pry-byebug'

file_path = 'coverage/.resultset.json'
output_file = 'coverage/coverage_formatted.json'

# Função para ler o arquivo JSON
def read_coverage_report(file_path)
  if File.exist?(file_path)
    JSON.parse(File.read(file_path))
  else
    raise "Arquivo de cobertura não encontrado em #{file_path}"
  end
end

# Função para calcular a porcentagem de linhas cobertas
def calculate_covered_percent(lines)
  total_lines = lines.size
  covered_lines = lines.compact.count { |line| line > 0 }
  (covered_lines.to_f / total_lines * 100).round(2)
end

# Função para gerar o hash no formato desejado
def generate_groups(coverage_data)
  groups = {
    "Controllers" => { "lines" => { "covered_percent" => 0.0 } },
    "Models" => { "lines" => { "covered_percent" => 0.0 } },
    "Mailers" => { "lines" => { "covered_percent" => 0.0 } },
    "Helpers" => { "lines" => { "covered_percent" => 0.0 } },
    "Jobs" => { "lines" => { "covered_percent" => 0.0 } },
    "Libraries" => { "lines" => { "covered_percent" => 0.0 } },
    "Ungrouped" => { "lines" => { "covered_percent" => 0.0 } }
  }

  file_paths = coverage_data['RSpec']['coverage']

  file_paths.each do |file_path, file_data|
    lines = file_data['lines']
    covered_percent = calculate_covered_percent(lines)

    case file_path
    when %r{/app/controllers/}
      groups["Controllers"]["lines"]["covered_percent"] += covered_percent
    when %r{/app/models/}
      groups["Models"]["lines"]["covered_percent"] += covered_percent
    else
      groups["Ungrouped"]["lines"]["covered_percent"] += covered_percent
    end
  end

  # Ajuste a porcentagem de cobertura para cada grupo
  groups.each do |group_name, data|
    total_files = file_paths.keys.count { |file_path| file_path.include?(group_name.downcase) }
    data["lines"]["covered_percent"] = total_files > 0 ? (data["lines"]["covered_percent"] / total_files).round(2) : 0
  end

  groups
end


begin
  coverage_data = read_coverage_report(file_path)
  simplecov_version = SimpleCov::VERSION rescue nil
  coverage = coverage_data["RSpec"]["coverage"] rescue {}
  groups = generate_groups(coverage_data)

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
  puts "Arquivo coverage_formatted.json gerado com sucesso."
rescue => e
  puts "Erro ao processar o relatório de cobertura: #{e.message}"
end
