import 'package:flutter/foundation.dart';
import 'package:freshflow_app/features/report/domain/report_item.dart';

class ReportRepository extends ChangeNotifier {
  final List<ReportItem> _ongoing = [];
  final List<ReportItem> _completed = [];

  List<ReportItem> get ongoing => List.unmodifiable(_ongoing);
  List<ReportItem> get completed => List.unmodifiable(_completed);

  void addOngoing(ReportItem item) {
    _ongoing.insert(0, item);
    notifyListeners();
  }

  void addCompleted(ReportItem item) {
    _completed.insert(0, item.markCompleted());
    notifyListeners();
  }

  void markCompleted(int index) {
    if (index < 0 || index >= _ongoing.length) return;
    final item = _ongoing.removeAt(index).markCompleted();
    _completed.insert(0, item);
    notifyListeners();
  }

  void markCompletedByItem(ReportItem item) {
    final idx = _ongoing.indexOf(item);
    if (idx == -1) return;
    markCompleted(idx);
  }

  void addReviewByItem(ReportItem item, {required int rating, required String review}) {
    final idxOngoing = _ongoing.indexOf(item);
    if (idxOngoing != -1) {
      _ongoing[idxOngoing] = _ongoing[idxOngoing].copyWith(rating: rating, review: review);
      notifyListeners();
      return;
    }
    final idxCompleted = _completed.indexOf(item);
    if (idxCompleted != -1) {
      _completed[idxCompleted] = _completed[idxCompleted].copyWith(rating: rating, review: review);
      notifyListeners();
    }
  }
}
