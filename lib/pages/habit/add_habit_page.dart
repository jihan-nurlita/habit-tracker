import 'package:flutter/material.dart';
import 'package:habit_tracker/models/habit_model.dart';
import 'package:habit_tracker/providers/habit_provider.dart';
import 'package:habit_tracker/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class AddHabitPage extends StatefulWidget {
  final HabitModel? habit;

  const AddHabitPage({
    super.key,
    this.habit,
  });

  @override
  State<AddHabitPage> createState() => _AddHabitPageState();
}

class _AddHabitPageState extends State<AddHabitPage> {
  final titleController = TextEditingController();

  final subtitleController = TextEditingController();

  final notesController = TextEditingController();

  bool reminderEnabled = true;

  @override
  void initState() {
    super.initState();

    final habit = widget.habit;

    if (habit != null) {
      titleController.text = habit.title;
      subtitleController.text = habit.subtitle;
      notesController.text = habit.notes;

      selectedCategory = habit.category;
      selectedIcon = habit.icon;

      selectedDuration = habit.duration;
      selectedTarget = habit.target;
      selectedRepeat = habit.repeat;

      reminderEnabled = habit.reminderEnabled;

      selectedDate = habit.date;

      startTime = _parseTime(habit.startTime);
      endTime = _parseTime(habit.endTime);
    }
  }

//
  TimeOfDay _parseTime(String value) {
    try {
      final parts = value.trim().split(' ');

      final timeParts = parts[0].split(':');

      int hour = int.parse(timeParts[0]);
      final int minute = int.parse(timeParts[1]);

      if (parts.length > 1) {
        final period = parts[1].toUpperCase();

        if (period == "PM" && hour != 12) {
          hour += 12;
        }

        if (period == "AM" && hour == 12) {
          hour = 0;
        }
      }

      return TimeOfDay(
        hour: hour,
        minute: minute,
      );
    } catch (_) {
      return const TimeOfDay(
        hour: 19,
        minute: 0,
      );
    }
  }

  /// DURATION
  final List<String> durations = [
    "Tidak Ada",
    "10 Menit",
    "15 Menit",
    "30 Menit",
    "1 Jam",
  ];

  /// TARGET
  final List<String> targets = [
    "Tidak Ada",
    "Kali",
    "Bab",
    "Halaman",
  ];

  /// REPEAT
  final List<String> repeatList = [
    "Setiap Hari",
    "Senin - Jumat",
    "Weekend",
    "Custom",
  ];

  String repeatType = "Harian";

  int repeatEvery = 1;

  DateTime repeatStartDate = DateTime.now();

  List<String> selectedDays = [];

  /// SELECTED VALUE
  String selectedDuration = "Tidak Ada";

  String selectedTarget = "Tidak Ada";

  /// =========================
  /// DATA
  /// =========================

  final List<Map<String, dynamic>> categories = [
    // ======================
    // Pribadi
    // ======================
    {
      "name": "Pribadi",
      "icon": Icons.person_rounded,
    },

    // ======================
    // Ibadah
    // ======================
    {
      "name": "Ibadah",
      "icon": Icons.mosque_rounded,
    },

    // ======================
    // Kesehatan
    // ======================
    {
      "name": "Kesehatan",
      "icon": Icons.favorite_rounded,
    },

    // ======================
    // Belajar
    // ======================
    {
      "name": "Belajar",
      "icon": Icons.menu_book_rounded,
    },

    // ======================
    // Kerja
    // ======================
    {
      "name": "Kerja",
      "icon": Icons.work_rounded,
    },

    // ======================
    // Produktivitas
    // ======================
    {
      "name": "Produktivitas",
      "icon": Icons.rocket_launch_rounded,
    },

    // ======================
    // Keuangan
    // ======================
    {
      "name": "Keuangan",
      "icon": Icons.account_balance_wallet_rounded,
    },

    // ======================
    // Rumah
    // ======================
    {
      "name": "Rumah",
      "icon": Icons.home_rounded,
    },

    // ======================
    // Sosial
    // ======================
    {
      "name": "Sosial",
      "icon": Icons.people_alt_rounded,
    },

    // ======================
    // Hobi
    // ======================
    {
      "name": "Hobi",
      "icon": Icons.palette_rounded,
    },

    // ======================
    // Olahraga
    // ======================
    {
      "name": "Olahraga",
      "icon": Icons.fitness_center_rounded,
    },

    // ======================
    // Perjalanan
    // ======================
    {
      "name": "Perjalanan",
      "icon": Icons.flight_takeoff_rounded,
    },
  ];

