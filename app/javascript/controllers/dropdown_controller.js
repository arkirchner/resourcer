import { Controller } from 'stimulus';

const ESCAPE_KEYS = ['Escape', 'Esc'];
const DOWN_KEYS = ['Down', 'ArrowDown'];
const UP_KEYS = ['Up', 'ArrowUp'];
const TAB_KEY = 'Tab';

export default class extends Controller {
  static targets = ['menu', 'item'];

  connect() {
    this.state = false;
    document.addEventListener('click', this._closeByClickOutside, false);
    document.addEventListener('keydown', this._escapeAndArrowKey, false);
    document.addEventListener('keyup', this._tabKey, false);
  }

  disconnect() {
    document.removeEventListener('click', this._closeByClickOutside, false);
    document.removeEventListener('keydown', this._escapeAndArrowKey, false);
    document.removeEventListener('keyup', this._tabKey, false);
  }

  toggle(event) {
    event.preventDefault();
    this._setState(!this.state);
  }

  _setState(state) {
    this.state = state;
    if (!state) {
      this.focusIndex = undefined;
    }

    this.element.setAttribute('aria-expanded', state);
    this.element.classList.toggle('show', state);
    this.menuTarget.classList.toggle('show', state);
  }

  _close() {
    if (this.state) {
      this._setState(false);
    }
  }

  _escapeAndArrowKey = ({ key }) => {
    if (!this.state) {
      return;
    }

    if (ESCAPE_KEYS.includes(key)) {
      this._close();
    }

    if (DOWN_KEYS.includes(key)) {
      this._focusDown();
    }

    if (UP_KEYS.includes(key)) {
      this._focusUp();
    }
  }

  _tabKey = ({ key, target }) => {
    if (TAB_KEY === key) {
      if (!this.element.contains(target)) {
        this._close();
      } else {
        if (this.focusIndex < this.itemCount) {
          this.focusIndex = this.focusIndex + 1;
        } else {
          this.focusIndex = 0;
        }
      }
    }
  };

  _focusDown() {
    if (this.focusIndex < this.itemCount) {
      this.focusIndex = this.focusIndex + 1;
    } else {
      this.focusIndex = 0;
    }

    this._focus();
  }

  _focusUp() {
    if (this.focusIndex > 0) {
      this.focusIndex = this.focusIndex - 1;
    } else {
      this.focusIndex = this.itemCount;
    }

    this._focus();
  }

  _focus() {
    this.itemTargets[this.focusIndex].focus();
  }

  _closeByClickOutside = ({ target }) => {
    if (!this.state || this.element.contains(target)) {
      return;
    }

    this._close();
  };

  get itemCount() {
    return this.itemTargets.length - 1;
  }
}
