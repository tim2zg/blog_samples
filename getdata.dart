import 'package:influxdb_client/api.dart';
import 'package:charts_flutter/flutter.dart' as charts;

Future<List<charts.Series<dynamic, DateTime>>> getdata(String duration, String timespann) async {
  var thedata = [];

  InfluxDBClient client = InfluxDBClient(
      url: '', // Your URL for Example: http://127.0.0.1:8086
      username: '',  // Your Username of the DB for Example: admin
      password: '', // Your Password of the DB for Example: 123
      debug: false);

  var queryService = client.getQueryService();

  var query = await queryService.query('''from(bucket: "iobroker")
  |> range(start: -${duration})
  |> filter(fn: (r) => r["_measurement"] == "0_userdata.0.SolarDaten.Eigenverbrauch_%")
  |> filter(fn: (r) => r["_field"] == "value")
  |> aggregateWindow(every: ${timespann}, fn: mean, createEmpty: false)
  |> yield(name: "mean")''');

  await query.forEach((element) {
    thedata.add(data(DateTime.parse(element['_time']), element['_value']));});

  client.close();

  return
    [charts.Series<dynamic, DateTime>(
      id: 'Eigenverbauch %',
      colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
      domainFn: (data, _) => data.time,
      measureFn: (data, _) => data.value,
      data: thedata,
    ),
    ];
}

class data {
  final DateTime time;
  final double value;

  data(this.time, this.value);
}
