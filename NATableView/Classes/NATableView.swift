//
//  NATableView.swift
//  ShareCare
//
//  Created by Nick Ager on 03/05/2016.
//  Copyright © 2016 ShareCare Ltd. All rights reserved.
//

import UIKit

public typealias NACellAction = UITableViewCell -> Void
public typealias NACellActionPair = (cell: UITableViewCell, action: NACellAction?)

public struct NATableSection {
    let title : String?
    public var cells : [NACellActionPair]
    
    public init(title: String?, cells: [NACellActionPair]) {
        self.title = title
        self.cells = cells
    }
}

public class NATableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    public var sectionTitleHeight : CGFloat = 20
    public var anyCellSelectedAction: NACellAction?
    
    public var sections : [NATableSection] = [] {
        didSet {
            forceLayout()
        }
    }
    
    public override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style:style)
        commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        self.delegate = self
        self.dataSource = self
    }
    
    
    // MARK :
    
    func forceLayout() {
        reloadData()
    }
    
    // MARK: UITableViewDelegate
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let (cell, _) = cellFromIndexPath(indexPath)
        return cell.frame.size.height
    }
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let (cell, possibleAction) = cellFromIndexPath(indexPath)
        
        if let cellSelectedAction = self.anyCellSelectedAction {
            cellSelectedAction(cell)
        }
        
        if let action = possibleAction {
            action(cell)
        }
        cell.selected = false
    }
    
    // MARK: UITableViewDataSource
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = sections[section]
        return section.cells.count
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let (cell, _) = cellFromIndexPath(indexPath)
        return cell
    }
    
    public func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = sections[section]
        return section.title
    }
    
    public func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let section = sections[section]
        return section.title == nil ? 0 : sectionTitleHeight
    }
    
    // MARK:
    
    func cellFromIndexPath(indexPath: NSIndexPath) -> NACellActionPair {
        let section = sections[indexPath.section]
        return section.cells[indexPath.row]
    }

}
