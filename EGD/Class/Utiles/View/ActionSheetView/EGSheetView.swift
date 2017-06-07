//
//  EGSheetView.swift
//  EGD
//
//  Created by jieku on 2017/6/7.
//
//

import UIKit

enum CellTextStyle : Int {
    case Center = 0
    case Left
    case Right
}

protocol EGSheetViewDelegate : NSObjectProtocol {
    func sheetViewDidSelect(index : Int, title : String)
}

class EGSheetView: UIView {
    // 数据源
    var dataSource = [String]()
    // cell title颜色
    var cellTextColor : UIColor?
    // cell title字体
    var cellTextFont : UIFont?
    // cell文字样式 默认居中
    var cellTextStyle : CellTextStyle = .Center
    // 是否显示分割线 默认显示
    var showDivLine : Bool = true
    weak var delegate :EGSheetViewDelegate?

    
    override init(frame:CGRect){
        super.init(frame:frame)
        
        addSubview(divLine)
        addSubview(tableView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        divLine.frame = CGRect.init(x: 0, y: 0, width: self.mo_width, height: kLineHeight)
        tableView.frame = CGRect.init(x: 0, y: divLine.bottomY, width: self.mo_width, height: self.mo_height)
    }
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .plain)
        table.dataSource = self
        table.delegate = self
        table.tableFooterView = UIView()
        table.separatorStyle = .none
        
        table.register(EGSheetTableViewCell.self, forCellReuseIdentifier: EGSheetCellIdentifier)
        return table
    }()
    
    lazy var divLine : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
}

extension EGSheetView : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return kCellH
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: EGSheetCellIdentifier) as! EGSheetTableViewCell
        
        if cellTextColor != nil {
            cell.titleLab.textColor = cellTextColor
        }
        if cellTextFont != nil {
            cell.titleLab.font = cellTextFont
        }
        
        switch cellTextStyle {
        case .Left:
            cell.titleLab.textAlignment = .left
        case .Right:
            cell.titleLab.textAlignment = .right
        default:
            cell.titleLab.textAlignment = .center
        }
        
        cell.lineView.isHidden = !showDivLine
        cell.titleLab.text = dataSource[indexPath.row]
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        delegate?.sheetViewDidSelect(index: indexPath.row, title: dataSource[indexPath.row])
    }
}
