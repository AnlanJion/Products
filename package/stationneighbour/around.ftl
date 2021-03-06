<!DOCTYPE html>
<html>

<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
  <meta name="viewport"
        content="width=device-width,initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no">
  <link rel="stylesheet" type="text/css" href="../stationneighbour/css/header.css"/>
</head>

<body>
<div class="playTheme">
  <div class="body">
  <#list types as type>
    <a href="getStationNeighbourList.html?stationId=${stationId}&type=${type}" class="playThemeItem">
      <div class="playThemeIcon" style="background-position-x: ${offsetMap[type]}"></div>
      <div class="playThemeName">${type}</div>
    </a>
  </#list>
  </div>
</div>

<div class="channel_title">${type}<span></span><i style="background: #80daea"></i></div>
<div class="products" style="padding-top: 0px;">
  <ul class="list" current_page="1" loading="0" finished="0">
  <#list stationNeighbourDtos as stationNeighbourDto>
    <li class="m-product-item" id="${stationNeighbourDto.getId()}">
      <a href="/getNeighbourDetailByStationId.html?stationId=${stationId}&neighbourId=${stationNeighbourDto.getId()}&type=${stationNeighbourDto.getType()}">
        <div class="item-top">
          <div class="product-image"><img
              src="${stationNeighbourDto.getImgUrl()}">
            <div class="image-gra"></div>
          </div>
            <#if stationNeighbourDto.getPerConsumption() != ''>
              <div class="product-price price-schema-1">
                <div class="product-price-now noPro">￥<em>${stationNeighbourDto.getPerConsumption()}</em>元起</div>
              </div>
            </#if>
        </div>
        <div class="item-bottom">
          <h5 class="product-title">${stationNeighbourDto.getName()}</h5>
          <p class="product-describe">${stationNeighbourDto.getAddress()}</p>
          <div class="product-tags">
              <#list stationNeighbourDto.getRemark() as label>
                <span class="label hairlines" style="">${label}</span>
              </#list>
          </div>
        </div>
      </a>
    </li>
  </#list>
  </ul>
</div>
<script src="http://cdn.bootcss.com/jquery/3.1.0/jquery.min.js"></script>
<script type="text/javascript">
  var t = this;
  t.topButton = $("<div class='back_to_top hidden'></div>"), t.topButton.appendTo("body"), t.topButton.on("click", function () {
    document.body.scrollTop = document.documentElement.scrollTop = 0, $(this).addClass("hidden")
  })

  $(window).on("scroll", function () {
    var e = this;
    var t = document.documentElement.clientHeight,
        i = document.body.scrollHeight || document.documentElement.scrollHeight,
        o = document.body.scrollTop || document.documentElement.scrollTop;
    var s = $(".products");
    var d = s.offset().top + 240;
    d > o && e.topButton.addClass("hidden"), o >= d && e.topButton.removeClass("hidden")
  })
</script>
</body>

</html>
