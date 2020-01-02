import { Controller } from 'stimulus';
import Gantt from 'frappe-gantt';

const OPTIONS = {
  header_height: 50,
  column_width: 30,
  step: 24,
  view_modes: ['Quarter Day', 'Half Day', 'Day', 'Week', 'Month'],
  bar_height: 20,
  bar_corner_radius: 3,
  arrow_curve: 5,
  padding: 18,
  view_mode: 'Day',
  date_format: 'YYYY-MM-DD',
  custom_popup_html: null,
};

export default class extends Controller {
  connect() {
    this.chart = new Gantt(this.element, this.issues, OPTIONS);
  }

  disconnect() {
    this.chart.clear();
    this.chart = null;
  }

  get issues() {
    // custom_class is optional
    return [
      {
        id: 'Task 1',
        name: 'Redesign website',
        start: '2016-12-28',
        end: '2016-12-31',
        progress: 20,
        dependencies: 'Task 2, Task 3',
        custom_class: 'bar-milestone',
      },
      {
        id: 'Task 2',
        name: 'Redesign website',
        start: '2016-12-28',
        end: '2016-12-31',
        progress: 20,
        dependencies: '',
        custom_class: 'bar-milestone',
      },
      {
        id: 'Task 3',
        name: 'Redesign website',
        start: '2016-12-28',
        end: '2016-12-31',
        progress: 20,
        dependencies: '',
        custom_class: 'bar-milestone',
      },
    ];
  }
}
