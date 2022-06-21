# ``DeliveryStatus/DeliveryStatusViewModel``

Модель для отображения групп статусов в детальной информации о заказе 

## Overview

Запутанность логики породила идею написания докумментации. 
Преобразование ...

Структура включает в себя все связанные viewModels: 
- ``Title-swift.struct`` 
- ``Step``
- ``Card-swift.struct``


``Group-swift.enum`` и ``Stage`` передаются во внутренние модели для определения стилей для группы. Инициализация производится с помощью ``StatusWidgetViewModelBuilder``

## Topics

### ViewModels

- ``DeliveryStatusViewModel``
- ``DeliveryStatusViewModel/Title-swift.struct``
- ``DeliveryStatusViewModel/Step``
- ``DeliveryStatusViewModel/Card-swift.struct``

###  Enums

- ``DeliveryStatusViewModel/Group-swift.enum``
- ``DeliveryStatusViewModel/Stage``

