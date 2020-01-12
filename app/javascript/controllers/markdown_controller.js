import { Controller } from 'stimulus';

const BOLD = '**';
const ITALIC = '_';
const STRIKE = '~~';
const QUOTE = '> ';
const CODE = '    ';
const ORDERED_LIST = '1. ';
const UNORDERED_LIST = '- ';
const LINK = '[link text](https://example.com)';
const TABLE = '\n| First | Second | Third |\n| First | Second | Third |\n\n';

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
    this.surround(BOLD);
  }

  italic() {
    this.surround(ITALIC);
  }

  strike() {
    this.surround(STRIKE);
  }

  quote() {
    this.prepend(QUOTE);
  }

  code() {
    this.prepend(CODE);
  }

  table() {
    const { text, start } = this.textStats;
    const beforeNewLine = text.slice(0, start).lastIndexOf('\n');

    const insertAt = beforeNewLine < 0 ? 0 : beforeNewLine + 1;
    const startText = text.slice(0, insertAt);
    const endText = text.slice(insertAt);
    this.textAreaTarget.value = `${startText}${TABLE}${endText}`;
    this.resize();
  }

  link() {
    const { text, start, end } = this.textStats;

    const startText = text.slice(0, start);
    const middleText = text.slice(start, end);
    const endText = text.slice(end);

    const linkText =
      middleText.length === 0 ? LINK : LINK.replace('link text', middleText);

    this.textAreaTarget.value = [startText, linkText, endText].join('');
    this.resize();
  }

  ordered() {
    this.prepend(ORDERED_LIST);
  }

  unordered() {
    this.prepend(UNORDERED_LIST);
  }

  surround(markdown) {
    const { text, start, end } = this.textStats;

    const startText = text.slice(0, start);
    const middleText = text.slice(start, end);
    const endText = text.slice(end);

    this.textAreaTarget.value = [startText, middleText, endText].join(markdown);
    this.resize();
  }

  prepend(markdown) {
    const { text, start, end } = this.textStats;

    const beforeFirstNewLine = text.slice(0, start).lastIndexOf('\n');
    const beforeLastNewLine = text.slice(0, end).lastIndexOf('\n');

    const insertFirstAt = beforeFirstNewLine < 0 ? 0 : beforeFirstNewLine + 1;
    const insertLastAt = beforeLastNewLine < 0 ? 0 : beforeLastNewLine + 1;

    const startText = text.slice(0, insertFirstAt);
    const middleTexts = text
      .slice(insertFirstAt, insertLastAt)
      .split('\n')
      .filter(t => t.length !== 0)
      .map(t => `${t}\n`);
    const endText = text.slice(insertLastAt);

    console.log(middleTexts);

    this.textAreaTarget.value = [startText, ...middleTexts, endText].join(
      markdown
    );
    this.resize();
  }

  get textStats() {
    const text = this.textAreaTarget.value;
    const start = this.textAreaTarget.selectionStart;
    const end = this.textAreaTarget.selectionEnd;

    return { text, start, end };
  }
}
