var url='https://secure.tlbl.winsion.net/mobile-api';
//var url = 'http://172.16.5.34:9024';
var Service = {
    getStationParkingList: function (Data, successFunction, errorFunction) {
        $.ajax({
            type: 'GET',
            url: url+'/q/diagram/getStationParkingList',
            data: Data,
            dataType: 'json',
            success: successFunction,
            error: errorFunction
        });
    }
};
