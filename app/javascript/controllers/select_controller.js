import { Controller } from 'stimulus';
import Choices from 'choices.js';


export default class extends Controller {
  connect() {
    this.choices = new Choices(this.element);
  }

  disconnect() {
    // Cleaning up will crash the browser ....
    // choices.destroy();
  }
}
