<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Title</title>
  <meta name="viewport"
        content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no"/>
  <link rel="stylesheet" href="../parkingservice/css/amazeui.min.css">
  <style type="text/css">
    body, html {
      width: 100%;
      height: 100%;
      margin: 0;
      font-family: "微软雅黑";
      background-color: #e0e0e0;
    }

    header {
      height: 42px;
      position: relative;
      text-align: center;
      z-index: 999;
      background-color: #f2f2f2;
      box-shadow: 0 1px 3px rgba(0, 0, 0, .3);
      margin: 0;
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
      margin: 0;
    }

    .img {
      height: 100px;
      width: 100px;
    }

    .img-box {
      border: 1px solid #A3A3A3;
      float: left;
      margin: 0 10px 0 0;
    }

    .info-box {
      line-height: 25px;
      font-size: 13px;
      margin-left: 112px;
      min-height: 75px;
      vertical-align: middle;
    }

    .name {
      vertical-align: middle;
      font-size: 15px;
      color: #3c3c3c;
      font-weight: 600;
      max-width: 86%;
      white-space: nowrap;
      text-overflow: ellipsis;
      display: inline-block;
      overflow: hidden;
    }

    .price {
      color: #f13b0e;
    }

    .tlbl-goto, .tlbl-map {
      padding-top: 15px;
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

    .clearfix {
    }

    .goto-info {
      background: #fff;
      border: 1px solid #e4e4e4;
      margin: 0 0 5px;
      border-radius: .25em;
      position: relative;
      line-height: 20px;
      min-height: 41px;
    }

    #parkingLotInfo {
      width: 100%;
      min-height: 130px;
      padding: 15px;
      background-color: #fff;
    }

    #l-map {
      width: 95%;
      height: 250px;
      margin: 0 auto;
    }

    .per {
      display: inline-block
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

    .am-icon-map-marker {
      position: absolute;
      top: 10px;
      left: 10px;
      float: left;
      margin: 4px 5px 0 0;
      text-align: center;
    }

    .address {
      float: left;
      width: 60%;
      position: absolute;
      top: 25%;
      overflow: hidden;
      white-space: nowrap;
      left: 26px;
      text-overflow: ellipsis;
    }

    .goto {
      position: absolute;
      top: 25%;
      right: 10px;
      border-left: #d4d4d4 solid 1px;
      color: #3385ff;
      text-indent: 4px;
    }

    .am-icon-map-signs {
      margin: 0 13px 0 -10px;
    }

    #tlbl-map {
      height: 100px;
    }
  </style>
</head>
<body>

<div id="root">
  <header id="header">
    <a href="getStationParkingList.html?stationId=${stationId}" class="back-btn"><span
        class="am-icon-angle-left icon"></span></a>
    <h1 class="page-name">详情</h1>
  </header>

  <div id="parkingLotInfo">

  </div>


  <div class="am-g">
    <div class="am-u-lg-12 am-u-md-12 am-u-sm-12 tlbl-goto">
      <div class="goto-info clearfix">
        <span class="am-icon-map-marker icon"></span>
        <a href="#" class="address" id="positionInfo"></a>
        <a class="goto" disable=“true” id="parkingGoto"><span class="am-icon-map-signs icon"></span>到这去</a>
      </div>
    </div>

    <div class="am-u-lg-12 am-u-md-12 am-u-sm-12 tlbl-map">
      <div id="tlbl-map">

      </div>
    </div>

  </div>
</div>

<script src="../../../俄罗斯方块/js/jquery-2.1.3.js"></script>
<script src="../parkingservice/js/jquery.cookie.js"></script>
<script type="text/javascript" src="https://api.map.baidu.com/api?v=2.0&ak=PfQ9N0aHmf9rw5hcuViCpQaG6CxYFVMs"></script>
<script type="text/javascript">
  var parkingLotId = $.cookie('parkingLotId');
  var presentCity = '${cityName}';//当前城市
  var x = '${longitude}';//当前车站的经度
  var y = '${latitude}';//当前车站的纬度

  var Service = {
    getStationParkingDetail: function (Data, successFunction, errorFunction) {
      $.ajax({
        type: 'POST',
        url: 'http://mobile-api.tlbl.winsion.net/diagram/getStationParkingDetail',
        data: Data,
        dataType: 'json',
        success: successFunction,
        error: errorFunction
      });
    }
  };

  Service.getStationParkingDetail({parkingId: parkingLotId}, function (ev) {
    console.log(ev.data)
    var URL = ev.data.imgUrl;
    var address = ev.data.address;
    var charge = ev.data.charge;
    var name = ev.data.name;
    var mobile = ev.data.mobile;
    var autoHeight = $(window).height() - $("#header").height() - $("#parkingLotInfo").height() - $('.tlbl-goto').height();

    $('#positionInfo').append("<span>" + address + "</span>")
    $('#parkingLotInfo').append("<div class='item-box'><div class='img-box'><img src=" + URL + " alt='' class='img'></div><div class='info-box'><div><span class='name'>" + name + "</span></div><div><span class='per'>消费:</span><span class='price'>" + charge + "</span></div><div id='address'><span>" + address + "</span></div><div id='phone'><span>" + mobile + "</span></div></div></div>")
    $('#tlbl-map').css('height', autoHeight);
    $('#parkingGoto').on('click', function () {
      $.cookie('parkingLotSearchName', address);
      window.location.href = 'searchStationParking.html?stationId=${stationId}&parkingId=${parkingId}'
    });

    // 百度地图API功能
    var map = new BMap.Map("tlbl-map");
    var point = new BMap.Point(x, y);
    map.centerAndZoom(point, 16);
    // 创建地址解析器实例
    var myGeo = new BMap.Geocoder();
    // 将地址解析结果显示在地图上,并调整地图视野
    myGeo.getPoint(address, function (point) {
      if (point) {
        map.centerAndZoom(point, 16);
        map.addOverlay(new BMap.Marker(point));
      } else {
        alert("您选择地址没有解析到结果!");
      }
    }, presentCity);


  }, function (error) {
    console.log(error)
  })

</script>
</body>
</html>