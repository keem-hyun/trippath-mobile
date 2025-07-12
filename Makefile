# Makefile
.PHONY: clean build watch test

clean:
	fvm flutter clean
	fvm flutter pub get

build:  # 이제 'make build'만 입력하면 됩니다
	fvm flutter pub run build_runner build --delete-conflicting-outputs

watch:  # 파일 변경 감지해서 자동 빌드
	fvm flutter pub run build_runner watch --delete-conflicting-outputs

test:
	fvm flutter test

icon:  # 앱 아이콘을 한 번에 생성
	fvm flutter pub run flutter_launcher_icons

splash:  # 스플래시 스크린도 한 번에
	fvm flutter pub run flutter_native_splash:create

# FVM 관련 명령어
setup:  # 프로젝트 초기 설정
	fvm install
	fvm flutter pub get

upgrade:  # 패키지 업그레이드
	fvm flutter pub upgrade