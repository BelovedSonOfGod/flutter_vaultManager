

# Big picture arquitecture

1. We have different layers, like security layer, UI layer, etc which translates to folders with classes, and they are not dependant of each other
2. We need a file which would be called orchestrator or something like that, that calls each actor based upon what is going on


## My learnings
- You can avoid using prints, to avoid reaching prod with them with
```dart
import 'package:flutter/foundation.dart'; // Import this to use kDebugMode

void logDebug(String message) {
  if (kDebugMode) {
    print(message); // Or debugPrint(message);
  }
}

```
- final es que solo se queda con ese valor por instancia.... los campos final solo pueden inicializarse en la lista de inicialización del constructor, no dentro del cuerpo.
- No es recomendable dejar algo como static late, ya que se puede acceder desde ya sin haber instanciado por static y con late tampoco es seguro por que el compilador deja de evitar que tenga un valor lo cual si se intenta acceder sin estar inicializado puede causar errores.
- El logging debe estar: arriba (manager) o en infraestructura común

1. Imports y estructura de tests
Los archivos en test/ no se importan como paquete.

Para usar el framework de pruebas:

package:test/test.dart → pruebas unitarias puras de Dart.

package:flutter_test/flutter_test.dart → pruebas de Flutter (con bindings).

Tu código propio se importa desde lib/ con:

dart
import 'package:vault_manager/storage_layer/vault_storage_class.dart';
2. Inicialización del binding
En tests de Flutter, hay que llamar a:

dart
TestWidgetsFlutterBinding.ensureInitialized();
Esto inicializa el entorno de Flutter, pero no carga implementaciones nativas de plugins.

3. Problemas con plugins (path_provider)
En unit tests (flutter test), los plugins nativos no funcionan → aparece MissingPluginException.

Soluciones:

Mockear el plugin en tests unitarios.

Usar integration tests en un emulador/dispositivo real (Pixel 7, iPhone, etc.), donde sí se cargan los plugins.

4. Diferencia entre unit tests e integration tests
Unit tests: corren en el runner de Dart, sin Android/iOS.

Integration tests: corren en un emulador/dispositivo, con plugins disponibles.

En VS Code, launch.json solo soporta "type": "dart". Para integration tests, se corre con:

bash
flutter test integration_test
5. Ejecución en Chrome vs emulador
En Chrome/web, los plugins como path_provider no tienen implementación.

En emulador/dispositivo, sí funcionan.

Por eso tus pruebas pasaron correctamente al correr en el Pixel 7.

6. Validaciones en tests
Tus pruebas iniciales (not null, not empty) pasaron ✅.

Puedes imprimir la ruta para depuración, aunque no es obligatorio.

Para pruebas más completas:

Escritura y lectura de archivos con File.writeAsString y File.readAsString.

Usar setUp y tearDown para preparar/limpiar antes y después de cada test.

Evitar depender del orden de ejecución; si necesitas secuencia, hazlo dentro de un mismo test o group.

✅ Conclusión
El problema inicial era por imports incorrectos y falta de binding.

El error de MissingPluginException se debe a que los plugins no funcionan en unit tests.

La solución fue mover las pruebas a integration tests y correrlas en un emulador Pixel 7.

Tus pruebas ya pasaron y ahora puedes extenderlas para validar lectura/escritura y limpieza de archivos.



🔹 launch.json en VS Code para Flutter/Dart
1. Tipos soportados
VS Code solo soporta "type": "dart" en launch.json.

No existe "type": "flutter", por eso te marcaba “debug type flutter is not supported”.

El plugin de Dart/Flutter interpreta "type": "dart" tanto para unit tests como para integration tests.

2. Unit tests vs Integration tests
Unit tests (test/):
Se corren con el runner de Dart (flutter test). No cargan plugins nativos.
Ejemplo de config:

json
{
  "name": "Debug Unit Test Vault Storage",
  "type": "dart",
  "request": "launch",
  "program": "test/vault_storage_class_test.dart"
}
Integration tests (integration_test/):
Se corren en un emulador/dispositivo con flutter test integration_test. Aquí sí funcionan los plugins como path_provider.
Ejemplo de config:

json
{
  "name": "Debug Integration Test Vault Storage",
  "type": "dart",
  "request": "launch",
  "program": "integration_test/vault_storage_class_integration_test.dart"
}
3. Ejecución práctica
Si corres con "type": "dart" y el archivo está en test/, se ejecuta como unit test (sin plugins).

Si corres con "type": "dart" y el archivo está en integration_test/, VS Code lanza la app en el emulador/dispositivo y los plugins sí funcionan.

Por eso tus pruebas pasaron en el Pixel 7, pero no en Chrome.

4. Recomendación
Mantén dos configuraciones en launch.json: una para unit tests y otra para integration tests.

Usa el emulador/dispositivo para los tests que dependen de plugins.

Usa el runner normal para lógica pura Dart.