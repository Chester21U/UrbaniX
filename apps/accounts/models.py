from django.contrib.auth.models import AbstractUser
from django.db import models


class User(AbstractUser):
    class Rol(models.TextChoices):
        CIUDADANO = "ciudadano", "Ciudadano"
        OPERADOR = "operador", "Operador municipal"
        CUADRILLA = "cuadrilla", "Cuadrilla"
        ADMINISTRADOR = "administrador", "Administrador"

    email = models.EmailField("correo electrónico", unique=True)
    rol = models.CharField(max_length=20, choices=Rol.choices, default=Rol.CIUDADANO)
    telefono = models.CharField("teléfono", max_length=15, blank=True)

    class Meta:
        verbose_name = "usuario"
        verbose_name_plural = "usuarios"

    def __str__(self):
        return self.get_full_name() or self.username
