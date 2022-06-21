# ``Widgets/OrderDetailInfoViewController``

Детальная информация данных о посылке

## Overview

Базовый класс наследуется: [UICollectionView](https://developer.apple.com/documentation/uikit/uicollectionview/)

Кастомный [UICollectionViewLayout](https://developer.apple.com/documentation/uikit/uicollectionviewlayout/) для настройки внешнего вида секций. 
см. [UICollectionViewCompositionalLayout](https://developer.apple.com/documentation/uikit/uicollectionviewcompositionallayout/)

DataSource:
 [UICollectionViewDiffableDataSource](https://developer.apple.com/documentation/uikit/uicollectionviewdiffabledatasource/)

### Особенности реализации
Секции конфигурируются на основе ``OrderDetailInfoViewModel``. 

В частности, каждая группа конфигурируется на основе ``OrderDetailInfoViewModel/ContentGroup``- элементы во вложеном ассоциативном enumе

Для хэдера всей коллекции используется ячейка в отдельной секции. Имеет свой [NSCollectionLayoutSection](https://developer.apple.com/documentation/uikit/nscollectionlayoutsection/)

Хэдеры для секции реализованы как обычные элементы внутри секции

## Topics

### ViewModel

- ``OrderDetailInfoViewModel``
- ``OrderDetailInfoWidgetViewModelBuilder/build(order:)``
