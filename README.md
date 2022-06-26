## 👨🏻‍🔧 미세먼지 앱

## 🤷🏻 What
공공 API 데이터로 구현한 반응형 미세먼지 앱

<a href="https://www.data.go.kr/tcs/dss/selectApiDataDetailView.do?publicDataPk=15073855" target="_blank">open API</a>

## 🚀 How
<details>
<summary> iOS 15.5 </summary>

### 인트로

![pollution_intro](https://user-images.githubusercontent.com/85836879/175816490-15945cdc-3f92-4941-af82-58c71c3c4a91.gif)

### 지역 선택하기

![pollution_region](https://user-images.githubusercontent.com/85836879/175816493-6aa63941-c33a-4fb7-a63c-6ca9a3ebd1b3.gif)

### 미세먼지 정보 갱신하기

![pollution_refresh](https://user-images.githubusercontent.com/85836879/175816492-a78b8328-af10-4f3d-a528-f554e2383aed.gif)

</details>

<details>
<summary> Android API 33 </summary>

### 인트로

![pollution_aos_intro](https://user-images.githubusercontent.com/85836879/175816481-33554589-8968-45ff-a501-3a76e572b371.gif)

### 지역 선택하기

![pollution_aos_region](https://user-images.githubusercontent.com/85836879/175816486-5198f67a-34f6-49a2-b852-d6d57f001588.gif)

### 미세먼지 정보 갱신하기

![pollution_aos_refresh](https://user-images.githubusercontent.com/85836879/175816485-56a9e0ac-7e02-455f-a332-3b0b5f3b9402.gif)

</details>

## 💡 Tips
open API의 service key를 개발용과 배포용을 분리하여 사용해야 합니다. 

Hive를 이용하여 ValueListenableBuilder 위젯으로 데이터를 효율적으로 랜더링 할 수 있습니다.

또한 Hive로 불러온 데이터를 이용하는 방식으로 구현하여 위젯간의 매개변수 인자 개수를 줄여 개발시간을 단축 시킬 수 있습니다. 

kToolbarHeight 값을 이용해 SliverAppBar의 스타일링을 더욱 효율적으로 반응형 구현할 수 있습니다.


## 📖 Review

open API의 개발용 access key를 dotenv 패키지를 이용해 형상관리를 하고 dotenv의 작동 유무 파악을 테스트 코드 작성으로 확인할 수 있었다.

<img width="200" height="250" alt="스크린샷 2022-06-24 오후 3 15 33" src="https://user-images.githubusercontent.com/85836879/175474861-8edc41e4-9382-42d7-bf45-36be09cb1ff4.png">
<img width="200" height="250" alt="image" src="https://user-images.githubusercontent.com/85836879/175475010-80da0416-49b4-4b7a-b86f-97925efdec7d.png">

DrawerHeader 위젯의 기본 설정된 border가 Theme의 기본 색상을 따라간다는 것을 알고 Theme 위젯으로 감싸어 border 색상을 바꾸어 주었다.

