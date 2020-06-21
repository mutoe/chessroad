import 'package:chessroad/chess/chess-base.dart';
import 'package:chessroad/chess/phase.dart';
import 'package:chessroad/engine/analysis.dart';
import 'package:chessroad/engine/chess-db.dart';

class EngineResponse {
  final String type;
  final dynamic value;

  EngineResponse(this.type, {this.value});

  @override
  String toString() {
    return 'type: $type, value: $value';
  }
}

class CloudEngine {
  Future<EngineResponse> search(Phase phase, {bool byUser = true}) async {
    final fen = phase.toFen();
    var response = await ChessDB.query(fen);
    if (response == null) return EngineResponse('network-error');

    if (!response.startsWith('move:')) {
      print('ChessDB.query: $response');
    } else {
      final firstStep = response.split('|')[0];
      print('ChessDB.query: $firstStep');

      var segments = firstStep.split(',');
      if (segments.length < 2) return EngineResponse('data-error');

      final move = segments[0];
      final score = segments[1];
      final scoreSegments = score.split(':');
      if (scoreSegments.length < 2) EngineResponse('data-error');

      final moveWithScore = int.tryParse(scoreSegments[1]) != null;

      if (moveWithScore) {
        final step = move.substring(5);
        if (Move.invalidateEngineStep(step)) {
          return EngineResponse('move', value: Move.fromEngineStep(step));
        }
      } else {
        if (byUser) {
          response = await ChessDB.requestComputeBackground(fen);
          print('ChessDB.requestComputeBackground: $response');
        }
        return Future<EngineResponse>.delayed(
          Duration(seconds: 2),
          () => search(phase, byUser: false),
        );
      }
    }
    return EngineResponse('unknown-error');
  }

  static Future<EngineResponse> analysis(Phase phase) async {
    final fen = phase.toFen();
    var response = await ChessDB.query(fen);

    if (response == null) {
      return EngineResponse('network-error');
    }

    if (response.startsWith('move:')) {
      final items = AnalysisFetcher.fetch(response);
      if (items.isEmpty) return EngineResponse('no-result');
      return EngineResponse('analysis', value: items);
    }

    print('ChessDB.query: $response');
    return EngineResponse('unknown-error');
  }
}
