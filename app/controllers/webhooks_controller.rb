class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    payload = request.body.read
    signature_header = request.env['HTTP_STRIPE_SIGNATURE']
    endpoint_secret = Rails.application.credentials.dig(:stripe, :whsc)
    event = nil

    begin
      event = Stripe::Webhook.construct_event(
        payload, signature_header, endpoint_secret
      )
    rescue JSON::ParserError => e
      # Invalid payload
      render json: { message: e.message }, status: :bad_request
      return
    rescue Stripe::SignatureVerificationError => e
      # Invalid signature
      render json: { message: e.message }, status: :bad_request
      return
    end

    # Handle the event
    case event.type
    when 'payment_intent.succeeded'
      session = event.data.object
      # Send email to customer notifying them that their payment was successful.
      # Be sure to approve the booking.
      @user = User.find(session.metadata['user_id'])
      @bookings = Booking.where(booking_type_id: @user.booking_type_ids)
      @booking = @bookings.last
      @booking.update(customer_paid: true, status: 'approved')

      puts "Checkout session #{session.id} succeeded."
    when 'payment_intent.processing'
      session = event.data.object
      # Send email to customer notifying them that their payment is processing.
      puts "Checkout session #{session.id} processing."
    when 'payment_intent.payment_failed'
      session = event.data.object
      # Send email to customer notifying them that their payment failed.
      # Be sure to unapprove the booking.
      puts "Checkout session #{session.id} failed."
    when 'charge.succeeded'
      charge = event.data.object
      # Send email to customer notifying them that their payment was successful.
      # Be sure to approve the booking.
      puts "Charge #{charge.id} succeeded."
    else
      # Unexpected event type
      puts "Unexpected event type: #{event.type}"
    end
  end
end
