
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:naai/utils/colors_constant.dart';
import 'package:naai/utils/components/curved_bordered_card.dart';
import 'package:naai/utils/components/red_button_with_text.dart';
import 'package:naai/utils/image_path_constant.dart';
import 'package:naai/utils/string_constant.dart';
import 'package:naai/utils/style_constant.dart';
import 'package:naai/view/post_auth/create_booking/create_booking_screen.dart';
import 'package:naai/view_model/post_auth/home/home_provider.dart';
import 'package:naai/view_model/post_auth/profile/profile_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:open_file/open_file.dart' as open_file;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

import '../../../models/allbooking.dart';
import '../../../utils/components/add_review_component.dart';
import '../../../view_model/post_auth/salon_details/salon_details_provider.dart';

//Local imports


class AppointmentDetails extends StatelessWidget {
  final int index;

  const AppointmentDetails({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer2<HomeProvider ,ProfileProvider>(builder: (context, provider,provider2, child) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          backgroundColor: Colors.white,
          title: Row(
            children: <Widget>[
              IconButton(
                onPressed: () => Navigator.pop(context),
                splashRadius: 0.1,
                splashColor: Colors.transparent,
                icon: Icon(
                  Icons.arrow_back,
                  color: ColorsConstant.textDark,
                ),
              ),
              Text(
                StringConstant.appointmentDetails,
                style: StyleConstant.textDark15sp600Style,
              ),
            ],
          ),
          centerTitle: false,
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 1.h),
                padding: EdgeInsets.symmetric(
                  vertical: 1.h,
                  horizontal: 3.w,
                ),
                decoration: BoxDecoration(
                  color: isBookingDatePassed(provider.previousBooking[index].bookingDate)
                      ? const Color(0xFF52D185).withOpacity(0.08)
                      : const Color(0xFFF6DE86),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      isBookingDatePassed(provider.previousBooking[index].bookingDate)
                          ? StringConstant.completed.toUpperCase()
                          : StringConstant.upcoming.toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 10.sp,
                        color: isBookingDatePassed(provider.previousBooking[index].bookingDate)
                            ? const Color(0xFF52D185)
                            : ColorsConstant.textDark,
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        children: <InlineSpan>[
                          TextSpan(
                              text: '${StringConstant.booked}: ',
                              style: StyleConstant.textLight11sp400Style),
                          TextSpan(
                           text: provider.formatAppointmentDate(provider.previousBooking[index].bookingDate),
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 10.sp,
                              color: ColorsConstant.textDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 4.w,
                  vertical: 2.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    appointmentOverview(provider),
                    SizedBox(height: 2.h),
                    const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Salon Name:-",
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Row(
                        children: [
                          Text(
                            '${provider.previousBooking[index].salonName}',
                            style: StyleConstant.textDark12sp600Style,
                          ),
                          Spacer(),
                          SvgPicture.asset(
                            ImagePathConstant.saveIcon,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Artist Name:-",
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Row(
                        children: [
                          Column(
                            children:[
                              Text(
                                '${provider.previousBooking[index].artistServiceMap.first.artistName}',
                                style: StyleConstant.textDark12sp600Style,
                              ),
                            ],
                          ),
                          Spacer(),
                          SvgPicture.asset(
                            ImagePathConstant.saveIcon,
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: RedButtonWithText(
                            fontSize: 10.sp,
                            fillColor: Colors.white,
                            buttonText: StringConstant.callCustomer,
                            textColor: Colors.black,
                            onTap: () {},
                            shouldShowBoxShadow: false,
                            border: Border.all(),
                            icon: SvgPicture.asset(ImagePathConstant.phoneIcon),
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          flex: 1,
                          child: RedButtonWithText(
                            fontSize: 10.sp,
                            fillColor: Colors.white,
                            buttonText: StringConstant.addToFavourites,
                            textColor: Colors.black,
                            onTap: () {
                              favouritePopUp(context, provider);
                            },
                            shouldShowBoxShadow: false,
                            border: Border.all(),
                            icon: Icon(Icons.star_border),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          StringConstant.invoice,
                          style: StyleConstant.textDark11sp600Style,
                        ),
                      //  IconButton(onPressed: generateInvoice, icon: Icon(Icons.save_alt_outlined))
                      ],
                    ),
                    SizedBox(height: 4.h),
                    textInRow(
                      textOne: StringConstant.subtotal,
                      textTwo:
                          'Rs ${provider.previousBooking[index].paymentStatus}',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              RedButtonWithText(
                buttonText: StringConstant.askForReview,
                onTap: () {
                  reviewPopUp(context,provider);
                },
                fillColor: Colors.white,
                textColor: ColorsConstant.textDark,
                border: Border.all(),
                shouldShowBoxShadow: false,
                padding: EdgeInsets.symmetric(vertical: 1.5.h),
              ),
            ],
          ),
        ),
      );
    });
  }
  bool isBookingDatePassed(DateTime bookingDate) {
    DateTime currentDate = DateTime.now();
    return currentDate.isAfter(bookingDate);
  }

  String formatBookingDate(DateTime bookingDate) {
    DateTime currentDate = DateTime.now();
    Duration difference = bookingDate.difference(currentDate);

    if (difference.inDays == 0) {
      return "Today";
    } else if (difference.inDays == 1) {
      return "1 day later";
    } else if (difference.inDays > 1 && difference.inDays < 7) {
      return "${difference.inDays} days later";
    } else {
      int weeks = (difference.inDays / 7).ceil();
      return "${weeks} ${weeks == 1 ? 'week' : 'weeks'} later";
    }
  }

  void reviewPopUp(BuildContext context,HomeProvider provider) async {
    await showModalBottomSheet(
      isDismissible: false,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(35),
          topRight: Radius.circular(35),
        ),
      ),
      context: context,
      builder: (BuildContext context) {
        return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Container(
                color: Colors.white,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Image.asset(
                        "assets/images/app_logo.png",
                        height: 80,
                        width: 80,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                     Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Review to ${provider.previousBooking.first.salonName} ",
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
              AddReviewComponent(reviewForSalon: true),
                    const SizedBox(height: 8.0),
                     Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Review to ${provider.previousBooking.first.artistServiceMap.first.artistName} ",
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                    AddReviewComponent(reviewForSalon: false),
                  ],
                ),
              ),
            )
        );
      },
    );
  }

  void favouritePopUp(BuildContext context,HomeProvider provider) async {
    await showModalBottomSheet(
      isDismissible: false,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(35),
          topRight: Radius.circular(35),
        ),
      ),
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Image.asset(
                    "assets/images/app_logo.png",
                    height: 80,
                    width: 80,
                  ),
                ),
                const SizedBox(height: 8.0),
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Salon Name:-",
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Row(
                    children: [
                      Text(
                        '${provider.previousBooking[index].salonName}',
                        style: StyleConstant.textDark12sp600Style,
                      ),
                      Spacer(),
                      SvgPicture.asset(
                        ImagePathConstant.saveIcon,
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 8.0),
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Artist Name:-",
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Row(
                    children: [
                      Text(
                        '${provider.previousBooking[index].artistServiceMap.first.artistName}',
                        style: StyleConstant.textDark12sp600Style,
                      ),
                      Spacer(),
                      SvgPicture.asset(
                        ImagePathConstant.saveIcon,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  Widget textInRow({
    required String textOne,
    required String textTwo,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          textOne,
          style: StyleConstant.textLight11sp400Style,
        ),
        Text(
          textTwo,
          style: StyleConstant.textDark12sp500Style,
        ),
      ],
    );
  }

  Widget appointmentOverview(HomeProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          color:  Color(0xFFE9EDF7),
          width: 50.h,
          child: CurvedBorderedCard(
            fillColor: const Color(0xFFE9EDF7),
            removeBottomPadding: false,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    StringConstant.barber,
                    style: StyleConstant.textLight11sp400Style,
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    '${provider.previousBooking[index].artistServiceMap.first.artistName}',
                    style: StyleConstant.textDark12sp600Style,
                  ),
                  SizedBox(height: 1.5.h),
                  Text(
                    StringConstant.appointmentDateAndTime,
                    style: StyleConstant.textLight11sp400Style,
                  ),
                  SizedBox(height: 0.5.h),
                  Text.rich(
                    TextSpan(
                      children: <InlineSpan>[
                        TextSpan(
                          text: provider.formatAppointmentDate(provider.previousBooking[index].bookingDate),
                          style: StyleConstant.textDark12sp600Style,
                        ),
                        TextSpan(
                          text: ' | ',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: ColorsConstant.textLight,
                          ),
                        ),
                        TextSpan(
                          text: provider.previousBooking[index].timeSlot.start,
                          style: StyleConstant.textDark12sp600Style,
                        ),
                      ],
                    ),
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(height: 1.5.h),
                  Text(
                    StringConstant.services,
                    style: StyleConstant.textLight11sp400Style,
                  ),
                  SizedBox(height: 0.5.h),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: 5.h),
                    child: ListView.separated(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index2) => Text(
                        provider.previousBooking[index].artistServiceMap.first.serviceName![index2],
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 11.sp,
                          color: const Color(0xFF212121),
                        ),
                      ),
                      separatorBuilder: (context, index) => Text(''),
                      itemCount: provider.previousBooking[index]
                              .artistServiceMap.first.serviceName?.length ??
                          0,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  ///! This is the code for invoice
  Future<void> generateInvoice() async {
    //Create a PDF document.
    final PdfDocument document = PdfDocument();
    //Add page to the PDF
    final PdfPage page = document.pages.add();
    //Get page client size
    final Size pageSize = page.getClientSize();
    //Draw rectangle
    page.graphics.drawRectangle(
        bounds: Rect.fromLTWH(0, 0, pageSize.width, pageSize.height),
        pen: PdfPen(PdfColor(170,47,76)));
    //Generate PDF grid.
    final PdfGrid grid = getGrid();
    //Draw the header section by creating text element
    final PdfLayoutResult result = drawHeader(page, pageSize, grid);
    //Draw grid
    drawGrid(page, grid, result);
    //Add invoice footer
    drawFooter(page, pageSize);
    //Save the PDF document
    final List<int> bytes = document.saveSync();
    //Dispose the document.
    document.dispose();
    //Save and launch the file.
    await saveAndLaunchFile(bytes, 'Invoice.pdf');
  }
  //Draws the invoice header
  PdfLayoutResult drawHeader(PdfPage page, Size pageSize, PdfGrid grid) {
    //Draw rectangle
    page.graphics.drawRectangle(
        brush: PdfSolidBrush(PdfColor(190,47,76)),
        bounds: Rect.fromLTWH(0, 0, pageSize.width - 115, 90));
    //Draw string
    page.graphics.drawString(
        'INVOICE', PdfStandardFont(PdfFontFamily.helvetica, 30),
        brush: PdfBrushes.white,
        bounds: Rect.fromLTWH(25, 0, pageSize.width - 115, 90),
        format: PdfStringFormat(lineAlignment: PdfVerticalAlignment.middle));

    page.graphics.drawRectangle(
        bounds: Rect.fromLTWH(400, 0, pageSize.width - 400, 90),
        brush: PdfSolidBrush(PdfColor(170,47,76)));

    page.graphics.drawString(r'$' + getTotalAmount(grid).toString(),
        PdfStandardFont(PdfFontFamily.helvetica, 18),
        bounds: Rect.fromLTWH(400, 0, pageSize.width - 400, 100),
        brush: PdfBrushes.white,
        format: PdfStringFormat(
            alignment: PdfTextAlignment.center,
            lineAlignment: PdfVerticalAlignment.middle));

    final PdfFont contentFont = PdfStandardFont(PdfFontFamily.helvetica, 9);
    //Draw string
    page.graphics.drawString('Amount', contentFont,
        brush: PdfBrushes.white,
        bounds: Rect.fromLTWH(400, 0, pageSize.width - 400, 33),
        format: PdfStringFormat(
            alignment: PdfTextAlignment.center,
            lineAlignment: PdfVerticalAlignment.bottom));
    //Create data foramt and convert it to text.
    final DateFormat format = DateFormat.yMMMMd('en_US');
    final String invoiceNumber =
        'Invoice Number: 2058557939\r\n\r\nDate: ${format.format(DateTime.now())}';
    final Size contentSize = contentFont.measureString(invoiceNumber);
    // ignore: leading_newlines_in_multiline_strings
    const String address = '''Bill To: \r\n\r\nAbraham Swearegin, 
        \r\n\r\nUnited States, California, San Mateo, 
        \r\n\r\n9920 BridgePointe Parkway, \r\n\r\n9365550136''';

    PdfTextElement(text: invoiceNumber, font: contentFont).draw(
        page: page,
        bounds: Rect.fromLTWH(pageSize.width - (contentSize.width + 30), 120,
            contentSize.width + 30, pageSize.height - 120));

    return PdfTextElement(text: address, font: contentFont).draw(
        page: page,
        bounds: Rect.fromLTWH(30, 120,
            pageSize.width - (contentSize.width + 30), pageSize.height - 120))!;
  }

  //Draws the grid
  void drawGrid(PdfPage page, PdfGrid grid, PdfLayoutResult result) {
    Rect? totalPriceCellBounds;
    Rect? quantityCellBounds;
    //Invoke the beginCellLayout event.
    grid.beginCellLayout = (Object sender, PdfGridBeginCellLayoutArgs args) {
      final PdfGrid grid = sender as PdfGrid;
      if (args.cellIndex == grid.columns.count - 1) {
        totalPriceCellBounds = args.bounds;
      } else if (args.cellIndex == grid.columns.count - 2) {
        quantityCellBounds = args.bounds;
      }
    };
    //Draw the PDF grid and get the result.
    result = grid.draw(
        page: page, bounds: Rect.fromLTWH(0, result.bounds.bottom + 40, 0, 0))!;

    //Draw grand total.
    page.graphics.drawString('Grand Total',
        PdfStandardFont(PdfFontFamily.helvetica, 9, style: PdfFontStyle.bold),
        bounds: Rect.fromLTWH(
            quantityCellBounds!.left,
            result.bounds.bottom + 10,
            quantityCellBounds!.width,
            quantityCellBounds!.height));
    page.graphics.drawString(getTotalAmount(grid).toString(),
        PdfStandardFont(PdfFontFamily.helvetica, 9, style: PdfFontStyle.bold),
        bounds: Rect.fromLTWH(
            totalPriceCellBounds!.left,
            result.bounds.bottom + 10,
            totalPriceCellBounds!.width,
            totalPriceCellBounds!.height));
  }

  //Draw the invoice footer data.
  void drawFooter(PdfPage page, Size pageSize) {
    final PdfPen linePen =
    PdfPen(PdfColor(190,47,76), dashStyle: PdfDashStyle.custom);
    linePen.dashPattern = <double>[3, 3];
    //Draw line
    page.graphics.drawLine(linePen, Offset(0, pageSize.height - 100),
        Offset(pageSize.width, pageSize.height - 100));

    const String footerContent =
    // ignore: leading_newlines_in_multiline_strings
    '''800 Interchange Blvd.\r\n\r\nSuite 2501, Austin,
         TX 78721\r\n\r\nAny Questions? support@adventure-works.com''';

    //Added 30 as a margin for the layout
    page.graphics.drawString(
        footerContent, PdfStandardFont(PdfFontFamily.helvetica, 9),
        format: PdfStringFormat(alignment: PdfTextAlignment.right),
        bounds: Rect.fromLTWH(pageSize.width - 30, pageSize.height - 70, 0, 0));
  }

  //Create PDF grid and return
  PdfGrid getGrid() {
    //Create a PDF grid
    final PdfGrid grid = PdfGrid();
    //Secify the columns count to the grid.
    grid.columns.add(count: 5);
    //Create the header row of the grid.
    final PdfGridRow headerRow = grid.headers.add(1)[0];
    //Set style
    headerRow.style.backgroundBrush = PdfSolidBrush(PdfColor(190,47,76));
    headerRow.style.textBrush = PdfBrushes.white;
    headerRow.cells[0].value = 'Product Id';
    headerRow.cells[0].stringFormat.alignment = PdfTextAlignment.center;
    headerRow.cells[1].value = 'Product Name';
    headerRow.cells[2].value = 'Price';
    headerRow.cells[3].value = 'Quantity';
    headerRow.cells[4].value = 'Total';
    //Add rows
    addProducts('CA-1098', 'AWC Logo Cap', 8.99, 2, 17.98, grid);
    addProducts('LJ-0192', 'Long-Sleeve Logo Jersey,M', 49.99, 3, 149.97, grid);
    addProducts('So-B909-M', 'Mountain Bike Socks,M', 9.5, 2, 19, grid);
    addProducts('LJ-0192', 'Long-Sleeve Logo Jersey,M', 49.99, 4, 199.96, grid);
    addProducts('FK-5136', 'ML Fork', 175.49, 6, 1052.94, grid);
    addProducts('HL-U509', 'Sports-100 Helmet,Black', 34.99, 1, 34.99, grid);
    //Apply the table built-in style
    grid.applyBuiltInStyle(PdfGridBuiltInStyle.listTable4Accent5);
    //Set gird columns width
    grid.columns[1].width = 200;
    for (int i = 0; i < headerRow.cells.count; i++) {
      headerRow.cells[i].style.cellPadding =
          PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
    }
    for (int i = 0; i < grid.rows.count; i++) {
      final PdfGridRow row = grid.rows[i];
      for (int j = 0; j < row.cells.count; j++) {
        final PdfGridCell cell = row.cells[j];
        if (j == 0) {
          cell.stringFormat.alignment = PdfTextAlignment.center;
        }
        cell.style.cellPadding =
            PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
      }
    }
    return grid;
  }

  //Create and row for the grid.
  void addProducts(String productId, String productName, double price,
      int quantity, double total, PdfGrid grid) {
    final PdfGridRow row = grid.rows.add();
    row.cells[0].value = productId;
    row.cells[1].value = productName;
    row.cells[2].value = price.toString();
    row.cells[3].value = quantity.toString();
    row.cells[4].value = total.toString();
  }

  //Get the total amount.
  double getTotalAmount(PdfGrid grid) {
    double total = 0;
    for (int i = 0; i < grid.rows.count; i++) {
      final String value =
      grid.rows[i].cells[grid.columns.count - 1].value as String;
      total += double.parse(value);
    }
    return total;
  }

  Future<void> saveAndLaunchFile(List<int> bytes, String fileName) async {
    //Get the storage folder location using path_provider package.
    String? path;
    if (Platform.isAndroid ||
        Platform.isIOS ||
        Platform.isLinux ||
        Platform.isWindows) {
      final Directory directory =
      await path_provider.getApplicationSupportDirectory();
      path = directory.path;
    } else {
      path = await PathProviderPlatform.instance.getApplicationSupportPath();
    }
    final File file =
    File(Platform.isWindows ? '$path\\$fileName' : '$path/$fileName');
    await file.writeAsBytes(bytes, flush: true);
    if (Platform.isAndroid || Platform.isIOS) {
      //Launch the file (used open_file package)
      await open_file.OpenFile.open('$path/$fileName');
    } else if (Platform.isWindows) {
      await Process.run('start', <String>['$path\\$fileName'], runInShell: true);
    } else if (Platform.isMacOS) {
      await Process.run('open', <String>['$path/$fileName'], runInShell: true);
    } else if (Platform.isLinux) {
      await Process.run('xdg-open', <String>['$path/$fileName'],
          runInShell: true);
    }
  }
}



class AppointmentDetails2 extends StatelessWidget {
  final CurrentBooking booking;

  const AppointmentDetails2({
    super.key,
    required this.booking,
  });

  @override
  Widget build(BuildContext context) {

    return Consumer2<HomeProvider,SalonDetailsProvider>(builder: (context, provider,salonprovider ,child) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          backgroundColor: Colors.white,
          title: Row(
            children: <Widget>[
              IconButton(
                onPressed: () => Navigator.pop(context),
                splashRadius: 0.1,
                splashColor: Colors.transparent,
                icon: Icon(
                  Icons.arrow_back,
                  color: ColorsConstant.textDark,
                ),
              ),
              Text(
                StringConstant.appointmentDetails,
                style: StyleConstant.textDark15sp600Style,
              ),
            ],
          ),
          centerTitle: false,
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 1.h),
                padding: EdgeInsets.symmetric(
                  vertical: 1.h,
                  horizontal: 3.w,
                ),
                decoration: BoxDecoration(
                  color: isBookingDatePassed(booking.bookingDate)
                      ? const Color(0xFF52D185).withOpacity(0.08)
                      :const Color(0xFFF6DE86)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      isBookingDatePassed(booking.bookingDate)
                          ? StringConstant.completed.toUpperCase()
                          : StringConstant.upcoming.toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 10.sp,
                        color: isBookingDatePassed(booking.bookingDate)
                            ? const Color(0xFF52D185)
                            : ColorsConstant.textDark,
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        children: <InlineSpan>[
                          TextSpan(
                              text: '${StringConstant.booked}: ',
                              style: StyleConstant.textLight11sp400Style),
                          TextSpan(
                            text: provider.formatAppointmentDate(booking.bookingDate),
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 10.sp,
                              color: ColorsConstant.textDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 4.w,
                  vertical: 2.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    appointmentOverview(provider),
                    SizedBox(height: 2.h),
                    const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Salon Name:-",
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Row(
                        children: [
                          Text(
                            '${booking.salonName}',
                            style: StyleConstant.textDark12sp600Style,
                          ),
                          Spacer(),
                          SvgPicture.asset(
                            ImagePathConstant.saveIcon,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Artist Name:-",
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                 //   for ( var booking in booking.artistServiceMap)
                      Align(
                        alignment: Alignment.topLeft,
                        child: Row(
                          children: [
                            Text(
                              '${booking.artistServiceMap.first.artistName}',
                              style: StyleConstant.textDark12sp600Style,
                            ),
                            Spacer(),
                            IconButton(
                              onPressed: () {
                                // Add functionality here for when the save icon is pressed
                              },
                              icon: SvgPicture.asset(
                                ImagePathConstant.saveIcon,
                              ),
                            )
                          ],
                        ),
                      ),
                    SizedBox(height: 3.h),
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: RedButtonWithText(
                            fontSize: 10.sp,
                            fillColor: Colors.white,
                            buttonText: StringConstant.callCustomer,
                            textColor: Colors.black,
                            onTap: () {},
                            shouldShowBoxShadow: false,
                            border: Border.all(),
                            icon: SvgPicture.asset(ImagePathConstant.phoneIcon),
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          flex: 1,
                          child: RedButtonWithText(
                            fontSize: 10.sp,
                            fillColor: Colors.white,
                            buttonText: StringConstant.addToFavourites,
                            textColor: Colors.black,
                            onTap: () {
                              favouritePopUp(context, provider);
                            },
                            shouldShowBoxShadow: false,
                            border: Border.all(),
                            icon: Icon(Icons.star_border),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          StringConstant.invoice,
                          style: StyleConstant.textDark11sp600Style,
                        ),
                        //  IconButton(onPressed: generateInvoice, icon: Icon(Icons.save_alt_outlined))
                      ],
                    ),
                    SizedBox(height: 4.h),
                    textInRow(
                      textOne: StringConstant.subtotal,
                      textTwo:
                      'Rs ${booking.paymentStatus}',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Visibility(
            visible: booking.paymentStatus.endsWith("pending"),
            replacement: Padding(
              padding: EdgeInsets.only(bottom: 1.h),
              child: RedButtonWithText(
                buttonText: StringConstant.askForReview,
                onTap: () {
                  reviewPopUp(context);
                },
                fillColor: Colors.white,
                textColor: ColorsConstant.textDark,
                border: Border.all(),
                shouldShowBoxShadow: false,
                padding: EdgeInsets.symmetric(vertical: 1.5.h),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                RedButtonWithText(
                  buttonText: StringConstant.Resheduling ,
                  onTap: () async{
                    String salonId =booking.salonId;
                    List<String> selectedServiceIds = booking.artistServiceMap
                        .map((service) => service.serviceId)
                        .toList();
                    await salonprovider.fetchArtist(context,salonId, selectedServiceIds);
                    salonprovider.setSchedulingStatus(onSelectStaff: true);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CreateBookingScreen2(
                              artistName: booking.artistServiceMap.first.artistName,
                              artistId: booking.artistServiceMap.first.artistId,
                            ),
                      ),

                    );
                    print('artist id : ${booking.artistServiceMap.first.artistName}');
                    print('artist name : ${booking.artistServiceMap.first.artistId}');
                    print(' service : ${selectedServiceIds}');
                  },
                  fillColor: ColorsConstant.textDark,
                  shouldShowBoxShadow: false,
                  padding: EdgeInsets.symmetric(vertical: 1.5.h),
                  border: Border.all(color: ColorsConstant.textDark),
                ),
                SizedBox(height: 1.h),
                RedButtonWithText(
                  buttonText: StringConstant.cancel,
                  onTap: () {},
                  fillColor: Colors.white,
                  textColor: ColorsConstant.textDark,
                  border: Border.all(),
                  shouldShowBoxShadow: false,
                  icon: Icon(Icons.close),
                  padding: EdgeInsets.symmetric(vertical: 1.5.h),
                ),
                SizedBox(height: 1.h),
              ],
            ),
          ),
        ),
      );
    });
  }
  bool isBookingDatePassed(DateTime bookingDate) {
    DateTime currentDate = DateTime.now();
    return currentDate.isAfter(bookingDate);
  }

  String formatAppointmentDate(DateTime bookingDate) {
    DateTime currentDate = DateTime.now();
    Duration difference = bookingDate.difference(currentDate);

    if (difference.inDays == 0) {
      return "Today";
    } else if (difference.inDays == 1) {
      return "1 day later";
    } else if (difference.inDays > 1 && difference.inDays < 7) {
      return "${difference.inDays} days later";
    } else {
      int weeks = (difference.inDays / 7).ceil();
      return "${weeks} ${weeks == 1 ? 'week' : 'weeks'} later";
    }
  }


  void reviewPopUp(BuildContext context) async {
    int selectedStarIndex = -1;
    await showModalBottomSheet(
      isDismissible: false,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(35),
          topRight: Radius.circular(35),
        ),
      ),
      context: context,
      builder: (BuildContext context) {
        return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Image.asset(
                      "assets/images/app_logo.png",
                      height: 80,
                      width: 80,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Review to Salon ",
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 2.h,
                      horizontal: 5.w,
                    ),
                    decoration: BoxDecoration(
                      color: ColorsConstant.graphicFillDark,
                      borderRadius: BorderRadius.circular(2.h),
                    ),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SvgPicture.asset(
                              ImagePathConstant.addYourReviewIcon,
                              fit: BoxFit.scaleDown,
                            ),
                            SizedBox(width: 5.w),
                            Text(
                              StringConstant.addYourReview,
                              style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 2.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            SizedBox(width: 5.w),
                            ...List.generate(
                              5,
                                  (index) => GestureDetector(
                                onTap: () {},
                                child: SvgPicture.asset(
                                  ImagePathConstant.reviewStarIcon,
                                  color: selectedStarIndex >= index
                                      ? ColorsConstant.yellowStar
                                      : ColorsConstant.reviewStarGreyColor,
                                ),
                              ),
                            ),
                            SizedBox(width: 5.w),
                          ],
                        ),
                        SizedBox(height: 3.h),
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: 6.h,
                            maxHeight: 19.h,
                          ),
                          child: TextFormField(
                            //   controller: reviewTextController,
                            maxLines: null,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(
                                left: 5.w,
                                right: 5.w,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              hintText: StringConstant.summarizeYourReview,
                              hintStyle: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w400,
                                color: ColorsConstant.textLight,
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(1.5.h),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 2.h),
                        GestureDetector(
                          onTap: () async {

                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 1.5.h,
                              horizontal: 10.w,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(1.5.h),
                            ),
                            child: Text(
                              StringConstant.submitReviewSalon,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 11.sp,
                                color: ColorsConstant.appColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Review to Artist ",
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 2.h,
                      horizontal: 5.w,
                    ),
                    decoration: BoxDecoration(
                      color: ColorsConstant.graphicFillDark,
                      borderRadius: BorderRadius.circular(2.h),
                    ),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SvgPicture.asset(
                              ImagePathConstant.addYourReviewIcon,
                              fit: BoxFit.scaleDown,
                            ),
                            SizedBox(width: 5.w),
                            Text(
                              StringConstant.addYourReview,
                              style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 2.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            SizedBox(width: 5.w),
                            ...List.generate(
                              5,
                                  (index) => GestureDetector(
                                onTap: () {},
                                child: SvgPicture.asset(
                                  ImagePathConstant.reviewStarIcon,
                                  color: selectedStarIndex >= index
                                      ? ColorsConstant.yellowStar
                                      : ColorsConstant.reviewStarGreyColor,
                                ),
                              ),
                            ),
                            SizedBox(width: 5.w),
                          ],
                        ),
                        SizedBox(height: 3.h),
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: 6.h,
                            maxHeight: 19.h,
                          ),
                          child: TextFormField(
                            //   controller: reviewTextController,
                            maxLines: null,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(
                                left: 5.w,
                                right: 5.w,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              hintText: StringConstant.summarizeYourReview,
                              hintStyle: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w400,
                                color: ColorsConstant.textLight,
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(1.5.h),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 2.h),
                        GestureDetector(
                          onTap: () async {

                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 1.5.h,
                              horizontal: 10.w,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(1.5.h),
                            ),
                            child: Text(
                              StringConstant.submitReviewArtist,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 11.sp,
                                color: ColorsConstant.appColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
        );
      },
    );
  }

  void favouritePopUp(BuildContext context,HomeProvider provider) async {
    await showModalBottomSheet(
      isDismissible: false,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(35),
          topRight: Radius.circular(35),
        ),
      ),
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Image.asset(
                    "assets/images/app_logo.png",
                    height: 80,
                    width: 80,
                  ),
                ),
                const SizedBox(height: 8.0),
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Salon Name:-",
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Row(
                    children: [
                      Text(
                        '${booking.salonName}',
                        style: StyleConstant.textDark12sp600Style,
                      ),
                      Spacer(),
                      SvgPicture.asset(
                        ImagePathConstant.saveIcon,
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 8.0),
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Artist Name:-",
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Row(
                    children: [
                      Text(
                        '${booking.artistServiceMap.first.artistName}',
                        style: StyleConstant.textDark12sp600Style,
                      ),
                      Spacer(),
                      SvgPicture.asset(
                        ImagePathConstant.saveIcon,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  Widget textInRow({
    required String textOne,
    required String textTwo,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          textOne,
          style: StyleConstant.textLight11sp400Style,
        ),
        Text(
          textTwo,
          style: StyleConstant.textDark12sp500Style,
        ),
      ],
    );
  }

  Widget appointmentOverview(HomeProvider provider) {
    return Container(
      color: Color(0xFFE9EDF7),
      width: 50.h,
      child: CurvedBorderedCard(
        fillColor: const Color(0xFFE9EDF7),
        removeBottomPadding: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Barber',
                style: StyleConstant.textLight11sp400Style,
              ),
              SizedBox(height: 0.5.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  //for (var artistService in booking.artistServiceMap)
                    Text(
                      '${booking.artistServiceMap.first.artistName} ',
                      style: StyleConstant.textDark12sp600Style,
                    ),
                ],
              ),
              SizedBox(height: 1.5.h),
              Text(
                'Appointment Date and Time',
                style: StyleConstant.textLight11sp400Style,
              ),
              SizedBox(height: 0.5.h),
              Text.rich(
                TextSpan(
                  children: <InlineSpan>[
                    TextSpan(
                      text: provider.formatAppointmentDate(booking.bookingDate),
                      style: StyleConstant.textDark12sp600Style,
                    ),
                    TextSpan(
                      text: ' | ',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: ColorsConstant.textLight,
                      ),
                    ),
                    TextSpan(
                      text: booking.timeSlot.start,
                      style: StyleConstant.textDark12sp600Style,
                    ),
                  ],
                ),
                textAlign: TextAlign.start,
              ),
              SizedBox(height: 1.5.h),
              Text(
                'Service',
                style: StyleConstant.textLight11sp400Style,
              ),
              SizedBox(height: 0.5.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                //  for (var artistService in booking.artistServiceMap)
                    ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: 5.h),
                      child: ListView.separated(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index2) =>
                            Text('${booking.artistServiceMap.first.serviceName![index2]}',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 11.sp,
                            color: const Color(0xFF212121),
                          ),
                        ),
                        separatorBuilder: (context, index) => Text(''),
                        itemCount: booking.artistServiceMap.first.serviceName?.length ?? 0,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }




  ///! This is the code for invoice
  Future<void> generateInvoice() async {
    //Create a PDF document.
    final PdfDocument document = PdfDocument();
    //Add page to the PDF
    final PdfPage page = document.pages.add();
    //Get page client size
    final Size pageSize = page.getClientSize();
    //Draw rectangle
    page.graphics.drawRectangle(
        bounds: Rect.fromLTWH(0, 0, pageSize.width, pageSize.height),
        pen: PdfPen(PdfColor(170,47,76)));
    //Generate PDF grid.
    final PdfGrid grid = getGrid();
    //Draw the header section by creating text element
    final PdfLayoutResult result = drawHeader(page, pageSize, grid);
    //Draw grid
    drawGrid(page, grid, result);
    //Add invoice footer
    drawFooter(page, pageSize);
    //Save the PDF document
    final List<int> bytes = document.saveSync();
    //Dispose the document.
    document.dispose();
    //Save and launch the file.
    await saveAndLaunchFile(bytes, 'Invoice.pdf');
  }
  //Draws the invoice header
  PdfLayoutResult drawHeader(PdfPage page, Size pageSize, PdfGrid grid) {
    //Draw rectangle
    page.graphics.drawRectangle(
        brush: PdfSolidBrush(PdfColor(190,47,76)),
        bounds: Rect.fromLTWH(0, 0, pageSize.width - 115, 90));
    //Draw string
    page.graphics.drawString(
        'INVOICE', PdfStandardFont(PdfFontFamily.helvetica, 30),
        brush: PdfBrushes.white,
        bounds: Rect.fromLTWH(25, 0, pageSize.width - 115, 90),
        format: PdfStringFormat(lineAlignment: PdfVerticalAlignment.middle));

    page.graphics.drawRectangle(
        bounds: Rect.fromLTWH(400, 0, pageSize.width - 400, 90),
        brush: PdfSolidBrush(PdfColor(170,47,76)));

    page.graphics.drawString(r'$' + getTotalAmount(grid).toString(),
        PdfStandardFont(PdfFontFamily.helvetica, 18),
        bounds: Rect.fromLTWH(400, 0, pageSize.width - 400, 100),
        brush: PdfBrushes.white,
        format: PdfStringFormat(
            alignment: PdfTextAlignment.center,
            lineAlignment: PdfVerticalAlignment.middle));

    final PdfFont contentFont = PdfStandardFont(PdfFontFamily.helvetica, 9);
    //Draw string
    page.graphics.drawString('Amount', contentFont,
        brush: PdfBrushes.white,
        bounds: Rect.fromLTWH(400, 0, pageSize.width - 400, 33),
        format: PdfStringFormat(
            alignment: PdfTextAlignment.center,
            lineAlignment: PdfVerticalAlignment.bottom));
    //Create data foramt and convert it to text.
    final DateFormat format = DateFormat.yMMMMd('en_US');
    final String invoiceNumber =
        'Invoice Number: 2058557939\r\n\r\nDate: ${format.format(DateTime.now())}';
    final Size contentSize = contentFont.measureString(invoiceNumber);
    // ignore: leading_newlines_in_multiline_strings
    const String address = '''Bill To: \r\n\r\nAbraham Swearegin, 
        \r\n\r\nUnited States, California, San Mateo, 
        \r\n\r\n9920 BridgePointe Parkway, \r\n\r\n9365550136''';

    PdfTextElement(text: invoiceNumber, font: contentFont).draw(
        page: page,
        bounds: Rect.fromLTWH(pageSize.width - (contentSize.width + 30), 120,
            contentSize.width + 30, pageSize.height - 120));

    return PdfTextElement(text: address, font: contentFont).draw(
        page: page,
        bounds: Rect.fromLTWH(30, 120,
            pageSize.width - (contentSize.width + 30), pageSize.height - 120))!;
  }

  //Draws the grid
  void drawGrid(PdfPage page, PdfGrid grid, PdfLayoutResult result) {
    Rect? totalPriceCellBounds;
    Rect? quantityCellBounds;
    //Invoke the beginCellLayout event.
    grid.beginCellLayout = (Object sender, PdfGridBeginCellLayoutArgs args) {
      final PdfGrid grid = sender as PdfGrid;
      if (args.cellIndex == grid.columns.count - 1) {
        totalPriceCellBounds = args.bounds;
      } else if (args.cellIndex == grid.columns.count - 2) {
        quantityCellBounds = args.bounds;
      }
    };
    //Draw the PDF grid and get the result.
    result = grid.draw(
        page: page, bounds: Rect.fromLTWH(0, result.bounds.bottom + 40, 0, 0))!;

    //Draw grand total.
    page.graphics.drawString('Grand Total',
        PdfStandardFont(PdfFontFamily.helvetica, 9, style: PdfFontStyle.bold),
        bounds: Rect.fromLTWH(
            quantityCellBounds!.left,
            result.bounds.bottom + 10,
            quantityCellBounds!.width,
            quantityCellBounds!.height));
    page.graphics.drawString(getTotalAmount(grid).toString(),
        PdfStandardFont(PdfFontFamily.helvetica, 9, style: PdfFontStyle.bold),
        bounds: Rect.fromLTWH(
            totalPriceCellBounds!.left,
            result.bounds.bottom + 10,
            totalPriceCellBounds!.width,
            totalPriceCellBounds!.height));
  }

  //Draw the invoice footer data.
  void drawFooter(PdfPage page, Size pageSize) {
    final PdfPen linePen =
    PdfPen(PdfColor(190,47,76), dashStyle: PdfDashStyle.custom);
    linePen.dashPattern = <double>[3, 3];
    //Draw line
    page.graphics.drawLine(linePen, Offset(0, pageSize.height - 100),
        Offset(pageSize.width, pageSize.height - 100));

    const String footerContent =
    // ignore: leading_newlines_in_multiline_strings
    '''800 Interchange Blvd.\r\n\r\nSuite 2501, Austin,
         TX 78721\r\n\r\nAny Questions? support@adventure-works.com''';

    //Added 30 as a margin for the layout
    page.graphics.drawString(
        footerContent, PdfStandardFont(PdfFontFamily.helvetica, 9),
        format: PdfStringFormat(alignment: PdfTextAlignment.right),
        bounds: Rect.fromLTWH(pageSize.width - 30, pageSize.height - 70, 0, 0));
  }

  //Create PDF grid and return
  PdfGrid getGrid() {
    //Create a PDF grid
    final PdfGrid grid = PdfGrid();
    //Secify the columns count to the grid.
    grid.columns.add(count: 5);
    //Create the header row of the grid.
    final PdfGridRow headerRow = grid.headers.add(1)[0];
    //Set style
    headerRow.style.backgroundBrush = PdfSolidBrush(PdfColor(190,47,76));
    headerRow.style.textBrush = PdfBrushes.white;
    headerRow.cells[0].value = 'Product Id';
    headerRow.cells[0].stringFormat.alignment = PdfTextAlignment.center;
    headerRow.cells[1].value = 'Product Name';
    headerRow.cells[2].value = 'Price';
    headerRow.cells[3].value = 'Quantity';
    headerRow.cells[4].value = 'Total';
    //Add rows
    addProducts('CA-1098', 'AWC Logo Cap', 8.99, 2, 17.98, grid);
    addProducts('LJ-0192', 'Long-Sleeve Logo Jersey,M', 49.99, 3, 149.97, grid);
    addProducts('So-B909-M', 'Mountain Bike Socks,M', 9.5, 2, 19, grid);
    addProducts('LJ-0192', 'Long-Sleeve Logo Jersey,M', 49.99, 4, 199.96, grid);
    addProducts('FK-5136', 'ML Fork', 175.49, 6, 1052.94, grid);
    addProducts('HL-U509', 'Sports-100 Helmet,Black', 34.99, 1, 34.99, grid);
    //Apply the table built-in style
    grid.applyBuiltInStyle(PdfGridBuiltInStyle.listTable4Accent5);
    //Set gird columns width
    grid.columns[1].width = 200;
    for (int i = 0; i < headerRow.cells.count; i++) {
      headerRow.cells[i].style.cellPadding =
          PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
    }
    for (int i = 0; i < grid.rows.count; i++) {
      final PdfGridRow row = grid.rows[i];
      for (int j = 0; j < row.cells.count; j++) {
        final PdfGridCell cell = row.cells[j];
        if (j == 0) {
          cell.stringFormat.alignment = PdfTextAlignment.center;
        }
        cell.style.cellPadding =
            PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
      }
    }
    return grid;
  }

  //Create and row for the grid.
  void addProducts(String productId, String productName, double price,
      int quantity, double total, PdfGrid grid) {
    final PdfGridRow row = grid.rows.add();
    row.cells[0].value = productId;
    row.cells[1].value = productName;
    row.cells[2].value = price.toString();
    row.cells[3].value = quantity.toString();
    row.cells[4].value = total.toString();
  }

  //Get the total amount.
  double getTotalAmount(PdfGrid grid) {
    double total = 0;
    for (int i = 0; i < grid.rows.count; i++) {
      final String value =
      grid.rows[i].cells[grid.columns.count - 1].value as String;
      total += double.parse(value);
    }
    return total;
  }

  Future<void> saveAndLaunchFile(List<int> bytes, String fileName) async {
    //Get the storage folder location using path_provider package.
    String? path;
    if (Platform.isAndroid ||
        Platform.isIOS ||
        Platform.isLinux ||
        Platform.isWindows) {
      final Directory directory =
      await path_provider.getApplicationSupportDirectory();
      path = directory.path;
    } else {
      path = await PathProviderPlatform.instance.getApplicationSupportPath();
    }
    final File file =
    File(Platform.isWindows ? '$path\\$fileName' : '$path/$fileName');
    await file.writeAsBytes(bytes, flush: true);
    if (Platform.isAndroid || Platform.isIOS) {
      //Launch the file (used open_file package)
      await open_file.OpenFile.open('$path/$fileName');
    } else if (Platform.isWindows) {
      await Process.run('start', <String>['$path\\$fileName'], runInShell: true);
    } else if (Platform.isMacOS) {
      await Process.run('open', <String>['$path/$fileName'], runInShell: true);
    } else if (Platform.isLinux) {
      await Process.run('xdg-open', <String>['$path/$fileName'],
          runInShell: true);
    }
  }
}