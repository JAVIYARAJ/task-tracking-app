import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_tracker/components/reusable_button.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../Constant/constant.dart';

class DocumentWebView extends StatefulWidget {
  
  final String? path;
  final String? documentType;
  final WebViewController? controller;

  const DocumentWebView({Key? key, this.path,this.documentType,this.controller})
      : super(key: key);

  @override
  State<DocumentWebView> createState() => _DocumentWebViewState();
}

class _DocumentWebViewState extends State<DocumentWebView> {
  // String? _path;
  int? _currentPdfPage=0;
  int? _totalPdfPages=0;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    Widget getWidget(String type) {
      if (type == "pdf") {
        if (widget.path == null) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.grey,
            ),
          );
        } else{
          return PDFView(
            fitPolicy: FitPolicy.BOTH,
            filePath: widget.path,
            enableSwipe: true,
            swipeHorizontal: false,
            autoSpacing: false,
            pageFling: true,
            onError: (error) {
              //beautiful custom message
            },
            onPageError: (page, error) {
              debugPrint('$page: ${error.toString()}');
            },
            onViewCreated: (PDFViewController pdfViewController) {
              //set page number
            },
            onPageChanged: (int? page, int? total) {
              setState((){
                _currentPdfPage=page;
                _totalPdfPages=total;
              });
            },
          );
        }
      }
      else if (type == "png" || type == "jpg") {
        return WebViewWidget(
          controller: widget.controller!,
        );
      }
      else if (type == "docx") {
        return ReusableWidgets.buildErrorScreen();
      }
      return Center(
        child: Text(
          "Document Not Found Please Try Again.",
          style: mPoppinsTextBlack
        ),
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0XFF77a7f0),
            actions: [
              if (widget.documentType=="pdf") Padding(
                padding:const EdgeInsets.only(right: 10),
                child: Row(
                  children: [
                    Text("${_currentPdfPage!+1}/$_totalPdfPages",style: GoogleFonts.poppins(fontSize: 20,color: Colors.white),)
                  ],
                ),
              ) else Container()
            ],
            leading: GestureDetector(
                onTap: () async {
                  Navigator.pop(context);
                  await widget.controller!.clearCache();
                  await widget.controller!.clearLocalStorage();
                },
                child: const Icon(
                  Icons.clear,
                  size: largeIcon,
                )),
            title: Text(
              "Document Viewer",
              style: mPoppinsTextWhite
            ),
          ),
          body: getWidget(widget.documentType!)),
    );
  }
}
