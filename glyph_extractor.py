import glob
import os

def collect_glyphs(html_dir):
    regular = list()
    semibold = list()

    # find all HTML files under html_dir
    for path in glob.glob(os.path.join(html_dir, '**', '*.html'), recursive=True):
        print()
        with open(path, 'r', encoding='utf-8') as f:
            soup = BeautifulSoup(f, 'html.parser')

        # iterate every text node
        for text_node in soup.find_all(string=True):
            text = text_node.strip()
            if not text:
                continue


            # gather ALL ancestor classes
            classes = set()
            for anc in text_node.parents:
                if anc.has_attr('class'):
                    classes.update(anc['class'])


            is_smallcaps   = 'smallcaps'    in classes
            is_semibold    = 'font-semibold' in classes

            heading_parent = text_node.find_parent({'h1','h2','h3','h4','h5','h6'})
            if heading_parent and heading_parent.find_parent(class_='prose'):
                is_semibold = True

            # remove ALL whitespace
            cleaned = re.sub(r'\s+', '', text)
            if not cleaned:
                continue

            # classify
            if not is_smallcaps and not is_semibold:
                # plain text → regular
                for c in cleaned:
                    if unicodedata.category(c) == 'Cf':
                        continue

                    if c not in regular:
                        regular.append(c)

            elif is_smallcaps and not is_semibold:
                # smallcaps → uppercase → regular
                for c in cleaned.upper():
                    if unicodedata.category(c) == 'Cf':
                        continue
                    if c not in regular:
                        regular.append(c)

            elif not is_smallcaps and is_semibold:
                # semibold → preserve case → semibold
                for c in cleaned:
                    if unicodedata.category(c) == 'Cf':
                        continue
                    if c not in semibold:
                        semibold.append(c)

            else:  # both smallcaps & semibold
                # uppercase → semibold
                for c in cleaned.upper():
                    if unicodedata.category(c) == 'Cf':
                        continue
                    if c not in semibold:
                        semibold.append(c)

    return regular, semibold

def dump_set(chars, out_path):
    # write the chars in sorted (Unicode code-point) order,
    # concatenated into a single line
    with open(out_path, 'w', encoding='utf-8') as f:
        for c in sorted(chars):
            f.write(c)

if __name__ == '__main__':
    html_dir = '/app/out'
    regular, semibold = collect_glyphs(html_dir)

    dump_set(regular,   '/regular.txt')
    dump_set(semibold,  '/semibold.txt')

    print(f"Written {len(regular)} glyphs to /regular.txt")
    print(f"Written {len(semibold)} glyphs to /semibold.txt")
