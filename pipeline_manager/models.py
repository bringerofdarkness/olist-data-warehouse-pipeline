from django.db import models

class PipelineRuns(models.Model):
    run_id = models.AutoField(primary_key=True)
    start_time = models.DateTimeField()
    end_time = models.DateTimeField(blank=True, null=True)
    status = models.CharField(max_length=20)

    class Meta:
        managed = False
        db_table = 'pipeline_runs'

class PipelineSteps(models.Model):
    step_id = models.AutoField(primary_key=True)
    run = models.ForeignKey(PipelineRuns, on_delete=models.CASCADE, db_column='run_id', related_name='steps')
    step_name = models.CharField(max_length=255)
    start_time = models.DateTimeField()
    end_time = models.DateTimeField(blank=True, null=True)
    status = models.CharField(max_length=20)

    class Meta:
        managed = False
        db_table = 'pipeline_steps'
