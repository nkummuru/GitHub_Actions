from locust import HttpUser, task, between

class LoadTestUser(HttpUser):
    """
    Simulates user scenarios based on application API endpoints.
    """
    wait_time = between(1, 3)  # Users wait 1-3 seconds between tasks

    @task(1)
    def test_root_endpoint(self):
        """
        Test the application's root endpoint.
        """
        self.client.get("/")

    @task(2)
    def test_api_endpoint(self):
        """
        Test the application's `/api/data` endpoint.
        """
        self.client.get("/api/data")

    @task(3)
    def test_form_submission(self):
        """
        Simulate a form submit workflow.
        """
        self.client.post("/form", json={"field1": "value1"})

