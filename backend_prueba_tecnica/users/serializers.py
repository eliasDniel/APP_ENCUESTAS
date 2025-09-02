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
        fields = ['id', 'name', 'email', 'password']
        extra_kwargs = {
            'password': {'write_only': True}
        }

    def create(self, validated_data):
        password = validated_data.pop('password', None)
        instance = self.Meta.model(**validated_data)
        if password is not None:
            instance.set_password(password)
        instance.save()
        return instance