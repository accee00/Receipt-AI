import 'package:frontend/features/receipt/model/dashboard_model.dart';
import 'package:frontend/features/receipt/repository/expense_repo.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dashboard_view_model.g.dart';

@Riverpod(keepAlive: true)
class DashboardViewModel extends _$DashboardViewModel {
  @override
  FutureOr<DashboardModel> build({int? month, int? year}) async {
    return _fetchData(month: month, year: year);
  }

  Future<DashboardModel> _fetchData({int? month, int? year}) async {
    final expenseRepo = ref.read(expenseRepoProvider);

    final now = DateTime.now();
    final targetMonth = month ?? now.month;
    final targetYear = year ?? now.year;

    final startDate = DateTime(targetYear, targetMonth, 1);
    final endDate = DateTime(targetYear, targetMonth + 1, 0, 23, 59, 59);

    final response = await expenseRepo.getDashboardData(
      startDate: startDate,
      endDate: endDate,
    );

    return response.fold((failure) => throw failure.message, (data) => data);
  }

  Future<void> refresh({int? month, int? year}) async {
    state = const AsyncValue.loading();
    try {
      final data = await _fetchData(month: month, year: year);
      state = AsyncValue.data(data);
    } catch (e, stack) {
      state = AsyncValue.error(e.toString(), stack);
    }
  }
}
