vim.g.phoenix = {
    dict = {
        capacity = 100000,
        min_word_length = 4,
        word_pattern = "[^%s%.:%(%)%[%]%{%}%d]+",
    },
    scanner = {
        scan_batch_size = 1000, -- Scan 1000 items per batch
        cache_duration_ms = 5000, -- Cache results for 5s
        throttle_delay_ms = 2000, -- Wait 150ms between updates
        ignore_patterns = {}, -- Dictionary or file ignored when path completion
    },
}

require("phoenix").register()
