
from rest_framework import serializers
from .models import Respuesta
from rest_framework import serializers
from .models import Encuesta, Pregunta, Opcion
class EncuestaListSerializer(serializers.ModelSerializer):
    creada_por = serializers.StringRelatedField()
    fecha_creacion = serializers.DateTimeField(format="%Y-%m-%d %H:%M:%S")
    cantidad_preguntas = serializers.SerializerMethodField()
    estado = serializers.SerializerMethodField()

    class Meta:
        model = Encuesta
        fields = ['id', 'titulo', 'descripcion', 'creada_por', 'fecha_creacion', 'cantidad_preguntas', 'estado']
        
    def get_cantidad_preguntas(self, obj):
        return obj.preguntas.count()

    def get_estado(self, obj):
        user = self.context.get('user')
        if not user or user.is_anonymous:
            return 'Pendiente'
        if Respuesta.objects.filter(usuario=user, encuesta=obj).exists():
            return 'Completada'
        return 'Pendiente'



class OpcionSerializer(serializers.ModelSerializer):
    class Meta:
        model = Opcion
        fields = ['texto']

class PreguntaSerializer(serializers.ModelSerializer):
    opciones = OpcionSerializer(many=True)

    class Meta:
        model = Pregunta
        fields = ['texto', 'tipo', 'opciones']

class EncuestaSerializer(serializers.ModelSerializer):
    preguntas = PreguntaSerializer(many=True)

    class Meta:
        model = Encuesta
        fields = ['id', 'titulo', 'descripcion', 'preguntas']

    def create(self, validated_data):
        preguntas_data = validated_data.pop('preguntas')
        encuesta = Encuesta.objects.create(**validated_data)
        for pregunta_data in preguntas_data:
            opciones_data = pregunta_data.pop('opciones')
            pregunta = Pregunta.objects.create(encuesta=encuesta, **pregunta_data)
            for opcion_data in opciones_data:
                Opcion.objects.create(pregunta=pregunta, **opcion_data)
        return encuesta
