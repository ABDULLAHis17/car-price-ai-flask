# -*- coding: utf-8 -*-
"""
قاعدة بيانات السيارات - Car Database
نظام إدارة البيانات الموحد للويب و Flutter
"""

import pandas as pd
import json
from pathlib import Path
from typing import List, Dict, Any, Optional
import logging

logger = logging.getLogger(__name__)

class CarDatabase:
    """
    فئة قاعدة البيانات الموحدة
    تعمل مع نفس البيانات للويب و Flutter
    """
    
    def __init__(self, csv_path: str):
        """
        تهيئة قاعدة البيانات
        
        Args:
            csv_path: مسار ملف CSV
        """
        self.csv_path = Path(csv_path)
        self.df = None
        self.load_data()
        
    def load_data(self):
        """تحميل البيانات من CSV"""
        try:
            self.df = pd.read_csv(self.csv_path)
            logger.info(f"✅ تم تحميل البيانات: {len(self.df)} صف")
        except Exception as e:
            logger.error(f"❌ خطأ في تحميل البيانات: {e}")
            raise
    
    def get_all_cars(self, limit: int = None, offset: int = 0) -> List[Dict[str, Any]]:
        """
        الحصول على جميع السيارات
        
        Args:
            limit: عدد الصفوف المطلوبة
            offset: موضع البداية
            
        Returns:
            قائمة بيانات السيارات
        """
        try:
            if limit:
                data = self.df.iloc[offset:offset+limit]
            else:
                data = self.df.iloc[offset:]
            
            return data.to_dict('records')
        except Exception as e:
            logger.error(f"خطأ في get_all_cars: {e}")
            return []
    
    def get_car_by_index(self, index: int) -> Optional[Dict[str, Any]]:
        """
        الحصول على سيارة بواسطة الفهرس
        
        Args:
            index: فهرس الصف
            
        Returns:
            بيانات السيارة أو None
        """
        try:
            if 0 <= index < len(self.df):
                return self.df.iloc[index].to_dict()
            return None
        except Exception as e:
            logger.error(f"خطأ في get_car_by_index: {e}")
            return None
    
    def get_car_names(self) -> List[str]:
        """
        الحصول على قائمة أسماء السيارات الفريدة
        
        Returns:
            قائمة الأسماء
        """
        try:
            # الحصول على الأسماء من name_le_mapping.json
            mapping_path = Path(__file__).parent / 'name_le_mapping.json'
            if mapping_path.exists():
                with open(mapping_path, 'r', encoding='utf-8') as f:
                    mapping = json.load(f)
                    return sorted(list(mapping.keys()))
            return []
        except Exception as e:
            logger.error(f"خطأ في get_car_names: {e}")
            return []
    
    def get_fuel_types(self) -> List[str]:
        """الحصول على أنواع الوقود"""
        try:
            mapping_path = Path(__file__).parent / 'categorical_levels.json'
            if mapping_path.exists():
                with open(mapping_path, 'r', encoding='utf-8') as f:
                    data = json.load(f)
                    return data.get('fuel', [])
            return []
        except Exception as e:
            logger.error(f"خطأ في get_fuel_types: {e}")
            return []
    
    def get_seller_types(self) -> List[str]:
        """الحصول على أنواع البائعين"""
        try:
            mapping_path = Path(__file__).parent / 'categorical_levels.json'
            if mapping_path.exists():
                with open(mapping_path, 'r', encoding='utf-8') as f:
                    data = json.load(f)
                    return data.get('seller_type', [])
            return []
        except Exception as e:
            logger.error(f"خطأ في get_seller_types: {e}")
            return []
    
    def get_transmissions(self) -> List[str]:
        """الحصول على أنواع الناقل"""
        try:
            mapping_path = Path(__file__).parent / 'categorical_levels.json'
            if mapping_path.exists():
                with open(mapping_path, 'r', encoding='utf-8') as f:
                    data = json.load(f)
                    return data.get('transmission', [])
            return []
        except Exception as e:
            logger.error(f"خطأ في get_transmissions: {e}")
            return []
    
    def get_owner_counts(self) -> List[str]:
        """الحصول على عدد المالكين"""
        try:
            mapping_path = Path(__file__).parent / 'categorical_levels.json'
            if mapping_path.exists():
                with open(mapping_path, 'r', encoding='utf-8') as f:
                    data = json.load(f)
                    return data.get('owner', [])
            return []
        except Exception as e:
            logger.error(f"خطأ في get_owner_counts: {e}")
            return []
    
    def get_statistics(self) -> Dict[str, Any]:
        """
        الحصول على إحصائيات البيانات
        
        Returns:
            قاموس بالإحصائيات
        """
        try:
            return {
                'total_cars': len(self.df),
                'columns': list(self.df.columns),
                'numeric_columns': self.df.select_dtypes(include=['number']).columns.tolist(),
                'categorical_columns': self.df.select_dtypes(include=['object']).columns.tolist(),
                'memory_usage': str(self.df.memory_usage(deep=True).sum()),
            }
        except Exception as e:
            logger.error(f"خطأ في get_statistics: {e}")
            return {}
    
    def search_cars(self, query: str, column: str = 'name_le') -> List[Dict[str, Any]]:
        """
        البحث عن السيارات
        
        Args:
            query: نص البحث
            column: العمود المراد البحث فيه
            
        Returns:
            قائمة النتائج
        """
        try:
            if column in self.df.columns:
                mask = self.df[column].astype(str).str.contains(query, case=False, na=False)
                return self.df[mask].to_dict('records')
            return []
        except Exception as e:
            logger.error(f"خطأ في search_cars: {e}")
            return []
    
    def get_data_range(self, column: str) -> Dict[str, Any]:
        """
        الحصول على نطاق البيانات لعمود معين
        
        Args:
            column: اسم العمود
            
        Returns:
            قاموس بـ min و max و mean
        """
        try:
            if column in self.df.columns:
                col_data = pd.to_numeric(self.df[column], errors='coerce')
                return {
                    'min': float(col_data.min()),
                    'max': float(col_data.max()),
                    'mean': float(col_data.mean()),
                    'median': float(col_data.median()),
                    'std': float(col_data.std()),
                }
            return {}
        except Exception as e:
            logger.error(f"خطأ في get_data_range: {e}")
            return {}
    
    def get_row_count(self) -> int:
        """الحصول على عدد الصفوف"""
        return len(self.df) if self.df is not None else 0
    
    def refresh(self):
        """تحديث البيانات من الملف"""
        self.load_data()
        logger.info("✅ تم تحديث البيانات")


# إنشاء instance عام من قاعدة البيانات
def get_database() -> CarDatabase:
    """الحصول على instance قاعدة البيانات"""
    csv_path = Path(__file__).parent / 'dataset' / 'cleaned_cars.csv'
    return CarDatabase(str(csv_path))
