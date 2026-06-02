import os
import subprocess
from celery import shared_task
from .models import PipelineRuns, PipelineSteps

@shared_task(bind=True)
def run_olist_data_pipeline(self):
    script_path = os.path.join(os.getcwd(), 'core_pipeline', 'run_pipeline.py')
    
    if not os.path.exists(script_path):
        return {"status": "FAILED", "error": f"Script not found at {script_path}"}
        
    try:
        process = subprocess.Popen(
            ['python', script_path],
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True
        )
        
        stdout, stderr = process.communicate()
        
        if process.returncode == 0:
            return {"status": "SUCCESS", "output": stdout}
        else:
            return {"status": "FAILED", "error": stderr}
            
    except Exception as e:
        return {"status": "FAILED", "error": str(e)}