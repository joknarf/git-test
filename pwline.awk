#!/bin/awk -f
function color(col) {
    return csi colors[col] "m"
}
BEGIN {
    csi = "\033["
    c = "black red green yellow blue magenta cyan white"
    split(c, co)
    for (i in co) {
        colors[co[i]] = csi i+29 "m"
        colors["l"co[i]] = csi i+89 "m"
        colors["b"co[i]] = csi i+39 "m"
        colors["bl"co[i]] = csi i+99 "m"
    }
    colors["reset_all"] = csi "0m"
    colors["reset"] = csi "39m"
    colors["breset"] = csi "49m"
    for (i=1;i<ARGC;i++) {
        text = ARGV[i]
        split(text, colinfo, ":")
        sub("[^:]*:", "", text)
        split(colinfo[1], colfgbg, "/")
        bg = colfgbg[1]
        fg = colfgbg[2] == "" ? "lwhite" : colfgbg[2]
        printf("%s %s %s", colors["b"bg] symbol colors["b"bg] colors[fg], text, colors["reset_all"] colors[bg])
        #print(colors[fg] colors[bg] seginfo colors["reset"])
        symbol=""
    }
    printf("%s\n", colors[bg] colors["breset"] symbol colors["reset_all"])
}
