---
name: refactoring-discipline
description: Use when editing existing code - constrains scope so changes stay minimal and reviewable, and defines exactly which cleanup is yours to do
---

# Refactoring discipline

When editing existing code, the change is the change. Nothing else.

## Do not

- Do not improve adjacent code, comments, or formatting.
- Do not refactor things that are not broken.
- Do not restyle code to your preference. Match the existing style, even
  where you would do it differently.

## Dead code

If you notice unrelated dead code, **mention it — do not delete it.** Removing
pre-existing dead code needs approval, separately.

## Orphans you created

Remove imports, variables, and functions that *your* change made unused. That
cleanup is part of your change, not a separate one.

The distinction: something your edit orphaned is yours to remove; something
that was already dead before you arrived is not.
