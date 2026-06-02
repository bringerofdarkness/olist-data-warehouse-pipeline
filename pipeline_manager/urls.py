from django.urls import path
from .views import TriggerPipelineView, PipelineStatusListView

urlpatterns = [
    path('trigger/', TriggerPipelineView.as_view(), name='trigger-pipeline'),
    path('status/', PipelineStatusListView.as_view(), name='pipeline-status-list'),
]