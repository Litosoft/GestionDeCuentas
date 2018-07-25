using SGSE.Security;
using System;
using System.Text;
using System.Windows.Forms;

namespace SGSE.Cliente.UI
{
    public partial class ui_security : Form
    {
        public ui_security()
        {
            InitializeComponent();
        }

        private void btnlimpiar_Click(object sender, EventArgs e)
        {
            txtdesde.Text = string.Empty;
            txthasta.Text = string.Empty;

            txtdesde.Focus();
        }

        private void ui_security_Load(object sender, EventArgs e)
        {
            cbometodo.DataSource = Enum.GetValues(typeof(SGSE.Security.Crypto.CryptoProvider));
            cboaccion.DataSource = Enum.GetValues(typeof(SGSE.Security.Crypto.CryptoAction));
        }

        private void btnejecutar_Click(object sender, EventArgs e)
        {
            try {
                var provider = cbometodo.SelectedValue;
                var action = cboaccion.SelectedValue.ToString();

                Crypto objCrypto = new Crypto((Crypto.CryptoProvider)provider);
                objCrypto.Key = txtkey.Text;
                objCrypto.IV = txtiv.Text;

                if (action == "Encrypt")
                {
                    // Encriptar
                    if (chkBase64.Checked)
                    {
                        var txt = objCrypto.EncryptString(txtdesde.Text);
                        txthasta.Text = EncriptToBase64(txt);
                    }
                    else
                    {
                        txthasta.Text = objCrypto.EncryptString(txtdesde.Text);
                    }
                }
                else
                {
                    // Desencriptar
                    if (chkBase64.Checked)
                    {
                        var txt = EncriptFromBase64(txtdesde.Text); 
                        txthasta.Text = objCrypto.DecryptString(txt);
                    }
                    else
                    {
                        txthasta.Text = objCrypto.DecryptString(txtdesde.Text);
                    }
                }
            }
            catch(Exception ex)
            {
                MessageBox.Show(ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return;
            }
        }

        private void btninvierte_Click(object sender, EventArgs e)
        {
            txtdesde.Text = txthasta.Text;
            txthasta.Text = string.Empty;
        }

        #region métodos privados

        private static string EncriptToBase64(string input)
        {
            byte[] enc_bytes = System.Text.Encoding.UTF8.GetBytes(input);
            return Convert.ToBase64String(enc_bytes);
        }

        /// <summary>Desencripta el parámetro desde base 64</summary>
        /// <param name="input">Texto a ser desencriptado</param>
        /// <returns></returns>
        private static string EncriptFromBase64(string input)
        {
            byte[] base64_input = Convert.FromBase64String(input);
            return Encoding.UTF8.GetString(base64_input);
        }


        #endregion
        /// <summary>
        /// Devuelve un Hash
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void btnhash_Click(object sender, EventArgs e)
        {
            txthasta.Text = Peach.Hash(txtdesde.Text);
        }
    }
}
