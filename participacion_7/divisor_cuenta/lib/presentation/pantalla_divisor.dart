import 'package:flutter/material.dart';
import 'divisor_controller.dart';
import 'formateador_moneda.dart';

/// Pantalla única de la aplicación para dividir la cuenta de un restaurante.
/// Maneja su estado local mediante [setState] y delega la lógica a [DivisorController].
class PantallaDivisor extends StatefulWidget {
  final DivisorController controller;

  const PantallaDivisor({
    super.key,
    required this.controller,
  });

  @override
  State<PantallaDivisor> createState() => _PantallaDivisorState();
}

class _PantallaDivisorState extends State<PantallaDivisor> {
  final TextEditingController _controladorMonto = TextEditingController();
  final TextEditingController _controladorPersonas = TextEditingController();
  final TextEditingController _controladorPropina = TextEditingController();

  ModoRedondeo _modoRedondeo = ModoRedondeo.exacto;
  DivisorEstado _estado = const DivisorEstado();

  @override
  void dispose() {
    _controladorMonto.dispose();
    _controladorPersonas.dispose();
    _controladorPropina.dispose();
    super.dispose();
  }

  void _ejecutarCalculo() {
    setState(() {
      _estado = widget.controller.calcular(
        textoMonto: _controladorMonto.text,
        textoPersonas: _controladorPersonas.text,
        textoPropina: _controladorPropina.text,
        modoRedondeo: _modoRedondeo,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Divisor de Cuenta'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Campo Monto Total
              TextField(
                key: const Key('campo_monto'),
                controller: _controladorMonto,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Monto total',
                  hintText: 'Ej. 100.00',
                  prefixText: '\$ ',
                  border: const OutlineInputBorder(),
                  errorText: _estado.errorMonto,
                ),
              ),
              const SizedBox(height: 16),

              // Campo Número de Personas
              TextField(
                key: const Key('campo_personas'),
                controller: _controladorPersonas,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Número de personas',
                  hintText: 'Ej. 4',
                  border: const OutlineInputBorder(),
                  errorText: _estado.errorPersonas,
                ),
              ),
              const SizedBox(height: 16),

              // Campo Porcentaje de Propina
              TextField(
                key: const Key('campo_propina'),
                controller: _controladorPropina,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Porcentaje de propina (%)',
                  hintText: 'Ej. 10',
                  suffixText: '%',
                  border: const OutlineInputBorder(),
                  errorText: _estado.errorPropina,
                ),
              ),
              const SizedBox(height: 20),

              // Selector de Modo de Redondeo
              const Text(
                'Modo de redondeo:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              SegmentedButton<ModoRedondeo>(
                key: const Key('selector_redondeo'),
                segments: const [
                  ButtonSegment<ModoRedondeo>(
                    value: ModoRedondeo.exacto,
                    label: Text('Exacto'),
                  ),
                  ButtonSegment<ModoRedondeo>(
                    value: ModoRedondeo.haciaArriba,
                    label: Text('Hacia arriba al entero más cercano'),
                  ),
                ],
                selected: {_modoRedondeo},
                onSelectionChanged: (Set<ModoRedondeo> nuevaSeleccion) {
                  setState(() {
                    _modoRedondeo = nuevaSeleccion.first;
                  });
                },
              ),
              const SizedBox(height: 24),

              // Botón Calcular
              ElevatedButton(
                key: const Key('boton_calcular'),
                onPressed: _ejecutarCalculo,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Calcular',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 28),

              // Área de Resultado
              if (_estado.resultado != null) ...[
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Text(
                          'Cada persona paga:',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          FormateadorMoneda.formatear(
                            _estado.resultado!.cuotaPorPersona,
                          ),
                          key: const Key('texto_resultado'),
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Total a pagar: \$ ${FormateadorMoneda.formatear(_estado.resultado!.totalPagar)}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
