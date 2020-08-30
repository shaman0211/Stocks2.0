//
//  ViewController.swift
//  Stocks
//
//  Created by Artem  on 29.08.2020.
//  Copyright © 2020 Artem . All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var mainStocks: UILabel!
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var companySymbolLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceChangeLabel: UILabel!
    @IBOutlet weak var companyPickerView: UIPickerView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var companyImage: UIImageView!
    
    private var networkService = NetworkService()
    
    //?token=pk_cc2367f4df2d44ae8e60a594f02154b9
    
    private var stocks: [Stock] = []
    
    private func requestQuoteUpdate() {
        activityIndicator.stopAnimating()
        companyNameLabel.text = "-"
        companySymbolLabel.text = "-"
        priceLabel.text = "-"
        priceChangeLabel.text = "-"
        priceChangeLabel.textColor = .black
        //companyImage.image = UIImage(systemName: "envelope")
        
        networkService.fetchCompanies { (stocks) in
            self.stocks = stocks
            DispatchQueue.main.async {
                self.companyPickerView.reloadAllComponents()
            }
        }
    }
        
//        networkService.fetchImage { (stocks) in
//            self.stocks = stocks
//            DispatchQueue.main.async {
//                self.imageView.image = UIImage(data: data)
//                }
        
//        networkService.requestQuote(for: selectedSymbol) { (stock) in
////            print(companySymbolLabel
    private func setupConstraint() {
        mainStocks.translatesAutoresizingMaskIntoConstraints = false
        mainStocks.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        mainStocks.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        mainStocks.heightAnchor.constraint(equalToConstant: 50).isActive = true
        mainStocks.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20 ).isActive = true
        mainStocks.textAlignment = .center
        
        companyImage.translatesAutoresizingMaskIntoConstraints = false
        companyImage.topAnchor.constraint(equalTo: mainStocks.bottomAnchor, constant: 20).isActive = true
        companyImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        companyImage.heightAnchor.constraint(equalToConstant: 60).isActive = true
        companyImage.widthAnchor.constraint(equalToConstant: 60).isActive = true
        //companyImage.backgroundColor = .red
        
        companyNameLabel.translatesAutoresizingMaskIntoConstraints = false
        companyNameLabel.topAnchor.constraint(equalTo: companyImage.topAnchor).isActive = true
        companyNameLabel.leadingAnchor.constraint(equalTo: companyImage.trailingAnchor, constant: 20).isActive = true
        companyNameLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        companyNameLabel.widthAnchor.constraint(equalToConstant: 210).isActive = true
        //companyNameLabel.backgroundColor = .orange
        
        companySymbolLabel.translatesAutoresizingMaskIntoConstraints = false
        companySymbolLabel.bottomAnchor.constraint(equalTo: companyImage.bottomAnchor).isActive = true
        companySymbolLabel.leadingAnchor.constraint(equalTo: companyNameLabel.leadingAnchor).isActive = true
        companySymbolLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        companySymbolLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
        //companySymbolLabel.backgroundColor = .yellow
        
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.topAnchor.constraint(equalTo: companyImage.topAnchor).isActive = true
        priceLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        priceLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        priceLabel.leadingAnchor.constraint(equalTo: companyNameLabel.trailingAnchor, constant: 5).isActive = true
        //priceLabel.backgroundColor = .black
        
        priceChangeLabel.translatesAutoresizingMaskIntoConstraints = false
        priceChangeLabel.bottomAnchor.constraint(equalTo: companyImage.bottomAnchor).isActive = true
        priceChangeLabel.trailingAnchor.constraint(equalTo: priceLabel.trailingAnchor).isActive = true
        priceChangeLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        priceChangeLabel.leadingAnchor.constraint(equalTo: companySymbolLabel.trailingAnchor, constant: 5).isActive = true
        //priceChangeLabel.backgroundColor = .green
    }

    
    
    private func displayStockInfo(companyName: String,
                                  companySymbol: String,
                                  price: Double,
                                  priceChange: Double) {
        activityIndicator.stopAnimating()
        companyNameLabel.text = companyName
        companySymbolLabel.text = companySymbol
        priceLabel.text = "$\(price)"
        if priceChange > 0 {
            priceChangeLabel.text = "↗ \(priceChange)$"
            priceChangeLabel.textColor = .green
        } else {
            priceChangeLabel.text = "↘ \(priceChange)$"
            priceChangeLabel.textColor = .red
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestQuoteUpdate()
        
        companyPickerView.dataSource = self
        companyPickerView.delegate = self

        activityIndicator.hidesWhenStopped = true
        
        setupConstraint()
    }
}

extension ViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stocks.count
    }
    
}

extension ViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return stocks[row].companyName
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        requestQuoteUpdate()
        activityIndicator.startAnimating()
        
        let selectedSymbol = stocks[row].symbol
        
        networkService.fetchImage(for: selectedSymbol) { (image) in
            guard let url = URL(string: image.url) else { return }
            do {
                let data = try Data(contentsOf: url)
                DispatchQueue.main.async {
                    self.companyImage.image = UIImage(data: data)
                }
            } catch {
                print(error.localizedDescription)
            }
            
            
        }
        
        networkService.requestQuote(for: selectedSymbol) { [weak self] (stock) in
            DispatchQueue.main.async {
                self?.displayStockInfo(companyName: stock.companyName, companySymbol: stock.symbol, price: stock.latestPrice, priceChange: stock.change)
            }
        }
    }
}