  final List<IconData> icons = [
    // =========================
    // 👤 Pribadi
    // =========================
    Icons.person_rounded,
    Icons.face_rounded,
    Icons.self_improvement_rounded,
    Icons.nightlight_round,
    Icons.bedtime_rounded,

    // =========================
    // 📚 Belajar
    // =========================
    Icons.menu_book_rounded,
    Icons.school_rounded,
    Icons.auto_stories_rounded,
    Icons.edit_note_rounded,
    Icons.library_books_rounded,

    // =========================
    // 💼 Kerja
    // =========================
    Icons.work_rounded,
    Icons.business_center_rounded,
    Icons.laptop_mac_rounded,
    Icons.desktop_windows_rounded,
    Icons.badge_rounded,

    // =========================
    // 🚀 Produktivitas
    // =========================
    Icons.check_circle_rounded,
    Icons.task_alt_rounded,
    Icons.flag_rounded,
    Icons.rocket_launch_rounded,
    Icons.timer_rounded,
    Icons.bolt_rounded,
    Icons.lightbulb_rounded,

    // =========================
    // ❤️ Kesehatan
    // =========================
    Icons.favorite_rounded,
    Icons.monitor_heart_rounded,
    Icons.local_hospital_rounded,
    Icons.medication_rounded,
    Icons.health_and_safety_rounded,

    // =========================
    // 💪 Olahraga
    // =========================
    Icons.fitness_center_rounded,
    Icons.directions_run_rounded,
    Icons.directions_walk_rounded,
    Icons.pedal_bike_rounded,
    Icons.sports_gymnastics_rounded,

    // =========================
    // 🍽️ Makanan & Minuman
    // =========================
    Icons.restaurant_rounded,
    Icons.lunch_dining_rounded,
    Icons.local_drink_rounded,
    Icons.water_drop_rounded,
    Icons.fastfood_rounded,

    // =========================
    // 💰 Keuangan
    // =========================
    Icons.account_balance_wallet_rounded,
    Icons.payments_rounded,
    Icons.savings_rounded,
    Icons.attach_money_rounded,
    Icons.credit_card_rounded,

    // =========================
    // 🏠 Rumah
    // =========================
    Icons.home_rounded,
    Icons.cleaning_services_rounded,
    Icons.chair_rounded,
    Icons.kitchen_rounded,
    Icons.local_laundry_service_rounded,

    // =========================
    // 🎨 Hobi
    // =========================
    Icons.palette_rounded,
    Icons.music_note_rounded,
    Icons.photo_camera_rounded,
    Icons.sports_esports_rounded,
    Icons.brush_rounded,

    // =========================
    // 👥 Sosial
    // =========================
    Icons.people_alt_rounded,
    Icons.groups_rounded,
    Icons.chat_rounded,
    Icons.handshake_rounded,
    Icons.favorite_border_rounded,

    // =========================
    // ✈️ Perjalanan
    // =========================
    Icons.flight_takeoff_rounded,
    Icons.map_rounded,
    Icons.directions_car_rounded,
    Icons.train_rounded,
    Icons.hotel_rounded,

    // =========================
    // 🕌 Ibadah
    // =========================
    Icons.mosque_rounded,
    Icons.volunteer_activism_rounded,
    Icons.auto_awesome_rounded,
    Icons.favorite_outline_rounded,
  ];

  String selectedCategory = "Pribadi";

  IconData selectedIcon = Icons.person_rounded;
  //
  TimeOfDay startTime = const TimeOfDay(
    hour: 19,
    minute: 00,
  );

  DateTime selectedDate = DateTime.now();

  TimeOfDay endTime = const TimeOfDay(
    hour: 19,
    minute: 30,
  );

  /// =========================
  /// PICK TIME
  /// =========================

