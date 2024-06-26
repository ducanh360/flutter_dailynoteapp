import 'package:flutter/material.dart';
import 'package:flutter_noteapp/controllers/task_controller.dart';
import 'package:flutter_noteapp/models/task.dart';
import 'package:flutter_noteapp/services/notification_services.dart';
import 'package:flutter_noteapp/services/theme_services.dart';
import 'package:flutter_noteapp/ui/add_task_bar.dart';
import 'package:flutter_noteapp/ui/themes.dart';
import 'package:flutter_noteapp/ui/widgets/button.dart';
import 'package:flutter_noteapp/ui/widgets/task_tile.dart';
import 'package:flutter_noteapp/services/notification_services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _selectedDate = DateTime.now();
  final _taskController = Get.put(TaskController());
  var notifyHelper;
  

  @override
  void initState(){
    super.initState();
    notifyHelper=NotifyHelper();
    notifyHelper.initializeNotification();
  }
  

  @override
  Widget build(BuildContext context) {
    print("build method called");
    return  Scaffold(
      appBar: _appBar(),
      backgroundColor: context.theme.backgroundColor,
      body: Column(
        children: [
          _addTaskBar(),
          _addDateBar(),
          SizedBox(height: 10,),
          _showTasks(),
        ],
      ),
    );
  }

_showTasks(){
  return Expanded(
    child:Obx(() {
      return ListView.builder(
        itemCount: _taskController.taskList.length,
        itemBuilder: (_, index){
          print(_taskController.taskList.length);
          Task task = _taskController.taskList[index];
          //print(task.toJson());
          if(task.repeat=="Daily") {
          return AnimationConfiguration.staggeredList(
            position: index,
            child: SlideAnimation(
              child: FadeInAnimation(
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: (){
                        _showBottomSheet(context as BuildContext, task);
                      },
                      child: TaskTile(task),
                    )
                  ],
                )))
            );
          }
          if(task.date==DateFormat.yMMMMd().format(_selectedDate)){
            return AnimationConfiguration.staggeredList(
            position: index,
            child: SlideAnimation(
              child: FadeInAnimation(
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: (){
                        _showBottomSheet(context as BuildContext, task);
                      },
                      child: TaskTile(task),
                    )
                  ],
                )))
            );
          }else{
            return Container();
          }
      });
    }),
  );
}
_bottomSheetButton({
  required String label,
    required Function()? onTap,
    required Color clr,
    bool isClose=false, 
    required BuildContext context,
}){
    return GestureDetector(
      onTap:onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 55,
        width: MediaQuery.of(context).size.width*0.9,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color:isClose==true?Get.isDarkMode?Colors.grey[600]!:Colors.grey[300]!:clr,
          ),
          borderRadius: BorderRadius.circular(20),
          color:isClose==true?Colors.transparent:clr,
        ),

        child: Center(
          child: Text(
            label,
            style:isClose?titleStyle:titleStyle.copyWith(color:Colors.white),


          ),
        ),
      ),
    );
}
_showBottomSheet(BuildContext context, Task task){
  Get.bottomSheet(
    Container(
      padding: const EdgeInsets.only(top:4),
      height: task.isCompleted==1?
      MediaQuery.of(context).size.height*0.24:
      MediaQuery.of(context).size.height*0.32,
      color:Get.isDarkMode?darkGreyClr:Colors.white,
     child:Column(
      children: [
        Container(
          height: 6,
          width: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Get.isDarkMode?Colors.grey[600]:Colors.grey[300],
          ),
        ),
        Spacer(),
        task.isCompleted==1
        ?Container()
          : _bottomSheetButton(
            label: "Task Completed", 
            onTap: (){
              _taskController.markTaskCompleted(task.id!);
              Get.back();
            }, clr:primaryClr,
              context:context,
            ),
            
            _bottomSheetButton(
            label: "Delete Task", 
            onTap: (){
              _taskController.delete(task);
              Get.back();
            }, clr:Colors.red[500]!,
              context:context,
            ),
            SizedBox(
              height: 20,
            ),
            _bottomSheetButton(
            label: "Close", 
            onTap: (){
              Get.back();
            }, clr:Colors.red[500]!,
            isClose:true,
              context:context,
            )
      ],
     ), 
    ),
  );
}
_addDateBar(){
  return Container(
            margin: const EdgeInsets.only(top: 20, left: 20),
            child: DatePicker(
              DateTime.now(),
              height: 100,
              width: 80,
              initialSelectedDate: DateTime.now(),
              selectionColor: primaryClr,
              selectedTextColor: Colors.white,
              dateTextStyle: GoogleFonts.lato(
              textStyle: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color:Colors.grey,
              ),),
              dayTextStyle: GoogleFonts.lato(
              textStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color:Colors.grey,
              ),),
              monthTextStyle: GoogleFonts.lato(
              textStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color:Colors.grey,
              ),),
              onDateChange: (date){
                setState(() {
                  _selectedDate=date;
                });
                
              },
            ),
          );
}
_addTaskBar(){
  return Container(
            margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(DateFormat.yMMMMd().format(DateTime.now()),
                      style: subHeadingStyle,
                      ),
                        Text("Today",
                        style: headingStyle,
                        ),
                    ],
                  ),
                ),
                MyButton(label: "+  Add Task", onTap: ()async{
                  await Get.to(()=>AddTaskpage());
                  _taskController.getTasks();
                },
                ), 
              ],
            ),
          );
        
}
_appBar(){
  return AppBar(
   // backgroundColor: context
    leading: GestureDetector(
      onTap: (){
          ThemeService().switchTheme();
          notifyHelper.displayNotification(
            title:"Theme Changed",
            body:Get.isDarkMode?"Activate Dark Theme":"Activate Light Theme"
          );
      },
      child: Icon(Icons.nightlight_round, size: 20,),
    ),
    actions: [
      Icon(Icons.person, size:20,),
    ],
  );
}}