import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_task/core/constants/app_theme.dart';
import 'package:product_task/core/routing/app_router.dart';
import 'package:product_task/core/theme/theme_cubit.dart';
import 'package:product_task/feature/product/presentation/blocs/cubits/product_cubit_state/product_cubit.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ProductCubit()..fetchProducts()),
        BlocProvider(create: (_) => ThemeCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          AppColors.setDarkMode(themeMode == ThemeMode.dark);
          return MaterialApp.router(
            title: 'Product Dashboard',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode,
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}
