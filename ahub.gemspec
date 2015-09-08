Gem::Specification.new do |s|
  s.name        = 'ahub'
  s.version     = '0.0.1'
  s.date        = '2015-09-07'
  s.summary     = "¡AHub!"
  s.description = "A gem to interact with the Answer Hub API"
  s.authors     = ["Abel Martin"]
  s.email       = 'abel.martin@gmail.com'
  s.files       = %w(
    lib/ahub.rb
    lib/ahub/answer.rb
    lib/ahub/user.rb
    lib/ahub/modules/api_helpers.rb
  )
  s.homepage    = 'https://github.com/abelmartin/ahub'
  s.license     = 'MIT'
end
