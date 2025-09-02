from django.urls import path
from .views import RegisterView, UserView
from rest_framework_simplejwt.views import TokenRefreshView
from .custom_token import CustomTokenObtainPairView

urlpatterns = [
    path('register', RegisterView.as_view()),
    path('user', UserView.as_view()),
    path('login', CustomTokenObtainPairView.as_view(), name='token_obtain_pair')
]