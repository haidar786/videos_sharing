import 'package:flutter/material.dart';
import 'package:videos_sharing/bloc/player/aspect_ratio_bloc.dart';

class AspectRatioState {
  IconData icon;
  double aspectRatio;
  String aspectRatioName;
  AspectRatioEvents aspectRatioEvents;

  AspectRatioState(this.aspectRatio, this.icon, this.aspectRatioName,this.aspectRatioEvents);
}
