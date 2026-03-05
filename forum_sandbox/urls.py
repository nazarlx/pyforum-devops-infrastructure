"""
Forum URL Configuration

The `urlpatterns` list routes URLs to views.
"""

from django.contrib import admin
from django.urls import include, path
from django.conf import settings
from django.conf.urls.static import static
from django.http import JsonResponse


# --- Health check view ---
def health(request):
    return JsonResponse({"status": "ok"})


urlpatterns = [
    # Health endpoint (must be first!)
    path("health/", health),

    # App routes
    path("", include("profiles.urls")),
    path("", include("authentication.urls")),
    path("", include("administration.urls")),
]

# Media files in DEBUG
if settings.DEBUG:
    urlpatterns += static(
        settings.MEDIA_URL,
        document_root=settings.MEDIA_ROOT
    )
