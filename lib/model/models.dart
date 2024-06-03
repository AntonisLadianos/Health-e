import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class Symptom {
  final String title;
  final String description;
  final DateTime from;
  final DateTime to;
  final String intensity;

  const Symptom({
    required this.title,
    required this.description,
    required this.from,
    required this.to,
    required this.intensity,
  });
}

class Pain {
  final String intensity;
  final DateTime from;
  final DateTime to;
  final String description;

  const Pain({
    required this.intensity,
    required this.from,
    required this.to,
    required this.description,
  });
}

class Utils {
  static String toDateTime(DateTime dateTime) {
    final date = DateFormat.yMMMEd().format(dateTime);
    final time = DateFormat.Hm().format(dateTime);

    return '$date $time';
  }

  static String toDate(DateTime dateTime) {
    final date = DateFormat.yMMMEd().format(dateTime);
    return date;
  }

  static String toTime(DateTime dateTime) {
    final time = DateFormat.Hm().format(dateTime);
    return time;
  }
}

class EventProvider extends ChangeNotifier {
  //Sympotms
  final List<Symptom> _symptomEvents = [];

  List<Symptom> get symevents => _symptomEvents;

  DateTime _selectedDateSym = DateTime.now();

  DateTime get selectedDate => _selectedDateSym;

  void setDate(DateTime dateSym) => _selectedDateSym = dateSym;

  List<Symptom> get eventsOfSelectedDateSym => symevents;

  void addEventSym(Symptom symptom) {
    _symptomEvents.add(symptom);
    notifyListeners();
  }

  void removeEventSym(Symptom symptom) {
    _symptomEvents.remove(symptom);
    notifyListeners();
  }

  List<int> getDailyEventCounts() {
    // group events by day using a Map
    final eventsByDay = _symptomEvents.fold<Map<DateTime, List<Symptom>>>(
      {},
      (Map<DateTime, List<Symptom>> acc, Symptom event) {
        final day = DateTime(event.from.year, event.from.month, event.from.day);
        final list = acc[day] ?? [];
        list.add(event);
        return {...acc, day: list};
      },
    );

    // count the number of events per day
    final dailyEventCounts = List<int>.filled(7, 0); // initialize with 0s
    for (var entry in eventsByDay.entries) {
      final dayOfWeek = entry.key.weekday;
      final count = entry.value.length;
      dailyEventCounts[dayOfWeek - 1] = count;
    }

    // print(dailyEventCounts);
    return dailyEventCounts;
  }

  List<double> getDailypainAverages() {
    // group events by day using a Map
    final eventsByDay = _symptomEvents.fold<Map<DateTime, List<Symptom>>>(
      {},
      (Map<DateTime, List<Symptom>> acc, Symptom event) {
        final day = DateTime(event.from.year, event.from.month, event.from.day);
        final list = acc[day] ?? [];
        list.add(event);
        return {...acc, day: list};
      },
    );
    // calculate the daily pain averages
    final dailyPainAverages = List<double>.filled(7, 0.0); // initialize with 0s
    for (var entry in eventsByDay.entries) {
      final dayOfWeek = entry.key.weekday;
      final events = entry.value;
      double totalPain = 0.0;
      int validEvents = 0;
      for (var event in events) {
        final intensity = double.tryParse(event.intensity);
        if (intensity != null) {
          totalPain += intensity;
          validEvents++;
        } else {
          print('Invalid intensity value for event: $event');
        }
      }
      if (validEvents > 0) {
        double averagePain = totalPain / validEvents;
        double avg = averagePain.roundToDouble();
        dailyPainAverages[dayOfWeek - 1] = avg;
      }
    }

    return dailyPainAverages;
  }

  //Pain
  final List<Pain> _painEvents = [];

  List<Pain> get painevents => _painEvents;

  DateTime _selectedDatePain = DateTime.now();

  DateTime get selectedDatePain => _selectedDatePain;

  void setDatePain(DateTime dateSym) => _selectedDateSym = dateSym;

  List<Pain> get eventsOfSelectedDatePain => painevents;

  void addEventPain(Pain pain) {
    _painEvents.add(pain);
    notifyListeners();
  }

  void removeEventPain(Pain pain) {
    _painEvents.remove(pain);
    notifyListeners();
  }

//profile image
  XFile? _imageFile;

  XFile? get imageFile => _imageFile;

  void setImageFile(XFile? file) {
    _imageFile = file;
    notifyListeners();
  }
}
