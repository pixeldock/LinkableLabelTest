//
//  Data.swift
//  LinkableLabelTest
//
//  Created by Jörn Schoppe on 07.12.17.
//  Copyright © 2017 Jörn Schoppe. All rights reserved.
//

import Foundation

struct Data {
    static let texts: [String] = [
        "This is a cell with a link: www.google.com",
        "This is a cell with 2 links: www.google.com and http://xing.de",
        "This is a cell with 2 links: www.google.com and http://xing.de",
        "A very long url: http://xing.de/asdfasdf/ASdfdsafasdfasdfasdf/ASdfdsafasdfasdfasdf/ASdfdsafasdfasdfasdf/ASdfdsafasdfasdfasdf/ASdfdsafasdfasdfasdf/ASdfdsafasdfasdfasdf/ASdfdsafasdfasdfasdf/ASdfdsafasdfasdfasdf/ASdfdsafasdfasdfasdf/ASdfdsafasdfasdfasdf/ASdfdsafasdfasdfasdf/ASdfdsafasdfasdfasdf/ASdfdsafasdfasdfasdf/ASdfdsafasdf",
        "Do you see any Teletubbies in here? Do you see a slender plastic tag clipped to my shirt with my name printed on it? Do you see a little Asian child with a blank expression on his face sitting outside on a mechanical helicopter that shakes when you put quarters in it? http://xing.de No? Well, that's what you see at a toy store. www.google.com. And you must think you're in a toy store, because you're here shopping for an infant named Jeb.",
        "You think water moves fast? You should see ice. It moves like it has a mind. Like it knows it killed the world once and got a taste for murder.",
        "Now that there is the Tec-9, a crappy spray gun from South Miami. This gun is advertised as the most popular gun in American crime. www.google.com. Do you believe that shit? It actually says that in the little book that comes with it: http://xing.de the most popular gun in American crime. http://amazon.de. Like they're actually proud of that shit.",
        "This is a cell with 2 links: www.google.com and http://xing.de",
        "This is a cell with 2 links: www.google.com and http://xing.de",
        "This is a cell with 2 links: www.google.com and http://xing.de",
        "Do you see any Teletubbies in here? Do you see a slender plastic tag clipped to my shirt with my name printed on it? Do you see a little Asian child with a blank expression on his face sitting outside on a mechanical helicopter that shakes when you put quarters in it? http://xing.de No? Well, that's what you see at a toy store. www.google.com. And you must think you're in a toy store, because you're here shopping for an infant named Jeb.",
        "You think water moves fast? You should see ice. It moves like it has a mind. Like it knows it killed the world once and got a taste for murder.",
        "Now that there is the Tec-9, a crappy spray gun from South Miami. This gun is advertised as the most popular gun in American crime. www.google.com. Do you believe that shit? It actually says that in the little book that comes with it: http://xing.de the most popular gun in American crime. http://amazon.de. Like they're actually proud of that shit.",
        "This is a cell with a link: www.google.com",
        "This is a cell with 2 links: www.google.com and http://xing.de",
        "This is a cell with 2 links: www.google.com and http://xing.de",
        "Do you see any Teletubbies in here? Do you see a slender plastic tag clipped to my shirt with my name printed on it? Do you see a little Asian child with a blank expression on his face sitting outside on a mechanical helicopter that shakes when you put quarters in it? http://xing.de No? Well, that's what you see at a toy store. www.google.com. And you must think you're in a toy store, because you're here shopping for an infant named Jeb.",
        "You think water moves fast? You should see ice. It moves like it has a mind. Like it knows it killed the world once and got a taste for murder.",
        "Now that there is the Tec-9, a crappy spray gun from South Miami. This gun is advertised as the most popular gun in American crime. www.google.com. Do you believe that shit? It actually says that in the little book that comes with it: http://xing.de the most popular gun in American crime. http://amazon.de. Like they're actually proud of that shit.",
        "This is a cell with 2 links: www.google.com and http://xing.de",
        "This is a cell with 2 links: www.google.com and http://xing.de",
        "This is a cell with 2 links: www.google.com and http://xing.de",
        "Do you see any Teletubbies in here? Do you see a slender plastic tag clipped to my shirt with my name printed on it? Do you see a little Asian child with a blank expression on his face sitting outside on a mechanical helicopter that shakes when you put quarters in it? http://xing.de No? Well, that's what you see at a toy store. www.google.com. And you must think you're in a toy store, because you're here shopping for an infant named Jeb.",
        "You think water moves fast? You should see ice. It moves like it has a mind. Like it knows it killed the world once and got a taste for murder.",
        "Now that there is the Tec-9, a crappy spray gun from South Miami. This gun is advertised as the most popular gun in American crime. www.google.com. Do you believe that shit? It actually says that in the little book that comes with it: http://xing.de the most popular gun in American crime. http://amazon.de. Like they're actually proud of that shit.",
        "This is a cell with a link: www.google.com",
        "This is a cell with 2 links: www.google.com and http://xing.de",
        "This is a cell with 2 links: www.google.com and http://xing.de",
        "Do you see any Teletubbies in here? Do you see a slender plastic tag clipped to my shirt with my name http://amazon.deprinted on it? Do you see a little Asian child with a blank expression on his face sitting outside on a mechanical helicopter that shakes when you put quarters in it? http://xing.de No? Well, that's what you see at a toy store. www.google.com. And you must think you're in a toy store, because you're here shopping for an infant named Jeb.",
        "You think water moves fast? You should see ice. It moves like it has a mind. Like it knows it killed the world once and got a taste for murder.",
        "Now that there is the Tec-9, a crappy spray gun from South Miami. This gun is advertised as the most popular gun in American crime. www.google.com. Do you believe that shit? It actually says that in the little book that comes with it: http://xing.de the most popular gun in American crime. http://amazon.de. Like they're actually proud of that shit.",
        "This is a cell with 2 links: www.google.com and http://xing.de",
        "This is a cell with 2 links: www.google.com and http://xing.de",
        "This is a cell with 2 links: www.google.com and http://xing.de",
        "Do you see any Teletubbies in here? Do you see a slender plastic tag clipped to my shirt with my name printed on it? Do you see a little Asian child with a blank expression on his face sitting outside on a mechanical helicopter that shakes when you put quarters in it? http://xing.de No? Well, that's what you see at a toy store. www.google.com. And you must think you're in a toy store, because you're here shopping for an infant named Jeb.",
        "You think water moves fast? http://amazon.de You should see ice. http://amazon.de It moves like http://amazon.de it has a mind. http://amazon.de Like it knows it killed the world http://amazon.de once and got a taste for murder. http://amazon.de",
        "Now that there is the Tec-9, a crappy spray gun from South Miami. This gun is advertised as the most popular gun in American crime. www.google.com. Do you believe that shit? It actually says that in the little book that comes with it: http://xing.de the most popular gun in American crime. http://amazon.de. Like they're actually proud of that shit.",
        "This is a cell with a link: www.google.com",
        "This is a cell with 2 links: www.google.com and http://xing.de",
        "This is a cell with 2 links: www.google.com and http://xing.de",
        "Do you see any Teletubbies in here? Do you see a slender plastic tag clipped to my shirt with my name printed on it? Do you see a little Asian child with a blank http://amazon.de expression on his face sitting outside on a mechanical helicopter that shakes when you put quarters in it? http://xing.de No? Well, that's what you see at a toy store. www.google.com. And you must think you're in a toy store, because you're here shopping for an infant named Jeb.",
        "You think water moves fast? You should see ice. It moves like it has a mind. Like it knows it killed the world once and got a taste for murder.",
        "Now that there is the Tec-9, a crappy spray gun http://amazon.de from South Miami. This gun is advertised as the most popular gun in American crime. www.google.com. Do you believe that shit? It actually says that in the little book that comes with it: http://xing.de the most popular gun in American crime. http://amazon.de. Like they're actually proud of that shit.",
        "This is a cell with 2 links: www.google.com and http://xing.de",
        "This is a cell with 2 links: www.google.com and http://xing.de",
        "This is a cell with 2 links: www.google.com and http://xing.de",
        "Do you see any Teletubbies in here? Do you see a slender plastic tag clipped to my shirt with my name printed on it? Do you see a little Asian child with a blank expression on his face sitting outside on a mechanical helicopter that shakes when you put quarters in it? http://xing.de No? Well, that's what you see at a toy store. www.google.com. And you must think you're in a toy store, because you're here shopping for an infant named Jeb.",
        "You think water moves fast? You should see ice. It moves like it has a mind. Like it knows it killed the world once and got a taste for murder.",
        "Now that there is the Tec-9, a crappy spray gun from South Miami. This gun is advertised as the most popular gun in American crime. www.google.com. Do you believe that shit? It actually says that in the little book that comes with it: http://xing.de the most popular gun in American crime. http://amazon.de. Like they're actually proud of that shit.",
    ]
    
