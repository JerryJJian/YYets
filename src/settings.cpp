#include "settings.h"

Settings::Settings(QObject *parent)
    : QSettings("config.ini", QSettings::IniFormat, parent)
{
    m_theme = value("theme").toInt();
}

int Settings::theme() const
{
    return m_theme;
}

void Settings::setTheme(int theme)
{
    if (m_theme == theme)
        return ;

    m_theme = theme;
    setValue("theme", static_cast<int>(m_theme));
    emit themeChanged(m_theme);
}
