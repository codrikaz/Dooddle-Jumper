// Copyright 2022 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

export 'game_over_overlay.dart';
export 'game_overlay.dart';
export 'game_settings_panel.dart';
export 'main_menu_overlay.dart';
export 'score_display.dart';
export 'back_menu_overlay.dart';

class WhiteSpace extends StatelessWidget {
  const WhiteSpace({super.key, this.height = 100});

  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
    );
  }
}
