// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scan_receipt_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ScanReceiptViewModel)
final scanReceiptViewModelProvider = ScanReceiptViewModelProvider._();

final class ScanReceiptViewModelProvider
    extends $AsyncNotifierProvider<ScanReceiptViewModel, ScanResultModel?> {
  ScanReceiptViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'scanReceiptViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$scanReceiptViewModelHash();

  @$internal
  @override
  ScanReceiptViewModel create() => ScanReceiptViewModel();
}

String _$scanReceiptViewModelHash() =>
    r'4533c0f73b6bc5673f9a1d5a01a15e31f72be833';

abstract class _$ScanReceiptViewModel extends $AsyncNotifier<ScanResultModel?> {
  FutureOr<ScanResultModel?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<ScanResultModel?>, ScanResultModel?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ScanResultModel?>, ScanResultModel?>,
              AsyncValue<ScanResultModel?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
