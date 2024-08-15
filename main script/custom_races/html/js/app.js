let weathers = [
	['Clear', 'CLEAR'],
	['Extrasunny', 'EXTRASUNNY'],
	['Clouds', 'CLOUDS'],
	['Overcast', 'OVERCAST'],
	['Rain', 'RAIN'],
	['Clearing', 'CLEARING'],
	['Thunder', 'THUNDER'],
	['Smog', 'SMOG'],
	['Foggy', 'FOGGY'],
	['Christmas', 'XMAS'],
	['Snow', 'SNOW'],
	['Snowlight', 'SNOWLIGHT'],
	['Blizzard', 'BLIZZARD'],
	['Halloween', 'HALLOWEEN'],
	['Neutral', 'NEUTRAL']
];
let racelaps = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16];
let hours = [
	'12:00',
	'13:00',
	'14:00',
	'15:00',
	'16:00',
	'17:00',
	'18:00',
	'19:00',
	'20:00',
	'21:00',
	'22:00',
	'23:00',
	'00:00',
	'01:00',
	'02:00',
	'03:00',
	'04:00',
	'05:00',
	'06:00',
	'07:00',
	'08:00',
	'09:00',
	'10:00',
	'11:00'
];
let explosion = [
	['No explosions', 'no-explosions'],
	['Every 15 sec', 'explosions-15'],
	['Every 30 sec', 'explosions-30'],
	['Every 45 sec', 'explosions-45'],
	['Every 60 sec', 'explosions-60']
];
let accesible = [
	['Public', 'public'],
	['Private', 'private']
];
let racemode = [
	['No Collisions', 'no_collision'],
	['Normal', 'normal'],
	['GTA', 'gta']
];
let racevehicle = [
	['Default', 'default'],
	['Specific', 'specific'],
	['Personal', 'personal']
];

/* to-do
let translations = {
	// american (en-US)
	0: {
		'text-Settings': 'Settings',
		'text-Laps': 'Laps',
		'text-Weather': 'Weather',
		'text-Hour': 'Hour'
	},

	// french (fr-FR)
	1: {
		'text-Settings': 'Settings',
		'text-Laps': 'Laps',
		'text-Weather': 'Weather',
		'text-Hour': 'Hour'
	},

	// german (de-DE)
	2: {
		'text-Settings': 'Settings',
		'text-Laps': 'Laps',
		'text-Weather': 'Weather',
		'text-Hour': 'Hour'
	},

	// italian (it-IT)
	3: {
		'text-Settings': 'Settings',
		'text-Laps': 'Laps',
		'text-Weather': 'Weather',
		'text-Hour': 'Hour'
	},

	// spanish (es-ES)
	4: {
		'text-Settings': 'Settings',
		'text-Laps': 'Laps',
		'text-Weather': 'Weather',
		'text-Hour': 'Hour'
	},

	// brazilian (pt-BR)
	5: {
		'text-Settings': 'Settings',
		'text-Laps': 'Laps',
		'text-Weather': 'Weather',
		'text-Hour': 'Hour'
	},

	// polish (pl-PL)
	6: {
		'text-Settings': 'Settings',
		'text-Laps': 'Laps',
		'text-Weather': 'Weather',
		'text-Hour': 'Hour'
	},

	// russian (ru-RU)
	7: {
		'text-Settings': 'Settings',
		'text-Laps': 'Laps',
		'text-Weather': 'Weather',
		'text-Hour': 'Hour'
	},

	// korean (ko-KR)
	8: {
		'text-Settings': 'Settings',
		'text-Laps': 'Laps',
		'text-Weather': 'Weather',
		'text-Hour': 'Hour'
	},

	// chinese-trad (zh-TW)
	9: {
		'text-Settings': 'Settings',
		'text-Laps': 'Laps',
		'text-Weather': 'Weather',
		'text-Hour': 'Hour'
	},

	// japanese (ja-JP)
	10: {
		'text-Settings': 'Settings',
		'text-Laps': 'Laps',
		'text-Weather': 'Weather',
		'text-Hour': 'Hour'
	},

	// mexican (es-MX)
	11: {
		'text-Settings': 'Settings',
		'text-Laps': 'Laps',
		'text-Weather': 'Weather',
		'text-Hour': 'Hour'
	},

	// chinese-simp (zh-CN)
	12: {
		'text-Settings': '设置',
		'text-Laps': '圈数',
		'text-Weather': '天气',
		'text-Hour': '时间'
	}
};
let languageCode = 0;
*/

let races_data_front = {};
var _racevehicle;

var current_page = 1;
var obj_per_page = 8;

let inRace = false;
let inRaceMenu = false;

//SOUNDS
let sound_invitation = new Audio('sounds/invitationsound.mp3');
sound_invitation.loop = false;
sound_invitation.volume = 0.7;
let sound_second = new Audio('sounds/second.mp3');
sound_second.volume = 0.1;
sound_second.loop = false;
let sound_over = new Audio('sounds/over.wav');
sound_over.volume = 0.2;
sound_over.loop = false;
let sound_click = new Audio('sounds/click.mp3');
sound_click.volume = 0.2;
sound_click.loop = false;
let sound_transition = new Audio('sounds/transition.mp3');
sound_transition.volume = 0.2;
sound_transition.loop = false;
let sound_transition2 = new Audio('sounds/transition2.mp3');
sound_transition2.volume = 0.2;
sound_transition2.loop = false;
let pop = new Audio('sounds/pop.ogg');
pop.volume = 1;
pop.loop = false;

let timeExplode;
let timeNF;
let resetLeaveRoom = false;
let resetShowMenu = false;

$(document).ready(() => {});

