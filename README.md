# my_meal

我的饭

## 设置项目图标
1. 替换`assets/icon/icon.jpg`下的文件或修改`flutter_launcher_icons.yaml`中的icon地址
2. 运行以下命令
```shell
dart run flutter_launcher_icons
```

## 注意事项

### 要在部署应用程序时禁用`AndroidManifest.xml`Impeller，请在项目文件的标签下添加以下设置 `<application>`

android项目已关闭Impeller

```xml
<meta-data
android:name="io.flutter.embedding.android.EnableImpeller"
android:value="false" />
```