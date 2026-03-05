from django.shortcuts import render
from django.views import View
from django.http import JsonResponse

from rest_framework.views import APIView
from rest_framework.response import Response

from profiles.models import SavedCompany, ProfilesImage


class MainPageView(View):
    def get(self, request, *args, **kwargs):
        latest_saved_companies = SavedCompany.objects.order_by("-added_at")[:6]

        clients = []
        for saved in latest_saved_companies:
            profile = saved.company
            image = ProfilesImage.objects.filter(profile_id_id=profile.id).order_by("-id").first()

            clients.append({
                "official_name": profile.official_name,
                "address": profile.address,
                "image": f"/media/{image.path}/{image.name}" if image else None,
            })

        return render(request, "main_page/index.html", {
            "clients": clients
        })


class MainPageApiView(APIView):
    def get(self, request, *args, **kwargs):
        latest_saved_companies = SavedCompany.objects.order_by("-added_at")[:6]

        data = []
        for saved in latest_saved_companies:
            profile = saved.company
            image = ProfilesImage.objects.filter(profile_id_id=profile.id).order_by("-id").first()

            data.append({
                "official_name": profile.official_name,
                "address": profile.address,
                "image": {
                    "name": image.name,
                    "path": image.path
                } if image else None
            })

        return Response({
            "clients": data
        })
