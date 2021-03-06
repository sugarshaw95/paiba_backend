# -*- coding: utf-8 -*-
from __future__ import unicode_literals, absolute_import

from django.contrib.auth.models import AbstractUser
from django.core.urlresolvers import reverse
from django.db import models
from django.utils.encoding import python_2_unicode_compatible
from django.utils.translation import ugettext_lazy as _


@python_2_unicode_compatible
class User(AbstractUser):

    name = models.CharField(_('Nickname of User'), blank = True, max_length = 127)
    GENDER_CHOICES = (
    ('M', 'male'),
    ('W', 'female'),
    ('U', 'unknown'),)
    gender = models.CharField(_('Gender'), max_length = 8, choices = GENDER_CHOICES, default = 'U')
    portrait = models.ImageField(_('Portrait'), upload_to = 'portraits/')

    def __str__(self):
        return self.username

    def get_absolute_url(self):
        return reverse('users:detail', kwargs={'username': self.username})
