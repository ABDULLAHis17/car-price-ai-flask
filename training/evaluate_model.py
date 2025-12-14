"""
📊 Model Evaluation and Visualization
تقييم وتصور أداء النموذج
"""

import pandas as pd
import numpy as np
import json
import joblib
from pathlib import Path
from sklearn.preprocessing import LabelEncoder, StandardScaler
from sklearn.metrics import mean_squared_error, r2_score, mean_absolute_error, mean_absolute_percentage_error
import matplotlib.pyplot as plt
import seaborn as sns

# ===== CONFIGURATION =====
plt.style.use('seaborn-v0_8-darkgrid')
sns.set_palette("husl")

# ===== PATHS =====
DATA_PATH = Path('../dataset/cleaned_cars.csv')
MODEL_PATH = Path('../lgbm_model.pkl')
FEATURES_PATH = Path('../lgbm_features.txt')
META_PATH = Path('../lgbm_meta.json')
SCALER_PATH = Path('../scaler_params.json')
NAME_MAPPING_PATH = Path('../name_le_mapping.json')

print("=" * 60)
print("📊 Model Evaluation")
print("=" * 60)

# ===== 1. LOAD DATA =====
print("\n📂 Loading data...")
df = pd.read_csv(DATA_PATH)
model = joblib.load(MODEL_PATH)

with open(FEATURES_PATH, 'r') as f:
    feature_names = [line.strip() for line in f if line.strip()]

with open(META_PATH, 'r') as f:
    meta = json.load(f)

with open(SCALER_PATH, 'r') as f:
    scaler_params = json.load(f)

with open(NAME_MAPPING_PATH, 'r') as f:
    name_mapping = json.load(f)

print(f"✅ Data loaded: {df.shape[0]} rows")
print(f"✅ Model loaded with {len(feature_names)} features")

# ===== 2. PREPARE DATA =====
print("\n🔧 Preparing data...")

df['car_age'] = 2025 - df['year']
X = df.drop(columns=['selling_price'])
y = df['selling_price']

# Encode
name_le = LabelEncoder()
name_le.fit(X['name'])
X['name_le'] = name_le.transform(X['name'])
X = X.drop(columns=['name'])

# One-hot encode
categorical_cols = ['fuel', 'seller_type', 'transmission', 'owner']
X_encoded = pd.get_dummies(X, columns=categorical_cols, drop_first=False)

# Scale
numerical_cols = ['km_driven', 'engine', 'max_power', 'mileage', 'seats', 'car_age']
scaler = StandardScaler()
X_scaled = X_encoded.copy()
X_scaled[numerical_cols] = scaler.fit_transform(X_encoded[numerical_cols])

# Align with training features
X_scaled = X_scaled.reindex(columns=feature_names, fill_value=0)

# Transform target
y_transformed = np.log1p(y)

print(f"✅ Data prepared: {X_scaled.shape}")

# ===== 3. PREDICTIONS =====
print("\n🤖 Making predictions...")

y_pred_transformed = model.predict(X_scaled)
y_pred = np.expm1(y_pred_transformed)

print(f"✅ Predictions made for {len(y_pred)} samples")

# ===== 4. METRICS =====
print("\n📈 Model Metrics:")

rmse = np.sqrt(mean_squared_error(y, y_pred))
mae = mean_absolute_error(y, y_pred)
r2 = r2_score(y_transformed, y_pred_transformed)
mape = mean_absolute_percentage_error(y, y_pred)

print(f"  - RMSE: ₹{rmse:.2f}")
print(f"  - MAE: ₹{mae:.2f}")
print(f"  - MAPE: {mape:.2f}%")
print(f"  - R² Score: {r2:.4f}")

# ===== 5. RESIDUALS ANALYSIS =====
print("\n📊 Residuals Analysis:")

residuals = y - y_pred
residuals_pct = (residuals / y) * 100

print(f"  - Mean residual: ₹{residuals.mean():.2f}")
print(f"  - Std residual: ₹{residuals.std():.2f}")
print(f"  - Min residual: ₹{residuals.min():.2f}")
print(f"  - Max residual: ₹{residuals.max():.2f}")
print(f"  - Mean % error: {residuals_pct.mean():.2f}%")

