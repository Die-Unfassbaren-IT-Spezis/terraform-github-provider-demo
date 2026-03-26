# Minimalbeispiel: GitHub-Repository mit Terraform erstellen

Diese Anleitung zeigt dir **in kleinen Schritten**, wie du mit Terraform über den **GitHub Provider** ein Repository anlegst.  
Zusätzlich ist alles **sauber auf mehrere Terraform-Dateien aufgeteilt**.

---

## Ziel

Am Ende hast du:

- ein kleines Terraform-Projekt
- mehrere `.tf`-Dateien statt einer einzigen großen Datei
- ein GitHub-Repository, das per Terraform erstellt wird
- die wichtigsten Terraform-Befehle einmal praktisch ausgeführt

---

## Voraussetzungen

Du brauchst:

- ein **GitHub-Konto**
- **Terraform** installiert
- einen **GitHub Personal Access Token**
- ein Terminal

---

## Projektstruktur

Lege einen neuen Ordner an, zum Beispiel:

```bash
mkdir terraform-github-demo
cd terraform-github-demo
```

Danach erstellen wir diese Dateien:

```text
terraform-github-demo/
├── provider.tf
├── variables.tf
├── terraform.tfvars
├── main.tf
├── outputs.tf
└── .gitignore
```

---

## Schritt 1: GitHub Token erstellen

Terraform muss sich bei GitHub authentifizieren.

### So geht's grob:

1. Öffne GitHub
2. Gehe in die **Developer Settings**. Die findest du, indem du auf dein User-Profil klickst und dann auf Settings und dann nach ganz unten scrollst.
3. Erstelle einen **Personal Access Token**. Gehe dabei auf "Generate new Token (classic)"
4. Gib dem Token passende Rechte für Repositories. Es reichen folgende: repo, admin:org, user, delete_repo
5. Klicke auf Generate Token
6. Speichere dir den Code ab, der dir angezeigt wird (Achtung, dieser wird wirklich nur einmal angezeigt, deswegen dringend abspeichern!)

Für dieses einfache Beispiel reicht in der Regel ein Token, das Repositories verwalten darf.

Wichtig:  
**Diesen Token niemals direkt in den Code schreiben.**

---

## Schritt 2: Umgebungsvariable setzen

Setze den Token als Umgebungsvariable.

### Linux / macOS

```bash
export GITHUB_TOKEN="dein_token_hier"
```

### Windows PowerShell

```powershell
$env:GITHUB_TOKEN="dein_token_hier"
```

Damit kann der GitHub Provider den Token verwenden, ohne dass er in einer Datei stehen muss.

---

## Schritt 3: Datei `provider.tf`

In dieser Datei definierst du Terraform selbst und den benötigten Provider.

```hcl
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }
}

provider "github" {
  # Der Token kommt aus der Umgebungsvariable GITHUB_TOKEN
}
```

### Erklärung

- `required_version`: Mindestversion für Terraform
- `required_providers`: sagt Terraform, welchen Provider es laden soll
- `provider "github"`: bindet den GitHub Provider ein

---

## Schritt 4: Datei `variables.tf`

Hier definierst du Variablen, damit das Projekt flexibler wird.

```hcl
variable "repo_name" {
  description = "Name des GitHub-Repositories"
  type        = string
  default     = "terraform-demo-repo"
}

variable "repo_description" {
  description = "Beschreibung des Repositories"
  type        = string
  default     = "Erstellt mit Terraform"
}

variable "repo_visibility" {
  description = "Sichtbarkeit des Repositories"
  type        = string
  default     = "public"
}
```

### Erklärung

Mit Variablen kannst du Werte später leicht ändern, ohne den eigentlichen Resource-Code umzuschreiben.

---

## Schritt 5: Datei `main.tf`

Hier kommt die eigentliche Ressource hinein.

```hcl
resource "github_repository" "demo" {
  name        = var.repo_name
  description = var.repo_description
  visibility  = var.repo_visibility

  auto_init = true
}
```

### Erklärung

- `github_repository`: Ressourcentyp des GitHub Providers
- `"demo"`: interner Name in Terraform
- `name`, `description`, `visibility`: Werte aus den Variablen
- `auto_init = true`: GitHub erstellt direkt ein initiales Repository, meist mit erstem Commit

---

## Schritt 6: Datei `outputs.tf`

Mit Outputs kannst du dir nach dem Anwenden wichtige Informationen ausgeben lassen.

```hcl
output "repository_name" {
  value = github_repository.demo.name
}

output "repository_url" {
  value = github_repository.demo.html_url
}
```

### Erklärung

Nach `terraform apply` zeigt Terraform dir dann zum Beispiel den Repo-Namen und die URL an.

---

## Schritt 7: Datei `terraform.tfvars`

Hier überschreibst du die Standardwerte aus `variables.tf`.

```hcl
repo_name        = "mein-kleines-terraform-repo"
repo_description = "Dieses Repo wurde per Terraform erstellt"
repo_visibility  = "public"
```

### Erklärung

Die Datei `terraform.tfvars` ist praktisch für konkrete Projektwerte.

---

## Schritt 8: Datei `.gitignore`

Falls du das Terraform-Projekt selbst in Git versionierst, sollte diese Datei nicht fehlen:

```gitignore
.terraform/
*.tfstate
*.tfstate.*
crash.log
.terraform.lock.hcl
```

### Warum?

Terraform erzeugt lokale Zustandsdateien.  
Diese sollten normalerweise **nicht einfach ins Repository committed** werden.

---

## Gesamtübersicht aller Dateien

## `provider.tf`

