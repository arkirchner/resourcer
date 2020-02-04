import { Controller } from 'stimulus';
import { close as closeModal } from './modal_controller';

export default class extends Controller {
  close(event) {
    event.preventDefault();
    closeModal();
  }
}
