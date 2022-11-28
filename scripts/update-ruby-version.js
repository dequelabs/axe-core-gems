const regex = /VERSION\s+=\s"([\d.]+)"/

exports.readVersion = contents => {
  const m = regex.exec(contents)
  return m[1]
}

exports.writeVersion = (contents, version) => {
  return contents.replace(regex, `VERSION = "${version}"`)
}
