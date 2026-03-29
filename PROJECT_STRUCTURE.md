# 신시 봄버맨 - 프로젝트 구조

## 📁 최종 폴더 구조

```
lib/
├── main.dart                         # 앱 진입점
├── game/                             # 게임 엔진 (Flame)
│   ├── bomberman_game.dart          # 메인 게임 클래스
│   ├── components/                   # 게임 컴포넌트
│   │   ├── player_component.dart    # 플레이어
│   │   ├── bomb_component.dart      # 폭탄
│   │   ├── explosion_component.dart # 폭발 이펙트
│   │   ├── enemy_component.dart     # 일반 요괴
│   │   └── boss_component.dart      # 보스 요괴
│   ├── map/                          # 게임 맵
│   │   ├── grid_map.dart            # 13x13 격자 맵
│   │   └── tile_type.dart           # 타일 타입 (벽, 벽돌, 파워업)
│   └── data/                         # 게임 데이터
│       ├── character_data.dart      # 10가지 캐릭터 데이터
│       ├── stage_data.dart          # 40개 스테이지 데이터
│       └── enemy_data.dart          # 요괴 데이터
├── screens/                          # UI 화면
│   ├── main_screen.dart             # 메인 화면
│   ├── game_screen.dart             # 게임 화면
│   ├── character_screen.dart        # 캐릭터 선택
│   ├── clear_screen.dart            # 스테이지 클리어
│   ├── gameover_screen.dart         # 게임 오버
│   └── settings_screen.dart         # 설정
└── managers/                         # 시스템 관리
    ├── ad_manager.dart              # Google Mobile Ads
    ├── save_manager.dart            # SharedPreferences 저장
    └── localization_manager.dart    # 한국어/영어 지역화
```

## 📊 파일 통계

| 카테고리 | 파일 수 | 설명 |
|---------|--------|------|
| **Game** | 10 | 게임 엔진 및 컴포넌트 |
| **Screens** | 6 | UI 화면 |
| **Managers** | 3 | 시스템 관리 |
| **Total** | 20 | Dart 파일 |

## 🎮 게임 요소

### 캐릭터 (Character Data)
- 10가지 신화 캐릭터
- 각각 고유한 속도, 폭탄 개수, 폭발 범위
- 언락 시스템

### 맵 (Grid Map)
- 13x13 격자
- 타일 타입: 벽, 벽돌, 풀
- 파워업: 속도 증가, 폭탄 증가, 범위 증가

### 요괴 (Enemy)
- 도깨비: 기본 요괴
- 귀신: 벽돌을 통과할 수 있음
- 구미호: 더 높은 HP
- 이무기: 느리지만 강력함

### 스테이지 (Stage Data)
- 40개 스테이지 (4개 지역 x 10)
- 난이도 점진적 상승
- 10번 스테이지마다 보스 등장

## 💻 핵심 클래스

### BombermanGame
```dart
class BombermanGame extends FlameGame {
  - gridMap: 게임 맵
  - player: 플레이어
  - enemies: 요괴 리스트
  - bombs: 폭탄 리스트
  - score: 현재 점수
  - enemiesDefeated: 처치한 요괴 수
}
```

### GridMap
```dart
class GridMap {
  - width, height: 13x13
  - tileSize: 32px
  - getTile(): 타일 조회
  - destroyTile(): 타일 파괴
  - destroyTilesInRadius(): 범위 파괴
  - isWalkable(): 이동 가능 여부
}
```

### CharacterData
```dart
class CharacterData {
  - id, name, koreanName
  - speed, maxBombs, fireRange
  - imageAsset, description
}
```

### EnemyData
```dart
class EnemyData {
  - id, name, type
  - speed, hp, score
  - canPassThrough: 벽돌 통과 여부
}
```

## 🎯 게임 플로우

1. **메인 화면** (MainScreen)
   - 게임 시작
   - 캐릭터 선택
   - 설정

2. **캐릭터 선택** (CharacterScreen)
   - 10가지 캐릭터 선택
   - 언락 시스템

3. **게임 플레이** (GameScreen + BombermanGame)
   - Flame 게임 실행
   - 폭탄 설치 및 폭발
   - 요괴 처치

4. **클리어** (ClearScreen)
   - 다음 스테이지
   - 메뉴로

5. **게임오버** (GameOverScreen)
   - 다시 시작
   - 메뉴로

## 🔧 시스템 관리

### AdManager
- Google Mobile Ads 통합
- 배너, 전면, 보상형 광고

### SaveManager
- SharedPreferences 저장/로드
- 게임 진행 상태
- 하이스코어
- 게임 설정

### LocalizationManager
- 한국어/영어 지원
- 동적 텍스트 변환

## 🎨 색상 스킴

- **주요 색**: `#8B0000` (어두운 빨강, 신화 테마)
- **강조 색**: `#FFD700` (금색)
- **배경**: `#1a1a1a` (검은색)
- **카드**: `#2d2d2d` (진회색)

## 📱 Android 설정

- **패키지명**: com.sinsi.bomberman
- **앱 이름**: 신시 봄버맨
- **최소 SDK**: API 21
- **필수 권한**: 인터넷, 네트워크 상태

## 📚 주요 기능

✅ 13x13 그리드 맵 시스템
✅ 5가지 타일 타입 (벽, 벽돌, 파워업)
✅ 10가지 캐릭터 선택
✅ 4가지 요괴 타입
✅ 40개 스테이지
✅ 폭탄 & 폭발 시스템
✅ 파워업 시스템
✅ 점수 계산
✅ 저장 시스템
✅ 광고 통합
✅ 한국어/영어 지원
✅ 다크 테마

## 🚀 다음 단계

- [ ] 게임 에셋 추가 (이미지, 음향)
- [ ] Flame 게임 화면 구현
- [ ] 플레이어 입력 처리
- [ ] 게임 로직 완성
- [ ] 테스트 및 디버깅
- [ ] Google Play 배포

---

**마지막 업데이트**: 2026-03-29
**구조 버전**: 2.0 (봄버맨 게임 중심)
