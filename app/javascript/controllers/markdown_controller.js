import { Controller } from 'stimulus';

export default class extends Controller {
  static targets = ['textArea'];

  connect() {
    this.minRows = this.textAreaTarget.rows;
    this.resize();
  }

  resize() {
    const rows = this.textAreaTarget.value.split('\n').length + 1;

    if (rows !== this.textAreaTarget.rows) {
      this.textAreaTarget.rows = this.minRows > rows ? this.minRows : rows;
    }
  }
}
