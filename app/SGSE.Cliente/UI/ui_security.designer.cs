namespace SGSE.Cliente.UI
{
    partial class ui_security
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.cbometodo = new System.Windows.Forms.ComboBox();
            this.txtdesde = new System.Windows.Forms.TextBox();
            this.label1 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.label3 = new System.Windows.Forms.Label();
            this.txthasta = new System.Windows.Forms.TextBox();
            this.btnejecutar = new System.Windows.Forms.Button();
            this.btnlimpiar = new System.Windows.Forms.Button();
            this.cboaccion = new System.Windows.Forms.ComboBox();
            this.lblaccion = new System.Windows.Forms.Label();
            this.txtkey = new System.Windows.Forms.TextBox();
            this.label4 = new System.Windows.Forms.Label();
            this.label5 = new System.Windows.Forms.Label();
            this.txtiv = new System.Windows.Forms.TextBox();
            this.chkBase64 = new System.Windows.Forms.CheckBox();
            this.btninvierte = new System.Windows.Forms.Button();
            this.btnhash = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // cbometodo
            // 
            this.cbometodo.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cbometodo.FormattingEnabled = true;
            this.cbometodo.Location = new System.Drawing.Point(12, 142);
            this.cbometodo.Margin = new System.Windows.Forms.Padding(6);
            this.cbometodo.Name = "cbometodo";
            this.cbometodo.Size = new System.Drawing.Size(224, 21);
            this.cbometodo.TabIndex = 0;
            // 
            // txtdesde
            // 
            this.txtdesde.Location = new System.Drawing.Point(12, 33);
            this.txtdesde.Multiline = true;
            this.txtdesde.Name = "txtdesde";
            this.txtdesde.Size = new System.Drawing.Size(224, 69);
            this.txtdesde.TabIndex = 1;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(13, 17);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(34, 13);
            this.label1.TabIndex = 2;
            this.label1.Text = "Texto";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(241, 17);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(55, 13);
            this.label2.TabIndex = 4;
            this.label2.Text = "Resultado";
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(12, 123);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(208, 13);
            this.label3.TabIndex = 6;
            this.label3.Text = "Método de Encriptación / Desencriptación";
            // 
            // txthasta
            // 
            this.txthasta.Location = new System.Drawing.Point(244, 33);
            this.txthasta.Multiline = true;
            this.txthasta.Name = "txthasta";
            this.txthasta.Size = new System.Drawing.Size(224, 69);
            this.txthasta.TabIndex = 8;
            // 
            // btnejecutar
            // 
            this.btnejecutar.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.btnejecutar.ForeColor = System.Drawing.Color.Blue;
            this.btnejecutar.Location = new System.Drawing.Point(359, 253);
            this.btnejecutar.Name = "btnejecutar";
            this.btnejecutar.Size = new System.Drawing.Size(111, 23);
            this.btnejecutar.TabIndex = 9;
            this.btnejecutar.Text = "Ejecutar";
            this.btnejecutar.UseVisualStyleBackColor = true;
            this.btnejecutar.Click += new System.EventHandler(this.btnejecutar_Click);
            // 
            // btnlimpiar
            // 
            this.btnlimpiar.Location = new System.Drawing.Point(359, 282);
            this.btnlimpiar.Name = "btnlimpiar";
            this.btnlimpiar.Size = new System.Drawing.Size(111, 23);
            this.btnlimpiar.TabIndex = 10;
            this.btnlimpiar.Text = "Limpiar";
            this.btnlimpiar.UseVisualStyleBackColor = true;
            this.btnlimpiar.Click += new System.EventHandler(this.btnlimpiar_Click);
            // 
            // cboaccion
            // 
            this.cboaccion.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cboaccion.FormattingEnabled = true;
            this.cboaccion.ItemHeight = 13;
            this.cboaccion.Location = new System.Drawing.Point(12, 284);
            this.cboaccion.Name = "cboaccion";
            this.cboaccion.Size = new System.Drawing.Size(224, 21);
            this.cboaccion.TabIndex = 11;
            // 
            // lblaccion
            // 
            this.lblaccion.AutoSize = true;
            this.lblaccion.Location = new System.Drawing.Point(13, 268);
            this.lblaccion.Name = "lblaccion";
            this.lblaccion.Size = new System.Drawing.Size(40, 13);
            this.lblaccion.TabIndex = 12;
            this.lblaccion.Text = "Acción";
            // 
            // txtkey
            // 
            this.txtkey.Location = new System.Drawing.Point(12, 189);
            this.txtkey.Name = "txtkey";
            this.txtkey.Size = new System.Drawing.Size(224, 20);
            this.txtkey.TabIndex = 13;
            this.txtkey.Text = "FRMINFRA";
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(12, 173);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(25, 13);
            this.label4.TabIndex = 14;
            this.label4.Text = "Key";
            // 
            // label5
            // 
            this.label5.AutoSize = true;
            this.label5.Location = new System.Drawing.Point(13, 219);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(17, 13);
            this.label5.TabIndex = 16;
            this.label5.Text = "IV";
            // 
            // txtiv
            // 
            this.txtiv.Location = new System.Drawing.Point(12, 235);
            this.txtiv.Name = "txtiv";
            this.txtiv.Size = new System.Drawing.Size(224, 20);
            this.txtiv.TabIndex = 15;
            this.txtiv.Text = "9X=Hu_hg3w[5*daC";
            // 
            // chkBase64
            // 
            this.chkBase64.AutoSize = true;
            this.chkBase64.Location = new System.Drawing.Point(244, 108);
            this.chkBase64.Name = "chkBase64";
            this.chkBase64.Size = new System.Drawing.Size(136, 17);
            this.chkBase64.TabIndex = 17;
            this.chkBase64.Text = "Habilitar salida Base-64";
            this.chkBase64.UseVisualStyleBackColor = true;
            // 
            // btninvierte
            // 
            this.btninvierte.Location = new System.Drawing.Point(357, 140);
            this.btninvierte.Name = "btninvierte";
            this.btninvierte.Size = new System.Drawing.Size(111, 23);
            this.btninvierte.TabIndex = 18;
            this.btninvierte.Text = "Invertir";
            this.btninvierte.UseVisualStyleBackColor = true;
            this.btninvierte.Click += new System.EventHandler(this.btninvierte_Click);
            // 
            // btnhash
            // 
            this.btnhash.Location = new System.Drawing.Point(357, 168);
            this.btnhash.Name = "btnhash";
            this.btnhash.Size = new System.Drawing.Size(111, 23);
            this.btnhash.TabIndex = 19;
            this.btnhash.Text = "Hash (SHA-1)";
            this.btnhash.UseVisualStyleBackColor = true;
            this.btnhash.Click += new System.EventHandler(this.btnhash_Click);
            // 
            // ui_security
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(482, 334);
            this.Controls.Add(this.btnhash);
            this.Controls.Add(this.btninvierte);
            this.Controls.Add(this.chkBase64);
            this.Controls.Add(this.label5);
            this.Controls.Add(this.txtiv);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.txtkey);
            this.Controls.Add(this.lblaccion);
            this.Controls.Add(this.cboaccion);
            this.Controls.Add(this.btnlimpiar);
            this.Controls.Add(this.btnejecutar);
            this.Controls.Add(this.txthasta);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.txtdesde);
            this.Controls.Add(this.cbometodo);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedToolWindow;
            this.Name = "ui_security";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "Encriptador / Desencriptador";
            this.Load += new System.EventHandler(this.ui_security_Load);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.ComboBox cbometodo;
        private System.Windows.Forms.TextBox txtdesde;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.TextBox txthasta;
        private System.Windows.Forms.Button btnejecutar;
        private System.Windows.Forms.Button btnlimpiar;
        private System.Windows.Forms.ComboBox cboaccion;
        private System.Windows.Forms.Label lblaccion;
        private System.Windows.Forms.TextBox txtkey;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.Label label5;
        private System.Windows.Forms.TextBox txtiv;
        private System.Windows.Forms.CheckBox chkBase64;
        private System.Windows.Forms.Button btninvierte;
        private System.Windows.Forms.Button btnhash;
    }
}