//
//  ViewController.swift
//  currency-converter
//
//  Created by Tric Rullan on 1/7/20.
//  Copyright © 2020 Tric. All rights reserved.
//

import UIKit
import SnapKit
import Foundation

class ConverterViewController: UIViewController {
   
   private struct Constants {
      static let trackCellRowHeight: CGFloat = 60
      static let screenHeight: CGFloat = UIScreen.main.bounds.height
   }
   
   @IBOutlet private weak var collectionView: UICollectionView!
   @IBOutlet private weak var tableView: UITableView!
   @IBOutlet private weak var submitBtn: UIButton!
   @IBOutlet private weak var pickerView: UIPickerView!
   @IBOutlet private weak var pickerContainerView: UIView!
   
   var viewModel: CurrencyViewModel!
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      configureTableView()
      setupViewModel()
      configureViews()
   }

   private func configureTableView() {
      tableView.register(R.nib.converterSellTableViewCell)
      tableView.register(R.nib.converterReceiveTableViewCell)
   }
   
   private func setupViewModel() {
      viewModel = CurrencyViewModel()
      viewModel.delegate = self
      viewModel.getCurrencyExchangeFromAPI()
   }
   
   private func configureViews() {
      submitBtn.layer.cornerRadius = submitBtn.frame.height / 2
      
      configurePickerView()
   }
   
   private func configurePickerView() {
      
   }
   
   private func dismissPickerView() {
      pickerContainerView.isHidden = true
   }
   
   private func showPickerView() {
      pickerContainerView.isHidden = false
      
//      UIView.animate(withDuration: 1.0, animations: {
//         self.pickerContainerView.snp.makeConstraints{ maker in
//            maker.height.equalTo(200)
//         }
//      }, completion: nil)
   }
   
   // MARK: - IBActions
   
   @IBAction func didTapDismiss(_ sender: Any) {
      dismissPickerView()
   }

}

// MARK: - UITableViewDataSource

extension ConverterViewController: UITableViewDataSource {
   
   func numberOfSections(in tableView: UITableView) -> Int {
      return viewModel.sectionModels.count
   }
   
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return viewModel.sectionModels[section].items.count
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let itemModel = viewModel.itemModel(at: indexPath)
      
      let cell = tableView.dequeueReusableCell(withIdentifier: itemModel.reuseIdentifier, for: indexPath)
      if let cell = cell as? CurrencyItemModelBindableType {
         cell.setItemModel(itemModel)
      }
      
      return cell
   }
}

// MARK: - UITableViewDelegate

extension ConverterViewController: UITableViewDelegate {
   
   func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
      return .leastNormalMagnitude
   }
   
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return Constants.trackCellRowHeight
   }
   
   func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
      return .leastNormalMagnitude
   }
}

// MARK: - UIPickerViewDelegate

extension ConverterViewController: UIPickerViewDelegate {
   
   func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
      return viewModel.pickerCurrencyData[row]
   }
   
   func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
      
      switch viewModel.pickerCurrency {
      case .sell:
         viewModel.didUpdatePickerCurrencySell(row: row)
      case .receive:
         viewModel.didUpdatePickerCurrencyReceive(row: row)
      }
     
      tableView.reloadData()
   }
   
}

// MARK: - UIPickerViewDataSource

extension ConverterViewController: UIPickerViewDataSource {
   
   func numberOfComponents(in pickerView: UIPickerView) -> Int {
      return 1
   }
   
   func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
      return viewModel.pickerCurrencyData.count
   }
}

// MARK: - CurrencyViewModelDelegate

extension ConverterViewController: CurrencyViewModelDelegate {
   func currencyViewModelDidTapCurrencyPicker(_: CurrencyViewModel, row: Int) {
      pickerView.selectRow(row, inComponent: 0, animated: true)
      view.endEditing(true)
      showPickerView()
   }
   
   func currencyViewModelDidUpdateCurrencyPicker(_: CurrencyViewModel, pickerCurrency: PickerCurrency) {    
      DispatchQueue.main.async { [weak self] in
         self?.tableView.reloadData()
      }
   }
   
   func currencyViewModelDidTapCurrencyPicker( _ : CurrencyViewModel) {
      showPickerView()
   }
}
