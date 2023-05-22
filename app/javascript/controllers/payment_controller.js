import { Controller } from "@hotwired/stimulus"

// Get your publishable API key from your server
const csrfToken = document.querySelector('meta[name="csrf-token"]').content;
const stripePublicKey = document.querySelector('meta[name="stripe-public-key"]').content;

// Create an instance of the Stripe object with your publishable API key
const stripe = Stripe(stripePublicKey);

// Create an instance of elements
let elements;

export default class extends Controller {
  static targets = ["element", "message", "submit", "form", "name", "email"]
  static values = {
    item: String,
    returnUrl: String,
  }

  async initialize() {
    const response = await fetch('/payment-intent', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'X-CSRF-Token': csrfToken
      },
      body: JSON.stringify(this.itemValue)
    });
    const { clientSecret } = await response.json();
    const appearance = { theme: 'stripe', locale: 'auto' };

    elements = stripe.elements({ clientSecret, appearance });
    const paymentElement = elements.create('payment');
    paymentElement.mount(this.elementTarget);
  }

  async purchase(event) {
    event.preventDefault();
    this.setLoading(true);

    // const formData = new FormData(this.formTarget);
    const { paymentIntent, error } = await stripe.confirmPayment({
      elements,
      redirect: "if_required",
      // confirmParams: {
      //   return_url: this.returnUrlValue,
      // },
      // paymentMethod: {
      //   card: elements.getElement('payment'),
      //   billing_details: {
      //     name: formData.get('name'),
      //     email: formData.get('email'),
      //   },
      // },
    });

    if (error) {
      if (error.type === 'card_error' || error.type === 'validation_error')
        this.showMessage(error.message);
      else this.showMessage('Something went wrong, please try again.');
    }
    else if (paymentIntent.status === 'succeeded') this.formTarget.submit();
    this.setLoading(false);
  }

  setLoading(isLoading) {
    if (isLoading) this.submitTarget.setAttribute('disabled', isLoading);
    else this.submitTarget.removeAttribute('disabled');
    this.submitTarget.textContent = isLoading ? 'Loading...' : 'Pay';
  }

  showMessage(message) {
    this.messageTarget.textContent = message;
    this.messageTarget.classList.remove('hidden');

    setTimeout(() => {
      this.messageTarget.classList.add('hidden');
      this.messageTarget.textContent = '';
    }, 5000);
  }
}
