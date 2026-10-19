# ============================================================
# SETUP AND MODEL INITIALIZATION
# ============================================================


using HetaSimulator
using Plots
using DataFrames
using Measures

plots_dir = joinpath(@__DIR__, "Plots")
mkpath(plots_dir)

heta_build(@__DIR__)

# Load the Heta platform and select the model
platform = load_platform(@__DIR__)
model = platform.models[:nameless]

# ============================================================
# SIMULATION: SINGLE DOSE
# ============================================================


# Configure the single-dose simulation scenario
scn_single = Scenario(
    model,
    (0.,1848.);
    events_active = [:Dose_on_single=>true, :Dose_on_Q2W=>false, :Rab_on=>false],
    observables = [:NEU_pl,:Sari_pl,:Sari_conc_mg_l_pl,:NEU_percent],
    )

# Run the simulation
res_scn_single = sim(scn_single)

# ============================================================
# PLOT 1: SARILUMAB CONCENTRATION IN BLOOD
# ============================================================


# Plot the simulated sarilumab concentration
Plots.plot(res_scn_single,
    color = palette(:tab20c)[6],
    label = "",
    yaxis = "Sarilumab in blood [mg/L]", 
    vars = [:Sari_conc_mg_l_pl],
    xaxis = "Time, days",
    xlim = [168,1680+168],
    xformatter = y -> (y-168)/24,
    xticks = 168:120:(1680+168),dpi=1200,
    tickfontsize = 12,guidefont = font(14),legendfont=font(12),titlefont=font(16)
    )

# Experimental data (time in days converted to hours)
x = [
    0,
    0.5,
    1,
    2,
    3,
    4,
    5,
    6,
    8,
    10,
    12,
    14,
    18,
    21,
    28,
    42
    ] .* 24

y = [
    0,
    0.9932432432432421,
    7.472972972972973,
    10.972972972972972,
    12.391891891891891,
    11.682432432432432,
    11.162162162162161,
    9.885135135135133,
    7.236486486486486,
    5.155405405405405,
    3.3108108108108105,
    1.8445945945945947,
    0.6148648648648631,
    0.18918918918918948,
    0.14189189189189122,
    0.14189189189189122
    ]

# Overlay experimental data on the simulation plot
plot!(
    x.+168, y, c=palette(:tab20c)[6],
    seriestype = :scatter,
    label = "", 
    background_color = :transparent
    )

# Save plot
savefig(joinpath(plots_dir, "Sarilumab_in_blood_single_dose.svg"))


# ============================================================
# PLOT 2: NEUTROPHILS (% FROM BASELINE)
# ============================================================


# Plot simulated Neutrophils % change from baseline
Plots.plot(res_scn_single,
    c = palette(:tab20c)[9],
    xlim = [168,960+168],
    ylim = [0,100],
    label = "",
    yaxis = "NEU % from baseline", 
    vars = [:NEU_percent],
    xaxis = "Time, days",
    xformatter = y -> (y-168)/24,
    xticks = 168:120:(960+168),
    tickfontsize = 12,guidefont = font(14),legendfont=font(12),titlefont=font(16),
    background_color = :transparent,
    dpi=1200,
    )
# Overlay experimental data on the simulation plot
scatter!([3.5*24+168], [70],yerror = ([70 - 16], [78 - 70]),label = "", c=palette(:tab20c)[13],)

# Save plot
savefig(joinpath(plots_dir, "NEU_perc_single_dose.svg"))


# ============================================================
# SIMULATION 2: SINGLE DOSE - RABBITS
# ============================================================


# Configure the rabbit single-dose simulation scenario
scn_single_rabbits = Scenario(
    model,
    (0.,1848.);
    events_active = [:Dose_on_single=>false,:Dose_on_Q2W=>false,:Rab_on=>true],
    observables = [:NEU_pl,:Sari_pl,:Sari_conc_mg_l_pl,:NEU_percent],
    ) 

# Run the rabbit simulation
res_scn_single_rabbits = sim(scn_single_rabbits)


# ============================================================
# PLOT 3: NEUTROPHILS (% FROM BASELINE) - RABBITS
# ============================================================

# Plot the simulated neutrophil percentage
Plots.plot(res_scn_single_rabbits,
    c = palette(:tab20c)[9],
    xlim = [168,240+168],
    ylim = [0,250],
    label = "",
    yaxis = "NEU % from baseline", 
    vars = [:NEU_percent],
    xaxis = "Time, days",
    xformatter = y -> (y-168)/24,
    xticks = 168:48:(960+168),
    tickfontsize = 12,guidefont = font(14),legendfont=font(12),titlefont=font(16),
    background_color = :transparent,
    dpi=1200,
    )

savefig(joinpath(plots_dir, "NEU_perc_single_dose_rabbit.svg"))


# ============================================================
# SIMULATION 3: MULTIPLE DOSES (EVERY TWO WEEKS)
# ============================================================


