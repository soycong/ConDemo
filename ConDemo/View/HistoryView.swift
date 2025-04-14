//
//  HistoryView.swift
//  ConDemo
//
//  Created by seohuibaek on 4/14/25.
//

import UIKit

final class HistoryView: UIView {
    
    private var adBanner: UIImageView = {
        let view: UIImageView = .init()
        
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = 14
        view.backgroundColor = .beigeGray
        
        return view
    }()
    
    private let historyLabel: UILabel = {
        let label: UILabel = .init()
        
        label.font = UIFont(name: "BricolageGrotesque-Bold", size: 26)
        label.text = "History"
        label.textColor = .label
        label.textAlignment = .left
        
        return label
    }()

    private let calenderButton: UIButton = {
        let button: UIButton = .init()

        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold)
        let image: UIImage = .init(systemName: "calendar", withConfiguration: config)!

        button.setImage(image, for: .normal)
        button.tintColor = .black

        return button
    }()
    
    private let historyTableView: UITableView = {
        let tableView: UITableView = .init()
        
        tableView.separatorStyle = .none
        
        return tableView
    }()
    
    private lazy var titleStackView: UIStackView = {
        let stackView: UIStackView = .init(arrangedSubviews: [historyLabel, calenderButton])
        
        stackView.axis = .horizontal
        stackView.spacing = 8
        
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        setupADimage()
        setUpTableView()
        configureUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupADimage() {
        adBanner.image = UIImage(named: "landingAD")
    }
    
    private func setUpTableView() {
        historyTableView.delegate = self
        historyTableView.dataSource = self
        
        historyTableView.register(HistoryCell.self, forCellReuseIdentifier: HistoryCell.id)
        
        historyTableView.backgroundColor = .white
        historyTableView.showsVerticalScrollIndicator = false
    }
    
    private func configureUI() {
        addSubview(adBanner)
        addSubview(titleStackView)
        addSubview(historyTableView)
        
        adBanner.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(96)
            make.horizontalEdges.equalToSuperview().inset(13)
            make.height.equalTo(72)
        }

        titleStackView.snp.makeConstraints { make in
            make.top.equalTo(adBanner.snp.bottom).offset(31)
            make.horizontalEdges.equalToSuperview().inset(25)
            make.height.equalTo(30)
        }
        
        historyTableView.snp.makeConstraints { make in
            make.top.equalTo(titleStackView.snp.bottom).offset(16)
            make.bottom.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(13)
        }
    }
}

extension HistoryView: UITableViewDelegate { }

extension HistoryView: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HistoryCell.id,
                                                       for: indexPath) as? HistoryCell else {
            return UITableViewCell()
        }

        cell.configure()

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 82
    }
}
