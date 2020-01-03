import { Controller } from 'stimulus';
import Gantt from 'ibm-gantt-chart';

export default class extends Controller {
  connect() {
    this.chart = new Gantt(this.element, this.config);
  }

  disconnect() {}

  get data() {
    return {
      resources: [
        {
          id: 'NURSES+Anne',
          name: 'Anne',
        },
        {
          id: 'NURSES+Betsy',
          name: 'Betsy',
        },
      ],
      activities: [
        {
          id: 'SHIFTS+Emergency+Monday+2+8',
          name: 'Emergency',
          start: 1474880400000,
          end: 1474902000000,
        },
        {
          id: 'SHIFTS+Emergency+Wednesday+12+18',
          name: 'Emergency',
          start: 1475089200000,
          end: 1475110800000,
        },
        {
          id: 'SHIFTS+Emergency+Saturday+12+20',
          name: 'Emergency',
          start: 1475348400000,
          end: 1475377200000,
        },
        {
          id: 'SHIFTS+Consultation+Friday+8+12',
          name: 'Consultation',
          start: 1475247600000,
          end: 1475262000000,
        },
      ],
      reservations: [
        { resource: 'NURSES+Anne', activity: 'SHIFTS+Emergency+Monday+2+8' },
        {
          resource: 'NURSES+Betsy',
          activity: 'SHIFTS+Emergency+Wednesday+12+18',
        },
        {
          resource: 'NURSES+Betsy',
          activity: 'SHIFTS+Emergency+Saturday+12+20',
        },
        {
          resource: 'NURSES+Betsy',
          activity: 'SHIFTS+Consultation+Friday+8+12',
        },
      ],
    };
  }

  get config() {
    return {
      data: this.data,
      // Configure a toolbar associated with the Gantt
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
