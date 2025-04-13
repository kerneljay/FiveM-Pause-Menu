

document.addEventListener("DOMContentLoaded", function () {
  window.addEventListener("keydown", function (event) {
      if (event.key === "Escape") {
        closeMenu()
      }
    })
    window.addEventListener("click", function (event) {
      var target = event.target.closest("[data_action]")
      if (target) {
        var action = target.getAttribute("data_action")
        if (action) {
          fetchAction(action)
        }
      }
    })
    window.addEventListener("message", function (event) {
      if (event.data === "openFRAGPauseMenu") {
        openMenu(event.data)
      } else if (event.data === "closeFRAGPauseMenu") {
        closeMenu()
      } else if (event.data.act == "openurl") {
        window.invokeNative("openUrl", event.data.url)
      } else if (event.data.act == "copyToClipboard") {
        var node = document.createElement("textarea")
        var selection = document.getSelection()
        node.textContent = event.data.copytoboard
        document.body.appendChild(node)
        selection.removeAllRanges()
        node.select()
        document.execCommand("copy")
        selection.removeAllRanges()
        document.body.removeChild(node)

      } else if (event.data.event === "updatePlayerPauseMenu") {
        updateMenu(event.data)
      }
    })
    // Update the server name
    if (typeof serverName !== 'undefined') {
      const serverNameElements = document.querySelectorAll('.server_name');
      serverNameElements.forEach(element => { element.textContent = serverName });
    } else {
      console.error("Could not find the server name within config.js")
    }
    if (typeof customSelectorName !== 'undefined') {
      const customSelectorElement = document.querySelector('.disputeplayer_title');
      customSelectorElement.textContent = customSelectorName;
    }
    if (typeof customSelectorDescription !== 'undefined') {
      const customSelectorDescElement = document.getElementById('bottom_button_custom_heading');
      customSelectorDescElement.textContent = customSelectorDescription;
    }
    if (typeof backgroundColour !== 'undefined') {
      const backgroundTheme = document.querySelector('.pause_menu_container');
      backgroundTheme.style.background = backgroundColour;
    }
    if (typeof buttonColour !== 'undefined') {
      const wiki_button = document.querySelector('.server_wiki_guide');
      wiki_button.style.background = buttonColour;
    }
    if (customSelectorImage || customSelectorImage !== "" || typeof buttonColour !== 'undefined') {
      const customSelectorElementImg = document.getElementById('dispute');
      customSelectorElementImg.style.backgroundImage = `url(${customSelectorImage})`;
    }
})

function fetchAction(action) {
  fetch(`https://${GetParentResourceName()}/${action}`, {
    method: "POST",
  }).then((resp) => resp.json()).then()
}

function updateMenu(data) {
  updateElement("name", data.name)
  updateElement("id", data.permID)
  updateElement("job", data.currentJob)
  updateElement("playtime", data.playtime)
  updateElement("playersOnline", data.playersOnline)
}

function updateDateTime() {
  var spanElement = document.querySelector(".server_info_date_and_time")
  if (spanElement) {
    const { date, time } = getCurrentDateTime()
    spanElement.textContent = `${formatDate(date)} ${time}`
  }
}

function getCurrentDateTime() {
  const currentDate = new Date()
  const year = currentDate.getFullYear()
  const month = currentDate.getMonth() + 1
  const day = currentDate.getDate()
  const hours = currentDate.getHours()
  const minutes = currentDate.getMinutes()
  const seconds = currentDate.getSeconds()
  const formattedDate = `${year}-${month.toString().padStart(2, "0")}-${day
    .toString()
    .padStart(2, "0")}`
  const formattedTime = `${hours.toString().padStart(2, "0")}:${minutes
    .toString()
    .padStart(2, "0")}:${seconds.toString().padStart(2, "0")}`
  return { date: formattedDate, time: formattedTime }
}

function formatDate(date) {
  const [year, month, day] = date.split("-")
  return `${day}/${month}/${year.slice(-2)}`
}

function openMenu(data) {
  setTimeout(function () {
    fadeIn(document.querySelector(".pause_menu_container"))
  }, 100)
  updateDateTime()
  setInterval(updateDateTime, 500)
  if (data) {
    updateMenu(data)
  }
}

function closeMenu() {
  fadeOut(document.querySelector(".pause_menu_container"))
}

function updateElement(selector, value) {
  var element = document.getElementById(selector)
  if (element) {
    element.textContent = value
  }
}

function fadeIn(element) {
  element.style.opacity = 0
  element.style.display = "flex"
  var opacity = 0
  var fadeInInterval = setInterval(function () {
    if (opacity < 1) {
      opacity += 0.05
      element.style.opacity = opacity
    } else {
      clearInterval(fadeInInterval)
    }
  }, 20)
}

function fadeOut(element) {
  var opacity = 1
  var fadeOutInterval = setInterval(function () {
    if (opacity > 0) {
      opacity -= 0.05
      element.style.opacity = opacity
    } else {
      clearInterval(fadeOutInterval)
      element.style.display = "none"
    }
  }, 2)
}