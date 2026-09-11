class Verset {
  final int numero;         // numéro du verset dans sa sourate
  final int sourateNumero;  // à quelle sourate ce verset appartient
  final String texte;       // texte arabe

  const Verset({
    required this.numero,
    required this.sourateNumero,
    required this.texte,
  });
}