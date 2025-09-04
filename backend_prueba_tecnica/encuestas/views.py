from django.shortcuts import render
from rest_framework.views import APIView
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from .models import Encuesta
from .serializers import EncuestaSerializer, EncuestaListSerializer, RespuestaClienteSerializer
from .models import Pregunta, Opcion, Respuesta
from rest_framework import status
from rest_framework.generics import get_object_or_404
from rest_framework.permissions import IsAdminUser

class ResponderEncuestaView(APIView):
    permission_classes = [IsAuthenticated]
    def post(self, request):
        serializer = RespuestaClienteSerializer(data=request.data, context={'request': request})
        if serializer.is_valid():
            user = request.user
            encuesta_id = serializer.validated_data['encuesta_id']
            respuestas = serializer.validated_data['respuestas']
            encuesta = Encuesta.objects.get(id=encuesta_id)
            for r in respuestas:
                pregunta = Pregunta.objects.get(id=r['pregunta_id'])
                opcion = None
                respuesta_texto = r.get('respuesta_texto')
                opcion_id = r.get('opcion_id')
                if opcion_id:
                    opcion = Opcion.objects.get(id=opcion_id)
                Respuesta.objects.create(
                    usuario=user,
                    encuesta=encuesta,
                    pregunta=pregunta,
                    opcion=opcion,
                    respuesta_texto=respuesta_texto
                )
            serializer = EncuestaListSerializer([encuesta], many=True, context={'user': user})
            return Response(serializer.data[0], status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class EncuestaDetailView(APIView):
    permission_classes = [IsAuthenticated]
    def get(self, request, pk):
        encuesta = get_object_or_404(Encuesta, pk=pk)
        serializer = EncuestaSerializer(encuesta, context={'user': request.user})
        return Response(serializer.data, status=status.HTTP_200_OK)

class EncuestasView(APIView):
    permission_classes = [IsAuthenticated]
    def get(self, request):
        page = int(request.query_params.get('page', 1))
        limit = 10
        offset = (page - 1) * limit
        user = request.user
        if user.is_staff:
            queryset = Encuesta.objects.filter(creada_por=user)
        else:
            queryset = Encuesta.objects.all()
        total = queryset.count()
        encuestas = queryset[offset:offset+limit]
        serializer = EncuestaListSerializer(encuestas, many=True, context={'user': user})
        return Response({
            'results': serializer.data,
            'total': total,
            'page': page,
            'limit': limit
        }, status=status.HTTP_200_OK)

    def post(self, request):
        data = request.data.copy()
        serializer = EncuestaSerializer(data=data)
        if serializer.is_valid():
            encuesta = serializer.save(creada_por=request.user)
            serializer = EncuestaListSerializer([encuesta], many=True, context={'user': request.user})
            return Response(serializer.data[0], status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class EncuestaResultadosAdminView(APIView):
    permission_classes = [IsAuthenticated, IsAdminUser]
    def get(self, request, pk):
        encuesta = get_object_or_404(Encuesta, pk=pk)
        preguntas = encuesta.preguntas.all()
        resultados = []

        for pregunta in preguntas:
            opciones = pregunta.opciones.all()
            opciones_resultado = []
            for opcion in opciones:
                respuestas_opcion_qs = Respuesta.objects.filter(
                    encuesta=encuesta,
                    pregunta=pregunta,
                    opcion=opcion
                )
                count = respuestas_opcion_qs.count()
                usuarios = [
                    {
                        'usuario_id': r.usuario.id,
                        'usuario': r.usuario.name
                    }
                    for r in respuestas_opcion_qs
                ]
                opciones_resultado.append({
                    'opcion_id': opcion.id,
                    'texto': opcion.texto,
                    'count_respuestas_option': count,
                    'usuarios': usuarios
                })
            respuestas_abiertas_qs = Respuesta.objects.filter(
                encuesta=encuesta,
                pregunta=pregunta,
                opcion=None
            ).exclude(respuesta_texto__isnull=True).exclude(respuesta_texto__exact='')
            respuestas_abiertas = [
                {
                    'usuario_id': r.usuario.id,
                    'usuario': r.usuario.name,
                    'respuesta_texto': r.respuesta_texto
                }
                for r in respuestas_abiertas_qs
            ]

            resultados.append({
                'pregunta_id': pregunta.id,
                'texto': pregunta.texto,
                'opciones': opciones_resultado,
                'count_respuestas_abiertas': len(respuestas_abiertas),
                'respuestas_abiertas': respuestas_abiertas
            })

        return Response({
            'encuesta_id': encuesta.id,
            'titulo': encuesta.titulo,
            'resultados': resultados
        }, status=status.HTTP_200_OK)

