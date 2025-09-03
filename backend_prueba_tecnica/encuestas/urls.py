




from django.urls import path
from .views import EncuestasView

urlpatterns = [
    path('encuestas/', EncuestasView.as_view()),
]