library;

import 'dart:ui';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:moh_eam/config/routing/_helpers/_routing_helpers_module.dart';
import 'package:moh_eam/config/utility/extensions/extensions_module.dart';
import 'package:moh_eam/config/utility/helpers/utility_helpers.dart';
import 'package:moh_eam/features/admin/bloc/bloc.dart';
import 'package:moh_eam/features/admin/data/sources/static/drawer_data.dart';
import 'package:moh_eam/features/entity/feature/devices/ui/widgets/device_widgets_module.dart';
import 'package:moh_eam/features/entity/feature/users/ui/widgets/users_widgets_module.dart';
import 'package:moh_eam/features/auth/bloc/auth_bloc.dart';

part 'containers/drawer.dart';
part 'fields/search_bar.dart';
part 'containers/card.dart';
part 'presentation/quick_access_cards.dart';
part 'charts/devices_per_type_chart.dart';
part 'charts/type_stats_chart.dart';
part 'containers/shimmer_container.dart';
part 'presentation/side_bar.dart';
part 'containers/side_bar_item_container.dart';
part 'fields/filter.dart';