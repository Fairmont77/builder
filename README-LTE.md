# OpenIPC Builder Fork - LTE Support

Цей fork OpenIPC builder оптимізований для збірки прошивок з LTE підтримкою.

## Швидкий старт в GitHub Codespaces

1. Натисніть кнопку "Code" → "Codespaces" → "Create codespace"
2. Чекайте завершення ініціалізації (встановлення залежностей)
3. В терміналі виконайте:

```bash
# Збірка для SSC30KQ з Huawei E3372h LTE модемом (✅ ПРОТЕСТОВАНО)
./builder.sh ssc30kq_lite_lte-e3372h

# Збірка для Vixand IPH-5-4G (EC200N LTE модем)
./builder.sh gk7205v200_lite_vixand-iph-5-4g

# Або для XG521 (EC800E LTE модем)
./builder.sh gk7202v300_lite_xg521
```

## Підтримувані LTE пристрої

- **ssc30kq_lite_lte-e3372h**: SSC30KQ з Huawei E3372h USB LTE модемом ✅
- **gk7205v200_lite_vixand-iph-5-4g**: Vixand IPH-5-4G з EC200N модемом
- **gk7202v300_lite_xg521**: XG521 з EC800E модемом

## Результат збірки

Готові прошивки будуть в директорії `archive/DEVICE_NAME/TIMESTAMP/`:
- `rootfs.squashfs.DEVICE` - кореневаа файлова система
- `uImage.DEVICE` - ядро Linux
- `openipc.DEVICE.tgz` - повний пакет прошивки

## Локальна збірка в Docker

```bash
docker build -t openipc-builder .
docker run --platform linux/amd64 -it --rm -v "$(pwd)":/workspace openipc-builder
./builder.sh gk7205v200_lite_vixand-iph-5-4g
```
