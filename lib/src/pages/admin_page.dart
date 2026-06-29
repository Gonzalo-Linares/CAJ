import 'package:flutter/material.dart';

import '../widgets/main_layout.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Administrador',
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const SizedBox(height: 8.0),
          _AdminHeader(),
          const SizedBox(height: 24.0),
          Text(
            'Menú',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12.0),
          _AdminMenuItem(
            icono: Icons.payments_outlined,
            titulo: 'Cobranzas',
            onTap: () => Navigator.pushNamed(context, 'admin-cobranzas'),
          ),
          _AdminMenuItem(
            icono: Icons.group_outlined,
            titulo: 'Socios',
            onTap: () => Navigator.pushNamed(context, 'socios'),
          ),
          _AdminMenuItem(
            icono: Icons.settings_outlined,
            titulo: 'Configuración',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Sección disponible próximamente.'),
                ),
              );
            },
          ),
          _AdminMenuItem(
            icono: Icons.bar_chart_outlined,
            titulo: 'Reportes',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Sección disponible próximamente.'),
                ),
              );
            },
          ),
          _AdminMenuItem(
            icono: Icons.notifications_none_outlined,
            titulo: 'Notificaciones',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Sección disponible próximamente.'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _AdminHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final colores = tema.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18.0),
      decoration: BoxDecoration(
        color: colores.primary,
        borderRadius: BorderRadius.circular(22.0),
      ),
      child: Row(
        children: [
          Icon(
            Icons.admin_panel_settings_outlined,
            color: colores.onPrimary,
            size: 34.0,
          ),
          const SizedBox(width: 14.0),
          Expanded(
            child: Text(
              'Panel de administración',
              style: tema.textTheme.titleMedium?.copyWith(
                color: colores.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AdminMenuItem extends StatelessWidget {
  final IconData icono;
  final String titulo;
  final VoidCallback onTap;

  const _AdminMenuItem({
    required this.icono,
    required this.titulo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final colores = tema.colorScheme;

    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 4.0,
            vertical: 6.0,
          ),
          leading: Icon(
            icono,
            size: 28.0,
            color: colores.onSurface,
          ),
          title: Text(
            titulo,
            style: tema.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: Icon(
            Icons.chevron_right,
            color: colores.primary,
            size: 30.0,
          ),
          onTap: onTap,
        ),
        Divider(
          height: 1.0,
          color: colores.outline.withValues(alpha: 0.35),
        ),
      ],
    );
  }
}