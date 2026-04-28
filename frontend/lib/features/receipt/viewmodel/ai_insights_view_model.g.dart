// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_insights_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AiInsightsViewModel)
final aiInsightsViewModelProvider = AiInsightsViewModelFamily._();

final class AiInsightsViewModelProvider
    extends $AsyncNotifierProvider<AiInsightsViewModel, String> {
  AiInsightsViewModelProvider._({
    required AiInsightsViewModelFamily super.from,
    required ({int month, int year}) super.argument,
  }) : super(
         retry: null,
         name: r'aiInsightsViewModelProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$aiInsightsViewModelHash();

  @override
  String toString() {
    return r'aiInsightsViewModelProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  AiInsightsViewModel create() => AiInsightsViewModel();

  @override
  bool operator ==(Object other) {
    return other is AiInsightsViewModelProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$aiInsightsViewModelHash() =>
    r'4fd09692df9f388904f288fecb4b41653120e9e3';

final class AiInsightsViewModelFamily extends $Family
    with
        $ClassFamilyOverride<
          AiInsightsViewModel,
          AsyncValue<String>,
          String,
          FutureOr<String>,
          ({int month, int year})
        > {
  AiInsightsViewModelFamily._()
    : super(
        retry: null,
        name: r'aiInsightsViewModelProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  AiInsightsViewModelProvider call({required int month, required int year}) =>
      AiInsightsViewModelProvider._(
        argument: (month: month, year: year),
        from: this,
      );

  @override
  String toString() => r'aiInsightsViewModelProvider';
}

abstract class _$AiInsightsViewModel extends $AsyncNotifier<String> {
  late final _$args = ref.$arg as ({int month, int year});
  int get month => _$args.month;
  int get year => _$args.year;

  FutureOr<String> build({required int month, required int year});
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<String>, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<String>, String>,
              AsyncValue<String>,
              Object?,
              Object?
            >;
    element.handleCreate(
      ref,
      () => build(month: _$args.month, year: _$args.year),
    );
  }
}
