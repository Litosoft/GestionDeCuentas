using System;

namespace SGSE.Data.Helpers
{
    public class DataUtil
    {
        #region Numericos

        /// <summary>Devuelve un Int32 a partir de un objeto</summary>
        public static int ObjectToInt(object obj)
        {
            try
            {
                return ((obj == null) || (obj == DBNull.Value)) ? 0 : Convert.ToInt32(obj);
            }
            catch (Exception ex)
            {
                return 0;
            }
        }

        /// <summary>Devuelve un Int16 a partir de un objeto</summary>
        public static short ObjectToInt16(object obj)
        {
            return ((obj == null) || (obj == DBNull.Value)) ? short.MinValue : Convert.ToInt16(obj);
        }

        /// <summary>Devuelve un Byte a partir de un objeto</summary>
        public static byte ObjectToByte(object obj)
        {
            return ((obj == null) || (obj == DBNull.Value)) ? byte.MinValue : Convert.ToByte(obj);
        }

        /// <summary>Devuelve un Decimal a partir de un objeto</summary>
        public static decimal ObjectToDecimal(object obj)
        {
            try
            {
                return ((obj == null) || (obj == DBNull.Value)) ? 0.00M : Convert.ToDecimal(obj);
            }
            catch (Exception ex)
            {
                return 0;
            }
        }

        /// <summary>Devuelve un Double a partir de un objeto</summary>
        public static double ObjectToDouble(object obj)
        {
            try
            {
                return ((obj == null) || (obj == DBNull.Value)) ? 0 : Convert.ToDouble(obj);
            }
            catch (Exception ex)
            {
                return 0;
            }
        }

        #endregion

        /// <summary>Devuelve un String a partir de un objeto</summary>
        public static string ObjectToString(object obj)
        {
            try
            {
                return ((obj == null) || (obj == DBNull.Value)) ? string.Empty : Convert.ToString(obj);

            }
            catch (Exception ex)
            {
                return string.Empty;
            }
        }

        /// <summary>Devuelve un Boolean a partir de un objeto</summary>
        public static bool ObjectToBoolean(object obj)
        {
            try
            {
                return ((obj == null) || (obj == DBNull.Value)) ? false : Convert.ToBoolean(obj);

            }
            catch (Exception ex)
            {
                return false;
            }
        }

    }
}
