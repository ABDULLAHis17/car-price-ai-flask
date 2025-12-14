import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/car_provider.dart';
import '../models/car_model.dart';
import '../constants/colors.dart';
import 'widgets/result_card.dart';

class ManualInputScreen extends StatefulWidget {
  const ManualInputScreen({Key? key}) : super(key: key);

  @override
  State<ManualInputScreen> createState() => _ManualInputScreenState();
}

class _ManualInputScreenState extends State<ManualInputScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _carNameController;
  late TextEditingController _yearController;
  late TextEditingController _kmController;
  late TextEditingController _engineController;
  late TextEditingController _powerController;
  late TextEditingController _mileageController;
  late TextEditingController _seatsController;
  
  String? _selectedFuel;
  String? _selectedTransmission;
  String? _selectedSeller;
  String? _selectedOwner;

  @override
  void initState() {
    super.initState();
    _carNameController = TextEditingController();
    _yearController = TextEditingController(text: '2017');
    _kmController = TextEditingController(text: '50000');
    _engineController = TextEditingController(text: '1200');
    _powerController = TextEditingController(text: '80');
    _mileageController = TextEditingController(text: '18');
    _seatsController = TextEditingController(text: '5');
  }

  @override
  void dispose() {
    _carNameController.dispose();
    _yearController.dispose();
    _kmController.dispose();
    _engineController.dispose();
    _powerController.dispose();
    _mileageController.dispose();
    _seatsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CarProvider>(
      builder: (context, provider, _) {
        return Column(
          children: [
            // Form Card
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      'Araç Özelliklerini Girin',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Car Name
                    _buildDropdownField(
                      label: '🚙 Araç Adı',
                      value: _carNameController.text.isEmpty ? null : _carNameController.text,
                      items: provider.carNames,
                      onChanged: (value) {
                        _carNameController.text = value ?? '';
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Araç adı seçiniz';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Year
                    _buildTextField(
                      controller: _yearController,
                      label: '📅 Üretim Yılı',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Yıl gereklidir';
                        final year = int.tryParse(value);
                        if (year == null || year < 1990 || year > 2025) {
                          return 'Geçerli bir yıl girin (1990-2025)';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // KM
                    _buildTextField(
                      controller: _kmController,
                      label: '🛣️ Kilometre',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Kilometre gereklidir';
                        final km = int.tryParse(value);
                        if (km == null || km < 0) return 'Geçerli bir değer girin';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Engine
                    _buildTextField(
                      controller: _engineController,
                      label: '⚙️ Motor Hacmi',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Motor hacmi gereklidir';
                        final engine = int.tryParse(value);
                        if (engine == null || engine < 500 || engine > 6000) {
                          return 'Geçerli bir değer girin (500-6000)';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Power
                    _buildTextField(
                      controller: _powerController,
                      label: '⚡ Maks. Güç',
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Güç gereklidir';
                        final power = double.tryParse(value);
                        if (power == null || power < 30 || power > 600) {
                          return 'Geçerli bir değer girin (30-600)';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Mileage
                    _buildTextField(
                      controller: _mileageController,
                      label: '⛽ Yakıt Tüketimi',
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Yakıt tüketimi gereklidir';
                        final mileage = double.tryParse(value);
                        if (mileage == null || mileage < 0 || mileage > 60) {
                          return 'Geçerli bir değer girin (0-60)';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Seats
                    _buildTextField(
                      controller: _seatsController,
                      label: '🪑 Koltuk Sayısı',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Koltuk sayısı gereklidir';
                        final seats = int.tryParse(value);
                        if (seats == null || seats < 2 || seats > 10) {
                          return 'Geçerli bir değer girin (2-10)';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Fuel Type
                    _buildDropdownField(
                      label: '🔥 Yakıt Türü',
                      value: _selectedFuel,
                      items: provider.carInfo?.fuelTypes ?? [],
                      onChanged: (value) => setState(() => _selectedFuel = value),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Yakıt türü seçiniz';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Transmission
                    _buildDropdownField(
                      label: '🔧 Vites Tipi',
                      value: _selectedTransmission,
                      items: provider.carInfo?.transmissions ?? [],
                      onChanged: (value) => setState(() => _selectedTransmission = value),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vites tipi seçiniz';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Seller Type
                    _buildDropdownField(
                      label: '🏪 Satıcı Tipi',
                      value: _selectedSeller,
                      items: provider.carInfo?.sellerTypes ?? [],
                      onChanged: (value) => setState(() => _selectedSeller = value),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Satıcı tipi seçiniz';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Owner Count
                    _buildDropdownField(
                      label: '👤 Sahip Sayısı',
                      value: _selectedOwner,
                      items: provider.carInfo?.ownerCounts ?? [],
                      onChanged: (value) => setState(() => _selectedOwner = value),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Sahip sayısı seçiniz';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: provider.isLoading
                            ? null
                            : () => _handleSubmit(context, provider),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          disabledBackgroundColor: AppColors.textHint,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: provider.isLoading
                            ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                            strokeWidth: 2,
                          ),
                        )
                            : const Text(
                          '🎯 Fiyat Tahmin Et',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Error Message
            if (provider.errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.error.withOpacity(0.1),
                    border: Border.all(color: AppColors.error),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: AppColors.error),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          provider.errorMessage!,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.error,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Result Card
            if (provider.lastPrediction != null &&
                provider.lastPrediction!.success)
              Padding(
                padding: const EdgeInsets.only(top: 24),
                child: ResultCard(
                  predictedPrice: provider.lastPrediction!.predictedPrice,
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required TextInputType keyboardType,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
    required String? Function(String?) validator,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items.map((item) {
        return DropdownMenuItem(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error),
        ),
      ),
    );
  }

  void _handleSubmit(BuildContext context, CarProvider provider) {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final request = CarPredictionRequest(
      carName: _carNameController.text,
      year: int.parse(_yearController.text),
      km: int.parse(_kmController.text),
      engine: int.parse(_engineController.text),
      power: double.parse(_powerController.text),
      mileage: double.parse(_mileageController.text),
      seats: int.parse(_seatsController.text),
      fuel: _selectedFuel ?? '',
      transmission: _selectedTransmission ?? '',
      seller: _selectedSeller ?? '',
      owner: _selectedOwner ?? '',
    );

    provider.predictManual(request);
  }
}
