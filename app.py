# -*- coding: utf-8 -*-
"""
🚗 Car Price Prediction API
نظام التنبؤ بأسعار السيارات - Backend API
"""

from flask import Flask, jsonify, request
from flask_cors import CORS
import json
import os
from pathlib import Path
import joblib
import numpy as np
import pandas as pd
import logging
from datetime import datetime
from database import get_database

# إعداد Logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

app = Flask(__name__)
CORS(app)

# ===== PATHS =====
BASE_DIR = Path(__file__).parent
FEATURES_PATH = BASE_DIR / 'lgbm_features.txt'
MODEL_PATH = BASE_DIR / 'lgbm_model.pkl'
META_PATH = BASE_DIR / 'lgbm_meta.json'
SCALER_JSON = BASE_DIR / 'scaler_params.json'
NAME_LE_JSON = BASE_DIR / 'name_le_mapping.json'
CATLEVELS_JSON = BASE_DIR / 'categorical_levels.json'

# ===== LOAD ASSETS =====
def load_features():
    feats = FEATURES_PATH.read_text(encoding='utf-8').splitlines()
    return [f for f in feats if f]

def load_model():
    return joblib.load(MODEL_PATH)

def load_meta():
    if META_PATH.exists():
        try:
            return json.loads(META_PATH.read_text(encoding='utf-8'))
        except:
            return {}
    return {}

def load_json_file(path):
    try:
        if path.exists():
            return json.loads(path.read_text(encoding='utf-8'))
    except:
        pass
    return {}

# تحميل جميع الأصول
try:
    # تحميل قاعدة البيانات
    db = get_database()
    df = db.df
    
    feature_names = load_features()
    model = load_model()
    meta = load_meta()
    scaler_params = load_json_file(SCALER_JSON)
    name_le_map = load_json_file(NAME_LE_JSON)
    cat_levels = load_json_file(CATLEVELS_JSON)
    logger.info("✅ تم تحميل جميع الأصول بنجاح")
except Exception as e:
    logger.error(f"❌ خطأ في تحميل الأصول: {e}")
    db = None
    df = None
    feature_names = []
    model = None
    meta = {}
    scaler_params = {}
    name_le_map = {}
    cat_levels = {}

# ===== HELPER FUNCTIONS =====
def validate_input(data, required_fields):
    """التحقق من وجود جميع الحقول المطلوبة"""
    for field in required_fields:
        if field not in data:
            return False, f"الحقل المطلوب '{field}' غير موجود"
    return True, "OK"

def format_price(price):
    """تنسيق السعر بصيغة محلية"""
    return f"{int(price):,}"

# ===== API ENDPOINTS =====

@app.route('/api/health', methods=['GET'])
def health_check():
    """فحص صحة الخادم"""
    return jsonify({
        'status': 'healthy',
        'timestamp': datetime.now().isoformat(),
        'model_loaded': model is not None,
        'data_loaded': df is not None
    })

@app.route('/api/car-names', methods=['GET'])
def get_car_names():
    """الحصول على قائمة أسماء السيارات"""
    try:
        names = sorted(list(name_le_map.keys())) if name_le_map else []
        return jsonify({
            'success': True,
            'names': names,
            'count': len(names)
        })
    except Exception as e:
        logger.error(f"خطأ في get_car_names: {e}")
        return jsonify({'success': False, 'error': str(e)}), 500

@app.route('/api/car-info', methods=['GET'])
def get_car_info():
    """الحصول على معلومات السيارات (الفئات المتاحة)"""
    try:
        info = {
            'fuel_types': cat_levels.get('fuel', []),
            'seller_types': cat_levels.get('seller_type', []),
            'transmissions': cat_levels.get('transmission', []),
            'owner_counts': cat_levels.get('owner', [])
        }
        return jsonify({'success': True, 'info': info})
    except Exception as e:
        logger.error(f"خطأ في get_car_info: {e}")
        return jsonify({'success': False, 'error': str(e)}), 500

