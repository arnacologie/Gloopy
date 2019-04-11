

import 'package:get_it/get_it.dart';
import 'package:gloopy/managers/user_manager.dart';

GetIt sl = GetIt();

void setUpServiceLocator( )
{
  sl.registerSingleton<UserManager>(UserManager());
}