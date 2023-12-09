
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:naai/utils/colors_constant.dart';
import 'package:naai/utils/components/curved_bordered_card.dart';
import 'package:naai/utils/components/red_button_with_text.dart';
import 'package:naai/utils/image_path_constant.dart';
import 'package:naai/utils/string_constant.dart';
import 'package:naai/utils/style_constant.dart';
import 'package:naai/view_model/post_auth/home/home_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:open_file/open_file.dart' as open_file;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

//Local imports


class AppointmentDetails extends StatelessWidget {
  final int index;

  const AppointmentDetails({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(builder: (context, provider, child) {
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
                  color: provider.lastOrNextBooking[index].isUpcoming
                      ? const Color(0xFFF6DE86)
                      : const Color(0xFF52D185).withOpacity(0.08),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      provider.lastOrNextBooking[index].isUpcoming
                          ? StringConstant.upcoming.toUpperCase()
                          : StringConstant.completed.toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 10.sp,
                        color: provider.lastOrNextBooking[index].isUpcoming
                            ? ColorsConstant.textDark
                            : const Color(0xFF52D185),
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        children: <InlineSpan>[
                          TextSpan(
                              text: '${StringConstant.booked}: ',
                              style: StyleConstant.textLight11sp400Style),
                          TextSpan(
                            text: provider
                                .lastOrNextBooking[index].createdOnString,
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
                    SizedBox(height: 7.h),
                    textInRow(
                      textOne: StringConstant.customerName,
                      textTwo: provider.userData.name ?? '',
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Visibility(
                          visible: provider.userData.phoneNumber != null,
                          child: Text(
                            StringConstant.mobileNumber,
                            style: StyleConstant.textLight11sp400Style,
                          ),
                          replacement: Text(
                            StringConstant.email,
                            style: StyleConstant.textLight11sp400Style,
                          ),
                        ),
                        Visibility(
                          visible: provider.userData.phoneNumber != null,
                          child: Text(
                            provider.userData.phoneNumber ?? '',
                            style: StyleConstant.textDark12sp500Style,
                          ),
                          replacement: Text(
                            provider.userData.gmailId ?? '',
                            style: StyleConstant.textDark12sp500Style,
                          ),
                        ),
                      ],
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
                            onTap: () {},
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
                          'Rs ${provider.lastOrNextBooking[index].totalPrice}',
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
            visible: provider.lastOrNextBooking[index].isUpcoming,
            replacement: Padding(
              padding: EdgeInsets.only(bottom: 1.h),
              child: RedButtonWithText(
                buttonText: StringConstant.askForReview,
                onTap: () {},
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
                  buttonText: StringConstant.startAppointment,
                  onTap: () {},
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
        CurvedBorderedCard(
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
                  '${provider.lastOrNextBooking[index].artistName}',
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
                        text: provider.getFormattedDateOfBooking(
                          secondaryDateFormat: true,
                          dateTimeString: provider
                              .lastOrNextBooking[index].bookingCreatedFor,
                          index: index,
                        ),
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
                        text: provider.getFormattedDateOfBooking(
                          getTimeScheduled: true,
                          dateTimeString: provider
                              .lastOrNextBooking[index].bookingCreatedFor,
                          index: index,
                        ),
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
                      provider
                          .lastOrNextBooking[index].bookedServiceNames![index2],
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 11.sp,
                        color: const Color(0xFF212121),
                      ),
                    ),
                    separatorBuilder: (context, index) => Text(', '),
                    itemCount: provider.lastOrNextBooking[index]
                            .bookedServiceNames?.length ??
                        0,
                  ),
                )
              ],
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
