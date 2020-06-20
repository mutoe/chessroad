import 'dart:convert';
import 'dart:io';

class ChessDB {
  static const Host = 'www.chessdb.cn';
  static const Path = '/chessdb.php';

  static Future<String> query(String board) async {
    Uri url = Uri(scheme: 'http', host: Host, path: Path, queryParameters: {
      'action': 'queryall',
      'learn': '1',
      'showall': '1',
      'board': board,
    });

    final httpClient = HttpClient();

    try {
      var httpClientRequest = await httpClient.getUrl(url);
      var httpClientResponse = await httpClientRequest.close();
      return httpClientResponse.transform(utf8.decoder).join();
    } catch (e) {
      print('Error: $e');
    } finally {
      httpClient.close();
    }
    return null;
  }

  static requestComputeBackground(String board) async {
    Uri url = Uri(scheme: 'http', host: Host, path: Path, queryParameters: {
      'action': 'queue',
      'board': board,
    });

    var httpClient = HttpClient();
    try {
      var httpClientRequest = await httpClient.getUrl(url);
      var httpClientResponse = await httpClientRequest.close();
      return await httpClientResponse.transform(utf8.decoder).join();
    } catch (e) {
      print('Error: $e');
    } finally {
      httpClient.close();
    }
    return null;
  }
}
