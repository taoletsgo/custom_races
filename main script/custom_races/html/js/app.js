//Data
let races_data_front = {};
let current_category;
let need_refresh = false;

//Status
let inRaceMenu = false;
let inSpectatorMode = false;
let resetLeaveRoom = false;
let resetShowMenu = false;

//Html text
let no_ranking_result;
let no_race_room;
let no_invite_result;
let room_status_host;
let room_status_guest;
let room_status_in;
let room_invite_invite;
let room_invite_invited;

//Pausemenu
let pausemenu_img;
let pausemenu_title;
let pausemenu_weather;
let pausemenu_time;
let pausemenu_traffic;
let pausemenu_dnf;
let pausemenu_accessible;
let pausemenu_mode;

//Define
var obj_per_page = 8;
var race_vehicle;

//Option
let lapOption = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16];
let weatherOption = [
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
let timeOption = [
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
let trafficOption = [
	['OFF', 'off'],
	['ON', 'on']
];
let dnfOption = [
	['OFF', 'off'],
	['25%', '0.25'],
	['50%', '0.50'],
	['75%', '0.75']
];
let accessibleOption = [
	['Public', 'public'],
	['Private', 'private']
];
let modeOption = [
	['No Collisions', 'no_collision'],
	['Normal', 'normal'],
	['GTA', 'gta']
];
let vehicleOption = [
	['Default', 'default'],
	['Specific', 'specific'],
	['Personal', 'personal']
];

//Sound
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

$(document).ready(() => {});

window.addEventListener('message', function (event) {
	if (event.data.action == 'language') {
		translateHtmlText(event.data.texts);
		no_ranking_result = event.data.texts["menu-no-ranking-result"];
		no_race_room = event.data.texts["lobby-no-race-room"];
		no_invite_result = event.data.texts["room-no-invite-result"];
		room_status_host = event.data.texts["room-status-host"];
		room_status_guest = event.data.texts["room-status-guest"];
		room_status_in = event.data.texts["room-status-in"];
		room_action_remove = event.data.texts["room-action-remove"];
		room_invite_invite = event.data.texts["room-invite-invite"];
		room_invite_invited = event.data.texts["room-invite-invited"];
		weatherOption.forEach(function (race_weather) {
			race_weather[0] = event.data.texts[race_weather[1]];
		});
		accessibleOption.forEach(function (race_accessible) {
			race_accessible[0] = event.data.texts[race_accessible[1]];
		});
		modeOption.forEach(function (race_mode) {
			race_mode[0] = event.data.texts[race_mode[1]];
		});
		vehicleOption.forEach(function (race_vehicle) {
			race_vehicle[0] = event.data.texts[race_vehicle[1]];
		});
	}

	if (event.data.action == 'openMenu') {
		races_data_front = event.data.races_data_front;
		inRaceMenu = event.data.inrace;
		need_refresh = event.data.needRefresh;
		openRaceLobby();
	}

	if (event.data.action == 'openNotifications') {
		openNotifications();
	}

	if (event.data.action == 'receiveInvitationClient') {
		receiveInvitationClient(
			event.data.info.title,
			event.data.info.race,
			event.data.info.roomid,
			event.data.info.accept,
			event.data.info.cancel
		);
	}

	if (event.data.action == 'joinPlayerRoom') {
		resetLeaveRoom = true;
		resetShowMenu = true;
		$('#btn-choose-vehicle').css('opacity', 1);
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
		$('#btn-choose-vehicle').css('opacity', 1);
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
		$('.lobby-rooms').html('');
		if (result && result.length > 0) {
			result.map((v) => {
				let vehicle = ' - ';
				vehicleOption.forEach(function (race_vehicle) {
					if (v.vehicle == race_vehicle[1]) {
						vehicle = race_vehicle[0];
					}
				});
				$('.lobby-rooms').append(`
				<div class="lobby-race lobby-room" id="${v.roomid}">
					<div class="lobby-field room-name"><i class="fa-solid fa-caret-right"></i>${v.name}</div>
					<div class="lobby-field room-vehicle">${vehicle}</div>
					<div class="lobby-field room-creator">${v.creator}</div>
					<div class="lobby-field room-players">${v.players}</div>
				</div>
				`);
			});
		} else {
			$('.lobby-rooms').append(`
			<div class="lobby-race">
				<div class="lobby-field w-100" data-translate="lobby-no-race-room">${no_race_room}</div>
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
		$('.bgblack').delay(1000).fadeOut(300, function () {
			$('.loading1').fadeOut(300);
			RestartMenu();
		});
	}

	if (event.data.action == 'exitRoom') {
		races_data_front = event.data.syncData;
		exitRoom(event.data.boolean);
	}

	if (event.data.action == 'removeInvitation') {
		$('[roomid=' + event.data.roomid + ']').animate(
			{
				opacity: 0
			},
			300,
			function () {
				$(this).remove();
				updateNotifications();
			}
		);
	}

	if (event.data.action == 'updatePauseMenu') {
		pausemenu_img = event.data.img;
		pausemenu_title = event.data.title;
		weatherOption.forEach(function (race_weather) {
			if (event.data.weather == race_weather[1]) {
				pausemenu_weather = race_weather[0];
			}
		});
		pausemenu_time = event.data.time;
		trafficOption.forEach(function (race_traffic) {
			if (event.data.traffic == race_traffic[1]) {
				pausemenu_traffic = race_traffic[0];
			}
		});
		dnfOption.forEach(function (race_dnf) {
			if (event.data.dnf == race_dnf[1]) {
				pausemenu_dnf = race_dnf[0];
			}
		});
		accessibleOption.forEach(function (race_accessible) {
			if (event.data.accessible == race_accessible[1]) {
				pausemenu_accessible = race_accessible[0];
			}
		});
		modeOption.forEach(function (race_mode) {
			if (event.data.mode == race_mode[1]) {
				pausemenu_mode = race_mode[0];
			}
		});
		setupPauseMenu();
	}

	if (event.data.action == 'showRaceHud') {
		$('.hud').removeClass('scale-out-hud').addClass('scale-in-hud').show();
	}

	if (event.data.action == 'hideRaceHud') {
		$('.hud').removeClass('scale-in-hud').addClass('scale-out-hud');
		$('.nf-zone').fadeOut(300);
		setTimeout(() => {
			$('.hud').hide();
		}, 2000);
	}

	if (event.data.action == 'hidePositionUI') {
		$('.position-table-container').removeClass('show');
	}

	if (event.data.position) {
		$('.position span').html(event.data.position);
	}

	if (event.data.checkpoints) {
		$('.checkpoints div').text(event.data.checkpoints);
	}

	if (event.data.laps) {
		$('.racing-lap div').text(event.data.laps);
	}

	if (event.data.time) {
		$('.counter div').text(event.data.time);
	}

	if (event.data.action == 'showScoreboard') {
		if (event.data.animation) {
			$('.finish-race').removeClass('animate__backOutDown').addClass('animate__backInUp');
			$('.finish-race').css('display', 'flex');
			sound_transition2.currentTime = 0;
			sound_transition2.play();
			$('.hud').removeClass('scale-in-hud').addClass('scale-out-hud');
			$('.nf-zone').fadeOut(300);
			setTimeout(() => {
				$('.hud').hide();
			}, 2000);
		}
		$('.finish-race table tbody').html('');
		event.data.racefrontpos.map((p) => {
			$('.finish-race table tbody').append(`
			<tr>
				<td class="td-position"><span class="n-position">${p.position}</span>${p.name}</td>
				<td class="text-center">${p.vehicle}</td>
				<td class="text-center">${p.totaltime}</td>
				<td class="text-center">${p.bestLap}</td>
			</tr>
			`);
		});
	}

	if (event.data.action == 'hideScoreboard') {
		$('.finish-race').removeClass('animate__backInUp').addClass('animate__backOutDown');
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
		$('.respawn').fadeIn(300);
	}

	if (event.data.action == 'hideRestartPosition') {
		$('.respawn').fadeOut(300);
	}

	if (event.data.action == 'startNFCountdown') {
		timerNF(event.data.endtime);
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
					$(this).removeClass('animate__backOutUp').addClass('animate__backInDown');
				});
		}, 4000);
	}

	if (event.data.action == 'showSpectate') {
		spectateList(event.data.players, event.data.playerid, event.data.sound);
	}

	if (event.data.action == 'hideSpectate') {
		$('.spectate').fadeOut(300);
		inSpectatorMode = false;
	}

	if (event.data.frontpos) {
		updatePositionTable(event.data.frontpos, event.data.visible, event.data.labels);
	}
});

function openRaceLobby() {
	sound_transition.currentTime = 0;
	sound_transition.play();

	if (inRaceMenu) {
		$('.in-race-menu').fadeIn(300, function () {
			eventKeydown();
		});
		$('#btn-quit-race')
			.off('click')
			.on('click', function () {
				$(document).off('keydown');
				$('.in-race-menu').fadeOut(300);
				$.post(`https://${GetParentResourceName()}/CloseNUI`, JSON.stringify({}));
				$.post(`https://${GetParentResourceName()}/leaveRace`, JSON.stringify({}));
			});

		$('#btn-join-spectator')
			.off('click')
			.on('click', function () {
				$(document).off('keydown');
				$('.in-race-menu').fadeOut(300);
				$.post(`https://${GetParentResourceName()}/CloseNUI`, JSON.stringify({}));
				$.post(`https://${GetParentResourceName()}/joinSpectator`, JSON.stringify({}));
			});
	} else {
		eventsMenu();
		$('.bgblack').fadeIn(300, function () {
			eventKeydown();
		});
	}
}

function openNotifications() {
	if ($('.invitations-count').text() != 0) {
		$('.notifications').addClass('expanded');
		eventKeydownNotifications();
	} else {
		$('.notifications').addClass('expanded').fadeIn(300);
		$('.no-invitations').show();
		$('.raceinvitations').hide();
		$.post(`https://${GetParentResourceName()}/CloseNUI`);
		setTimeout(() => {
			$('.no-invitations').hide();
			$('.notifications').removeClass('expanded');
			setTimeout(() => {
				if ($('.invitations-count').text() == 0) {
					$('.notifications').fadeOut(300);
				}
			}, 500)
		}, 5000)
	}
}

function receiveInvitationClient(title, race, roomid, accept, cancel) {
	const uniqueId = `invitation-${roomid}-${Date.now()}`;
	$('.raceinvitations').append(`
	<div class="invitation" id="${uniqueId}" roomid="${roomid}">
		<div class="title-invitation"><i class="fas fa-flag-checkered"></i>${title}</div>
		<div class="details-invitation">${race}</div>
		<div class="buttons-invi border-top">
			<div class="accept border-end"><i class="fas fa-check"></i>${accept}</div>
			<div class="cancel"><i class="fas fa-times"></i>${cancel}</div>
		</div>
	</div>
	`);
	$(`#${uniqueId} .cancel`)
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
						if ($('.invitations-count').text() == 0) {
							$(document).off('keydown');
							$.post(`https://${GetParentResourceName()}/CloseNUI`);
						}
					}
				);
		});
	$(`#${uniqueId} .accept`)
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
						$.post(`https://${GetParentResourceName()}/acceptInvitation`, JSON.stringify({ src: roomid }));
						$('.notifications').removeClass('expanded');
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
		$('.invitations-count').text($('.invitation').length);
		$('.notifications').fadeIn(300);
	} else {
		$('.notifications').removeClass('expanded');
		setTimeout(() => {
			$('.notifications').fadeOut(300);
		}, 500);
		$('.invitations-count').text($('.invitation').length);
		$('.raceinvitations').hide();
	}
}

