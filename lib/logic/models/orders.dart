class OrdersState {
  bool loading;
  bool noMore;
  List orders;
  bool loaded;
  int page;
  String? filterStatus;
  String? filterMethod;
  bool reloading;
  OrdersState({
    this.loading = false,
    this.noMore = false,
    this.orders = const [],
    this.loaded = false,
    this.page = 1,
    this.filterStatus,
    this.filterMethod,
    this.reloading = false,
  });

  OrdersState copyWith({
    bool? loading,
    bool? noMore,
    List? orders,
    bool? loaded,
    int? page,
    String? filterStatus,
    String? filterMethod,
    bool? reloading,
  }) {
    return OrdersState(
      loading: loading ?? this.loading,
      noMore: noMore ?? this.noMore,
      orders: orders ?? this.orders,
      loaded: loaded ?? this.loaded,
      page: page ?? this.page,
      filterStatus: filterStatus ?? this.filterStatus,
      filterMethod: filterMethod ?? this.filterMethod,
      reloading: reloading ?? this.reloading,
    );
  }
}

enum OrderStatus {
  rejected('r', 'Rejected'),
  completed('f', 'Completed'),
  waitingForReceipt('w', 'Waiting for receipt'),
  delivering('d', 'Delivering'),
  preparing('c', 'Preparing'),
  waiting('q', 'Waiting'),
  canceled('t', 'Canceled');

  final String name;
  final String code;

  const OrderStatus(this.code, this.name);
  List<OrderStatus> nextStatus(String payMethod) {
    late List<OrderStatus> list;
    if (this == OrderStatus.waiting) {
      list = [OrderStatus.preparing, OrderStatus.rejected];
    } else if (this == OrderStatus.preparing) {
      if (payMethod == PayMethod.card.code ||
          payMethod == PayMethod.cash.code) {
        list = [OrderStatus.delivering];
      } else if (payMethod == PayMethod.recieveFromStore.code) {
        list = [OrderStatus.waitingForReceipt];
      }
    } else if (this == OrderStatus.delivering ||
        this == OrderStatus.waitingForReceipt) {
      list = [OrderStatus.completed];
    } else if (this == OrderStatus.rejected ||
        this == OrderStatus.canceled ||
        this == OrderStatus.completed) {
      list = [];
    }
    return list;
  }
}

enum PayMethod {
  cash('ca', 'Cash'),
  card('cc', 'Card'),
  recieveFromStore('rs', 'Recieve From Store');

  final String name;
  final String code;

  const PayMethod(this.code, this.name);
}
