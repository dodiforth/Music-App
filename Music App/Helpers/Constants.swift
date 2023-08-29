//
//  Constants.swift
//  Music App
//
//  Created by Dowon Kim on 29/08/2023.
//

import Foundation

// MARK: - Name Space

//let REQUEST_URL = "https://itunes.apple.com/search?"

// API related Strings
public enum MusicApi {
    static let requestUrl = "https://itunes.apple.com/search?"
    static let mediaParam = "media=music"
}

// Cell Related Strings
public struct Cell {
    static let musicCellIdentifier = "MusicCell"
    static let musicCollectionViewCellIdentifier = "MusicCollectionViewCell"
    private init() {}
}

// Configure setting for Collection View
public struct CVCell {
    static let spacingWidth: CGFloat = 1
    static let cellColumns: CGFloat = 3
    private init() {}
}
