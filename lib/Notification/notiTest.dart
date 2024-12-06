import 'package:flutter/material.dart';
import 'package:medminder/Notification/notification.dart';
import 'package:medminder/custom.dart';
import 'package:medminder/Notification/newSchedule.dart';
class notiTest extends StatefulWidget {
  const notiTest({super.key});

  @override
  State<notiTest> createState() => _notiTestState();
}

class _notiTestState extends State<notiTest> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            ElevatedButton(
              onPressed: () {
                notificationRem.showInstantNotification("Instant Notification", "Notification appeared as soon button was pressed");
              },
              child: const Text("Show Notification"),
              ),
              SizedBox(height: 20,),

              ElevatedButton(
              onPressed: () {
                DateTime scheduledTime = DateTime.now().add(const Duration(seconds: 5));
                notificationRem.scheduledNotification("Notification is Scheduled", "This is a scheduled reminder, 5 seconds", scheduledTime);
              },
              child: const Text("Scheduled Notification")),

              
            Custom.newButton('Back',
             Color.fromRGBO(217, 217, 217, 1), 
             () {Navigator.push(context,
                          MaterialPageRoute(
                            builder: (context) => NewSchedule(), //Goes to login page
                          ),
                    );
                   },),

          ],
        ),
      ),
    );
  }
}