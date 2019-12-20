import 'package:flutter/material.dart';
import 'package:videos_sharing/bloc/player/aspect_ratio_bloc.dart';

class AspectRatioModel {
  IconData icon;
  double aspectRatio;
  String aspectRatioName;
  AspectRatioEvents aspectRatioEvents;

  AspectRatioModel(this.aspectRatio, this.icon, this.aspectRatioName,this.aspectRatioEvents);
}