    static let text: String = "http://amazon.de asdf http://amazon.de adfadsfhttp://amazon.de ss sdasfdaf https://mobile-jenkins.dc.xing.com/job/ios-XING-monorepo-pull-requests/1489/ sfsfd sdfdsf dfs dd https://demo.int/pages/3 https://demo.int/pages/3 https://demo.int/pages/3 https://demo.int/pages/3 fasdsdaf sdaffadshttps://demo.int/pages/3  asd https://demo.int/pages/3 afsasdfhttps://demo.int/pages/3 https://demo.int/pages/3 afdsfadfs https://demo.int/pages/3 fasdfdfasdaffd https://demo.int/pages/3 fsadfsddafs https://demo.int/pages/3 https://demo.int/pages/3 wewewerwewer https://demo.int/pages/3 adf sadffa qereewrwer ysdsddssd https://demo.int/pages/3 https://demo.int/pages/3 https://demo.int/pages/3 werewwerrwe fdssdfdfsdsf awewaaewaew sdfsf sdf https://demo.int/pages/3 fafdshttps://demo.int/pages/3  adsfd https://demo.int/pages/3 afdsfda https://demo.int/pages/3http://amazon.de asdf http://amazon.de adfadsfhttp://amazon.de ss sdasfdaf https://mobile-jenkins.dc.xing.com/job/ios-XING-monorepo-pull-requests/1489/ sfsfd sdfdsf dfs dd https://demo.int/pages/3 https://demo.int/pages/3 https://demo.int/pages/3 https://demo.int/pages/3 fasdsdaf sdaffadshttps://demo.int/pages/3  asd https://demo.int/pages/3 afsasdfhttps://demo.int/pages/3 https://demo.int/pages/3 afdsfadfs https://demo.int/pages/3 fasdfdfasdaffd https://demo.int/pages/3 fsadfsddafs https://demo.int/pages/3 https://demo.int/pages/3 wewewerwewer https://demo.int/pages/3 adf sadffa qereewrwer ysdsddssd https://demo.int/pages/3 https://demo.int/pages/3 https://demo.int/pages/3 werewwerrwe fdssdfdfsdsf awewaaewaew sdfsf sdf https://demo.int/pages/3 fafdshttps://demo.int/pages/3  adsfd https://demo.int/pages/3 afdsfda https://demo.int/pages/3"
    
}
