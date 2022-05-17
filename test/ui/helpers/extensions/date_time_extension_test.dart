import 'package:test/test.dart';

import 'package:tab_news/ui/ui.dart';

void main() {
  test('Should show correct sentence for seconds', () {
    expect(DateTime.now().subtract(const Duration(seconds: 1)).timeAgo(), 'Agora');
    expect(DateTime.now().subtract(const Duration(seconds: 3)).timeAgo(), '3 segundos atrás');
    expect(DateTime.now().subtract(const Duration(seconds: 10)).timeAgo(), '10 segundos atrás');
    expect(DateTime.now().subtract(const Duration(seconds: 59)).timeAgo(), '59 segundos atrás');
  });

  test('Should show correct sentence for minutes', () {
    expect(DateTime.now().subtract(const Duration(minutes: 1)).timeAgo(), '1 minuto atrás');
    expect(DateTime.now().subtract(const Duration(minutes: 1)).timeAgo(numericDates: false), 'Um minuto atrás');
    expect(DateTime.now().subtract(const Duration(minutes: 3)).timeAgo(), '3 minutos atrás');
    expect(DateTime.now().subtract(const Duration(minutes: 10)).timeAgo(), '10 minutos atrás');
    expect(DateTime.now().subtract(const Duration(minutes: 59)).timeAgo(), '59 minutos atrás');
  });

  test('Should show correct sentence for hours', () {
    expect(DateTime.now().subtract(const Duration(hours: 1)).timeAgo(), '1 hora atrás');
    expect(DateTime.now().subtract(const Duration(hours: 1)).timeAgo(numericDates: false), 'Uma hora atrás');
    expect(DateTime.now().subtract(const Duration(hours: 3)).timeAgo(), '3 horas atrás');
    expect(DateTime.now().subtract(const Duration(hours: 10)).timeAgo(), '10 horas atrás');
    expect(DateTime.now().subtract(const Duration(hours: 23, seconds: 59)).timeAgo(), '23 horas atrás');
  });

  test('Should show correct sentence for days', () {
    expect(DateTime.now().subtract(const Duration(days: 1)).timeAgo(), '1 dia atrás');
    expect(DateTime.now().subtract(const Duration(days: 1)).timeAgo(numericDates: false), 'Ontem');
    expect(DateTime.now().subtract(const Duration(days: 3)).timeAgo(), '3 dias atrás');
    expect(DateTime.now().subtract(const Duration(days: 6)).timeAgo(), '6 dias atrás');
    expect(DateTime.now().subtract(const Duration(days: 7)).timeAgo(), '1 semana atrás');
    expect(DateTime.now().subtract(const Duration(days: 8)).timeAgo(numericDates: false), 'Última semana');
    expect(DateTime.now().subtract(const Duration(days: 14)).timeAgo(numericDates: false), 'Última semana');

    final date = DateTime.now().subtract(const Duration(days: 15));
    expect(date.timeAgo(), '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}');
  });
}
