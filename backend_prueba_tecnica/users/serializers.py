from rest_framework import serializers
from .models import User


class LoginUserSerializer(serializers.ModelSerializer):
    fullName = serializers.CharField(source='name')
    isActive = serializers.BooleanField(source='is_active')
    roles = serializers.SerializerMethodField()
    class Meta:
        model = User
        fields = ['id', 'email', 'fullName', 'isActive', 'roles']

    def get_roles(self, obj):
        return ['admin'] if obj.is_staff else ['customer']
    

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['id', 'email', 'password', 'name', 'device_token']  # Asegúrate de incluir device_token
        extra_kwargs = {
            'password': {'write_only': True}
        }

    def create(self, validated_data):
        password = validated_data.pop('password')
        user = User(**validated_data)
        user.set_password(password)
        user.save()
        return user