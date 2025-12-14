# -*- coding: utf-8 -*-
"""
سكربت إنشاء المخططات البيانية لتحليل بيانات السيارات
"""

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
import plotly.express as px
import plotly.io as pio
import os
import warnings

warnings.filterwarnings('ignore')

# إعداد مسار الحفظ
IMG_DIR = os.path.join(os.path.dirname(__file__), 'img')
os.makedirs(IMG_DIR, exist_ok=True)

# إعداد الستايل
plt.style.use('seaborn-v0_8-whitegrid')
plt.rcParams['figure.figsize'] = (10, 6)
plt.rcParams['font.size'] = 12
plt.rcParams['axes.titlesize'] = 14
plt.rcParams['axes.labelsize'] = 12

# تحميل البيانات
DATA_PATH = os.path.join(os.path.dirname(__file__), 'dataset', 'cleaned_cars.csv')
df = pd.read_csv(DATA_PATH)

print(f"تم تحميل البيانات: {df.shape[0]} صف × {df.shape[1]} عمود")
print(f"الأعمدة: {df.columns.tolist()}")

# تحديد الأعمدة الرقمية والفئوية
num_cols = ['selling_price', 'km_driven', 'engine', 'max_power', 'seats', 'mileage', 'car_age']
cat_cols = ['fuel_CNG', 'fuel_Diesel', 'fuel_LPG', 'fuel_Petrol', 
            'seller_Dealer', 'seller_Individual', 'seller_Trustmark Dealer',
            'trans_Automatic', 'trans_Manual', 
            'owner_0', 'owner_1', 'owner_2', 'owner_3', 'owner_4+']

# التحقق من وجود الأعمدة
num_cols = [col for col in num_cols if col in df.columns]
cat_cols = [col for col in cat_cols if col in df.columns]

print(f"\nالأعمدة الرقمية: {num_cols}")
print(f"الأعمدة الفئوية: {len(cat_cols)} عمود")

# ========================================
# 1. Histogram + KDE (للأعمدة الرقمية)
# ========================================
print("\n📊 إنشاء Histogram + KDE...")
for col in num_cols:
    plt.figure(figsize=(8, 4))
    sns.histplot(df[col], kde=True, color='steelblue')
    plt.title(f"Distribution of {col}")
    plt.xlabel(col)
    plt.ylabel("Frequency")
    plt.tight_layout()
    plt.savefig(os.path.join(IMG_DIR, f'hist_{col}.png'), dpi=150, bbox_inches='tight')
    plt.close()
    print(f"  ✓ hist_{col}.png")

# ========================================
# 2. Boxplots (كشف الشواذ Outliers)
# ========================================
print("\n📦 إنشاء Boxplots...")
for col in num_cols:
    plt.figure(figsize=(7, 4))
    sns.boxplot(x=df[col], color='coral')
    plt.title(f"Boxplot of {col}")
    plt.xlabel(col)
    plt.tight_layout()
    plt.savefig(os.path.join(IMG_DIR, f'boxplot_{col}.png'), dpi=150, bbox_inches='tight')
    plt.close()
    print(f"  ✓ boxplot_{col}.png")

# ========================================
# 3. علاقة الأعمدة الرقمية مع السعر (Scatter)
# ========================================
print("\n📈 إنشاء Scatter Plots...")
target = 'selling_price'
for col in num_cols:
    if col != target:
        plt.figure(figsize=(7, 4))
        sns.scatterplot(x=df[col], y=df[target], alpha=0.5, color='purple')
        plt.title(f"{col} vs {target}")
        plt.xlabel(col)
        plt.ylabel(target)
        plt.tight_layout()
        plt.savefig(os.path.join(IMG_DIR, f'scatter_{col}_vs_price.png'), dpi=150, bbox_inches='tight')
        plt.close()
        print(f"  ✓ scatter_{col}_vs_price.png")

# ========================================
# 4. Correlation Matrix (Heatmap)
# ========================================
print("\n🔥 إنشاء Correlation Heatmap...")
plt.figure(figsize=(12, 8))
corr_matrix = df[num_cols].corr()
sns.heatmap(corr_matrix, annot=True, cmap="coolwarm", center=0, 
            fmt='.2f', square=True, linewidths=0.5)
plt.title("Correlation Heatmap")
plt.tight_layout()
plt.savefig(os.path.join(IMG_DIR, 'correlation_heatmap.png'), dpi=150, bbox_inches='tight')
plt.close()
print("  ✓ correlation_heatmap.png")