```hcl
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }
}

provider "github" {
}
```

## `variables.tf`

```hcl
variable "repo_name" {
  description = "Name des GitHub-Repositories"
  type        = string
  default     = "terraform-demo-repo"
}

variable "repo_description" {
  description = "Beschreibung des Repositories"
  type        = string
  default     = "Erstellt mit Terraform"
}

variable "repo_visibility" {
  description = "Sichtbarkeit des Repositories"
  type        = string
  default     = "public"
}
```

## `main.tf`

```hcl
resource "github_repository" "demo" {
  name        = var.repo_name
  description = var.repo_description
  visibility  = var.repo_visibility

  auto_init = true
}
```

## `outputs.tf`

```hcl
output "repository_name" {
  value = github_repository.demo.name
}

output "repository_url" {
  value = github_repository.demo.html_url
}
```

## `terraform.tfvars`

```hcl
repo_name        = "mein-kleines-terraform-repo"
repo_description = "Dieses Repo wurde per Terraform erstellt"
repo_visibility  = "public"
```

---

## Schritt 9: Terraform initialisieren

Jetzt lädt Terraform den GitHub Provider herunter.

```bash
terraform init
```

### Was passiert dabei?

- Terraform liest deine `.tf`-Dateien
- lädt den GitHub Provider herunter
- erstellt den Ordner `.terraform`

---

## Schritt 10: Prüfen, was erstellt werden soll

```bash
terraform plan
```

### Was passiert dabei?

Terraform zeigt dir an:

- welche Ressourcen neu erstellt werden
- welche Werte verwendet werden
- was genau bei GitHub passieren wird

Du änderst hier noch nichts wirklich.

---

## Schritt 11: Repository wirklich erstellen

```bash
terraform apply
```

Terraform zeigt dir wieder den Plan und fragt nach Bestätigung.

Bestätige mit:

```text
yes
```

Danach erstellt Terraform das Repository über die GitHub API.

---

## Schritt 12: Ergebnis im Browser prüfen

Öffne GitHub und prüfe, ob das Repository angelegt wurde.

Du solltest sehen:

- den gewünschten Repository-Namen
- die Beschreibung
- die Sichtbarkeit
- eventuell ein initialisiertes Repository

---

## Schritt 13: Änderungen testen

Ändere jetzt testweise einen Wert in `terraform.tfvars`, zum Beispiel:

```hcl
repo_description = "Beschreibung wurde geändert"
```

Dann wieder:

```bash
terraform plan
terraform apply
```

So siehst du gut, wie Terraform Änderungen erkennt und gezielt umsetzt.

---

## Schritt 14: Repository wieder löschen

Wenn du das Beispiel wieder aufräumen willst:

```bash
terraform destroy
```

Dann bestätigt Terraform wieder mit einer Abfrage.  
Nach dem Bestätigen wird das Repository gelöscht.

---

## Warum die Aufteilung in mehrere Dateien sinnvoll ist

Die Aufteilung macht Projekte übersichtlicher:

- `provider.tf` → Terraform und Provider
- `variables.tf` → Eingabewerte
- `main.tf` → eigentliche Ressourcen
- `outputs.tf` → Ausgaben
- `terraform.tfvars` → konkrete Werte für das Projekt

Gerade für Unterricht oder Einstieg ist das viel besser als eine einzige große Datei.

---

## Typischer Ablauf nochmal kurz

```bash
terraform init
terraform plan
terraform apply
terraform destroy
```

---

## Häufige Fehler

## 1. Token nicht gesetzt

Wenn `GITHUB_TOKEN` nicht gesetzt ist, kann Terraform sich nicht bei GitHub anmelden.

Prüfe im Terminal, ob die Variable gesetzt ist.

### Linux / macOS

```bash
echo $GITHUB_TOKEN
```

### Windows PowerShell

```powershell
echo $env:GITHUB_TOKEN
```

---

## 2. Repository-Name existiert schon

Wenn du denselben Namen schon auf deinem GitHub-Account hast, schlägt das Erstellen fehl.

Lösung:  
Wähle einfach einen anderen Namen in `terraform.tfvars`.

---

## 3. Falsche Berechtigungen im Token

Wenn der Token nicht genug Rechte hat, kann Terraform kein Repository anlegen.

Lösung:  
Token-Rechte prüfen und neuen Token erstellen.

---

## Erweiterungsideen

Wenn das Grundbeispiel funktioniert, kannst du es später erweitern:

- `private` statt `public`
- Topics für das Repository setzen
- ein README verwalten
- Branch Protection hinzufügen
- mehrere Repositories mit Terraform anlegen

---

## Mini-Variante für schnellen Unterrichtseinstieg

Falls du erst einmal nur das absolute Minimum zeigen willst, reichen sogar diese zwei Dateien:

### `provider.tf`

```hcl
terraform {
  required_providers {
    github = {
      source = "integrations/github"
    }
  }
}

provider "github" {}
```

### `main.tf`

```hcl
resource "github_repository" "demo" {
  name       = "terraform-kurzbeispiel"
  visibility = "public"
}
```

Danach:

```bash
terraform init
terraform apply
```

---

## Fazit

Mit diesem Beispiel hast du ein einfaches, aber realistisches Terraform-Projekt aufgebaut:

- Provider eingebunden
- Variablen ausgelagert
- Ressource definiert
- Outputs ergänzt
- Werte in `terraform.tfvars` gepflegt
- Repository per Terraform erstellt und wieder gelöscht

Das ist ein sehr guter Einstieg, um später komplexere Terraform-Projekte zu verstehen.

