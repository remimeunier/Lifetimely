require './daily_cost'
require 'date'

all_time_periods = %w(daily weekly monthly)

# time interval
start_date = Date.new(2019, 10, 1)
end_date = Date.new(2019, 10, 3)
time_period_costs = [
  {
    time_period: all_time_periods[0], # daily
    cost: 10.0
  },
  {
    time_period: all_time_periods[1], # weekly
    cost: 70.0
  },
  {
    time_period: all_time_periods[2], # monthly
    cost: 31.0
  }
]

puts daily_cost(start_date, end_date, time_period_costs)
