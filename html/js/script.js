//Data
let trackData = {};
let trackPerPage = 12;

//Status
let firstLoad = true;
let inInvitationUI = false;
let inSpectatorMode = false;
let resetLeaveRoom = false;
let resetShowMenu = false;
let isFavoriteUpdating = false;
let isVehicleSelecting = false;
let thumbnailPreviewEnable = false;

//Html text
let noRankingResult;
let noRaceRoom;
let noInviteSesult;
let roomStatusHost;
let roomStatusGuest;
let roomStatusJoining;
let roomStatusIn;
let roomActionRemove;
let roomInviteInvite;
let roomInviteInvited;
let favoriteText;
let personalText;

//Pausemenu
let pausemenuImg;
let pausemenuTitle;
let pausemenuWeather;
let pausemenuTime;
let pausemenuTraffic;
let pausemenuDNF;
let pausemenuAccessible;
let pausemenuMode;

//Option
let lapOption = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16];
let weatherOption = [
	["Clear", "CLEAR"],
	["Extrasunny", "EXTRASUNNY"],
	["Clouds", "CLOUDS"],
	["Overcast", "OVERCAST"],
	["Rain", "RAIN"],
	["Clearing", "CLEARING"],
	["Thunder", "THUNDER"],
	["Smog", "SMOG"],
	["Foggy", "FOGGY"],
	["Christmas", "XMAS"],
	["Snow", "SNOW"],
	["Snowlight", "SNOWLIGHT"],
	["Blizzard", "BLIZZARD"],
	["Halloween", "HALLOWEEN"],
	["Neutral", "NEUTRAL"]
];
let timeOption = [
	"12:00",
	"13:00",
	"14:00",
	"15:00",
	"16:00",
	"17:00",
	"18:00",
	"19:00",
	"20:00",
	"21:00",
	"22:00",
	"23:00",
	"00:00",
	"01:00",
	"02:00",
	"03:00",
	"04:00",
	"05:00",
	"06:00",
	"07:00",
	"08:00",
	"09:00",
	"10:00",
	"11:00"
];
let trafficOption = [
	["OFF", "off"],
	["ON", "on"]
];
let dnfOption = [
	["OFF", "off"],
	["25%", "0.25"],
	["50%", "0.50"],
	["75%", "0.75"]
];
let accessibleOption = [
	["Public", "public"],
	["Private", "private"]
];
let modeOption = [
	["No Collisions", "no_collision"],
	["Normal", "normal"],
	["GTA", "gta"]
];
let vehicleOption = [
	["Default", "default"],
	["Specific", "specific"],
	["Personal", "personal"]
];

//Sound
let soundInvitation = new Audio("./sounds/invitation.mp3");
soundInvitation.loop = false;
soundInvitation.volume = 0.7;
let soundSecond = new Audio("./sounds/second.mp3");
soundSecond.volume = 0.1;
soundSecond.loop = false;
let soundOver = new Audio("./sounds/over.wav");
soundOver.volume = 0.2;
soundOver.loop = false;
let soundCick = new Audio("./sounds/click.mp3");
soundCick.volume = 0.2;
soundCick.loop = false;
let soundTransition = new Audio("./sounds/transition.mp3");
soundTransition.volume = 0.2;
soundTransition.loop = false;
let soundTransition_2 = new Audio("./sounds/transition2.mp3");
soundTransition_2.volume = 0.2;
soundTransition_2.loop = false;
let pop = new Audio("./sounds/pop.ogg");
pop.volume = 1;
pop.loop = false;

