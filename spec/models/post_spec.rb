RSpec.describe Post, type: :model do
  # Testando validações
  it "is valid with valid attributes" do
    post = Post.new(title: "Valid Title", body: "Valid content.")
    expect(post).to be_valid
  end

  it "is not valid without a title" do
    post = Post.new(title: nil, body: "Some content.")
    expect(post).to_not be_invalid
  end

  it "is not valid without content" do
    post = Post.new(title: "Some Title", body: nil)
    expect(post).to_not be_invalid
  end

  # Adicione mais testes conforme necessário
end
