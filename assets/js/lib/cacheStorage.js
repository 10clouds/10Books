const setItem = (key, value, expiresIn) => {
  const data = JSON.stringify({
    value,
    expiresAt: expiresIn ? new Date().getTime() + expiresIn : null
  })

  try {
    window.localStorage.setItem(key, data)
  } catch (e) {
    console.error('Localstorage is not supported')
  }
}

const getItem = key => {
  const data = JSON.parse(window.localStorage.getItem(key))

  if (data) {
    return !data.expiresAt || data.expiresAt > new Date() ? data.value : null
  } else {
    return null
  }
}

export default { setItem, getItem }
