from rest_framework_simplejwt.views import TokenObtainPairView
from rest_framework_simplejwt.serializers import TokenObtainPairSerializer
from .serializers import LoginUserSerializer

from rest_framework_simplejwt.views import TokenObtainPairView
from rest_framework_simplejwt.serializers import TokenObtainPairSerializer
from .serializers import LoginUserSerializer
from rest_framework import serializers

class CustomTokenObtainPairSerializer(TokenObtainPairSerializer):
    device_token = serializers.CharField(required=False, write_only=True)
    @classmethod
    def get_token(cls, user):
        token = super().get_token(user)
        return token

    def validate(self, attrs):
        device_token = attrs.pop('device_token', None)
        data = super().validate(attrs)
        user = self.user

        # Actualiza el device_token si se proporciona
        if device_token:
            user.device_token = device_token
            user.save(update_fields=['device_token'])

        user_data = LoginUserSerializer(user).data
        user_data['token'] = data['access']
        return user_data

class CustomTokenObtainPairView(TokenObtainPairView):
    serializer_class = CustomTokenObtainPairSerializer