document.addEventListener("DOMContentLoaded", function () {
	const colorPicker = document.getElementById("colorPicker");
	const picker = document.getElementById("picker");
	const confirmButton = document.getElementById("confirmButton");
	const speedometerWindow = document.getElementById("speedometer");
	const speedSvg = document.getElementById("speedSvg");
	const speedTextKm = document.getElementById("speedTextKm");
	const speedTextMiles = document.getElementById("speedTextMiles");
	const fuelSvg = document.getElementById("fuelSvg");
	const fuelPath = document.getElementById("fuelPath");
	const fuelIcon = document.getElementById("fuelIcon");
	const seatBelt = document.getElementById("seatBelt");
	const engine = document.getElementById("engine");
	const highBeam = document.getElementById("beam");
	const inputBox = document.getElementById("inputBox");
	const thumbnail = document.getElementById("thumbnail");
	const thumbnailPreview = document.getElementById("thumbnailPreview");

	window.addEventListener("message", function (event) {
		if (event.data.action == "fade out") {
			$(".black-screen").fadeIn(event.data.time);
		}

		if (event.data.action == "fade in") {
			$(".black-screen").fadeOut(event.data.time);
		}

		if (event.data.action == "translate html") {
			translateHtmlText(event.data.texts);
			noRankingResult = event.data.texts["menu-no-ranking-result"];
			noRaceRoom = event.data.texts["lobby-no-race-room"];
			noInviteSesult = event.data.texts["room-no-invite-result"];
			roomStatusHost = event.data.texts["room-status-host"];
			roomStatusGuest = event.data.texts["room-status-guest"];
			roomStatusJoining = event.data.texts["room-status-joining"];
			roomStatusIn = event.data.texts["room-status-in"];
			roomActionRemove = event.data.texts["room-action-remove"];
			roomInviteInvite = event.data.texts["room-invite-invite"];
			roomInviteInvited = event.data.texts["room-invite-invited"];
			weatherOption.forEach(function (weatherData) {
				weatherData[0] = event.data.texts[weatherData[1]];
			});
			accessibleOption.forEach(function (accessibleData) {
				accessibleData[0] = event.data.texts[accessibleData[1]];
			});
			modeOption.forEach(function (modeData) {
				modeData[0] = event.data.texts[modeData[1]];
			});
			vehicleOption.forEach(function (vehicleData) {
				vehicleData[0] = event.data.texts[vehicleData[1]];
			});
		}

		if (event.data.action == "update cursor position") {
			$(".xbox-cursor").css("left", `${event.data.x * window.innerWidth}px`);
			$(".xbox-cursor").css("top", `${event.data.y * window.innerHeight}px`);
		}

		if (event.data.action == "trigger click") {
			let targetElement = document.elementFromPoint(event.data.x * window.innerWidth, event.data.y * window.innerHeight);
			let $target = $(targetElement);
			if ($target.length) {
				$target.trigger("click");
			}
		}

		if (event.data.action == "scroll") {
			let targetElement = document.elementFromPoint(event.data.x * window.innerWidth, event.data.y * window.innerHeight);
			let $target = $(targetElement);
			let scrollableTarget = null;
			while ($target.length && $target[0] !== document.body) {
				if (($target[0].scrollHeight > $target[0].clientHeight) && ($target[0].tagName.toLowerCase() === "div" && ($target.hasClass("lobby-rooms") || $target.hasClass("players-room") || $target.hasClass("vehicles-container") || $target.hasClass("invite-players-list")))) {
					scrollableTarget = $target;
					break;
				}
				$target = $target.parent();
			}
			if (scrollableTarget && scrollableTarget[0] !== document.body) {
				scrollableTarget.scrollTop(scrollableTarget.scrollTop() + event.data.scrollY * 20);
			}
		}

		if (event.data.action == "close nui") {
			const escKeyEvent = $.Event("keydown", {
				key: "Escape",
				keyCode: 27,
				which: 27,
				bubbles: true,
				cancelable: true
			});
			$(document).trigger(escKeyEvent);
		}

		if (event.data.action == "show cursor") {
			$(".xbox-cursor").css("display", "block");
		}

		if (event.data.action == "hide cursor") {
			$(".xbox-cursor").css("display", "none");
		}

		if (event.data.action == "open track list") {
			trackData = event.data.trackData;
			openRaceLobby(event.data.isInRace);
		}

		if (event.data.action == "open invitations") {
			openInvitations();
		}

		if (event.data.action == "receive invitation") {
			receiveInvitation(
				event.data.info.title,
				event.data.info.name,
				event.data.info.roomId,
				event.data.info.accept,
				event.data.info.cancel
			);
		}

		if (event.data.action == "join player room") {
			$(".container-menu").hide();
			$(".container-lobby").hide();
			updateInvitations();
			loadRoom(
				event.data.data,
				event.data.bool,
				false
			);
		}

		if (event.data.action == "join public room") {
			$(".container-menu").fadeOut(300);
			$(".container-lobby").fadeOut(300);
			updateInvitations();
			loadRoom(
				event.data.data,
				event.data.bool,
				true
			);
		}

		if (event.data.action == "count down") {
			countdown();
		}

		if (event.data.action == "update room list") {
			const result = event.data.result;
			$(".lobby-rooms").html("");
			if (result && result.length > 0) {
				result.map((v) => {
					let vehicle = " - ";
					vehicleOption.forEach(function (vehicleData) {
						if (v.vehicle == vehicleData[1]) {
							vehicle = vehicleData[0];
						}
					});
					$(".lobby-rooms").append(`
					<div class="lobby-race lobby-room" id="${v.roomId}">
						<div class="lobby-field room-name"><i class="fa-solid fa-caret-right"></i>${v.name}</div>
						<div class="lobby-field room-vehicle">${vehicle}</div>
						<div class="lobby-field room-creator">${v.creator}</div>
						<div class="lobby-field room-players">${v.players}</div>
					</div>
					`);
				});
			} else {
				$(".lobby-rooms").append(`
				<div class="lobby-race">
					<div class="lobby-field w-100" data-translate="lobby-no-race-room">${noRaceRoom}</div>
				</div>
				`);
			}
			eventLobby();
		}

		if (event.data.action == "update room players") {
			updatePlayersRoom(
				event.data.players,
				event.data.invitations,
				event.data.playerCount,
				event.data.vehicle
			);
		}

		if (event.data.action == "hide loading") {
			$(".container-ui").delay(1000).fadeOut(300, function () {
				$(".loading").fadeOut(300);
				restartMenu();
			});
		}

		if (event.data.action == "exit room") {
			trackData = event.data.trackData;
			exitRoom();
		}

		if (event.data.action == "remove invitation") {
			$("[roomId=" + event.data.roomId + "]").animate(
				{
					opacity: 0
				},
				300,
				function () {
					$(this).remove();
					updateInvitations();
				}
			);
		}

		if (event.data.action == "update pause menu") {
			pausemenuImg = event.data.img;
			pausemenuTitle = event.data.title;
			weatherOption.forEach(function (weatherData) {
				if (event.data.weather == weatherData[1]) {
					pausemenuWeather = weatherData[0];
				}
			});
			pausemenuTime = event.data.time;
			trafficOption.forEach(function (trafficData) {
				if (event.data.traffic == trafficData[1]) {
					pausemenuTraffic = trafficData[0];
				}
			});
			dnfOption.forEach(function (dnfData) {
				if (event.data.dnf == dnfData[1]) {
					pausemenuDNF = dnfData[0];
				}
			});
			accessibleOption.forEach(function (accessibleData) {
				if (event.data.accessible == accessibleData[1]) {
					pausemenuAccessible = accessibleData[0];
				}
			});
			modeOption.forEach(function (modeData) {
				if (event.data.mode == modeData[1]) {
					pausemenuMode = modeData[0];
				}
			});
			updatePauseMenu();
		}

		if (event.data.action == "show race hud") {
			if (event.data.showCurrentLap) {
				$(".current-lap").show();
			} else {
				$(".current-lap").hide();
			}
			$(".hud").removeClass("scale-out-hud").addClass("scale-in-hud").show();
		}

		if (event.data.action == "hide race hud") {
			$(".hud").removeClass("scale-in-hud").addClass("scale-out-hud");
			$(".nf-zone").fadeOut(300);
			setTimeout(() => {
				$(".hud").hide();
				$(".current-lap").hide();
			}, 2000);
		}

		if (event.data.action == "hide position ui") {
			$(".position-table-container").removeClass("show");
		}

		if (event.data.position) {
			$(".position span").html(event.data.position);
		}

		if (event.data.checkpoints) {
			$(".checkpoints div").text(event.data.checkpoints);
		}

		if (event.data.laps) {
			$(".racing-lap div").text(event.data.laps);
		}

		if (event.data.timeLap) {
			$(".current-lap div").text(event.data.timeLap);
		}

		if (event.data.timeTotal) {
			$(".counter div").text(event.data.timeTotal);
		}

		if (event.data.action == "show scoreboard") {
			if (event.data.title) {
				$(".finish-race .label-results").text(event.data.title);
				$(".finish-race").removeClass("animate__backOutDown").addClass("animate__backInUp");
				$(".finish-race").css("display", "flex");
				soundTransition_2.currentTime = 0;
				soundTransition_2.play();
				$(".hud").removeClass("scale-in-hud").addClass("scale-out-hud");
				$(".nf-zone").fadeOut(300);
				setTimeout(() => {
					$(".hud").hide();
				}, 2000);
			}
			$(".finish-race table tbody").html("");
			event.data.frontPosResult.map((p) => {
				$(".finish-race table tbody").append(`
				<tr>
					<td class="td-position"><span class="n-position">${p.position}</span><img class="position-flag" src="./flags/${p.flag}.svg" /> ${p.keyboard} ${p.name}</td>
					<td class="text-center">${p.vehicle}</td>
					<td class="text-center">${p.totalTime}</td>
					<td class="text-center">${p.bestLap}</td>
				</tr>
				`);
			});
		}

		if (event.data.action == "hide scoreboard") {
			$(".finish-race").removeClass("animate__backInUp").addClass("animate__backOutDown");
			soundTransition_2.currentTime = 0;
			soundTransition_2.play();
			setTimeout(() => {
				$(".finish-race").hide();
			}, 1000);
		}

		if (event.data.action == "show notification") {
			const message = event.data.message;
			showNotification(message);
		}

		if (event.data.action == "show respawn ui") {
			$(".respawn").fadeIn(300);
		}

		if (event.data.action == "hide respawn ui") {
			$(".respawn").fadeOut(300);
		}

		if (event.data.action == "start dnf countdown") {
			countdownDNF(event.data.endTime);
		}

		if (event.data.action == "show race info") {
			soundTransition_2.currentTime = 0;
			soundTransition_2.play();
			$(".race-name .title-race").text(event.data.raceName);
			$(".race-name").fadeIn(1000, function () {
				$(this).removeClass("animate__backInDown");
			});
			setTimeout(() => {
				$(".race-name")
					.addClass("animate__backOutUp")
					.fadeOut(700, function () {
						$(this).removeClass("animate__backOutUp").addClass("animate__backInDown");
						//Backup for poor network :(
						$(".container-ui").fadeOut(300);
						$(".room").fadeOut(300);
					});
			}, 4000);
		}

		if (event.data.action == "show spectate") {
			spectateList(event.data.players, event.data.playerId, event.data.sound);
		}

		if (event.data.action == "hide spectate") {
			$(".spectate").fadeOut(300);
			inSpectatorMode = false;
		}

		if (event.data.frontPos) {
			updatePositionTable(event.data.frontPos, event.data.labels);
		}

		if (event.data.action == "show color picker") {
			colorPicker.style.display = "block";
			picker.jscolor.fromString(event.data.color);
			picker.jscolor.show();
		}

		if (event.data.action == "close color picker") {
			colorPicker.style.display = "none";
			picker.jscolor.hide();
		}

		if (event.data.action == "show speedometer") {
			speedometerWindow.style.opacity = 1;

			let percentSpeed = (event.data.speed * 100) / (event.data.maxSpeed + 50);
			let percentFuel = (event.data.fuel * 100) / (event.data.maxFuel + 0.001);
			setDashedGaugeValue(speedSvg, percentSpeed, 219.911485751);
			setDashedGaugeValue(fuelSvg, percentFuel, 87.9645943005);
			speedTextKm.innerText = Math.round(event.data.speed);
			speedTextMiles.innerText = Math.round(event.data.speed);

			if (event.data.electric == true) {
				fuelIcon.src = "./img/battery.png";
			} else {
				fuelIcon.src = "./img/gas.png";
			}

			if (event.data.useMiles == true) {
				speedTextKm.style.display = "none";
				speedTextMiles.style.display = "block";
			} else {
				speedTextKm.style.display = "block";
				speedTextMiles.style.display = "none";
			}

			if (event.data.hasMotor == true) {
				highBeam.style.display = "block";
				engine.style.display = "block";
				seatBelt.style.display = "block";
				fuelSvg.style.display = "block";
				fuelPath.style.display = "block";
				fuelIcon.style.display = "block";
				speedometerWindow.style.marginLeft = "0px";
				speedometerWindow.style.marginBottom = "0px";
			} else {
				highBeam.style.display = "none";
				engine.style.display = "none";
				seatBelt.style.display = "none";
				fuelSvg.style.display = "none";
				fuelPath.style.display = "none";
				fuelIcon.style.display = "none";
				speedometerWindow.style.marginLeft = "10px";
				speedometerWindow.style.marginBottom = "-10px";
			}

			if (event.data.highBeam == 1) {
				if (highBeam.classList.contains("disabled")) {
					highBeam.classList.remove("disabled");
				}
			} else {
				if (!highBeam.classList.contains("disabled")) {
					highBeam.classList.add("disabled");
				}
			}

			if (event.data.engine == 1) {
				if (engine.classList.contains("disabled")) {
					engine.classList.remove("disabled");
				}
			} else {
				if (!engine.classList.contains("disabled")) {
					engine.classList.add("disabled");
				}
			}

			if (event.data.seatBelt == true) {
				if (seatBelt.classList.contains("disabled")) {
					seatBelt.classList.remove("disabled");
				}
			} else {
				if (!seatBelt.classList.contains("disabled")) {
					seatBelt.classList.add("disabled");
				}
			}
		}

		if (event.data.action == "hide speedometer") {
			speedometerWindow.style.opacity = 0;
		}

		if (event.data.action == "redbox on") {
			$(".redbox").css("display", "flex");
			$(".redbox").html("");
			$(".redbox").append(`
				<span class="redbox-text">${event.data.safezone}</span>
			`);
		}

		if (event.data.action == "redbox off") {
			$(".redbox").css("display", "none");
		}

		if (event.data.action == "minimap on") {
			$(".minimap-ui").css("display", "flex");
		}

		if (event.data.action == "minimap off") {
			$(".minimap-ui").css("display", "none");
		}

		if (event.data.action == "help on") {
			$(".help-ui").css("display", "flex");
		}

		if (event.data.action == "help off") {
			$(".help-ui").css("display", "none");
		}

		if (event.data.action == "info on") {
			$(".info-ui").css("display", "flex");
		}

		if (event.data.action == "info off") {
			$(".info-ui").css("display", "none");
		}

		if (event.data.action == "minimap data") {
			$(".minimap-ui").html("");
			$(".minimap-ui").append(`
			<div class="minimap-container">
				<div class="minimap-top">
					<span class="minimap-top-text">${event.data.time}</span>
					<span class="minimap-top-text">${event.data.ping}</span>
				</div>
				<div class="minimap-bottom">${event.data.bottom}</div>
			</div>
			`);
		}

		if (event.data.action == "help data") {
			$(".help-ui").html("");
			event.data.tips.map((p) => {
				$(".help-ui").append(`
				<div class="help-combine">
					<div class="help-button"><span>${p.button}</span></div>
					<div class="help-tip">${p.tip}</div>
				</div>
				`);
			});
		}

		if (event.data.action == "info data") {
			$(".info-ui").html("");
			$(".info-ui").append(`
			<img src=${event.data.logo} alt="logo" class="info-logo">
			<div class="info-text">
				<div class="info-combine">
					<div id="welcome">${event.data.welcome},</div>
					<div class="info-text-color">${event.data.name}</div>
					<div>!</div>
				</div>
				<div class="info-combine">
					<div>Discord :</div>
					<div class="info-text-color">${event.data.discord}</div>
				</div>
				<div class="info-combine">
					<div>Web :</div>
					<div class="info-text-color">${event.data.web}</div>
				</div>
				<div>${event.data.players}</div>
				<div>${event.data.fps}</div>
			</div>
			`);
		}

		if (event.data.action == "input open") {
			$(".input-ui").css("display", "flex");
			inputBox.value = event.data.value;
			inputBox.focus();
		}

		if (event.data.action == "input off") {
			$(".input-ui").css("display", "none");
		}

		if (event.data.action == "accept controller") {
			$(".input-ui").css("display", "none");
			$.post(`https://${GetParentResourceName()}/submitValue`, JSON.stringify({value: inputBox.value}));
		}

		if (event.data.action == "thumbnail url") {
			thumbnail.src = event.data.url;
			thumbnail.onload = function () {
				$.post(`https://${GetParentResourceName()}/urlValid`, JSON.stringify({}));
			};
			thumbnail.onerror = function () {
				$.post(`https://${GetParentResourceName()}/urlError`, JSON.stringify({}));
			};
		}

		if (event.data.action == "thumbnail on") {
			$(".thumbnail-ui").css("display", "flex");
		}

		if (event.data.action == "thumbnail off") {
			$(".thumbnail-ui").css("display", "none");
		}

		if (event.data.action == "thumbnail preview") {
			thumbnailPreviewEnable = true;
			thumbnailPreview.src = event.data.url;
			thumbnailPreview.onload = function () {
				if (thumbnailPreviewEnable) {
					$(".thumbnail-preview-ui").css("display", "flex");
				} else {
					$(".thumbnail-preview-ui").css("display", "none");
				}
			};
			thumbnailPreview.onerror = function () {
				$(".thumbnail-preview-ui").css("display", "none");
			};
		}

		if (event.data.action == "thumbnail preview off") {
			thumbnailPreviewEnable = false;
			$(".thumbnail-preview-ui").css("display", "none");
		}

		if (event.data.action == "adjust hud") {
			$(".invitations").css("bottom", event.data.bottom);
			$(".hud").css("bottom", event.data.bottom);
		}
	});

	picker.addEventListener("change", function () {
		const color = picker.jscolor.toRGBString();
		$.post(`https://${GetParentResourceName()}/colorSelected`, JSON.stringify({color: color}));
	});

	inputBox.addEventListener("keydown", function (event) {
		if (event.key === "Enter" && $(".input-ui").css("display") === "flex") {
			$(".input-ui").css("display", "none");
			$.post(`https://${GetParentResourceName()}/submitValue`, JSON.stringify({value: inputBox.value}));
		}
	});

	confirmButton.addEventListener("click", function () {
		colorPicker.style.display = "none";
		picker.jscolor.hide();
		$.post(`https://${GetParentResourceName()}/colorClosed`);
	});

	setDashedGaugeValue(speedSvg, 0, 219.911485751);
	setDashedGaugeValue(fuelSvg, 0, 87.9645943005);

	$.post(`https://${GetParentResourceName()}/nuiLoaded`, JSON.stringify({}));
});

