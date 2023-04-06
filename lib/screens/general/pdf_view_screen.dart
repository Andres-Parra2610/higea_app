import 'dart:typed_data';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:higea_app/styles/app_theme.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:html' as html;

class PdfViewScreen extends StatefulWidget {
  PdfViewScreen({super.key, required this.url});

  final server = dotenv.env['SERVER_PATH'];
  final String url; 
  
  @override
  _PdfViewScreenState createState() => _PdfViewScreenState();
}

class _PdfViewScreenState extends State<PdfViewScreen> {

  Uint8List pdfBytes = Uint8List(0);

  Future _getPdfBytes() async {
    final response = await http.readBytes(Uri.parse('${widget.server}/reportes/${widget.url}'));
    pdfBytes = response;
    setState(() {});
  }

  @override
  void initState() {
    _getPdfBytes();
    super.initState();
  }


  void _downloadPdf(Uint8List pdfBytes) {
    final blob = html.Blob([pdfBytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = 'example.pdf';
    html.document.body!.children.add(anchor);
    anchor.click();
    html.document.body!.children.remove(anchor);
    html.Url.revokeObjectUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: pdfBytes.isEmpty
          ? const CircularProgressIndicator()
          : SfPdfViewer.memory(pdfBytes)
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: pdfBytes.isEmpty ? null : () => _downloadPdf(pdfBytes),
        backgroundColor: const Color(AppTheme.primaryColor),
        child: const Icon(Icons.download, color: Colors.white,),
      ),
    );
  }
}
