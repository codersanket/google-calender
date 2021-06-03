import 'package:calender/core/enums/CalenderStatus.dart';
import 'package:calender/core/viewmodel/calender_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddEvents extends StatefulWidget {
  const AddEvents({Key? key}) : super(key: key);
  @override
  _AddEventsState createState() => _AddEventsState();
}

class _AddEventsState extends State<AddEvents> {
  final GlobalKey<FormState> _form = GlobalKey();
  String start = "Start";
  String end = "End";
  DateTime? _start;
  DateTime? _end;
  TextEditingController _title = TextEditingController();

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CalenderViewModel state = Provider.of<CalenderViewModel>(context);

    final textField = TextField(
      cursorColor: Colors.black,
      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      controller: _title,
      decoration: InputDecoration(
          isDense: true,
          hintText: "Add title",
          hintStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
          border: OutlineInputBorder()),
    );

    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Form(
        key: _form,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              textField,
              SizedBox(
                height: 5,
              ),
              OutlinedButton(
                onPressed: () {
                  DatePicker.showDateTimePicker(context,
                      onConfirm: (DateTime val) {
                    setState(() {
                      _start = val;
                      var temp = DateFormat('dd-MM-yyyy – kk:mm').format(val);
                      start = temp.toString();
                    });
                  });
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.event,
                      color: Colors.grey,
                    ),
                    Text(start)
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                ),
              ),
              OutlinedButton(
                onPressed: () {
                  DatePicker.showDateTimePicker(context, showTitleActions: true,
                      onConfirm: (DateTime val) {
                    setState(() {
                      _end = val;
                      var temp = DateFormat('dd-MM-yyyy – kk:mm').format(val);
                      end = temp.toString();
                    });
                  });
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.event,
                      color: Colors.grey,
                    ),
                    Text(end)
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              state.insertStatus == InsertStatus.Uploading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : ElevatedButton(
                      onPressed: () async {
                        state
                            .insertEvents(_title.text, _start!, _end!)
                            .then((value) => Navigator.pop(context));
                      },
                      child: Text("Add"),
                    )
            ]),
      ),
    );
  }
}