# ========================================
# 5. Correlation (Plotly Interactive)
# ========================================
print("\n📊 إنشاء Interactive Correlation Matrix...")
fig = px.imshow(corr_matrix, 
                text_auto='.2f', 
                aspect="auto", 
                title="Interactive Correlation Matrix",
                color_continuous_scale='RdBu_r')
pio.write_html(fig, os.path.join(IMG_DIR, 'correlation_interactive.html'))
print("  ✓ correlation_interactive.html")

# ========================================
# 6. Pairplot (عينة صغيرة لتسريع العملية)
# ========================================
print("\n🔗 إنشاء Pairplot (عينة من البيانات)...")
sample_df = df[num_cols].sample(min(500, len(df)), random_state=42)
pairplot_fig = sns.pairplot(sample_df, diag_kind='kde', plot_kws={'alpha': 0.5})
pairplot_fig.savefig(os.path.join(IMG_DIR, 'pairplot.png'), dpi=100, bbox_inches='tight')
plt.close()
print("  ✓ pairplot.png")

# ========================================
# 7. Violin Plot (توزيع السعر حسب الفئات)
# ========================================
print("\n🎻 إنشاء Violin Plots...")

# إنشاء أعمدة فئوية مجمعة من الأعمدة المشفرة (one-hot)
# Fuel Type
fuel_cols = [c for c in df.columns if c.startswith('fuel_')]
if fuel_cols:
    df['Fuel_Type'] = df[fuel_cols].idxmax(axis=1).str.replace('fuel_', '')
    plt.figure(figsize=(10, 5))
    sns.violinplot(x='Fuel_Type', y=target, data=df, palette='Set2')
    plt.title(f"Violin Plot of {target} by Fuel Type")
    plt.xticks(rotation=45)
    plt.tight_layout()
    plt.savefig(os.path.join(IMG_DIR, 'violin_fuel_type.png'), dpi=150, bbox_inches='tight')
    plt.close()
    print("  ✓ violin_fuel_type.png")

# Seller Type
seller_cols = [c for c in df.columns if c.startswith('seller_')]
if seller_cols:
    df['Seller_Type'] = df[seller_cols].idxmax(axis=1).str.replace('seller_', '')
    plt.figure(figsize=(10, 5))
    sns.violinplot(x='Seller_Type', y=target, data=df, palette='Set3')
    plt.title(f"Violin Plot of {target} by Seller Type")
    plt.xticks(rotation=45)
    plt.tight_layout()
    plt.savefig(os.path.join(IMG_DIR, 'violin_seller_type.png'), dpi=150, bbox_inches='tight')
    plt.close()
    print("  ✓ violin_seller_type.png")

# Transmission
trans_cols = [c for c in df.columns if c.startswith('trans_')]
if trans_cols:
    df['Transmission'] = df[trans_cols].idxmax(axis=1).str.replace('trans_', '')
    plt.figure(figsize=(10, 5))
    sns.violinplot(x='Transmission', y=target, data=df, palette='Pastel1')
    plt.title(f"Violin Plot of {target} by Transmission")
    plt.tight_layout()
    plt.savefig(os.path.join(IMG_DIR, 'violin_transmission.png'), dpi=150, bbox_inches='tight')
    plt.close()
    print("  ✓ violin_transmission.png")

# Owner Count
owner_cols = [c for c in df.columns if c.startswith('owner_')]
if owner_cols:
    df['Owner_Count'] = df[owner_cols].idxmax(axis=1).str.replace('owner_', '')
    plt.figure(figsize=(10, 5))
    sns.violinplot(x='Owner_Count', y=target, data=df, palette='husl')
    plt.title(f"Violin Plot of {target} by Owner Count")
    plt.tight_layout()
    plt.savefig(os.path.join(IMG_DIR, 'violin_owner_count.png'), dpi=150, bbox_inches='tight')
    plt.close()
    print("  ✓ violin_owner_count.png")

# ========================================
# 8. Bar Plots (متوسط السعر حسب الفئات)
# ========================================
print("\n📊 إنشاء Bar Plots...")

# Fuel Type
if 'Fuel_Type' in df.columns:
    plt.figure(figsize=(10, 4))
    order = df.groupby('Fuel_Type')[target].mean().sort_values(ascending=False).index
    sns.barplot(x='Fuel_Type', y=target, data=df, order=order, palette='viridis', errorbar=None)
    plt.title(f"Average {target} by Fuel Type")
    plt.xticks(rotation=40)
    plt.tight_layout()
    plt.savefig(os.path.join(IMG_DIR, 'barplot_fuel_type.png'), dpi=150, bbox_inches='tight')
    plt.close()
    print("  ✓ barplot_fuel_type.png")

