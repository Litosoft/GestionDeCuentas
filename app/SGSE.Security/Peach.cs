using System;
using System.Text;

namespace SGSE.Security
{
    /// <summary>
    /// Manejador de llamadas a encriptación
    /// </summary>
    public sealed class Peach
    {
        #region Encriptacion

        /// <summary>
        /// Encripta una cadena de texto en base al proveedor de critografia seleccionado
        /// </summary>
        /// <param name="provider">Proveedor de criptografia</param>
        /// <param name="input">Texto</param>
        /// <returns></returns>
        public static string EncriptText(Crypto.CryptoProvider provider, string input)
        {
            try
            {
                return new CryptoBussiness(provider).EncryptString(input);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>Encripta la cadena de texto</summary>
        /// <param name="input">Cadena de Texto</param>
        public static string EncriptText(string input)
        {
            try
            {
                return new CryptoBussiness().EncryptString(input);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        #endregion

        
        #region Desencriptacion

        /// <summary>Desencripta la cadena de texto </summary>
        /// <param name="input">Cadena de Texto</param>
        public static string DecriptText(string input)
        {
            try
            {
                return new CryptoBussiness().DecryptString(input);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>Desencripta la cadena de texto utilizando el proveedor de criptografia seleccionado</summary>
        /// <param name="input">Cadena de Texto</param>
        public static string DecriptText(Crypto.CryptoProvider provider, string input)
        {
            try
            {
                return new CryptoBussiness(provider).DecryptString(input);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        #endregion


        #region Base-64 AES

        /// <summary>Encripta el parametro input y convierte el resultado en cadena base 64</summary>
        /// <param name="input">texto a ser encriptado</param>
        public static string EncriptToBase64(string input)
        {
            string input_enc = EncriptText(input);
            byte[] enc_bytes = System.Text.Encoding.UTF8.GetBytes(input_enc);
            return Convert.ToBase64String(enc_bytes);
        }


        /// <summary>Desencripta el parámetro desde base 64</summary>
        /// <param name="input">Texto a ser desencriptado</param>
        /// <returns></returns>
        public static string DecriptFromBase64(string input)
        {
            byte[] base64_input = Convert.FromBase64String(input);
            string txtbase = Encoding.UTF8.GetString(base64_input);
            return DecriptText(txtbase);
        }

        #endregion


        /// <summary>
        /// Devuelve un Hash SHA1 de la cadena input. 160 bits (5x32) en Bloques de 512
        /// </summary>
        /// <param name="input">Cadena input</param>
        /// <returns>Hash</returns>
        public static string Hash(string input)
        {
            try
            {
                return new CryptoBussiness().SHA1(input);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// Implementación de Hash SHA-256 de la cadena input.
        /// </summary>
        /// <param name="input"></param>
        /// <returns></returns>
        public static string SHA256(string input)
        {
            try
            {
                return new CryptoBussiness().SHA256(input);
            }
            catch(Exception ex)
            {
                throw ex;
            }
        }
    }
}
