import { Controller } from 'stimulus';
import { fire } from '@rails/ujs';

export default class extends Controller {
  connect() {
    if (this.open) {
      fire(this.element, 'click');
    }
  }

  get open() {
    return String(this.data.get('open')) === 'true';
  }
}
