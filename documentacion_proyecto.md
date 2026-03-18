# Documentación del Proyecto - VETASOFT Mobile

Este documento proporciona una visión general técnica de la implementación del proyecto VETASOFT Mobile, incluyendo tanto el backend como el frontend.

## 🏗️ Arquitectura General

El sistema sigue una arquitectura cliente-servidor:
- **Backend**: API REST construida con Node.js y Express.
- **Frontend**: Aplicación móvil multiplataforma desarrollada con Flutter.
- **Base de Datos**: MySQL para el almacenamiento persistente.

---

## 🖥️ Backend (Node.js)

### Estructura de Carpetas
- `src/config/`: Configuraciones de base de datos y variables de entorno.
- `src/controllers/`: Lógica de control que procesa las peticiones.
- `src/models/`: Interacción directa con la base de datos (Consultas SQL).
- `src/routes/`: Definición de los endpoints de la API.
- `src/middleware/`: Filtros de seguridad (como la verificación de tokens JWT).

### Tecnologías Clave
- **Express**: Framework web.
- **JWT (jsonwebtoken)**: Autenticación basada en tokens.
- **Bcrypt**: Encriptación de contraseñas.
- **Dotenv**: Gestión de variables de configuración.

### Funcionalidades Implementadas
1. **Autenticación**: Login seguro y verificación de sesión.
2. **Sincronización de Estado**: Al loguearse, el usuario pasa automáticamente a estado "Activo" en la DB.
3. **CRUD de Estados**: Gestión completa (Crear, Leer, Actualizar, Borrar) de la tabla `user_status`.

---

## 📱 Frontend (Flutter)

### Estructura de Carpetas
- `lib/screens/`: Interfaces de usuario (Login, Home, Status).
- `lib/services/`: Clientes para consumir la API.
- `lib/utils/`: Funciones de ayuda (como el decodificador de JWT).
- `lib/main.dart`: Punto de entrada de la aplicación y definición de rutas.

### Tecnologías Clave
- **Flutter SDK**: Framework UI.
- **HTTP Package**: Para peticiones a la API.
- **Secure Storage**: Gestión segura de tokens en el dispositivo.

### Funcionalidades Implementadas
1. **Interfaz Premium**: Diseño moderno con gradientes, animaciones y sombras.
2. **Gestión de Estados**: Pantalla interactiva para administrar los estados de usuario con confirmaciones de borrado.
3. **Dashboard Informativo**: Pantalla de inicio que muestra datos del usuario autenticado.

---

## 🚀 Configuración y Ejecución

### Backend
1. Navegar a la carpeta `back/`.
2. Instalar dependencias: `npm install`.
3. Configurar el archivo `.env` con las credenciales de DB y `JWT_SECRET`.
4. Ejecutar: `npm start` (o `npm run dev`).

### Frontend
1. Navegar a la carpeta `frontend/`.
2. Instalar dependencias: `flutter pub get`.
3. Asegurarse de tener la API corriendo.
4. Ejecutar: `flutter run`.

---

## 🔧 Notas de Mantenimiento
- Para el desarrollo local en Android, usar `10.0.2.2` en lugar de `localhost` si se usa el emulador.
- Los cambios en los modelos del backend se reflejan automáticamente en la API sin necesidad de cambiar el frontend, siempre que la estructura de los datos se mantenga.
