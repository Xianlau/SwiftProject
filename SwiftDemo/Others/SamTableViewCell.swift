//
//  SamTableViewCell.swift
//  SwiftDemo
//
//  Created by sam   on 2019/4/24.
//  Copyright © 2019 sam  . All rights reserved.
//

import UIKit
import SnapKit

class SamTableViewCell: UITableViewCell {

    var iconImv:UIImageView!    // 头像

    override func awakeFromNib() {
        super.awakeFromNib()

    }


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        // 头像
        iconImv = UIImageView()
        iconImv.layer.masksToBounds = true
        iconImv.layer.cornerRadius = 22.0
        iconImv.isUserInteractionEnabled = true

        contentView.addSubview(iconImv)

    }


//    func cellWithTableView<T: UITableViewCell>(tableView : UITableView, cellCls:T.Type) -> T {
//
//        let cellid = Sam_ClassName
//        var cell:UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellid) as! SamTableViewCell
//        if cell == nil {
//            cell = SamTableViewCell (style: .subtitle, reuseIdentifier: cellid)
//        }
//        return cell as! T
//    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override func layoutSubviews() {
        super.layoutSubviews()

        //iconImv.frame = contentView.bounds
        iconImv.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        }

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)




    }

}
