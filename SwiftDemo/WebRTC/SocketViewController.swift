//
//  SocketViewController.swift
//  SwiftDemo
//
//  Created by sam   on 2019/8/28.
//  Copyright © 2019 sam  . All rights reserved.
//

import UIKit
import CocoaAsyncSocket

class SocketViewController: UIViewController {

    var addressField: UITextField!      // 服务器ip地址
    var portField: UITextField!         // 端口号
    var messageField: UITextField!      // 消息输入框
    var logField: UITextView!           // 日志
    var clientSocket: GCDAsyncSocket!   // 客户端socket
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        addViews()
        
        clientSocket = GCDAsyncSocket(delegate: self, delegateQueue: DispatchQueue.main)

    }
}

extension SocketViewController {
    
    func addViews() {
        
        // IP地址
        let ipLabel = UILabel(title: "IP地址", fontSize: 15, color: MW_BLACK_COLOR)
        ipLabel.frame = CGRect(x: 20, y: 80, width: 50, height: 15)
        // IP地址
        addressField = UITextField(placeholder: "请输入服务器的IP", placeholderColor: UIColor.lightGray, placeholderFontSize: 13, textColor: MW_BLACK_COLOR, textFontSize: 13)
        
        addressField.frame = CGRect(x: 90, y: 80, width: 150, height: 20)
        addressField.keyboardType = .decimalPad
        addressField.layer.borderWidth = 1
        addressField.layer.borderColor = UIColor.lightGray.cgColor
        addressField.layer.cornerRadius = 4
        // 端口
        let portLabel = UILabel(title: "端口", fontSize: 15, color: MW_BLACK_COLOR)
        portLabel.frame = CGRect(x: 20, y: 120, width: 40, height: 15)
        // 端口号
        portField = UITextField(placeholder: "请输入端口号", placeholderColor: UIColor.lightGray, placeholderFontSize: 13, textColor: MW_BLACK_COLOR, textFontSize: 13)
        
        portField.frame = CGRect(x: 90, y: 120, width: 100, height: 20)
        portField.keyboardType = .numberPad
        portField.layer.borderWidth = 1
        portField.layer.borderColor = UIColor.lightGray.cgColor
        portField.layer.cornerRadius = 4
        // 连接按钮
        let startConnectBtn = UIButton(title: "开始连接", fontSize: 14, titleColor: UIColor.blue)
        startConnectBtn.setTitle("断开连接", for: .selected)
        startConnectBtn.addTarget(self, action: #selector(clickConnect), for: .touchUpInside)
        
        startConnectBtn.frame = CGRect(x: 260, y: 120, width: 90, height: 20)
        startConnectBtn.layer.borderWidth = 1
        startConnectBtn.layer.borderColor = UIColor.blue.cgColor
        startConnectBtn.layer.cornerRadius = 4
        // 消息内容
        messageField = UITextField(placeholder: "请输入消息内容", placeholderColor: UIColor.lightGray, placeholderFontSize: 13, textColor: MW_BLACK_COLOR, textFontSize: 13)
        
        messageField.frame = CGRect(x: 40, y: 180, width: 200, height: 20)
        messageField.layer.borderWidth = 1
        messageField.layer.borderColor = UIColor.lightGray.cgColor
        messageField.layer.cornerRadius = 4
        // 发送消息
        let sendMsgBtn = UIButton(title: "发送消息", fontSize: 14, titleColor: UIColor.blue)
        
        sendMsgBtn.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        
        sendMsgBtn.frame = CGRect(x: 260, y: 180, width: 90, height: 20)
        sendMsgBtn.layer.borderWidth = 1
        sendMsgBtn.layer.borderColor = UIColor.blue.cgColor
        sendMsgBtn.layer.cornerRadius = 4
        // 清空消息
        let receiveBtn = UIButton(title: "清空消息", fontSize: 14, titleColor: UIColor.blue)
        
        receiveBtn.addTarget(self, action: #selector(clearData), for: .touchUpInside)
        
        receiveBtn.frame = CGRect(x: 100, y: 220, width: 90, height: 20)
        receiveBtn.layer.borderWidth = 1
        receiveBtn.layer.borderColor = UIColor.blue.cgColor
        receiveBtn.layer.cornerRadius = 4
        
        // 显示日志
        logField = UITextView(textColor: UIColor.gray, textFontSize: 15)
        logField.backgroundColor = UIColor.orange
        
        logField.frame = CGRect(x: 50, y: 280, width: MW_SCREEN_WIDTH() - 100, height: 300)
        
        view.addSubview(ipLabel)
        view.addSubview(addressField)
        view.addSubview(portLabel)
        view.addSubview(portField)
        view.addSubview(startConnectBtn)
        view.addSubview(messageField)
        view.addSubview(sendMsgBtn)
        view.addSubview(receiveBtn)
        view.addSubview(logField)
    }
}

extension SocketViewController {
    
    // 开始连接
    @objc func clickConnect(button: UIButton) {
        
        button.isSelected = !button.isSelected
        
        button.isSelected ? startConnect() : stopConnect()
    }
    // 停止连接
    func stopConnect() {
        
        clientSocket.disconnect()
        showMessage("断开连接")
    }
    // 开始连接
    func startConnect(){
        
        view.endEditing(true)
        
        do {
            try clientSocket.connect(toHost: addressField.text!, onPort: UInt16(portField.text!)!, withTimeout: -1)
            showMessage("连接成功")
        } catch {
            
            showMessage("连接失败")
        }
    }
    // 发消息
    @objc func sendMessage() {
        
        view.endEditing(true)
        
        let data = messageField.text?.data(using: .utf8)
        
        // timeout -1: 无穷大，一直等
        // tag: 消息标记
        clientSocket.write(data!, withTimeout: -1, tag: 0)
    }
    // 显示消息
    func showMessage(_ str: String) {
        
        logField.text = logField.text.appendingFormat("%@\n", str)
    }
    // 清空消息
    @objc func clearData() {
        
        logField.text = ""
    }
}

extension SocketViewController: GCDAsyncSocketDelegate {
    // 断开连接
    func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) {
        
        showMessage("已断开连接-----")
    }
    // 连接成功
    func socket(_ sock: GCDAsyncSocket, didConnectToHost host: String, port: UInt16) {
        
        showMessage("连接成功")
        
        let address = "服务器IP：" + "\(host)"
        
        showMessage(address)
        
        clientSocket.readData(withTimeout: -1, tag: 0)
    }
    // 接收到消息
    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        
        let text = String(data: data, encoding: .utf8)
        
        showMessage(text!)
        
        clientSocket.readData(withTimeout: -1, tag: 0)
    }
}
