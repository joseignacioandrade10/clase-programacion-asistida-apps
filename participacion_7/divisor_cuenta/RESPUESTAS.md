# Respuestas — Deber 2

1. Análisis QUÉ/CÓMO y reutilización de la especificación
* **Spec intacta (QUÉ):** Aproximadamente el 85% de la especificación viajó intacta. Pude reutilizar todos los enunciados que describían el comportamiento del usuario y las reglas de negocio matemáticas son totalmente agnósticos a la tecnología.
* **Spec con adaptación (MIXTO):** Un **10%** requirió adaptación en su redacción. Las ideas seguían siendo válidas, pero usaban alguna palabra que sonaba al ecosistema móvil, aunque su propósito era general.
* **Spec no reutilizable (CÓMO):** Alrededor del **5%**.
* **Justificación:** Tal como comprobé al hacer el `git diff --no-index` inicial, la copia de la especificación original arrojó un diff vacío. Esto demuestra empíricamente que cuando usamos SDD para aislar el QUÉ del CÓMO desde el principio, el conocimiento del sistema sobrevive al cambio de Flutter a React.

1. Clasificación de la Constitution
Al analizar la constitución del proyecto y migrar de Flutter a React, clasifiqué las reglas
* **Idénticas:** Los 5 principios SOLID (SRP, OCP, LSP, ISP, DIP) y las reglas de Seguridad (como "Nunca guardar secretos ni API keys en el repositorio") viajaron de forma idéntica porque son principios universales de ingeniería de software.
* **Adaptadas en redacción:** La regla de arquitectura que decía "lib/domain no importa package:flutter" la adapté a "src/domain NO importa react ni nada del DOM: es JavaScript puro". La idea de mantener el dominio libre del framework se conservó perfectamente.
* **Reemplazadas:** Cualquier regla que hiciera referencia a cómo instanciar widgets o usar `setState` de Flutter se reemplazó por el uso de `useState` y hooks en React, ya que eso pertenece estrictamente al CÓMO.

## 3. Implementación y posibles modificaciones de la spec
**No tuve que modificar ningún enunciado de la spec original para implementar React.** 
Lo que me permitió reutilizar la spec sin hacer cambios (y tener ese diff inicial vacío) fue que, en el laboratorio anterior, fuimos muy estrictos en redactar la especificación enfocándonos únicamente en el comportamiento externo y verificable. Enunciados como "Con 100 USD, 4 personas y 10% → 27.50 por persona" son verdades matemáticas que funcionan igual en Dart, JavaScript o Python. Al no tener "supuestos escondidos" de Flutter (como menciones a `MaterialApp` o `Widgets`), la herramienta de análisis de Spec Kit (`/speckit-analyze`) no encontró contradicciones al planificar en React.

## 4. Comparación de los seis casos de aceptación (Flutter vs React)
Los 6 casos de aceptación **se conservaron exactamente iguales**. No cambió ningún valor esperado, mensaje de error ni escenario. 
* Los casos como el reparto normal (100.00, 4 personas, 10% propina -> 27.50) o el error de cero personas ("Debe haber al menos una persona") son idénticos. 
* **Lo único que cambió fue la herramienta (runner) y la sintaxis:** Pasamos de usar `flutter_test` y el lenguaje Dart en Flutter, a usar `vitest` y JavaScript en React. Esto demuestra que las pruebas viajan conceptualmente, aunque el archivo físico de pruebas no viaje byte por byte.

## 5. Cambios en el Plan (El CÓMO)
A diferencia de la spec, el plan sí se rehace casi por completo porque representa las decisiones tecnológicas. Al comparar el plan de Flutter con el de React, estas tres cosas dejaron de tener sentido y se adaptaron:
1. **La estructura y extensiones de archivos:** Pasamos de usar la carpeta `lib/` con archivos `.dart` a usar la carpeta `src/` con archivos `.js` y `.jsx`.
2. **El manejo del estado local:** Dejamos atrás las herramientas de estado de Flutter (StatefulWidgets) y en el plan nuevo se especificó usar estado local con `useState` (un hook de React en `useDivisor.js`).
3. **La capa de presentación:** En lugar de crear un `DivisorController` y widgets de Flutter, el plan de React definió la creación de `PantallaDivisor.jsx` para dibujar la interfaz usando componentes web.

## 6. Reflexión Técnica: Artefactos más y menos reusables
* **El artefacto MÁS reusable:** Fue la **Especificación (`spec.md`)** y, conceptualmente, los **Casos de Prueba**. Al contener puramente las reglas de negocio y el QUÉ, sobrevivieron al cambio de tecnología sin alteraciones estructurales.
* **El artefacto MENOS reusable:** Fue el **Código fuente (`src/`)**, el **Plan (`plan.md`)** y las **Tareas (`tasks.md`)**. Como estos artefactos detallan el CÓMO y están acoplados al framework de turno (librerías, extensiones, sintaxis de React vs Flutter), tuvieron que rehacerse desde cero usando el agente. 

*Conclusión final:* Este ejercicio me demostró que separar las responsabilidades no es solo para tener un "código bonito", sino para proteger el conocimiento del sistema. Si el día de mañana el cliente nos pide esta app en una terminal de Python, el 85% de nuestro trabajo intelectual (la spec) seguirá intacto.