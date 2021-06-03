import 'package:calender/core/enums/CalenderStatus.dart';
import 'package:calender/core/viewmodel/calender_viewmodel.dart';
import 'package:calender/ui/addEvents/add_events.dart';
import 'package:calender/ui/widgets/failure_widgets.dart';
import 'package:calender/ui/widgets/loading_widget.dart';
import 'package:cell_calendar/cell_calendar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CalenderView extends StatefulWidget {
  const CalenderView({Key? key}) : super(key: key);

  @override
  _CalenderViewState createState() => _CalenderViewState();
}

class _CalenderViewState extends State<CalenderView> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CalenderViewModel(context: context),
      child: Calender_View(),
    );
  }
}

class Calender_View extends StatelessWidget {
  const Calender_View({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CalenderViewModel _calender = Provider.of<CalenderViewModel>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text("Calender"),
          actions: [
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          child:
                              ChangeNotifierProvider<CalenderViewModel>.value(
                            value: _calender,
                            child: AddEvents(),
                          ),
                        );
                      });
                },
                icon: Icon(Icons.add))
          ],
        ),
        body: Consumer<CalenderViewModel>(
          builder: (context, state, child) {
            if (state.calenderStatus == CalenderStatus.Error) {
              showDialog(
                  context: context,
                  builder: (context) =>
                      FailureWidget(failure: state.failure!, context: context));
            }
            return Stack(
              fit: StackFit.expand,
              children: [
                CellCalendar(
                  events: state.calenderEvent,
                  onCellTapped: (DateTime date) {},
                ),
                if (state.calenderStatus == CalenderStatus.Loading)
                  Positioned.fill(child: LoadingWidget())
              ],
            );
          },
        ));
  }
}
