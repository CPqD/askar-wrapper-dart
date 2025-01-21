# import_so_libaskar

A new Flutter project that imports aries library

## Rodar testes

```
flutter test
```

## Atualiza Libs

```
flutter pub get
```

## Gerar `libcallback.so`:

```bash
g++ -shared -o android/app/src/main/libaries_askar/askar_callbacks.so -fPIC etc/askar_callbacks.cpp
```
