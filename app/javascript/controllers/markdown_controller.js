import { Controller } from 'stimulus';

const BOLD = '**';
const ITALIC = '_';
const STRIKE = '~~';

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

  bold() {
    this._surround(BOLD);
  }

  italic() {
    this._surround(ITALIC);
  }

  strike() {
    this.surround(STRIKE);
  }

  surround(markdown) {
    const { text, start, end } = this.testStats;

    const startText = text.slice(0, start);
    const middleText = text.slice(start, end);
    const endText = text.slice(end);

    this.textAreaTarget.value = [
      startText,
      markdown,
      middleText,
      markdown,
      endText,
    ].join('');
  }

  get testStats() {
    const text = this.textAreaTarget.value;
    const start = this.textAreaTarget.selectionStart;
    const end = this.textAreaTarget.selectionEnd;

    return { text, start, end };
  }
}
