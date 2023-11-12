from django.urls import path
from . import views # this import refers to your views.py

urlpatterns = [
    # your HTTP endpoints here
    path('example/', views.example_view), 
]

