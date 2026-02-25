def parse_and_convert_to_latex(filename):
    with open(filename, "r") as f:
        lines = f.readlines()

    # Prepare LaTeX table header and footer
    header = r"""\begin{tabular}{cccc}%
\toprule
$\MH$[GeV] & $\sigma^{bbH}$[fb] & $\delta(\mathrm{theory})$ & $\delta_{\mu_{R}\oplus\mu_{F}}$ & \delta_{\mu_{B}} & \delta(\mathrm{PDF}+\alphas+m_b) & $\delta_{\mathrm{PDF}}$ & \delta_{\alphas} & \delta_{m_b} \\
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
        if len(parts) != 14:
            continue  # skip malformed lines

        mh = float(parts[0])
        xs = float(parts[1])
        # parts[2] is '+-'
        #theory uncertainty
        drf_err = float(parts[3])
        dmub_err = float(parts[4])
        scale_err = float(parts[5])
        #parametric uncertainty
        par_err_mass = float(parts[6]) #parts[7]=-parts[6]
        par_err_pdfplus = float(parts[8])
        par_err_pdfminus = float(parts[9])
        par_err_asplus = float(parts[10])
        par_err_asminus = float(parts[11])
        par_err_up = float(parts[12])
        par_err_down = float(parts[13])

        # Convert absolute errors to percentages relative to xs
        drf_err_pct = 100 * drf_err / xs
        dmub_err_pct = 100 * dmub_err / xs
        scale_err_pct = 100 * scale_err / xs
        par_err_mass_pct = 100 * par_err_mass / xs
        par_err_pdfplus_pct = 100 * par_err_pdfplus / xs
        par_err_pdfminus_pct = 100 * abs(par_err_pdfminus) / xs
        par_err_asplus_pct = 100 * par_err_asplus / xs
        par_err_asminus_pct = 100 * abs(par_err_asminus) / xs
        par_err_up_pct = 100 * par_err_up / xs
        par_err_down_pct = 100 * abs(par_err_down) / xs  # abs because down error is negative

        # Format cross section as integer fb (rounded)
        xs_int = round(xs * 1000)  # assuming xs in pb? If xs already in fb, just round(xs)

        # Format row
        # Scale error: symmetric ±x.xx%
        scale_str = rf"$\pm{scale_err_pct:.2f}\%$"
        drf_str   = rf"{{\color{{black!55}}$\pm {drf_err_pct:.2f}\%$}}"
        dmub_str  = rf"{{\color{{black!55}}$\pm {dmub_err_pct:.2f}\%$}}"
        # PDF+alpha errors: asymmetric +x.xx / -x.xx %
        dmass_str = rf"{{\color{{black!55}}$\pm {par_err_mass_pct:.2f}\%$}}"
        pdf_str = rf"{{\color{{black!55}}$^{{+{par_err_pdfplus_pct:.2f}}}_{{-{par_err_pdfminus_pct:.2f}}}\%$}}"
        as_str  = rf"{{\color{{black!55}}$^{{+{par_err_asplus_pct:.2f}}}_{{-{par_err_asminus_pct:.2f}}}\%$}}"
        par_str = rf"$^{{+{par_err_up_pct:.2f}}}_{{-{par_err_down_pct:.2f}}}\%$"
        
        row = f"${mh:.2f}$ & ${xs_int}$ & {scale_str} & {drf_str} & {dmub_str} & {par_str} & {pdf_str} & {as_str} & {dmass_str}  \\\\"
        table_rows.append(row)

    table_content = "\n".join(table_rows)
    latex_table = header + table_content + "\n" + footer
    return latex_table


# Example usage
filename = "saved-136-ilog0.dat"  # replace with your actual data filename
latex_output = parse_and_convert_to_latex(filename)
print(latex_output)
