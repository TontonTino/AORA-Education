enum AppProfile {
  voyant,
  nonVoyant,
  sourd,
  muet,
}

extension AppProfileExtension on AppProfile {
  String get label {
    switch (this) {
      case AppProfile.voyant:    return 'Voyant';
      case AppProfile.nonVoyant: return 'Non-voyant';
      case AppProfile.sourd:     return 'Sourd';
      case AppProfile.muet:      return 'Muet';
    }
  }

  String get description {
    switch (this) {
      case AppProfile.voyant:    return 'Interface standard avec tuteur IA';
      case AppProfile.nonVoyant: return 'Navigation vocale, zéro texte requis';
      case AppProfile.sourd:     return 'Visuel riche, avatars LSB, sous-titres';
      case AppProfile.muet:      return 'Reconnaissance gestuelle et icônes';
    }
  }
}