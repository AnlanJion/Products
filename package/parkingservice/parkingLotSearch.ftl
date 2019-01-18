<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport"
        content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no"/>
  <link rel="stylesheet" href="../parkingservice/css/amazeui.min.css">
  <title>WINSION</title>

  <style type="text/css">
    h1 {
      margin: 0;
    }

    #l-map {
      width: 100%;
      height: 300px;
    }

    .clearfix:after {
      content: "";
      display: block;
      height: 0;
      clear: both;
      visibility: hidden;
    }

    header {
      height: 42px;
      position: relative;
      text-align: center;
      z-index: 999;
      background-color: #f2f2f2;
      box-shadow: 0 1px 3px rgba(0, 0, 0, .3);
    }

    .back-btn {
      position: absolute;
      width: 42px;
      height: 42px;
      line-height: 42px;
      font-size: 14px;
      padding: 0;
      top: 0;
      left: 0;
    }

    .icon {
      display: inline-block;
      font-weight: 400;
      font-style: normal;
      font-variant: normal;
      line-height: 1;
      text-transform: none;
      -webkit-font-smoothing: antialiased;
      font-size: 16px;
      width: 1em;
      height: 1em;
    }

    header h1 {
      font-size: 18px;
      font-weight: normal;
      line-height: 42px;
      overflow: hidden;
      text-overflow: ellipsis;
      white-space: nowrap;
      text-align: center;
      width: 100%;
    }

    .clearfix {
      *zoom: 1;
    }

    .container div {
      width: 100%;
    }

    .input-container {
      padding: 0 20px;
    }

    .input {
      position: relative;
      line-height: 2;
    }

    .start, .end {
      float: left;
      width: 10px;
      height: 10px;
      border: 2px solid #000;
      border-radius: 50%;
      margin: 16px 10px 0;
    }

    .start {
      border-color: red;
    }

    .end {
      border-color: green;
    }

    .input input {
      float: left;
      width: 80%;
      border: none;
      padding: 10px 0;
      /*font-size: 1em;*/
      outline: none;
    }

    .input:nth-child(1) {
      border-bottom: 1px solid #ccc;
    }

    .map-btn {
      border-top: #d4d4d4 solid 1px;
      border-bottom: #d4d4d4 solid 1px;
      background-color: #f9f9f9 !important;
    }

    .map-btn button {
      height: 44px;
      min-width: 44px;
      /*font-size: 16px;*/
      border: none;
      background-color: inherit;
      display: inline-block !important;
      outline: none;
      color: #666;
      width: 50%;
      margin: 0px;
      padding: 0px;
      float: left;
    }

    .bus {
      border-right: 1px solid #ccc !important;
    }

    .am-icon-bus, .am-icon-car {
      margin-right: 6px;
    }

    .undefinedPoint {
      margin-top: 12px !important;
      background: url("./img/undefinedPoint.png") no-repeat !important;
      background-size: 100% 67% !important;
      position: relative;
    }

    .undefinedText {
      position: relative;
      display: block;
      font-size: 20px;
      color: red;
      width: 200px;
      margin: 0 auto;
      padding-top: 208px;
    }

  </style>
</head>
<body>
<header id="header">
  <a href="getStationParkingDetail.html?stationId=${stationId}&parkingId=${parkingId}" class="back-btn"><span class="am-icon-angle-left icon"></span></a>
  <h1 class="page-name">详情</h1>
</header>
<div class="position-relative">
  <div class="container">
    <div class="input-container">
      <div class="input clearfix">
        <span class="start"></span>
        <input id="start-input" type="text" placeholder="在此输入起点">
      </div>
      <div class="input clearfix">
        <span class="end"></span>
        <input id="end-input" type="text" placeholder="在此输入终点" value="北京西站南广场"/>
      </div>
    </div>
  </div>
  <div class="map-btn clearfix">
    <button id="bus" class="btn bus" onclick='bus()'><span class="am-icon-bus"></span>公交</button>
    <button id="car" class="btn car" onclick='car()'><span class="am-icon-car"></span>驾车</button>
  </div>
</div>
<div id="l-map"></div>
<div id="r-result"></div>

