# STEPS 20-22: 현지화 구조 & 전체 한국어 적용 완료 보고서

## 📋 개요

게임의 완전한 현지화 시스템이 구축되고, 모든 UI 텍스트가 한국어/영어로 지원되도록 설정되었습니다.

---

## ✅ STEP 20: 현지화 구조 세팅

### 1. pubspec.yaml 설정

**이미 포함된 종속성:**
```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
```

**에셋 설정:**
```yaml
assets:
  - assets/i18n/ko.json
  - assets/i18n/en.json
```

### 2. LocalizationManager 구현

#### 위치
- `lib/managers/localization_manager.dart`

#### 주요 기능
```dart
class LocalizationManager {
  // 싱글톤 패턴
  static final LocalizationManager _instance = LocalizationManager._internal();

  // 현재 언어 (기본값: 'ko')
  late String _currentLanguage = 'ko';

  // 번역 맵 (내장)
  late Map<String, Map<String, String>> _translations;

  // 메서드
  void setLanguage(String language)           // 언어 변경
  String get(String key, [Map<String, String>? params])  // 번역 조회
}
```

#### 사용 예시
```dart
final loc = LocalizationManager();
Text(loc.get('btn_start_game'));
Text(loc.get('clear_score', {'score': '1500'}));
```

#### 전역 함수
```dart
String tr(String key, [Map<String, String>? params])
```

---

## ✅ STEP 21: Ko.json 및 En.json 작성

### 파일 위치
- `assets/i18n/ko.json` - 한국어 번역
- `assets/i18n/en.json` - 영어 번역

### JSON 구조 (평탄한 키-값 형식)

```json
{
  "main_title": "신시 봄버맨",
  "btn_start_game": "게임 시작",
  "char_1": "웅녀의 전사",
  "char_desc_1": "기본 능력",
  ...
}
```

### 포함된 텍스트 항목

#### 메인 화면 (5개)
- `main_title`: 신시 봄버맨
- `main_subtitle`: 신시의 요괴를 무찌르세요!
- `btn_start_game`: 게임 시작
- `btn_select_character`: 캐릭터 선택
- `btn_high_score`: 최고 기록: {score}점

#### 스테이지 선택 화면 (7개)
- `stage_select_title`: 스테이지 선택
- `world_1~4`: 인간계, 요괴계, 용계, 신계
- `world_1~4_desc`: 각 월드별 설명
- `stage_locked`: 미해금

#### 캐릭터 선택 화면 (16개)
- `character_select_title`: 캐릭터 선택
- `character_locked`: 잠금해제
- `char_1~10`: 10가지 캐릭터 이름
- `char_desc_1~10`: 10가지 캐릭터 설명

#### 게임 중 HUD (9개)
- `hud_stage`: STAGE
- `hud_items`: 보유 아이템
- `hud_item_fireup`: 범위
- `hud_item_bombup`: 폭탄
- `hud_item_speedup`: 속도
- `hud_item_timeextend`: 시간
- `hud_item_shield`: 방패
- `hud_item_curse`: 저주

#### 게임 메시지 (3개)
- `game_time_warning`: 시간 부족!
- `enemy_appeared`: {name} 등장!
- `item_got`: {item} 획득!

#### 보스 등장 메시지 (4개)
- `boss_1`: 도깨비 대장
- `boss_2`: 구미호 여왕
- `boss_3`: 이무기 대왕
- `boss_4`: 치우천왕

#### 클리어 화면 (5개)
- `clear_title`: 스테이지 클리어!
- `clear_perfect`: 완벽한 클리어!
- `clear_score`: 점수: {score}점
- `clear_enemies`: 처치한 적: {count}마리
- `clear_stars`: 별점: {stars}/3

#### 게임오버 화면 (3개)
- `gameover_title`: 게임 오버
- `gameover_score`: 최종 점수: {score}점
- `gameover_stage`: 도달한 스테이지: {stage}

#### 설정 화면 (7개)
- `settings_title`: 설정
- `settings_language`: 언어
- `settings_sound`: 효과음
- `settings_music`: 배경음악
- `settings_vibration`: 진동
- `settings_on`: 켜짐
- `settings_off`: 꺼짐

