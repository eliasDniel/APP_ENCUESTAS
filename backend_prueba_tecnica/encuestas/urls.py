




from django.urls import path
from .views import EncuestaResultadosAdminView, EncuestasView, EncuestaDetailView, ResponderEncuestaView, EncuestaDeleteView

urlpatterns = [
    path('encuestas/', EncuestasView.as_view()),
    path('encuestas/<int:pk>/', EncuestaDetailView.as_view()),
    path('encuestas/responder/', ResponderEncuestaView.as_view()),
    path('encuestas/<int:pk>/eliminar/', EncuestaDeleteView.as_view(), name='encuesta-eliminar'),
    path('encuestas/<int:pk>/resultados/', EncuestaResultadosAdminView.as_view()),
]