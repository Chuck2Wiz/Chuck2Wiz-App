import 'package:chuck2wiz/data/blocs/main/ai/ai_bloc.dart';
import 'package:chuck2wiz/data/blocs/main/main_bloc.dart';
import 'package:chuck2wiz/data/blocs/main/main_state.dart';
import 'package:chuck2wiz/data/repository/ai/form_repository.dart';
import 'package:chuck2wiz/ui/pages/main/ai/ai_page.dart';
import 'package:chuck2wiz/ui/pages/main/community/community_page.dart';
import 'package:chuck2wiz/ui/pages/main/home/home_page.dart';
import 'package:chuck2wiz/ui/pages/main/mypage/my_page.dart';
import 'package:chuck2wiz/ui/util/base_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/blocs/main/main_event.dart';
import '../../widget/bottomBar/bottom_navigation_widget.dart';

class MainPage extends BasePage<MainBloc, MainState> {
  const MainPage({super.key});

  @override
  MainBloc createBloc(BuildContext context) => MainBloc();

  @override
  Widget buildContent(BuildContext context, MainState state) {
    int currentIndex = getSelectBottomNavIndex(state);

    switch(currentIndex) {
      case 0:
        return HomePage();
      case 1:
        return AiPage();
      case 2:
        return const CommunityPage();
      case 3:
        return MyPage();
      default:
        return HomePage();
    }
  }

  @override
  Widget? buildBottomNavigationBar(BuildContext context, int currentIndex) {
    return BottomNavigationWidget(
      items: const ["Home", "Ai", "Community", "MyPage"],
      onClickItem: (String value) {
        switch(value) {
          case "Home":
            context.read<MainBloc>().add(const ChangedBottomNavIndex(0));
            break;
          case "Ai":
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (newContext, animation, secondaryAnimation) {
                  final aiBloc = AiBloc(FormRepository());
                  return BlocProvider.value(
                      value: aiBloc,
                      child: const AiPage()
                  );
                },
                transitionsBuilder: (newContext, animation, secondaryAnimation, child) {
                  const begin = Offset(0.0, 1.0);
                  const end = Offset.zero;
                  const curve = Curves.easeInOut;

                  var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                  var offsetAnimation = animation.drive(tween);

                  return SlideTransition(
                    position: offsetAnimation,
                    child: child,
                  );
                },
              ),
            );
            break;
          case "Community":
            context.read<MainBloc>().add(const ChangedBottomNavIndex(2));
            break;
          case "MyPage":
            context.read<MainBloc>().add(const ChangedBottomNavIndex(3));
            break;
        }
      });
  }
}
