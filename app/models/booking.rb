class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :room
  validate :is_available?
  before_create :set_check_in_times

  def self.during arrival, departure
    arrival = arrival.change(hour: 14, min: 00, sec: 00)
    departure = departure.change(hour: 11, min: 00, sec: 00)
    starts_before_ends_after(arrival, departure).or( ends_during(arrival, departure) ).or(start_during(arrival,departure))
  end

  def self.starts_before_ends_after arrival, departure
    where("starts_at < ? AND ends_at >= ?", arrival, departure)
  end

  def self.start_during arrival, departure
    where("starts_at BETWEEN ? AND ?", arrival, departure)
  end

  def self.ends_during arrival, departure
    where("ends_at BETWEEN ? AND ?", arrival, departure)
  end

  private
    def set_check_in_times
      self.starts_at = starts_at.change(hour: 14, min: 00, sec: 00)
      self.ends_at = ends_at.change(hour: 11, min: 00, sec: 00)
    end

    def is_available?
      if Booking.where("starts_at <= ? AND ends_at >= ?", ends_at, starts_at) != []
        errors.add(:starts_at, "Date Not Available")
        return false
      else
        return true
      end
    end

end
