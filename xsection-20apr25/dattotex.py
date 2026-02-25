def parse_and_convert_to_latex(filename):
    with open(filename, "r") as f:
        lines = f.readlines()

    # Skip header lines until the data starts (lines starting with digits)
    data_lines = []
    for line in lines:
        if line.strip() == "":
            continue
        if line.lstrip()[0].isdigit() or line.lstrip()[0] == '.':  # start of data
            data_lines.append(line.strip())

    # Prepare output table
    header = r"""\begin{tabular}{cccccc}%
\toprule
$\MH$[GeV] & $\sigma^{bbH}$[fb] & $\Delta_{\mu_{R}\oplus\mu_{F}}$[\%] & $\Delta_{\mu_{B}}$[\%] & $\Delta_{\mathrm{PDF}}$[\%] & $\Delta_{\alphas}$[\%] \\
\midrule
"""
    footer = r"\bottomrule" + "\n" + r"\end{tabular}%"

    table_rows = []

    for line in data_lines:
        parts = line.split()
        if len(parts) < 11:
            continue  # skip incomplete lines

        # Extract needed fields by index based on your dat format
        # columns:
        # 0 mH, 3 xs, 4 muR_muF_unc, 5 mub_unc, 7 deltaPDF_up, 8 deltaPDF_down, 9 delta_as_up, 10 delta_as_down

        mH = float(parts[0])
        xs = float(parts[4-1])  # xs column index = 4th zero-based = 3rd or 4th? Let's check carefully

        # Check from example line:
        # 50         0    NLO+NNLLpart+ybyt     2.863e+00      5.28e-01      2.19e-01      1.03e-01      7.64e-02     -8.21e-02     -1.05e-02      4.95e-02
        # indices:0:mH,1:muF,2:descr,3:xs,4:muR_muF_unc,5:mub_unc,6:mb_unc,7:deltaPDF_up,8:deltaPDF_down,9:delta_as_up,10:delta_as_down

        xs = float(parts[3])
        muR_muF_unc = float(parts[4])
        mub_unc = float(parts[5])
        deltaPDF_up = float(parts[7])
        deltaPDF_down = float(parts[8])
        delta_as_up = float(parts[9])
        delta_as_down = float(parts[10])

        # Convert uncertainties to percent relative to xs, keep absolute value and format +/-
        def fmt_unc(up, down):
            up_pct = abs(up / xs) * 100
            down_pct = abs(down / xs) * 100
            return f"${{+{up_pct:.2f}}}/{{-{down_pct:.2f}}}$"

        # Format xs to integer (like in your example) by rounding
        xs_int = round(xs * 1000)  # Your example shows values like 1310 for 1.31
        # It looks like your example converts xs from fb to fb (maybe original xs was in pb?)
        # In your example, 1.310e+00 is turned into 1310. So multiply xs by 1000 for fb?

        # Based on the dat file, xs looks like it's in pb (e.g. 2.863e+00), so multiply by 1000 to get fb

        # Build the table row
        row = f"${mH:.2f}$ & ${xs_int}$ & {fmt_unc(muR_muF_unc, muR_muF_unc)} & {fmt_unc(mub_unc, mub_unc)} & {fmt_unc(deltaPDF_up, deltaPDF_down)} & {fmt_unc(delta_as_up, delta_as_down)} \\\\"
        table_rows.append(row)

    # Combine all rows
    table_content = "\n".join(table_rows)

    # Full latex output
    latex_table = header + table_content + "\n" + footer
    return latex_table

# Usage
filename = "Ecm_14000/BPT_summary4_NLO+NNLLpart+ybyt.dat"  # replace with your file name
latex_output = parse_and_convert_to_latex(filename)
print(latex_output)