  Future<void> pickStartTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: startTime,
    );

    if (picked != null) {
      setState(() {
        startTime = picked;
      });
    }
  }

  Future<void> pickEndTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: endTime,
    );

    if (picked != null) {
      setState(() {
        endTime = picked;
      });
    }
  }

  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  /// =========================
  /// ICON MODAL
  /// =========================

  void openIconModal(dynamic theme) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled:
          true, // Tambahkan ini agar modal bisa mengambil tinggi lebih besar jika dibutuhkan
      builder: (_) {
        // Gunakan DraggableScrollableSheet atau batasi tinggi maksimum agar aman
        return Container(
          padding: const EdgeInsets.all(22),
          margin: const EdgeInsets.all(12),
          // Berikan batasan tinggi maksimal (misal: 70% dari tinggi layar)
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(32),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              const SizedBox(height: 24),
              const Row(
                children: [
                  Text(
                    "Pilih Icon Habit",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Bungkus GridView dengan Expanded + SingleChildScrollView agar bisa di-scroll di dalam ruang yang tersedia
              Expanded(
                child: SingleChildScrollView(
                  child: GridView.builder(
                    shrinkWrap: true,
                    itemCount: icons.length,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                    ),
                    itemBuilder: (context, index) {
                      final icon = icons[index];
                      final selected = selectedIcon == icon;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIcon = icon;
                          });
                          Navigator.pop(context);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          decoration: BoxDecoration(
                            color:
                                selected ? theme.primaryColor : theme.softColor,
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: Icon(
                            icon,
                            size: 30,
                            color: selected ? Colors.white : theme.primaryColor,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  /// =========================
  /// CATEGORY MODAL
  /// =========================

  void openCategoryModal(dynamic theme) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true, // Tambahkan ini
      builder: (_) {
        return Container(
          padding: const EdgeInsets.all(22),
          margin: const EdgeInsets.all(12),
          height: MediaQuery.of(context).size.height *
              0.6, // Batasi tinggi maksimal modal kategori
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(32),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  const SizedBox(width: 10),
                  Text(
                    "Pilih Category",
                    style: TextStyle(
                      color: theme.textColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Bungkus GridView dengan Expanded + SingleChildScrollView
              Expanded(
                child: SingleChildScrollView(
                  child: GridView.builder(
                    shrinkWrap: true,
                    itemCount: categories.length,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: 2.6,
                    ),
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      final selected = selectedCategory == category["name"];

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedCategory = category["name"];
                          });
                          Navigator.pop(context);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color:
                                selected ? theme.primaryColor : theme.softColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                category["icon"],
                                color: selected
                                    ? Colors.white
                                    : theme.primaryColor,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  category["name"],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: selected
                                        ? Colors.white
                                        : theme.textColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

/////// Duration lama
  void openSelectionModal({
    required String title,
    required List<String> items,
    required String selectedValue,
    required Function(String) onSelected,
    required dynamic theme,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled:
          true, // 1. Izinkan modal menyesuaikan ukuran konten harian
      builder: (_) {
        return Container(
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.all(22),
          // 2. Batasi tinggi maksimal agar tidak overflow (50% dari tinggi layar)
          height: MediaQuery.of(context).size.height * 0.5,
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(32),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// HANDLE
              Container(
                width: 60,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),

              const SizedBox(height: 24),

              Row(
                children: [
                  const SizedBox(width: 10),
                  Text(
                    title,
                    style: TextStyle(
                      color: theme.textColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              /// 3. Bungkus daftar list item dengan Expanded + SingleChildScrollView
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: items.map((item) {
                      final selected = selectedValue == item;

                      return GestureDetector(
                        onTap: () {
                          onSelected(item);
                          Navigator.pop(context);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color:
                                selected ? theme.primaryColor : theme.softColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  item,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: selected
                                        ? Colors.white
                                        : theme.textColor,
                                  ),
                                ),
                              ),
                              if (selected)
                                const Icon(
                                  Icons.check_rounded,
                                  color: Colors.white,
                                ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),

              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  // DURATION
  void openDurationModal(dynamic theme) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled:
          true, // 1. Izinkan modal mengambil tinggi lebih besar / menyesuaikan keyboard
      builder: (_) {
        return Padding(
          // Menggunakan Padding bottom agar modal otomatis naik saat keyboard muncul
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            padding: const EdgeInsets.all(22),
            margin: const EdgeInsets.all(12),
            // 2. Batasi tinggi maksimal modal durasi (misal: 50% dari tinggi layar)
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(32),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 60,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Icon(Icons.timer_rounded, color: theme.primaryColor),
                    const SizedBox(width: 10),
                    Text(
                      "Atur Durasi",
                      style: TextStyle(
                          color: theme.textColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // 3. Bungkus area input dengan Expanded + SingleChildScrollView
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Taruh komponen input durasi Anda di sini (misal: TextField atau Wheel Picker)
                        TextField(
                          style: TextStyle(
                            color: theme.textColor,
                          ),
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: "Masukkan durasi (menit)",
                            filled: true,
                            fillColor: theme.softColor,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Tombol Simpan/Konfirmasi
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Simpan",
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  //
  // Tambahkan variabel di bagian atas class State (jika belum ada)
  final targetNumberController = TextEditingController(text: "1");

  void openTargetModal(dynamic theme) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true, // Agar aman saat keyboard muncul
      builder: (_) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            padding: const EdgeInsets.all(22),
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(32),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 60,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Icon(Icons.flag_rounded, color: theme.primaryColor),
                    const SizedBox(width: 10),
                    const Text("Atur Target",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 24),

                // Input Row: Angka dan Satuan
                Row(
                  children: [
                    // Input Angka
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: targetNumberController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Jumlah",
                          filled: true,
                          fillColor: theme.softColor,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Pilihan Satuan (Kali, Bab, Halaman)
                    Expanded(
                      flex: 3,
                      child: StatefulBuilder(builder: (context, setModalState) {
                        return DropdownButtonFormField<String>(
                          value: selectedTarget == "Tidak Ada"
                              ? "Kali"
                              : selectedTarget,
                          decoration: InputDecoration(
                            labelText: "Satuan",
                            filled: true,
                            fillColor: theme.softColor,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none),
                          ),
                          items: targets
                              .where((e) => e != "Tidak Ada")
                              .map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setModalState(() {
                              selectedTarget = newValue!;
                            });
                          },
                        );
                      }),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: () {
                      setState(() {
                        // Gabungkan angka dan satuan untuk ditampilkan di UI utama
                        selectedTarget =
                            "${targetNumberController.text} $selectedTarget";
                      });
                      Navigator.pop(context);
                    },
                    child: const Text("Simpan Target",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  //
  String selectedRepeat = "Setiap Hari";

  // Tambahkan/pastikan list ini ada untuk menampung hari kustom (7 hari)
  List<String> customSelectedDays = [];

  // List bantuan untuk menampilkan nama hari di UI
  final List<String> allDays = [
    "Sen",
    "Sel",
    "Rab",
    "Kam",
    "Jum",
    "Sab",
    "Min"
  ];

  void openRepeatModal(dynamic theme) {
    final List<String> defaultOptions = [
      "Setiap Hari",
      "Senin - Jumat",
      "Weekend",
      "Custom (Pilih Hari)",
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(22),
              margin: const EdgeInsets.all(12),
              // Membatasi tinggi agar aman dari overflow dan rapi
              height: MediaQuery.of(context).size.height * 0.65,
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(32),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// HANDLE ATAS
                  Center(
                    child: Container(
                      width: 60,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Icon(Icons.repeat_rounded, color: theme.primaryColor),
                      const SizedBox(width: 10),
                      Text(
                        "Ulangi Habit",
                        style: TextStyle(
                          color: theme.textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  /// LIST PILIHAN REPEAT
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          ...defaultOptions.map((option) {
                            final isSelected = selectedRepeat == option;

                            return GestureDetector(
                              onTap: () {
                                setModalState(() {
                                  selectedRepeat = option;
                                  // Logika otomatisasi hari berdasarkan pilihan cepat
                                  if (option == "Setiap Hari") {
                                    customSelectedDays = List.from(allDays);
                                  } else if (option == "Senin - Jumat") {
                                    customSelectedDays = [
                                      "Sen",
                                      "Sel",
                                      "Rab",
                                      "Kam",
                                      "Jum"
                                    ];
                                  } else if (option == "Weekend") {
                                    customSelectedDays = ["Sab", "Min"];
                                  } else if (option == "Custom (Pilih Hari)" &&
                                      customSelectedDays.isEmpty) {
                                    customSelectedDays = [
                                      "Sen"
                                    ]; // Default awal kustom
                                  }
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(18),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? theme.primaryColor
                                      : theme.softColor,
                                  borderRadius: BorderRadius.circular(22),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        option,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: isSelected
                                              ? Colors.white
                                              : theme.textColor,
                                        ),
                                      ),
                                    ),
                                    if (isSelected)
                                      const Icon(Icons.check_rounded,
                                          color: Colors.white),
                                  ],
                                ),
                              ),
                            );
                          }),

                          const SizedBox(height: 16),

                          /// TAMPILAN PILIHAN HARI MANUAL (Hanya muncul jika memilih Custom)
                          if (selectedRepeat == "Custom (Pilih Hari)") ...[
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Pilih Hari Secara Manual:",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: theme.textColor.withOpacity(0.7),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: allDays.map((day) {
                                final daySelected =
                                    customSelectedDays.contains(day);

                                return GestureDetector(
                                  onTap: () {
                                    setModalState(() {
                                      if (daySelected) {
                                        // Jangan biarkan kosong sama sekali, minimal harus ada 1 hari aktif
                                        if (customSelectedDays.length > 1) {
                                          customSelectedDays.remove(day);
                                        }
                                      } else {
                                        customSelectedDays.add(day);
                                      }
                                    });
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    width: 42,
                                    height: 42,
                                    decoration: BoxDecoration(
                                      color: daySelected
                                          ? theme.primaryColor
                                          : theme.softColor.withOpacity(0.5),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: daySelected
                                            ? Colors.transparent
                                            : theme.primaryColor
                                                .withOpacity(0.3),
                                        width: 1,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        day,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: daySelected
                                              ? Colors.white
                                              : theme.textColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// TOMBOL SIMPAN KUSTOMISASI
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () {
                        // Sinkronisasi data ke state utama halaman utama
                        setState(() {
                          // Jika custom, ubah teks ringkasan agar user tahu hari apa saja yang aktif
                          if (selectedRepeat == "Custom (Pilih Hari)") {
                            selectedRepeat =
                                "Custom (${customSelectedDays.join(', ')})";
                          }
                        });
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Konfirmasi Pilihan",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(
      context,
    ).currentTheme;

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: SizedBox(
          height: 62,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.primaryColor,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: () {
              if (titleController.text.trim().isEmpty) {
                return;
              }

              final habitProvider = Provider.of<HabitProvider>(
                context,
                listen: false,
              );

              final oldHabit = widget.habit;

              final habit = HabitModel(
                icon: selectedIcon,
                title: titleController.text.trim(),
                subtitle: subtitleController.text.trim(),
                notes: notesController.text.trim(),
                category: selectedCategory,
                startTime: startTime.format(context),
                endTime: endTime.format(context),
                duration: selectedDuration,
                target: selectedTarget,
                repeat: selectedRepeat,
                reminderEnabled: reminderEnabled,

                /// TANGGAL
                date: selectedDate,

                /// Kalau edit, createdAt lama tetap dipertahankan
                /// Kalau tambah baru, gunakan waktu sekarang.
                createdAt: oldHabit?.createdAt ?? DateTime.now(),

                /// Kalau edit, status selesai tetap dipertahankan.
                /// Kalau tambah baru, false.
                completed: oldHabit?.completed ?? false,
              );

              if (oldHabit != null) {
                /// EDIT HABIT
                habitProvider.updateHabit(
                  oldHabit,
                  habit,
                );
              } else {
                /// TAMBAH HABIT BARU
                habitProvider.addHabit(
                  habit,
                );
              }

              Navigator.pop(context);
            },
            child: const Text(
              "Simpan Habit",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),

      /// =========================
      /// APP BAR
      /// =========================
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: theme.primaryColor),
        ),
        title: Text(
          "Tambah Habit",
          style: TextStyle(
            color: theme.textColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ICON PICKER
              GestureDetector(
                onTap: () {
                  openIconModal(theme);
                },
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 62,
                        height: 62,
                        decoration: BoxDecoration(
                          color: theme.softColor,
                          borderRadius: BorderRadius.circular(
                            20,
                          ),
                        ),
                        child: Icon(
                          selectedIcon,
                          color: theme.primaryColor,
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Icon Habit",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Pilih Icon Habit",
                              style: TextStyle(
                                color: theme.textColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.keyboard_arrow_right_rounded,
                        color: theme.iconColor,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 22),

              /// TITLE
              _buildTitle(
                title: "Judul Habit",
                theme: theme,
              ),

              const SizedBox(height: 10),

              TextField(
                // TAMBAHKAN KODE INI agar warna teks yang diketik berubah jadi putih saat Dark Mode
                style: TextStyle(
                  color: theme.textColor,
                  fontSize: 16,
                ),
                controller: titleController,
                decoration: _inputDecoration(
                  hint: "tambahkan judul habit",
                  theme: theme,
                ),
              ),

              const SizedBox(height: 20),

              /// SUBTITLE
              _buildTitle(
                title: "Subtitle",
                theme: theme,
              ),

              const SizedBox(height: 10),

              TextField(
                // TAMBAHKAN KODE INI agar warna teks yang diketik berubah jadi putih saat Dark Mode
                style: TextStyle(
                  color: theme.textColor,
                  fontSize: 16,
                ),
                controller: subtitleController,
                decoration: _inputDecoration(
                  hint: "Tambahkan keterangan singkat",
                  theme: theme,
                ),
              ),

              const SizedBox(height: 20),
              _buildTitle(
                title: "Catatan",
                theme: theme,
              ),

              const SizedBox(height: 10),

              TextField(
                // TAMBAHKAN KODE INI agar warna teks yang diketik berubah jadi putih saat Dark Mode
                style: TextStyle(
                  color: theme.textColor,
                  fontSize: 16,
                ),
                controller: notesController,
                maxLines: 3,
                decoration: _inputDecoration(
                  hint: "Tambahkan catatan...",
                  theme: theme,
                ),
              ),

              const SizedBox(height: 20),

              /// CATEGORY
              _buildTitle(
                title: "Category",
                theme: theme,
              ),

              const SizedBox(height: 10),

              GestureDetector(
                onTap: () {
                  openCategoryModal(theme);
                },
                child: _buildDropdownField(
                  text: selectedCategory,
                  theme: theme,
                ),
              ),

              const SizedBox(height: 20),

              /// START & END TIME
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTitle(
                          title: "Mulai",
                          theme: theme,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: pickStartTime,
                          child: _buildTimeField(
                            time: startTime.format(
                              context,
                            ),
                            theme: theme,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTitle(
                          title: "Selesai",
                          theme: theme,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: pickEndTime,
                          child: _buildTimeField(
                            time: endTime.format(
                              context,
                            ),
                            theme: theme,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// REMINDER
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.notifications_none_rounded,
                      color: theme.primaryColor,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        "Aktifkan Reminder",
                        style: TextStyle(
                          color: theme.textColor,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Switch(
                      value: reminderEnabled,
                      activeTrackColor: theme.primaryColor,
                      onChanged: (value) {
                        setState(() {
                          reminderEnabled = value;
                        });
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// DURATION & TARGET
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTitle(
                          title: "Durasi",
                          theme: theme,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            openSelectionModal(
                              title: "Pilih Durasi",
                              items: durations,
                              selectedValue: selectedDuration,
                              theme: theme,
                              onSelected: (value) {
                                setState(() {
                                  selectedDuration = value;
                                });
                              },
                            );
                          },
                          child: _buildDropdownField(
                            text: selectedDuration,
                            theme: theme,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTitle(
                          title: "Target (optional)",
                          theme: theme,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            openSelectionModal(
                              title: "Pilih Target",
                              items: targets,
                              selectedValue: selectedTarget,
                              theme: theme,
                              onSelected: (value) {
                                setState(() {
                                  selectedTarget = value;
                                });
                              },
                            );
                          },
                          child: _buildDropdownField(
                            text: selectedTarget,
                            theme: theme,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// REPEAT
              _buildTitle(
                title: "Repeat",
                theme: theme,
              ),

              const SizedBox(height: 12),

              GestureDetector(
                onTap: () {
                  openRepeatModal(theme);
                },
                child: _buildDropdownField(
                  text: selectedRepeat,
                  theme: theme,
                ),
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  /// TITLE
  Widget _buildTitle({
    required String title,
    required dynamic theme,
  }) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: theme.textColor,
      ),
    );
  }

  /// INPUT
  InputDecoration _inputDecoration({
    required String hint,
    required dynamic theme,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: Colors.grey,
        fontWeight: FontWeight.w500,
      ),
      filled: true,
      fillColor: theme.cardColor,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 18,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide.none,
      ),
    );
  }

  /// DROPDOWN
  Widget _buildDropdownField({
    required String text,
    required dynamic theme,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 18,
      ),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: theme.textColor,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ),
          Icon(
            Icons.keyboard_arrow_down_rounded,
            color: theme.iconColor,
          ),
        ],
      ),
    );
  }

  /// TIME
  Widget _buildTimeField({
    required String time,
    required dynamic theme,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 16,
      ),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 22,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            color: theme.softColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            time,
            style: TextStyle(
              color: theme.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
