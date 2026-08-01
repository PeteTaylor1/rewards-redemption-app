User.destroy_all
Reward.destroy_all
Redemption.destroy_all

user = User.create!(
  name: "Demo User",
  points_balance: 1000
)

rewards = [
  { name: "Free Coffee", description: "Redeem for a free coffee at any participating location.", points_cost: 100 },
  { name: "Movie Ticket", description: "One free movie ticket (standard seating).", points_cost: 250 },
  { name: "$10 Gift Card", description: "Digital gift card usable at partner stores.", points_cost: 400 },
  { name: "Wireless Earbuds", description: "Premium wireless earbuds (while supplies last).", points_cost: 800 },
  { name: "Weekend Getaway Voucher", description: "One night stay at select hotels.", points_cost: 1500 }
]

rewards.each { |attrs| Reward.create!(attrs) }

puts "Seeded #{User.count} user(s) and #{Reward.count} rewards."
puts "Demo user id=#{user.id} starts with #{user.points_balance} points."
