"""
🚗 Car Price Prediction Model Training
تدريب نموذج التنبؤ بأسعار السيارات باستخدام LightGBM
"""

import pandas as pd
import numpy as np
import json
import joblib
from pathlib import Path
from sklearn.preprocessing import LabelEncoder, StandardScaler
from sklearn.model_selection import train_test_split
from sklearn.metrics import mean_squared_error, r2_score, mean_absolute_error
import lightgbm as lgb
import warnings

warnings.filterwarnings('ignore')

# ===== CONFIGURATION =====
RANDOM_STATE = 42
TEST_SIZE = 0.2
VALIDATION_SIZE = 0.2

# ===== PATHS =====
DATA_PATH = Path('../dataset/cleaned_cars.csv')
OUTPUT_DIR = Path('..')

print("=" * 60)
print("🚗 Car Price Prediction Model Training")
print("=" * 60)

# ===== 1. LOAD DATA =====
print("\n📂 Loading data...")
try:
    df = pd.read_csv(DATA_PATH)
    print(f"✅ Data loaded: {df.shape[0]} rows, {df.shape[1]} columns")
except FileNotFoundError:
    print(f"❌ Error: Data file not found at {DATA_PATH}")
    exit(1)

# ===== 2. DATA EXPLORATION =====
print("\n📊 Data Overview:")
print(f"  - Columns: {list(df.columns)}")
print(f"  - Missing values: {df.isnull().sum().sum()}")
print(f"  - Data types:\n{df.dtypes}")

# ===== 3. FEATURE ENGINEERING =====
print("\n🔧 Feature Engineering...")

# Create car age feature
df['car_age'] = 2025 - df['year']

# Separate features and target
X = df.drop(columns=['selling_price'])
y = df['selling_price']

print(f"  - Target variable: selling_price")
print(f"  - Features before encoding: {X.shape[1]}")

# ===== 4. ENCODING CATEGORICAL VARIABLES =====
print("\n🏷️  Encoding categorical variables...")

# Label encoding for car name
name_le = LabelEncoder()
X['name_le'] = name_le.fit_transform(X['name'])
X = X.drop(columns=['name'])

# One-hot encoding for categorical variables
categorical_cols = ['fuel', 'seller_type', 'transmission', 'owner']
X_encoded = pd.get_dummies(X, columns=categorical_cols, drop_first=False)

print(f"  - Features after encoding: {X_encoded.shape[1]}")
print(f"  - Categorical columns: {categorical_cols}")

# ===== 5. FEATURE SCALING =====
print("\n📏 Scaling numerical features...")

numerical_cols = ['km_driven', 'engine', 'max_power', 'mileage', 'seats', 'car_age']
scaler = StandardScaler()
X_scaled = X_encoded.copy()
X_scaled[numerical_cols] = scaler.fit_transform(X_encoded[numerical_cols])

print(f"  - Scaled columns: {numerical_cols}")

# ===== 6. TARGET TRANSFORMATION =====
print("\n🔄 Transforming target variable...")

# Log transformation for target
y_transformed = np.log1p(y)
print(f"  - Original target range: {y.min():.2f} - {y.max():.2f}")
print(f"  - Transformed target range: {y_transformed.min():.2f} - {y_transformed.max():.2f}")

# ===== 7. TRAIN-TEST SPLIT =====
print("\n✂️  Splitting data...")

X_train, X_test, y_train, y_test = train_test_split(
    X_scaled, y_transformed, test_size=TEST_SIZE, random_state=RANDOM_STATE
)

print(f"  - Training set: {X_train.shape[0]} samples")
print(f"  - Test set: {X_test.shape[0]} samples")

# ===== 8. MODEL TRAINING =====
print("\n🤖 Training LightGBM model...")

# LightGBM parameters
lgb_params = {
    'objective': 'regression',
    'metric': 'rmse',
    'num_leaves': 31,
    'learning_rate': 0.05,
    'feature_fraction': 0.8,
    'bagging_fraction': 0.8,
    'bagging_freq': 5,
    'verbose': -1,
    'random_state': RANDOM_STATE
}

# Create LightGBM dataset
train_data = lgb.Dataset(X_train, label=y_train)
valid_data = lgb.Dataset(X_test, label=y_test, reference=train_data)

# Train model
model = lgb.train(
    lgb_params,
    train_data,
    num_boost_round=1000,
    valid_sets=[train_data, valid_data],
    valid_names=['train', 'valid'],
    callbacks=[
        lgb.early_stopping(50),
        lgb.log_evaluation(period=100)
    ]
)

print("✅ Model training completed!")

# ===== 9. MODEL EVALUATION =====
print("\n📈 Model Evaluation:")

# Predictions
y_train_pred = model.predict(X_train)
y_test_pred = model.predict(X_test)

