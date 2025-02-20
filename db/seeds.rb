# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

{
  'rvoss' => { name: 'Robert Voß', password: 'bfpi', role: User.roles[:admin] },
  'nbennke' => { name: 'Niels Bennke', password: 'bfpi', role: User.roles[:admin] }
}.each do |login, hsh|
  User.find_or_create_by!(active: true, login:) do |user|
    user.name = hsh[:name]
    user.role = hsh[:role]
    user.password = hsh[:password]
  end
end
