import 'services.dart';

/// Static global state. Immutable services that do not care about build context.
class Global {
  static final String title = 'Fireship';

  // Data Models
  static final Map models = {
    User: (data) => User.fromMap(data),
    Cafeteria: (data) => Cafeteria.fromMap(data),
  };
}
