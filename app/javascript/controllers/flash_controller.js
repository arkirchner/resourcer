import { Controller } from 'stimulus';
import getTransitionDurationFromElement from '../utils/get_transition_duration_from_element';

export default class extends Controller {
  close(event) {
    event.preventDefault();
    this.element.classList.remove('show');
    setTimeout(() => {
      this.element.classList.add('d-none');
    }, this.transitionDuration);
  }

  get transitionDuration() {
    return getTransitionDurationFromElement(this.element);
  }
}
