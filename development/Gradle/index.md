# Gradle
In diesem Projekt wird Gradle genutzt. Dabei handelt es sich um automatisiertes Build-Tool, das hauptsächlich für Java-basierte Projekte entwickelt wurde, aber auch die Unterstützung für andere Programmiersprachen wie Kotlin, Scala und Groovy bietet. \
Im Gegensatz zu traditionellen Build-Tools wie Ant oder Maven, verwendet Gradle eine domänenspezifische Sprache (DSL) basierend auf Groovy, um Build-Skripte zu definieren. Dies ermöglicht es Entwicklern, komplexere Build-Prozesse in einer intuitiveren und flexibleren Weise zu gestalten.

## Versionsupgrade
Der [Upgrade Guide](https://docs.gradle.org/current/userguide/upgrading_version_8.html) von Gradle ist eine umfassende Ressource, die Entwicklern bei der Migration von einer Gradle-Version zur nächsten hilft. Sie enthält detaillierte Anleitungen und Hinweise, um potenzielle Kompatibilitätsprobleme und Änderungen zu identifizieren und zu beheben. \
Die Seite listet die wichtigsten Neuerungen, Verbesserungen und Breaking Changes auf, die bei der Aktualisierung berücksichtigt werden müssen. Zudem bietet sie praktische Tipps und Best Practices, um den Upgrade-Prozess so reibungslos wie möglich zu gestalten.


Die Version kann in der [Gradle Wrapper Properties](https://git.svws-nrw.de/svws/SVWS-Server/-/blob/dev/gradle/wrapper/gradle-wrapper.properties#L3) angepasst werden. Hierfür muss die Version in `distributionUrl=https\://services.gradle.org/distributions/gradle-{version}-bin.zip` auf die gewünschte Versionsnummer geändert werden.

### Hinweis
Ein lokales `gradle build` kann Hinweise auf Probleme mit einer neuen Version geben.