# ===== 6. FEATURE IMPORTANCE =====
print("\n🎯 Top 15 Important Features:")

feature_importance = pd.DataFrame({
    'feature': feature_names,
    'importance': model.feature_importance()
}).sort_values('importance', ascending=False)

for idx, (_, row) in enumerate(feature_importance.head(15).iterrows(), 1):
    print(f"  {idx:2d}. {row['feature']:30s} {row['importance']:8.4f}")

# ===== 7. VISUALIZATION =====
print("\n📊 Creating visualizations...")

fig, axes = plt.subplots(2, 2, figsize=(14, 10))
fig.suptitle('🚗 Car Price Prediction Model Evaluation', fontsize=16, fontweight='bold')

# Plot 1: Actual vs Predicted
ax1 = axes[0, 0]
ax1.scatter(y, y_pred, alpha=0.5, s=20)
ax1.plot([y.min(), y.max()], [y.min(), y.max()], 'r--', lw=2)
ax1.set_xlabel('Actual Price (₹)')
ax1.set_ylabel('Predicted Price (₹)')
ax1.set_title(f'Actual vs Predicted (R² = {r2:.4f})')
ax1.grid(True, alpha=0.3)

# Plot 2: Residuals
ax2 = axes[0, 1]
ax2.scatter(y_pred, residuals, alpha=0.5, s=20)
ax2.axhline(y=0, color='r', linestyle='--', lw=2)
ax2.set_xlabel('Predicted Price (₹)')
ax2.set_ylabel('Residuals (₹)')
ax2.set_title('Residual Plot')
ax2.grid(True, alpha=0.3)

# Plot 3: Feature Importance
ax3 = axes[1, 0]
top_features = feature_importance.head(10)
ax3.barh(range(len(top_features)), top_features['importance'].values)
ax3.set_yticks(range(len(top_features)))
ax3.set_yticklabels(top_features['feature'].values)
ax3.set_xlabel('Importance')
ax3.set_title('Top 10 Feature Importance')
ax3.invert_yaxis()

# Plot 4: Error Distribution
ax4 = axes[1, 1]
ax4.hist(residuals_pct, bins=50, edgecolor='black', alpha=0.7)
ax4.axvline(x=residuals_pct.mean(), color='r', linestyle='--', lw=2, label=f'Mean: {residuals_pct.mean():.2f}%')
ax4.set_xlabel('Percentage Error (%)')
ax4.set_ylabel('Frequency')
ax4.set_title('Error Distribution')
ax4.legend()
ax4.grid(True, alpha=0.3)

plt.tight_layout()
plt.savefig('../model_evaluation.png', dpi=300, bbox_inches='tight')
print("✅ Visualization saved: model_evaluation.png")

# ===== 8. SAMPLE PREDICTIONS =====
print("\n🎯 Sample Predictions:")
print("-" * 80)
print(f"{'Car':<20} {'Actual Price':<15} {'Predicted':<15} {'Error %':<10}")
print("-" * 80)

sample_indices = np.random.choice(len(df), min(10, len(df)), replace=False)
for idx in sample_indices:
    car_name = df.iloc[idx]['name']
    actual = y.iloc[idx]
    predicted = y_pred.iloc[idx]
    error_pct = ((predicted - actual) / actual) * 100
    print(f"{car_name:<20} ₹{actual:<14,.0f} ₹{predicted:<14,.0f} {error_pct:>8.2f}%")

print("-" * 80)

# ===== 9. SUMMARY =====
print("\n" + "=" * 60)
print("✅ Evaluation completed!")
print("=" * 60)
print(f"\n📊 Summary:")
print(f"  - RMSE: ₹{rmse:.2f}")
print(f"  - MAE: ₹{mae:.2f}")
print(f"  - R² Score: {r2:.4f}")
print(f"  - Mean Error: {residuals_pct.mean():.2f}%")
print(f"\n📈 Visualization saved: model_evaluation.png")
