# This is just an example to get you started. A typical binary package
# uses this file as the main entry point of the application.
import strutils, sequtils, nre, options

# ************ Input *************

proc getInput(file: bool): seq[seq[string]] =
  var input = 
    if file: 
      readFile("input.txt")
    else:
      """
      ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
      byr:1937 iyr:2017 cid:147 hgt:183cm

      iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884
      hcl:#cfa07d byr:1929

      hcl:#ae17e1 iyr:2013
      eyr:2024
      ecl:brn pid:760753108 byr:1931
      hgt:179cm

      hcl:#cfa07d eyr:2025 pid:166559648
      iyr:2011 ecl:brn hgt:59in
      """
  for data in input.strip.split("\n\n"):
    let fields = data.strip(true, true, {'\n'}).splitWhitespace
    result.add(fields)

# ************ Validation *************

proc validateFieldValue(key: string, value: string): bool =
  result = case key
    # Birth Year
    of "byr":
      try: 
        let val = parseInt(value) 
        1920 <= val and val <= 2002
      except: false
    # Issue Year
    of "iyr":
      try: 
        let val = parseInt(value) 
        2010 <= val and val <= 2020
      except: false
    # Expiration Year
    of "eyr":
      try: 
        let val = parseInt(value) 
        2020 <= val and val <= 2030
      except: false
    # Height
    of "hgt":
      let match = value.match(re"^([0-9]{3}cm)$|^([0-9]{2}in)$")
      if match.isSome:
        # NNNcm
        if match.get.captures[-1].len == 5:
          try:
            let val = parseInt(match.get.captures[0][0..2])
            150 <= val and val <= 193
          except: false
        # NNin
        elif match.get.captures[-1].len == 4: 
          try:
            let val = parseInt(match.get.captures[1][0..1])
            59 <= val and val <= 76
          except: false
        else: false
      else: false
    # Hair Color
    of "hcl":
      value.match(re"^#[0-9a-fA-F]{6}$").isSome
    # Eye Color
    of "ecl":
      ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"].contains(value)
    # Passport Id
    of "pid":
      value.match(re"^\d{9}$").isSome
    # Country Id
    of "cid": true
    else: false

const validKeys = ["ecl", "pid", "eyr", "hcl", "byr", "iyr", "hgt"]

proc validate(data: seq[string]): bool =
  # this checksum increments for every valid key
  # final value must be equal to len of the validKeys
  var validatedKeysChecksum: uint
  # this seq contains results of validation of each value
  # the idea is to fold this later to get final result of all the validated values
  var validatedValuesResults: seq[bool]

  for field in data:
    # validate key
    let key = field[0..2]
    if validKeys.contains(key): inc(validatedKeysChecksum)

    # validate values
    let value = field[4..field.high]
    validatedValuesResults.add(validateFieldValue(key, value))

  result = validatedKeysChecksum == validKeys.len and validatedValuesResults.foldl(a and b)

# ************ Main *************

when isMainModule:
  let input = getInput(true)
  echo input.filter(validate).len

