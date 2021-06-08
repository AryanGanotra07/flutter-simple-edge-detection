import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:simple_edge_detection_example/containers/CropView.dart';
import 'package:simple_edge_detection_example/containers/Scan.dart';
import 'package:simple_edge_detection_example/utils/CustomStyles.dart';
import 'package:simple_edge_detection_example/utils/Helpers.dart';


class ImageModeComponent extends StatelessWidget {


  void _onGalleryButtonPressed(BuildContext context) async {
    ImagePicker picker = ImagePicker();
    PickedFile pickedFile = await picker.getImage(source: ImageSource.gallery);
    final filePath = pickedFile.path;
    String  tempPath = await Helpers.createCopy(filePath);
    print('Picture saved to $filePath');
    Helpers.navigateTo(context, CropView(filePath, tempPath));
  }
  @override
  Widget build(BuildContext context) {
    // return Container();
    return Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
              verticalDirection: VerticalDirection.down,
              mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Add New Invoice", style: CustomStyles.cardTitleStyle,),
                      )),
                  Divider(),
                  TextButton(onPressed: (){
                      Helpers.navigateTo(context, Scan());
                  }, child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.camera),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Take a picture"),
                      ),
                    ],
                  )),
                  Text("Or"),
                  TextButton(onPressed: () {
                    _onGalleryButtonPressed(context);
                  }, child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.insert_drive_file_sharp),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Choose from gallery"),
                      ),
                    ],
                  )),

                ],

      ),
        ),
    );

  }

}