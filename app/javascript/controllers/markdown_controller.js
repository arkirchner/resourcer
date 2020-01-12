import { Controller } from 'stimulus';

const BOLD = '**';
const ITALIC = '_';
const STRIKE = '~~';
const ORDERED_LIST = '1. ';
const UNORDERED_LIST = '- ';

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

  ordered() {
    this.prepend(ORDERED_LIST);
  }

  unordered() {
    this.prepend(UNORDERED_LIST);
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

  prepend(markdown) {
    const { text, start, end } = this.testStats;

    const beforeNewLine = text.slice(0, start).lastIndexOf('\n');
    const insertAt = beforeNewLine < 0 ? 0 : beforeNewLine + 1;

    const startText = text.slice(0, insertAt);
    const endText = text.slice(insertAt);

    this.textAreaTarget.value = [startText, markdown, endText].join('');
  }

  get testStats() {
    const text = this.textAreaTarget.value;
    const start = this.textAreaTarget.selectionStart;
    const end = this.textAreaTarget.selectionEnd;

    return { text, start, end };
  }
}
