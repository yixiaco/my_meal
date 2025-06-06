/// 表示回调
typedef TCallback = void Function();

/// 代表结果的提供者
typedef TSupplier<T> = T Function();

/// 表示接受单个输入参数且不返回结果的操作
typedef TConsumer<T> = void Function(T t);

/// 表示接受一个参数并产生结果的函数
typedef TFunction<T, R> = R Function(T t);

/// 表示接受两个输入参数且不返回结果的操作
typedef TBiConsumer<T, U> = void Function(T t, U u);

/// 表示接受两个参数并产生结果的函数
typedef TBiFunction<T, U, R> = R Function(T t, U u);

/// 值回调
typedef TValueChange<T> = void Function(T value);