function eventsMenu() {
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
		if (!$('.race-filter .' + categoryClass).length) {
			if (i == 0) {
				current_category = category;
				$('.race-filter').append(`
				<div class="tag ${categoryClass} filter-selected">${category}</div>
				`);
				$('#btn-create-race')
					.removeClass("animate__animated animate__fadeInUp")
					.addClass("animate__animated animate__fadeOutDown")
					.fadeOut(300);
				loadRacesList(races_data_front[category]);
			} else {
				$('.race-filter').append(`
				<div class="tag ${categoryClass}">${category}</div>
				`);
			}
		}
	});

	if (need_refresh && current_category !== undefined && current_category !== null && races_data_front.hasOwnProperty) {
		need_refresh = false;
		$('#btn-create-race')
			.removeClass("animate__animated animate__fadeInUp")
			.addClass("animate__animated animate__fadeOutDown")
			.fadeOut(300);
		loadRacesList(races_data_front[current_category])
	}

	$('.selector .right')
		.off('click')
		.on('click', function () {
			let val;
			let pos = parseInt($(this).parent().find('.content').attr('pos'));
			let nButton = '';

			if ($(this).parent().hasClass('weather')) {
				val = weatherOption;
			}

			if ($(this).parent().hasClass('laps')) {
				val = lapOption;
				nButton = 'laps';
			}

			if ($(this).parent().hasClass('time')) {
				val = timeOption;
				nButton = 'time';
			}

			if ($(this).parent().hasClass('traffic')) {
				val = trafficOption;
			}

			if ($(this).parent().hasClass('dnf')) {
				val = dnfOption;
			}

			if ($(this).parent().hasClass('accessible')) {
				val = accessibleOption;
			}

			if ($(this).parent().hasClass('racemode')) {
				val = modeOption;
			}

			if ($(this).parent().hasClass('racevehicle')) {
				val = vehicleOption;
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
					let zone, zone2;
					if (nButton == 'time' || nButton == 'laps') {
						zone = val[pos];
						zone2 = val[pos];
					} else {
						zone = val[pos][0];
						zone2 = val[pos][1];
					}
					$(this).parent().find('.content').attr('value', zone2);
					$(this)
						.parent()
						.find('.content')
						.find('div')
						.css('transform', 'translateX(-90px)')
						.text(zone)
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
			let nButton = '';

			if ($(this).parent().hasClass('weather')) {
				val = weatherOption;
			}

			if ($(this).parent().hasClass('laps')) {
				val = lapOption;
				nButton = 'laps';
			}

			if ($(this).parent().hasClass('time')) {
				val = timeOption;
				nButton = 'time';
			}

			if ($(this).parent().hasClass('traffic')) {
				val = trafficOption;
			}

			if ($(this).parent().hasClass('dnf')) {
				val = dnfOption;
			}

			if ($(this).parent().hasClass('accessible')) {
				val = accessibleOption;
			}

			if ($(this).parent().hasClass('racemode')) {
				val = modeOption;
			}

			if ($(this).parent().hasClass('racevehicle')) {
				val = vehicleOption;
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
					let zone, zone2;
					if (nButton == 'time' || nButton == 'laps') {
						zone = val[pos];
						zone2 = val[pos];
					} else {
						zone = val[pos][0];
						zone2 = val[pos][1];
					}
					$(this).parent().find('.content').attr('value', zone2);
					$(this)
						.parent()
						.find('.content')
						.find('div')
						.css('transform', 'translateX(-90px)')
						.text(zone)
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
			$('.tag').removeClass('filter-selected');
			$(this).addClass('filter-selected');
			current_category = $(this).text().trim();
			$('#btn-create-race')
				.removeClass("animate__animated animate__fadeInUp")
				.addClass("animate__animated animate__fadeOutDown")
				.fadeOut(300);
			loadRacesList(races_data_front[$(this).text().trim()]);
		});

	$('.btn-random')
		.off('click')
		.on('click', function () {
			$.post(
				`https://${GetParentResourceName()}/GetRandomRace`,
				JSON.stringify({}),
				function (cb) {
					if (cb) {
						$('.tag').removeClass('filter-selected');
						$('#btn-create-race')
							.removeClass("animate__animated animate__fadeInUp")
							.addClass("animate__animated animate__fadeOutDown")
							.fadeOut(300);
						loadRacesList(cb)
					}
				}
			);
		});

	$('.search-race')
		.off('keyup')
		.on('keyup', function (e) {
			if (e.which === 13) {
				let value = $(this).val();
				$.post(
					`https://${GetParentResourceName()}/filterRaces`,
					JSON.stringify({ name: value }),
					function (cb) {
						if (cb) {
							$('.tag').removeClass('filter-selected');
							$('#btn-create-race')
								.removeClass("animate__animated animate__fadeInUp")
								.addClass("animate__animated animate__fadeOutDown")
								.fadeOut(300);
							loadRacesList(cb)
						}
					}
				);
			}
		});

	$('#btn-create-race')
		.off('click')
		.on('click', function () {
			$(this).off('click');
			let raceid = $('.menu-map.race-selected').attr('raceid');
			let maxplayers = $('.menu-map.race-selected').attr('maxplayers');
			let laps = $('.laps .content').attr('value');
			let weather = $('.weather .content').attr('value');
			let time = $('.time .content').attr('value').split(':');
			let traffic = $('.traffic .content').attr('value');
			let dnf = $('.dnf .content').attr('value');
			let accessible = $('.accessible .content').attr('value');
			let name = $('.menu-map.race-selected .name-map').text().replace('–', '-');
			let img = $('.menu-map.race-selected').css('background-image');
			let mode = $('.racemode .content').attr('value');
			let vehicle = $('.racevehicle .content').attr('value');
			img = /^url\((['"]?)(.*)\1\)$/.exec(img);
			img = img ? img[2] : '';
			resetLeaveRoom = true;
			resetShowMenu = false;
			$('#btn-choose-vehicle').css('opacity', 1);
			$.post(
				`https://${GetParentResourceName()}/new-race`,
				JSON.stringify({
					raceid: raceid,
					laps: laps,
					weather: weather,
					time: time[0],
					traffic: traffic,
					dnf: dnf,
					accessible: accessible,
					img: img,
					mode: mode,
					name: name,
					maxplayers: parseInt(maxplayers),
					vehicle: vehicle
				}),
				function (cb) {
					if (cb) {
						createRoom(
							cb,
							img,
							name,
							laps,
							weather,
							time[0],
							traffic,
							dnf,
							accessible,
							mode,
							maxplayers,
							vehicle
						);
					}
				}
			);
		});

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
			$('#btn-join-room').hide();
			$('.lobby-room').removeClass('select');
			loadListLobby();
		});
}

function loadListLobby() {
	$.post(`https://${GetParentResourceName()}/raceList`, JSON.stringify({}), function (result) {
		$('.lobby-rooms').html('');
		if (result && result.length > 0) {
			result.map((v) => {
				let vehicle = ' - ';
				vehicleOption.forEach(function (race_vehicle) {
					if (v.vehicle == race_vehicle[1]) {
						vehicle = race_vehicle[0];
					}
				});
				$('.lobby-rooms').append(`
				<div class="lobby-race lobby-room" id="${v.roomid}">
					<div class="lobby-field room-name"><i class="fa-solid fa-caret-right"></i>${v.name}</div>
					<div class="lobby-field room-vehicle">${vehicle}</div>
					<div class="lobby-field room-creator">${v.creator}</div>
					<div class="lobby-field room-players">${v.players}</div>
				</div>
				`);
			});
		} else {
			$('.lobby-rooms').append(`
			<div class="lobby-race">
				<div class="lobby-field w-100" data-translate="lobby-no-race-room">${no_race_room}</div>
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
	$('.btn-lobby-create')
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

	$('.lobby-room')
		.off('click')
		.on('click', function () {
			$('.lobby-race').removeClass('select');
			$(this).addClass('select');
			$('#btn-join-room').fadeIn(300);
			$('#btn-join-room')
				.off('click')
				.on('click', function () {
					const roomid = $('.lobby-room.select').attr('id');
					$.post(`https://${GetParentResourceName()}/joinRoom`, JSON.stringify({ src: roomid }));
					$(this).off('click');
					$('.bgblack').fadeOut(300);
					$('#btn-join-room').fadeOut(300);
				});
		});

	$('#btn-update-rooms')
		.off('click')
		.on('click', function () {
			sound_click.currentTime = 0;
			sound_click.play();
			$('#btn-join-room').fadeOut(300);
			loadListLobby();
		});
}

function loadRacesList(list) {
	let ac = Object.values(list);
	$('#races-predefined').html('');
	createPage(Math.ceil(ac.length / 8), ac);
	change(1, ac);
}

function createRoom(cbdata, img, name, laps, _weather, time, _traffic, _dnf, _accessible, _mode, maxplayers, _vehicle) {
	$(document).off('keydown');
	$('#btn-choose-vehicle').show();
	$('.room').removeClass('animate__animate animate__fadeInDown');

	let weather = '';
	weatherOption.forEach(function (race_weather) {
		if (_weather == race_weather[1]) {
			weather = race_weather[0];
		}
	});

	let traffic = '';
	trafficOption.forEach(function (race_traffic) {
		if (_traffic == race_traffic[1]) {
			traffic = race_traffic[0];
		}
	});

	let dnf = '';
	dnfOption.forEach(function (race_dnf) {
		if (_dnf == race_dnf[1]) {
			dnf = race_dnf[0];
		}
	});

	let accessible = '';
	accessibleOption.forEach(function (race_accessible) {
		if (_accessible == race_accessible[1]) {
			accessible = race_accessible[0];
		}
	});

	let mode = '';
	modeOption.forEach(function (race_mode) {
		if (_mode == race_mode[1]) {
			mode = race_mode[0];
		}
	});

	let vehicle = '';
	vehicleOption.forEach(function (race_vehicle) {
		if (_vehicle == race_vehicle[1]) {
			vehicle = race_vehicle[0];
		}
	});

	var veh = '';
	race_vehicle = _vehicle;
	if (_vehicle == 'default') {
		$('.room .titles .label-2').hide();
		$('#btn-choose-vehicle').hide();
	} else {
		$('.room .titles .label-2').show();
		veh = `<div class="room-field player-vehicle">-</div>`;
	}

	$('.players-room').html('').append(`
	<div class="player-room animate__animated animate__zoomIn animate__faster" idPlayer="${cbdata.src}">
		<div class="room-field player-name"><i class="fa-solid fa-user"></i>${cbdata.nick}</div>
		${veh}
		<div class="room-field player-state">${room_status_host}</div>
		<div class="room-field action-player-creator">-</div>
	</div>
	`);

	$('#btn-invite-players').show();
	$('#btn-start-race').show();
	$('.container-menu').fadeOut(300, function () {
		$('.loading1').fadeIn(300, function () {
			$('.race-room-img').attr('src', img);
			$('.name-race .data-room').text(name);
			$('.laps .data-room').text(laps);
			$('.weather .data-room').text(weather);
			$('.time .data-room').text(time + ":00");
			$('.traffic .data-room').text(traffic);
			$('.dnf .data-room').text(dnf);
			$('.accessible .data-room').text(accessible);
			$('.mode .data-room').text(mode);
			$('.race-vehicle .data-room').text(vehicle);
			$('.playercount span').text(1 + '/' + maxplayers);
			$('.room').attr('isOwner', 'true');
			$('.bgblack')
				.delay(2000)
				.fadeOut(300, function () {
					$('.loading1').fadeOut(300);
					$('.room').fadeIn(1000);
					sound_transition.currentTime = 0;
					sound_transition.play();
				});
		});
	});
	eventsRoom();
	if (_vehicle != 'default') {
		$('#btn-start-race').css('opacity', 0.5);
		$('#btn-start-race').off('click');
	} else {
		$('#btn-start-race').css('opacity', 1);
		$('#btn-start-race')
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

function loadInvitePlayers() {
	let players;
	$('.invite-players-list').html('');
	$.post(
		`https://${GetParentResourceName()}/InvitePlayerslist`,
		JSON.stringify({}),
		function (cb) {
			if (cb != '') {
				players = cb;
			}
		}
	)
		.promise()
		.done(() => {
			if (players) {
				let p = Object.values(players);
				p.forEach(function (player) {
					$('.invite-players-list').append(`
					<div class="player">
						<div class="n-player"><i class="fa-solid fa-user"></i>${player.name}</div>
						<div class="btn-invite" idPlayer="${player.id}" nPlayer="${player.name}">${room_invite_invite}</div>
					</div>
					`);
				});
				$('.btn-invite')
					.off('click')
					.on('click', function () {
						invitePlayerRoom(
							$(this).attr('idPlayer')
						);
						$(this).text(room_invite_invited).off('click');
					});
				$('.search-players')
					.off('keyup')
					.on('keyup', function (e) {
						if (e.which === 13) {
							let value = $(this).val().toLowerCase();
							$('.player').filter(function () {
								$(this).toggle(
									$(this).text().toLowerCase().indexOf(value) > -1
								);
							});
						}
					});
			} else {
				$('.invite-players-list').append(`
				<div class="player">
					<div class="no-result" data-translate="room-no-invite-result">${no_invite_result}</div>
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
	$('.menu-map').removeClass('race-selected');
	$('#btn-create-race').hide();
}

function totNumPages(obj) {
	return Math.ceil(obj.length / obj_per_page);
}

function validURL(str) {
	if (str.startsWith('https://') || str.startsWith('http://')) {
		return true;
	} else {
		return false;
	}
}

function change(page, map) {
	$('#races-predefined').fadeOut(300, function () {
		$(this).html('');
		for (var i = (page - 1) * obj_per_page; i < page * obj_per_page; i++) {
			if (map[i] != null || map[i] != undefined) {
				if (!validURL(map[i].img)) {
					map[i].img = '../' + map[i].img;
				}

				$('#races-predefined').append(`
				<div class="col-3 mb-4">
					<div class="menu-map" style="background-image:url('${map[i].img}')" raceid="${map[i].raceid}" maxplayers="${map[i].maxplayers}">
						<div class="info-map">
							<div class="name-map">${map[i].name}</div>
						</div>
						<div class="race-times"><img src="./img/rAYsQ5E.png"></div>
					</div>
				</div>
				`);
			}
		}
		$(this).fadeIn(300);
		$('.menu-map')
			.off('click')
			.on('click', function () {
				$('.menu-map').removeClass('race-selected');
				$(this).addClass('race-selected');
				sound_click.currentTime = 0;
				sound_click.play();
				$('#btn-create-race')
					.removeClass("animate__animated animate__fadeOutDown")
					.addClass("animate__animated animate__fadeInUp")
					.fadeIn(300);
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
								let minutes = Math.floor(time.time / 60000);
								let seconds = Math.floor((time.time - minutes * 60000) / 1000);
								let milliseconds = time.time - minutes * 60000 - seconds * 1000;
								if (minutes < 10) {
									minutes = '0' + minutes;
								}
								if (seconds < 10) {
									seconds = '0' + seconds;
								}
								milliseconds = milliseconds.toString().substring(0, 2);

								let date = time.date.split('/');
								let dateFinal = date[1] + '/' + date[0] + '/' + date[2];

								$('.times-container .table-times').append(`
								<div class="user-time animate__animated animate__zoomIn" style="animation-delay:${ms}ms; animation-duration:300ms; animation-timing-function:var(--cubic) !important;">
									<div class="time-position">${index + 1}</div>
									<div class="time-name"><i class="fas fa-user"></i>${time.name}</div>
									<div class="time-vehicle"><i class="fas fa-car"></i>${time.vehicle}</div>
									<div class="time-date"><i class="fas fa-calendar-alt"></i>${dateFinal}</div>
									<div class="time-timer"><i class="fas fa-stopwatch-20"></i>${minutes}:${seconds}:${milliseconds}</div>
								</div>
								`);
								ms += 200;
							});
						} else {
							$('.times-container .table-times').html('');
							$('.times-container .table-times').append(`
							<div class="user-time">
								<div class="time-name" style="width:100%" data-translate="menu-no-ranking-result">${no_ranking_result}</div>
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

function createPage(pages, ac) {
	$('.races-page').html('');
	for (let i = 0; i < pages; i++) {
		if (i == 0) {
			$('.races-page').append(`
			<div class="page-number sel">${i + 1}</div>
			`);
		} else {
			$('.races-page').append(`
			<div class="page-number">${i + 1}</div>
			`);
		}
	}

	$('.page-number')
		.off('click')
		.on('click', function () {
			let page = $(this).text();
			$('#btn-create-race')
				.removeClass("animate__animated animate__fadeInUp")
				.addClass("animate__animated animate__fadeOutDown")
				.fadeOut(300);
			$('.page-number').removeClass('sel');
			$(this).addClass('sel');
			change(page, ac);
		});
}

function loadRoom(data, players, invitations, playercount, nameRace, lobby, bool) {
	$(document).off('keydown');
	$('#btn-invite-players').show();
	$('#btn-start-race').hide();
	$('#btn-leave-race').attr('status', 'player');
	$('.container-principal, .container-lobby').fadeOut(300);
	$('.room').attr('isOwner', 'false');
	$('.room').removeClass('animate__animate animate__fadeInDown');

	let weather = '';
	weatherOption.forEach(function (race_weather) {
		if (data.weather == race_weather[1]) {
			weather = race_weather[0];
		}
	});

	let traffic = '';
	trafficOption.forEach(function (race_traffic) {
		if (data.traffic == race_traffic[1]) {
			traffic = race_traffic[0];
		}
	});

	let dnf = '';
	dnfOption.forEach(function (race_dnf) {
		if (data.dnf == race_dnf[1]) {
			dnf = race_dnf[0];
		}
	});

	let accessible = '';
	accessibleOption.forEach(function (race_accessible) {
		if (data.accessible == race_accessible[1]) {
			accessible = race_accessible[0];
		}
	});

	let mode = '';
	modeOption.forEach(function (race_mode) {
		if (data.mode == race_mode[1]) {
			mode = race_mode[0];
		}
	});

	let vehicle = '';
	vehicleOption.forEach(function (race_vehicle) {
		if (data.vehicle == race_vehicle[1]) {
			vehicle = race_vehicle[0];
		}
	});

	$('#btn-choose-vehicle').show();

	switch (data.vehicle) {
		case 'default':
			$('#btn-choose-vehicle').hide();
			break;

		case 'specific':
			$('#btn-choose-vehicle').hide();
			break;
	}

	updatePlayersRoom(players, invitations, playercount, data.vehicle);

	if (!lobby) {
		if (bool) {
			$('.bgblack').fadeIn(300, function () {
				$('.loading1').fadeIn(300, function () {
					$('.race-room-img').attr('src', data.img);
					$('.name-race .data-room').text(nameRace);
					$('.laps .data-room').text(data.laps);
					$('.weather .data-room').text(weather);
					$('.time .data-room').text(data.time + ":00");
					$('.traffic .data-room').text(traffic);
					$('.dnf .data-room').text(dnf);
					$('.accessible .data-room').text(accessible);
					$('.mode .data-room').text(mode);
					$('.race-vehicle .data-room').text(vehicle);
					$('.bgblack')
						.delay(2000)
						.fadeOut(300, function () {
							$('.loading1').fadeOut(300);
							if (resetLeaveRoom) {
								$('.room').fadeIn(1000);
							} else {
								$.post(`https://${GetParentResourceName()}/closeMenu`, JSON.stringify({}));
								$('.in-race-menu').fadeOut(300);
								$('.bgblack').fadeOut(300);
							}
						});
				});
			});
		} else {
			RestartMenu();
		}
	} else {
		if (bool) {
			$('.race-room-img').attr('src', data.img);
			$('.name-race .data-room').text(nameRace);
			$('.laps .data-room').text(data.laps);
			$('.weather .data-room').text(weather);
			$('.time .data-room').text(data.time + ":00");
			$('.traffic .data-room').text(traffic);
			$('.dnf .data-room').text(dnf);
			$('.accessible .data-room').text(accessible);
			$('.mode .data-room').text(mode);
			$('.race-vehicle .data-room').text(vehicle);
			$('.bgblack')
				.fadeOut(300, function () {
					if (resetLeaveRoom) {
						$('.room').fadeIn(1000);
					} else {
						$.post(`https://${GetParentResourceName()}/closeMenu`, JSON.stringify({}));
						$('.in-race-menu').fadeOut(300);
						$('.bgblack').fadeOut(300);
					}
				});
		} else {
			RestartMenu();
		}
	}
	eventsRoom();
}

function updatePlayersRoom(players, invitations, playercount, vehicle) {
	if (vehicle) {
		race_vehicle = vehicle;
		if (race_vehicle == 'default') {
			$('.room .titles .label-2').hide();
		} else {
			$('.room .titles .label-2').show();
		}
	}

	if (players && invitations) {
		let p = Object.values(players);
		let start = true;
		$('.players-room').html('');
		p.forEach(function (player) {
			let label = room_status_in;
			let labelAction = room_action_remove;
			let action = 'action="kick"';
			let classAction = 'action-player';
			if (player.ownerRace) {
				label = room_status_host;
				labelAction = ' - ';
				action = '';
				classAction = 'action-player-creator';
			}
			if ($('.room').attr('isOwner') == 'false') {
				labelAction = ' - ';
				action = '';
				classAction = 'action-player-creator';
			}

			var veh = '';

			if (race_vehicle && race_vehicle == 'default') {
				start = true;
			}

			if (race_vehicle && race_vehicle == 'specific') {
				veh = `<div class="room-field player-vehicle">${p[0].vehicle || '-'}</div>`;
			}

			if (race_vehicle && race_vehicle == 'personal') {
				veh = `<div class="room-field player-vehicle">${player.vehicle || '-'}</div>`;
			}

			$('.players-room').append(`
			<div class="player-room" idPlayer="${player.src}">
				<div class="room-field player-name"><i class="fa-solid fa-user"></i>${player.nick}</div>
				${veh}
				<div class="room-field player-state">${label}</div>
				<div class="room-field ${classAction}" ${action}>${labelAction}</div>
			</div>
			`);
		});
		Object.values(invitations).map(function (player) {
			let label = room_status_guest;
			let labelAction = room_action_remove;
			let action = 'action="cancel-invi"';
			let classAction = 'action-player';
			if ($('.room').attr('isOwner') == 'false') {
				labelAction = ' - ';
				action = '';
				classAction = 'action-player-creator';
			}
			let veh = '';

			if (race_vehicle && race_vehicle != 'default') {
				veh = `<div class="room-field player-vehicle">${player.vehicle || '-'}</div>`;
			}

			$('.players-room').append(`
			<div class="player-room" idPlayer="${player.src}">
				<div class="room-field player-name"><i class="fa-solid fa-user"></i>${player.nick}</div>
				${veh}
				<div class="room-field player-state">${label}</div>
				<div class="room-field ${classAction}" ${action}>${labelAction}</div>
			</div>
			`);
		});

		$('.player-vehicle').each(function () {
			if ($(this).text().trim() == '-') {
				start = false;
			}
		});

		if (start && $('.room').attr('isOwner') == 'true') {
			$('#btn-start-race').css('opacity', 1);
			$('#btn-start-race')
				.off('click')
				.on('click', function () {
					sound_click.currentTime = 0;
					sound_click.play();
					$(this).off('click');
					$.post(`https://${GetParentResourceName()}/start-race`, JSON.stringify({}));
				});
		} else {
			$('#btn-start-race').css('opacity', 0.5);
			$('#btn-start-race').off('click');
		}

		$('.action-player')
			.off('click')
			.on('click', function () {
				let action = $(this).attr('action');
				let player = $(this).parent().attr('idplayer');

				if (action == 'kick') {
					$.post(`https://${GetParentResourceName()}/kickPlayer`, JSON.stringify({ player: player }));
				} else if (action == 'cancel-invi') {
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
		$('.room')
			.addClass('scale-out2')
			.fadeOut(500, function () {
				$(this).removeClass('scale-out2');
				if (!bool) {
					$.post(
						`https://${GetParentResourceName()}/leaveRoom`,
						JSON.stringify({}),
						function (cb) {
							if (cb) {
								races_data_front = cb.last_data;
							}
							sound_transition.currentTime = 0;
							sound_transition.play();
							$('.container-menu').fadeIn(300);
							$('.container-principal').fadeIn(300, function () {
								eventsMenu();
								eventsSounds();
								eventKeydown();
							});
						}
					);
				} else {
					sound_transition.currentTime = 0;
					sound_transition.play();
					$('.container-menu').fadeIn(300);
					$('.container-principal').fadeIn(300, function () {
						eventsMenu();
						eventsSounds();
						eventKeydown();
					});
				}
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
			$(document).off('keydown');
			$('.notifications').removeClass('expanded');
			$.post(`https://${GetParentResourceName()}/closeMenu`, JSON.stringify({}));
		}
	});
}

function countDownGo() {
	$('.bottom-layer').fadeIn(300);
	$('.countdown-number').text('3');
	$('.countdown').fadeIn(300);
	sound_transition2.currentTime = 0;
	sound_transition2.play();
	$('.room .title, .room-data, .room-button-zone').css('filter', 'blur(10px)');
	let time = 2;
	let countDownGo = setInterval(() => {
		$('.countdown-number').text(time);

		if (time == 0) {
			let sound_start = new Audio('sounds/startrace.mp3');
			sound_start.volume = 0.3;
			sound_start.loop = false;
			sound_start.currentTime = 0;
			sound_start.play();
			clearInterval(countDownGo);
			$('.container-principal, .container-lobby').hide();
			$('.bgblack').fadeIn(300, function () {
				$('.room')
					.addClass('scale-out2')
					.fadeOut(500, function () {
						$(this).removeClass('scale-out2');
						$('.loading1').fadeIn(300, function () {
							$('.bottom-layer, .countdown').hide();
							$('.room .title, .room-data, .room-button-zone').css(
								'filter',
								'blur(0px)'
							);
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
	$('.button, .menu-map, .left, .right, .category, .vehicle-button, .race-times, .btn-random')
		.off('mouseenter')
		.mouseenter(function () {
			sound_over.currentTime = 0;
			sound_over.play();
		});

	$('.button, .menu-map, .left, .right, .category, .vehicle-button, .btn-random').click(function (event) {
		if (event.currentTarget.id !== 'btn-choose-vehicle') {
			sound_click.currentTime = 0;
			sound_click.play();
		}
	});
}

function showNoty(text) {
	const noty = $(`<div class="noty animate__animated animate__backInRight">${text}</div>`);
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

function spectateList(players, playerid, bool) {
	$('.players-spectate').html('');
	if (!inSpectatorMode) {
		$('.spectate').fadeIn(300);
		inSpectatorMode = true;
	}
	players.forEach((v) => {
		$('.players-spectate').append(`
		<div class="player-sp d-flex" id="player_spec_${v.playerID}">
			<div class="sp-number">${v.position}</div>
			<div class="sp-nick">${v.playerName}</div>
			<div class="eye"><i class="fas fa-eye"></i></div>
		</div>
		`);
	});

	$('#player_spec_' + playerid).addClass('view');
	if (bool) {
		sound_over.currentTime = '0';
		sound_over.play();
	}
}

function setupPauseMenu() {
	$('.race-info #p-title').text(pausemenu_title);
	$('.race-info #p-weather').text(pausemenu_weather);
	$('.race-info #p-time').text(pausemenu_time);
	$('.race-info #p-traffic').text(pausemenu_traffic);
	$('.race-info #p-dnf').text(pausemenu_dnf);
	$('.race-info #p-accessible').text(pausemenu_accessible);
	$('.race-info #p-mode').text(pausemenu_mode);
	$('.race-info .race-img').attr('src', pausemenu_img);
}

function eventsRoom() {
	$('#btn-leave-race')
		.off('click')
		.on('click', function () {
			exitRoom(false);
			sound_click.currentTime = '0';
			sound_click.play();
		});
	$('#btn-choose-vehicle')
		.off('click')
		.on('click', function () {
			sound_click.currentTime = 0;
			sound_click.play();
			$('.room').addClass('animate__animated animate__fadeOutUp').fadeOut(500);
			loadSelectRaceVehicle();
			$('#btn-choose-vehicle').css('opacity', 0.5);
			$('#btn-choose-vehicle').off('click');
		});

	$('#btn-invite-players')
		.off('click')
		.on('click', function () {
			sound_click.currentTime = 0;
			sound_click.play();
			$('.invite-box').fadeIn(300);
			$('.bottom-layer').fadeIn(300);
			loadInvitePlayers();
			$('.invite-box .close-box')
				.off('click')
				.on('click', function () {
					$('.bottom-layer').fadeOut(300);
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

function updatePositionTable(table, visible, labels) {
	if (table) {
		$('.flex-position').html('');
		$('.flex-position').append(`
			<div class="position-label">
				<div class="position-hidden-number"></div>
				<div class="position-label-long">${labels.label_name}</div>
				<div class="position-label-short">${labels.label_distance}</div>
				<div class="position-label-short">${labels.label_lap}</div>
				<div class="position-label-short">${labels.label_checkpoint}</div>
				<div class="position-label-long">${labels.label_vehicle}</div>
				<div class="position-label-pink">${labels.label_bestlap}</div>
				<div class="position-label-pink">${labels.label_totaltime}</div>
			</div>
			`);
		table.map((p) => {
			$('.flex-position').append(`
			<div class="position-label">
				<div class="position-number">${p.position}</div>
				<div class="position-text-long">${p.name}</div>
				<div class="position-text-short">${p.distance}</div>
				<div class="position-text-short">${p.lap}</div>
				<div class="position-text-short">${p.checkpoint}</div>
				<div class="position-text-blue">${p.vehicle}</div>
				<div class="position-text-short">${p.bestlap}</div>
				<div class="position-text-short">${p.totaltime}</div>
			</div>
			`);
		});

		if (visible) {
			$('.position-table-container').addClass('show');
		}
	}
}

function translateHtmlText(texts) {
	document.querySelectorAll('[data-translate]').forEach(element => {
		const key = element.getAttribute('data-translate');
		if (texts[key]) {
			if (element.placeholder !== undefined) {
				element.placeholder = texts[key];
			} else {
				element.textContent = texts[key];
			}
		} else {
			console.log(`Error: ${key} not found in translations`)
		}
	});
	$('.weather .content').find('div').text(texts[$('.weather .content').attr('value')]);
	$('.accessible .content').find('div').text(texts[$('.accessible .content').attr('value')]);
	$('.racemode .content').find('div').text(texts[$('.racemode .content').attr('value')]);
	$('.racevehicle .content').find('div').text(texts[$('.racevehicle .content').attr('value')]);
}