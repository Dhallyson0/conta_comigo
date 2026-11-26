String formatarValor(double valor) {
  return 'R\$ ${formatarNumero(valor)}';
}

String formatarNumero(double valor) {
  return valor.toStringAsFixed(2).replaceAll('.', ',');
}

String formatarData(dynamic data) {
  if (data == null) {
    return '00/00/0000';
  }

  final texto = data.toString();

  try {
    final partes = texto.split('-');

    if (partes.length >= 3) {
      return '${partes[2].substring(0, 2)}/'
          '${partes[1]}/'
          '${partes[0]}';
    }
  } catch (_) {}

  return texto;
}
