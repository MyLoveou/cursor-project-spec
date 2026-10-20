# Scan Report

- Root: `D:\Project\SourceManager`
- Time: 2026-10-20 23:14:32
- Scanners: 3

## Summary

| Severity | Count |
|----------|-------|
| HIGH | 1 |
| MEDIUM | 16 |
| LOW | 2 |

## Violations

| Severity | Rule | Location | Message |
|----------|------|----------|---------|
| HIGH | no-console | apps\desktop\src\main\infrastructure\persistence\migrations\007_add_content_hash_unique.ts:16 | console debug output |
| MEDIUM | no-impl-in-pages | apps\desktop\src\renderer\views\AlbumView.vue:155 | Page file implements function 'handleReorganize' (20 lines) - move to service/hook |
| MEDIUM | no-impl-in-pages | apps\desktop\src\renderer\views\AlbumView.vue:204 | Page file implements function 'initSortable' (17 lines) - move to service/hook |
| MEDIUM | no-impl-in-pages | apps\desktop\src\renderer\views\AlbumView.vue:221 | Page file implements function 'selectResource' (11 lines) - move to service/hook |
| MEDIUM | no-impl-in-pages | apps\desktop\src\renderer\views\AlbumView.vue:273 | Page file implements function 'handleContextAction' (19 lines) - move to service/hook |
| MEDIUM | no-impl-in-pages | apps\desktop\src\renderer\views\ImageLibrary.vue:177 | Page file implements function 'handleReorganize' (20 lines) - move to service/hook |
| MEDIUM | no-impl-in-pages | apps\desktop\src\renderer\views\ImageLibrary.vue:299 | Page file implements function 'handleSeriesMetaUpdate' (11 lines) - move to service/hook |
| MEDIUM | no-impl-in-pages | apps\desktop\src\renderer\views\ImageLibrary.vue:320 | Page file implements function 'handleKeydown' (11 lines) - move to service/hook |
| MEDIUM | no-impl-in-pages | apps\desktop\src\renderer\views\ImageLibrary.vue:331 | Page file implements function 'openViewerAt' (20 lines) - move to service/hook |
| MEDIUM | no-impl-in-pages | apps\desktop\src\renderer\views\ImageLibrary.vue:383 | Page file implements function 'handleSelect' (11 lines) - move to service/hook |
| MEDIUM | no-impl-in-pages | apps\desktop\src\renderer\views\ImageLibrary.vue:419 | Page file implements function 'handleImport' (25 lines) - move to service/hook |
| MEDIUM | no-impl-in-pages | apps\desktop\src\renderer\views\ImageLibrary.vue:449 | Page file implements function 'handleDrop' (20 lines, has side effect) - move to service/hook |
| MEDIUM | no-impl-in-pages | apps\desktop\src\renderer\views\SettingsView.vue:226 | Page file implements function 'reorganize' (19 lines) - move to service/hook |
| MEDIUM | no-impl-in-pages | apps\desktop\src\renderer\views\SettingsView.vue:253 | Page file implements function 'scanMissing' (16 lines) - move to service/hook |
| MEDIUM | no-impl-in-pages | apps\desktop\src\renderer\views\SettingsView.vue:275 | Page file implements function 'chooseDirectory' (12 lines) - move to service/hook |
| MEDIUM | no-impl-in-pages | apps\desktop\src\renderer\views\SettingsView.vue:292 | Page file implements function 'migrateExisting' (21 lines) - move to service/hook |
| MEDIUM | no-impl-in-pages | apps\desktop\src\renderer\views\SettingsView.vue:313 | Page file implements function 'retryFailed' (21 lines) - move to service/hook |
| LOW | file-size | apps\desktop\src\renderer\views\ImageLibrary.vue:1 | File has 765 lines, exceeds 400-line comfort zone |
| LOW | file-size | apps\desktop\src\renderer\views\SettingsView.vue:1 | File has 756 lines, exceeds 400-line comfort zone |
