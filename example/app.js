// this sets the background color of the master UIView (when there are no windows/tab groups on it)
Titanium.UI.setBackgroundColor('#000');

var stop = false;
var win1 = Titanium.UI.createWindow({
	title : 'Rotation',
	backgroundColor : '#fff'
});

var roll = Titanium.UI.createLabel({
	color : '#999',
	text : 'Roll:',
	top : 200,
	left : 0,
	height : 30,
	//font:{fontSize:20,fontFamily:'Helvetica Neue'},
	//textAlign:'center',
	width : 'auto'
});
roll.addEventListener('click', function(e) {
	stop = true;
	alert('click')
});
var pitch = Titanium.UI.createLabel({
	color : '#999',
	top : 230,
	left : 0,
	height : 30,
	text : 'Pitch:',
	//font:{fontSize:20,fontFamily:'Helvetica Neue'},
	//textAlign:'center',
	width : 'auto'
});

var yaw = Titanium.UI.createLabel({
	color : '#999',
	top : 260,
	left : 0,
	height : 30,
	text : 'Yaw:',
	//font:{fontSize:20,fontFamily:'Helvetica Neue'},
	//textAlign:'center',
	width : 'auto'
});

var lat = Titanium.UI.createLabel({
	color : '#999',
	top : 290,
	left : 0,
	height : 30,
	text : 'Lat:',
	//font:{fontSize:20,fontFamily:'Helvetica Neue'},
	//textAlign:'center',
	width : 'auto'
});

var lon = Titanium.UI.createLabel({
	color : '#999',
	top : 320,
	left : 0,
	height : 30,
	text : 'Lon:',
	//font:{fontSize:20,fontFamily:'Helvetica Neue'},
	//textAlign:'center',
	width : 'auto'
});

var alt = Titanium.UI.createLabel({
	color : '#999',
	top : 350,
	left : 0,
	height : 30,
	text : 'Alt:',
	//font:{fontSize:20,fontFamily:'Helvetica Neue'},
	//textAlign:'center',
	width : 'auto'
});

win1.add(roll);
win1.add(pitch);
win1.add(yaw);
win1.add(lat);
win1.add(lon);
win1.add(alt);

win1.open();


var curr;
var movement = require('ti.movement');

Ti.API.info('Accuracy three: ' + movement.LOCATION_ACCURACY_THREE_KILOMETERS)
Ti.API.info('Accuracy best: ' + movement.LOCATION_ACCURACY_BEST)
Ti.API.info('Accuracy navig: ' + movement.LOCATION_ACCURACY_BEST_FOR_NAVIGATION)

Ti.API.info('Ref frame true: ' + movement.ROTATION_REFERENCE_FRAME_TRUE_NORTH)
Ti.API.info('Ref frame magn: ' + movement.ROTATION_REFERENCE_FRAME_MAGNETIC_NORTH)
Ti.API.info('Ref frame corr: ' + movement.ROTATION_REFERENCE_FRAME_CORRECTED)

movement.startMovementUpdates({
	//location : false,
	rotation : true,
	//locationAccuracy : movement.LOCATION_ACCURACY_BEST_FOR_NAVIGATION,
	//rotationReferenceFrame : movement.ROTATION_REFERENCE_FRAME_CORRECTED
});

function s() {
	if(!stop) {
		curr = movement.currentMovement;	
		//Ti.API.info(curr)
	
		roll.setText('Roll: ' + curr.rotation.roll);
		pitch.setText('Pitch: ' + curr.rotation.pitch);
		yaw.setText('Yaw: ' + curr.rotation.yaw);
		lat.setText('Lat: ' + curr.location.latitude);
		lon.setText('Lon: ' + curr.location.longitude);
		alt.setText('Alt: ' + curr.location.altitude);
				
		setTimeout(s, 0);
	} else return;

}
setTimeout(s, 0);