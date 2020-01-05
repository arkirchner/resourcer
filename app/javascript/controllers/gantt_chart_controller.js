import { Controller } from 'stimulus';
import Gantt from 'ibm-gantt-chart';

export default class extends Controller {
  connect() {
    this.chart = new Gantt(this.element, this.config);
  }

  disconnect() {}

  get chartData() {
    return JSON.parse(this.data.get('data'));
  }

  get config() {
    return {
      data: this.chartData,
      // Configure a toolbar associated with the Gantt
      type: Gantt.type.ACTIVITY_CHART,
      toolbar: [
        'title',
        'search',
        'separator',
        {
          type: 'button',
          text: 'Refresh',
          fontIcon: 'fa fa-refresh fa-lg',
          onclick(ctx) {
            ctx.gantt.draw();
          },
        },
        'fitToContent',
        'zoomIn',
        'zoomOut',
      ],
      title: 'Simple Gantt', // Title for the Gantt to be displayed in the toolbar
    };
  }
}
