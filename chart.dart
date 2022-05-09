import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'getdata.dart';


class datachart extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return datachartwidget(); // Calling the Chart widget
  }

}

class datachartwidget extends State<datachart> { // Our Chart widget
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getdata("1d", "1m"), // Function that gets the Data
        builder: (BuildContext context, AsyncSnapshot snapshot) {
      if (snapshot.connectionState == ConnectionState.done) { // See if the data is there
        return charts.TimeSeriesChart( // If data is there we return the chart
          snapshot.data,
          animate: true,
          customSeriesRenderers: [
            charts.SymbolAnnotationRendererConfig(
                customRendererId: 'customSymbolAnnotation')
          ],
          dateTimeFactory: const charts.LocalDateTimeFactory(),
        );
      } else {
        return const Center(child: CircularProgressIndicator());// Else we return a Progressbar
      }
    }
    );
  }
}
