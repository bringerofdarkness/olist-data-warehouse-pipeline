from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from .models import PipelineRuns
from .serializers import PipelineRunsSerializer
from .tasks import run_olist_data_pipeline

class TriggerPipelineView(APIView):
    def post(self, request):
        task = run_olist_data_pipeline.delay()
        return Response(
            {"message": "Pipeline triggered successfully", "celery_task_id": task.id},
            status=status.HTTP_202_ACCEPTED
        )

class PipelineStatusListView(APIView):
    def get(self, request):
        runs = PipelineRuns.objects.prefetch_related('steps').order_by('-run_id')[:10]
        serializer = PipelineRunsSerializer(runs, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)