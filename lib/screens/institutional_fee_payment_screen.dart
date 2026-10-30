import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/gri_colors.dart';
import '../utils/gri_url_launcher.dart';

class InstitutionalFeePaymentScreen extends StatefulWidget {
  const InstitutionalFeePaymentScreen({super.key});

  @override
  State<InstitutionalFeePaymentScreen> createState() => _InstitutionalFeePaymentScreenState();
}

class _InstitutionalFeePaymentScreenState extends State<InstitutionalFeePaymentScreen> {
  String _selectedFeeCategory = "COE Tatkal & Transcripts";
  final TextEditingController _rollController = TextEditingController(text: "23402108");
  final TextEditingController _nameController = TextEditingController(text: "Mahesh V.");
  bool _isSandboxMode = false;
  bool _isProcessing = false;
  Map<String, dynamic>? _lastReceipt;

  final List<Map<String, dynamic>> _feeCategories = [
    {
      "name": "COE Tatkal & Transcripts",
      "amount": "₹ 1,500.00",
      "code": "COE-TATKAL-2026",
      "officialPortal": "https://ruraluniv.ac.in/includes/infrastructure/coe/pdf/Duplicate_Certificate_Application.pdf",
      "bankMode": "SBI Collect (GRI Examination Account)",
      "description": "Fast-track issue of Degree, Consolidated Mark Statement, or Official Transcripts within 48 hours.",
    },
    {
      "name": "Semester Tuition & Lab Fee",
      "amount": "₹ 12,450.00",
      "code": "SEM-FEE-IV-2026",
      "officialPortal": "https://ruraluniv.ac.in/fee_structure",
      "bankMode": "Canara Bank / SBI Collect E-Challan",
      "description": "Regular academic tuition, laboratory consumables, library digital database, and sports council fee.",
    },
    {
      "name": "Hostel & Dining Mess Charges",
      "amount": "₹ 8,700.00",
      "code": "HSTL-MESS-2026",
      "officialPortal": "https://ruraluniv.ac.in/facilities?content=hostel",
      "bankMode": "GRI Hostels Account (SBI Gandhigram)",
      "description": "Kasturba & Tagore Hostels lodging maintenance, steam kitchen meal token, and solar hot water facility.",
    },
    {
      "name": "Admission Application (CUET/Non-CUET)",
      "amount": "₹ 600.00",
      "code": "ADM-APP-2026",
      "officialPortal": "https://ruraluniv.ac.in/admissions",
      "bankMode": "Online Payment Gateway (SBI E-Pay)",
      "description": "Application registration for Undergraduate, Postgraduate, Diploma, and Ph.D. admissions.",
    },
  ];