window.addEventListener('message', function (event) {
	/* to-do
	if (event.data.action == 'language') {
		languageCode = event.data.currentLanguage;
		translateHtmlText(languageCode);
	}
	*/

	if (event.data.action == 'SyncData') {
		races_data_front = event.data.races_data_front;
	}

	if (event.data.action == 'openMenu') {
		races_data_front = event.data.races_data_front;
		inRaceMenu = event.data.inrace;
		openRaceLobby();
	}

	if (event.data.action == 'openNotifications') {
		openNotifications();
	}

	if (event.data.action == 'receiveInvitationClient') {
		receiveInvitationClient(
			event.data.data.nickname,
			event.data.data.nameRace,
			event.data.data.roomid
		);
	}

	if (event.data.action == 'joinPlayerRoom') {
		resetLeaveRoom = true;
		resetShowMenu = true;
		$('.container-menu').hide();
		$('.container-lobby').hide();
		updateNotifications();
		loadRoom(
			event.data.data,
			event.data.players,
			event.data.invitations,
			event.data.playercount,
			event.data.nameRace,
			false,
			event.data.bool
		);
	}

	if (event.data.action == 'joinPlayerLobby') {
		resetLeaveRoom = true;
		resetShowMenu = true;
		$('.container-menu').fadeOut(300);
		$('.container-lobby').fadeOut(300);
		updateNotifications();
		loadRoom(
			event.data.data,
			event.data.players,
			event.data.invitations,
			event.data.playercount,
			event.data.nameRace,
			true,
			event.data.bool
		);
	}

	if (event.data.action == 'clientStartRace') {
		countDownGo();
	}

	if (event.data.action == 'updateRaceList') {
		const result = event.data.result
		$('.carreras').html('');
		if (result && result.length > 0) {
			result.map((v) => {
				$('.carreras').append(`
                    <div class="carrera-lobby sala-lobby" id="${v.roomid}">
                        <div class="campo nombre-carrera">
                            <i class="fa-solid fa-caret-right"></i> ${v.name}
                        </div>
                        <div class="campo vehicle">
                            ${v.vehicle || ' - '}
                        </div>
                        <div class="campo creador">
                            ${v.creator}
                        </div>
                        <div class="campo players">
                            ${v.players}
                        </div>
                    </div>
                `);
			});
		} else {
			$('.carreras').append(`
                    <div class="carrera-lobby">
                        <div class="campo w-100">
                            No rooms available
                        </div>

                    </div>
            `);
		}
		eventsLobby();
	}

	if (event.data.action == 'updatePlayersRoom') {
		updatePlayersRoom(
			event.data.players,
			event.data.invitations,
			event.data.playercount
		);
	}

	if (event.data.action == 'hideLoad') {
		$('.bgblack')
			.delay(1000)
			.fadeOut(300, function () {
				$('.starting-race').hide();
				$('.loading1').fadeOut(300);
				$('.letras-comenzando').fadeOut(300);
				RestartMenu();
			});
	}

	if (event.data.action == 'countdown') {
		$('.countdown').show();

		$('.countdown div').hide();
		$('#c-' + event.data.data).show();
	}

	if (event.data.action == 'exitRoom') {
		exitRoom(event.data.hostLeaveRoom);
	}

	if (event.data.action == 'removeInvitation') {
		$('[idsala=' + event.data.roomid + ']').animate(
			{
				opacity: 0
			},
			300,
			function () {
				$(this).remove();
				updateNotifications();
				if ($('.contador').text() == 0) {
					$.post(`https://${GetParentResourceName()}/CloseNUI`);
				}
			}
		);
	}

	if (event.data.action == 'showRaceHud') {
		$('.hud').fadeIn(300);
		// $(".position-table-container").addClass("show");
		inRace = true;
	}

	if (event.data.action == 'hideRaceHud') {
		$('.hud').fadeOut(300);
		$('.countdown').hide();
		$('.nf-zone').fadeOut(300);
		$('.position-table-container').removeClass('show');

		inRace = false;
	}

	if (event.data.position) {
		$('.position span').html(event.data.position);
	}

	if (event.data.checkpoints) {
		$('.checkpoints div').text(event.data.checkpoints);
	}

	if (event.data.laps) {
		$('.vuelta div').text(event.data.laps);
	}

	if (event.data.time) {
		$('.counter div').text(event.data.time);
	}

	if (event.data.action == 'startLastExplode') {
		$('.hud .explosion').fadeIn(300);
		tempExplode(event.data.value);
	}

	if (event.data.action == 'showScoreboard') {
		$('.spectate').fadeOut(300);

		$('.finish-race')
			.removeClass('animate__backOutDown')
			.addClass('animate__backInUp');

		$('.finish-race').css('display', 'flex');
		sound_transition2.currentTime = 0;
		sound_transition2.play();
		$('.finish-race table tbody').html('');
		event.data.racefrontpos.map((p) => {
			$('.finish-race table tbody').append(`
            <tr>
                <td class="td-position"><span class="n-position">${p.position}</span> ${p.name}</td>
                <td class="text-center">${p.vehicle}</td>
                <td class="text-center">${p.totaltime}</td>
                <td class="text-center">${p.bestLap}</td>
            </tr>
            `);
		});
		$('.hud .explosion').hide();
	}

	if (event.data.action == 'hideScoreboard') {
		$('.finish-race')
			.removeClass('animate__backInUp')
			.addClass('animate__backOutDown');
		sound_transition2.currentTime = 0;
		sound_transition2.play();
		setTimeout(() => {
			$('.finish-race').hide();
		}, 1000);
	}

	if (event.data.action == 'showNoty') {
		const message = event.data.message
		showNoty(message);
	}

	if (event.data.action == 'showRestartPosition') {
		$('.reappear').fadeIn(300);
	}

	if (event.data.action == 'hideRestartPosition') {
		$('.reappear').fadeOut(300);
	}

	if (event.data.action == 'startNFCountdown') {
		timerNF(event.data.time);
	}

	if (event.data.action == 'showRaceInfo') {
		sound_transition2.currentTime = '0';
		sound_transition2.play();
		$('.race-name .title-race').text(event.data.racename);
		$('.race-name').fadeIn(1000, function () {
			$(this).removeClass('animate__backInDown');
		});
		setTimeout(() => {
			$('.race-name')
				.addClass('animate__backOutUp')
				.fadeOut(700, function () {
					$(this)
						.removeClass('animate__backOutUp')
						.addClass('animate__backInDown');
				});
		}, 4000);
	}

	if (event.data.action == 'showSpectate') {
		spectateList(event.data.players);
	}

	if (event.data.action == 'slectedSpectate') {
		spectateSelected(event.data.playerid);
	}

	if (event.data.action == 'hideSpectate') {
		$('.spectate').fadeOut(300);
	}

	if (event.data.frontpos) {
		updatePositionTable(event.data.frontpos);
	}
});

function openRaceLobby() {
	eventsCreateCareer();
	eventKeydown();
	sound_transition.currentTime = 0;
	sound_transition.play();

	if (inRaceMenu) {
		$('.in-race-menu').fadeIn(300);
		$('#btn-abandonar-carrera')
			.off('click')
			.on('click', function () {
				$('.in-race-menu').fadeOut(300);
				$.post(`https://${GetParentResourceName()}/CloseNUI`, JSON.stringify({}));
				$.post(`https://${GetParentResourceName()}/leaveRace`, JSON.stringify({}));
			});
	} else {
		$('.bgblack').fadeIn(300);
	}
}