</body>
<script src="../../../俄罗斯方块/js/jquery-2.1.3.js"></script>
<script src="../parkingservice/js/jquery.cookie.js"></script>
<script type="text/javascript" src="https://api.map.baidu.com/api?v=2.0&ak=PfQ9N0aHmf9rw5hcuViCpQaG6CxYFVMs"></script>
<script type="text/javascript">
  $(document).ready(function () {
    $('#start-input').attr('disabled', true);
    $('#end-input').attr('disabled', true);
    $('#end-input').attr('value', $.cookie('parkingLotSearchName'));
    autoBrowser();
  });

  var browser = {
    versions: function () {
      var u = navigator.userAgent, app = navigator.appVersion;
      return { //移动终端浏览器版本信息
        ios: !!u.match(/\(i[^;]+;( U;)? CPU.+Mac OS X/), //ios终端
        android: u.indexOf('Android') > -1 || u.indexOf('Linux') > -1, //android终端或uc浏览器
        iPhone: u.indexOf('iPhone') > -1, //是否为iPhone或者QQHD浏览器
        iPad: u.indexOf('iPad') > -1, //是否iPad
        wp: u.indexOf("Windows Phone") > -1, //是否windowsPhone
        wxIphone: u.indexOf('MicroMessenger') > -1,
        wxAndroid: u.indexOf('MicroMessenger') > -1

      };
    }(),
  };

  function autoBrowser() {
    //ios判断浏览器
    if (browser.versions.ios && browser.versions.wxIphone) {
      bus()
      return false;
    }

    if (browser.versions.iPhone || browser.versions.iPad || browser.versions.ios) {
      bus()
      return false;
    }

    //判断安卓浏览器
    if (browser.versions.android && browser.versions.wxIphone) {
      alert("不支持");
      return false;
    }


    if (browser.versions.android) {
      alert("不支持");
      return false;
    }

    if (browser.versions.wp) {
      alert("暂不支持此设备");
      return false;
    }
  }

  function bus() {
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(function (position) {
        //定位打开时,获取原始坐标成功后调用的函数
        $("#l-map").removeClass('undefinedPoint');
        $("#undefinedPoint").remove();
        AutoShowPositionBus(position);
      }, function (error) {
        //定位关闭时,获取坐标失败后调用的函数
        $("#start-input").val('未能获取到您的位置信息');
        $("#start-input").css('color', '#EE000C');
        $("#l-map").addClass('undefinedPoint');
        $("#l-map").append('<span class="undefinedText">请打开手机的定位服务</span>');

      });
    }
  }

  function car() {
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(function (position) {
        //定位打开时,获取原始坐标成功后调用的函数
        $("#l-map").removeClass('undefinedPoint');
        $("#undefinedPoint").remove();
        AutoShowPositionCar(position);
      }, function (error) {
        //定位关闭时,获取坐标失败后调用的函数
        $("#start-input").val('未能获取到您的位置信息');
        $("#start-input").css('color', '#EE000C');
        $("#l-map").addClass('undefinedPoint');
        $("#l-map").append('<span class="undefinedText">请打开手机的定位服务</span>');

      });
    }
  }

  function AutoShowPositionBus(position) {

    $('#start-input').val("我的位置");  //开始位置
    var x = position.coords.longitude; //GPSx坐标
    var y = position.coords.latitude;  //GPSy坐标
    var ggPoint = new BMap.Point(x, y);
    //地图初始化
    var bm = new BMap.Map("l-map");
    bm.centerAndZoom(ggPoint, 15);
    bm.addControl(new BMap.NavigationControl());


    //将地名转成百度坐标;
    var pointGo;
    var myGeo = new BMap.Geocoder();
    // 将地址解析结果显示在地图上,并调整地图视野
    myGeo.getPoint($('#end-input').val(), function (point) {
      if (point) {
        pointGo = point;
      } else {
        alert("您选择地址没有解析到结果!");
      }
    });

    //坐标转换完之后的回调函数
    translateCallback = function (data) {
      if (data.status === 0) {
        //我的位置坐标
        var p1 = data.points[0];
        //目的地的位置坐标
        var p2 = pointGo;
        //根据GPS坐标画出地图路线
        var transit = new BMap.TransitRoute(bm, {
          renderOptions: {map: bm, panel: "r-result"}
        });
        transit.search(p1, p2);
      }
    };
    setTimeout(function () {
      var convertor = new BMap.Convertor();
      var pointArr = [];
      pointArr.push(ggPoint);
      convertor.translate(pointArr, 1, 5, translateCallback)
    }, 1000);
  }

  function AutoShowPositionCar(position) {

    $('#start-input').val("我的位置");  //开始位置
    var x = position.coords.longitude; //GPSx坐标
    var y = position.coords.latitude;  //GPSy坐标
    var ggPoint = new BMap.Point(x, y);
    //地图初始化
    var bm = new BMap.Map("l-map");
    bm.centerAndZoom(ggPoint, 15);
    bm.addControl(new BMap.NavigationControl());


    //将地名转成百度坐标;
    var pointGo;
    var myGeo = new BMap.Geocoder();
    // 将地址解析结果显示在地图上,并调整地图视野
    myGeo.getPoint($('#end-input').val(), function (point) {
      if (point) {
        pointGo = point;
      } else {
        alert("您选择地址没有解析到结果!");
      }
    });

    //坐标转换完之后的回调函数
    translateCallback = function (data) {
      if (data.status === 0) {
        //我的位置坐标
        var p1 = data.points[0];
        //目的地的位置坐标
        var p2 = pointGo;
        //根据GPS坐标画出地图路线
        var Drive = new BMap.DrivingRoute(bm, {
          renderOptions: {map: bm, panel: "r-result"}
        });
        Drive.search(p1, p2);
      }
    };
    setTimeout(function () {
      var convertor = new BMap.Convertor();
      var pointArr = [];
      pointArr.push(ggPoint);
      convertor.translate(pointArr, 1, 5, translateCallback)
    }, 1000);
  }


</script>
</html>