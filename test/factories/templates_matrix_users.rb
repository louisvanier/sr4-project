FactoryBot.define do
  factory :templates_matrix_user, class: 'Templates::MatrixUser' do
    user { nil }
    name { "MyString" }
    reaction { 1 }
    intuition { 1 }
    logic { 1 }
    willpower { 1 }
    computer { 1 }
    cybercombat { 1 }
    data_search { 1 }
    electronic_warfare { 1 }
    hacking { 1 }
    programs { "MyText" }
    access_id { "MyString" }
  end
end
