# ``Widgets/OrderDetailInfoViewModel``

Модель для экрана "Детальная информация данных о посылке" ``OrderDetailInfoViewController``

## Overview

Модели настледуются от [Hashable](https://developer.apple.com/documentation/swift/hashable/) для использования dataSource [UICollectionViewDiffableDataSource](https://developer.apple.com/documentation/uikit/uicollectionviewdiffabledatasource/)

## Topics

### Creating

- ``StatusWidgetViewModelBuilder/buildStatuses(_:)``

### Includes ViewModels

- ``OrderDetailInfoViewModel/ContentGroup``
- ``OrderDetailInfoViewModel/HeaderItem``
- ``OrderDetailInfoViewModel/OrderActor``
- ``OrderDetailInfoViewModel/AdditionalService``
- ``OrderDetailInfoViewModel/ParcelInfo``
