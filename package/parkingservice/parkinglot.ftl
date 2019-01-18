<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>parking lot</title>
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

    #l-map {
      width: 100%;
      height: 250px;

    }

    #parkingLotList {
      width: 100%;
    }

    #parkingLotListHeader {
      background-color: #fff;
      padding-left: 10px;
      padding-right: 10px;
      padding-top: 10px;
    }

    .parkingLotListHeaderBG {
      background-color: #2A82D3;
      width: 5px;
      height: 23px;
      float: left;
      border-bottom: 1px solid #2A82D3;
    }

    .parkingLotListHeaderSP {
      line-height: 23px;
      text-indent: 10px;
    }

    #parkingLotListSort {
      min-height: 50px;
      background-color: #fff;
      border-bottom: none;
      border-top: none;
      padding: 10px;
      width: 100%;
      display: inline-flex;

    }

    #parkingLotListMain {
      border: 1px solid #93a4af;
      border-top: none;
      background-color: #fff;
    }

    .parkingLotListText {
      text-align: center;
      font-size: 16px;
      width: 48%;
      line-height: 45px;
    }

    #thisToStation {
      background-color: #DB8C84;
      color: #fff;

    }

    #thisToMe {
      background-color: #7DAED2;
      color: #fff;
      margin-left: 4%;

    }

    #Type {
      background-color: #57AB7E;
      color: #fff;
    }

    #Price {
      background-color: #587AA7;
      color: #fff;
    }

    .parkingLostImg {
      height: 220px;
      width: 100%;
    }

    .parkingLostItemText {
      width: 100%;
      word-break: break-all;
      padding: 10px;
      font-size: 12px;
    }

    #parkingLotListName {
      font-size: 18px;
    }

    #parkingLotListAddress .am-icon-map-marker {
      color: red;
    }

    #parkingLotListName, #parkingLotListAddress, #parkingLotListCharge {
      overflow: hidden;
      white-space: nowrap;
      text-overflow: ellipsis;
    }


  </style>
</head>
<body>

<div id="l-map"></div>


<div id="parkingLotList">
  <div id="parkingLotListHeader">
    <div class="parkingLotListHeaderBG"></div>
    <div class="parkingLotListHeaderSP">停车场</div>
  </div>

  <div id="parkingLotListSort">
    <div id="thisToStation" class="parkingLotListText">火车站距离</div>
    <div id="thisToMe" class="parkingLotListText">离我最近</div>
  </div>

  <div id="parkingLotListMain"></div>
</div>

