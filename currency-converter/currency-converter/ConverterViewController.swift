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
      static let alertTitle = "Currency Converted"
      static let alertMessageFail = "You cannot convert the same currency. Please try again."
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
   
   private func hidePickerView() {
      pickerContainerView.isHidden = true
   }
   
   private func showPickerView() {
      pickerContainerView.isHidden = false
   }
   
   private func reloadTableRow() {
      
      switch viewModel.pickerCurrency {
      case .sell:
         DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
         }
      default:
         DispatchQueue.main.async { [weak self] in
            let index = IndexPath(row: 0, section: 1)
            self?.tableView.reloadRows(at: [index], with: .automatic)
         }
      }
   }
   
   private func showAlertMessage(_ message: String) {
      let alert = UIAlertController(title: Constants.alertTitle,
                                    message: message,
                                    preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "Done",
                                    style: .cancel, handler: nil))
      present(alert, animated: true)
   }
   
   // MARK: - IBActions
   
   @IBAction private func didTapSubmit(_ sender: Any) {
      view.endEditing(true)
      pickerContainerView.isHidden = true
      
      viewModel.convertSelectedCurrencyExchange()
   }
   
   @IBAction private func didTapDismiss(_ sender: Any) {
      hidePickerView()
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
      default:
         viewModel.didUpdatePickerCurrencyReceive(row: row)
      }
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
   func currencyViewModelDidTapTextField(_ viewModel: CurrencyViewModel) {
      hidePickerView()
   }
   
   func currencyViewModelNeedsReloadData(_ viewModel: CurrencyViewModel) {
      reloadTableRow()
   }
   
   func currencyViewModelDidSubmitCurrencyExchange(_ viewModel: CurrencyViewModel, message: String) {
      showAlertMessage(message)
   }
   
   func currencyViewModelDidTapCurrencyPicker(_ viewModel: CurrencyViewModel, row: Int) {
      pickerView.selectRow(row, inComponent: 0, animated: true)
      view.endEditing(true)
      showPickerView()
   }
   
   func currencyViewModelDidUpdateCurrencyPicker(_ viewModel: CurrencyViewModel, pickerCurrency: PickerCurrency) {
      reloadTableRow()
   }
   
   func currencyViewModelDidTapCurrencyPicker(_ viewModel: CurrencyViewModel) {
      showPickerView()
   }
}