# Configure the multiple-dose simulation scenario
scn_q2w = Scenario(
    model,
    (0.,4488.);
    events_active = [:Dose_on_single=>false, :Dose_on_Q2W=>true, :Rab_on=>false],
    observables = [:NEU_pl, :NEU_percent, :NEU_blood]
    ) 

# Run the multiple-dose simulation
res_scn_q2w = sim(scn_q2w)


# ============================================================
# PLOT 4: NEUTROPHIL CONCENTRATION - MULTIPLE DOSES
# ============================================================


# Plot the simulated neutrophil concentration
Plots.plot(res_scn_q2w,
    c = palette(:tab20c)[9],
    label = "",
    yaxis = "NEU in plasma \$\\times 10^6\$ [kcell/L]", 
    vars = [:NEU_blood],
    xaxis = "Time, days",
    xformatter = y -> (y-168)/24,
    xticks = 168:480:(4320+168),
    xlim = [168,(4320+168)],
    ylim = [0,6e6],
    yticks = [0,1e6,2e6,3e6,4e6,5e6,6e6]
    )

# Experimental data (time in days from simulation start)
x = [1.5544041450777257,
    13.056994818652853,
    24.870466321243526,
    32.95336787564766,
    55.02590673575129,
    78.65284974093264,
    89.22279792746113,
    103.83419689119171,
    115.95854922279793,
    138.3419689119171,
    155.75129533678754,
    167.56476683937822].+7
y = [4884615.384615384,
    3249999.9999999995,
    3923076.9230769225,
    3403846.1538461535,
    3057692.307692307,
    3346153.846153846,
    3153846.1538461535,
    3155384.615384615,
    3673076.923076923,
    3403846.1538461535,
    3596153.8461538455,
    3403846.1538461535]

# Overlay experimental data (convert days to hours)
plot!(x.*24, y,seriestype = :scatter, label = "", c=palette(:tab20c)[13],
    tickfontsize = 12,guidefont = font(14),legendfont=font(12),titlefont=font(16),
    background_color = :transparent,
    dpi=1200,
    right_margin =5mm,
    yformatter = y -> y/10^6,
    )

savefig(joinpath(plots_dir, "NEU_plasma_multiple_doses.svg"))


# ============================================================
# SIMULATION 4: BASELINE / STEADY-STATE CONDITIONS
# ============================================================


# Configure the baseline simulation without active dosing
scn_st_st = Scenario(
    model,
    (0.,168.);
    events_active = [:Dose_on_single=>false, :Dose_on_Q2W=>false, :Rab_on=>false],
    observables = [:NEU_pl, :NEU_bm, :NEU_ts, :IL6_pl]
    ) 

# Run the baseline simulation
res_scn_st_st = sim(scn_st_st)

# Convert simulation results to a DataFrame
df = DataFrame(res_scn_st_st)


# ============================================================
# PLOT 5: BASELINE NEUTROPHIL AND IL6 CONCENTRATIONS
# ============================================================


labels = ["NEU_bm","NEU_pl","NEU_ts","IL6_pl"]
color_a = palette(:tab20c)[9]
color_b = palette(:tab20c)[13]

yL = [df[end-1,:NEU_bm],df[end-1,:NEU_pl],df[end-1,:NEU_ts],df[end-1,:IL6_pl]]
yR = [776200000, 9150000, 504650, 0.354342327]

bar_w = 0.3

n  = length(labels)
xc = collect(1:n)
δ  = 0.2
xL = xc .- δ
xR = xc .+ δ

p = bar(xL, yL; bar_width=bar_w, label= "Model", c =color_a,fillrange = 0.01)
p2 = twinx(p)
bar!(p, xR, yR; bar_width=bar_w, label= "Data", c =color_b,fillrange = 0.01)

tick_positions = [10^-1, 10^1, 10^3,10^5,10^7,10^9]
tick_labels = ["10⁻¹", "10¹", "10³", "10⁵", "10⁷", "10⁹"]

# Use separate panels because NEU and IL6 have different units

plot!(p;
    xticks=(xc, labels),
    xlims=(0.5, n + 0.5),
    size=(1200, 400),
    legend=true, 
    ylim = [0.1,10^9], 
    yscale =:log10,
    ylabel = "Neutrophils consentration, kcell/L",
    left_margin=5mm,right_margin=8mm,bottom_margin=8mm,
    yticks = (tick_positions, tick_labels),
    tickfontsize = 12,guidefont = font(14),legendfont=font(12),titlefont=font(16),
    background_color = :transparent,
    background_color_legend = :white,
    dpi=1200,
    )
plot!(p2;
    ylabel = "IL6 consentration, pmole/L", yticks = (tick_positions, tick_labels),
    tickfontsize = 12,guidefont = font(14),legendfont=font(12),titlefont=font(16),
    background_color = :transparent,
    dpi=1200,
    size = (711, 400),
    )

savefig(joinpath(plots_dir, "NEU_conc_st_st.svg"))