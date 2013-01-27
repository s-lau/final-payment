# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

def create_random_charge event, user
  user.joined_events.push event
  stuff = %w{Beer Wine Meat Toys Plates CDs Juices Drinks Vegetables Fruits Crackers Chips Corn Beef Spices Sauces}
  charge = EventCharge.new
  charge.event = event
  charge.user = user
  charge.name = stuff.sample
  charge.price_cents = rand(100..1500)
  charge.save
end

def create_random_event owner
  event_name = %w{Party Birthday Football-Game Olympics Grand-Finale Sleep-Over Pyjama-Party Concert}.sample
  Event.create name: "#{owner.username.capitalize}'s #{event_name}", description: "That was some really awesome #{event_name}", owner: owner
end

if Rails.env == "development"
  EventCharge.delete_all
  EventComment.delete_all
  EventParticipation.delete_all
  Event.delete_all
  User.delete_all

  names = %w{Stefan Hendrik Arsenij John Jaime Steven Rick Paula Charlotte Mimi Homer Bart Lisa Marge Montgomery Rico Bertha Robert Bob Alice Eve Albert Rob}.shuffle

  names.each_with_index do |name,i|
    user = User.create email: "test#{i}@example.com", username: name.downcase, :password => '123', :password_confirmation => '123'
    user.confirm!

    if i%5 == 0
      (1..rand(5)).each do
        create_random_event user
      end
    end
  end

  Event.all.each do |event|
    (0..rand(0..10)).each do
      random_user = User.where('id != ?', event.owner.id).sample

      unless random_user.joined_events.include? event
        event_participation = EventParticipation.new
        event_participation.user= random_user
        event_participation.event= event
        event_participation.save
      end
      create_random_charge event, random_user
    end
  end
end



