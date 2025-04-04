#!/bin/bash
echo "🔨 Сборка проекта..."
swift build

if [ $? -eq 0 ]; then
    echo ""
    echo "📦 Копирование исполняемого файла в корневую папку..."
    cp .build/debug/ContactsApp ./ContactsMannager
    echo "✅ Сборка успешно завершена!"
    echo ""
    echo "✨ Запустите приложение командой: ./ContactsMannager"
else
    echo "❌ Ошибка при сборке проекта"
    exit 1
fi 