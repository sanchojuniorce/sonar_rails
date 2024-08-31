require 'json'
require 'simplecov'
require 'pry'
require 'pry-byebug'

file_path = 'coverage/.resultset.json'
output_file = 'coverage/coverage_formatted.json'

# Função para ler o arquivo JSON
def read_coverage_report(file_path)
  raise "Arquivo de cobertura não encontrado em #{file_path}" unless File.exist?(file_path)
  data = JSON.parse(File.read(file_path))
  puts JSON.pretty_generate(data) # Para depuração
  data
end

# Função para calcular a porcentagem de linhas cobertas
def calculate_covered_percent(lines)
  total_lines = lines.size
  return 0 if total_lines == 0 # Evitar divisão por zero
  covered_lines = lines.compact.count { |line| line.to_i > 0 }
  (covered_lines.to_f / total_lines * 100).round(2)
end

# Função para gerar o hash no formato desejado
def generate_groups(coverage_data)
  groups = {
    'Controllers' => { 'lines' => { 'covered_percent' => 0.0 }, 'file_count' => 0 },
    'Models' => { 'lines' => { 'covered_percent' => 0.0 }, 'file_count' => 0 },
    'Mailers' => { 'lines' => { 'covered_percent' => 0.0 }, 'file_count' => 0 },
    'Helpers' => { 'lines' => { 'covered_percent' => 0.0 }, 'file_count' => 0 },
    'Jobs' => { 'lines' => { 'covered_percent' => 0.0 }, 'file_count' => 0 },
    'Libraries' => { 'lines' => { 'covered_percent' => 0.0 }, 'file_count' => 0 },
    'Ungrouped' => { 'lines' => { 'covered_percent' => 0.0 }, 'file_count' => 0 }
  }

  file_paths = coverage_data['RSpec']['coverage']

  file_paths.each do |file_path, file_data|
    lines = file_data['lines'] || [] # Garanta que lines é um array
    covered_percent = calculate_covered_percent(lines)

    case file_path
    when %r{/app/controllers/}
      groups['Controllers']['lines']['covered_percent'] += covered_percent
      groups['Controllers']['file_count'] += 1
    when %r{/app/models/}
      groups['Models']['lines']['covered_percent'] += covered_percent
      groups['Models']['file_count'] += 1
    else
      groups['Ungrouped']['lines']['covered_percent'] += covered_percent
      groups['Ungrouped']['file_count'] += 1
    end
  end

  # Ajuste a porcentagem de cobertura para cada grupo
  groups.each do |group_name, data|
    file_count = data['file_count']
    data['lines']['covered_percent'] = file_count > 0 ? (data['lines']['covered_percent'] / file_count).round(2) : 0
  end

  groups
end

begin
  coverage_data = read_coverage_report(file_path)
  simplecov_version = begin
    SimpleCov::VERSION
  rescue StandardError
    nil
  end
  coverage = begin
    coverage_data['RSpec']['coverage']
  rescue StandardError
    {}
  end
  groups = generate_groups(coverage_data)

  formatted_data = {
    'meta' => {
      'simplecov_version' => simplecov_version
    },
    'coverage' => coverage,
    'groups' => groups
  }

  File.open(output_file, 'w') do |f|
    f.write(JSON.pretty_generate(formatted_data))
  end
  puts 'Arquivo coverage_formatted.json gerado com sucesso.'
rescue StandardError => e
  puts "Erro ao processar o relatório de cobertura: #{e.message}"
end
