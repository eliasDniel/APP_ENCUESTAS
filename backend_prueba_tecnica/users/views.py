from .serializers import LoginUserSerializer
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated, AllowAny
from rest_framework_simplejwt.tokens import RefreshToken
from .serializers import UserSerializer

class UserView(APIView):
    permission_classes = [IsAuthenticated]
    def get(self, request):
        serializer = LoginUserSerializer(request.user)
        return Response(serializer.data)

class RegisterView(APIView):
    permission_classes = [AllowAny]
    def post(self, request):
        serializer = UserSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        user = serializer.save()
        refresh = RefreshToken.for_user(user)
        user_data = LoginUserSerializer(user).data
        user_data['token'] = str(refresh.access_token)
        return Response(user_data)



