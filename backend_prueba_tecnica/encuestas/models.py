from django.db import models
from django.conf import settings

class Encuesta(models.Model):
    titulo = models.CharField(max_length=255)
    descripcion = models.TextField(blank=True, null=True)
    creada_por = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name="encuestas_creadas"
    )
    fecha_creacion = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.titulo


class Pregunta(models.Model):
    TIPO_RESPUESTA = [
        ("opcion_libre", "Opción Libre"),
        ("opcion_multiple", "Opción múltiple"),
    ]

    encuesta = models.ForeignKey(
        Encuesta,
        on_delete=models.CASCADE,
        related_name="preguntas"
    )
    texto = models.CharField(max_length=500)
    tipo = models.CharField(max_length=20, choices=TIPO_RESPUESTA, default="texto")

    def __str__(self):
        return self.texto


class Opcion(models.Model):
    pregunta = models.ForeignKey(
        Pregunta,
        on_delete=models.CASCADE,
        related_name="opciones"
    )
    texto = models.CharField(max_length=255)

    def __str__(self):
        return self.texto


class Respuesta(models.Model):
    usuario = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name="respuestas"
    )
    encuesta = models.ForeignKey(
        Encuesta,
        on_delete=models.CASCADE,
        related_name="respuestas"
    )
    pregunta = models.ForeignKey(
        Pregunta,
        on_delete=models.CASCADE,
        related_name="respuestas"
    )
    opcion = models.ForeignKey(
        Opcion,
        on_delete=models.CASCADE,
        blank=True,
        null=True,
        related_name="respuestas"
    )
    respuesta_texto = models.TextField(blank=True, null=True)
    fecha_respuesta = models.DateTimeField(auto_now_add=True)


    class Meta:
        pass  # Ya no se restringe a una sola respuesta por usuario y encuesta

    def __str__(self):
        return f"{self.usuario} - {self.encuesta}"

