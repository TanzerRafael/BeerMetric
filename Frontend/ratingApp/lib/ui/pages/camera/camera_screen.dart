import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ratingApp/ui/pages/camera/preview_screen.dart';

class CameraScreen extends StatefulWidget{

  final CameraDescription cam;

  CameraScreen({Key key, @required this.cam}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _CameraScreenState();

}
class _CameraScreenState extends State<CameraScreen>{

  CameraController camController;
  List cams;
  String imgPath;



  Future _initCamController(CameraDescription cameraDescription) async{
    if(camController != null){
      await camController.dispose();
    }

    camController = CameraController(cameraDescription, ResolutionPreset.high);
    camController.addListener(() {
      if(mounted){
        setState(() {

        });
      }
    });

    if(camController.value.hasError){
      print('CameraError: ${camController.value.errorDescription}');
    }

    try{
      await camController.initialize();
    }on CameraException catch(e){
      _showCameraException(e);
    }
    if(mounted){
      setState(() {

      });
    }
  }

  Widget _cameraPreview(){
    if(camController == null || !camController.value.isInitialized){
      return const Text(
        'Loading',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.bold
        ),
      );
    }
    
    return AspectRatio(aspectRatio: camController.value.aspectRatio,
      child: CameraPreview(camController),
    );
  }

  Widget _cameraControlWidget(context){
    return Expanded(
      child: Align(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: [
            FloatingActionButton(
              child: Icon(
                Icons.camera,
                color: Colors.black54,
              ),
              backgroundColor: Colors.white,
              onPressed: (){
                _onCapturePressed(context);
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _cameraCancelWidget(context){
    return Expanded(
      child: Align(
        alignment: Alignment.centerLeft,
        child: IconButton(
              icon: Icon(
                Icons.cancel,
                color: Colors.white,
              ),
              onPressed: (){
                Navigator.pop(context, "");
              },
            )
        )
    );
  }

  @override
  void initState() {
    super.initState();
    _initCamController(widget.cam);
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        body: Container(
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: _cameraPreview(), flex: 1,),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 100,
                    width: double.infinity,
                    padding: EdgeInsets.all(15),
                    color: Colors.black54,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _cameraCancelWidget(context),
                        _cameraControlWidget(context),
                        Spacer(),
                      ],
                    ),
                  )
                )
              ],
            ),
          ),
        ),
      );
  }

  void _showCameraException(CameraException e) {
    String errText = 'Error : ${e.code}\n Desc: ${e.description}';
    print(errText);
  }

  void _onCapturePressed(context) async {
    try{
      final path = join((await getTemporaryDirectory()).path,
          '${DateTime.now()}.png');
      await camController.takePicture(path);
      await moveToPreview(context, path);
    }catch(e){
      _showCameraException(e);
    }
  }

  Future moveToPreview(context, path) async{
    final okPic = await Navigator.push(context, MaterialPageRoute(builder: (context) => PreviewScreen(imgPath: path)));
    if(okPic){
      Navigator.pop(context, path);
    }
  }

  @override
  void dispose() {
    camController?.dispose();
    super.dispose();
  }
}