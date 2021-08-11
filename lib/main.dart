import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<File> file = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        addfiles();
                      },
                      child: const Text('Upload files'),
                    ),
                    Text(
                      file.isEmpty
                          ? 'You have not added any files:'
                          : 'you added these files:',
                    ),
                    Text(
                      '${file.length}',
                      key: const Key('Text'),
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ],
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: file.length,
                itemBuilder: (BuildContext context, int i) {
                  return Text(file[i].basename, key: Key('Text$i'));
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> addfiles() async {
    final newFiles = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['mp3', 'ogg', 'm4a', 'oga', 'zip', 'rar'],
    );
    if (newFiles != null) {
      for (final newFile in newFiles.files) {
        setState(() {
          file.add(const LocalFileSystem().file(newFile.path!));
        });
      }
    }
  }
}
