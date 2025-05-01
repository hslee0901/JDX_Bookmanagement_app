Read.me

https://console.cloud.google.com/welcome?hl=ko&inv=1&invt=AblxHg&project=sincere-cat-417804
↑키를 발급 받을 수있는 구글클라우드 ・ KEYをもらえるグーグルクラウド ・ You can obtain the google books api key.



This project was created by the JDX club at Pusan University of Foreign Studies.

The project utilizes Maven, the Google Books API, and MySQL, TOMCAT.

The database table creation commands are commented out at the bottom of the DBconnection.java file in the function_jdxbook directory, so please refer to them when creating the schema.

Additionally, a Google Books API key is required, so please obtain a key personally and modify the project to include it.

The following files need modification and the API key added: search.jsp, BookDetail.jsp, and recommend.jsp.  （You can find where to replace the key by searching for 'apikey')

Features


Login/Logout (Database)
Favorites (API, Database)
Search (API)
Book Detail Page (API)



이 프로젝트는 부산외국어대학교 JDX 동아리에서 만든 프로젝트입니다.

이 프로젝트는 maven과 google books api, MySQL, 톰캣서버를 사용했습니다. 

db 테이블 생성 명령어는 function_jdxbook의 DBconnection.java 밑 부분에 주석처리로 되어있기 때문에 스키마를 만들때 참고해주세요

그리고 google books api의 키가 필요하기 때문에 개인적으로 키를 발급 받아 수정하고 넣어주세요

위치 search.jsp / BookDetail.jsp / recommend.jsp <==수정과 키 넣기 필요  (apikey검색 수정)

기능

로그인/로그아웃(DB)

즐겨찾기(API, DB)

검색(API)

책 상세페이지 (API)



このプロジェクトは釜山外国語大学のJ-DXサークルが作ったプロジェクトです。

MAVENとgoogle books api, MySQL, TOMCATを使いました。

DBのテーブルを作るコードは function_jdxbookのDBconnection.javaの下側にありますので、参考してください。

そしてこのウェブアプリケーションを作動するため、 google books apiのKEYが必要です。グーグルクラウドからKEYをもらって入れてください。

KEY入れるところ　 search.jsp / BookDetail.jsp / recommend.jsp     （apikey検索して修正）


機能

ログイン/ログアウト(DB)

気に入り(API, DB)

検索(API)

ブック詳細(API)