<script src="../../../俄罗斯方块/js/jquery-2.1.3.js"></script>
<script src="../parkingservice/js/jquery.cookie.js"></script>
<script type="text/javascript" src="https://api.map.baidu.com/api?v=2.0&ak=PfQ9N0aHmf9rw5hcuViCpQaG6CxYFVMs"></script>
<script type="text/javascript">
  //加载时服务端需要的数据和网络请求
  var stationId = '${stationId}';//当前车站id
  var presentCity = '${cityName}';//当前城市
  var x = '${longitude}';//当前车站的经度
  var y = '${latitude}';//当前车站的纬度
 var Service = {
    getStationParkingList: function (Data, successFunction, errorFunction) {
      $.ajax({
        type: 'POST',
        url: 'http://mobile-api.tlbl.winsion.net/diagram/getStationParkingList',
        data: Data,
        dataType: 'json',
        success: successFunction,
        error: errorFunction
      });
    }
  };
  Service.getStationParkingList({stationId: stationId}, function (ev) {
    // 百度地图API功能
    var map = new BMap.Map("l-map");
    map.centerAndZoom(new BMap.Point(x, y), 16);
    map.enableScrollWheelZoom(true);
    var myGeo = new BMap.Geocoder();


    var parkingLot = ev.data;//接口返回的停车场信息
    var adds = [];//拿出所有的停车场名称名
    var newAddress = [];//拿出所有的停车场的坐标
    var stationLength = [];//火车站距离

    for (var i = 0; i < parkingLot.length; i++) {
      adds.push(parkingLot[i].address)
    }

    //画地图////////////////////////////////////////////////
    for (var i = 0; i < adds.length; i++) {

      myGeo.getPoint(adds[i], function (point, a) {

        if (point) {

          var address = new BMap.Point(point.lng, point.lat);
          newAddress.push({lng: point.lng, lat: point.lat});
          var marker = new BMap.Marker(address);
          map.addOverlay(marker);

          var opts = {
            width: 200,     // 信息窗口宽度
            height: 100,     // 信息窗口高度
            title: "停车场", // 信息窗口标题
            enableMessage: true//设置允许信息窗发送短息
          }
          var infoWindow = new BMap.InfoWindow(a.address, opts);  // 创建信息窗口对象
          marker.addEventListener("click", function () {
            map.openInfoWindow(infoWindow, point); //开启信息窗口
          });

        }

      }, presentCity);


    }
    ///////////////////////////////////////////////////////

    //画列表////////////////////////////////////////////////
    for (var i = 0; i < parkingLot.length; i++) {
      var imgUrl = parkingLot[i].imgUrl;
      var nextIndex = i + 1;
      var index = '0' + nextIndex;
      var name = parkingLot[i].name;
      var address = parkingLot[i].address;
      var charge = parkingLot[i].charge;
      var iph = parkingLot[i].mobile;
      var parkingLotId = parkingLot[i].id;

      $('#parkingLotListMain').append(
          "<div class='parkingLostItem' data-parkingLotId=" + parkingLotId + "><img class='parkingLostImg' src=" + imgUrl + "><div class='parkingLostItemText'><div id='parkingLotListName'>" + index + " " + name + "</div><div id='parkingLotListAddress'><span class='am-icon-map-marker'></span>" + address + "</div><div id='parkingLotListCharge'>" + charge + "</div><div>" + iph + "</div></div>"
      )
    }
    ///////////////////////////////////////////////////////


    handleCallBack(parkingLot, adds, newAddress);


  }, function (error) {
    alert('error')
  });


  var handleCallBack = function (data1, data2, data3) {


    //接口数据
    var parkingLotInfo = data1;
    //停车场名称
    var parkingLotName = data2;
    //停车场坐标
    var parkingLotAddress = data3;

    //绑定跳转事件
    $('#parkingLotListMain .parkingLostItem').on('click', function () {
      var parkingLotId = $(this).attr('data-parkinglotid');
      $.cookie('parkingLotId', parkingLotId);
      window.location.href = 'getStationParkingDetail.html?stationId=${stationId}&parkingId='+parkingLotId
    })

    stationLength(parkingLotInfo, parkingLotAddress);

    myStationLength(parkingLotInfo, parkingLotAddress);


  };


  //按照车站距离排序
  function stationLength(parkingLotInfo, parkingLotAddress) {
    //按车站距离排序
    $('#thisToStation').on('click', function () {
      for (var i = 0; i < parkingLotInfo.length; i++) {
        parkingLotInfo[i].lng = parkingLotAddress[i].lng;
        parkingLotInfo[i].lat = parkingLotAddress[i].lat;
      }

      for (var i = 0; i < parkingLotInfo.length; i++) {
        var stationLength = ComputeDistance(x, y, parkingLotInfo[i].lng, parkingLotInfo[i].lat);
        parkingLotInfo[i].stationLength = stationLength;
      }

      for (var i = 0; i < parkingLotInfo.length; i++) {
        for (var j = i; j < parkingLotInfo.length; j++) {
          if (parkingLotInfo[i].stationLength > parkingLotInfo[j].stationLength) {
            var temp = parkingLotInfo[i];
            parkingLotInfo[i] = parkingLotInfo[j];
            parkingLotInfo[j] = temp;

          }
        }
      }


      console.log(parkingLotInfo);

      $('#parkingLotListMain').html('');

      for (var i = 0; i < parkingLotInfo.length; i++) {
        var imgUrl = parkingLotInfo[i].imgUrl;
        var nextIndex = i + 1;
        var index = '0' + nextIndex;
        var name = parkingLotInfo[i].name;
        var address = parkingLotInfo[i].address;
        var charge = parkingLotInfo[i].charge;
        var iph = parkingLotInfo[i].mobile;
        var parkingLotId = parkingLotInfo[i].id;

        $('#parkingLotListMain').append(
            "<div class='parkingLostItem' data-parkingLotId=" + parkingLotId + "><img class='parkingLostImg' src=" + imgUrl + "><div class='parkingLostItemText'><div id='parkingLotListName'>" + index + " " + name + "</div><div id='parkingLotListAddress'><span class='am-icon-map-marker'></span>" + address + "</div><div id='parkingLotListCharge'>" + charge + "</div><div>" + iph + "</div></div>"
        )
      }

      $('#parkingLotListMain .parkingLostItem').on('click', function () {
        var parkingLotId = $(this).attr('data-parkinglotid');
        $.cookie('parkingLotId', parkingLotId);
        window.location.href = 'getStationParkingDetail.html?stationId=${stationId}&parkingId='+parkingLotId
      });


    });
  }

  //按我的距离排序
  function myStationLength(parkingLotInfo, parkingLotAddress) {
    $('#thisToMe').on('click', function () {


      var geolocation = new BMap.Geolocation();
      geolocation.getCurrentPosition(function (r) {
        if (this.getStatus() == BMAP_STATUS_SUCCESS) {

          //定位打开时,获取原始坐标成功后调用的函数

          var _x = r.point.lng; //GPSx坐标
          var _y = r.point.lat;  //GPSy坐标

          for (var i = 0; i < parkingLotInfo.length; i++) {
            parkingLotInfo[i].lng = parkingLotAddress[i].lng;
            parkingLotInfo[i].lat = parkingLotAddress[i].lat;
          }

          for (var i = 0; i < parkingLotInfo.length; i++) {
            var myLength = ComputeDistance(_x, _y, parkingLotInfo[i].lng, parkingLotInfo[i].lat);
            parkingLotInfo[i].myLength = myLength;
          }

          for (var i = 0; i < parkingLotInfo.length; i++) {
            for (var j = i; j < parkingLotInfo.length; j++) {
              if (parkingLotInfo[i].myLength > parkingLotInfo[j].myLength) {
                var temp = parkingLotInfo[i];
                parkingLotInfo[i] = parkingLotInfo[j];
                parkingLotInfo[j] = temp;

              }
            }
          }

          $('#parkingLotListMain').html('');

          for (var i = 0; i < parkingLotInfo.length; i++) {
            var imgUrl = parkingLotInfo[i].imgUrl;
            var nextIndex = i + 1;
            var index = '0' + nextIndex;
            var name = parkingLotInfo[i].name;
            var address = parkingLotInfo[i].address;
            var charge = parkingLotInfo[i].charge;
            var iph = parkingLotInfo[i].mobile;
            var parkingLotId = parkingLotInfo[i].id;

            $('#parkingLotListMain').append(
                "<div class='parkingLostItem' data-parkingLotId=" + parkingLotId + "><img class='parkingLostImg' src=" + imgUrl + "><div class='parkingLostItemText'><div id='parkingLotListName'>" + index + " " + name + "</div><div id='parkingLotListAddress'><span class='am-icon-map-marker'></span>" + address + "</div><div id='parkingLotListCharge'>" + charge + "</div><div>" + iph + "</div></div>"
            )
          }
          $('#parkingLotListMain .parkingLostItem').on('click', function () {
            var parkingLotId = $(this).attr('data-parkinglotid');
            $.cookie('parkingLotId', parkingLotId);
            window.location.href = 'getStationParkingDetail.html?stationId=${stationId}&parkingId='+parkingLotId
          })



        }
        else {
          alert('failed' + this.getStatus());
        }
      }, {enableHighAccuracy: true});


//            if (navigator.geolocation) {
//                navigator.geolocation.getCurrentPosition(function (position) {
//                    //定位打开时,获取原始坐标成功后调用的函数
//
//                    var _x = position.coords.longitude; //GPSx坐标
//                    var _y = position.coords.latitude;  //GPSy坐标
//
//                    for (var i = 0; i < parkingLotInfo.length; i++) {
//                        parkingLotInfo[i].lng = parkingLotAddress[i].lng;
//                        parkingLotInfo[i].lat = parkingLotAddress[i].lat;
//                    }
//
//                    for (var i = 0; i < parkingLotInfo.length; i++) {
//                        var myLength = ComputeDistance(_x, _y, parkingLotInfo[i].lng, parkingLotInfo[i].lat);
//                        parkingLotInfo[i].myLength = myLength;
//                    }
//
//                    for (var i = 0; i < parkingLotInfo.length; i++) {
//                        for (var j = i; j < parkingLotInfo.length; j++) {
//                            if (parkingLotInfo[i].myLength > parkingLotInfo[j].myLength) {
//                                var temp = parkingLotInfo[i];
//                                parkingLotInfo[i] = parkingLotInfo[j];
//                                parkingLotInfo[j] = temp;
//
//                            }
//                        }
//                    }
//
//                    $('#parkingLotListMain').html('');
//
//                    for (var i = 0; i < parkingLotInfo.length; i++) {
//                        var imgUrl = parkingLotInfo[i].imgUrl;
//                        var nextIndex = i + 1;
//                        var index = '0' + nextIndex;
//                        var name = parkingLotInfo[i].name;
//                        var address = parkingLotInfo[i].address;
//                        var charge = parkingLotInfo[i].charge;
//                        var iph = parkingLotInfo[i].mobile;
//                        var parkingLotId = parkingLotInfo[i].id;
//
//                        $('#parkingLotListMain').append(
//                                "<div class='parkingLostItem' data-parkingLotId=" + parkingLotId + "><img class='parkingLostImg' src=" + imgUrl + "><div class='parkingLostItemText'><div id='parkingLotListName'>" + index + " " + name + "</div><div id='parkingLotListAddress'><span class='am-icon-map-marker'></span>" + address + "</div><div id='parkingLotListCharge'>" + charge + "</div><div>" + iph + "</div></div>"
//                        )
//                    }
//                    $('#parkingLotListMain .parkingLostItem').on('click', function () {
//                        var parkingLotId = $(this).attr('data-parkinglotid');
//                        $.cookie('parkingLotId', parkingLotId);
//                        window.location.href = 'parkingLotDetail.html'
//                    })
//
//
//                }, function (error) {
//
//                    //定位关闭时,获取坐标失败后调用的函数
//                    alert('请打开手机定位服务')
//                });
//            }
    })
  }

  //计算两点间距离公式的算法
  function ComputeDistance(x1, y1, x2, y2) {
    var num1 = Math.pow(x2 - x1, 2);
    var num2 = Math.pow(y2 - y1, 2);
    var num3 = Math.sqrt(num1 + num2);
    return num3;
  }


</script>

</body>
</html>