using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;

namespace SGSE.Security
{
    public class CryptoBussiness
    {
        private Crypto objCrypto;

        /// <summary>
        /// Inicializa el servicio de criptografia. AES por defecto
        /// </summary>
        public CryptoBussiness()
        {
            objCrypto = new Crypto(Crypto.CryptoProvider.Rijndael);
            objCrypto.Key = "FRMINFRA";
            objCrypto.IV = "9X=Hu_hg3w[5*daC";
        }


        /// <summary>
        /// Inicializa el servicio de criptografia con un proveedor determinado
        /// </summary>
        /// <param name="provider">Proveedor de encriptación</param>
        public CryptoBussiness(Crypto.CryptoProvider provider)
        {
            objCrypto = new Crypto(provider);
            objCrypto.Key = "FRMINFRA";
            objCrypto.IV = "9X=Hu_hg3w[5*daC";
        }


        public string EncryptString(string pstrCadena)
        {
            return objCrypto.EncryptString(pstrCadena);
        }


        public string DecryptString(string pstrCadena)
        {
            return objCrypto.DecryptString(pstrCadena);
        }


        /// <summary>
        /// Implementación Hash de 160 bytes
        /// </summary>
        /// <param name="pstrCadena"></param>
        /// <returns></returns>
        public string SHA1(string pstrCadena)
        {
            return objCrypto.SHA1(pstrCadena);
        }


        /// <summary>
        /// Implementación de Hash de 256 bytes
        /// </summary>
        /// <param name="pstrCadena"></param>
        /// <returns></returns>
        public string SHA256(string pstrCadena)
        {
            using (SHA256 sha256Hash = System.Security.Cryptography.SHA256.Create())
            {
                // Calcula es hash - retorna un arreglo de bytes
                byte[] bytes = sha256Hash.ComputeHash(Encoding.UTF8.GetBytes(pstrCadena));

                // Convierte el arreglo de bytes a string
                StringBuilder builder = new StringBuilder();
                for (int i = 0; i < bytes.Length; i++)
                {
                    builder.Append(bytes[i].ToString("x2"));
                }
                return builder.ToString();
            }
        }
    }
}