  @override
  void dispose() {
    _rollController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _executePayment(Map<String, dynamic> fee) async {
    if (_isSandboxMode) {
      setState(() => _isProcessing = true);
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        _isProcessing = false;
        _lastReceipt = {
          "receiptNo": "GRI-REC-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}",
          "feeTitle": fee["name"],
          "amount": fee["amount"],
          "studentName": _nameController.text.trim(),
          "rollNo": _rollController.text.trim(),
          "date": DateTime.now().toString().split(".")[0],
          "bankRef": "SBICOLLECT-${DateTime.now().microsecondsSinceEpoch.toString().substring(8)}",
          "status": "SUCCESSFUL (SANDBOX VERIFIED)",
        };
      });
      if (mounted) {
        _showReceiptModal(context);
      }
    } else {
      // Launch official university payment gateway
      final url = fee["officialPortal"] as String;
      await GriUrlLauncher.launch(context, url);
    }
  }

  void _showReceiptModal(BuildContext context) {
    if (_lastReceipt == null) return;
    final r = _lastReceipt!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? GriColors.darkSurface1 : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.check_circle, color: Colors.green, size: 26),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Institutional Fee Receipt",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Gandhigram Rural Institute (Deemed University)",
                          style: TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(height: 1),
              const SizedBox(height: 14),
              _receiptRow("Receipt Number:", r["receiptNo"]!),
              _receiptRow("Student Name:", r["studentName"]!),
              _receiptRow("Registration/Roll No:", r["rollNo"]!),
              _receiptRow("Fee Head:", r["feeTitle"]!),
              _receiptRow("Amount Paid:", r["amount"]!),
              _receiptRow("Transaction Ref:", r["bankRef"]!),
              _receiptRow("Date & Time:", r["date"]!),
              _receiptRow("Payment Status:", r["status"]!, isSuccess: true),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.copy, size: 16),
                      label: const Text("Copy Ref"),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: r["bankRef"]!));
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Bank reference copied to clipboard.")),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: GriColors.forestPrimary,
                        foregroundColor: Colors.white,
                      ),
                      icon: const Icon(Icons.download, size: 16),
                      label: const Text("Download PDF"),
                      onPressed: () {
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Receipt saved to device storage.")),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _receiptRow(String label, String value, {bool isSuccess = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isSuccess ? Colors.green.shade800 : null,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeFee = _feeCategories.firstWhere(
      (f) => f["name"] == _selectedFeeCategory,
      orElse: () => _feeCategories[0],
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("GRI Fee & Payment Portal", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        backgroundColor: isDark ? GriColors.darkSurface1 : Colors.white,
        elevation: 0.5,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Institutional Banner Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  GriColors.forestPrimary,
                  GriColors.forestPrimary.withValues(alpha: 0.85),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: GriColors.forestPrimary.withValues(alpha: 0.25),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "OFFICIAL E-COLLECTION PORTAL",
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                        color: Colors.white70,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        "RBI & SBI Regulated",
                        style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  "Gandhigram University Fee Gateway",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Secure direct remittance of tuition fees, hostels, examination tatkal documents, and admission forms.",
                  style: TextStyle(fontSize: 11.5, color: Colors.white70, height: 1.3),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Fee Selection Dropdown
          const Text(
            "SELECT FEE CATEGORY",
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: isDark ? GriColors.darkSurface1 : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isDark ? GriColors.darkOutlineVariant : GriColors.outlineVariant,
                width: 0.8,
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedFeeCategory,
                isExpanded: true,
                items: _feeCategories.map((f) {
                  return DropdownMenuItem<String>(
                    value: f["name"] as String,
                    child: Text(
                      "${f["name"]} (${f["amount"]})",
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedFeeCategory = val);
                },
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Fee Details Card
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? GriColors.darkSurface1 : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? GriColors.darkOutlineVariant : GriColors.outlineVariant,
                width: 0.8,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      activeFee["name"] as String,
                      style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      activeFee["amount"] as String,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: GriColors.forestPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  activeFee["description"] as String,
                  style: TextStyle(
                    fontSize: 11.5,
                    color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.account_balance, size: 14, color: Colors.grey),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        "Collection Mode: ${activeFee["bankMode"]}",
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // Student Verification Fields
          const Text(
            "STUDENT / APPLICANT IDENTIFIERS",
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: _rollController,
            decoration: InputDecoration(
              labelText: "Registration / Roll Number",
              prefixIcon: const Icon(Icons.badge_outlined, size: 18),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: "Student Full Name (as per GRI records)",
              prefixIcon: const Icon(Icons.person_outline, size: 18),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
          ),
          const SizedBox(height: 16),

          // Sandbox Switch Card
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: (_isSandboxMode ? Colors.amber : Colors.blueGrey).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: (_isSandboxMode ? Colors.amber : Colors.blueGrey).withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _isSandboxMode ? Icons.science_outlined : Icons.lock_outline,
                  size: 18,
                  color: _isSandboxMode ? Colors.amber.shade900 : Colors.blueGrey,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isSandboxMode ? "Sandbox Simulation Mode Active" : "Live Bank Gateway Mode Active",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: _isSandboxMode ? Colors.amber.shade900 : Colors.blueGrey,
                        ),
                      ),
                      Text(
                        _isSandboxMode
                            ? "Simulate verified test payment and instant receipt generation without debiting money."
                            : "Opens official SBI Collect / Canara Bank portal in external browser.",
                        style: const TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _isSandboxMode,
                  onChanged: (val) => setState(() => _isSandboxMode = val),
                  activeColor: GriColors.forestPrimary,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Payment Button
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: GriColors.forestPrimary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            icon: _isProcessing
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                  )
                : Icon(_isSandboxMode ? Icons.verified : Icons.open_in_new, size: 18),
            label: Text(
              _isProcessing
                  ? "Processing Simulation..."
                  : (_isSandboxMode
                      ? "Pay ${activeFee["amount"]} (Sandbox Test)"
                      : "Proceed to Official Bank Gateway"),
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            onPressed: _isProcessing ? null : () => _executePayment(activeFee),
          ),
        ],
      ),
    );
  }
}
