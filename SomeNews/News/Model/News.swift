import Foundation
import CoreData

struct News {
    var author: String
    var title: String
    var text: String
    var urlString: String
    
    init() {
        author = ""
        title = ""
        text = ""
        urlString = ""
    }
    
    init(author: String, title: String, text: String, urlString: String) {
        self.author = author
        self.title = title
        self.text = text
        self.urlString = urlString
    }
}

extension News: Equatable {
    static func ==(left: News, right: News) -> Bool { // 1
        if (left.author != right.author) {
            return false
        }
        if (left.title != right.title) {
            return false
        }
        if (left.text != right.text) {
            return false
        }
        if (left.urlString != right.urlString) {
            return false
        }
        return true
    }
}

func CoreDataToNews(entity: NewEntity) -> News {
    return News(author: entity.author ?? "None", title: entity.title ?? "None", text: entity.text ?? "None", urlString: entity.urlString ?? "")
}

func CoreDataToNews(entity: AddNewsEntity) -> News {
    return News(author: entity.author ?? "None", title: entity.title ?? "None", text: entity.text ?? "None", urlString: entity.urlString ?? "")
}

func CoreDataToNews(entity: FavouriteNewsEntity) -> News {
    return News(author: entity.author ?? "None", title: entity.title ?? "None", text: entity.text ?? "None", urlString: entity.urlString ?? "")
}

let coreDataNews: [News] = [News(author: "timonin",
                                 title: "В России зафиксировали рекордное число смертей от COVID-19 за сутки",
                                 text: "За минувшие сутки в России от коронавирусной инфекции умерли 613 человек, следует из сообщения оперативного штаба. С начала распространения коронавируса число смертельных случаев достигло 45 893.",
                                 urlString: "https://s0.rbk.ru/v6_top_pics/resized/1180xH/media/img/8/35/756076739679358.jpg"),
                            News(author: "timonin",
                                                             title: "Власти обвинили частные клиники в репродукции детей для одиноких мужчин",
                                                             text: "Росздравнадзор нашел нарушения предоставления услуг репродуктивных технологий в крупных московских клиниках. Заказчиками были одинокие мужчины-иностранцы. Юристы объясняют ситуацию пробелами в законе и борьбой с однополыми браками",
                                                             urlString: "https://s0.rbk.ru/v6_top_pics/resized/1180xH/media/img/6/92/756075257589926.jpg"),
                            News(author: "timonin",
                                                             title: "Санта на удаленке: мир готовится к Новому году в пандемию",
                                                             text: "Новый, 2021-й год человечество готовится встречать в условиях пандемии. В европейских странах все еще действуют ограничения, введенные на фоне второй волны заболеваемости, в российских регионах и городах заранее ввели ограничения на новогодние мероприятия.",
                                                             urlString: "https://s0.rbk.ru/v6_top_pics/resized/590xH/media/img/6/26/756073301434266.jpg"),
                            News(author: "timonin",
                                                             title: "Правительство продлило выдачу бесплатных лекарств больным COVID-19",
                                                             text: "Для лечения пациентов с COVID-19 Минздрав одобрил шесть препаратов: фавипиравир, гидроксихлорохин, азитромицин (в сочетании с гидроксихлорохином), препараты интерферона-альфа, а также ремдесивира, умифеновира.",
                                                             urlString: "https://cdn25.img.ria.ru/images/07e4/09/17/1577671151_0:100:3463:2048_1600x0_80_0_0_64cf6d8b63d6df45eafe896133e50785.jpg"),
                            News(author: "timonin",
                                                             title: "Почему народ должен отвечать за своих чиновников",
                                                             text: "Отношение к чиновникам в обществе по-прежнему очень плохое. Последний социологический опрос ФОМ дал уже привычные цифры, главная из которых касается даже не личного мнения, а представления опрошенных о мнении общества в целом.",
                                                             urlString: "https://cdn23.img.ria.ru/images/07e4/0c/04/1587741784_0:137:3076:1867_1600x0_80_0_0_94b1ee788c5167beac9cede58d1a6718.jpg"),
                            News(author: "timonin",
                                                             title: "Счетная палата предложила варианты улучшения налога для самозанятых",
                                                             text: "Число легальных самозанятых в России приблизилось к 1,5 млн человек. Счетная палата видит в новом налоговом режиме потенциал для вывода предпринимателей из тени, но для этого, по мнению аудиторов, нужны дополнительные стимулы",
                                                             urlString: "https://s0.rbk.ru/v6_top_pics/resized/1180xH/media/img/4/70/756075209377704.jpg"),]

func coreDataAdaptNews(news: AddNewsEntity) -> News {
    let adapted = News(author: news.author ?? "",
                       title: news.title ?? "",
                       text: news.text ?? "",
                       urlString: news.urlString ?? "")
    return adapted
}

func coreDataAdaptNews(news: FavouriteNewsEntity) -> News {
    let adapted = News(author: news.author ?? "",
                       title: news.title ?? "",
                       text: news.text ?? "",
                       urlString: news.urlString ?? "")
    return adapted
}

func coreDataAdaptNews(news: NewEntity) -> News {
    let adapted = News(author: news.author ?? "",
                       title: news.title ?? "",
                       text: news.text ?? "",
                       urlString: news.urlString ?? "")
    return adapted
}



let mysteryNews: [News] = [News(author: "timonin",
                                title: "Собака чуть не застрелила хозяина",
                                text: "Вероятность получить пулю от лап собственной собаки фантастически мала. Однако одному счастливчику из Техаса все-таки повезло.",
                                urlString: "https://www.marketmatters.com.au/news/wp-content/uploads/2019/07/question1.jpg"),
                           News(author: "timonin",
                                                           title: "Айпады вместо болельщиков",
                                                           text: "На протяжении многих лет между Главной лигой бейсбола (MLB) и Apple действует соглашение, согласно которому у каждой команды есть свой iPad Pro. Девайсы используются для анализа матчей и помогают тренерам вырабатывать правильную стратегию. А на время пандемии Covid-19, MLB нашла новое применение планшетам из Купертино.",
                                                           urlString: "https://avatars.mds.yandex.net/get-dialogs/998463/b814f3272cf8c7e10dfb/orig"),
                           News(author: "timonin",
                                                           title: "Мошенники продавали «лампу Аладдина»",
                                                           text: "Врач из Индии обязался заплатить мошенникам 200000 долларов за «лампу Аладдина». Его убедили, что в лампе живет джин.",
                                                           urlString: "https://www.clipartmax.com/png/full/35-353659_question-mark-png-green-question-mark-transparent.png")]
