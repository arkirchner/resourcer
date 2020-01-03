import { Controller } from 'stimulus';
import Gantt from 'ibm-gantt-chart';

const END_TO_START = Gantt.constraintTypes.END_TO_START;

export default class extends Controller {
  connect() {
    this.chart = new Gantt(this.element, this.config);
  }

  disconnect() {}

  get data() {
    return {
      constraints: [
        {
          from: 'A-4.2.1',
          to: 'A-4.2.2',
          type: END_TO_START,
        },
        {
          from: 'A-2',
          to: 'A-3',
          type: END_TO_START,
        },
        {
          from: 'A-4.1.1',
          to: 'A-4.1.2',
          type: END_TO_START,
        },
        {
          from: 'A-5.2',
          to: 'A-6.1',
          type: END_TO_START,
        },
        {
          from: 'A-3',
          to: 'A-4',
          type: 1,
        },
        {
          from: 'A-4.1.2',
          to: 'A-4.2.1',
          type: 0,
        },
        {
          from: 'A-1.2',
          to: 'A-1.3',
          type: 1,
        },
        {
          from: 'A-5.2',
          to: 'A-5.3',
          type: 1,
        },
        {
          from: 'A-1.1.1',
          to: 'A-1.1.2',
          type: 1,
        },
        {
          from: 'A-2.1',
          to: 'A-2.2',
          type: 1,
        },
        {
          from: 'A-1.1',
          to: 'A-1.2',
          type: 1,
        },
        {
          from: 'A-5.1',
          to: 'A-5.2',
          type: 1,
        },
        {
          from: 'A-1',
          to: 'A-2',
          type: 1,
        },
        {
          from: 'A-4',
          to: 'A-5',
          type: 1,
        },
      ],
      activities: [
        {
          id: 'A-Root',
          name: 'Project Summary',
          start: 1487750400000,
          end: 1508310000000,
          parent: null,
        },
        {
          id: 'A-1',
          name: 'Gather Requirements',
          start: 1487750400000,
          end: 1489219200000,
          parent: 'A-Root',
        },
        {
          id: 'A-1.1',
          name: 'Talk to customers',
          start: 1487750400000,
          end: 1488614400000,
          parent: 'A-1',
        },
        {
          id: 'A-1.1.1',
          name: 'Compile customer list',
          start: 1487750400000,
          end: 1487923200000,
          parent: 'A-1.1',
        },
        {
          id: 'A-1.1.2',
          name: 'Contact customers',
          start: 1487923200000,
          end: 1488614400000,
          parent: 'A-1.1',
        },
        {
          id: 'A-1.2',
          name: 'Write up requirements',
          start: 1488614400000,
          end: 1488873600000,
          parent: 'A-1',
        },
        {
          id: 'A-1.3',
          name: 'Review requirements',
          start: 1488787200000,
          end: 1489219200000,
          parent: 'A-1',
        },
        {
          id: 'A-2',
          name: 'Marketing Specification',
          start: 1489219200000,
          end: 1490252400000,
          parent: 'A-Root',
        },
        {
          id: 'A-2.1',
          name: 'First Draft Specification',
          start: 1489219200000,
          end: 1489820400000,
          parent: 'A-2',
        },
        {
          id: 'A-2.2',
          name: 'Second Draft Specification',
          start: 1489820400000,
          end: 1490252400000,
          parent: 'A-2',
        },
        {
          id: 'A-3',
          name: 'Engineering Review',
          start: 1490252400000,
          end: 1491116400000,
          parent: 'A-Root',
        },
        {
          id: 'A-4',
          name: 'Proof of Concept',
          start: 1491116400000,
          end: 1495609200000,
          parent: 'A-Root',
        },
        {
          id: 'A-4.1',
          name: 'Rough Design',
          start: 1491116400000,
          end: 1492930800000,
          parent: 'A-4',
        },
        {
          id: 'A-4.1.1',
          name: 'CAD Layout',
          start: 1491116400000,
          end: 1492326000000,
          parent: 'A-4.1',
        },
        {
          id: 'A-4.1.2',
          name: 'Detailing',
          start: 1492066800000,
          end: 1492930800000,
          parent: 'A-4.1',
        },
        {
          id: 'A-4.2',
          name: 'Fabricate Prototype',
          start: 1492498800000,
          end: 1494399600000,
          parent: 'A-4',
        },
        {
          id: 'A-4.2.1',
          name: 'Order Materials',
          start: 1492498800000,
          end: 1493190000000,
          parent: 'A-4.2',
        },
        {
          id: 'A-4.2.2',
          name: 'Machining',
          start: 1493190000000,
          end: 1494399600000,
          parent: 'A-4.2',
        },
        {
          id: 'A-4.3',
          name: 'Burn-in Testing',
          start: 1494399600000,
          end: 1495004400000,
          parent: 'A-4',
        },
        {
          id: 'A-4.4',
          name: 'Prepare Demo',
          start: 1495004400000,
          end: 1495609200000,
          parent: 'A-4',
        },
        {
          id: 'A-5',
          name: 'Design and Development',
          start: 1495609200000,
          end: 1507100400000,
          parent: 'A-Root',
        },
        {
          id: 'A-5.1',
          name: 'Phase I Development',
          start: 1495609200000,
          end: 1500447600000,
          parent: 'A-5',
        },
        {
          id: 'A-5.2',
          name: 'Phase II Development',
          start: 1500447600000,
          end: 1504076400000,
          parent: 'A-5',
        },
        {
          id: 'A-5.3',
          name: 'Phase III Development',
          start: 1504076400000,
          end: 1507100400000,
          parent: 'A-5',
        },
        {
          id: 'A-6',
          name: 'Packaging',
          start: 1500447600000,
          end: 1508310000000,
          parent: 'A-Root',
        },
        {
          id: 'A-6.1',
          name: 'User Manual',
          start: 1500447600000,
          end: 1507100400000,
          parent: 'A-6',
        },
        {
          id: 'A-6.2',
          name: 'Installation Procedures',
          start: 1505890800000,
          end: 1508310000000,
          parent: 'A-6',
        },
        {
          id: 'A-6.3',
          name: 'Update WebSite',
          start: 1507100400000,
          end: 1508310000000,
          parent: 'A-6',
        },
      ],
    };
  }

  get config() {
    return {
      data: this.data,
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
