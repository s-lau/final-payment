# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Event.delete_all
User.delete_all

(1..30).each do |n|
  user = User.create email: "test#{n}@example.com", username: "test#{n}", :password => '123', :password_confirmation => '123'
  user.confirm!
  (1..5).each do |nr|
    Event.create owner:user, name: "User #{n}'s Test-Event No. #{nr}'", description: "Description"
  end
end

