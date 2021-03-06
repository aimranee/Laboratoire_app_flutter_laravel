import 'package:get/get.dart';
import 'package:laboratoire_app/Screen/prescription/prescriptionListByIdPage.dart';
import 'package:laboratoire_app/Service/Firebase/deletData.dart';
import 'package:laboratoire_app/Service/Firebase/updateData.dart';
import 'package:laboratoire_app/Service/Noftification/handleFirebaseNotification.dart';
import 'package:laboratoire_app/Service/Noftification/handleLocalNotification.dart';
import 'package:laboratoire_app/Service/appointmentService.dart';
import 'package:laboratoire_app/Service/drProfileService.dart';
import 'package:laboratoire_app/Service/notificationService.dart';
import 'package:laboratoire_app/model/appointmentModel.dart';
import 'package:laboratoire_app/model/notificationModel.dart';
import 'package:laboratoire_app/utilities/color.dart';
import 'package:laboratoire_app/utilities/dialogBox.dart';
import 'package:laboratoire_app/utilities/toastMsg.dart';
import 'package:laboratoire_app/widgets/appbarsWidget.dart';
import 'package:laboratoire_app/widgets/bottomNavigationBarWidget.dart';
import 'package:laboratoire_app/widgets/custom_drawer.dart';
import 'package:laboratoire_app/widgets/loadingIndicator.dart';
import 'package:flutter/material.dart';
class AppointmentDetailsPage extends StatefulWidget {
  final appointmentDetails;

  const AppointmentDetailsPage({Key key, this.appointmentDetails})
      : super(key: key);
  @override
  _AppointmentDetailsPageState createState() => _AppointmentDetailsPageState();
}

class _AppointmentDetailsPageState extends State<AppointmentDetailsPage> {

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _latsNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _phnController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _serviceNameController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  final TextEditingController _serviceTimeController = TextEditingController();
  final TextEditingController _appointmentIdController = TextEditingController();
  final TextEditingController _uIdController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _createdDateTimeController =
  TextEditingController();
  final TextEditingController _lastUpdatedController = TextEditingController();
  String _isBtnDisable = "false";
  bool _isLoading=false;
  bool isConn = Get.arguments;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firstNameController.text = widget.appointmentDetails.pFirstName;
    _latsNameController.text = widget.appointmentDetails.pLastName;
    _ageController.text = widget.appointmentDetails.age;
    _cityController.text = widget.appointmentDetails.pCity;
    _emailController.text = widget.appointmentDetails.pEmail;
    _phnController.text = widget.appointmentDetails.pPhn;
    _dateController.text = widget.appointmentDetails.appointmentDate;
    _timeController.text = widget.appointmentDetails.appointmentTime;
    _serviceNameController.text = widget.appointmentDetails.serviceName;
    _serviceTimeController.text =
        (widget.appointmentDetails.serviceTimeMin).toString();
    _appointmentIdController.text = widget.appointmentDetails.id;
    _uIdController.text = widget.appointmentDetails.uId; //firebase user id
    _descController.text = widget.appointmentDetails.description;
    _createdDateTimeController.text = widget.appointmentDetails.createdTimeStamp;
    _lastUpdatedController.text = widget.appointmentDetails.updatedTimeStamp;
    _statusController.text=widget.appointmentDetails.appointmentStatus;