function openNotifications() {
	if ($('.contador').text() != 0) {
		$('.notifications').addClass('expandidas');
		eventKeydownNotifications();
	} else {
		$('.notifications').addClass('expandidas').fadeIn(300);
		$('.no-invitations').show();
		$('.raceinvitations').hide();
		$.post(`https://${GetParentResourceName()}/CloseNUI`);
		setTimeout(()=>{
			$('.no-invitations').hide();
		}, 5000)
	}
}

function receiveInvitationClient(nickname, nameRace, roomid) {
	const uniqueId = `invitation-${roomid}-${Date.now()}`;
	$('.raceinvitations').append(`
    <div class="invitation" id="${uniqueId}" idsala="${roomid}">
        <div class="titulo-invi">
            <i class="fas fa-flag-checkered"></i> ${nickname} has invited you to a race
        </div>
        <div class="detalles-invi">
            ${nameRace}
        </div>
        <div class="botones-invi border-top">
            <div class="aceptar border-end" idSala="${roomid}"><i class="fas fa-check"></i> Accept</div>
            <div class="rechazar"><i class="fas fa-times"></i> Decline</div>
        </div>
    </div>
    `);
	$(`#${uniqueId} .rechazar`)
		.off('click')
		.on('click', function () {
			$(this)
				.parent()
				.parent()
				.animate(
					{
						opacity: 0
					},
					300,
					function () {
						$(this).remove();
						updateNotifications();
						$.post(`https://${GetParentResourceName()}/denyInvitation`, JSON.stringify({ src: roomid }));
						if ($('.contador').text() == 0) {
							$.post(`https://${GetParentResourceName()}/CloseNUI`);
						}
					}
				);
		});
	$(`#${uniqueId} .aceptar`)
		.off('click')
		.on('click', function () {
			$(this)
				.parent()
				.parent()
				.animate(
					{
						opacity: 0
					},
					300,
					function () {
						$(this).remove();
						updateNotifications();
						$.post(`https://${GetParentResourceName()}/acceptInvitationPlayer`, JSON.stringify({ src: roomid }));
						$('.notifications').removeClass('expandidas');
					}
				);
		});
	sound_invitation.currentTime = 0;
	sound_invitation.play();
	updateNotifications();
}

function updateNotifications() {
	if ($('.invitation').length != 0) {
		$('.raceinvitations').show();
		$('.no-invitations').hide();
		$('.contador').text($('.invitation').length);
		$('.notifications').fadeIn(300);
	} else {
		$('.notifications').removeClass('expandidas');
		setTimeout(() => {
			$('.notifications').fadeOut(300, function () {
				$('.no-invitations').show();
			});
		}, 500);
		$('.contador').text($('.invitation').length);
		$('.raceinvitations').hide();
	}
}

const sortedKeys = Object.keys(races_data_front).sort((a, b) => {
	const aIsAlpha = /^[a-z]+$/i.test(a);
	const bIsAlpha = /^[a-z]+$/i.test(b);
	const aIsDigit = /^\d+$/.test(a);
	const bIsDigit = /^\d+$/.test(b);
  
	if (aIsAlpha && bIsAlpha) {
	  return a.toLowerCase().localeCompare(b.toLowerCase());
	} else if (aIsAlpha && bIsDigit) {
	  return -1;
	} else if (aIsDigit && bIsAlpha) {
	  return 1;
	} else if (aIsDigit && bIsDigit) {
	  return a - b;
	} else {
	  return a.localeCompare(b);
	}
  });
  
