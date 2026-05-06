# dYdX Digital — Private Plugin Marketplace

Internal plugin marketplace for the dYdX Digital team. Subscribe once, get every plugin and update we publish.

## What's in here

| Plugin | Purpose | Version |
|---|---|---|
| [`dydx-delivery`](./dydx-delivery/) | Stage-gated client delivery pipeline (discovery → SOW → functional spec → technical spec → test sheet → execution) | 0.1.0 |

More plugins will be added over time (monitoring, drift detection, handover packs, etc.). Updates land here.

## How to install

### One-time setup per teammate

In Cowork, open the command palette and run:

```
/plugin marketplace add https://github.com/SonofJay13/dydx-project-workflow
```

Then install whichever plugins you need:

```
/plugin install dydx-delivery
```

### Getting updates

When a new version is published:

```
/plugin update dydx-delivery
```

Or update everything from this marketplace:

```
/plugin update --marketplace dydx-digital
```

## How to publish a new plugin or version

### New plugin

1. Build the plugin in the `outputs/` of a Cowork session (or locally)
2. Copy the plugin directory into this repo at the root: `<plugin-name>/`
3. Add an entry to `.claude-plugin/marketplace.json` under `plugins:`
4. Commit and push

### Update an existing plugin

1. Bump `version` in `<plugin-name>/.claude-plugin/plugin.json` (semver)
2. Bump the matching `version` in `.claude-plugin/marketplace.json`
3. Commit with a clear message: `feat(dydx-delivery): add refine-<skill> counterparts`
4. Push

Teammates will see the update on their next `/plugin update`.

## Repo layout

```
dydx-digital-plugins/
├── .claude-plugin/
│   └── marketplace.json          ← marketplace manifest
├── dydx-delivery/                ← one folder per plugin
│   ├── .claude-plugin/plugin.json
│   ├── skills/
│   ├── README.md
│   └── ...
└── README.md                     ← this file
```

## Access

This is a **private repo**. Access controlled via the `dYdX Digital` GitHub org. New teammates: ask Jason for an invite.

## Versioning convention

- Patch (0.1.0 → 0.1.1): bug fixes, doc updates, no behaviour change
- Minor (0.1.0 → 0.2.0): new skill, new capability, backwards-compatible
- Major (0.1.0 → 1.0.0): breaking change to skill names, output paths, or pipeline contract

## Maintainer

Jason Blignaut — jasonmichaelb@gmail.com
