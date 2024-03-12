// import Chart from "chart.js";
// Starting with 3.0 you'll need to import Chart.js like so:
import Chart from 'chart.js/auto';

class LineChart {
  // context is the canvas element displaying chart.
  constructor(context, labels, values) {
    this.chart = new Chart(context, {
      type: 'line',
      data: {
        labels: labels,
        datasets: [
          {
            label: 'Wally',
            // Bezier curve tension of the line. Set to 0 to draw straightlines.
            lineTension: 0.4,
            // Set the fill property to true.
            fill: true,
            data: values,
            borderColor: '#4c51bf'
          }
        ]
      },
      options: {
        animation: {
          duration: 4 // general animation time
        },
        scales: {
          x: {
            ticks: {
              font: {
                weight: 'bold',
                size: 14
              }
            }
          },
          y: {
            suggestedMin: 50,
            suggestedMax: 200,
            ticks: {
              font: {
                weight: 'bold',
                size: 14
              }
            }
          }
        }
      }
    });
  }

  addPoint(label, value) {
    const labels = this.chart.data.labels;
    const data = this.chart.data.datasets[0].data;

    labels.push(label);
    data.push(value);

    if (data.length > 12) {
      data.shift();
      labels.shift();
    }

    this.chart.update(); // adds new point to chart in efficient way
  }
}

export default LineChart;
