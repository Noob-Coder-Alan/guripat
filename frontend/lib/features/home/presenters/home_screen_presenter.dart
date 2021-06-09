import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/core/presenters/base_presenter.dart';
import 'package:frontend/core/state/app_state.dart';
import 'package:frontend/features/home/views/home_screen_view.dart';

class HomeScreenPresenter extends BasePresenter<HomeScreenView> {
  Widget body(BuildContext context) {
    checkViewAttached();

    if (isViewAttached && getView().state == AppState.loading) {
      return Center(child: CircularProgressIndicator());
    } else if (isViewAttached && getView().state == AppState.done) {
      return getView().body;
    } else if(isViewAttached && getView().state == AppState.invalid) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Oops, invalid code! Or it could be the internet."),
            SizedBox(height: 15),
            ElevatedButton(
                onPressed: () async {
                  getView().setAppState(AppState.done);
                },
                child: Text("Okay")
            ),
          ],
        ),
      );
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("An error has occured... Hmmm, it's probably the net."),
            ElevatedButton(
                onPressed: () async {
                  getView().setAppState(AppState.done);
                },
                child: Text("Okay")),
          ],
        ),
      );
    }
  }
}