function openRaceLobby(isInRace) {
	soundTransition.currentTime = 0;
	soundTransition.play();

	if (isInRace) {
		$(".in-race-menu").fadeIn(300, function () {
			eventKeydown();
			$("#btn-quit-race")
				.off("click")
				.on("click", function () {
					$(document).off("keydown");
					$("#btn-quit-race").off("click");
					$("#btn-join-spectator").off("click");
					$(".in-race-menu").fadeOut(300);
					$.post(`https://${GetParentResourceName()}/closeNUI`, JSON.stringify({}));
					$.post(`https://${GetParentResourceName()}/leaveRace`, JSON.stringify({}));
				});
			$("#btn-join-spectator")
				.off("click")
				.on("click", function () {
					$(document).off("keydown");
					$("#btn-quit-race").off("click");
					$("#btn-join-spectator").off("click");
					$(".in-race-menu").fadeOut(300);
					$.post(`https://${GetParentResourceName()}/closeNUI`, JSON.stringify({}));
					$.post(`https://${GetParentResourceName()}/joinSpectator`, JSON.stringify({}));
				});
			eventSound();
		});
	} else {
		eventMenu();
		$(".container-ui").fadeIn(300, function () {
			eventKeydown();
			if (!firstLoad) {
				eventInteraction();
				eventMapInteraction();
				eventSearchRace();
				eventCreateRoom();
				eventSound();
			}
		});
	}
}

function openInvitations() {
	inInvitationUI = true;
	eventKeydownInvitation();
	$(".invitations").addClass("expanded").fadeIn(300);
	if ($(".invitations-count").text() != 0) {
		$(".room-invitations").show();
		$(".no-invitations").hide();
	} else {
		$(".room-invitations").hide();
		$(".no-invitations").show();
	}
}

function updateInvitations() {
	$(".invitations-count").text($(".invitation").length);
	if ($(".invitations-count").text() != 0) {
		$(".hud").css("right", "6vh");
		$(".room-invitations").show();
		$(".no-invitations").hide();
		$(".invitations").fadeIn(300);
	} else {
		$(".hud").css("right", "0.8vh");
		$(".room-invitations").hide();
		if (inInvitationUI) {
			$(".no-invitations").show();
		} else {
			setTimeout(() => {
				if (($(".invitations-count").text() == 0) && (!inInvitationUI)) {
					$(".invitations").fadeOut(300);
				};
			}, 500)
		}
	}
}

function receiveInvitation(title, name, roomId, accept, cancel) {
	const uniqueId = `invitation-${roomId}-${Date.now()}`;
	$(".room-invitations").append(`
	<div class="invitation" id="${uniqueId}" roomId="${roomId}">
		<div class="title-invitation"><i class="fas fa-flag-checkered"></i>${title}</div>
		<div class="details-invitation">${name}</div>
		<div class="buttons-invi border-top">
			<div class="accept border-end"><i class="fas fa-check"></i>${accept}</div>
			<div class="cancel"><i class="fas fa-times"></i>${cancel}</div>
		</div>
	</div>
	`);
	$(`#${uniqueId} .cancel`)
		.off("click")
		.on("click", function () {
			$(this).off("click");
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
						updateInvitations();
						$.post(`https://${GetParentResourceName()}/denyInvitation`, JSON.stringify({src: roomId}));
					}
				);
		});
	$(`#${uniqueId} .accept`)
		.off("click")
		.on("click", function () {
			$(document).off("keydown");
			$(this).off("click");
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
						inInvitationUI = false;
						updateInvitations();
						$.post(`https://${GetParentResourceName()}/acceptInvitation`, JSON.stringify({src: roomId}));
						$(".invitations").removeClass("expanded");
						$(".players-room").html("");
						$(".player-count span").text("0/0");
					}
				);
		});
	soundInvitation.currentTime = 0;
	soundInvitation.play();
	updateInvitations();
}

function eventMenu() {
	const sortedKeys = Object.keys(trackData).sort((a, b) => {
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
		const categoryClass = category.replace(/\s/g, "_").replace(/\./g, "_");
		if (!$(".race-filter ." + categoryClass).length) {
			if (i == 0) {
				setTimeout(() => {
					firstLoad = false;
				}, 1000);
				$(".race-filter").append(`
				<div class="tag ${categoryClass} filter-selected">${category}</div>
				`);
				$("#btn-create-race")
					.removeClass("animate__animated animate__fadeInUp")
					.addClass("animate__animated animate__fadeOutDown")
					.fadeOut(300);
				loadRacesList(trackData[category]);
			} else {
				$(".race-filter").append(`
				<div class="tag ${categoryClass}">${category}</div>
				`);
			}
		}
	});
}

