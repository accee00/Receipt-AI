import 'package:frontend/features/receipt/repository/expense_repo.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ai_insights_view_model.g.dart';

@Riverpod(keepAlive: true)
class AiInsightsViewModel extends _$AiInsightsViewModel {
  @override
  FutureOr<String> build({required int month, required int year}) async {
    final expenseRepo = ref.read(expenseRepoProvider);
    
    final response = await expenseRepo.getAiInsights(month: month, year: year);
    
    return response.fold(
      (failure) => throw failure.message,
      (insights) => insights,
    );
  }
}
