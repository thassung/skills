"""Cross-file checks for claude-env. Run via validate.sh; pass --live to also diff ~/.claude."""
import filecmp
import os
import re
import sys
from pathlib import Path

ROOT = Path(sys.argv[1]) if len(sys.argv) > 1 and not sys.argv[1].startswith("--") else Path(__file__).resolve().parent.parent
LIVE = "--live" in sys.argv
errors = []


def frontmatter(path):
    text = path.read_text(encoding="utf-8")
    m = re.match(r"---\r?\n(.*?)\r?\n---", text, re.S)
    return m.group(1) if m else ""


skills = {}
for f in sorted(ROOT.glob("skills/*/*/SKILL.md")):
    skills[f.parent.name] = "disable-model-invocation: true" in frontmatter(f)
user_invoked = {n for n, u in skills.items() if u}

# 1. A skill must not load a user-invoked skill: the Skill tool refuses it. Point at its SKILL.md path instead.
for f in sorted(ROOT.glob("skills/*/*/**/*.md")):
    owner = f.relative_to(ROOT).parts[2]
    for i, line in enumerate(f.read_text(encoding="utf-8").splitlines(), 1):
        for u in user_invoked - {owner}:
            if f"skills/{u}/SKILL.md" in line:
                continue
            n = re.escape(u)
            if re.search(rf"Skill tool[^.]*`/?{n}`|[Ii]nvoke `/?{n}`|(?:[Aa]pply|through|of) the \*\*{n}\*\* skill|\*\*{n}\*\* skill appl", line):
                errors.append(f"{f.relative_to(ROOT)}:{i}: loads user-invoked skill '{u}'; read `~/.claude/skills/{u}/SKILL.md` instead")

# 2. README invocation lists must match frontmatter.
readme = (ROOT / "README.md").read_text(encoding="utf-8")
def listed(label):
    m = re.search(rf"\*\*{label}\*\*[^\n]*\n([^\n]+)", readme)
    if not m:
        errors.append(f"README.md: no **{label}** list")
        return set()
    return {s.strip() for s in re.sub(r",? plus all .*$", "", m.group(1)).split(",") if s.strip()}
non_principle = {n for n in skills if not n.startswith("principle-")}
for label, expected in (("Model-invoked", {n for n in non_principle if not skills[n]}), ("User-invoked", {n for n in non_principle if skills[n]})):
    got = listed(label)
    for n in sorted(expected - got):
        errors.append(f"README.md: '{n}' missing from the {label} list")
    for n in sorted(got - expected):
        errors.append(f"README.md: '{n}' is in the {label} list but its frontmatter disagrees")

# 3. Every principle pointer resolves.
for f in [ROOT / "CLAUDE.md", *sorted(ROOT.glob("skills/custom/mode/*.md"))]:
    text = f.read_text(encoding="utf-8")
    names = set(re.findall(r"principle-([a-z]+(?:-[a-z]+)*)", text))
    if f.name == "CLAUDE.md":
        names |= set(re.findall(r"^- \*\*([a-z-]+)\*\* —", text, re.M))
    for n in sorted(names):
        if f"principle-{n}" not in skills:
            errors.append(f"{f.relative_to(ROOT)}: points at principle-{n}, which does not exist")

# 4. --live: the deployed copy matches the repo.
if LIVE:
    target = Path.home() / ".claude"
    def same_tree(a, b):
        c = filecmp.dircmp(a, b)
        if c.left_only or c.right_only or c.funny_files:
            return False
        if filecmp.cmpfiles(a, b, c.common_files, shallow=False)[1:] != ([], []):
            return False
        return all(same_tree(Path(a) / d, Path(b) / d) for d in c.common_dirs)
    for src in sorted(ROOT.glob("skills/*/*/")):
        dst = target / "skills" / src.name
        if not dst.is_dir():
            errors.append(f"live: {src.name} not deployed")
        elif (dst / src.name).is_dir():
            errors.append(f"live: {src.name} has a nested copy at {dst / src.name}")
        elif not same_tree(src, dst):
            errors.append(f"live: {src.name} differs from the repo")
    if not filecmp.cmp(ROOT / "CLAUDE.md", target / "CLAUDE.md", shallow=False):
        errors.append("live: CLAUDE.md differs from the repo")

for e in errors:
    print(f"FAIL: {e}")
sys.exit(1 if errors else 0)
