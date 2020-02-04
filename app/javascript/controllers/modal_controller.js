import { Controller } from 'stimulus';
import getTransitionDurationFromElement from '../utils/get_transition_duration_from_element';
import reflow from '../utils/reflow';

const ClassName = {
  BACKDROP: 'modal-backdrop',
  OPEN: 'modal-open',
  FADE: 'fade',
  SHOW: 'show',
};

const OPEN_EVENT = 'open-modal';
const CLOSE_EVENT = 'close-modal';
const FOCUS_EVENT = 'focusin';
const ESCAPE_KEYS = ['Escape', 'Esc'];

const open = html => {
  const event = new CustomEvent(OPEN_EVENT, { detail: html });
  document.dispatchEvent(event);
};

const close = () => {
  const event = new Event(CLOSE_EVENT);
  document.dispatchEvent(event);
};

export { open, close };

export default class extends Controller {
  static targets = ['content'];

  connect() {
    this._isShown = false;
    this._isTransitioning = false;
    document.addEventListener(OPEN_EVENT, this._open, false);
    document.addEventListener(CLOSE_EVENT, this._close, false);
  }

  disconnect() {
    document.removeEventListener(OPEN_EVENT, this._open, false);
    document.removeEventListener(CLOSE_EVENT, this._close, false);
    this._close();
  }

  _open = ({ detail: html }) => {
    this._isShown = true;
    document.body.classList.add(ClassName.OPEN);
    this.contentTarget.innerHTML = html;
    this._showBackdrop(this._showModal);
    document.removeEventListener(FOCUS_EVENT, this._focus, false); // guard against infinite focus loop
    document.addEventListener(FOCUS_EVENT, this._focus, false);
    document.addEventListener('keydown', this._escapeKey, false);
  };

  _close = () => {
    document.removeEventListener(FOCUS_EVENT, this._focus, false);
    document.removeEventListener('keydown', this._escapeKey, false);
    document.body.classList.remove(ClassName.OPEN);
    this._hideModal(this._removeBackdrop);
    this.contentTarget.innerHTML = '...';
  };

  _escapeKey = ({ key }) => {
    if (ESCAPE_KEYS.includes(key)) {
      this._close();
    }
  };

  _showModal = () => {
    this.element.style.display = 'block';
    this.element.removeAttribute('aria-hidden');
    this.element.setAttribute('aria-modal', true);
    this.element.scrollTop = 0;
    reflow(this.element);
    this.element.classList.add(ClassName.SHOW);
    this.element.focus();
  };

  _hideModal(callback) {
    this.element.setAttribute('aria-hidden', true);
    this.element.removeAttribute('aria-modal');
    this.element.classList.remove(ClassName.SHOW);
    setTimeout(() => {
      this.element.style.display = 'none';
      callback();
    }, getTransitionDurationFromElement(this.element));
  }

  _removeBackdrop = () => {
    if (!this._backdrop) {
      return;
    }

    this._backdrop.removeEventListener('click', this._close, false);
    this._backdrop.classList.remove(ClassName.SHOW);

    setTimeout(() => {
      this._backdrop.parentNode.removeChild(this._backdrop);
      this._backdrop = null;
    }, getTransitionDurationFromElement(this._backdrop));
  };

  _showBackdrop(callback) {
    if (this._backdrop) {
      return;
    }

    this._backdrop = document.createElement('div');
    this._backdrop.className = `${ClassName.BACKDROP} ${ClassName.FADE} ${ClassName.SHOW}`;
    this._backdrop.addEventListener('click', this._close, false);

    document.body.appendChild(this._backdrop);
    setTimeout(callback, getTransitionDurationFromElement(this._backdrop));
  }

  _focus = ({ target }) => {
    if (
      document !== target &&
      this.element !== target &&
      !this.element.contains(target)
    ) {
      this.element.focus();
    }
  };
}
