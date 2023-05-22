import { Controller } from "@hotwired/stimulus"

// Get your publishable API key from your server
const csrfToken = document.querySelector('meta[name="csrf-token"]').content;
const stripePublicKey = document.querySelector('meta[name="stripe-public-key"]').content;

// Create an instance of the Stripe object with your publishable API key
const stripe = Stripe(stripePublicKey);

// Create an instance of elements
const elements = stripe.elements();

export default class extends Controller {
  static targets = [ "element", "message", "submit", "form", "name", "email" ]
  static values = {
    item: String,
    returnUrl: String,
  }

  connect() {
    console.log("Payment controller connected")
  }
}
