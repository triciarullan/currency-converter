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

enum TransactionType {
   case none
   case success
   case error
}

class ConverterViewController: UIViewController {
   
   private struct Constants {
      static let currencyRowHeight: CGFloat = 60
      static let collectionViewHeight: CGFloat = 230
      static let cornerRadius: CGFloat = 5
      static let vcTitleFont: UIFont = UIFont(name: "Charter-Bold", size: 16)!
      static let screenHeight: CGFloat = UIScreen.main.bounds.height
   }
   
   @IBOutlet private weak var collectionView: UICollectionView!
   @IBOutlet private weak var tableView: UITableView!
   @IBOutlet private weak var submitBtn: UIButton!
   @IBOutlet private weak var pickerView: UIPickerView!
   @IBOutlet private weak var pickerContainerView: UIView!
   
   var viewModel: CurrencyViewModel!
   var collectionViewModel: CurrencyBalanceCollectionViewModel!
   
   private var transactionType: TransactionType = .none
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      configureViews()
      setupViewModel()
   }
   
   private func setupViewModel() {
      collectionViewModel = CurrencyBalanceCollectionViewModel()
      collectionViewModel.delegate = self
      
      viewModel = CurrencyViewModel()
      viewModel.delegate = self
      viewModel.getCurrencyExchangeFromAPI()
      viewModel.recordModel = collectionViewModel.recordCurrency
   }

   private func configureTableView() {
      tableView.register(R.nib.converterSellTableViewCell)
      tableView.register(R.nib.converterReceiveTableViewCell)
   }
   
   private func configureCollectionView() {
      collectionView.register(R.nib.currencyBalanceCollectionViewCell)
   }
   
   private func configureViews() {
      title = R.string.localizable.currencyConverter()
      navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: Constants.vcTitleFont]
      submitBtn.layer.cornerRadius = Constants.cornerRadius
   
      configureTableView()
      configureCollectionView()
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
      let alert = UIAlertController(title: R.string.localizable.currencyConverted(),
                                    message: message,
                                    preferredStyle: .alert)
      
      var title = R.string.localizable.done()
      var style: UIAlertAction.Style = .default
      switch transactionType {
      case .error:
         title = R.string.localizable.cancel()
         style = .cancel
      default: break
      }
      
      alert.addAction(UIAlertAction(title: title,
                                    style: style, handler: nil))
      present(alert, animated: true)
   }
   
   // MARK: - IBActions
   
   @IBAction private func didTapSubmit(_ sender: Any) {
      view.endEditing(true)
      pickerContainerView.isHidden = true
      viewModel.submitSelectedCurrencyExchanage()
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
      return Constants.currencyRowHeight
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
   func currencyViewModelDidExchangeCurrencySuccess(_ viewModel: CurrencyViewModel, currency: Currency, transactionCount: Int, message: String) {
      collectionViewModel.recordCurrency = currency
      collectionViewModel.transactionCount = transactionCount
      
      transactionType = .success
      showAlertMessage(message)
   }
   
   func currencyViewModelDidExchangeCurrencyFail(_ viewModel: CurrencyViewModel, message: String) {
      transactionType = .error
      showAlertMessage(message)
   }
   
   func currencyViewModelDidTapTextField(_ viewModel: CurrencyViewModel) {
      hidePickerView()
   }
   
   func currencyViewModelNeedsReloadData(_ viewModel: CurrencyViewModel) {
      reloadTableRow()
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

extension ConverterViewController: CurrencyBalanceCollectionViewModelDelegate {
   func currencyBalanceCollectionViewModelNeedsReload(_ viewModel: CurrencyBalanceCollectionViewModel) {
      DispatchQueue.main.async { [weak self] in
         self?.collectionView.reloadData()
      }
   }
   
   func currencyBalanceCollectionViewModelDidUpdate(viewModel model: CurrencyBalanceCollectionViewModel, recordCurrency: Currency) {
      viewModel.recordModel = recordCurrency
   }
}

// MARK: - UICollectionViewDataSource

extension ConverterViewController: UICollectionViewDataSource {
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return collectionViewModel.sectionModels[section].items.count
   }
   
   func numberOfSections(in collectionView: UICollectionView) -> Int {
      return collectionViewModel.sectionModels.count
   }
   
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      let itemModel = collectionViewModel.itemModel(at: indexPath)
      
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: itemModel.reuseIdentifier, for: indexPath)
      if let cell = cell as? CurrencyBalanceItemModelBindableType {
         cell.setItemModel(itemModel)
      }
      
      return cell
   }
   
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ConverterViewController: UICollectionViewDelegateFlowLayout {
   func collectionView(_ collectionView: UICollectionView,
                       layout collectionViewLayout: UICollectionViewLayout,
                       sizeForItemAt indexPath: IndexPath) -> CGSize {
      
      let width = collectionView.frame.size.width / 3
      return CGSize(width: width, height: Constants.collectionViewHeight)
   }
}
