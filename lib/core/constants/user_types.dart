class UserTypes {
  static const String client = 'client';
  static const String barber = 'barber';
  static const String owner = 'owner'; // Novo tipo para dono da barbearia

  // Verificar se é dono da barbearia
  static bool isOwner(String userType) => userType == owner;

  // Verificar se é barbeiro (inclui donos)
  static bool isBarber(String userType) =>
      userType == barber || userType == owner;

  // Verificar se é cliente
  static bool isClient(String userType) => userType == client;

  // Obter nome amigável do tipo
  static String getDisplayName(String userType) {
    switch (userType) {
      case client:
        return 'Cliente';
      case barber:
        return 'Barbeiro';
      case owner:
        return 'Dono';
      default:
        return 'Usuário';
    }
  }
}
