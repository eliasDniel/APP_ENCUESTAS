from django.urls import path
from .views import RegisterView, UserView
from rest_framework_simplejwt.views import TokenRefreshView
from .custom_token import CustomTokenObtainPairView

urlpatterns = [
    path('auth/register', RegisterView.as_view()),
    path('auth/check-status', UserView.as_view()),
    path('auth/login', CustomTokenObtainPairView.as_view(), name='token_obtain_pair')
]