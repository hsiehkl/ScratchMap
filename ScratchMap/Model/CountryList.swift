//
//  CountryList.swift
//  ScratchMap
//
//  Created by Cheng-Shan Hsieh on 2017/12/17.
//  Copyright © 2017年 HsinTing Hsieh. All rights reserved.
//

import Foundation

enum Continent: String {

    typealias RawValue = String

    case europe = "Europe"

    case asia = "Asia"

    case africa = "Africa"

    case northAmerica = "North America"

    case southAmerica = "South America"

    case oceania = "Oceania"

    case europeAndAsia = "Europe and Asia"

}

let countryIdClassifiedByContinents = [

    "Europe": ["AL", "AD", "AM", "AT", "AX", "AZ", "BY", "BE", "BA", "BG", "HR", "CY", "CZ", "DK", "EE", "FI", "FO", "FR", "GE", "GE", "GI", "DE", "GR", "HU", "IM", "IS", "IE", "JE", "IT", "XK", "LV", "LI", "LT", "LU", "MK", "MT", "MD", "MC", "ME", "NL", "NO", "PL", "PT", "RO", "RU", "SM", "RS", "SK", "SJ", "SI", "ES", "SE", "CH", "TR", "UA", "GB", "VA"],

    "Asia": ["AF", "AM", "AZ", "BH", "BD", "BT", "BN", "KH", "CN", "CY", "CX", "GE", "IN", "ID", "IR", "IQ", "IL", "JP", "JO", "KZ", "KW", "KG", "LA", "LB", "MY", "MV", "MN", "MM", "NP", "KP", "OM", "PK", "PS", "PH", "QA", "RU", "SA", "SG", "KR", "LK", "SY", "TW", "TJ", "TH", "TL", "TR", "TM", "AE", "UZ", "VN", "YE"],

    "Africa": [ "DZ", "AO", "BJ", "BW", "BF", "BI", "CV", "CM", "CF", "TD", "KM", "CD", "CG", "CI", "DJ", "EG", "GQ", "ER", "ET", "GA", "GM", "GH", "GN", "GW", "KE", "LS", "LR", "LY", "MG", "MW", "ML", "MR", "MU", "MA", "MZ", "NA", "NE", "NG", "RE", "RW", "ST", "SN", "SC", "SL", "SO", "ZA", "SS", "SD", "SZ", "TZ", "TG", "TN", "UG", "YT", "ZM", "ZW"],

    "North America": ["AG", "BS", "BB", "BZ", "CA", "CR", "CU", "DM", "DO", "SV", "GD", "GT", "HT", "HN", "JM", "MX", "NI", "PA", "KN", "LC", "VC", "TT", "US", "AI", "AW", "BM", "BQ", "VG", "KY", "CW", "GL", "GP", "MQ", "MS", "PR", "BQ", "BL", "MF", "PM", "SX", "TC", "VI"],

    "South America": ["AR", "BO", "BR", "CL", "CO", "EC", "GY", "PY", "PE", "SR", "UY", "VE", "GS", "FK", "GF"],

    "Oceania": ["AU", "FJ", "KI", "MH", "FM", "NR", "NZ", "PW", "PG", "WS", "SB", "TO", "TV", "VU", "AS", "CK", "PF", "GU", "NC", "NU", "NF", "MP", "PN", "TK", "UM-WQ", "WF"]

]