# Seller Type
if 'Seller_Type' in df.columns:
    plt.figure(figsize=(10, 4))
    order = df.groupby('Seller_Type')[target].mean().sort_values(ascending=False).index
    sns.barplot(x='Seller_Type', y=target, data=df, order=order, palette='magma', errorbar=None)
    plt.title(f"Average {target} by Seller Type")
    plt.xticks(rotation=40)
    plt.tight_layout()
    plt.savefig(os.path.join(IMG_DIR, 'barplot_seller_type.png'), dpi=150, bbox_inches='tight')
    plt.close()
    print("  ✓ barplot_seller_type.png")

# Transmission
if 'Transmission' in df.columns:
    plt.figure(figsize=(10, 4))
    order = df.groupby('Transmission')[target].mean().sort_values(ascending=False).index
    sns.barplot(x='Transmission', y=target, data=df, order=order, palette='plasma', errorbar=None)
    plt.title(f"Average {target} by Transmission")
    plt.tight_layout()
    plt.savefig(os.path.join(IMG_DIR, 'barplot_transmission.png'), dpi=150, bbox_inches='tight')
    plt.close()
    print("  ✓ barplot_transmission.png")

# Owner Count
if 'Owner_Count' in df.columns:
    plt.figure(figsize=(10, 4))
    order = df.groupby('Owner_Count')[target].mean().sort_values(ascending=False).index
    sns.barplot(x='Owner_Count', y=target, data=df, order=order, palette='cividis', errorbar=None)
    plt.title(f"Average {target} by Owner Count")
    plt.tight_layout()
    plt.savefig(os.path.join(IMG_DIR, 'barplot_owner_count.png'), dpi=150, bbox_inches='tight')
    plt.close()
    print("  ✓ barplot_owner_count.png")

# ========================================
# 9. Count Plots (للأعمدة الفئوية)
# ========================================
print("\n📊 إنشاء Count Plots...")

for cat in ['Fuel_Type', 'Seller_Type', 'Transmission', 'Owner_Count']:
    if cat in df.columns:
        plt.figure(figsize=(10, 4))
        order = df[cat].value_counts().index
        sns.countplot(x=df[cat], order=order, palette='Set2')
        plt.xticks(rotation=45)
        plt.title(f"Count Plot of {cat}")
        plt.tight_layout()
        plt.savefig(os.path.join(IMG_DIR, f'countplot_{cat.lower()}.png'), dpi=150, bbox_inches='tight')
        plt.close()
        print(f"  ✓ countplot_{cat.lower()}.png")

# ========================================
# 10. 3D Scatter (Engine, Mileage, Price)
# ========================================
print("\n🌐 إنشاء 3D Scatter Plot...")
if all(col in df.columns for col in ['engine', 'mileage', target]):
    sample_3d = df.sample(min(2000, len(df)), random_state=42)
    color_col = 'Fuel_Type' if 'Fuel_Type' in sample_3d.columns else None
    
    fig = px.scatter_3d(
        sample_3d, 
        x="engine", 
        y="mileage", 
        z=target,
        color=color_col,
        title="3D View: Engine vs Mileage vs Selling Price",
        opacity=0.7
    )
    pio.write_html(fig, os.path.join(IMG_DIR, '3d_scatter.html'))
    print("  ✓ 3d_scatter.html")

# ========================================
# 11. Distribution Summary (All Numeric)
# ========================================
print("\n📈 إنشاء Distribution Summary...")
fig, axes = plt.subplots(2, 4, figsize=(16, 8))
axes = axes.flatten()

for i, col in enumerate(num_cols[:8]):
    sns.histplot(df[col], kde=True, ax=axes[i], color='teal')
    axes[i].set_title(f'{col}')
    axes[i].set_xlabel('')

# إخفاء المحاور الفارغة
for j in range(len(num_cols), 8):
    axes[j].axis('off')

plt.suptitle('Distributions of Numerical Features', fontsize=16, y=1.02)
plt.tight_layout()
plt.savefig(os.path.join(IMG_DIR, 'distributions_summary.png'), dpi=150, bbox_inches='tight')
plt.close()
print("  ✓ distributions_summary.png")

# ========================================
# ملخص
# ========================================
print("\n" + "="*50)
print("✅ تم إنشاء جميع المخططات بنجاح!")
print(f"📁 المسار: {IMG_DIR}")

# عرض قائمة الملفات
files = sorted(os.listdir(IMG_DIR))
print(f"\n📊 عدد الملفات: {len(files)}")
for f in files:
    print(f"   • {f}")
