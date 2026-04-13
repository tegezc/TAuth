// file: lib/t_auth.dart
library t_auth;

// Export Core
export 'src/core/error/failures.dart';
export 'src/core/usecases/usecase.dart';

// Export Domain
export 'src/domain/entities/auth_user.dart';
export 'src/domain/usecases/login_with_email.dart';
export 'src/domain/usecases/login_with_google.dart'; // <-- EXPORT BARU
export 'src/domain/usecases/logout.dart';
export 'src/domain/usecases/observe_auth_state.dart';