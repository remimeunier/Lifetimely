require_relative "daily_cost"
require "test/unit"

class TestDailyCost < Test::Unit::TestCase

  def setup
    @start_date = Date.new(2019, 10, 29)
    @end_date = Date.new(2019, 10, 31)
    @end_date_2 = Date.new(2019, 11, 2)
    @daily_time_period = {
      time_period: ALL_TIME_PERIODS[0], # daily
      cost: 10
    }
    @weekly_time_period = {
      time_period: ALL_TIME_PERIODS[1], # weekly
      cost: 70.0
    }
    @monthly_time_period = {
      time_period: ALL_TIME_PERIODS[2], # monthly
      cost: 31
    }
    @time_periods = [@daily_time_period, @weekly_time_period, @monthly_time_period]
  end

  # Test raising erros
  def test_invalide_date_interval
    assert_raise(InvalidDateIntervalError) { daily_cost(@end_date, @start_date, @time_periods) }
  end
  def test_invalide_date
    assert_raise(InvalidDateError) { daily_cost(@start_date, nil, @time_periods) }
    assert_raise(InvalidDateError) { daily_cost(1, @start_date, @time_periods) }
  end
  def test_invalide_cost_key
    time_periods = [@daily_time_period, { time_period: ALL_TIME_PERIODS[1], coast: 70.0 }]
    assert_raise(InvalidCostKey) { daily_cost(@start_date, @end_date, time_periods) }
  end
  def test_invalide_cost_value
    time_periods = [@daily_time_period, { time_period: ALL_TIME_PERIODS[1], cost: '70' }]
    assert_raise(InvalidCostValue) { daily_cost(@start_date, @end_date, time_periods) }
  end

  # Test Edge cases
  def test_empty_time_periods
    result = daily_cost(@start_date, @end_date, [])
    assert result.size == 3
    for day in result
      assert day[:cost] == 0
    end
  end

  # Test Success with daily, weekly and monthly cost
  def test_daily_cost_on_one_day_and_complete_time_periods
    result = daily_cost(@start_date, @start_date, @time_periods)
    assert result.size == 1
    assert result.first[:cost] == 21
    assert result.first[:date] == @start_date.to_s
  end
  def test_daily_cost_on_three_day_same_month_and_complete_time_periods
    result = daily_cost(@start_date, @end_date, @time_periods)
    assert result.size == 3
    for day in result
      assert day[:cost] == 21
    end
    assert result[0][:date] == @start_date.to_s
    assert result[1][:date] == Date.new(2019, 10, 30).to_s
    assert result[2][:date] == @end_date.to_s
  end
  def test_daily_cost_on_three_day_different_month_and_complete_time_periods
    result = daily_cost(@end_date, @end_date_2, @time_periods)
    assert result.size == 3
    assert result[0][:cost] == 21
    assert result[1][:cost] == 20 + 31.0 / 30
    assert result[2][:cost] == 20 + 31.0 / 30
    assert result[0][:date] == @end_date.to_s
    assert result[1][:date] == Date.new(2019, 11, 1).to_s
    assert result[2][:date] == @end_date_2.to_s
  end

  # Test Success mix of daily, weekly, monthly
  def test_daily_cost_on_three_day_different_month_without_monthly_cost
    result = daily_cost(@end_date, @end_date_2, [@daily_time_period, @weekly_time_period])
    assert result.size == 3
    assert result[0][:cost] == 20
    assert result[1][:cost] == 20
    assert result[2][:cost] == 20
    assert result[0][:date] == @end_date.to_s
    assert result[1][:date] == Date.new(2019, 11, 1).to_s
    assert result[2][:date] == @end_date_2.to_s
  end
  def test_daily_cost_on_three_day_different_month_without_weekly_cost
    result = daily_cost(@end_date, @end_date_2, [@daily_time_period, @monthly_time_period])
    assert result.size == 3
    assert result[0][:cost] == 11
    assert result[1][:cost] == 10 + 31.0 / 30
    assert result[2][:cost] == 10 + 31.0 / 30
    assert result[0][:date] == @end_date.to_s
    assert result[1][:date] == Date.new(2019, 11, 1).to_s
    assert result[2][:date] == @end_date_2.to_s
  end
  def test_daily_cost_on_three_day_different_month_without_daily_cost
    result = daily_cost(@end_date, @end_date_2, [@weekly_time_period, @monthly_time_period])
    assert result.size == 3
    assert result[0][:cost] == 11
    assert result[1][:cost] == 10 + 31.0 / 30
    assert result[2][:cost] == 10 + 31.0 / 30
    assert result[0][:date] == @end_date.to_s
    assert result[1][:date] == Date.new(2019, 11, 1).to_s
    assert result[2][:date] == @end_date_2.to_s
  end
end
