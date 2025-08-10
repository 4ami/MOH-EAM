library;

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:moh_eam/config/logging/logger.dart';
import 'package:moh_eam/config/routing/_helpers/_routing_helpers_module.dart';
import 'package:moh_eam/config/utility/helpers/utility_helpers.dart';
import 'package:moh_eam/core/bloc/global_bloc_module.dart';
import 'package:moh_eam/core/domain/entity/entity_model.dart';
import 'package:moh_eam/features/admin/admin_module.dart';
import 'package:moh_eam/features/admin/bloc/bloc.dart';
import 'package:moh_eam/features/entity/feature/departments/bloc/bloc.dart';
import 'package:moh_eam/features/entity/feature/departments/ui/page.dart';
import 'package:moh_eam/features/entity/feature/departments/ui/view/department_viewer.dart';
import 'package:moh_eam/features/entity/feature/users/bloc/bloc.dart';
import 'package:moh_eam/features/entity/feature/users/ui/view/user_detail.dart';
import 'package:moh_eam/features/entity/feature/users/domain/entity/user_entity.dart';
import 'package:moh_eam/features/entity/ui/page.dart';
import 'package:moh_eam/features/error/ui/page.dart';
import 'package:moh_eam/features/entity/feature/users/ui/view/edit_user.dart';
import 'package:moh_eam/features/entity/feature/users/users_module.dart';
import 'package:moh_eam/features/auth/auth_module.dart';
import 'package:moh_eam/features/auth/bloc/auth_bloc.dart';
import 'package:moh_eam/features/splash/splash_module.dart';

part '_route_interface.dart';
part '_splash.dart';
part '_signin.dart';
part '_admin.dart';
part '_entity_viewer.dart';

final class AppRoutes {
  const AppRoutes._();
  static final AppRoutes _instance = AppRoutes._();
  static AppRoutes get instance => _instance;

  List<GoRoute> get appRoutes {
    return [
      _SplashRoute().page,
      _SigninRoute().page,
      _Admin().page,
      // _EntityViewerPage().page,
    ];
  }
}
