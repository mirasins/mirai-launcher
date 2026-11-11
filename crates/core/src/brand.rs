//! The Mirai fork's display name for the launcher.
//!
//! Upstream calls it "ArtCraft Launcher", in its own strings and in every translation catalog.
//! The fork shows it as "Mirai Launcher" without editing those catalogs: [`rebrand`] swaps the
//! name in every translated interface string and message, and the few places that draw the name
//! without translating it (window titles, the tray, notifications) use [`APP_NAME`].
//! Identifiers stay upstream's: the binary, crate names, the app id, the settings folder, the
//! startup-list entry and the installer's registry keys, so settings and installs carry over.

use std::collections::HashMap;
use std::sync::{Mutex, OnceLock};

/// The name the fork shows for the launcher.
pub const APP_NAME: &str = "Mirai Launcher";

/// Upstream's name for the launcher, as its interface strings spell it.
pub const UPSTREAM_NAME: &str = "ArtCraft Launcher";

/// Distinct rebranded strings kept. Interface strings are a fixed set (catalog rows and literals),
/// so this is never reached in practice; it guards against unbounded growth all the same: past it,
/// a string not seen before is shown with upstream's name rather than kept.
const CACHE_LIMIT: usize = 4096;

/// `s` with the launcher's upstream name replaced by [`APP_NAME`]; `s` itself when it doesn't name
/// the launcher. The rebranded copies are cached for the life of the process, so a string is
/// rebuilt once.
pub fn rebrand(s: &str) -> &str {
    if !s.contains(UPSTREAM_NAME) {
        return s;
    }
    static CACHE: OnceLock<Mutex<HashMap<String, &'static str>>> = OnceLock::new();
    // A poisoned lock (a panic elsewhere while holding it) only costs the rename, never a crash.
    let Ok(mut cache) = CACHE.get_or_init(Default::default).lock() else { return s };
    if let Some(&branded) = cache.get(s) {
        return branded;
    }
    if cache.len() >= CACHE_LIMIT {
        return s;
    }
    let branded: &'static str = Box::leak(s.replace(UPSTREAM_NAME, APP_NAME).into_boxed_str());
    cache.insert(s.to_owned(), branded);
    branded
}

/// [`rebrand`] for an owned string (plural forms, filled-in messages), without caching.
pub fn rebrand_owned(s: String) -> String {
    if s.contains(UPSTREAM_NAME) { s.replace(UPSTREAM_NAME, APP_NAME) } else { s }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn the_upstream_name_becomes_the_fork_name() {
        assert_eq!(rebrand("Quit ArtCraft Launcher"), "Quit Mirai Launcher");
        assert_eq!(rebrand("ArtCraft Launcher"), APP_NAME);
        assert_eq!(rebrand("Salir de ArtCraft Launcher"), "Salir de Mirai Launcher");
        assert_eq!(rebrand_owned("ArtCraft Launcher · 2 updates available".into()), "Mirai Launcher · 2 updates available");
    }

    #[test]
    fn other_strings_are_left_alone() {
        let s = "Craft App Suite";
        assert!(std::ptr::eq(rebrand(s), s));
        // The company and the suite keep their names; only the launcher's changes.
        assert_eq!(rebrand("Join the ArtCraft community"), "Join the ArtCraft community");
        assert_eq!(rebrand_owned("artcraft-launcher".into()), "artcraft-launcher");
    }

    #[test]
    fn the_same_string_is_rebuilt_once() {
        let a = rebrand("Open ArtCraft Launcher to update.");
        let b = rebrand("Open ArtCraft Launcher to update.");
        assert!(std::ptr::eq(a, b));
    }
}
