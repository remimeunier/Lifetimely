require 'date'

# errors
class InvalidDateIntervalError < StandardError; end
class InvalidDateError < StandardError; end
class InvalidCostValue < StandardError; end
class InvalidCostKey < StandardError; end

ALL_TIME_PERIODS = %w(daily weekly monthly)

def daily_cost(start_date, end_date, time_period_costs)
  # Date Validation
  validate_interval(start_date, end_date)

  # Cost set up and validation
  daily_and_weekly_cost_per_day = get_value(time_period_costs, ALL_TIME_PERIODS[0]) +
                                  get_value(time_period_costs, ALL_TIME_PERIODS[1]).to_f / 7
  monthly_cost = get_value(time_period_costs, ALL_TIME_PERIODS[2]).to_f
  result = []

  # Don't bother to calculate months, if we don't have monthly cost
  if monthly_cost == 0
    (start_date..end_date).each do |date|
      result << { date: date.to_s, cost: daily_and_weekly_cost_per_day }
    end
  else
    current_month = nil
    nbr_of_days_in_current_month = nil
    monthly_cost_per_day = nil
    (start_date..end_date).each do |date|
      # Recalculate current_month and current_days_in_month on month changes
      unless  date.month == current_month
        nbr_of_days_in_current_month = Date.new(date.year, date.month, -1).day
        current_month = date.month
        monthly_cost_per_day = monthly_cost / nbr_of_days_in_current_month
      end
      result << { date: date.to_s, cost: daily_and_weekly_cost_per_day + monthly_cost_per_day }
    end
  end
  result
end

def validate_interval(start_date, end_date)
  raise InvalidDateError unless start_date.instance_of?(Date)
  raise InvalidDateError unless end_date.instance_of?(Date)
  raise InvalidDateIntervalError if start_date > end_date
end

def validate_cost_value(cost)
  raise InvalidCostKey unless cost
  raise InvalidCostValue unless cost.kind_of?(Integer) or cost.kind_of?(Float)
  cost
end

def get_value(time_period_costs, time_periode)
  period = time_period_costs.find { |time_period_cost|  time_period_cost[:time_period] == time_periode }
  period.nil? ? 0 : validate_cost_value(period[:cost])
end
