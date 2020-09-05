import 'services.dart';

/// Static global state. Immutable services that do not care about build context.
class Global {
  // Data Models
  static final Map models = {
    User: (data) => User.fromMap(data),
    Cafeteria: (data) => Cafeteria.fromMap(data),
    MealDoc: (data) => MealDoc.fromMap(data)
  };
}
