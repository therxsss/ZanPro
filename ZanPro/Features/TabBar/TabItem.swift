enum TabItem: Int {
    case main
    case search
    case appeal
    case menu
    
    var icon: String {
        switch self {
        case .menu: return "menu24"
        case .main: return "home24"
        case .search: return "search24"
        case .appeal: return "appealsplus24"
        }
    }
    
    var activeIcon: String {
        switch self {
        case .menu: return "close24"
        case .main: return "home24"
        case .search: return "search24"
        case .appeal: return "appealsplus24"
        }
    }
    
    var systemName: String {
        switch self {
        case .menu: return "line.3.horizontal"
        case .main: return "house"
        case .search: return "magnifyingglass"
        case .appeal: return "bubble.left"
        }
    }
    
    var title: String {
        switch self {
        case .menu: return "Меню"
        case .main: return "Главная"
        case .search: return "Поиск"
        case .appeal: return "Обращение"
        }
    }
}