function eventsCreateCareer() {
	const sortedKeys = Object.keys(races_data_front).sort((a, b) => {
		const aIsAlpha = /^[a-z]+$/i.test(a);
		const bIsAlpha = /^[a-z]+$/i.test(b);
		const aIsDigit = /^\d+$/.test(a);
		const bIsDigit = /^\d+$/.test(b);

		if (aIsAlpha && bIsAlpha) {
			return a.toLowerCase().localeCompare(b.toLowerCase());
		} else if (aIsAlpha && bIsDigit) {
			return -1;
		} else if (aIsDigit && bIsAlpha) {
			return 1;
		} else if (aIsDigit && bIsDigit) {
			return a - b;
		} else {
			return a.localeCompare(b);
		}
	});
	  
	sortedKeys.map((category, i) => {
        const categoryClass = category.replace(/\s/g, '_').replace(/\./g, '_');
        if (!$('.filtro .' + categoryClass).length) {
            if (i == 0) {
                $('.filtro').append(`
                    <div class="tag ${categoryClass} elegido">
                        ${category}
                    </div>
                `);
                $('#btn-crear-carrera').fadeOut(300);
                loadListRaces(races_data_front[category]);
            } else {
                $('.filtro').append(`
                    <div class="tag ${categoryClass}">
                        ${category}
                    </div>
                `);
            }
        }
    });


	$('.selector .right')
		.off('click')
		.on('click', function () {
			let val;
			let pos = parseInt($(this).parent().find('.content').attr('pos'));
			let nBoton = '';

			if ($(this).parent().hasClass('weather')) {
				val = weathers;
			}

			if ($(this).parent().hasClass('racelaps')) {
				val = racelaps;
				nBoton = 'racelaps';
			}

			if ($(this).parent().hasClass('hour')) {
				val = hours;
				nBoton = 'hour';
			}

			if ($(this).parent().hasClass('explotar')) {
				val = explosion;
			}

			if ($(this).parent().hasClass('accesible')) {
				val = accesible;
			}

			if ($(this).parent().hasClass('juego')) {
				val = racemode;
			}

			if ($(this).parent().hasClass('racevehicle')) {
				val = racevehicle;
			}

			let max = val.length - 1;

			if (pos < max) {
				pos++;
				$(this).parent().find('.content').attr('pos', pos);
			} else {
				pos = 0;
				$(this).parent().find('.content').attr('pos', 0);
			}

			$(this)
				.parent()
				.find('.content')
				.find('div')
				.animate(
					{ borderSpacing: 90 },
					{
						step: function (now, fx) {
							$(this).css('transform', 'translateX(' + now + 'px)');
						},
						duration: 150
					},
					'ease-in-out'
				)
				.promise()
				.done(() => {
					let zona;
					if (nBoton == 'hour' || nBoton == 'racelaps') {
						zona = val[pos];
						zona2 = val[pos];
					} else {
						zona = val[pos][0];
						zona2 = val[pos][1];
					}
					$(this).parent().find('.content').attr('value', zona2);
					$(this)
						.parent()
						.find('.content')
						.find('div')
						.css('transform', 'translateX(-90px)')
						.text(zona)
						.animate(
							{ borderSpacing: 0 },
							{
								step: function (now, fx) {
									$(this).css(
										'transform',
										'translateX(-' + now + 'px)'
									);
								},
								duration: 150
							},
							'ease-in-out'
						);
				});
		});

	$('.selector .left')
		.off('click')
		.on('click', function () {
			let val;
			let pos = parseInt($(this).parent().find('.content').attr('pos'));
			let nBoton = '';

			if ($(this).parent().hasClass('weather')) {
				val = weathers;
			}

			if ($(this).parent().hasClass('racelaps')) {
				val = racelaps;
				nBoton = 'racelaps';
			}

			if ($(this).parent().hasClass('hour')) {
				val = hours;
				nBoton = 'hour';
			}

			if ($(this).parent().hasClass('explotar')) {
				val = explosion;
			}

			if ($(this).parent().hasClass('accesible')) {
				val = accesible;
			}

			if ($(this).parent().hasClass('juego')) {
				val = racemode;
			}

			if ($(this).parent().hasClass('racevehicle')) {
				val = racevehicle;
			}

			let max = val.length - 1;

			if (pos - 1 >= 0) {
				pos--;
				$(this).parent().find('.content').attr('pos', pos);
			} else {
				pos = max;
				$(this).parent().find('.content').attr('pos', max);
			}

			$(this)
				.parent()
				.find('.content')
				.find('div')
				.animate(
					{ borderSpacing: 90 },
					{
						step: function (now, fx) {
							$(this).css('transform', 'translateX(-' + now + 'px)');
						},
						duration: 150
					},
					'ease-in-out'
				)
				.promise()
				.done(() => {
					let zona, zona2;
					if (nBoton == 'hour' || nBoton == 'racelaps') {
						zona = val[pos];
						zona2 = val[pos];
					} else {
						zona = val[pos][0];
						zona2 = val[pos][1];
					}
					$(this).parent().find('.content').attr('value', zona2);
					$(this)
						.parent()
						.find('.content')
						.find('div')
						.css('transform', 'translateX(-90px)')
						.text(zona)
						.animate(
							{ borderSpacing: 0 },
							{
								step: function (now, fx) {
									$(this).css('transform', 'translateX(' + now + 'px)');
								},
								duration: 150
							},
							'ease-in-out'
						);
				});
		});

	$('.tag')
		.off('click')
		.on('click', function () {
			$('.tag').removeClass('elegido');
			$(this).addClass('elegido');
			$('#btn-crear-carrera').fadeOut(300);
			loadListRaces(races_data_front[$(this).text().trim().replace(/_/g, '_')]);
		});

	//CREAR CARRERA
	$('#btn-crear-carrera')
		.off('click')
		.on('click', function () {
			let raceid = $('.carrera.seleccionada').attr('raceid');
			let maxplayers = $('.carrera.seleccionada').attr('maxplayers');
			let racelaps = $('.racelaps .content').attr('value');
			let weather = $('.weather .content').attr('value');
			let hour = $('.hour .content').attr('value').split(':');
			let explosions = $('.explotar .content').attr('value');
			let accesible = $('.accesible .content').attr('value');
			let name = $('.carrera.seleccionada .nombre').text().replace('–', '-');
			let img = $('.carrera.seleccionada').css('background-image');
			let modo = $('.juego .content').attr('value');
			let vehiculo = $('.racevehicle .content').attr('value');
			img = /^url\((['"]?)(.*)\1\)$/.exec(img);
			img = img ? img[2] : '';
			resetLeaveRoom = true;
			resetShowMenu = false;
			$.post(
				`https://${GetParentResourceName()}/new-race`,
				JSON.stringify({
					raceid: raceid,
					racelaps: racelaps,
					weather: weather,
					hour: hour[0],
					explosions: explosions,
					accesible: accesible,
					img: img,
					modo: modo,
					name: name,
					maxplayers: parseInt(maxplayers),
					vehiculo: vehiculo
				}),
				function (cb) {
					if (cb) {
						createRoom(
							cb,
							img,
							name,
							racelaps,
							$('.weather .content div').text(),
							hour,
							$('.explotar .content div').text(),
							$('.accesible .content div').text(),
							$('.juego .content div').text(),
							maxplayers,
							$('.racevehicle .content div').text()
						);
					}
				}
			);
		});

	//TRANSICION A LOBBY
	$('.btn-lobby')
		.off('click')
		.on('click', function () {
			sound_click.currentTime = 0;
			sound_click.play();
			$('.container-menu')
				.animate(
					{ left: '-102%' },
					{
						duration: 500
					},
					'ease-in-out'
				)
				.promise()
				.done(() => {
					$('.container-menu').hide();
				});
			$('.container-lobby').show().animate(
				{ left: '0%' },
				{
					duration: 500
				},
				'ease-in-out'
			);
			$('#btn-acceder-sala').hide();
			$('.sala-lobby').removeClass('select');
			loadListLobby();
		});
}

function loadListLobby() {
	$.post(`https://${GetParentResourceName()}/raceList`, JSON.stringify({}), function (result) {
		$('.carreras').html('');
		if (result && result.length > 0) {
			result.map((v) => {
				$('.carreras').append(`
                    <div class="carrera-lobby sala-lobby" id="${v.roomid}">
                        <div class="campo nombre-carrera">
                            <i class="fa-solid fa-caret-right"></i> ${v.name}
                        </div>
                        <div class="campo vehicle">
                            ${v.vehicle || ' - '}
                        </div>
                        <div class="campo creador">
                            ${v.creator}
                        </div>
                        <div class="campo players">
                            ${v.players}
                        </div>
                    </div>
                `);
			});
		} else {
			$('.carreras').append(`
                    <div class="carrera-lobby">
                        <div class="campo w-100">
                            No rooms available
                        </div>

                    </div>
            `);
		}
	})
		.promise()
		.done(() => {
			eventsLobby();
		});
}

function eventsLobby() {
	$('.btn-crear')
		.off('click')
		.on('click', function () {
			sound_click.currentTime = 0;
			sound_click.play();
			$('.container-lobby')
				.animate(
					{ left: '102%' },
					{
						duration: 500
					},
					'ease-in-out'
				)
				.promise()
				.done(() => {
					$('.container-lobby').hide();
				});
			$('.container-menu').show().animate(
				{ left: '0%' },
				{
					duration: 500
				},
				'ease-in-out'
			);
		});

	$('.sala-lobby')
		.off('click')
		.on('click', function () {
			$('.carrera-lobby').removeClass('select');
			$(this).addClass('select');
			$('#btn-acceder-sala').fadeIn(300);
			$('#btn-acceder-sala')
				.off('click')
				.on('click', function () {
					const idSala = $('.sala-lobby.select').attr('id');
					$.post(`https://${GetParentResourceName()}/joinRoom`, JSON.stringify({ src: idSala }));
					$(this).off('click');
					$('.bgblack').fadeOut(300);
					$('#btn-acceder-sala').fadeOut(300);
				});
		});

	$('#btn-actualizar-salas')
		.off('click')
		.on('click', function () {
			sound_click.currentTime = 0;
			sound_click.play();
			$('#btn-acceder-sala').fadeOut(300);
			loadListLobby();
		});
}

function loadListRaces(list) {
	let ac = Object.values(list);
	$('#carreras-predefinidas').html('');
	createPage(Math.ceil(ac.length / 8), ac);
	change(1, ac);
}

function createRoom(cbdata, img, name, racelaps, weather, hour, explosions, accesible, modo, maxplayers, vehiculo) {
	$(document).off('keydown');
	$('#btn-elegir-vehiculo').show();

	var veh = '';
	_racevehicle = vehiculo.toLowerCase();
	if (vehiculo == 'Default') {
		$('.sala .titles .vehiculo').hide();
		$('#btn-elegir-vehiculo').hide();
	} else {
		$('.sala .titles .vehiculo').show();
		veh = `
            <div class="campo-sala player-vehicle">
                -
            </div>
        `;
	}

	$('.players-sala').html('').append(`
        <div class="player-sala animate__animated animate__zoomIn animate__faster" idPlayer="${cbdata.src}">
            <div class="campo-sala nombre-player">
                <i class="fa-solid fa-user"></i> ${cbdata.nick}
            </div>
            ${veh}
            <div class="campo-sala estado-player">
                Host
            </div>
            <div class="campo-sala accion-player-creador">
                -
            </div>
        </div>
    `);

	$('#btn-invitar-sala').show();
	$('#btn-comenzar-carrera').show();
	$('.container-menu').fadeOut(300, function () {
		$('.loading1').fadeIn(300, function () {
			$('.img-carrera-sala').attr('src', img);
			$('.nombre-carrera .cont-dato').text(name);
			$('.racelaps .cont-dato').text(racelaps);
			$('.weather .cont-dato').text(weather);
			$('.hour .cont-dato').text(hour);
			$('.explosions .cont-dato').text(explosions);
			$('.accesibilidad .cont-dato').text(accesible);
			$('.modo .cont-dato').text(modo);
			$('.vehiculo .cont-dato').text(vehiculo);
			$('.playercount span').text(1 + '/' + maxplayers);
			$('.sala').attr('isOwner', 'true');
			$('.bgblack')
				.delay(2000)
				.fadeOut(300, function () {
					$('.loading1').fadeOut(300);
					$('.sala').fadeIn(1000);
					sound_transition.currentTime = 0;
					sound_transition.play();
				});
		});
	});
	eventsRoom();
	if (_racevehicle != 'default') {
		$('#btn-comenzar-carrera').css('opacity', 0.5);
		$('#btn-comenzar-carrera').off('click');
	} else {
		$('#btn-comenzar-carrera').css('opacity', 1);
		$('#btn-comenzar-carrera')
			.off('click')
			.on('click', function () {
				sound_click.currentTime = 0;
				sound_click.play();
				$(this).off('click');
				$.post(`https://${GetParentResourceName()}/start-race`, JSON.stringify({}));
			});
	}
}

function invitePlayerRoom(idPlayer) {
	$.post(`https://${GetParentResourceName()}/invitePlayer`, JSON.stringify({ idPlayer: idPlayer }));
}

function loadPlayersInvite() {
	let players;
	$.post(
		`https://${GetParentResourceName()}/listPlayersInvite`,
		JSON.stringify({}),
		function (cb) {
			if (cb != '') {
				players = cb;
			}
		}
	)
		.promise()
		.done(() => {
			$('.lista-players-invitar').html('');
			if (players) {
				let p = Object.values(players);
				p.forEach(function (player) {
					$('.lista-players-invitar').append(`
                <div class="player">
                    <div class="n-player">
                        <i class="fa-solid fa-user"></i> ${player.name}
                    </div>
                    <div class="btn-invitar" idPlayer="${player.id}" nPlayer="${player.name}">
                        Invite
                    </div>
                </div>
                `);
				});
				$('.btn-invitar')
					.off('click')
					.on('click', function () {
						invitePlayerRoom(
							$(this).attr('idPlayer')
						);
						$(this).text('Invited').off('click');
					});
				$('.buscador-players')
					.off('keydown')
					.on('keydown', function () {
						let value = $(this).val().toLowerCase();
						$('.player').filter(function () {
							$(this).toggle(
								$(this).text().toLowerCase().indexOf(value) > -1
							);
						});
					});
			} else {
				$('.lista-players-invitar').append(`
            <div class="player">
                            <div class="n-player">
                                No players online
                            </div>

                        </div>
            `);
			}
		});
}

function RestartMenu() {
	$('.container-menu').show();
	$('.container-lobby').show();
	$('.container-menu').fadeIn(300);
	$('.container-principal').fadeIn(300);
	$('.carrera').removeClass('seleccionada');
	$('#btn-crear-carrera').hide();
	$('.tag').removeClass('elegido');
	$('.tag.todas').addClass('elegido');
}

function totNumPages(obj) {
	return Math.ceil(obj.length / obj_per_page);
}

/* FUNCION PARA PAGINACION DE CARRERAS*/
function validURL(str) {
	if (str.startsWith('https://') || str.startsWith('http://')) {
		return true;
	} else {
		return false;
	}
}

function change(page, carrera) {
	$('#carreras-predefinidas').fadeOut(300, function () {
		$(this).html('');
		for (var i = (page - 1) * obj_per_page; i < page * obj_per_page; i++) {
			if (carrera[i] != null || carrera[i] != undefined) {
				if (!validURL(carrera[i].img)) {
					carrera[i].img = '../' + carrera[i].img;
				}

				$('#carreras-predefinidas').append(`
                <div class="col-3 mb-4">
                    <div class="carrera" style="background-image:url('${carrera[i].img}')" raceid="${carrera[i].raceid}" maxplayers="${carrera[i].maxplayers}">
                        <div class="info-carrera">
                            <div class="nombre">${carrera[i].name}</div>
                        </div>
                        <div class="race-times">
                            <img src="./img/rAYsQ5E.png">
                        </div>
                    </div>
                </div>
            `);
			}
		}
		$(this).fadeIn(300);
		$('.carrera')
			.off('click')
			.on('click', function () {
				$('.carrera').removeClass('seleccionada');
				$(this).addClass('seleccionada');
				sound_click.currentTime = 0;
				sound_click.play();
				$('#btn-crear-carrera').fadeIn(300);
			});
		$('.race-times')
			.off('click')
			.on('click', function () {
				let raceid = $(this).parent().attr('raceid');
				sound_transition2.currentTime = '0';
				sound_transition2.play();
				$('.times-container').addClass('show');

				$.post(
					`https://${GetParentResourceName()}/get-race-times`,
					JSON.stringify({ raceid: raceid }),
					function (cb) {
						if (cb && cb.length > 0) {
							if (cb.length > 10) {
								cb = cb.slice(0, 10);
							}
							$('.times-container .table-times').html('');
							let ms = 800;
							cb.map((time, index) => {
								let minutos = Math.floor(time.time / 60000);
								let segundos = Math.floor(
									(time.time - minutos * 60000) / 1000
								);
								let milisegundos =
									time.time - minutos * 60000 - segundos * 1000;
								if (minutos < 10) {
									minutos = '0' + minutos;
								}
								if (segundos < 10) {
									segundos = '0' + segundos;
								}
								milisegundos = milisegundos.toString().substring(0, 2);

								let fecha = time.date.split('/');
								let fechaFinal =
									fecha[1] + '/' + fecha[0] + '/' + fecha[2];

								$('.times-container .table-times').append(`
                    <div class="user-time animate__animated animate__zoomIn" style="animation-delay:${ms}ms; animation-duration:300ms; animation-timing-function:var(--cubic) !important;">
                                <div class="time-position">
                                    ${index + 1}
                                </div>
                                <div class="time-name">
                                    <i class="fas fa-user"></i> ${time.name}
                                </div>
                                <div class="time-vehicle">
                                    <i class="fas fa-car"></i> ${time.vehicle}
                                </div>
                                <div class="time-date">
                                <i class="fas fa-calendar-alt"></i> ${fechaFinal}
                                </div>
                                <div class="time-timer">
                                    <i class="fas fa-stopwatch-20"></i> ${minutos}:${segundos}:${milisegundos}
                                </div>
                            </div>
                    `);
								ms += 200;
							});
						} else {
							$('.times-container .table-times').html('');
							$('.times-container .table-times').append(`
                <div class="user-time">
                            <div class="time-name" style="width:100%">
                               There are no trademarks!
                            </div>
                        </div>
                `);
						}
					}
				);

				$('.times-container .close-button')
					.off('click')
					.on('click', function () {
						$('.times-container').removeClass('show');
					});
			});
	});
	setTimeout(() => {
		eventsSounds();
	}, 500);
}

function createPage(pages, carreras) {
	$('.paginacion').html('');
	for (let i = 0; i < pages; i++) {
		if (i == 0) {
			$('.paginacion').append(`
            <div class="pagina sel">
                ${i + 1}
            </div>
            `);
		} else {
			$('.paginacion').append(`
            <div class="pagina">
                ${i + 1}
            </div>
            `);
		}
	}
	$('.pagina')
		.off('click')
		.on('click', function () {
			let pagina = $(this).text();
			$('#btn-crear-carrera').fadeOut(300);
			$('.pagina').removeClass('sel');
			$(this).addClass('sel');
			change(pagina, carreras);
		});
}

/* FUNCION PARA PAGINACION DE CARRERAS*/

function loadRoom(data, players, invitations, playercount, nameRace, lobby, bool) {
	$(document).off('keydown');
	// $("#btn-invitar-sala").hide();
	$('#btn-invitar-sala').show();

	$('#btn-comenzar-carrera').hide();
	$('#btn-salir-sala').attr('status', 'player');
	$('.container-principal, .container-lobby').fadeOut(300);
	$('.sala').attr('isOwner', 'false');

	let weather = '';
	weathers.forEach(function (weatherA) {
		if (data.weather == weatherA[1]) {
			weather = weatherA[0];
		}
	});

	let explosions = '';
	explosion.forEach(function (explosion) {
		if (data.explosions == explosion[1]) {
			explosions = explosion[0];
		}
	});

	let modo = '';
	racemode.forEach(function (racemode) {
		if (data.modo == racemode[1]) {
			modo = racemode[0];
		}
	});

	let vehiculo = '';
	racevehicle.forEach(function (racevehicle) {
		if (data.vehiculo == racevehicle[1]) {
			vehiculo = racevehicle[0];
		}
	});

	let accesibilidad = '';
	accesible.forEach(function (accesible) {
		if (data.accesible == accesible[1]) {
			accesibilidad = accesible[0];
		}
	});
	$('#btn-elegir-vehiculo').show();

	switch (data.vehiculo) {
		case 'default':
			$('#btn-elegir-vehiculo').hide();
			break;

		case 'specific':
			$('#btn-elegir-vehiculo').hide();
			break;
	}

	updatePlayersRoom(players, invitations, playercount, data.vehiculo);
	if (!lobby) {
		if (bool) {
			$('.bgblack').fadeIn(300, function () {
				$('.loading1').fadeIn(300, function () {
					$('.img-carrera-sala').attr('src', data.img);
					$('.nombre-carrera .cont-dato').text(nameRace);
					$('.racelaps .cont-dato').text(data.racelaps);
					$('.weather .cont-dato').text(weather);
					$('.hour .cont-dato').text(data.hour);
					$('.explosions .cont-dato').text(explosions);
					$('.accesibilidad .cont-dato').text(accesibilidad);
					$('.modo .cont-dato').text(modo);
					$('.vehiculo .cont-dato').text(vehiculo);
					$('.bgblack')
						.delay(2000)
						.fadeOut(300, function () {
							$('.loading1').fadeOut(300);
							$('.sala').fadeIn(1000);
						});
				});
			});
		} else {
			RestartMenu();
		}
	} else {
		if (bool) {
			$('.img-carrera-sala').attr('src', data.img);
			$('.nombre-carrera .cont-dato').text(nameRace);
			$('.racelaps .cont-dato').text(data.racelaps);
			$('.weather .cont-dato').text(weather);
			$('.hour .cont-dato').text(data.hour);
			$('.explosions .cont-dato').text(explosions);
			$('.accesibilidad .cont-dato').text(accesibilidad);
			$('.modo .cont-dato').text(modo);
			$('.vehiculo .cont-dato').text(vehiculo);
			$('.bgblack')
				.fadeOut(300, function () {
					$('.sala').fadeIn(1000);
				});
		} else {
			RestartMenu();
		}
	}
	eventsRoom();
}

function updatePlayersRoom(players, invitations, playercount, t_racevehicle) {
	if (t_racevehicle) {
		_racevehicle = t_racevehicle.toLowerCase();
		if (_racevehicle == 'default') {
			$('.sala .titles .vehiculo').hide();
		} else {
			$('.sala .titles .vehiculo').show();
		}
	}

	if (players && invitations) {
		let p = Object.values(players);
		let comenzar = true;
		$('.players-sala').html('');
		p.forEach(function (player) {
			let label = 'In Room';
			let labelAction = 'Remove';
			let action = 'action="expulsar"';
			let classAction = 'accion-player';
			if (player.ownerRace) {
				label = 'Host';
				labelAction = ' - ';
				action = '';
				classAction = 'accion-player-creador';
			}
			if ($('.sala').attr('isOwner') == 'false') {
				labelAction = ' - ';
				action = '';
				classAction = 'accion-player-creador';
			}

			var veh = '';

			if (_racevehicle && _racevehicle == 'default') {
				comenzar = true;
			}

			if (_racevehicle && _racevehicle == 'specific') {
				veh = `
                    <div class="campo-sala player-vehicle">
                        ${p[0].vehicle || '-'}
                    </div>
                `;
			}

			if (_racevehicle && _racevehicle == 'personal') {
				veh = `
                    <div class="campo-sala player-vehicle">
                        ${player.vehicle || '-'}
                    </div>
                `;
			}

			$('.players-sala').append(`
            <div class="player-sala" idPlayer="${player.src}">
                <div class="campo-sala nombre-player">
                    <i class="fa-solid fa-user"></i> ${player.nick}
                </div>
                ${veh}
                <div class="campo-sala estado-player">
                    ${label}
                </div>
                <div class="campo-sala ${classAction}" ${action}>
                    ${labelAction}
                </div>
            </div>
            `);
		});
		Object.values(invitations).map(function (player) {
			let label = 'Guest';
			let labelAction = 'Remove';
			let action = 'action="cancelar-invi"';
			let classAction = 'accion-player';
			if ($('.sala').attr('isOwner') == 'false') {
				labelAction = ' - ';
				action = '';
				classAction = 'accion-player-creador';
			}
			let veh = '';

			if (_racevehicle && _racevehicle != 'default') {
				veh = `
                    <div class="campo-sala player-vehicle">
                        ${player.vehicle || '-'}
                    </div>
                `;
			}

			$('.players-sala').append(`
            <div class="player-sala" idPlayer="${player.src}">
                <div class="campo-sala nombre-player">
                    <i class="fa-solid fa-user"></i> ${player.nick}
                </div>
                ${veh}
                <div class="campo-sala estado-player">
                    ${label}
                </div>
                <div class="campo-sala ${classAction}" ${action}>
                    ${labelAction}
                </div>
            </div>
            `);
		});

		$('.player-vehicle').each(function () {
			if ($(this).text().trim() == '-') {
				comenzar = false;
			}
		});

		if (comenzar && $('.sala').attr('isOwner') == 'true') {
			$('#btn-comenzar-carrera').css('opacity', 1);
			$('#btn-comenzar-carrera')
				.off('click')
				.on('click', function () {
					sound_click.currentTime = 0;
					sound_click.play();
					$(this).off('click');
					$.post(`https://${GetParentResourceName()}/start-race`, JSON.stringify({}));
				});
		} else {
			$('#btn-comenzar-carrera').css('opacity', 0.5);
			$('#btn-comenzar-carrera').off('click');
		}

		$('.accion-player')
			.off('click')
			.on('click', function () {
				let action = $(this).attr('action');
				let player = $(this).parent().attr('idplayer');

				if (action == 'expulsar') {
					$.post(`https://${GetParentResourceName()}/kickPlayer`, JSON.stringify({ player: player }));
				} else if (action == 'cancelar-invi') {
					$.post(`https://${GetParentResourceName()}/cancelInvi`, JSON.stringify({ player: player }));
				}
			});
	}
	if (playercount) {
		$('.playercount span').text(playercount);
	}
}

function exitRoom(bool) {
	if (resetShowMenu) {
		$('.container-lobby')
		.animate(
			{ left: '102%' },
			{
				duration: 500
			},
			'ease-in-out'
		)
		.promise()
		.done(() => {
			$('.container-lobby').hide();
		});

		$('.container-menu').show().animate(
			{ left: '0%' },
			{
				duration: 500
			},
			'ease-in-out'
		);
		resetShowMenu = false;
	}

	if (resetLeaveRoom) {
		$('.bgblack').fadeIn(500);
		$('.sala')
		.addClass('scale-out2')
		.fadeOut(500, function () {
			$('.container-menu').fadeIn(300);
			$('.container-principal').fadeIn(300);
			$(this).removeClass('scale-out2');
			if (!bool) {
			$.post(`https://${GetParentResourceName()}/leaveRoom`, JSON.stringify({}));
			}
			eventsCreateCareer();
			eventKeydown();
			eventsSounds();
			sound_transition.currentTime = 0;
			sound_transition.play();
		});
		resetLeaveRoom = false;
	}
}

function eventKeydown() {
	$(document).keydown(function (event) {
		var keycode = event.keyCode ? event.keyCode : event.which;

		if (keycode == '27' || keycode == '117') {
			$(document).off('keydown');
			$.post(`https://${GetParentResourceName()}/closeMenu`, JSON.stringify({}));
			$('.in-race-menu').fadeOut(300);
			$('.bgblack').fadeOut(300);
		}
	});
}

function eventKeydownNotifications() {
	$(document).keydown(function (event) {
		var keycode = event.keyCode ? event.keyCode : event.which;

		if (keycode == '27' || keycode == '118') {
			$('.notifications').removeClass('expandidas');
			$(document).off('keydown');
			if ($('.contador').text() == 0) {
				$('.no-invitations').hide();
				$.post(`https://${GetParentResourceName()}/closeMenu`, JSON.stringify({}));
				setTimeout(() => {
					$('.notifications').fadeOut(300);
				}, 1000);
			} else {
				$.post(`https://${GetParentResourceName()}/closeMenu`, JSON.stringify({}));
			}
		}
	});
}

function countDownGo() {
	$('.capa-fondo').fadeIn(300);
	$('.cuenta-atras').text('3');
	$('.comenzando-carrera').fadeIn(300);
	sound_transition2.currentTime = 0;
	sound_transition2.play();
	$('.sala .title, .datos-sala, .zona-botones-sala').css('filter', 'blur(10px)');
	let time = 2;
	let countDownGo = setInterval(() => {
		$('.cuenta-atras').text(time);

		if (time == 0) {
			let sound_start = new Audio('sounds/startrace.mp3');
			sound_start.volume = 0.3;
			sound_start.loop = false;
			sound_start.currentTime = 0;
			sound_start.play();
			clearInterval(countDownGo);
			$('.container-principal, .container-lobby').hide();
			$('.bgblack').fadeIn(300, function () {
				$('.sala')
					.addClass('scale-out2')
					.fadeOut(500, function () {
						$(this).removeClass('scale-out2');
						$('.starting-race').show();
						$('.loading1').fadeIn(300, function () {
							$('.capa-fondo, .comenzando-carrera').hide();
							$('.sala .title, .datos-sala, .zona-botones-sala').css(
								'filter',
								'blur(0px)'
							);
							setupPauseMenu();
						});
					});
			});
		} else {
			sound_second.currentTime = 0;
			sound_second.play();
		}
		time--;
	}, 1000);
}

function eventsSounds() {
	$('.boton, .carrera, .left, .right, .category, .vehicle-button, .race-times')
		.off('mouseenter')
		.mouseenter(function () {
			sound_over.currentTime = 0;
			sound_over.play();
		});

	$('.boton, .carrera, .left, .right, .category, .vehicle-button').click(function () {
		sound_click.currentTime = 0;
		sound_click.play();
	});
}

function tempExplode(time) {
	let aux = time;
	$('.hud .explosion div').html(time / 1000);
	if (inRace) {
		timeExplode = setInterval(() => {
			if (aux == 0) {
				clearInterval(timeExplode);
				tempExplode(time);
			}
			$('.hud .explosion div').html(aux / 1000);
			aux = aux - 1000;
		}, 1000);
	} else {
		return;
	}
}

function showNoty(text) {
	const noty = $(`
    <div class="noty animate__animated animate__backInRight">
            ${text}
        </div>
    `);
	$('.shownotifications').append(noty);
	setTimeout(() => {
		pop.currentTime = '0';
		pop.play();
	}, 500);
	setTimeout(() => {
		$(noty)
			.removeClass('animate__backInRight')
			.addClass('animate__backOutRight')
			.fadeOut(500, function () {
				$(this).remove();
			});
	}, 3000);
}

function timerNF(number) {
	$('.nf-zone').fadeIn(300);
	let timeOut = number / 1000;
	let minutes = Math.floor(timeOut / 60);
    let seconds = timeOut % 60;
    $('.nf-zone span').text(`${minutes < 10 ? '0' : ''}${minutes}:${seconds < 10 ? '0' : ''}${seconds}`);
	let timeNF = setInterval(() => {
        if (timeOut > 1) {
            timeOut--;
            minutes = Math.floor(timeOut / 60);
            seconds = timeOut % 60;
            $('.nf-zone span').text(`${minutes < 10 ? '0' : ''}${minutes}:${seconds < 10 ? '0' : ''}${seconds}`);
        } else {
            clearInterval(timeNF);
            setTimeout(() => {
                $('.nf-zone').fadeOut(300);
            }, 1000);
        }
    }, 1000);
}

function spectateList(players) {
	$('.players-spectate').html('');
	$('.spectate').fadeIn(300);
	players.forEach((v, k) => {
		$('.players-spectate').append(`
        <div class="player-sp d-flex" id="player_spec_${v.playerID}">
            <div class="sp-number">
                ${k + 1}
            </div>
            <div class="sp-nick">
                ${v.playerName}
            </div>
            <div class="eye">
                <i class="fas fa-eye"></i>
            </div>
        </div>
        `);
	});
}

function spectateSelected(playerid) {
	$('.player-sp').removeClass('view');
	$('#player_spec_' + playerid).addClass('view');
	sound_over.currentTime = '0';
	sound_over.play();
}

function setupPauseMenu() {
	const img = $('.datos-sala .img-carrera-sala').attr('src');
	const nombre = $('.datos-sala .nombre-carrera .cont-dato').text();
	const racelaps = $('.datos-sala .racelaps .cont-dato').text();
	const weather = $('.datos-sala .weather .cont-dato').text();
	const hour = $('.datos-sala .hour .cont-dato').text();
	const explosions = $('.datos-sala .explosions .cont-dato').text();
	const accesibilidad = $('.datos-sala .accesibilidad .cont-dato').text();
	const modo = $('.datos-sala .modo .cont-dato').text();

	$('.race-info #p-title').text(nombre);
	$('.race-info #p-racelaps').text(racelaps);
	$('.race-info #p-weather').text(weather);
	$('.race-info #p-hour').text(hour);
	$('.race-info #p-explosions').text(explosions);
	$('.race-info #p-accesibilidad').text(accesibilidad);
	$('.race-info #p-modo').text(modo);
	$('.race-info .race-img').attr('src', img);
}

function eventsRoom() {
	$('#btn-salir-sala')
		.off('click')
		.on('click', function () {
			exitRoom(false);
			sound_click.currentTime = '0';
			sound_click.play();
		});
	$('#btn-elegir-vehiculo')
		.off('click')
		.on('click', function () {
			sound_click.currentTime = 0;
			sound_click.play();
			$('.sala').addClass('animate__animated animate__fadeOutUp').fadeOut(500);
			loadSelectRaceVehicle();
		});

	$('#btn-invitar-sala')
		.off('click')
		.on('click', function () {
			sound_click.currentTime = 0;
			sound_click.play();
			$('.invitar-box').fadeIn(300);
			$('.capa-fondo').fadeIn(300);
			loadPlayersInvite();
			$('.invitar-box .close-box')
				.off('click')
				.on('click', function () {
					$('.capa-fondo').fadeOut(300);

					$(this)
						.parent()
						.removeClass('scale-in2')
						.addClass('scale-out2')
						.fadeOut(300, function () {
							$(this).removeClass('scale-out2').addClass('scale-in2');
						});
				});
		});
}

function updatePositionTable(table) {
	if (table) {
		$('.flex-position').html('');
		table.map((p) => {
			$('.flex-position').append(`
            <div class="position-label">
                <div class="position-number">
                    ${p.position}
                </div>
                <div class="position-name">
                    <div class="position-user">
                        ${p.name}
                    </div>
                    <div class="position-time">
                        ${p.meters || ''}
                    </div>
                </div>
            </div>
            `);
		});
		if (!$('.position-table-container').hasClass('show') && inRace) {
			$('.position-table-container').addClass('show');
		}
	}
}

/* to-do
function translateHtmlText(number) {
	if (translations[number]) {
		document.querySelectorAll('[data-translate]').forEach(element => {
			const key = element.getAttribute('data-translate');
			if (translations[number][key]) {
				element.textContent = translations[number][key];
			}
		});
	}
}

function getTranslateHtmlText(number) {

}
*/