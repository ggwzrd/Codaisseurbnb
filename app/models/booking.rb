class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :room
  validate :dates_cannot_be_already_booked

  def dates_cannot_be_already_booked
    debugger
    errors.add(:starts_at, "Dates not available") unless
      Booking.where("starts_at <= :ends_at AND ends_at >= :starts_at", {starts_at: ends_at, ends_at: starts_at}) == []
  end

  def create
    checkin, checkout = get_dates(booking_params)
    room = Room.find(booking_params[:room_id])

    if room.available?(checkin, checkout)
      total_price = get_total_price(booking_params)
      @booking = current_user.bookings.create(booking_params.merge(total: total_price))
      redirect_to @booking.room, notice: "Thank you for booking!"
    else
      redirect_to room, notice: "Sorry! This listing is not available during the dates you requested."
    end
  end
end