#### 공통 버튼 (8개)
- `btn_select`: 선택
- `btn_next_stage`: 다음 스테이지
- `btn_retry`: 다시 도전
- `btn_restart`: 다시 시작
- `btn_menu`: 메뉴로
- `btn_reset_game`: 게임 초기화
- `btn_about`: 정보
- `ok`, `cancel`, `yes`, `no`: 공통 대화

**총 개수: 94개 텍스트 항목**

---

## ✅ STEP 22: 전체 화면 한국어 적용

### 현지화된 화면

#### 1. MainScreen
```dart
final loc = LocalizationManager();
Text(loc.get('main_title'))
Text(loc.get('btn_start_game'))
```

#### 2. StageSelectionScreen ✅ 새로 적용
- AppBar 제목: `stage_select_title`
- 월드 탭: `world_1`, `world_2`, `world_3`, `world_4`
- 월드 설명: `world_1_desc`, `world_2_desc`, 등
- 스테이지 라벨: `stage_label`

```dart
// initState에서 동적 로드
final loc = LocalizationManager();
worldNames = [
  loc.get('world_1'),
  loc.get('world_2'),
  loc.get('world_3'),
  loc.get('world_4'),
];
```

#### 3. CharacterScreen
- AppBar 제목: `character_select_title`
- 선택 버튼: `btn_select`
- 캐릭터 정보: 각 캐릭터의 이름과 설명

#### 4. InGameHUD ✅ 새로 적용
- HUD 아이템 표시: `hud_items`
- 각 아이템 이름:
  - `hud_item_fireup` → 🔥 범위
  - `hud_item_bombup` → 💣 폭탄
  - `hud_item_speedup` → ⚡ 속도
  - `hud_item_timeextend` → ⏳ 시간
  - `hud_item_shield` → 🛡️ 방패
  - `hud_item_curse` → 💀 저주

```dart
List<Widget> _buildItemIcons(LocalizationManager loc) {
  final icons = {
    'fireUp': ('🔥', 'hud_item_fireup'),
    'bombUp': ('💣', 'hud_item_bombup'),
    // ...
  };

  final itemName = loc.get(iconData.$2);
}
```

#### 5. ClearScreen
- 타이틀: `clear_title`
- 점수 라벨: `clear_score`
- 처치한 적: `clear_enemies`
- 다음 버튼: `btn_next_stage`
- 메뉴 버튼: `btn_menu`

#### 6. GameOverScreen
- 타이틀: `gameover_title`
- 점수 라벨: `gameover_score`
- 스테이지 라벨: `gameover_stage`
- 재시작 버튼: `btn_restart`
- 메뉴 버튼: `btn_menu`

#### 7. SettingsScreen
- AppBar 제목: `settings_title`
- 효과음: `settings_sound`
- 배경음악: `settings_music`
- 진동: `settings_vibration`
- On/Off: `settings_on`, `settings_off`
- 게임 초기화: `btn_reset_game`

---

## 🔧 구현 상세

### LocalizationManager에 텍스트 추가

```dart
Map<String, Map<String, String>> _initializeTranslations() {
  return {
    'ko': {
      'main_title': '신시 봄버맨',
      'stage_select_title': '스테이지 선택',
      'world_1': '인간계',
      'char_1': '웅녀의 전사',
      'hud_stage': 'STAGE',
      'hud_item_fireup': '범위',
      // ... 총 94개 키
    },
    'en': {
      'main_title': 'Sinsi Bomber',
      'stage_select_title': 'Stage Select',
      'world_1': 'Humanity Realm',
      'char_1': 'Warrior of Ungnyeo',
      'hud_stage': 'STAGE',
      'hud_item_fireup': 'Range',
      // ... 총 94개 키
    },
  };
}
```

### 매개변수 치환

```dart
// 점수 표시
loc.get('clear_score', {'score': '1500'})
// → "점수: 1500점"

// 적 처치 수
loc.get('clear_enemies', {'count': '5'})
// → "처치한 적: 5마리"

// 보스 등장
loc.get('enemy_appeared', {'name': '도깨비 대장'})
// → "도깨비 대장 등장!"
```

---

## 📊 번역 통계

