import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../tickets/presentation/screens/ticket_list_screen.dart';

class RegistrationSuccessScreen extends StatelessWidget {
  final String userName;
  final String userCi;

  const RegistrationSuccessScreen({
    super.key,
    this.userName = 'Juan Pérez',
    this.userCi = '12345678 SC',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),

              // Icono de Éxito
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  color: AppTheme.secondary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 60,
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                '¡Registro Completado!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Tu dispositivo se ha vinculado correctamente a tu cuenta de salud.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),

              const SizedBox(height: 32),

              // Tarjeta de Identidad Digital Vinculada
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const Icon(Icons.badge_outlined, size: 40, color: AppTheme.primary),
                      const SizedBox(height: 12),
                      Text(
                        userName,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'CI: $userCi',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const Divider(height: 24),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.phonelink_lock_rounded, size: 16, color: AppTheme.secondary),
                          SizedBox(width: 8),
                          Text(
                            'Dispositivo Registrado Exitosamente',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.secondary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(),

              // Botón de Inicio
              ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const TicketListScreen()),
                    (route) => false,
                  );
                },
                child: const Text('Ir a Mis Fichas'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}