# Inverse transform predictions
y_train_pred_original = np.expm1(y_train_pred)
y_test_pred_original = np.expm1(y_test_pred)
y_train_original = np.expm1(y_train)
y_test_original = np.expm1(y_test)

# Metrics
train_rmse = np.sqrt(mean_squared_error(y_train, y_train_pred))
test_rmse = np.sqrt(mean_squared_error(y_test, y_test_pred))
train_mae = mean_absolute_error(y_train_original, y_train_pred_original)
test_mae = mean_absolute_error(y_test_original, y_test_pred_original)
train_r2 = r2_score(y_train, y_train_pred)
test_r2 = r2_score(y_test, y_test_pred)

print(f"  Training RMSE: {train_rmse:.4f}")
print(f"  Test RMSE: {test_rmse:.4f}")
print(f"  Training MAE: ₹{train_mae:.2f}")
print(f"  Test MAE: ₹{test_mae:.2f}")
print(f"  Training R²: {train_r2:.4f}")
print(f"  Test R²: {test_r2:.4f}")

# ===== 10. FEATURE IMPORTANCE =====
print("\n🎯 Top 10 Important Features:")

feature_importance = pd.DataFrame({
    'feature': X_scaled.columns,
    'importance': model.feature_importance()
}).sort_values('importance', ascending=False)

for idx, row in feature_importance.head(10).iterrows():
    print(f"  {row['feature']}: {row['importance']:.4f}")

# ===== 11. SAVE MODEL AND ARTIFACTS =====
print("\n💾 Saving model and artifacts...")

# Save model
model_path = OUTPUT_DIR / 'lgbm_model.pkl'
joblib.dump(model, model_path)
print(f"  ✅ Model saved: {model_path}")

# Save feature names
features_path = OUTPUT_DIR / 'lgbm_features.txt'
with open(features_path, 'w', encoding='utf-8') as f:
    f.write('\n'.join(X_scaled.columns))
print(f"  ✅ Features saved: {features_path}")

# Save metadata
meta = {
    'target_transform': 'log1p',
    'inverse_transform': 'expm1',
    'num_features': X_scaled.shape[1],
    'train_rmse': float(train_rmse),
    'test_rmse': float(test_rmse),
    'train_r2': float(train_r2),
    'test_r2': float(test_r2),
    'best_iteration': model.best_iteration
}
meta_path = OUTPUT_DIR / 'lgbm_meta.json'
with open(meta_path, 'w', encoding='utf-8') as f:
    json.dump(meta, f, indent=2)
print(f"  ✅ Metadata saved: {meta_path}")

# Save scaler parameters
scaler_params = {
    'means': {col: float(mean) for col, mean in zip(numerical_cols, scaler.mean_)},
    'scales': {col: float(scale) for col, scale in zip(numerical_cols, scaler.scale_)}
}
scaler_path = OUTPUT_DIR / 'scaler_params.json'
with open(scaler_path, 'w', encoding='utf-8') as f:
    json.dump(scaler_params, f, indent=2)
print(f"  ✅ Scaler params saved: {scaler_path}")

# Save name label encoder mapping
name_mapping = {name: int(code) for name, code in zip(name_le.classes_, name_le.transform(name_le.classes_))}
name_path = OUTPUT_DIR / 'name_le_mapping.json'
with open(name_path, 'w', encoding='utf-8') as f:
    json.dump(name_mapping, f, indent=2, ensure_ascii=False)
print(f"  ✅ Name mapping saved: {name_path}")

# Save categorical levels
cat_levels = {}
for col in categorical_cols:
    cat_levels[col] = sorted(df[col].unique().tolist())
cat_path = OUTPUT_DIR / 'categorical_levels.json'
with open(cat_path, 'w', encoding='utf-8') as f:
    json.dump(cat_levels, f, indent=2, ensure_ascii=False)
print(f"  ✅ Categorical levels saved: {cat_path}")

# ===== 12. SUMMARY =====
print("\n" + "=" * 60)
print("✅ Training completed successfully!")
print("=" * 60)
print(f"\n📊 Model Summary:")
print(f"  - Test RMSE: ₹{test_rmse:.4f}")
print(f"  - Test MAE: ₹{test_mae:.2f}")
print(f"  - Test R²: {test_r2:.4f}")
print(f"  - Features: {X_scaled.shape[1]}")
print(f"  - Training samples: {X_train.shape[0]}")
print(f"\n💾 Saved files:")
print(f"  - lgbm_model.pkl")
print(f"  - lgbm_features.txt")
print(f"  - lgbm_meta.json")
print(f"  - scaler_params.json")
print(f"  - name_le_mapping.json")
print(f"  - categorical_levels.json")
print("\n🚀 Ready for deployment!")
