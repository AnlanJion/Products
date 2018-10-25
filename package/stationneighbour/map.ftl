<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport"
        content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no">
  <title>${stationNeighbourDto.getName()}</title>
  <link rel="stylesheet" href="../stationneighbour/css/amazeui.min.css">
  <link rel="stylesheet" href="../stationneighbour/css/around.css">
</head>
<body>
<header id="header">
  <a href="/getStationNeighbourList.html?stationId=${stationId}&type=${type}#${stationNeighbourDto.getId()}"
     class="back-btn"><span class="am-icon-angle-left icon"></span></a>
  <h1 class="page-name">详情</h1>
</header>
<div class="item-box">
  <div class="img-box">
    <img src="${stationNeighbourDto.getImgUrl()}" alt="">
  </div>s="per">人均</span><span class="price" id="address">${stationNeighbourDto.getPerConsumption()}</span>
    </div>
  <div class="info-box">
    <div><span class="name">${stationNeighbourDto.getName()}</span></div>
    <div><span clas
  </div>
</div>
<div class="am-g">
  <div class="am-u-lg-12 am-u-md-12 am-u-sm-12 tlbl-goto">
    <div class="goto-info clearfix">
      <span class="am-icon-map-marker icon"></span>
      <a href="#" class="address" id="positionInfo">${stationNeighbourDto.getAddress()}</a>
      <a href="/getDetailAndMapMsg.html?stationId=${stationId}&neighbourId=${stationNeighbourDto.getId()}&type=${type}"
         class="goto"><span class="am-icon-map-signs icon"></span>到这去</a>
    </div>
  </div>

  <div class="am-u-lg-12 am-u-md-12 am-u-sm-12">
    <div id="tlbl-map">

    </div>
  </div>

</div>
<script type="text/javascript" src="../stationneighbour/js/jquery.min.js"></script>
<script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=PfQ9N0aHmf9rw5hcuViCpQaG6CxYFVMs"></script>
<script type="text/javascript">
  $(document).ready(function () {
    var AutoHeight = $(window).height() - $("#header").height() - $(".item-box").height() - $(".tlbl-goto").height() - 45;
    $("#tlbl-map").css("height", AutoHeight);
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
      shouMap();
      return false;
    }
    ;

    if (browser.versions.iPhone || browser.versions.iPad || browser.versions.ios) {
      shouMap();
      return false;
    }
    ;

    //判断安卓浏览器
    if (browser.versions.android && browser.versions.wxIphone) {
      shouMap();
      return false;
    }
    ;


    if (browser.versions.android) {
      shouMap();
      return false;
    }
    ;

    if (browser.versions.wp) {
      alert("暂不支持此设备");
      return false;
    }
    ;
  }


  function shouMap() {
    // 百度地图API功能
    var position = $("#positionInfo").text();
    var map = new BMap.Map("tlbl-map");
    map.centerAndZoom(new BMap.Point(116.404, 39.915), 11);
    var local = new BMap.LocalSearch(map, {
      renderOptions: {map: map}
    });
    local.search(position);
  }

</script>
</body>
</html>