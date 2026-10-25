<p align="center"><img src="docs/icon.png" width="128" alt="Feilo icon"></p>

<h1 align="center">Feilo</h1>

<p align="center">
English · <a href="README.de.md">Deutsch</a>
</p>

This repository hosts the signed release builds of Feilo and its install
script. The source code is private.

Select text in any app, press **⌃⌥R**, and Feilo replaces it with a polished
version: grammar, spelling and punctuation fixed, sentences smoothed, meaning
kept. It works in mail, chat, browsers, editors and office apps, and it keeps
bold, italics and links where they were.

*Feilo* comes from German *feilen*: to file something until it is smooth.

![Feilo settings](docs/screenshots/general.png)

## Install

With [Homebrew](https://brew.sh):

```bash
brew install --cask xiaoyuhen/tap/feilo
```

Or with one line in Terminal:

```bash
curl -fsSL https://raw.githubusercontent.com/xiaoyuhen/feilo-releases/main/install.sh | bash
```

Or download `Feilo-x.y.z.zip` from
[Releases](https://github.com/xiaoyuhen/feilo-releases/releases), unzip it and
drag `Feilo.app` to Applications. Feilo is signed but **not notarized**, so a
browser download is blocked the first time. Either run
`xattr -dr com.apple.quarantine /Applications/Feilo.app` once, or open it,
dismiss the warning and press **Open Anyway** in System Settings → Privacy &
Security. Homebrew and the install script handle this for you.

Requires macOS 14 (Sonoma) or later, on Apple silicon or Intel.

### First launch

1. Feilo appears in the menu bar and opens its settings.
2. macOS asks for **Accessibility** access. Allow it in System Settings →
   Privacy & Security → Accessibility. Feilo needs it to copy the selected
   text and paste the result back. The permission stays across updates.
3. Feilo opens at login from now on. You can turn that off in Settings →
   General.

## Using it

| | |
|---|---|
| **Polish** | Select text, press **⌃⌥R**. A small "Polish…" bubble appears near the pointer; when it disappears the text has been replaced. Press the shortcut again to cancel. |
| **Your own actions** | Settings → Actions: add instructions such as "more formal", "shorter" or "translate only", each with its own shortcut. They also appear in the menu bar menu. |
| **Language** | Rewrite in **English** (default) or **German**. Text in any other language is translated as it is rewritten. |
| **Level** | Keep the result at a CEFR level: A1, A2, B1, B2, **C1** (default), C2, or no limit. Feilo tells the model which vocabulary and sentence structures that level allows. |
| **Rich text** | Bold, italics, underline, links, fonts and colours stay on the right words, even when a sentence is reordered or translated. |

Your clipboard is put back as it was after every rewrite. If you switch apps
while a rewrite is loading, nothing is pasted.

## Models

Choose a provider in Settings → Model:

| Provider | Key |
|---|---|
| **Free (built-in)** | None. 25 rewrites a day, up to 2,000 characters each, on an open model (Mistral Small 3.1) hosted on Cloudflare Workers AI. |
| OpenAI, Anthropic, Google Gemini, DeepSeek, Groq, OpenRouter, Mistral | Your API key. Gemini, Groq and OpenRouter have free tiers of their own. |
| Ollama | None; runs locally, nothing leaves your Mac. |
| Custom | Any OpenAI-compatible endpoint (LM Studio, a company proxy, …). |

The model name is editable, and **Test Connection** checks the key and model
before your first real rewrite. Keys are stored in
`~/Library/Application Support/Feilo/credentials.json`, readable only by your
user account, and sent only to the provider they belong to.

![Model settings](docs/screenshots/model.png)

![Actions](docs/screenshots/actions.png)

## Updates

Feilo checks for a new version once a day (Settings → About → *Check for
updates automatically*), or whenever you choose **Check for Updates…** in the
menu. An update is downloaded from GitHub and installed only if its checksum
matches and it is signed with Feilo's own certificate. Then Feilo relaunches.
Homebrew users can also run `brew upgrade --cask feilo`.

## Privacy

Selected text goes only to the provider you chose. With your own key it goes
straight from your Mac to that provider; on the free tier it passes through
Feilo's Cloudflare Worker, which does not store it.

Feilo also sends anonymous daily counts (launches, and rewrites per provider
type). The free tier counts requests per install (a random UUID) and per
network (a SHA-256 hash of the IP address mixed with a secret that changes
daily, never the IP itself) to enforce its daily limit. These counters are
deleted after two days. The anonymous counts never include text, prompts, keys,
model names or app names. You can turn them off in Settings → About, or by
setting `FEILO_NO_TELEMETRY=1`.