function eventInteraction() {
	$(".selector .right")
		.off("click")
		.on("click", function () {
			let val;
			let pos = parseInt($(this).parent().find(".content").attr("pos"));
			let nButton = "";

			if ($(this).parent().hasClass("weather")) {
				val = weatherOption;
			}

			if ($(this).parent().hasClass("laps")) {
				val = lapOption;
				nButton = "laps";
			}

			if ($(this).parent().hasClass("time")) {
				val = timeOption;
				nButton = "time";
			}

			if ($(this).parent().hasClass("traffic")) {
				val = trafficOption;
			}

			if ($(this).parent().hasClass("dnf")) {
				val = dnfOption;
			}

			if ($(this).parent().hasClass("accessible")) {
				val = accessibleOption;
			}

			if ($(this).parent().hasClass("racemode")) {
				val = modeOption;
			}

			if ($(this).parent().hasClass("racevehicle")) {
				val = vehicleOption;
			}

			let max = val.length - 1;

			if (pos < max) {
				pos++;
				$(this).parent().find(".content").attr("pos", pos);
			} else {
				pos = 0;
				$(this).parent().find(".content").attr("pos", 0);
			}

			$(this)
				.parent()
				.find(".content")
				.find("div")
				.animate(
					{
						borderSpacing: 90
					},
					{
						step: function (now, fx) {
							$(this).css(
								"transform",
								"translateX(" + now + "px)"
							);
						},
						duration: 150
					},
					"ease-in-out"
				)
				.promise()
				.done(() => {
					let zone, zone2;
					if (nButton == "time" || nButton == "laps") {
						zone = val[pos];
						zone2 = val[pos];
					} else {
						zone = val[pos][0];
						zone2 = val[pos][1];
					}
					$(this).parent().find(".content").attr("value", zone2);
					$(this)
						.parent()
						.find(".content")
						.find("div")
						.css("transform", "translateX(-90px)")
						.text(zone)
						.animate(
							{
								borderSpacing: 0
							},
							{
								step: function (now, fx) {
									$(this).css(
										"transform",
										"translateX(-" + now + "px)"
									);
								},
								duration: 150
							},
							"ease-in-out"
						);
				});
		});

	$(".selector .left")
		.off("click")
		.on("click", function () {
			let val;
			let pos = parseInt($(this).parent().find(".content").attr("pos"));
			let nButton = "";

			if ($(this).parent().hasClass("weather")) {
				val = weatherOption;
			}

			if ($(this).parent().hasClass("laps")) {
				val = lapOption;
				nButton = "laps";
			}

			if ($(this).parent().hasClass("time")) {
				val = timeOption;
				nButton = "time";
			}

			if ($(this).parent().hasClass("traffic")) {
				val = trafficOption;
			}

			if ($(this).parent().hasClass("dnf")) {
				val = dnfOption;
			}

			if ($(this).parent().hasClass("accessible")) {
				val = accessibleOption;
			}

			if ($(this).parent().hasClass("racemode")) {
				val = modeOption;
			}

			if ($(this).parent().hasClass("racevehicle")) {
				val = vehicleOption;
			}

			let max = val.length - 1;

			if (pos - 1 >= 0) {
				pos--;
				$(this).parent().find(".content").attr("pos", pos);
			} else {
				pos = max;
				$(this).parent().find(".content").attr("pos", max);
			}

			$(this)
				.parent()
				.find(".content")
				.find("div")
				.animate(
					{
						borderSpacing: 90
					},
					{
						step: function (now, fx) {
							$(this).css(
								"transform",
								"translateX(-" + now + "px)"
							);
						},
						duration: 150
					},
					"ease-in-out"
				)
				.promise()
				.done(() => {
					let zone, zone2;
					if (nButton == "time" || nButton == "laps") {
						zone = val[pos];
						zone2 = val[pos];
					} else {
						zone = val[pos][0];
						zone2 = val[pos][1];
					}
					$(this).parent().find(".content").attr("value", zone2);
					$(this)
						.parent()
						.find(".content")
						.find("div")
						.css("transform", "translateX(-90px)")
						.text(zone)
						.animate(
							{
								borderSpacing: 0
							},
							{
								step: function (now, fx) {
									$(this).css(
										"transform",
										"translateX(" + now + "px)"
									);
								},
								duration: 150
							},
							"ease-in-out"
						);
				});
		});

	$(".tag")
		.off("click")
		.on("click", function () {
			$(".tag").removeClass("filter-selected");
			$(this).addClass("filter-selected");
			$("#btn-create-race")
				.removeClass("animate__animated animate__fadeInUp")
				.addClass("animate__animated animate__fadeOutDown")
				.fadeOut(300);
			loadRacesList(trackData[$(this).text().trim()]);
		});

	$(".btn-bookmarked ")
		.off("click")
		.on("click", function () {
			$.post(`https://${GetParentResourceName()}/getBookmarkedRace`, JSON.stringify({}), function (cb) {
				if (cb) {
					$(".tag").removeClass("filter-selected");
					$("#btn-create-race")
						.removeClass("animate__animated animate__fadeInUp")
						.addClass("animate__animated animate__fadeOutDown")
						.fadeOut(300);
					loadRacesList(cb)
				}
			}, "json");
		});

	$(".btn-random")
		.off("click")
		.on("click", function () {
			$.post(`https://${GetParentResourceName()}/getRandomRace`, JSON.stringify({}), function (cb) {
				if (cb) {
					$(".tag").removeClass("filter-selected");
					$("#btn-create-race")
						.removeClass("animate__animated animate__fadeInUp")
						.addClass("animate__animated animate__fadeOutDown")
						.fadeOut(300);
					loadRacesList(cb)
				}
			}, "json");
		});

	$(".btn-lobby")
		.off("click")
		.on("click", function () {
			soundCick.currentTime = 0;
			soundCick.play();
			$(".container-menu")
				.animate(
					{
						left: "-102%"
					},
					{
						duration: 500
					},
					"ease-in-out"
				)
				.promise()
				.done(() => {
					$(".container-menu").hide();
				});
			$(".container-lobby").show()
				.animate(
					{
						left: "0%"
					},
					{
						duration: 500
					},
					"ease-in-out"
				);
			$("#btn-join-room").hide();
			$(".lobby-room").removeClass("select");
			loadListLobby();
		});
}

function eventMapInteraction() {
	$(".menu-map")
		.off("click")
		.on("click", function () {
			$(".menu-map").removeClass("race-selected");
			$(this).addClass("race-selected");
			$("#btn-create-race")
				.removeClass("animate__animated animate__fadeOutDown")
				.addClass("animate__animated animate__fadeInUp")
				.fadeIn(300);
		});

	$(".race-bookmarked")
		.off("click")
		.on("click", function () {
			let raceId = $(this).parent().parent().attr("raceId");
			let bookmarked = $(this).attr("bookmarked") !== "yes";
			$(this).attr("bookmarked", bookmarked ? "yes" : "no");
			$(this).find("img").attr("src", `./img/${bookmarked ? "bookmarked.svg" : "unbookmarked.svg"}`);
			$.post(`https://${GetParentResourceName()}/updateBookmarked`, JSON.stringify({raceId: raceId, bookmarked: bookmarked}), function (data) {
				trackData = data;
			}, "json");
		});

	$(".race-times")
		.off("click")
		.on("click", function () {
			let raceId = $(this).parent().parent().attr("raceId");
			$.post(`https://${GetParentResourceName()}/getBestTimes`, JSON.stringify({raceId: raceId}), function (cb) {
				soundTransition_2.currentTime = 0;
				soundTransition_2.play();
				$(".times-container").addClass("show");
				$(".times-container .table-times").html("");
				if (cb && cb.length > 0) {
					if (cb.length > 10) {
						cb = cb.slice(0, 10);
					}
					let ms = 800;
					cb.map((time, index) => {
						let date = time.date.split("/");
						let dateFinal = date[2] + "/" + date[0] + "/" + date[1];
						$(".times-container .table-times").append(`
						<div class="user-time animate__animated animate__zoomIn" style="animation-delay:${ms}ms; animation-duration:300ms; animation-timing-function:var(--cubic) !important;">
							<div class="time-position">${index + 1}</div>
							<div class="time-name"><i class="fas fa-user"></i><span class="time-text-overflow">${time.name}</span></div>
							<div class="time-vehicle"><i class="fas fa-car"></i><span class="time-text-overflow">${time.vehicle}</span></div>
							<div class="time-date"><i class="fas fa-calendar-alt"></i>${dateFinal}</div>
							<div class="time-timer"><i class="fas fa-stopwatch-20"></i>${time.time}</div>
						</div>
						`);
						ms += 200;
					});
				} else {
					$(".times-container .table-times").append(`
					<div class="user-time">
						<div class="time-name" style="width:100%" data-translate="menu-no-ranking-result">${noRankingResult}</div>
					</div>
					`);
				}
				$(".times-container .close-button")
					.off("click")
					.on("click", function () {
						$(this).off("click");
						$(".times-container").removeClass("show");
					});
			}, "json");
		});
}

function eventSearchRace() {
	$(".search-race")
		.off("keyup")
		.on("keyup", function (e) {
			if (e.which === 13) {
				$(document).off("keydown");
				$(".search-race").off("keyup");
				$("#btn-create-race").off("click");
				let value = $(this).val();
				$(".searching-background").fadeIn(300, function () {
					$(".loading").fadeIn(300);
					$(document).keydown(function (event) {
						var keycode = event.keyCode ? event.keyCode : event.which;
						if (keycode == "27") {
							$(document).off("keydown");
							$.post(`https://${GetParentResourceName()}/cancelSearch`, JSON.stringify({}));
						}
					});
					$.post(`https://${GetParentResourceName()}/searchRace`, JSON.stringify({text: value}), function (cb) {
						$(document).off("keydown");
						if (cb && cb.createRoom) {
							let img = cb.img;
							let name = cb.name;
							let laps = $(".laps .content").attr("value");
							let weather = $(".weather .content").attr("value");
							let time = $(".time .content").attr("value").split(":");
							let traffic = $(".traffic .content").attr("value");
							let dnf = $(".dnf .content").attr("value");
							let accessible = $(".accessible .content").attr("value");
							let mode = $(".racemode .content").attr("value");
							let vehicle = $(".racevehicle .content").attr("value");
							let maxPlayers = cb.maxPlayers;
							let roomData = {
								img: img,
								name: name,
								laps: laps,
								weather: weather,
								time: time[0],
								traffic: traffic,
								dnf: dnf,
								accessible: accessible,
								mode: mode,
								vehicle: vehicle,
								maxPlayers: maxPlayers
							};
							$(".searching-background").fadeOut(300);
							$(".menu-map").removeClass("race-selected");
							$("#btn-create-race")
								.removeClass("animate__animated animate__fadeInUp")
								.addClass("animate__animated animate__fadeOutDown")
								.fadeOut(300);
							$.post(`https://${GetParentResourceName()}/createRace`, JSON.stringify(roomData));
							createRoom(roomData);
						} else {
							if (cb) {
								$(".tag").removeClass("filter-selected");
								$("#btn-create-race")
									.removeClass("animate__animated animate__fadeInUp")
									.addClass("animate__animated animate__fadeOutDown")
									.fadeOut(300);
								loadRacesList(cb);
							}
							$(".searching-background").fadeOut(300, function () {
								$(".loading").fadeOut(300);
								eventKeydown();
								eventInteraction();
								eventMapInteraction();
								eventSearchRace();
								eventCreateRoom();
								eventSound();
							});
						}
					}, "json");
				});
			}
		});
}