@app.route('/api/predict-row', methods=['POST'])
def predict_row():
    """التنبؤ بسعر سيارة من صف في البيانات"""
    try:
        data = request.json
        row_idx = data.get('row_index', 0)
        
        if df is None:
            return jsonify({'success': False, 'error': 'البيانات غير محملة'}), 500
        
        if row_idx < 0 or row_idx >= len(df):
            return jsonify({'success': False, 'error': f'رقم الصف غير صحيح (0-{len(df)-1})'}), 400
        
        X_row = df.drop(columns=['selling_price']).iloc[[int(row_idx)]].copy()
        X_row = X_row.reindex(columns=feature_names, fill_value=0)
        
        # التنبؤ
        num_iter = getattr(model, 'best_iteration_', None)
        if num_iter is not None:
            y_pred_raw = model.predict(X_row, num_iteration=num_iter)[0]
        else:
            y_pred_raw = model.predict(X_row)[0]
        
        # عكس التحويل
        transform = meta.get('target_transform')
        inverse = meta.get('inverse_transform')
        if transform == 'log1p' and inverse == 'expm1':
            y_pred = float(np.expm1(y_pred_raw))
        else:
            y_pred = float(y_pred_raw)
        
        if y_pred < 0:
            y_pred = 0.0
        
        y_true = float(df.iloc[int(row_idx)]['selling_price']) if 'selling_price' in df.columns else 0.0
        
        return jsonify({
            'success': True,
            'predicted_price': y_pred,
            'real_price': y_true,
            'row_index': int(row_idx)
        })
    except Exception as e:
        logger.error(f"خطأ في predict_row: {e}")
        return jsonify({'success': False, 'error': str(e)}), 500

@app.route('/api/predict-manual', methods=['POST'])
def predict_manual():
    """التنبؤ بسعر سيارة من إدخال يدوي"""
    try:
        data = request.json
        
        # التحقق من الحقول المطلوبة
        required = ['car_name', 'year', 'km', 'engine', 'power', 'mileage', 'seats', 'fuel', 'transmission', 'seller', 'owner']
        is_valid, msg = validate_input(data, required)
        if not is_valid:
            return jsonify({'success': False, 'error': msg}), 400
        
        # بناء الميزات
        features = {
            'km_driven': float(data.get('km', 0)),
            'engine': float(data.get('engine', 0)),
            'max_power': float(data.get('power', 0)),
            'seats': float(data.get('seats', 0)),
            'mileage': float(data.get('mileage', 0)),
            'name_le': float(name_le_map.get(data.get('car_name', ''), 0)) if name_le_map else 0.0,
            'car_age': float(2025 - int(data.get('year', 2025))),
        }
        
        # تطبيع الميزات
        means = scaler_params.get('means', {})
        scales = scaler_params.get('scales', {})
        for c in ['km_driven', 'engine', 'max_power', 'mileage', 'seats', 'car_age']:
            if c in means and c in scales and scales.get(c, 0) not in (0, None):
                features[c] = (features[c] - means[c]) / scales[c]
        
        # ترميز One-hot
        onehots = {
            f'fuel_{data.get("fuel", "")}': 1,
            f'seller_{data.get("seller", "")}': 1,
            f'trans_{data.get("transmission", "")}': 1,
            f'owner_{data.get("owner", "")}': 1,
        }
        
        # بناء الصف
        row = {}
        for col in feature_names:
            if col in features:
                row[col] = features[col]
            elif col in onehots:
                row[col] = 1
            else:
                row[col] = 0
        
        X_manual = pd.DataFrame([row], columns=feature_names)
        
        # التنبؤ
        num_iter = getattr(model, 'best_iteration_', None)
        if num_iter is not None:
            y_pred_raw = model.predict(X_manual, num_iteration=num_iter)[0]
        else:
            y_pred_raw = model.predict(X_manual)[0]
        
        # عكس التحويل
        transform = meta.get('target_transform')
        inverse = meta.get('inverse_transform')
        if transform == 'log1p' and inverse == 'expm1':
            y_pred = float(np.expm1(y_pred_raw))
        else:
            y_pred = float(y_pred_raw)
        
        if y_pred < 0:
            y_pred = 0.0
        
        return jsonify({
            'success': True,
            'predicted_price': y_pred
        })
    except Exception as e:
        logger.error(f"خطأ في predict_manual: {e}")
        return jsonify({'success': False, 'error': str(e)}), 500

