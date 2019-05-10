from datetime import datetime, timedelta

from django.conf import settings
from django.contrib.auth import get_user_model
from django.utils.timezone import make_aware


def activation_deadline():
    deadline = datetime.now() - timedelta(days=settings.ACCOUNT_ACTIVATION_DAYS)
    return make_aware(deadline)


# TODO: make this a (huey?) cron task/job
def delete_stale_users():
    User = get_user_model()
    stale_users = User.objects.filter(is_active=False, last_login=None,
                                      date_joined__lte=activation_deadline())
    # TODO: log operation
    stale_users.delete()
