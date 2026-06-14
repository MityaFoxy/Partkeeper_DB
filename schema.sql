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

CREATE TABLE component_lookup_cache (
                provider TEXT NOT NULL,
                query TEXT NOT NULL,
                payload_json TEXT NOT NULL DEFAULT '{}',
                normalized_json TEXT NOT NULL DEFAULT '{}',
                confidence TEXT NOT NULL DEFAULT 'exact',
                fetched_at TEXT NOT NULL,
                expires_at TEXT NOT NULL,
                PRIMARY KEY(provider, query)
            );

CREATE TABLE component_mpn_aliases (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                component_id INTEGER NOT NULL REFERENCES components(id) ON DELETE CASCADE,
                mpn TEXT NOT NULL,
                manufacturer TEXT DEFAULT '',
                reason TEXT DEFAULT '',
                created_at TEXT NOT NULL,
                UNIQUE(component_id, mpn)
            );

CREATE TABLE component_revisions (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                component_id INTEGER NOT NULL REFERENCES components(id) ON DELETE CASCADE,
                field_name TEXT NOT NULL,
                old_value TEXT DEFAULT '',
                new_value TEXT DEFAULT '',
                reason TEXT DEFAULT '',
                change_type TEXT NOT NULL DEFAULT 'edit',
                created_at TEXT NOT NULL
            );

CREATE TABLE "components" (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    uuid TEXT NOT NULL UNIQUE,
                    mpn TEXT NOT NULL,
                    manufacturer TEXT DEFAULT '',
                    description TEXT DEFAULT '',
                    category TEXT NOT NULL DEFAULT 'Uncategorized'
                        REFERENCES categories(name) ON UPDATE CASCADE ON DELETE RESTRICT,
                    value TEXT DEFAULT '',
                    package TEXT DEFAULT '',
                    source_url TEXT DEFAULT '',
                    notes TEXT DEFAULT '',
                    fingerprint TEXT NOT NULL DEFAULT '',
                    created_at TEXT NOT NULL,
                    updated_at TEXT NOT NULL,
                    UNIQUE(manufacturer, mpn)
                );

CREATE TABLE field_reviews (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                component_id INTEGER NOT NULL REFERENCES components(id) ON DELETE CASCADE,
                field_name TEXT NOT NULL,
                field_value TEXT DEFAULT '',
                value_hash TEXT NOT NULL,
                status TEXT NOT NULL DEFAULT 'pending',
                reason TEXT DEFAULT '',
                created_at TEXT NOT NULL,
                resolved_at TEXT DEFAULT '',
                UNIQUE(component_id, field_name, value_hash)
            );

CREATE TABLE lot_revisions (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                lot_id INTEGER NOT NULL REFERENCES lots(id) ON DELETE CASCADE,
                component_id INTEGER NOT NULL REFERENCES components(id) ON DELETE CASCADE,
                field_name TEXT NOT NULL DEFAULT 'storage_location',
                old_value TEXT DEFAULT '',
                new_value TEXT DEFAULT '',
                reason TEXT DEFAULT '',
                created_at TEXT NOT NULL
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

CREATE TABLE trusted_values (
                field_name TEXT NOT NULL,
                normalized_value TEXT NOT NULL,
                display_value TEXT NOT NULL,
                created_at TEXT NOT NULL,
                PRIMARY KEY(field_name, normalized_value)
            );

CREATE INDEX idx_aliases_mpn ON component_mpn_aliases(mpn);

CREATE UNIQUE INDEX idx_categories_name_normalized ON categories(lower(trim(name)));

CREATE INDEX idx_components_fingerprint ON components(fingerprint);

CREATE INDEX idx_components_mpn ON components(mpn);

CREATE UNIQUE INDEX idx_components_uuid ON components(uuid);

CREATE INDEX idx_field_reviews_component_status ON field_reviews(component_id, status);

CREATE INDEX idx_lookup_cache_expires_at ON component_lookup_cache(expires_at);

CREATE INDEX idx_lot_revisions_component_id ON lot_revisions(component_id);

CREATE INDEX idx_lots_component_id ON lots(component_id);

CREATE INDEX idx_revisions_component_id ON component_revisions(component_id);

CREATE TRIGGER trg_categories_english_insert
            BEFORE INSERT ON categories
            WHEN trim(NEW.name) = ''
              OR NEW.name NOT GLOB '*[A-Za-z]*'
              OR NEW.name GLOB '*[^ -~]*'
            BEGIN
                SELECT RAISE(ABORT, 'PartKeeper category names must be English ASCII text');
            END;

CREATE TRIGGER trg_categories_english_update
            BEFORE UPDATE OF name ON categories
            WHEN trim(NEW.name) = ''
              OR NEW.name NOT GLOB '*[A-Za-z]*'
              OR NEW.name GLOB '*[^ -~]*'
            BEGIN
                SELECT RAISE(ABORT, 'PartKeeper category names must be English ASCII text');
            END;