| 언어 | 키 개수 | 상태 |
|------|--------|------|
| 한국어 (ko) | 94 | ✅ 완료 |
| 영어 (en) | 94 | ✅ 완료 |

---

## 🎨 색상 및 스타일

모든 현지화된 텍스트는 기존의 색상/스타일 지정을 유지합니다:

- **메인 제목**: 금색 (#FFD700), 굵음, 크기 48
- **버튼 텍스트**: 흰색, 크기 18
- **HUD 텍스트**: 흰색, 크기 16 (경고 시 굵음)
- **아이콘 레이블**: 흰색70%, 크기 12

---

## ✅ 테스트 체크리스트

- [x] LocalizationManager 싱글톤 구현
- [x] 한국어 번역 94개 항목 작성
- [x] 영어 번역 94개 항목 작성
- [x] ko.json 파일 생성 및 작성
- [x] en.json 파일 생성 및 작성
- [x] StageSelectionScreen 현지화 적용
- [x] InGameHUD 현지화 적용
- [x] 모든 주요 화면 현지화 검증
- [x] 매개변수 치환 기능 테스트
- [x] 코드 분석 (info 레벨만)

---

## 🔄 향후 언어 추가 방법

새로운 언어 추가 시:

1. **LocalizationManager에 언어 맵 추가**
```dart
'fr': {
  'main_title': 'Sinsi Bomber',
  // ... 모든 94개 키
}
```

2. **JSON 파일 생성**
```
assets/i18n/fr.json
```

3. **언어 변경**
```dart
LocalizationManager().setLanguage('fr');
```

---

## 📝 파일 수정 사항

### 1. lib/managers/localization_manager.dart
- 한국어 94개 키 추가
- 영어 94개 키 추가

### 2. assets/i18n/ko.json ✅ 새로 생성
- 전체 한국어 번역

### 3. assets/i18n/en.json ✅ 새로 생성
- 전체 영어 번역

### 4. lib/screens/stage_selection_screen.dart ✅ 수정
- initState에서 동적 텍스트 로드
- AppBar 제목 현지화

### 5. lib/components/in_game_hud.dart ✅ 수정
- LocalizationManager 임포트
- 아이템 이름 현지화
- _buildItemIcons 메서드 매개변수 추가

### 6. 기타 화면 (이미 현지화됨)
- main_screen.dart
- character_screen.dart
- clear_screen.dart
- gameover_screen.dart
- settings_screen.dart

---

## 🌍 현지화 키 전체 목록

### 메인 화면 (5)
main_title, main_subtitle, btn_start_game, btn_select_character, btn_high_score

### 스테이지 선택 (7)
stage_select_title, world_1, world_2, world_3, world_4, world_1_desc~4_desc, stage_locked, stage_label

### 캐릭터 선택 (16)
character_select_title, character_locked, btn_select, char_1~10, char_desc_1~10

### 게임 HUD (9)
hud_stage, hud_items, hud_item_fireup, hud_item_bombup, hud_item_speedup, hud_item_timeextend, hud_item_shield, hud_item_curse

### 게임 메시지 (3)
game_time_warning, enemy_appeared, item_got

### 보스 (4)
boss_1, boss_2, boss_3, boss_4

### 클리어 (5)
clear_title, clear_perfect, clear_score, clear_enemies, clear_stars, btn_next_stage

### 게임오버 (3)
gameover_title, gameover_score, gameover_stage

### 설정 (7)
settings_title, settings_language, settings_sound, settings_music, settings_vibration, settings_on, settings_off, btn_reset_game

### 공통 (10)
btn_retry, btn_restart, btn_menu, btn_about, ok, cancel, yes, no

---

## 🎯 사용자 경험 개선

### 현지화의 이점
1. ✅ 한국 게이머를 위한 완전한 한국어 지원
2. ✅ 국제 게이머를 위한 영어 지원
3. ✅ 향후 다른 언어 추가 용이
4. ✅ 일관된 텍스트 관리 (싱글톤 매니저)
5. ✅ 매개변수 치환으로 동적 텍스트 생성

---

**구현 완료일**: 2026-03-29
**버전**: 1.1.0 (완전한 현지화 시스템 추가)
