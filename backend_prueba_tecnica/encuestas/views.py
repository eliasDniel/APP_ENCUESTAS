from django.shortcuts import render
from rest_framework.views import APIView
from rest_framework.permissions import IsAuthenticated
# ...existing code...
from rest_framework.response import Response
# ...existing code...
from .models import Encuesta
from .serializers import EncuestaSerializer, EncuestaListSerializer
from rest_framework import status
# Create your views here.

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
            return Response(EncuestaSerializer(encuesta).data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