@app.route('/api/model-info', methods=['GET'])
def get_model_info():
    """الحصول على معلومات النموذج"""
    try:
        return jsonify({
            'success': True,
            'info': meta
        })
    except Exception as e:
        logger.error(f"خطأ في get_model_info: {e}")
        return jsonify({'success': False, 'error': str(e)}), 500

@app.route('/api/database/stats', methods=['GET'])
def get_database_stats():
    """الحصول على إحصائيات قاعدة البيانات"""
    try:
        if db is None:
            return jsonify({'success': False, 'error': 'قاعدة البيانات غير محملة'}), 500
        
        stats = db.get_statistics()
        return jsonify({
            'success': True,
            'stats': stats
        })
    except Exception as e:
        logger.error(f"خطأ في get_database_stats: {e}")
        return jsonify({'success': False, 'error': str(e)}), 500

@app.route('/api/database/cars', methods=['GET'])
def get_all_cars():
    """الحصول على جميع السيارات من قاعدة البيانات"""
    try:
        if db is None:
            return jsonify({'success': False, 'error': 'قاعدة البيانات غير محملة'}), 500
        
        limit = request.args.get('limit', type=int)
        offset = request.args.get('offset', default=0, type=int)
        
        cars = db.get_all_cars(limit=limit, offset=offset)
        return jsonify({
            'success': True,
            'cars': cars,
            'total': db.get_row_count(),
            'count': len(cars)
        })
    except Exception as e:
        logger.error(f"خطأ في get_all_cars: {e}")
        return jsonify({'success': False, 'error': str(e)}), 500

@app.route('/api/database/car/<int:index>', methods=['GET'])
def get_car_by_index(index):
    """الحصول على سيارة محددة من قاعدة البيانات"""
    try:
        if db is None:
            return jsonify({'success': False, 'error': 'قاعدة البيانات غير محملة'}), 500
        
        car = db.get_car_by_index(index)
        if car is None:
            return jsonify({'success': False, 'error': 'السيارة غير موجودة'}), 404
        
        return jsonify({
            'success': True,
            'car': car,
            'index': index
        })
    except Exception as e:
        logger.error(f"خطأ في get_car_by_index: {e}")
        return jsonify({'success': False, 'error': str(e)}), 500

@app.route('/api/database/search', methods=['GET'])
def search_cars():
    """البحث عن السيارات في قاعدة البيانات"""
    try:
        if db is None:
            return jsonify({'success': False, 'error': 'قاعدة البيانات غير محملة'}), 500
        
        query = request.args.get('q', '')
        column = request.args.get('column', 'name_le')
        
        if not query:
            return jsonify({'success': False, 'error': 'نص البحث مطلوب'}), 400
        
        results = db.search_cars(query, column)
        return jsonify({
            'success': True,
            'results': results,
            'count': len(results)
        })
    except Exception as e:
        logger.error(f"خطأ في search_cars: {e}")
        return jsonify({'success': False, 'error': str(e)}), 500

@app.route('/api/database/range/<column>', methods=['GET'])
def get_data_range(column):
    """الحصول على نطاق البيانات لعمود معين"""
    try:
        if db is None:
            return jsonify({'success': False, 'error': 'قاعدة البيانات غير محملة'}), 500
        
        data_range = db.get_data_range(column)
        if not data_range:
            return jsonify({'success': False, 'error': 'العمود غير موجود'}), 404
        
        return jsonify({
            'success': True,
            'column': column,
            'range': data_range
        })
    except Exception as e:
        logger.error(f"خطأ في get_data_range: {e}")
        return jsonify({'success': False, 'error': str(e)}), 500

@app.errorhandler(404)
def not_found(error):
    return jsonify({'success': False, 'error': 'الـ Endpoint غير موجود'}), 404

@app.errorhandler(500)
def internal_error(error):
    return jsonify({'success': False, 'error': 'خطأ في الخادم'}), 500

if __name__ == '__main__':
    logger.info("🚀 بدء تشغيل الخادم على المنفذ 5000...")
    app.run(debug=False, port=5000, host='0.0.0.0', use_reloader=False)
