library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:moh_eam/config/logging/logger.dart';
import 'package:moh_eam/config/utility/extensions/extensions_module.dart';
import 'package:moh_eam/config/utility/helpers/utility_helpers.dart';
import 'package:moh_eam/core/bloc/global_bloc_module.dart';
import 'package:moh_eam/features/auth/domain/entities/role.dart';
import 'package:moh_eam/features/auth/bloc/auth_bloc.dart';
import 'package:moh_eam/features/entity/feature/departments/bloc/bloc.dart';
import 'package:moh_eam/features/entity/feature/users/bloc/bloc.dart';
import 'package:moh_eam/features/entity/feature/departments/domain/entity/department.dart';
import 'package:moh_eam/features/entity/feature/users/data/model/patch_user.dart';
import 'package:moh_eam/features/entity/feature/users/domain/entity/user_entity.dart';


part 'edit_user_form.dart';
part 'editable_text_field.dart';
part 'role_selector.dart';
part 'submit_button.dart';
part 'user_filter.dart';