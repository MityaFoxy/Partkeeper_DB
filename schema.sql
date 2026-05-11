-- PartKeeper schema dump
-- Generated automatically. Edit migrations in the app repo, not this file by hand unless you know why.
PRAGMA foreign_keys = ON;

CREATE TABLE categories (
                name TEXT PRIMARY KEY,
                code TEXT DEFAULT '',
                gost_group TEXT DEFAULT '',
                description TEXT DEFAULT '',
                builtin INTEGER NOT NULL DEFAULT 0,
                created_at TEXT NOT NULL
            );

CREATE TABLE components (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                uuid TEXT NOT NULL UNIQUE,
                mpn TEXT NOT NULL,
                manufacturer TEXT DEFAULT '',
                description TEXT DEFAULT '',
                category TEXT DEFAULT '',
                value TEXT DEFAULT '',
                package TEXT DEFAULT '',
                source_url TEXT DEFAULT '',
                notes TEXT DEFAULT '',
                fingerprint TEXT NOT NULL DEFAULT '',
                created_at TEXT NOT NULL,
                updated_at TEXT NOT NULL,
                UNIQUE(manufacturer, mpn)
            );

CREATE TABLE lots (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                component_id INTEGER NOT NULL REFERENCES components(id) ON DELETE CASCADE,
                quantity INTEGER NOT NULL CHECK(quantity >= 0),
                supplier TEXT DEFAULT '',
                storage_location TEXT DEFAULT '',
                received INTEGER NOT NULL DEFAULT 1,
                received_at TEXT NOT NULL,
                label_text TEXT DEFAULT '',
                source_url TEXT DEFAULT '',
                notes TEXT DEFAULT '',
                created_at TEXT NOT NULL
            );

CREATE TABLE meta (
                key TEXT PRIMARY KEY,
                value TEXT NOT NULL
            );

CREATE INDEX idx_components_fingerprint ON components(fingerprint);

CREATE INDEX idx_components_mpn ON components(mpn);

CREATE UNIQUE INDEX idx_components_uuid ON components(uuid);

CREATE INDEX idx_lots_component_id ON lots(component_id);
