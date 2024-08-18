require 'json'

# Carregar o JSON gerado pelo SimpleCov
input_file = 'coverage/coverage.json'
output_file = 'coverage/coverage_formatted.json'

# Ler o arquivo JSON
coverage_data = JSON.parse(File.read(input_file))

# Inicializar a estrutura formatada
formatted_data = {
  "meta" => {
    "simplecov_version" => "0.22.0"#coverage_data["version"]
  },
  "coverage" => {},
  "groups" => {}
}

# Verificar se "results" está presente e é um array
if coverage_data["results"].is_a?(Array)
  coverage_data["results"].each do |file|
    formatted_data["coverage"][file["filename"]] = {
      "lines" => file["coverage"],
      "branches" => [] # Adaptar conforme necessário
    }
  end
else
  puts "Formato inesperado no arquivo de cobertura: 'results' não encontrado ou não é um array."
end

# Adicionar dados agregados para grupos
if coverage_data["groups"].is_a?(Hash)
  coverage_data["groups"].each do |group_name, group_data|
    formatted_data["groups"][group_name] = {
      "lines" => {
        "covered_percent" => group_data["covered_percent"]
      }
    }
  end
else
  puts "Formato inesperado para grupos de cobertura."
end

# Salvar o arquivo JSON formatado
File.open(output_file, 'w') do |f|
  f.write(JSON.pretty_generate(formatted_data))
end

puts "Arquivo de cobertura formatado salvo em #{output_file}"