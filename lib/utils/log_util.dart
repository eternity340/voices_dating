import 'package:logger/logger.dart';
import 'package:voices_dating/utils/logger_filter.dart';

class LogUtil{

  static late Logger logger;

  static final LogUtil _instance = LogUtil._();

  factory LogUtil() =>_instance;

  static LogUtil get instance => LogUtil();


  LogUtil._(){
    init();
  }


  init(){
    logger = Logger(printer:PrettyPrinter(methodCount: 2),filter: MyFilter());
  }

  static d({required String message}){
    logger.d(message);
  }

  static v({required String message}){
    logger.e(message);
  }

  static i({required String message}){
    logger.i(message);
  }

  static e({required String message}){
    logger.e(message);
  }


}