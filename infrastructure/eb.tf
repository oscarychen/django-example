resource "aws_elastic_beanstalk_application" "this" {
  name        = "django-experiment-app"
  description = "Django example application"
}

resource "aws_elastic_beanstalk_environment" "this" {
  name                = "django-experiment-env"
  description         = "Django example environment"
  application         = aws_elastic_beanstalk_application.this.name
  solution_stack_name = "64bit Amazon Linux 2 v3.5.6 running Docker"

  wait_for_ready_timeout = "20m"

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = "aws-elasticbeanstalk-ec2-role"
  }
}
