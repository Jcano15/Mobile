import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';

class StatusScreen extends StatefulWidget {
  const StatusScreen({super.key});

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen>
    with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> _statuses = [];
  bool _isLoading = true;
  String? _errorMessage;

  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _loadStatuses();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _loadStatuses() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final token = await AuthService.getToken();
      if (token == null) {
        if (mounted) Navigator.pushReplacementNamed(context, '/login');
        return;
      }
      // Llamamos al servicio que trae los estados de la tabla user_status
      final statuses = await ApiService.getUserStatuses(token);
      setState(() {
        _statuses = statuses;
        _isLoading = false;
      });
      _animController.forward(from: 0);
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  Future<void> _showStatusDialog({Map<String, dynamic>? status}) async {
    final isEditing = status != null;
    final nameController = TextEditingController(
        text: isEditing ? status['User_status_name']?.toString() : '');
    final descController = TextEditingController(
        text: isEditing ? status['User_status_description']?.toString() : '');

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          isEditing ? 'Editar Estado' : 'Nuevo Estado',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              style: const TextStyle(color: Colors.white),
              decoration: _inputDecoration('Nombre del estado'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descController,
              style: const TextStyle(color: Colors.white),
              maxLines: 3,
              decoration: _inputDecoration('Descripción'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar', style: TextStyle(color: Color(0xFF9E9EBF))),
          ),
          ElevatedButton(
            onPressed: () async {
              final name = nameController.text.trim();
              final desc = descController.text.trim();
              if (name.isEmpty || desc.isEmpty) return;

              try {
                final token = await AuthService.getToken();
                if (token == null) return;

                if (isEditing) {
                  await ApiService.updateUserStatus(
                    token,
                    status['User_status_id'],
                    name,
                    desc,
                  );
                } else {
                  await ApiService.createUserStatus(token, name, desc);
                }

                if (mounted) {
                  Navigator.pop(context);
                  _loadStatuses();
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: $e'), backgroundColor: Colors.redAccent),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6C63FF),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(isEditing ? 'Actualizar' : 'Crear', style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(int id, String name) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Eliminar Estado', style: TextStyle(color: Colors.white)),
        content: Text('¿Estás seguro de que deseas eliminar el estado "$name"?',
            style: const TextStyle(color: Color(0xFF9E9EBF))),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar', style: TextStyle(color: Color(0xFF9E9EBF))),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                final token = await AuthService.getToken();
                if (token == null) return;
                await ApiService.deleteUserStatus(token, id);
                if (mounted) {
                  Navigator.pop(context);
                  _loadStatuses();
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: $e'), backgroundColor: Colors.redAccent),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text('Eliminar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Color(0xFF9E9EBF)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF4A4A6A)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF6C63FF)),
      ),
      filled: true,
      fillColor: const Color(0xFF0F0F1A),
    );
  }

  // Assign a color from palette based on index
  Color _colorForIndex(int index) {
    const colors = [
      Color(0xFF6C63FF),
      Color(0xFFE040FB),
      Color(0xFF00D2FF),
      Color(0xFF43E97B),
      Color(0xFFFF6B6B),
      Color(0xFFFFAD56),
    ];
    return colors[index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1A),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Custom app bar
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1A2E),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: const Color(0xFF6C63FF).withOpacity(0.2)),
                      ),
                      child: const Icon(Icons.arrow_back_ios_new_rounded,
                          color: Colors.white, size: 18),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Gestión de Estados',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'user_status table',
                          style: TextStyle(
                            color: Color(0xFF9E9EBF),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Add button
                  GestureDetector(
                    onTap: () => _showStatusDialog(),
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: const Color(0xFF6C63FF).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: const Color(0xFF6C63FF).withOpacity(0.3)),
                      ),
                      child: const Icon(Icons.add_rounded,
                          color: Color(0xFF6C63FF), size: 24),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Refresh button
                  GestureDetector(
                    onTap: _isLoading ? null : _loadStatuses,
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1A2E),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: const Color(0xFF9E9EBF).withOpacity(0.2)),
                      ),
                      child: const Icon(Icons.refresh_rounded,
                          color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Content
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(color: Color(0xFF6C63FF)),
                          SizedBox(height: 16),
                          Text(
                            'Cargando estados...',
                            style: TextStyle(color: Color(0xFF9E9EBF)),
                          ),
                        ],
                      ),
                    )
                  : _errorMessage != null
                      ? _buildError()
                      : _statuses.isEmpty
                          ? _buildEmpty()
                          : _buildList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(Icons.wifi_off_rounded,
                  color: Colors.redAccent, size: 40),
            ),
            const SizedBox(height: 20),
            const Text(
              'Error de conexión',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF9E9EBF), fontSize: 14),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadStatuses,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.inbox_outlined, color: Color(0xFF4A4A6A), size: 64),
          const SizedBox(height: 16),
          const Text(
            'Sin estados registrados',
            style: TextStyle(color: Color(0xFF9E9EBF), fontSize: 16),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _showStatusDialog(),
            icon: const Icon(Icons.add_rounded),
            label: const Text('Crear primer estado'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6C63FF),
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: _statuses.length,
      itemBuilder: (context, index) {
        final status = _statuses[index];
        final name = status['User_status_name']?.toString() ?? 'Sin nombre';
        final desc = status['User_status_description']?.toString() ?? 'Sin descripción';
        final updatedAt = status['updated_at']?.toString() ?? 'No disponible';
        final id = status['User_status_id'];
        final color = _colorForIndex(index);

        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: Duration(milliseconds: 300 + (index * 80)),
          curve: Curves.easeOut,
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, 20 * (1 - value)),
                child: child,
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A2E),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: color.withOpacity(0.2)),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.06),
                  blurRadius: 16,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          '#$id',
                          style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            desc,
                            style: const TextStyle(
                              color: Color(0xFF9E9EBF),
                              fontSize: 13,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_rounded, color: Color(0xFF6C63FF), size: 20),
                      onPressed: () => _showStatusDialog(status: status),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 20),
                      onPressed: () => _confirmDelete(id as int, name),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(color: Colors.white10, height: 1),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.update_rounded, color: Color(0xFF4A4A6A), size: 16),
                    const SizedBox(width: 8),
                    Text(
                      'Actualizado: $updatedAt',
                      style: const TextStyle(
                        color: Color(0xFF4A4A6A),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
