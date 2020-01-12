import { Controller } from 'stimulus';
import ajaxToHtml from '../utils/ajax_to_html';

export default class extends Controller {
  update(event) {
    this.element.outerHTML = ajaxToHtml(event);
  }
}
