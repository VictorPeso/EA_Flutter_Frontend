import 'organization.dart';

enum TaskStatus {
  toDo,
  inProgress,
  done,
}

class Task {
  final String id;
  final String titulo;
  final DateTime fechaInicio;
  final DateTime fechaFin;
  final List<OrganizationUser> usuarios;
  final TaskStatus status;

  Task({
    required this.id,
    required this.titulo,
    required this.fechaInicio,
    required this.fechaFin,
    required this.usuarios,
    this.status = TaskStatus.toDo,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    final String id = (json['_id'] ?? json['id'] ?? '').toString();
    final String titulo =
        (json['titulo'] ?? json['title'] ?? 'Sin título').toString();

    return Task(
      id: id,
      titulo: titulo,
      fechaInicio: _parseDate(json['fechaInicio'] ?? json['fecha_inicio']),
      fechaFin: _parseDate(json['fechaFin'] ?? json['fecha_fin']),
      usuarios: (json['usuarios'] as List<dynamic>?)
              ?.map((dynamic u) => OrganizationUser.fromJson(u))
              .toList() ??
          [],
      status: _parseStatus(json['status'] ?? json['estado']),
    );
  }

  Task copyWith({
    String? id,
    String? titulo,
    DateTime? fechaInicio,
    DateTime? fechaFin,
    List<OrganizationUser>? usuarios,
    TaskStatus? status,
  }) {
    return Task(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      fechaInicio: fechaInicio ?? this.fechaInicio,
      fechaFin: fechaFin ?? this.fechaFin,
      usuarios: usuarios ?? this.usuarios,
      status: status ?? this.status,
    );
  }

  static DateTime _parseDate(dynamic value) {
    if (value is String) {
      final DateTime? parsed = DateTime.tryParse(value);
      if (parsed != null) {
        return parsed;
      }
    }
    throw FormatException('Fecha inválida en Task: $value');
  }

  static TaskStatus _parseStatus(dynamic value) {
    if (value == null) {
      return TaskStatus.toDo;
    }

    if (value is String) {
      switch (value.toLowerCase()) {
        case 'to_do':
        case 'todo':
          return TaskStatus.toDo;
        case 'in_progress':
        case 'inprogress':
          return TaskStatus.inProgress;
        case 'done':
          return TaskStatus.done;
        default:
          return TaskStatus.toDo;
      }
    }
    return TaskStatus.toDo;
  }
}