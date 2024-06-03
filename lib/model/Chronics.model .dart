class MyOption {
  final int id;
  late final String name;

  MyOption({required this.id, required this.name});
}

List<MyOption> chronicDiseases = [
// Σακχαρώδης διαβήτης (τύπου 1 και 2)
  MyOption(id: 1, name: 'Diabetes mellitus'),

// Υπέρταση (υψηλή αρτηριακή πίεση)
  MyOption(id: 2, name: 'Hypertension '),

// Καρδιαγγειακά νοσήματα (καρδιακές παθήσεις, συμπεριλαμβανομένης της στεφανιαίας νόσου, της καρδιακής ανεπάρκειας και των αρρυθμιών)
  MyOption(id: 3, name: 'Cardiovascular diseases'),

// Χρόνια αποφρακτική πνευμονοπάθεια (ΧΑΠ)
  MyOption(id: 4, name: 'Chronic obstructive pulmonary disease(COPD)'),

// Άσθμα
  MyOption(id: 5, name: 'Asthma'),

// Χρόνια νεφρική νόσος
  MyOption(id: 6, name: 'Chronic kidney disease'),

// Χρόνια ηπατική νόσος (όπως κίρρωση)
  MyOption(id: 7, name: 'Chronic liver disease'),

// Ρευματοειδής αρθρίτιδα
  MyOption(id: 8, name: 'Rheumatoid arthritis'),

// Οστεοαρθρίτιδα
  MyOption(id: 9, name: 'Osteoarthritis'),

// Καρκίνος (διάφοροι τύποι)
  MyOption(id: 10, name: 'Cancer'),

// Νόσος Αλτσχάιμερ και άλλες μορφές άνοιας
  MyOption(id: 11, name: 'Alzheimers disease and other forms of dementia'),

// Νόσος του Πάρκινσον
  MyOption(id: 12, name: 'Parkinsons disease'),

// Σκλήρυνση κατά πλάκας
  MyOption(id: 13, name: 'Multiple sclerosis'),

// HIV/AIDS
  MyOption(id: 14, name: 'HIV/AIDS'),

// Ινομυαλγία
  MyOption(id: 15, name: 'Fibromyalgia'),

// Σύνδρομο χρόνιας κόπωσης
  MyOption(id: 16, name: 'Chronic fatigue syndrome'),

// Σύνδρομο ευερέθιστου εντέρου (IBS)
  MyOption(id: 17, name: 'Irritable bowel syndrome (IBS)'),

// Νόσος του Crohn
  MyOption(id: 18, name: 'Crohns disease'),

// Ελκώδης κολίτιδα
  MyOption(id: 19, name: 'Ulcerative colitis'),

// Λύκος (συστηματικός ερυθηματώδης λύκος)
  MyOption(id: 20, name: 'Lupus'),

// Επιληψία
  MyOption(id: 21, name: 'Epilepsy'),

// Κατάθλιψη
  MyOption(id: 22, name: 'Depression'),

// Αγχώδεις διαταραχές (όπως η γενικευμένη αγχώδης διαταραχή, η διαταραχή πανικού και η ιδεοψυχαναγκαστική διαταραχή)
  MyOption(id: 23, name: 'Anxiety disorders'),

// Διπολική διαταραχή
  MyOption(id: 24, name: 'Bipolar disorder'),

// Σχιζοφρένεια
  MyOption(id: 24, name: 'Schizophrenia'),

  MyOption(id: 25, name: 'Other'),
];
