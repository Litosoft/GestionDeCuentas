using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;

namespace SGSE.Security
{
    public class Crypto
    {
        /// <summary>
        /// Algoritmos simétricos
        /// </summary>
        public enum CryptoProvider
        {
            /// <summary>
            /// 56 bits
            /// </summary>
            DES,
            /// <summary>
            /// 3DES, TDES 64 bits
            /// </summary>
            TripleDES,
            /// <summary>
            /// 64 bits
            /// </summary>
            RC2,
            /// <summary>
            /// AES 128 bits
            /// </summary>
            Rijndael
        }

        public enum CryptoAction
        {
            Encrypt,
            Desencrypt
        }

        private string stringKey;

        private string stringIV;

        private CryptoProvider algorithm;

        public string Key
        {
            get
            {
                return stringKey;
            }
            set
            {
                stringKey = value;
            }
        }

        public string IV
        {
            get
            {
                return stringIV;
            }
            set
            {
                stringIV = value;
            }
        }

        public Crypto(CryptoProvider alg)
        {
            algorithm = alg;
        }

        public string EncryptString(string CadenaOriginal)
        {
            MemoryStream memoryStream;
            try
            {
                bool flag = stringKey == null || stringIV == null;
                if (flag)
                {
                    throw new Exception("Error al inicializar la clave y el vector");
                }
                byte[] key = MakeKeyByteArray();
                byte[] iV = MakeIVByteArray();
                byte[] bytes = Encoding.UTF8.GetBytes(CadenaOriginal);
                memoryStream = new MemoryStream(checked(CadenaOriginal.Length * 2));
                ICryptoTransform serviceProvider = new CryptoServiceProvider((CryptoServiceProvider.CryptoProvider)algorithm, CryptoServiceProvider.CryptoAction.Encrypt).GetServiceProvider(key, iV);
                CryptoStream cryptoStream = new CryptoStream(memoryStream, serviceProvider, CryptoStreamMode.Write);
                cryptoStream.Write(bytes, 0, bytes.Length);
                cryptoStream.Close();
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return Convert.ToBase64String(memoryStream.ToArray());
        }

        public string DecryptString(string CadenaCifrada)
        {
            MemoryStream memoryStream;
            try
            {
                bool flag = stringKey == null || stringIV == null;
                if (flag)
                {
                    throw new Exception("Error al inicializar la clave y el vector.");
                }
                byte[] key = MakeKeyByteArray();
                byte[] iV = MakeIVByteArray();
                byte[] array = Convert.FromBase64String(CadenaCifrada);
                memoryStream = new MemoryStream(CadenaCifrada.Length);
                ICryptoTransform serviceProvider = new CryptoServiceProvider((CryptoServiceProvider.CryptoProvider)algorithm, CryptoServiceProvider.CryptoAction.Desencrypt).GetServiceProvider(key, iV);
                CryptoStream cryptoStream = new CryptoStream(memoryStream, serviceProvider, CryptoStreamMode.Write);
                cryptoStream.Write(array, 0, array.Length);
                cryptoStream.Close();
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return Encoding.UTF8.GetString(memoryStream.ToArray());
        }

        private byte[] MakeKeyByteArray()
        {
            switch (algorithm)
            {
                case CryptoProvider.DES:
                case CryptoProvider.RC2:
                    {
                        bool flag = stringKey.Length < 8;
                        if (flag)
                        {
                            stringKey = stringKey.PadRight(8);
                        }
                        else
                        {
                            bool flag2 = stringKey.Length > 8;
                            if (flag2)
                            {
                                stringKey = stringKey.Substring(0, 8);
                            }
                        }
                        break;
                    }
                case CryptoProvider.TripleDES:
                case CryptoProvider.Rijndael:
                    {
                        bool flag3 = stringKey.Length < 16;
                        if (flag3)
                        {
                            stringKey = stringKey.PadRight(16);
                        }
                        else
                        {
                            bool flag4 = stringKey.Length > 16;
                            if (flag4)
                            {
                                stringKey = stringKey.Substring(0, 16);
                            }
                        }
                        break;
                    }
            }
            return Encoding.UTF8.GetBytes(stringKey);
        }

        private byte[] MakeIVByteArray()
        {
            switch (algorithm)
            {
                case CryptoProvider.DES:
                case CryptoProvider.TripleDES:
                case CryptoProvider.RC2:
                    {
                        bool flag = stringIV.Length < 8;
                        if (flag)
                        {
                            stringIV = stringIV.PadRight(8);
                        }
                        else
                        {
                            bool flag2 = stringIV.Length > 8;
                            if (flag2)
                            {
                                stringIV = stringIV.Substring(0, 8);
                            }
                        }
                        break;
                    }
                case CryptoProvider.Rijndael:
                    {
                        bool flag3 = stringIV.Length < 16;
                        if (flag3)
                        {
                            stringIV = stringIV.PadRight(16);
                        }
                        else
                        {
                            bool flag4 = stringIV.Length > 16;
                            if (flag4)
                            {
                                stringIV = stringIV.Substring(0, 16);
                            }
                        }
                        break;
                    }
            }
            return Encoding.UTF8.GetBytes(stringIV);
        }

        public void EncryptDecryptFile(string InFileName, string OutFileName, CryptoAction Action)
        {
            bool flag = !File.Exists(InFileName);
            if (flag)
            {
                throw new Exception("No se ha encontrado el archivo.");
            }
            checked
            {
                try
                {
                    bool flag2 = stringKey == null || stringIV == null;
                    if (flag2)
                    {
                        throw new Exception("Error al inicializar la clave y el vector.");
                    }
                    FileStream fileStream = new FileStream(InFileName, FileMode.Open, FileAccess.Read);
                    FileStream fileStream2 = new FileStream(OutFileName, FileMode.OpenOrCreate, FileAccess.Write);
                    fileStream2.SetLength(0L);
                    byte[] key = MakeKeyByteArray();
                    byte[] iV = MakeIVByteArray();
                    byte[] buffer = new byte[4097];
                    long length = fileStream.Length;
                    long num = 0L;
                    ICryptoTransform serviceProvider = new CryptoServiceProvider((CryptoServiceProvider.CryptoProvider)algorithm, (CryptoServiceProvider.CryptoAction)Action).GetServiceProvider(key, iV);
                    CryptoStream cryptoStream = null;
                    if (Action != CryptoAction.Encrypt)
                    {
                        if (Action == CryptoAction.Desencrypt)
                        {
                            cryptoStream = new CryptoStream(fileStream2, serviceProvider, CryptoStreamMode.Write);
                        }
                    }
                    else
                    {
                        cryptoStream = new CryptoStream(fileStream2, serviceProvider, CryptoStreamMode.Write);
                    }
                    while (num < length)
                    {
                        int num2 = fileStream.Read(buffer, 0, 4096);
                        cryptoStream.Write(buffer, 0, num2);
                        num += unchecked((long)num2);
                    }
                    bool flag3 = cryptoStream != null;
                    if (flag3)
                    {
                        cryptoStream.Close();
                    }
                    fileStream.Close();
                    fileStream2.Close();
                }
                catch (Exception ex)
                {
                    throw ex;
                }
            }
        }

        /// <summary>
        /// SHA-1
        /// </summary>
        /// <param name="input">Cadena input</param>
        /// <returns></returns>
        public string SHA1(string Cadena)
        {
            SHA1 sha1 = new SHA1CryptoServiceProvider();

            byte[] inputBytes = (new UnicodeEncoding()).GetBytes(Cadena);
            byte[] hash = sha1.ComputeHash(inputBytes);
            return Convert.ToBase64String(hash);
        }
    }
}
