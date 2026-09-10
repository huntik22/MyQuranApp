class Sourate {
  final int numero;
  final String nom;          // ex: "Al-Fatiha"
  final String nomArabe;     // ex: "الفاتحة"
  final String traduction;   // ex: "Prologue"
  final int nombreVersets;

  const Sourate({
    required this.numero,
    required this.nom,
    required this.nomArabe,
    required this.traduction,
    required this.nombreVersets,
  });

  factory Sourate.fromJson(Map<String, dynamic> json) {
    return Sourate(
      numero: json['numero'],
      nom: json['nom'],
      nomArabe: json['nom_arabe'],
      traduction: json['traduction'],
      nombreVersets: json['nombre_versets'],
    );
  }
}