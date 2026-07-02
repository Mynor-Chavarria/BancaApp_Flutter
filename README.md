# Banca App (Flutter)

Aplicación móvil Flutter para flujo bancario (login, dashboard, transferencias, historial y ajustes).

## Requisitos

- Flutter SDK instalado
- Dart SDK `^3.7.2` (incluido con Flutter compatible)
- Xcode (iOS) y/o Android Studio + SDK (Android)

Verifica instalación:

```bash
flutter --version
flutter doctor
```

## Inicio rápido

1. Instala dependencias:

```bash
flutter pub get
```

2. Ejecuta la app:

```bash
flutter run
```

> También puedes ejecutar explícitamente el entrypoint de desarrollo:

```bash
flutter run -t lib/main_dev.dart
```

## Configuración de entorno

La app usa archivos JSON por entorno y carga valores desde `Env`.

- Desarrollo: `env_dev.json`
- Staging: `env_staging.json`
- Producción: `env_prod.json`

Ejemplo mínimo de `env_dev.json`:

```json
{
  "appName": "Banca App",
  "apiUrl": "https://api.ejemplo.com",
  "apiKey": "TU_API_KEY"
}
```

## Estructura del proyecto

```text
lib/
	app/
		presentation/
	core/
		environmet/
	features/
		dashboard/
		history/
		login/
		settings/
		transfers/
	l10n/
	main.dart
	main_dev.dart
```

## Localización

El proyecto tiene soporte de idiomas con archivos ARB:

- `lib/l10n/app_es.arb`
- `lib/l10n/app_en.arb`

Si cambias traducciones, ejecuta:

```bash
flutter gen-l10n
```

## Comandos útiles

```bash
flutter analyze
flutter test
```

## Generación de código

El proyecto usa `freezed` y `json_serializable` para generar código boilerplate (modelos inmutables, `fromJson`/`toJson`, `copyWith`, etc.).

Los archivos generados tienen extensión `.freezed.dart` y `.g.dart`. **No los edites manualmente.**

### Generar una sola vez

```bash
dart run build_runner build --delete-conflicting-outputs
```

### Modo watch (regenera automáticamente al guardar)

```bash
dart run build_runner watch --delete-conflicting-outputs
```

### Solo generar localizaciones

```bash
flutter gen-l10n
```

> Ejecuta `build_runner` cada vez que agregues o modifiques una clase anotada con `@freezed` o `@JsonSerializable`.

## Git (opcional, si inicias repo local)

Si este proyecto aún no tiene repositorio Git:

```bash
git init
git config user.name "Tu Nombre"
git config user.email "tu-correo@ejemplo.com"
git add .
git commit -m "Initial commit"
```
