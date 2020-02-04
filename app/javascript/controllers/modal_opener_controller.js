import { Controller } from 'stimulus';
import { open } from './modal_controller';
import ajaxToHtml from '../utils/ajax_to_html';

export default class extends Controller {
  open(event) {
    event.preventDefault();
    open(ajaxToHtml(event));
  }
}
