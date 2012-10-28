part of surface_layout_buckshot;

// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.


class MeasurementChangedEventArgs extends EventArgs {
  final RectMeasurement oldMeasurement;
  final RectMeasurement newMeasurement;

  MeasurementChangedEventArgs(this.oldMeasurement, this.newMeasurement);
}
