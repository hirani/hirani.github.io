# STATUS — working notes for this repository

Anil Hirani's homepage, served by GitHub Pages at <https://hirani.github.io>. `.nojekyll` is
present, so **every file in this repository is served verbatim**, including this one, at
`https://hirani.github.io/STATUS.md`. Nothing private belongs here.

Written 2026-09-19. These are the conventions a session arriving from
`~/github/discrete-exterior-calculus/myprojects` needs, because the rules there do not all
carry over.

## The PDFs under `papers/` are published artifacts, not reference copies

`myprojects/CLAUDE.md` says a paper is never copied into the project — papers live in
`~/github/discrete-exterior-calculus/references` and are cited by key. **That rule does not
apply here.** The files under `papers/` are the copies the world downloads. They are the point
of the directory, not clutter in it.

A session fresh from myprojects will notice that these files share the library's naming scheme
and are mostly identical to library files, and will be tempted to "deduplicate" them into
citations. Do not. Measured 2026-09-19 over the 40 PDFs directly under `papers/`:

| | count |
|---|---|
| byte-identical to `references/?/*/<key>.pdf` | 33 |
| present in the archive but different bytes | 3 |
| not in the archive under that key | 4 |

The three that differ: `CoHiVi2007_SFM` (site 1067390 B, archive 2014682 B — the site copy is
compressed for download), `HiNaCh2015_IJCMESM` (1461012 vs 1630466), and
`HiMaAr2001_EMMCVPR`, which differs **by a single byte** (220780 vs 220779). The four with no
archive counterpart: `GrHiDeSc2003_SCA_lowres`, `HiKaVa2013correction`,
`Hirani2003_PhD_Caltech`, `HiSu1990_FI`.

The one-byte difference is the lesson in miniature. Byte-identity is not what makes these files
legitimate and it is not a test you can apply — a published copy may be recompressed, a
low-resolution variant, a correction note, or a thesis the archive never held. The site's copies
have their own life. Leave them alone unless Anil asks for a specific change.

## This repository is a cited source — renames break things silently

Files here are cited by path from `myprojects`, which is a different repository with no way to
notice a rename. As of 2026-09-19:

| File here | Cited from |
|---|---|
| `slides/fortworth25.pdf` | `decbc/README.md:300`, `decbc/notes.tex:801`, `house/README.md:111`, `house/README.md:180` |
| `oxford-lectures.html` | `oxford/lecture4-notes.tex:4`, `oxford/docs/lecture3-state.md:12`, `oxford/docs/status.md:163`, `oxford/docs/status.md:189` |
| `slides/` (as a location) | `oxford/docs/status.md:58` |

`fortworth25.pdf` is the SIAM CSE 2025 talk. `oxford-lectures.html` carries the published
lecture abstracts, which the oxford project treats as the source of record for what was
advertised.

Before moving, renaming or regenerating anything under `slides/` or `papers/`, re-run the check
rather than trusting this table — it was true on the date above and nothing updates it:

    grep -rn "hirani\.github\.io" --include='*.md' --include='*.tex' \
        ~/github/discrete-exterior-calculus/myprojects

Line numbers drift; the filenames are the part that matters. If a rename is right anyway, say so
to the session working in `myprojects` so the citations move with it.

## Git

A session working here loads `myprojects/CLAUDE.md` when its working directory is under
`myprojects`, and those rules are about concurrent sessions sharing a working tree. Today no
peer session is live in this repository, so most of them are precautionary. Two cost nothing and
are worth using unconditionally:

- Commit as `git commit -- <paths>`, never a bare `git commit`. A bare commit takes the whole
  index, including anything another session staged since you looked.
- Run `git log origin/main..main` immediately before pushing and say what is in it. A push
  carries every ancestor, so it can publish work that is not yours.

And three that matter the moment a second session does appear here:

- Never `git commit --amend`. It takes `HEAD`, and `HEAD` may have become someone else's commit.
- Never state what is ahead, behind or held from memory. Check at the moment of the claim and
  report the tip with what it was checked against — `main at <sha>, origin/main at <sha>` — so
  the reader can tell whether the claim is still live.
- Every session commits as Anil Hirani, so `%an` identifies nobody. The subject line is the only
  authorship record. Start subjects for this repository with `Webpage:`.

Stage explicit paths. Never `git add -A`, `push --force`, `reset --hard`, or rewrite history.

## Where notes go

In this repository, in git. Not in `~/.claude/projects/<dir>/memory/`: that store is per machine,
it does not sync to the office machine or the laptop, and it is keyed to the working directory
rather than to a session, so the other myprojects sessions share it. A git rule written into one
of those stores on 2026-09-17 could not reach the sessions that needed it, which rediscovered it
the hard way two days later.
