
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
        fields = ['id', 'texto']

class PreguntaSerializer(serializers.ModelSerializer):
    opciones = OpcionSerializer(many=True)

    class Meta:
        model = Pregunta
        fields = ['id', 'texto', 'tipo', 'opciones']


class EncuestaSerializer(serializers.ModelSerializer):
    preguntas = PreguntaSerializer(many=True)
    estado = serializers.SerializerMethodField()

    class Meta:
        model = Encuesta
        fields = ['id', 'titulo', 'descripcion', 'preguntas','estado']

    def create(self, validated_data):
        preguntas_data = validated_data.pop('preguntas')
        encuesta = Encuesta.objects.create(**validated_data)
        for pregunta_data in preguntas_data:
            opciones_data = pregunta_data.pop('opciones')
            pregunta = Pregunta.objects.create(encuesta=encuesta, **pregunta_data)
            for opcion_data in opciones_data:
                Opcion.objects.create(pregunta=pregunta, **opcion_data)
        return encuesta
    
    def get_estado(self, obj):
        user = self.context.get('user')
        if not user or user.is_anonymous:
            return 'Pendiente'
        if Respuesta.objects.filter(usuario=user, encuesta=obj).exists():
            return 'Completada'
        return 'Pendiente'



# Serializer para recibir respuestas de encuestas
class RespuestaClienteSerializer(serializers.Serializer):
    encuesta_id = serializers.IntegerField()
    respuestas = serializers.ListField(
        child=serializers.DictField(
            child=serializers.CharField()
        )
    )

    def validate(self, data):
        from .models import Encuesta, Pregunta, Opcion, Respuesta
        user = self.context['request'].user
        encuesta_id = data['encuesta_id']
        respuestas = data['respuestas']
        # Validar que la encuesta existe
        try:
            encuesta = Encuesta.objects.get(id=encuesta_id)
        except Encuesta.DoesNotExist:
            raise serializers.ValidationError('La encuesta no existe.')
        # Validar que el usuario no haya respondido ya
        if Respuesta.objects.filter(usuario=user, encuesta=encuesta).exists():
            raise serializers.ValidationError('Ya has respondido esta encuesta.')
        # Validar preguntas
        pregunta_ids = set(p.id for p in encuesta.preguntas.all())
        for r in respuestas:
            if 'pregunta_id' not in r:
                raise serializers.ValidationError('Falta pregunta_id en una respuesta.')
            if int(r['pregunta_id']) not in pregunta_ids:
                raise serializers.ValidationError(f"Pregunta {r['pregunta_id']} no pertenece a la encuesta.")
        return data
