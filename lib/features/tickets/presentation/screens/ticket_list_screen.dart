import 'package:flutter/material.dart';
import 'request_ticket_screen.dart';
import 'profile_screen.dart'; // <-- IMPORTACIÓN AÑADIDA

class TicketListScreen extends StatefulWidget {
  const TicketListScreen({super.key});

  @override
  State<TicketListScreen> createState() => _TicketListScreenState();
}

class _TicketListScreenState extends State<TicketListScreen> {
  final bool _hasActiveSanction = false;
  final String _sanctionUntil = "29/09/2026 10:30 AM";

  final List<Map<String, dynamic>> _activeTickets = [
    {
      'id': 1,
      'specialty': 'Medicina General',
      'ticketNumber': 14,
      'shift': 'MAÑANA',
      'time': 'Hoy, 08:30 AM',
      'room': 'Consultorio 04',
      'peopleAhead': 3,
      'alertTurnsBefore': 3, // 3 turnos por defecto (0 = desactivado)
    },
  ];

  void _showRequestTicketDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => RequestTicketModal(
        activeTickets: _activeTickets,
        onTicketCreated: (newTicket) {
          setState(() {
            _activeTickets.add(newTicket);
          });
        },
      ),
    );
  }

  // Diálogo para ajustar o quitar alerta (Botones con altura y tamaño idénticos)
  void _showAdjustAlertDialog(Map<String, dynamic> ticket) {
    int selectedTurns = ticket['alertTurnsBefore'] ?? 3;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),
              titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              actionsPadding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0F2FE),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.notifications_active_rounded,
                      color: Color(0xFF0284C7),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Ajustar Alerta',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '¿Con cuántos turnos de anticipación deseas recibir la notificación?',
                    style: TextStyle(fontSize: 13, color: Color(0xFF64748B), height: 1.3),
                  ),
                  const SizedBox(height: 16),

                  // Lista de opciones
                  ...[
                    {'turns': 5, 'label': '5 turnos previos'},
                    {'turns': 3, 'label': '3 turnos previos'},
                    {'turns': 2, 'label': '2 turnos previos'},
                    {'turns': 0, 'label': 'Sin notificación (Desactivar)'},
                  ].map((option) {
                    final int turns = option['turns'] as int;
                    final String label = option['label'] as String;
                    final bool isSelected = selectedTurns == turns;
                    final bool isDisableOption = turns == 0;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: InkWell(
                        onTap: () {
                          setDialogState(() {
                            if (isSelected && !isDisableOption) {
                              selectedTurns = 0;
                            } else {
                              selectedTurns = turns;
                            }
                          });
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? (isDisableOption
                                    ? const Color(0xFFFEF2F2)
                                    : const Color(0xFFE0F2FE))
                                : const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? (isDisableOption
                                      ? const Color(0xFFEF4444)
                                      : const Color(0xFF0284C7))
                                  : const Color(0xFFE2E8F0),
                              width: isSelected ? 1.8 : 1.0,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                isSelected
                                    ? Icons.radio_button_checked_rounded
                                    : Icons.radio_button_off_rounded,
                                color: isSelected
                                    ? (isDisableOption
                                        ? const Color(0xFFEF4444)
                                        : const Color(0xFF0284C7))
                                    : const Color(0xFF94A3B8),
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  label,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: isSelected
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                    color: isSelected
                                        ? (isDisableOption
                                            ? const Color(0xFF991B1B)
                                            : const Color(0xFF0369A1))
                                        : const Color(0xFF334155),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),

              // Botones con dimensiones e iguales
              actions: [
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(dialogContext),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size.fromHeight(44),
                            maximumSize: const Size.fromHeight(44),
                            padding: EdgeInsets.zero,
                            side: const BorderSide(color: Color(0xFFCBD5E1), width: 1.2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Cancelar',
                            style: TextStyle(
                              color: Color(0xFF64748B),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              ticket['alertTurnsBefore'] = selectedTurns;
                            });
                            Navigator.pop(dialogContext);

                            final bool disabled = selectedTurns == 0;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  disabled
                                      ? 'Notificación desactivada para esta ficha.'
                                      : 'Alerta actualizada: te avisaremos $selectedTurns turnos antes.',
                                ),
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: disabled
                                    ? const Color(0xFF64748B)
                                    : const Color(0xFF0284C7),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(44),
                            maximumSize: const Size.fromHeight(44),
                            padding: EdgeInsets.zero,
                            backgroundColor: const Color(0xFF0284C7),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Guardar',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF0F172A),
                Color(0xFF1E293B),
              ],
            ),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Color(0x1A000000),
                blurRadius: 16,
                offset: Offset(0, 8),
              )
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
              child: Row(
                children: [
                  // --- AVATAR CONVERTIDO EN BOTÓN INTERACTIVO ---
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProfileScreen(),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(24),
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFF38BDF8), width: 1.5),
                        ),
                        child: const CircleAvatar(
                          radius: 20,
                          backgroundColor: Color(0xFF334155),
                          child: Icon(Icons.person_rounded, color: Colors.white, size: 22),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Text(
                      'Mis Fichas Médicas',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.notifications_outlined, color: Colors.white, size: 22),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_hasActiveSanction) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF2F2),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFFCA5A5)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline_rounded, color: Color(0xFFDC2626), size: 28),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Cuenta Restringida',
                            style: TextStyle(
                              color: Color(0xFF991B1B),
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Bloqueado por inasistencia hasta $_sanctionUntil.',
                            style: const TextStyle(color: Color(0xFFB91C1C), fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _activeTickets.length > 1 ? 'Fichas Activas' : 'Ficha Activa',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F172A),
                  ),
                ),
                if (_activeTickets.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0F2FE),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${_activeTickets.length} Activa(s)',
                      style: const TextStyle(
                        color: Color(0xFF0369A1),
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 14),

            if (_activeTickets.isNotEmpty)
              Column(
                children: _activeTickets.map((ticket) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: _buildActiveTicketCard(ticket),
                  );
                }).toList(),
              )
            else
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.confirmation_number_outlined, color: Color(0xFF94A3B8), size: 40),
                    SizedBox(height: 8),
                    Text(
                      'No tienes reservas activas',
                      style: TextStyle(color: Color(0xFF475569), fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Solicita un nuevo turno presionando el botón inferior',
                      style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 16),

            const Text(
              'Historial Reciente',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 14),

            _buildHistoryCard(
              specialty: 'Pediatría',
              date: '10 Sep 2026',
              doctor: 'Dra. María Ugarte',
              status: 'Atendido',
              statusBg: const Color(0xFFF0FDF4),
              statusColor: const Color(0xFF15803D),
            ),
            const SizedBox(height: 10),
            _buildHistoryCard(
              specialty: 'Odontología',
              date: '28 Ago 2026',
              doctor: 'Dr. Lucas Silva',
              status: 'Atendido',
              statusBg: const Color(0xFFF0FDF4),
              statusColor: const Color(0xFF15803D),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: _hasActiveSanction ? null : _showRequestTicketDialog,
        backgroundColor: _hasActiveSanction ? const Color(0xFF94A3B8) : const Color(0xFF0284C7),
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        icon: const Icon(Icons.add_rounded, color: Colors.white, size: 22),
        label: const Text(
          'Solicitar Ficha',
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _buildActiveTicketCard(Map<String, dynamic> ticket) {
    final int turnsAlert = ticket['alertTurnsBefore'] ?? 0;
    final bool isAlertActive = turnsAlert > 0;

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0284C7),
            Color(0xFF0369A1),
          ],
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x290284C7),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      ticket['shift'] == 'MAÑANA'
                          ? Icons.wb_sunny_rounded
                          : Icons.nights_stay_rounded,
                      color: Colors.amber[300],
                      size: 15,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'TURNO ${ticket['shift']}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),

              // Botón "Ajustar Alerta" más grande y prominente
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _showAdjustAlertDialog(ticket),
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.35),
                        width: 1.2,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isAlertActive
                              ? Icons.notifications_active_rounded
                              : Icons.notifications_off_rounded,
                          color: isAlertActive
                              ? const Color(0xFFBAE6FD)
                              : Colors.white60,
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          isAlertActive
                              ? 'Ajustar Alerta ($turnsAlert)'
                              : 'Sin Alerta',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                'N° ${ticket['ticketNumber']}',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  ticket['specialty'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(height: 1, color: Colors.white.withOpacity(0.15)),
          const SizedBox(height: 14),
          Row(
            children: [
              Row(
                children: [
                  Icon(Icons.schedule_rounded, color: Colors.white.withOpacity(0.8), size: 16),
                  const SizedBox(width: 6),
                  Text(
                    ticket['time'],
                    style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const Spacer(),
              Row(
                children: [
                  Icon(Icons.meeting_room_outlined, color: Colors.white.withOpacity(0.8), size: 16),
                  const SizedBox(width: 6),
                  Text(
                    ticket['room'],
                    style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A).withOpacity(0.25),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.people_alt_outlined, color: Color(0xFF7DD3FC), size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'En espera: ${ticket['peopleAhead']} pacientes',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    setState(() {
                      _activeTickets.removeWhere((item) => item['id'] == ticket['id']);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Ficha de ${ticket['specialty']} cancelada.'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEF4444).withOpacity(0.35),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFFCA5A5).withOpacity(0.5), width: 1.2),
                    ),
                    child: const Text(
                      'Cancelar',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryCard({
    required String specialty,
    required String date,
    required String doctor,
    required String status,
    required Color statusBg,
    required Color statusColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.medical_services_outlined, color: Color(0xFF0284C7), size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  specialty,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)),
                ),
                const SizedBox(height: 2),
                Text(
                  '$doctor • $date',
                  style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(8)),
            child: Text(
              status,
              style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}