function eventCreateRoom() {
	$("#btn-create-race")
		.off("click")
		.on("click", function () {
			$(document).off("keydown");
			$(".search-race").off("keyup");
			$("#btn-create-race").off("click");
			let raceId = $(".menu-map.race-selected").attr("raceId");
			let img = $(".menu-map.race-selected").css("background-image");
			let name = $(".menu-map.race-selected .name-map").text().replace("–", "-");
			let laps = $(".laps .content").attr("value");
			let weather = $(".weather .content").attr("value");
			let time = $(".time .content").attr("value").split(":");
			let traffic = $(".traffic .content").attr("value");
			let dnf = $(".dnf .content").attr("value");
			let accessible = $(".accessible .content").attr("value");
			let mode = $(".racemode .content").attr("value");
			let vehicle = $(".racevehicle .content").attr("value");
			let maxPlayers = $(".menu-map.race-selected").attr("maxPlayers");
			img = /^url\((['"]?)(.*)\1\)$/.exec(img);
			img = img ? img[2] : "";
			let roomData = {
				raceId: raceId,
				img: img,
				name: name || "error",
				laps: laps,
				weather: weather,
				time: time[0],
				traffic: traffic,
				dnf: dnf,
				accessible: accessible,
				mode: mode,
				vehicle: vehicle,
				maxPlayers: parseInt(maxPlayers || 0)
			};
			$.post(`https://${GetParentResourceName()}/createRace`, JSON.stringify(roomData));
			createRoom(roomData);
		});
}

function loadListLobby() {
	$.post(`https://${GetParentResourceName()}/getRoomList`, JSON.stringify({}), function (result) {
		$(".lobby-rooms").html("");
		if (result && result.length > 0) {
			result.map((v) => {
				let vehicle = " - ";
				vehicleOption.forEach(function (vehicleData) {
					if (v.vehicle == vehicleData[1]) {
						vehicle = vehicleData[0];
					}
				});
				$(".lobby-rooms").append(`
				<div class="lobby-race lobby-room" id="${v.roomId}">
					<div class="lobby-field room-name"><i class="fa-solid fa-caret-right"></i>${v.name}</div>
					<div class="lobby-field room-vehicle">${vehicle}</div>
					<div class="lobby-field room-creator">${v.creator}</div>
					<div class="lobby-field room-players">${v.players}</div>
				</div>
				`);
			});
		} else {
			$(".lobby-rooms").append(`
			<div class="lobby-race">
				<div class="lobby-field w-100" data-translate="lobby-no-race-room">${noRaceRoom}</div>
			</div>
			`);
		}
		eventLobby();
	}, "json");
}

function eventLobby() {
	$(".btn-lobby-create")
		.off("click")
		.on("click", function () {
			soundCick.currentTime = 0;
			soundCick.play();
			$(".container-lobby")
				.animate(
					{
						left: "102%"
					},
					{
						duration: 500
					},
					"ease-in-out"
				)
				.promise()
				.done(() => {
					$(".container-lobby").hide();
				});
			$(".container-menu").show()
				.animate(
					{
						left: "0%"
					},
					{
						duration: 500
					},
					"ease-in-out"
				);
		});

	$(".lobby-room")
		.off("click")
		.on("click", function () {
			$(".lobby-room").removeClass("select");
			$(this).addClass("select");
			$("#btn-join-room")
				.removeClass("animate__animated animate__fadeOutDown")
				.addClass("animate__animated animate__fadeInUp")
				.fadeIn(300);
			$("#btn-join-room")
				.off("click")
				.on("click", function () {
					$(document).off("keydown");
					$(this).off("click");
					const roomId = $(".lobby-room.select").attr("id");
					$.post(`https://${GetParentResourceName()}/joinPublicRoom`, JSON.stringify({src: roomId}));
					$(".container-ui").fadeOut(300);
					soundCick.currentTime = 0;
					soundCick.play();
					$("#btn-join-room")
						.removeClass("animate__animated animate__fadeInUp")
						.addClass("animate__animated animate__fadeOutDown")
						.fadeOut(300);
					$(".players-room").html("");
					$(".player-count span").text("0/0");
				});
		});

	$("#btn-update-rooms")
		.off("click")
		.on("click", function () {
			soundCick.currentTime = 0;
			soundCick.play();
			$("#btn-join-room")
				.removeClass("animate__animated animate__fadeInUp")
				.addClass("animate__animated animate__fadeOutDown")
				.fadeOut(300);
			loadListLobby();
		});
}

function invitePlayers() {
	$(".invite-players-list").html("");
	$.post(`https://${GetParentResourceName()}/getPlayerList`, JSON.stringify({}), function (cb) {
		if (cb != "") {
			let players = Object.values(cb);
			players.forEach(function (player) {
				$(".invite-players-list").append(`
				<div class="player">
					<div class="n-player"><i class="fa-solid fa-user"></i>${player.name}</div>
					<div class="btn-invite" playerId="${player.id}" nPlayer="${player.name}">${roomInviteInvite}</div>
				</div>
				`);
			});
			$(".btn-invite")
				.off("click")
				.on("click", function () {
					$.post(`https://${GetParentResourceName()}/invitePlayer`, JSON.stringify({player: $(this).attr("playerId")}));
					$(this).text(roomInviteInvited).off("click");
				});
			$(".search-players")
				.off("keyup")
				.on("keyup", function (e) {
					if (e.which === 13) {
						let value = $(this).val().toLowerCase();
						$(".player").filter(function () {
							$(this).toggle(
								$(this).text().toLowerCase().indexOf(value) > -1
							);
						});
					}
				});
		} else {
			$(".invite-players-list").append(`
			<div class="player">
				<div class="no-result" data-translate="room-no-invite-result">${noInviteSesult}</div>
			</div>
			`);
		}
	}, "json");
}

function restartMenu() {
	$(".container-menu").show();
	$(".container-lobby").show();
	$(".container-main").show();
	$(".menu-map").removeClass("race-selected");
	$("#btn-create-race").hide();
}

function loadRacesList(list) {
	$("#races-predefined").html("");
	let map = Object.values(list);
	createPage(Math.ceil(map.length / trackPerPage));
	changePage(1, map);
}

function createPage(pages) {
	$(".races-page").html("");
	for (let i = 0; i < pages; i++) {
		if (i == 0) {
			$(".races-page").append(`
			<div class="page-number sel">${i + 1}</div>
			`);
		} else {
			$(".races-page").append(`
			<div class="page-number">${i + 1}</div>
			`);
		}
	}
	$(".page-number").off("click");
	$(".menu-map").off("click");
}

function changePage(page, map) {
	$("#races-predefined").fadeOut(300, function () {
		$(this).html("");
		for (var i = (page - 1) * trackPerPage; i < page * trackPerPage; i++) {
			if (map[i] != null || map[i] != undefined) {
				$("#races-predefined").append(`
				<div class="races-list">
					<div class="menu-map" style="background-image:url('${map[i].img}')" raceId="${map[i].raceId}" maxPlayers="${map[i].maxPlayers}">
						<div class="info-map">
							<div class="name-map">${map[i].name}</div>
						</div>
						<div class="race-top-right">
							${map[i].played ? `<div class="race-played"><img src="./img/played.svg"></div>` : ""}
							${map[i].finished ? `<div class="race-finished"><img src="./img/finished.svg"></div>` : ""}
							<div class="race-bookmarked" bookmarked="${map[i].bookmarked ? "yes" : "no"}"><img src="./img/${map[i].bookmarked ? "bookmarked.svg" : "unbookmarked.svg"}"></div>
							<div class="race-times"><img src="./img/time.png"></div>
						</div>
					</div>
				</div>
				`);
			}
		}
		$(this).fadeIn(300, function () {
			eventInteraction();
			eventMapInteraction();
			eventSearchRace();
			eventCreateRoom();
			eventSound();
			eventPage(map);
		});
	});
}

function eventPage(map) {
	$(".page-number")
		.off("click")
		.on("click", function () {
			$(".page-number").off("click");
			$(".menu-map").off("click");
			$("#btn-create-race")
				.removeClass("animate__animated animate__fadeInUp")
				.addClass("animate__animated animate__fadeOutDown")
				.fadeOut(300);
			$(".page-number").removeClass("sel");
			$(this).addClass("sel");
			let page = $(this).text();
			changePage(page, map);
		});
}

function createRoom(data) {
	$(".players-room").html("");
	$(".player-count span").text("0/0");
	$(".room").removeClass("animate__animate animate__fadeInDown");
	$(".room").attr("isOwner", "true");
	$("#btn-invite-players").show();
	$("#btn-start-race").show();
	if (data.vehicle == "default") {
		$("#btn-choose-vehicle").hide();
	} else {
		$("#btn-choose-vehicle").show();
		$("#btn-choose-vehicle").css("opacity", 1);
	}

	let weather = "";
	weatherOption.forEach(function (weatherData) {
		if (data.weather == weatherData[1]) {
			weather = weatherData[0];
		}
	});

	let traffic = "";
	trafficOption.forEach(function (trafficData) {
		if (data.traffic == trafficData[1]) {
			traffic = trafficData[0];
		}
	});

	let dnf = "";
	dnfOption.forEach(function (dnfData) {
		if (data.dnf == dnfData[1]) {
			dnf = dnfData[0];
		}
	});

	let accessible = "";
	accessibleOption.forEach(function (accessibleData) {
		if (data.accessible == accessibleData[1]) {
			accessible = accessibleData[0];
		}
	});

	let mode = "";
	modeOption.forEach(function (modeData) {
		if (data.mode == modeData[1]) {
			mode = modeData[0];
		}
	});

	let vehicle = "";
	vehicleOption.forEach(function (vehicleData) {
		if (data.vehicle == vehicleData[1]) {
			vehicle = vehicleData[0];
		}
	});

	$(".container-menu").fadeOut(300, function () {
		$(".loading").fadeIn(300, function () {
			$(".race-room-img").attr("src", data.img).off("error").on("error", function () {
				$(this).attr("src", "https://prod.cloud.rockstargames.com/ugc/gta5mission/3988/6WZSEickbUudE_FOQVgOrQ/2_0.jpg");
			});
			$(".name-race .data-room").text(data.name);
			$(".laps .data-room").text(data.laps);
			$(".weather .data-room").text(weather);
			$(".time .data-room").text(data.time + ":00");
			$(".traffic .data-room").text(traffic);
			$(".dnf .data-room").text(dnf);
			$(".accessible .data-room").text(accessible);
			$(".mode .data-room").text(mode);
			$(".race-vehicle .data-room").text(vehicle);
			$(".container-ui")
				.delay(2000)
				.fadeOut(300, function () {
					$(".loading").fadeOut(300);
					$(".room").fadeIn(1000);
					soundTransition.currentTime = 0;
					soundTransition.play();
					resetLeaveRoom = true;
					resetShowMenu = false;
				});
		});
	});
	eventRoom();
}

function loadRoom(data, bool, lobby) {
	$(".room").removeClass("animate__animate animate__fadeInDown");
	$(".room").attr("isOwner", "false");
	$("#btn-invite-players").show();
	$("#btn-start-race").hide();
	$(".container-main, .container-lobby").fadeOut(300);
	if (data.vehicle == "personal") {
		$("#btn-choose-vehicle").show();
		$("#btn-choose-vehicle").css("opacity", 1);
	} else {
		$("#btn-choose-vehicle").hide();
	}

	let weather = "";
	weatherOption.forEach(function (weatherData) {
		if (data.weather == weatherData[1]) {
			weather = weatherData[0];
		}
	});

	let traffic = "";
	trafficOption.forEach(function (trafficData) {
		if (data.traffic == trafficData[1]) {
			traffic = trafficData[0];
		}
	});

	let dnf = "";
	dnfOption.forEach(function (dnfData) {
		if (data.dnf == dnfData[1]) {
			dnf = dnfData[0];
		}
	});

	let accessible = "";
	accessibleOption.forEach(function (accessibleData) {
		if (data.accessible == accessibleData[1]) {
			accessible = accessibleData[0];
		}
	});

	let mode = "";
	modeOption.forEach(function (modeData) {
		if (data.mode == modeData[1]) {
			mode = modeData[0];
		}
	});

	let vehicle = "";
	vehicleOption.forEach(function (vehicleData) {
		if (data.vehicle == vehicleData[1]) {
			vehicle = vehicleData[0];
		}
	});

	if (!lobby) {
		if (bool) {
			$(".container-ui").fadeIn(300, function () {
				$(".loading").fadeIn(300, function () {
					$(".race-room-img").attr("src", data.img).off("error").on("error", function () {
						$(this).attr("src", "https://prod.cloud.rockstargames.com/ugc/gta5mission/3988/6WZSEickbUudE_FOQVgOrQ/2_0.jpg");
					});
					$(".name-race .data-room").text(data.name);
					$(".laps .data-room").text(data.laps);
					$(".weather .data-room").text(weather);
					$(".time .data-room").text(data.time + ":00");
					$(".traffic .data-room").text(traffic);
					$(".dnf .data-room").text(dnf);
					$(".accessible .data-room").text(accessible);
					$(".mode .data-room").text(mode);
					$(".race-vehicle .data-room").text(vehicle);
					$(".container-ui")
						.delay(2000)
						.fadeOut(300, function () {
							$(".loading").fadeOut(300);
							$(".room").fadeIn(1000, function () {
								$.post(`https://${GetParentResourceName()}/roomLoaded`, JSON.stringify({}));
								resetLeaveRoom = true;
								resetShowMenu = true;
							});
						});
				});
			});
		} else {
			restartMenu();
		}
	} else {
		if (bool) {
			$(".race-room-img").attr("src", data.img).off("error").on("error", function () {
				$(this).attr("src", "https://prod.cloud.rockstargames.com/ugc/gta5mission/3988/6WZSEickbUudE_FOQVgOrQ/2_0.jpg");
			});
			$(".name-race .data-room").text(data.name);
			$(".laps .data-room").text(data.laps);
			$(".weather .data-room").text(weather);
			$(".time .data-room").text(data.time + ":00");
			$(".traffic .data-room").text(traffic);
			$(".dnf .data-room").text(dnf);
			$(".accessible .data-room").text(accessible);
			$(".mode .data-room").text(mode);
			$(".race-vehicle .data-room").text(vehicle);
			$(".container-ui")
				.fadeOut(300, function () {
					$(".room").fadeIn(1000, function () {
						$.post(`https://${GetParentResourceName()}/roomLoaded`, JSON.stringify({}));
						resetLeaveRoom = true;
						resetShowMenu = true;
					});
				});
		} else {
			restartMenu();
		}
	}
	eventRoom();
}

function updatePlayersRoom(_players, _invitations, _playerCount, _vehicle) {
	$(".players-room").html("");

	if (_vehicle == "default") {
		$(".room .titles .label-2").hide();
	} else {
		$(".room .titles .label-2").show();
	}

	if (_players && _invitations) {
		let players = Object.values(_players);
		let invitations = Object.values(_invitations);
		let start = true;

		players.forEach(function (player) {
			let label = !player.roomLoaded ? roomStatusJoining : (player.ownerRace ? roomStatusHost : roomStatusIn);
			let labelAction = (player.ownerRace || !player.roomLoaded) ? " - " : roomActionRemove;
			let action = (player.ownerRace || !player.roomLoaded) ? "" : "action='kick'";
			let classAction = (player.ownerRace || !player.roomLoaded) ? "action-player-creator" : "action-player";
			if ($(".room").attr("isOwner") == "false") {
				labelAction = " - ";
				action = "";
				classAction = "action-player-creator";
			}
			let veh = "";
			if (_vehicle == "default") {
				start = true;
			}
			if (_vehicle == "specific") {
				veh = `<div class="room-field player-vehicle">${players[0].vehicle || "-"}</div>`;
			}
			if (_vehicle == "personal") {
				veh = `<div class="room-field player-vehicle">${player.vehicle || "-"}</div>`;
			}
			$(".players-room").append(`
			<div class="player-room" playerId="${player.src}">
				<div class="room-field player-name"><i class="fa-solid fa-user"></i>${player.nick}</div>
				${veh}
				<div class="room-field player-state">${label}</div>
				<div class="room-field ${classAction}" ${action}>${labelAction}</div>
			</div>
			`);
		});

		invitations.forEach(function (player) {
			let label = roomStatusGuest;
			let labelAction = roomActionRemove;
			let action = "action='cancel'";
			let classAction = "action-player";
			if ($(".room").attr("isOwner") == "false") {
				labelAction = " - ";
				action = "";
				classAction = "action-player-creator";
			}
			let veh = "";
			if (_vehicle != "default") {
				veh = `<div class="room-field player-vehicle">${player.vehicle || "-"}</div>`;
			}
			$(".players-room").append(`
			<div class="player-room" playerId="${player.src}">
				<div class="room-field player-name"><i class="fa-solid fa-user"></i>${player.nick}</div>
				${veh}
				<div class="room-field player-state">${label}</div>
				<div class="room-field ${classAction}" ${action}>${labelAction}</div>
			</div>
			`);
		});

		$(".player-vehicle").each(function () {
			if ($(this).text().trim() == "-") {
				start = false;
			}
		});

		if (start && $(".room").attr("isOwner") == "true") {
			$("#btn-start-race").css("opacity", 1);
			$("#btn-start-race")
				.off("click")
				.on("click", function () {
					if (resetLeaveRoom) {
						soundCick.currentTime = 0;
						soundCick.play();
						$.post(`https://${GetParentResourceName()}/startRace`, JSON.stringify({}));
					}
				});
		} else {
			$("#btn-start-race").css("opacity", 0.5);
			$("#btn-start-race").off("click");
		}

		$(".action-player")
			.off("click")
			.on("click", function () {
				let action = $(this).attr("action");
				let playerId = $(this).parent().attr("playerId");
				if (action == "kick") {
					$.post(`https://${GetParentResourceName()}/kickPlayer`, JSON.stringify({player: playerId}));
				} else if (action == "cancel") {
					$.post(`https://${GetParentResourceName()}/cancelInvitation`, JSON.stringify({player: playerId}));
				}
			});
	}
	if (_playerCount) {
		$(".player-count span").text(_playerCount);
	}
}

function exitRoom() {
	if (resetLeaveRoom) {
		resetLeaveRoom = false;
		if (resetShowMenu) {
			resetShowMenu = false;
			$(".container-lobby")
				.animate(
					{
						left: "102%"
					},
					{
						duration: 500
					},
					"ease-in-out"
				);

			$(".container-menu")
				.animate(
					{
						left: "0%"
					},
					{
						duration: 500
					},
					"ease-in-out"
				)
				.promise()
				.done(() => {
					$(".room")
						.addClass("scale-out2")
						.fadeOut(300, function () {
							$(this).removeClass("scale-out2");
							soundTransition.currentTime = 0;
							soundTransition.play();
							$(".container-menu").show();
							$(".container-main").show();
							eventMenu();
							$(".container-ui").fadeIn(300, function () {
								eventKeydown();
								if (!firstLoad) {
									eventInteraction();
									eventMapInteraction();
									eventSearchRace();
									eventCreateRoom();
									eventSound();
								}
							});
						});
				});
		} else {
			$(".room")
				.addClass("scale-out2")
				.fadeOut(300, function () {
					$(this).removeClass("scale-out2");
					soundTransition.currentTime = 0;
					soundTransition.play();
					$(".container-menu").show();
					$(".container-main").show();
					eventMenu();
					$(".container-ui").fadeIn(300, function () {
						eventKeydown();
						if (!firstLoad) {
							eventInteraction();
							eventMapInteraction();
							eventSearchRace();
							eventCreateRoom();
							eventSound();
						}
					});
				});
		}
	}
}

function eventKeydown() {
	$(document).off("keydown");
	$(document).keydown(function (event) {
		var keycode = event.keyCode ? event.keyCode : event.which;
		if (keycode == "27") {
			$(document).off("keydown");
			$(".search-race").off("keyup");
			$("#btn-create-race").off("click");
			$("#btn-quit-race").off("click");
			$("#btn-join-spectator").off("click");
			$(".lobby-room").removeClass("select");
			$("#btn-join-room").off("click");
			$("#btn-join-room")
				.removeClass("animate__animated animate__fadeInUp")
				.addClass("animate__animated animate__fadeOutDown")
				.fadeOut(300);
			$(".in-race-menu").fadeOut(300);
			$(".container-ui").fadeOut(300);
			$.post(`https://${GetParentResourceName()}/closeMenu`, JSON.stringify({}));
		}
	});
}

function eventKeydownInvitation() {
	$(document).off("keydown");
	$(document).keydown(function (event) {
		var keycode = event.keyCode ? event.keyCode : event.which;
		if (keycode == "27") {
			$(document).off("keydown");
			inInvitationUI = false;
			$(".invitations").removeClass("expanded");
			$(".no-invitations").hide();
			setTimeout(() => {
				if (($(".invitations-count").text() == 0) && (!inInvitationUI)) {
					$(".invitations").fadeOut(300);
				};
			}, 500)
			$.post(`https://${GetParentResourceName()}/closeMenu`, JSON.stringify({}));
		}
	});
}

function countdown() {
	resetLeaveRoom = false;
	resetShowMenu = false;
	$(".invite-box .close-box").off("click");
	$(".invite-box").removeClass("scale-in2").addClass("scale-out2").fadeOut(300, function () {
		$(this).removeClass("scale-out2").addClass("scale-in2");
	});
	$(".bottom-layer").fadeIn(300);
	$(".countdown-number").text("3");
	$(".countdown").fadeIn(300);
	soundTransition_2.currentTime = 0;
	soundTransition_2.play();
	$(".room .title, .room-data, .room-button-zone").css("filter", "blur(10px)");
	let time = 2;
	let countdownGo = setInterval(() => {
		$(".countdown-number").text(time);

		if (time == 0) {
			let soundStart = new Audio("./sounds/start.mp3");
			soundStart.volume = 0.3;
			soundStart.loop = false;
			soundStart.currentTime = 0;
			soundStart.play();
			clearInterval(countdownGo);
			$(".container-main, .container-lobby").hide();
			$(".container-ui").fadeIn(300, function () {
				$(".room")
					.addClass("scale-out2")
					.fadeOut(500, function () {
						$(this).removeClass("scale-out2");
						$(".loading").fadeIn(300, function () {
							$(".bottom-layer, .countdown").hide();
							$(".room .title, .room-data, .room-button-zone").css(
								"filter",
								"blur(0px)"
							);
						});
					});
			});
		} else {
			soundSecond.currentTime = 0;
			soundSecond.play();
		}
		time--;
	}, 1000);
}

function eventSound() {
	$(".button, .menu-map, .left, .right, .category, .vehicle-button, .race-bookmarked, .race-times, .btn-bookmarked, .btn-random")
		.off("mouseenter")
		.mouseenter(function () {
			soundOver.currentTime = 0;
			soundOver.play();
		});

	$(".button, .menu-map, .left, .right, .category, .vehicle-button, .btn-bookmarked, .btn-random").click(function (event) {
		if (event.currentTarget.id !== "btn-choose-vehicle") {
			soundCick.currentTime = 0;
			soundCick.play();
		}
	});
}

function showNotification(text) {
	const notification = $(`<div class="notification animate__animated animate__backInRight">${text}</div>`);
	$(".notifications").append(notification);
	setTimeout(() => {
		pop.currentTime = 0;
		pop.play();
	}, 500);
	setTimeout(() => {
		$(notification)
			.removeClass("animate__backInRight")
			.addClass("animate__backOutRight")
			.fadeOut(500, function () {
				$(this).remove();
			});
	}, 3000);
}

function countdownDNF(number) {
	$(".nf-zone").fadeIn(300);
	let timeOut = number / 1000;
	let minutes = Math.floor(timeOut / 60);
	let seconds = timeOut % 60;
	$(".nf-zone span").text(`${minutes < 10 ? "0" : ""}${minutes}:${seconds < 10 ? "0" : ""}${seconds}`);
	let timeNF = setInterval(() => {
		if (timeOut > 1) {
			timeOut--;
			minutes = Math.floor(timeOut / 60);
			seconds = timeOut % 60;
			$(".nf-zone span").text(`${minutes < 10 ? "0" : ""}${minutes}:${seconds < 10 ? "0" : ""}${seconds}`);
		} else {
			clearInterval(timeNF);
			setTimeout(() => {
				$(".nf-zone").fadeOut(300);
			}, 1000);
		}
	}, 1000);
}

function spectateList(players, playerId, bool) {
	$(".players-spectate").html("");
	if (!inSpectatorMode) {
		$(".spectate").fadeIn(300);
		inSpectatorMode = true;
	}
	players.forEach((v) => {
		$(".players-spectate").append(`
		<div class="player-sp d-flex" id="player_spec_${v.playerId}">
			<div class="sp-number">${v.position}</div>
			<div class="sp-nick"><img class="sp-flag" src="./flags/${v.flag}.svg" /> <span class="sp-keyboard">${v.keyboard}</span> ${v.playerName}</div>
			<div class="eye"><i class="fas fa-eye"></i></div>
		</div>
		`);
	});

	$("#player_spec_" + playerId).addClass("view");
	if (bool) {
		soundOver.currentTime = 0;
		soundOver.play();
	}
}

function updatePauseMenu() {
	$(".race-info #p-title").text(pausemenuTitle);
	$(".race-info #p-weather").text(pausemenuWeather);
	$(".race-info #p-time").text(pausemenuTime);
	$(".race-info #p-traffic").text(pausemenuTraffic);
	$(".race-info #p-dnf").text(pausemenuDNF);
	$(".race-info #p-accessible").text(pausemenuAccessible);
	$(".race-info #p-mode").text(pausemenuMode);
	$(".race-info .race-img").attr("src", pausemenuImg).off("error").on("error", function () {
		$(this).attr("src", "https://prod.cloud.rockstargames.com/ugc/gta5mission/3988/6WZSEickbUudE_FOQVgOrQ/2_0.jpg");
	});
}

function eventRoom() {
	$("#btn-leave-race")
		.off("click")
		.on("click", function () {
			if (resetLeaveRoom) {
				$("#btn-leave-race").off("click");
				$("#btn-choose-vehicle").off("click");
				$("#btn-start-race").off("click");
				soundCick.currentTime = 0;
				soundCick.play();
				$.post(`https://${GetParentResourceName()}/leaveRoom`, JSON.stringify({}));
			}
		});

	$("#btn-choose-vehicle")
		.off("click")
		.on("click", function () {
			$("#btn-choose-vehicle").off("click");
			$("#btn-choose-vehicle").css("opacity", 0.5);
			soundCick.currentTime = 0;
			soundCick.play();
			$(".room").addClass("animate__animated animate__fadeOutUp").fadeOut(500);
			loadSelectRaceVehicle();
		});

	$("#btn-invite-players")
		.off("click")
		.on("click", function () {
			soundCick.currentTime = 0;
			soundCick.play();
			$(".invite-box").fadeIn(300);
			$(".bottom-layer").fadeIn(300);
			invitePlayers();
			$(".invite-box .close-box")
				.off("click")
				.on("click", function () {
					$(".bottom-layer").fadeOut(300);
					$(this)
						.parent()
						.removeClass("scale-in2")
						.addClass("scale-out2")
						.fadeOut(300, function () {
							$(this).removeClass("scale-out2").addClass("scale-in2");
						});
				});
		});
}

function updatePositionTable(table, labels) {
	if (table) {
		$(".flex-position").html("");
		$(".flex-position").append(`
			<div class="position-label">
				<div class="position-hidden-number"></div>
				<div class="position-label-long"><span class="position-text-overflow">${labels.label_name}</span></div>
				<div class="position-label-ping">${labels.label_ping}</div>
				<div class="position-label-fps">${labels.label_fps}</div>
				<div class="position-label-short">${labels.label_distance}</div>
				${labels.label_lap ? `<div class="position-label-short">${labels.label_lap}</div>` : ""}
				<div class="position-label-short">${labels.label_checkpoint}</div>
				<div class="position-label-long"><span class="position-text-overflow">${labels.label_vehicle}</span></div>
				${labels.label_last_lap ? `<div class="position-label-short">${labels.label_last_lap}</div>` : ""}
				${labels.label_best_lap ? `<div class="position-label-short">${labels.label_best_lap}</div>` : ""}
				<div class="position-label-short">${labels.label_total_time}</div>
			</div>
			`);
		table.map((p) => {
			$(".flex-position").append(`
			<div class="position-label">
				<div class="position-number">${p.position}</div>
				<div class="position-text-long"><span class="position-text-overflow"><img class="position-flag" src="./flags/${p.flag}.svg" /> ${p.keyboard} ${p.name}</span></div>
				<div class="position-text-ping">${p.ping}</div>
				<div class="position-text-fps">${p.fps}</div>
				<div class="position-text-short">${p.distance}</div>
				${labels.label_lap ? `<div class="position-text-short">${p.lap}</div>` : ""}
				<div class="position-text-short">${p.checkpoint}</div>
				<div class="position-text-blue"><span class="position-text-overflow">${p.vehicle}</span></div>
				${labels.label_last_lap ? `<div class="position-text-short">${p.lastLap}</div>` : ""}
				${labels.label_best_lap ? `<div class="position-text-short">${p.bestLap}</div>` : ""}
				<div class="position-text-short">${p.totalTime}</div>
			</div>
			`);
		});

		if (!$(".position-table-container").hasClass("show")) {
			$(".position-table-container").addClass("show");
		}
	}
}

function translateHtmlText(texts) {
	document.querySelectorAll("[data-translate]").forEach(element => {
		const key = element.getAttribute("data-translate");
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
	$(".weather .content").find("div").text(texts[$(".weather .content").attr("value")]);
	$(".accessible .content").find("div").text(texts[$(".accessible .content").attr("value")]);
	$(".racemode .content").find("div").text(texts[$(".racemode .content").attr("value")]);
	$(".racevehicle .content").find("div").text(texts[$(".racevehicle .content").attr("value")]);
}

function adjustVehicleListAndStatsTop() {
	const categories = $(".vehicles .categories");
	let categoriesHeight = categories.outerHeight();
	let lineHeight = parseFloat(categories.css("font-size")) * 1.333;
	let numLines = Math.round(categoriesHeight / lineHeight);
	$(".vehicles .vehicle-list").css("top", `${24 + (numLines - 2) * 4}vh`);
	$(".vehicles .vehicle-stats").css("top", `${24 + (numLines - 2) * 4}vh`);
}

function loadSelectRaceVehicle() {
	$.post(`https://${GetParentResourceName()}/selectVehicleCam`, JSON.stringify({}), function () {
		loadVehicleCategories().done(() => {
			$(".vehicles .category").removeClass("selected");
			$(".vehicles .category:first-child").addClass("selected");
			postGetVehicles(favoriteText).done(function () {
				eventRaceVehicle();
				$(".vehicle-list").delay(1000).fadeIn(500);
				setTimeout(() => {
					adjustVehicleListAndStatsTop();
				}, 1000);
			});
			$(".vehicle-stats").removeClass("show");
			$(".vehicles").fadeIn(300);
			$(".vehicles .category")
				.off("click")
				.on("click", function () {
					if (!$(this).hasClass("selected")) {
						$(".vehicles .category").removeClass("selected");
						$(this).addClass("selected");
						const category = $(this).text();
						$(".vehicle-list")
							.removeClass("fade-in-right")
							.addClass("fade-out-left")
							.fadeOut(500, function () {
								postGetVehicles(category.trim()).done(function () {
									eventRaceVehicle();
									$(".vehicle-list")
										.removeClass("fade-out-left")
										.addClass("fade-in-right")
										.fadeIn(500);
								});
							});
					}
				});
		});
	});
}

function loadVehicleCategories() {
	return $.post(`https://${GetParentResourceName()}/getCategoryList`, JSON.stringify({}), function (data) {
		if (data) {
			favoriteText = data.translatedText["Favorite"];
			personalText = data.translatedText["Personal"];
			$(".vehicles .categories").html(`
			<div class="category selected">${favoriteText}</div>
			<div class="category selected">${personalText}</div>
			`);
			Object.entries(data.categoryList).forEach((category) => {
				$(".vehicles .categories").append(`
				<div class="category">${category[1]}</div>
				`);
			});
		}
	}, "json");
}

function postGetVehicles(category) {
	return $.post(`https://${GetParentResourceName()}/getCategory`, JSON.stringify({category: category}), function (data) {
		if (data) {
			let htmlCategory = "";
			$(".vehicles-container").html("");
			data.forEach((vehicle) => {
				let favorite = "<i class='fa-regular fa-star gradient-text'></i>";
				if (vehicle.favorite || category == favoriteText) {
					favorite = "<i class='fa-solid fa-star gradient-text'></i>";
					vehicle.favorite = true;
				}
				if (category == favoriteText) {
					htmlCategory = `<div class="category-name">${vehicle.category}</div>`;
				}

				$(".vehicles-container").append(`
				<div class="vehicle" model="${vehicle.model}">
					<div class="w-100 vehicle-button d-flex align-items-center">
						<i class="fas fa-car gradient-text"></i>
						<div class="d-inline-block">
							${htmlCategory}
							<div class="v-tag">${vehicle.label}</div>
						</div>
					</div>
					<div class="favorite" favorite="${vehicle.favorite}">
						${favorite}
					</div>
				</div>
				`);
			});
		}
	}, "json").promise();
}

function eventRaceVehicle() {
	setTimeout(() => {
		$(".vehicles-container").scrollTop(0);
		eventSound();
	}, 5);
	$("#search-vehicle").val("");
	$(".vehicle-button")
		.off("click")
		.on("click", function () {
			if ((!$(this).parent().hasClass("selected")) && (!isVehicleSelecting)) {
				isVehicleSelecting = true;
				$(".vehicle").removeClass("selected");
				$(this).parent().addClass("selected");

				$.post(`https://${GetParentResourceName()}/previewVeh`, JSON.stringify({model: $(this).parent().attr("model")}), function (handling) {
					$(".traction").css("width", handling.traction + "%");
					$(".speed").css("width", handling.maxSpeed + "%");
					$(".acceleration").css("width", handling.acceleration + "%");
					$(".braking").css("width", handling.breaking + "%");
					$(".vehicle-stats").addClass("show").show();
					isVehicleSelecting = false;
				}, "json");
			}
		});

	$(".favorite")
		.off("click")
		.on("click", function () {
			if (!isFavoriteUpdating) {
				isFavoriteUpdating = true;
				setTimeout(() => {
					isFavoriteUpdating = false;
				}, 1000);
				let category = $(".vehicles .category.selected").text().trim();
				const model = $(this).parent().attr("model");
				const label = $(this).parent().find(".v-tag").text();
				if ($(this).attr("favorite") == "true") {
					$(this).attr("favorite", false);
					$(this).html("<i class='fa-regular fa-star gradient-text'></i>");

					if (category == favoriteText) {
						category = $(this).parent().find(".category-name").text().trim();
						$(this)
							.parent()
							.addClass("fade-out-left")
							.fadeOut(300, function () {
								$(this).remove();
							});
					}

					$.post(`https://${GetParentResourceName()}/removeFromFavorite`, JSON.stringify({model: model, category: category}));
				} else {
					$(this).attr("favorite", true);
					$(this).html("<i class='fa-solid fa-star gradient-text'></i>");
					$.post(`https://${GetParentResourceName()}/addToFavorite`, JSON.stringify({model: model, label: label, category: category}));
				}
			}
		});

	$("#btn-accept-vehicle")
		.off("click")
		.on("click", function () {
			if (($(".vehicle.selected").length > 0) && (!isVehicleSelecting)) {
				$.post(`https://${GetParentResourceName()}/selectVeh`, JSON.stringify({model: $(".vehicle.selected").attr("model"), label: $(".vehicle.selected").find(".v-tag").text()}), function (data) {
					$(".room").removeClass("animate__fadeOutUp").addClass("animate__fadeInDown");
					if (data.inRoom) {
						$(".room").fadeIn(500);
					} else {
						$(".room").fadeOut(500);
					}
				}, "json");
				$(".vehicle-stats").removeClass("show");
				$(".vehicle").removeClass("selected");
				$(".vehicles").fadeOut(500);
			}
		});

	$(".vehicle-list .input-search")
		.off("keyup")
		.on("keyup", function (e) {
			if (e.which === 13) {
				let value = $(this).val().toLowerCase();
				$(".vehicle").filter(function () {
					$(this).toggle(
						$(this).find(".category-name").text().toLowerCase().indexOf(value) > -1 ||
						$(this).find(".v-tag").text().toLowerCase().indexOf(value) > -1
					);
				});
			}
		});
}

function setDashedGaugeValue(gaugeDOMElement, percentage, arcLength) {
	const emptyDashLength = 500;
	const filledArcLength = arcLength * (percentage / 100);
	gaugeDOMElement.style.strokeDasharray = `${filledArcLength} ${emptyDashLength}`;
	gaugeDOMElement.style.strokeDashoffset = filledArcLength;
}