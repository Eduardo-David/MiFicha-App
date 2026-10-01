import 'package:flutter/material.dart';

class RequestTicketModal extends StatefulWidget {
  final Function(Map<String, dynamic>) onTicketCreated;
  final List<Map<String, dynamic>> activeTickets;

  const RequestTicketModal({
    super.key,
    required onTicketCreated,
    required activeTickets,
  })  : onTicketCreated = onTicketCreated,
        activeTickets = activeTickets;

  @override
  State<RequestTicketModal> createState() => _RequestTicketModalState();
}

class _RequestTicketModalState extends State<RequestTicketModal> {
  String selectedSpecialty = 'Medicina General';
  String selectedShift = 'Mañana';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        top: 24,
        left: 24,
        right: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 28,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Indagador superior del modal
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Solicitar Ficha Médica',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F172A),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded, color: Color(0xFF64748B)),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          ),
          const SizedBox(height: 16),

          // Selección de Especialidad
          const Text('Especialidad', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF334155))),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: selectedSpecialty,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF8FAFC),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
            ),
            items: const [
              DropdownMenuItem(value: 'Medicina General', child: Text('Medicina General')),
              DropdownMenuItem(value: 'Pediatría', child: Text('Pediatría')),
              DropdownMenuItem(value: 'Odontología', child: Text('Odontología')),
            ],
            onChanged: (val) {
              if (val != null) {
                setState(() => selectedSpecialty = val);
              }
            },
          ),

          const SizedBox(height: 18),

          // Selección de Jornada
          const Text('Jornada del Día', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF334155))),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ChoiceChip(
                  showCheckmark: false,
                  label: const Center(child: Text('Turno Mañana')),
                  selected: selectedShift == 'Mañana',
                  selectedColor: const Color(0xFF0284C7),
                  backgroundColor: const Color(0xFFF1F5F9),
                  labelStyle: TextStyle(
                    color: selectedShift == 'Mañana' ? Colors.white : const Color(0xFF475569),
                    fontWeight: FontWeight.w600,
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  onSelected: (selected) {
                    if (selected) setState(() => selectedShift = 'Mañana');
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ChoiceChip(
                  showCheckmark: false,
                  label: const Center(child: Text('Turno Tarde')),
                  selected: selectedShift == 'Tarde',
                  selectedColor: const Color(0xFF0284C7),
                  backgroundColor: const Color(0xFFF1F5F9),
                  labelStyle: TextStyle(
                    color: selectedShift == 'Tarde' ? Colors.white : const Color(0xFF475569),
                    fontWeight: FontWeight.w600,
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  onSelected: (selected) {
                    if (selected) setState(() => selectedShift = 'Tarde');
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Botón Confirmar Reserva
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F766E),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () {
                bool hasDuplicateSpecialty = widget.activeTickets.any((ticket) =>
                    ticket['specialty'].toString().toLowerCase() ==
                    selectedSpecialty.toLowerCase());

                if (hasDuplicateSpecialty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Ya posees una reserva activa para $selectedSpecialty.',
                      ),
                      backgroundColor: const Color(0xFFB45309),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  );
                  return;
                }

                final newTicket = {
                  'id': DateTime.now().millisecondsSinceEpoch,
                  'specialty': selectedSpecialty,
                  'ticketNumber': 22,
                  'shift': selectedShift.toUpperCase(),
                  'time': selectedShift == 'Mañana' ? 'Hoy, 10:15 AM' : 'Hoy, 03:00 PM',
                  'room': selectedSpecialty == 'Pediatría' ? 'Consultorio 02' : 'Consultorio 05',
                  'doctor': selectedSpecialty == 'Pediatría' ? 'Dra. María Ugarte' : 'Dr. Carlos Mendoza',
                  'peopleAhead': 5,
                };

                widget.onTicketCreated(newTicket);
                Navigator.of(context).pop();

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Ficha para $selectedSpecialty confirmada.'),
                    backgroundColor: const Color(0xFF0F766E),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                );
              },
              child: const Text(
                'Confirmar Reserva',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}