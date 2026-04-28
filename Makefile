.PHONY: get gen watch clean fix run

get:
	flutter pub get

gen:
	dart run build_runner build --delete-conflicting-outputs

watch:
	dart run build_runner watch --delete-conflicting-outputs

clean:
	flutter clean
	flutter pub get

fix:
	dart fix --apply

run:
	flutter run