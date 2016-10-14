class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :room

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
