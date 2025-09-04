




from django.urls import path
from .views import EncuestasView, EncuestaDetailView, ResponderEncuestaView

urlpatterns = [
    path('encuestas/', EncuestasView.as_view()),
    path('encuestas/<int:pk>/', EncuestaDetailView.as_view()),
    path('encuestas/responder/', ResponderEncuestaView.as_view()),
]