# ETM-Orexe-Elias-Ramos - Proyecto Encuestas

Este repositorio contiene el desarrollo completo de una aplicación de encuestas, abarcando tanto el backend (API REST con Django) como el frontend (aplicación Flutter). El objetivo es ofrecer una solución escalable y mantenible para la gestión y participación en encuestas.

## Estructura del proyecto

```
ETM-Orexe-Elias-Ramos/
├── backend_prueba_tecnica/   # Backend: API REST en Django
└── frontend_encuestas/       # Frontend: App Flutter multiplataforma
```

## Estado actual
- **Backend:**
  - Autenticación de usuarios (registro, login, token personalizado)
  - Estructura modular y lista para expandirse (encuestas, respuestas, administración, etc.)
- **Frontend:**
  - Estructura inicial de proyecto Flutter creada
  - Próximamente: integración con la API y desarrollo de interfaces de usuario

## Tecnologías principales
- **Backend:** Python, Django, Django REST Framework, Postgres
- **Frontend:** Flutter, Dart

## Instalación y ejecución

### Backend
1. Navega a la carpeta del backend:
   ```bash
   cd backend_prueba_tecnica
   ```
2. Instala dependencias y ejecuta migraciones:
   ```bash
   pip install -r requirements.txt
   python manage.py migrate
   python manage.py runserver
   ```

### Frontend
1. Navega a la carpeta del frontend:
   ```bash
   cd frontend_encuestas
   ```
2. Instala dependencias:
   ```bash
   flutter pub get
   ```
3. Ejecuta la app en el emulador o dispositivo:
   ```bash
   flutter run
   ```

## Expansión futura
Este README está diseñado para ser escalable. A medida que el proyecto avance, se podrán agregar secciones como:
- Documentación de endpoints y ejemplos de uso
- Guía de despliegue en producción
- Pruebas automatizadas (backend y frontend)
- Contribuciones, licencias y autores
- Integración continua y despliegue automatizado

## Notas
- El backend y el frontend están desacoplados, permitiendo desarrollos y despliegues independientes.
- La comunicación entre ambos se realiza vía API REST.

---

> Última actualización: 02 Septiembre 2025
