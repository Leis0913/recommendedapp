## RecommendedApp


#### 사용자의 기분, 현재 위치, 시간대, 날씨 등을 바탕으로 AI가 최적의 메뉴를 추천해주는 식사 도우미 앱

2071141 홍민혁


### 1. 프로젝트 수행 목적 

1.1 프로젝트 정의

  * AI를 이용한 메뉴 추천 어플리케이션

1.2 프로젝트 배경

  * 일상에서 많은 사람들이 식사 메뉴를 고르느라 고민하며 시간을 허비하는 경우가 많습니다. 특히 기분, 날씨, 위치, 시간대와 같은 다양한 요인에 따라 먹고 싶은 음식이 달라지기 때문에, 메뉴를 결정하는 일이 더욱 어렵게 느껴지곤 합니다
  * 이러한 문제점을 해소하기 위해 본 프로젝트는 AI 기술을 활용하여 사용자의 기분, 현재 날씨, 위치, 시간대 등 정보를 종합적으로 분석하고, 상황에 가장 잘 어울리는 식사 메뉴를 추천합니다. 또한 추천된 메뉴에 대해 주변 정보를 함께 제공함으로써, 사용자가 보다 쉽고 빠르게 식사를 선택할 수 있도록 돕는 것이 본 프로젝트의 목적입니다.
    
1.3 프로젝트 목표

 * 사용자 정보 파악
   * 사용자의 기분, 위치, 시간대, 날씨 정보를 입력받고 메뉴를 추천하도록 구현
 * 주변 식당 조회
   * MapKit을 사용하여 추천된 메뉴에 대한 주변 식당 정보 지도에 표시하도록 구현   

### 2. 프로젝트 개요

2.1 프로젝트 설명

 * 사용자의 기분, 날씨, 위치, 시간대를 실시간으로 수집하고, 이를 기반으로 AI가 가장 적절한 식사 메뉴를 추천하도록 구현한다.
 * MapKit을 사용하여 추천 받은 메뉴를 전달 받아 사용자 위치 근처의 식당을 검색한다.

2.2 프로젝트 구조

![프로젝트 구조](https://github.com/Leis0913/recommendedapp/blob/main/recommendedapp.PNG)


2.3 결과물

 * 메인 화면

<p align="left">
 <img src="https://github.com/user-attachments/assets/efb89462-ded7-430e-ad48-4c0209c8959e" width="150" style="margin-right: 30px;">
 <img src="https://github.com/Leis0913/recommendedapp/blob/main/recommended_menu.PNG" width="150" style="margin-right: 30px;">
 <img src="https://github.com/Leis0913/recommendedapp/blob/main/recommended_menu_2.PNG" width="150">
</p>

 * 지도 화면
   
<p align="left">
 <img src="https://github.com/Leis0913/recommendedapp/blob/main/map.PNG" width="150" style="margin-right: 30px;">
 <img src="https://github.com/Leis0913/recommendedapp/blob/main/find_in_map.PNG" width="150" style="margin-right: 30px;">
 <img src="https://github.com/Leis0913/recommendedapp/blob/main/found_in_map.PNG" width="150">
</p>

 * 룰렛 화면
 
 <p align="left">
 <img src="https://github.com/Leis0913/recommendedapp/blob/main/roulette.PNG" width="150" style="margin-right: 30px;">
 <img src="https://github.com/Leis0913/recommendedapp/blob/main/roulette_make_input.PNG" width="150" style="margin-right: 30px;">
 <img src="https://github.com/Leis0913/recommendedapp/blob/main/roulette_setting.PNG" width="150" style="margin-right: 30px;">
 <img src="https://github.com/Leis0913/recommendedapp/blob/main/roulette_finish.PNG" width="150">
 </p>


2.4 기대효과
 * 다양한 요인을 고려하여 식사 메뉴를 추천해줌으로써 사용자의 선택 부담을 출일 수 있다.
 * 사용자는 기분만 선택하면 날씨, 위치, 시간대 등의 정보를 알아서 입력 받아 빠르고 효율적인 식사 결정이 가능하다.
 * 추천된 메뉴와 연동된 주변 식당 정보까지 확인할 수 있어 사용자 편의성이 증가한다.

2.5 관련기술
| 구분               | 설명                                    |
| ------------------ | --------------------------------------- |
| MapKit             | Apple에서 제공하는 지도로 Apple의 다양한 플랫폼에서 지도를 사용하고 통합할 수 있도록 설계된 프레임워크이다.|
| OpenAI API         | 사용자의 기분, 날씨, 시간대 등의 정보를 바탕으로 자연어 처리 AI에게 적절한 메뉴를 추천받는데 사용된다.     |
| OpenWeatherMap API | 사용자의 현재 위치를 기반으로 실시간 날씨 정보를 가져 오기 위해 사용되며, 온도와 날씨 설명 등을 메뉴 추천 조건에 반영한다|


2.6 개발도구
| 구분                | 설명                                     |
| ------------------- | ---------------------------------------- |
| Xcode               | 	애플에서 제공하는 통합 개발 환경(IDE)으로, iOS 앱 개발을 위한 필수 도구이다. Swift 코드 작성, UI 설계, 시뮬레이터 테스트 등을 지원하며, 본 프로젝트 전반의 개발 환경으로 사용되었다.|
| Swift               | 애플의 공식 프로그래밍 언어로, iOS 앱 개발에 최적화되어 있다. 가독성과 안정성이 높으며, 본 프로젝트의 전체 로직을 구현하는 데 사용되었다. |

2.7 발표영상

Youtube 동영상



# git에 업로드되어 있는 gptapi는 현재 존재하지 않는 api입니다.
