import 'package:oara/core/models/lesson.dart';

class LessonsData {
  static final List<Lesson> maths = [
    Lesson(
      subject: 'Maths',
      title: 'Les Fractions',
      pages: [
        LessonPage(
          title: 'Qu\'est-ce qu\'une fraction ?',
          content: 'Une fraction représente une partie d\'un tout. '
              'Elle est composée de deux nombres séparés par une barre.',
          keyPoints: [
            '🔢 Le nombre du HAUT = numérateur',
            '🔢 Le nombre du BAS = dénominateur',
            '📌 Exemple : 1/2 = une moitié',
          ],
        ),
        LessonPage(
          title: 'Visualiser 1/2',
          content: 'Si tu coupes une pizza en 2 parts égales '
              'et que tu en prends 1, tu as mangé 1/2 de la pizza.',
          keyPoints: [
            '🍕 Pizza entière = 1',
            '🍕 Une part sur deux = 1/2',
            '✅ 1/2 = 0.5 = 50%',
          ],
        ),
        LessonPage(
          title: 'Visualiser 3/4',
          content: 'Si tu coupes un gâteau en 4 parts égales '
              'et que tu en prends 3, tu as 3/4 du gâteau.',
          keyPoints: [
            '🎂 Gâteau entier = 1',
            '🎂 Trois parts sur quatre = 3/4',
            '✅ 3/4 = 0.75 = 75%',
          ],
        ),
        LessonPage(
          title: 'Additionner des fractions',
          content: 'Pour additionner deux fractions avec le même dénominateur, '
              'on additionne seulement les numérateurs.',
          keyPoints: [
            '➕ 1/4 + 2/4 = 3/4',
            '➕ 1/3 + 1/3 = 2/3',
            '⚠️ Les dénominateurs restent pareils',
          ],
        ),
        LessonPage(
          title: 'Exercice',
          content: 'Résous ces exercices dans ton cahier. '
              'Prends le temps de bien réfléchir !',
          keyPoints: [
            '✏️ 1/5 + 2/5 = ?',
            '✏️ 2/6 + 3/6 = ?',
            '✏️ 1/4 + 1/4 = ?',
          ],
        ),
      ],
    ),
  ];
}
