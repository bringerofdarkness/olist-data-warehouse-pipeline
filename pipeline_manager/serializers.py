from rest_framework import serializers
from .models import PipelineRuns, PipelineSteps

class PipelineStepsSerializer(serializers.ModelSerializer):
    class Meta:
        model = PipelineSteps
        fields = '__all__'

class PipelineRunsSerializer(serializers.ModelSerializer):
    steps = PipelineStepsSerializer(many=True, read_only=True)

    class Meta:
        model = PipelineRuns
        fields = ['run_id', 'start_time', 'end_time', 'status', 'steps']