//
//  HistoryView.swift
//  ConDemo
//
//  Created by seohuibaek on 4/14/25.
//

import UIKit

protocol HistoryViewDelegate: AnyObject {
    func didSelectHistory(at index: Int)
    func deleteHistory(at index: Int)
}

final class HistoryView: UIView {
    // MARK: - Properties

    weak var delegate: HistoryViewDelegate?
    private var analysis: [Analysis] = []

    private(set) var calenderButton: UIButton = {
        let button: UIButton = .init()

        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .light)
        let image: UIImage = .init(systemName: "calendar", withConfiguration: config)!

        button.setImage(image, for: .normal)
        button.tintColor = .label

        return button
    }()

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

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .baseBackground

        setupADimage()
        setUpTableView()
        configureUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Functions
    
    func updateData(with analyses: [Analysis]) {
        self.analysis = analyses
        historyTableView.reloadData()
    }

    private func setupADimage() {
        adBanner.image = UIImage(named: "landingAD")
    }

    private func setUpTableView() {
        historyTableView.delegate = self
        historyTableView.dataSource = self

        historyTableView.register(HistoryCell.self, forCellReuseIdentifier: HistoryCell.id)

        historyTableView.backgroundColor = .baseBackground
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

extension HistoryView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        delegate?.didSelectHistory(at: indexPath.row)
    }
}

extension HistoryView: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        analysis.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HistoryCell.id,
                                                       for: indexPath) as? HistoryCell else {
            return UITableViewCell()
        }
        
        let analysis = analysis[indexPath.row]
        var imageName = "level\(analysis.level)"
        
        // ViewController에서 설정 정보 전달
        if analysis.level == 0 {
            imageName = "level1"
        }
        
        let dateFormatter: DateFormatter = .init()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        
        guard let date = analysis.date,  let title = analysis.title else { return cell }
        let dateText = dateFormatter.string(from: date)
        let titleText = formatTitle(analysis.title, level: analysis.level)
        
        cell.configure(imageName: imageName, dateText: dateText, titleText: titleText)
        
        return cell
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        82
    }

    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
        -> UISwipeActionsConfiguration? {
        let action: UIContextualAction = .init(style: .destructive,
                                               title: nil) { _, _, completion in
            tableView.deleteRows(at: [indexPath], with: .automatic)
            completion(true)
        }

        action.backgroundColor = .pointBlue
        action.title = "Clear"

        let configuration: UISwipeActionsConfiguration = .init(actions: [action])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
}

extension HistoryView {
    func formatTitle(_ title: String?, level: Int32) -> String {
        guard let title = title, !title.isEmpty else {
            return "대화 분석 | 매운맛 \(level)"
        }
        
        
        
        switch level {
//        case 0 ... 4:
//            return "\(title) | 순한맛 \(level)단계"
//        case 5 ... 9:
//            return "\(title) | 순한맛 \(level)단계"
//        default:
//            return "분석이 어렵습니다."
        case 0 ... 1:
            return "\(title) | 순한맛 \(1)단계"
        case 2 ... 5:
            return "\(title) | 순한맛 \(level)단계"
        case 6 ... 10:
            return "\(title) | 매운맛 \(level)단계"
        default:
            return "\(title) | 분석이 어렵습니다. Level: \(level)"
        }
    }
}
