# PDS Diary
- 실행 시 랜덤으로 명언을 보여주고, 내부 저장소를 이용해서 간단하게 Plan, Do, See 를 작성할 수 있는 다이어리 앱.
## 개발환경
- xcode 14.1
- iOS 16.1
## 구조
- MVC + Clean Architecture
## 사용 기술
- Swift Concurruncy
- UICalendarView
## 화면 구성 
| 초기 화면 | 추가 화면|
|:---:|:---:|
|<img src = "https://user-images.githubusercontent.com/96932116/207522859-d08d144f-a1ef-423c-9f6b-c729a61d4746.PNG" width="300" height="600">|<img src = "https://user-images.githubusercontent.com/96932116/207522930-9f5f19d4-0bec-4f9a-9200-0bf1ec7368c9.PNG" width="300" height="600">|
| 수정 화면 | 삭제 기능 |
|<img src = "https://user-images.githubusercontent.com/96932116/207522920-fe1f9cf2-fb42-480c-935f-2d5c6128fae0.PNG" width="300" height="600">|<img src = "https://user-images.githubusercontent.com/96932116/207522944-bf17f44c-a3b5-48b1-841a-8d3066bcf5bc.PNG" width="300" height="600">|

## History
### Custom Navigation View의 버튼 이벤트 처리
- Custom Navigation View에서 버튼의 클릭 이벤트를 감시 할 수 있는 방법을 고민했다.
- `Custom Navigation View가 이벤트를 처리해야 할 View를 알 수 없는 상황을 고려해 Delegate 방식으로 동작 이벤트를 감지하도록 구현.`
### 달력에서 선택한 날짜의 데이터만 보여주는 방법
- 처음엔 Dictionary 타입을 사용해 선택 된 날짜의 Key값에 맞는 Diary 데이터들을 배열로 넣어줬다.
  - Diary 데이터 수정이 제대로 이뤄지지 않는 문제가 생겼다.
    -> `모든 수정이 필요한 날짜의 모든 Data를 Dictionary에서 꺼내서 수정을 요청한 날짜로 filtering 후 다시 주입해줘야 하는 번거로운 상황`
    -> 내부흐름에 문제가 있어 제대로 이뤄지지 않았다.
- `배열에 전체 데이터를 저장하고 다른 배열에 실제로 테이블 뷰에 보여줄 날짜의 데이터만 넣는 방식으로 수정.`