    if(widget.appointmentDetails.appointmentStatus=="Rejected"||widget.appointmentDetails.appointmentStatus=="Canceled"){
      setState(() {
        _isBtnDisable="";
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _cityController.dispose();
    _ageController.dispose();
    _firstNameController.dispose();
    _latsNameController.dispose();
    _phnController.dispose();
    _emailController.dispose();
    _serviceNameController.dispose();
    _serviceTimeController.dispose();
    _appointmentIdController.dispose();
    _uIdController.dispose();
    _descController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationStateWidget(
            title:widget.appointmentDetails.appointmentStatus=="Visited"?"Get Prescription":"Cancel",
            onPressed: widget.appointmentDetails.appointmentStatus=="Visited"?_handlePrescription:_takeConfirmation,
            clickable: _isBtnDisable
        ),
        drawer : _isLoading ? Container() : CustomDrawer(isConn: isConn),
        body: Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            CAppBarWidget(
              title:"Appointment Details",
              isConn : isConn,
            ),
            Positioned(
              top: 90,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10))),
                child:_isLoading?LoadingIndicatorWidget(): SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 8.0, bottom: 8.0, left: 0, right: 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        _inputTextField("First Name", _firstNameController, 1),
                        _inputTextField("Last Name", _latsNameController, 1),
                        _inputTextField("Age", _ageController, 1),
                        _inputTextField("Appointment Status", _statusController, 1),
                        _inputTextField("Phone Number", _phnController, 1),
                        _inputTextField("City ", _cityController, 1),
                        _inputTextField("Email", _emailController, 1),
                        _inputTextField("Appointment Date", _dateController, 1),
                        _inputTextField("Appointment Time", _timeController, 1),
                        _inputTextField(
                            "Appointment Minute", _serviceTimeController, 1),
                        _inputTextField(
                            "Appointment ID", _appointmentIdController, 1),
                        _inputTextField("User ID", _uIdController, 1),
                        _inputTextField(
                            "Created on", _createdDateTimeController, 1),
                        _inputTextField(
                            "Last update on", _lastUpdatedController, 1),
                        _inputTextField("Description, About your problem", _descController, null),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
  _handlePrescription(){
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>   PrescriptionListByIDPage(
              appointmentId: widget.appointmentDetails.id)
      ),
    );

  }
  Widget _inputTextField(String labelText, controller, maxLine) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: TextFormField(
        maxLines: maxLine,
        readOnly: true,
        controller: controller,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          // prefixIcon:Icon(Icons.,),
            labelText: labelText,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).dividerColor),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
            )),
      ),
    );
  }

  void _handleCancelBtn() async{
    setState(() {
      _isBtnDisable = "";
      _isLoading = true;
    });
    final res = await DeleteData.deleteBookedAppointment(
      widget.appointmentDetails.id,
      widget.appointmentDetails.appointmentDate,
    );
    if (res == "success") {
      final appointmentModel=AppointmentModel(
          id: widget.appointmentDetails.id,
          appointmentStatus: "Canceled"
      );
      final isUpdated=await AppointmentService.updateStatus(appointmentModel);
      if(isUpdated=="success"){
        final notificationModel = NotificationModel(
            title: "Canceled",
            body:
            "Appointment has been canceled for date ${widget.appointmentDetails.appointmentDate}. appointment id: ${widget.appointmentDetails.id}",
            uId: widget.appointmentDetails.uId,
            routeTo: "/Appointmentstatus",
            sendBy: "user",
            sendFrom: "${widget.appointmentDetails.pFirstName} ${widget.appointmentDetails.pLastName}",
            sendTo: "Admin");
        final notificationModelForAdmin = NotificationModel(
            title: "Canceled Appointment",
            body:
            "${widget.appointmentDetails.pFirstName} ${widget.appointmentDetails.pLastName} has canceled appointment for date ${widget.appointmentDetails.appointmentDate}. appointment id: ${widget.appointmentDetails.id}",//body
            uId: widget.appointmentDetails.uId,
            sendBy: "${widget.appointmentDetails.pFirstName} ${widget.appointmentDetails.pLastName}"
        );
        await NotificationService.addData(notificationModel);
        _handleSendNotification();
        await NotificationService.addDataForAdmin(notificationModelForAdmin);
        ToastMsg.showToastMsg("Successfully Canceled");
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/Appointmentstatus', ModalRoute.withName('/'));
      } else {
        ToastMsg.showToastMsg("Something went wrong");
      }

    } else {
      ToastMsg.showToastMsg("Something went wrong");
    }
    setState(() {
      _isBtnDisable = "false";
      _isLoading = false;
    });

  }

  void _handleSendNotification() async {
    final res = await DrProfileService
        .getData();
    String  _adminFCMid = res[0].fdmId;
    //send local notification

    await HandleLocalNotification.showNotification(
      "Canceled",
      "Appointment has been canceled for date ${widget.appointmentDetails.appointmentDate}", // body
    );
    await UpdateData.updateIsAnyNotification("usersList", widget.appointmentDetails.uId, true);

    //send notification to admin app for booking confirmation
    await HandleFirebaseNotification.sendPushMessage(
        _adminFCMid, //admin fcm
        "Canceled Appointment", //title
        "${widget.appointmentDetails.pFirstName} ${widget.appointmentDetails.pLastName} has canceled appointment for date ${widget.appointmentDetails.appointmentDate}. appointment id: ${widget.appointmentDetails.id}"//body
    );
    await UpdateData.updateIsAnyNotification("profile", "profile", true);

  }
  _takeConfirmation() {
    DialogBoxes.confirmationBox(
        context, "Cancel", "Are you sure want to cancel appointment", _handleCancelBtn);
  }
}
