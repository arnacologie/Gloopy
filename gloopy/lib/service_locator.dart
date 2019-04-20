

import 'package:get_it/get_it.dart';
import 'package:gloopy/managers/user_manager.dart';
import 'package:gloopy/services/dialog_helper.dart';

GetIt sl = GetIt();

void setUpServiceLocator( )
{
  sl.registerSingleton<UserManager>(UserManager());
  sl.registerSingleton<DialogHelper>(DialogHelper());
}