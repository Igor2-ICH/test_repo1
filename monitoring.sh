1.
#!/bin/bash
# Устанавливаем пороговое значение для дискового пространства
THRESHOLD=70
# Получаем текущее использование дискового пространства в /
USAGE=$(df / | grep / | awk '{ print $5 }' | sed 's/%//g')
# Проверяем, превышает ли текущее использование установленный порог
if [ "$USAGE" -gt "$THRESHOLD" ]; then
  echo "Дисковое пространство в корневом разделе занято более $THRESHOLD%. Текущее использование: $USAGE%."
  # Находим и выводим самые большие директории
  echo "Самые большие директории:"
  du -ah / | sort -rh | head -n 10
  # Находим и выводим самые большие файлы
  echo "Самые большие файлы:"
  find / -type f -exec du -ah {} + | sort -rh | head -n 10
else
  echo "Дисковое пространство в корневом разделе занято на $USAGE%. Это меньше порогового значения $THRESHOLD%."
fi
2.
#!/bin/bash
# Версия операционной системы
os_version=$(cat /etc/os-release | grep "PRETTY_NAME" | cut -d '"' -f 2)
# Дата и время
current_date=$(date "+%Y-%m-%d")
current_time=$(date "+%H:%M:%S")
# Время работы системы
uptime_info=$(uptime -p)
# Загруженность системы
system_load=$(uptime | awk -F'[a-z]:' '{ print $2 }')
# Занятое дисковое пространство
disk_usage=$(df / | awk '{print $5}' | sed 's/%//')
# Топ процессы по использованию памяти
top_processes=$(ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head -n 6)
# Количество процессов
process_count=$(ps -ef | wc -l)
# Количество пользователей
user_count=$(who | wc -l)
# Выводим отчет
echo "Отчет о системе"
echo "Версия операционной системы: $os_version"
echo "Дата: $current_date"
echo "Время: $current_time"
echo "Время работы системы: $uptime_info"
echo "Загруженность системы: $system_load"
echo "Занятое дисковое пространство: $disk_usage"
echo "Топ процессы по использованию памяти:"
echo "$top_processes"
echo "Количество процессов: $process_count"
echo "Количество пользователей: $user_count"
3.
#!/bin/bash
# Директории для резервного копирования
backup_dirs=("/opt" "/home/ec2-user")
# Директория для хранения архивов
backup_location="/backup"
# Максимальное количество хранимых архивов
max_backup_count=3
# Создаем каталог для хранения бекапов, если он не существует
mkdir -p "$backup_location"
# Проходимся по каждой директории и создаем архив
for dir in "${backup_dirs[@]}"; do
    backup_file="$backup_location/$(basename "$dir")_backup_$(date +%Y-%m-%d).tar.gz"
    tar -czf "$backup_file" "$dir"
done
# Удаляем старые архивы, если наше задание выполняется раз в неделю, то -mtime будет 21
find "$backup_location" -maxdepth 1 -type f -name "*.tar.gz" -mtime +21 -delete
4.
#!/bin/bash
# Директория с логами
log_directory="/var/log"
# Файл для сохранения отчета
report_file="/tmp/error_report.txt"
# Шаблон для поиска ошибок
error_patterns="(error|Error|ERROR|warning|Warning|WARNING)"
# Поиск ошибок в логах и подсчет их количества
grep -E -r "$error_patterns" "$log_directory" | awk -F ':' '{print $2}' | sort | uniq -c | sort -nr > "$report_file"
# Вывод отчета в консоль
echo "Отчет о ошибках в логах:"
cat "$report_file"
# Подготовка списка наиболее частых ошибок (первые 5)
echo -e "\nНаиболее частые ошибки (первые 5):\n"
head -n 5 "$report_file"
Collapse