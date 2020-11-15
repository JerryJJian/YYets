#pragma once

#include <QtCore/QSettings>
#include <QtCore/qglobal.h>

class Settings : public QSettings
{
    Q_OBJECT
    Q_PROPERTY(int theme READ theme WRITE setTheme NOTIFY themeChanged)
public:
    explicit Settings(QObject *parent = nullptr);

    enum Theme
    {
        Light = 0,
        Dark
    };
    Q_ENUM(Theme)

    int theme() const;

    enum FontSize {
        TagFontSize = 0,
        TextFontSize,
        TitleFontSize
    };
    Q_ENUM(FontSize)

signals:
    void themeChanged(int theme);

public slots:
    void setTheme(int theme);

private:
    int m_theme;

};

