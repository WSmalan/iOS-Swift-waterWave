//
//  ASongWaterWaveView.swift
//  WSWaterWaveDemo
//
//  Created by SongLan on 2017/2/19.
//  Copyright © 2017年 SongLan. All rights reserved.
//

import UIKit

class ASongWaterWaveView: UIView {
    //这里的lazy：是懒加载 就是OC中重写get，set方法
    lazy var waveDisplaylink = CADisplayLink()//相比NSTimer下，这里用CADisplayLink主要是精确点，其频率：1/60
    lazy var firstWaveLayer = CAShapeLayer()
    lazy var secondWaveLayer = CAShapeLayer()
    /// 基础描述 正弦函数
    ///   y=Asin(ωx+φ）+ b
    ///   A : wavaA
    ///   w : 1/waveW
    ///   φ : offsetφ
    ///   b : b
    private var waveA: CGFloat = 0
    private var waveW: CGFloat = 0
    private var offsetX: CGFloat = 0
    private var b : CGFloat = 0
    //水纹的移动的速度
    var waveSpeed : CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let asongLabel = UILabel(frame: CGRect(x: 0, y: 64, width: frame.size.width, height: 40))
        asongLabel.text = "Asong教你水波纹的实现"
        asongLabel.font = UIFont.systemFont(ofSize: 20)
        asongLabel.textColor = UIColor.red
        asongLabel.textAlignment = .center
        self.addSubview(asongLabel)
        
        initData()
        configUI()
    }
    //MARK: - 数据的初始化
    private func initData(){
        waveSpeed = 0.05
        waveA = 8
        // 设置周期 :( 2* M_PI)/waveW = bounds.size.width 。因为涉及的是layer，所以只谈bounds,不说frame
        waveW = 2 * CGFloat(M_PI) / bounds.size.width
        b  = bounds.size.height / 2
    }
    //MARK: - 初始化UI
    private func configUI(){
        firstWaveLayer.fillColor = UIColor.init(colorLiteralRed: 69/255.0, green: 255/255.0, blue: 255/255.0, alpha: 0.5).cgColor
        secondWaveLayer.fillColor = UIColor.init(colorLiteralRed: 69/255.0, green: 255/255.0, blue: 255/255.0, alpha: 0.5).cgColor
        layer.addSublayer(firstWaveLayer)
        layer.addSublayer(secondWaveLayer)
        waveDisplaylink = CADisplayLink(target: self, selector: #selector(getCurrentWave))
        waveDisplaylink.add(to: RunLoop.current, forMode: .commonModes)
    }
    
    @objc private func getCurrentWave() {
        offsetX += waveSpeed
        setCurrentStatusWavePath()
    }
    //MARK: - 关键部分
    private func setCurrentStatusWavePath() {
        // 创建一个路径
        let firstPath = CGMutablePath()
        var firstY = bounds.size.width/2
        firstPath.move(to: CGPoint(x: 0, y: firstY))
        for i in 0...Int(bounds.size.width) {
            firstY = waveA * sin(waveW * CGFloat(i) + offsetX) + b
            firstPath.addLine(to: CGPoint(x: CGFloat(i), y: firstY))
        }
        
        firstPath.addLine(to: CGPoint(x: bounds.size.width, y: bounds.size.height))
        firstPath.addLine(to: CGPoint(x: 0, y: bounds.size.height))
        firstPath.closeSubpath()
        firstWaveLayer.path = firstPath
        
        // 创建一个路径
        let secondPath = CGMutablePath()
        var secondY = bounds.size.width/2
        secondPath.move(to: CGPoint(x: 0, y: secondY))
        
        for i in 0...Int(bounds.size.width) {
            secondY = waveA * sin(waveW * CGFloat(i) + offsetX - bounds.size.width/2 ) + b
            secondPath.addLine(to: CGPoint(x: CGFloat(i), y: secondY))
        }
        secondPath.addLine(to: CGPoint(x: bounds.size.width, y: bounds.size.height))
        secondPath.addLine(to: CGPoint(x: 0, y: bounds.size.height))
        secondPath.closeSubpath()
        secondWaveLayer.path = secondPath
    }
    //记得释放 CADisplayLink
    deinit {
        waveDisplaylink.invalidate()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
}
