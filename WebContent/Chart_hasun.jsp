<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="Windows 95 UI Kit crafted by Themesberg.com">
    <meta name="author" content="Themesberg">
    <title>TEAM 5 CHART</title>
    <!-- Favicon -->
    <link rel="apple-touch-icon" sizes="60x60" href="img/favicon/apple-touch-icon.png">
    <link rel="icon" type="image/png" sizes="32x32" href="img/favicon/favicon-32x32.png">
    <link rel="icon" type="image/png" sizes="16x16" href="img/favicon/favicon-16x16.png">
    <link rel="manifest" href="img/favicon/site.webmanifest">
    <link rel="mask-icon" href="img/favicon/safari-pinned-tab.svg" color="#5bbad5">
    <meta name="msapplication-TileColor" content="#2d89ef">
    <meta name="theme-color" content="#ffffff">
    <!-- Bootstrap CSS -->
    <link type="text/css" rel="stylesheet" href="node_modules/bootstrap/dist/css/bootstrap.min.css">
    <!-- Pixel CSS -->
    <link type="text/css" rel="stylesheet" href="css/pixel.css">
    
	<script type="text/javascript" src="http://code.jquery.com/jquery-1.10.1.min.js"></script>
	<script src="https://code.highcharts.com/highcharts.js"></script>
	<script src="https://code.highcharts.com/modules/exporting.js"></script>
	<script type="text/javascript">
		$(function(){
			$('#btn').click(function(){
				let movieAPI = "http://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=f5eef3421c602c6cb7ea224104795888"
				//targetDt=20210405
				let data = {targetDt:$('#search').val()};
				//console.log(data);
				$('#movieChart').empty();
				
				$.getJSON(movieAPI, data, function(data, textStatus, xhr){
					let table = "<table border='1'>";
					table += "<tr><th>순위</th><th>영화제목</th><th>개봉일</th></tr>";
					console.log(data)
					$.each(data.boxOfficeResult.dailyBoxOfficeList, function(index, obj){
						table += "<tr><td>"+obj.rank+"</td><td>"+obj.movieNm+"</td><td>"+obj.openDt+"</td></tr>";
					});
					table+="</table>";
					$('#movieChart').html(table);
					
					let xCategories = [];
					let Visitors = [];
					let totalVisitors = [];
					
					$.each(data.boxOfficeResult.dailyBoxOfficeList, function(index, obj){
						xCategories.push(obj.movieNm);
						Visitors.push(parseInt(obj.audiCnt));
						totalVisitors.push(parseInt(obj.audiAcc)); 
					});
					
					console.log(xCategories);
					
					$('#highchart').highcharts({
						
						title : {
						text : '주간 박스오피스', //차트의 제목
						x : -20
						},
						
						xAxis : {
						categories : xCategories, //x축, 각 막대 그래프의 항목 이름
						crosshair: {
						width: 3,
						color: 'black'
						}
						},
						yAxis : { //y축
						min:10000, // 0부터 시작
						title : {
						text : '관객수(명)'
						},
						crosshair: {
						width: 3,
						color: 'black'
						},
						plotLines : [ {
						value : 0,
						width : 1,
						color : '#4682b4'
						} ]
						}, 
						tooltip: {
						headerFormat: '<span style="font-size:10px">{point.key}</span><table>', //key는 x축 
						pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
						'<td style="padding:0"><b>{point.y} 명</b></td></tr>',
						footerFormat: '</table>', //{point.y:f}442543, {point.y}443 543
						shared: true, //true면 같은 X축의 데이터 값이 같이 보임 
						useHTML: true //true면 위의 지정한 html 태그 사용
						}, 
						plotOptions: { //해당 X축의 블록지정
						column: {
						pointPadding: 0.2,
						borderWidth: 0
						}
						}, 
						legend : { //범례
						layout : 'vertical',
						align : 'right', // sereis 오른쪽
						verticalAlign : 'middle', //sereis 오른쪽 중간
						borderWidth : 0 //sereis 테두리
						}, 
						series : [ { 
						name : '당일 관객수',
						data : Visitors
						}, {
						name : '누적 관객수',
						data : totalVisitors
						} ] 
						});//highcharts 
				});
				
			});
			
		})
	</script>
</head>
<body>
	<main>
		<!-- Hero -->
		<section class="section-sm bg-secondary">
			<div class="container">
				<div class="row">
					<div class="col-12">
						<div class="mt-5 mb-5 mt-md-0">
							<h4 class="text-white">Hasun's chart</h4>
						</div>
					</div>
				</div>
				<input type="text" id="search">
				<button class="btn mr-2 mb-2 btn-primary border-dark-lg" type="button" id="btn">
					<span class="btn-text">search</span>
				</button>
				
				<div id="highchart"></div>
				<div id="movieChart" style="margin-top: 15px"></div>
			</div>
		</section>
	</main>
</body>
</html>