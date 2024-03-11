// import LineChart from './line-chart'
import IncidentMap from './incident-map'
// import flatpickr from 'flatpickr'
import { AsYouType } from 'libphonenumber-js'

let Hooks = {} // containing object for any JS hooks...

// Hooks.AutoFocus = {
//   mounted() {
//     if (this.el.nodeName == 'INPUT') {
//       this.el.focus()
//     } else {
//       this.el.getElementsByTagName('input')[0].focus()
//     }
//   }
// }

// Hooks.SetFocus = {
//   mounted() {
//     this.handleEvent('set-focus', ({ id }) => {
//       document.getElementById(id).focus()
//     })
//   }
// }

Hooks.SelectedServer = {
  mounted() {
    this.handleEvent('switch-selected-server', ({ old_id, new_id }) => {
      if (old_id) document.getElementById(old_id).removeAttribute('selected')
      document.getElementById(new_id).setAttribute('selected', true)
    })
  }
}

// Hook lifecycle callback object...
Hooks.InfiniteScroll = {
  mounted() {
    console.log('Footer added to DOM!', this.el)
    this.observer = new IntersectionObserver((entries) => {
      const entry = entries[0]
      if (entry.isIntersecting) {
        // console.log('Footer is visible!', entry)
        console.log('Footer is visible!')
        this.pushEvent('load-more')
      }
    })
    // Adds an element to the set of target elements being observed.
    this.observer.observe(this.el)
  },
  destroyed() {
    // this.observer.disconnect()
    this.observer.unobserve(this.el)
  }
}

Hooks.IncidentMap = {
  mounted() {
    _denver = [39.74, -104.99]
    montreal = [45.5, -73.6]

    this.map = new IncidentMap(this.el, montreal, (event) => {
      const incidentId = event.target.options.incidentId

      // Push event but wait for LiveView's reply before scrolling.
      this.pushEvent('marker-clicked', incidentId, (reply, _ref) => {
        this.scrollTo(reply.incident.id) // same as incidentId
      })
    })

    this.pushEvent('get-incidents', {}, (reply, _ref) => {
      reply.incidents.forEach((incident) => {
        this.map.addMarker(incident)
      })
    })

    // Replaced by the above pushEvent...
    // const incidents = JSON.parse(this.el.dataset.incidents);

    // incidents.forEach(incident => {
    //   this.map.addMarker(incident);
    // })

    this.handleEvent('highlight-marker', (incident) => {
      this.map.highlightMarker(incident)
    })

    this.handleEvent('add-ma-selected-serverrker', (incident) => {
      this.map.addMarker(incident)
      this.map.highlightMarker(incident)
      this.scrollTo(incident.id)
    })
  },

  scrollTo(incidentId) {
    const incidentElement = document.querySelector(
      `[phx-value-id="${incidentId}"]`
    )
    // The bottom of the element will be aligned to the bottom of the area.
    incidentElement.scrollIntoView(false)
  }
}

// Hooks.LineChart = {
//   mounted() {
//     const { labels, values } = JSON.parse(this.el.dataset.chart)
//     // The element this hook is bound to is this.el...
//     this.chart = new LineChart(this.el, labels, values)
//     this.handleEvent('new-po-selected-serverint', ({ label, value }) => {
//       this.chart.addPoint(label, value)
//     })
//   }
// }

// Define a mounted callback and instantiate a
// flatpickr instance using this.el as the element.
// When a date is picked, use this.pushEvent()
// to push an event to the LiveView with the chosen
// date string as the payload.

// Hooks.DatePicker = {
//   mounted() {
//     flatpickr(this.el, {
//       enableTime: false,
//       dateFormat: 'F d, Y',
//       // The onChange option takes a function that's invoked when a date is
//       // picked. In this example, we named the function handleDatePicked.
//       // We use bind to get the this reference correct at runtime and tie
//       // the handleDatePicked function to our hook module.
//       onChange: this.handleDatePicked.bind(this)
//     })
//   },

//   // Inside this function, the this reference points to the hook module, not
//   // the flatpickr. This is important as you'll need to use this to send an
//   // event from the hook to the LiveView.
//   handleDatePicked(selectedDate, dateStr, instance) {
//     // console.log("Selected Date", selectedDate)
//     // console.log("Instance", instance)
//     this.pushEvent('date-picked', dateStr)
//   }
// }

Hooks.PhoneNumber = {
  mounted() {
    this.el.addEventListener('input', (e) => {
      this.el.value = new AsYouType('US').input(this.el.value)
    })
  }
}

export default Hooks
