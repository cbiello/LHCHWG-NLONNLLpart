def parse_and_convert_to_latex(filename):
    with open(filename, "r") as f:
        lines = f.readlines()

    # Prepare LaTeX table header and footer
    header = r"""\begin{tabular}{cccc}%
\toprule
$\MH$[GeV] & $\sigma^{bbH}$[fb] & $\Delta_{\mu_{R}\oplus\mu_{F}\oplus\mu_{B}}$[\%] & $\Delta_{\mathrm{PDF}\oplus\alphas}$[\%] \\
\midrule
"""
    footer = r"\bottomrule" + "\n" + r"\end{tabular}%"

    table_rows = []

    for line in lines:
        line = line.strip()
        if not line:
            continue
        # Split by whitespace, expect 6 elements:
        # mh, xs, "+-", scale_err, par_err_up, par_err_down
        parts = line.split()
        if len(parts) != 6:
            continue  # skip malformed lines

        mh = float(parts[0])
        xs = float(parts[1])
        # parts[2] is '+-'
        scale_err = float(parts[3])
        par_err_up = float(parts[4])
        par_err_down = float(parts[5])

        # Convert absolute errors to percentages relative to xs
        scale_err_pct = 100 * scale_err / xs
        par_err_up_pct = 100 * par_err_up / xs
        par_err_down_pct = 100 * abs(par_err_down) / xs  # abs because down error is negative

        # Format cross section as integer fb (rounded)
        xs_int = round(xs * 1000)  # assuming xs in pb? If xs already in fb, just round(xs)

        # Format row
        # Scale error: symmetric ±x.xx%
        scale_str = rf"$\pm{scale_err_pct:.2f}$"

        # PDF+alpha errors: asymmetric +x.xx / -x.xx %
        par_str = rf"${{{{+{par_err_up_pct:.2f}}}}}/{{-{par_err_down_pct:.2f}}}$"

        row = f"${mh:.2f}$ & ${xs_int}$ & {scale_str} & {par_str} \\\\"
        table_rows.append(row)

    table_content = "\n".join(table_rows)
    latex_table = header + table_content + "\n" + footer
    return latex_table


# Example usage
filename = "saved-136-ilog1.dat"  # replace with your actual data filename
latex_output = parse_and_convert_to_latex(filename)
print(latex_output)
