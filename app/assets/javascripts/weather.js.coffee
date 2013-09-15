# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  if(!window.preload)
    curloc = "Salt_Lake_City"
    local_requrl = window.ruby_url+ "/weather_ajax/get"
    geo_requrl = "http://api.ipinfodb.com/v3/ip-city/?key=8e7a04c4f57900bae6713dbb17866506ebf86f000e983a606d6e8cc7dcf8898d&ip=" + window.mock_ip + "&format=json&callback=?"
    $.getJSON(geo_requrl, (geores) ->
      if(!geores.cityName || !geores.countryName || !geores.regionName || geores.cityName == '-' || geores.countryName == '-' || geores.regionName == '-')
        alert("Can't find you")
        return
      $.getJSON(local_requrl, {"name":geores.cityName, "province":geores.regionName, "country":geores.countryName}, (res)->
        if(res.error)
          alert('Error getting weather data.')
        else
         $('.brand').empty().append("Weather for " + res.cityName + ", " + res.province)
         $.each( $('.span2'), (index, item) ->
            cur_item = res.weather.list[index]
            $(item).children('.temp').append(Math.round(cur_item.temp.day) + "&deg;F")
            $(item).children('.desc').append(cur_item.weather[0].main)
            img = $('<img>')
            img.attr('src', window.site_url + "/weather_img/" + cur_item.weather[0].icon + ".svg")
            $(item).children('.wimg').append(img)
            console.log(index + ' ' + item)
          )
      )
    )
  

