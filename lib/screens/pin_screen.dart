import 'package:flutter/material.dart';

class PinScreen extends StatefulWidget {
  final String title;
  final int pinLength;
  const PinScreen({Key? key, this.title = "Nhập PIN", this.pinLength = 6}) : super(key: key);

  @override
  State<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  final TextEditingController _pinController = TextEditingController();
  String? _error;

  void _submitPin() {
    String pin = _pinController.text.trim();
    if (pin.isEmpty) {
      setState(() => _error = "Vui lòng nhập mã PIN");
      return;
    }
    if (pin.length != widget.pinLength) {
      setState(() => _error = "PIN phải đủ ${widget.pinLength} ký tự");
      return;
    }
    Navigator.of(context).pop(pin);
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.lock, size: 56, color: Colors.blueAccent),
              const SizedBox(height: 16),
              Text(
                widget.title,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _pinController,
                autofocus: true,
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: widget.pinLength,
                decoration: InputDecoration(
                  labelText: 'Nhập mã PIN',
                  border: const OutlineInputBorder(),
                  errorText: _error,
                  counterText: '',
                  prefixIcon: const Icon(Icons.password),
                ),
                onSubmitted: (_) => _submitPin(),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                icon: const Icon(Icons.check),
                label: const Text('Xác nhận'),
                onPressed: _submitPin,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(180, 48),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
