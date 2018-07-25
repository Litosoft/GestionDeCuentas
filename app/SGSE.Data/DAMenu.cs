using SGSE.Data.Abstract;
using SGSE.Data.Helpers;
using SGSE.Entidad;
using SGSE.Entidad.Enumeradores;
using SGSE.Entidad.Primitivos;
using SGSE.Entidad.Responsers;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

namespace SGSE.Data
{
    public class DAMenu : AbstractDataManager
    {

        private string sp_listar = "SC_COMUN.USP_MENUITEM_LISTAR";
        private string sp_listar_byPerfil = "SC_COMUN.USP_MENUITEM_LISTAR_byPERFIL";
        private string sp_listar_byId = "SC_COMUN.USP_MENUITEM_LISTAR_BYID";
        private string sp_grabar = "SC_COMUN.USP_MENUITEM_GRABAR";

        private string sp_reset_items_byperfil = "SC_COMUN.USP_MENUITEMS_RESET_BYPERFIL";
        private string sp_grabar_items_byperfil = "SC_COMUN.USP_MENUITEMS_GRABAR_BYPERFIL";


        /// <summary>
        /// Lista todos los elementos del menú
        /// </summary>
        /// <returns>IEnumerable BEMenuItem</returns>
        public IEnumerable<BEMenuItem> Listar()
        {
            List<BEMenuItem> Items = new List<BEMenuItem>();
            try
            {
                using (SqlConnection oConexion = new SqlConnection(DBConexion))
                {
                    SqlCommand oComando = new SqlCommand(sp_listar, oConexion);
                    oComando.CommandType = CommandType.StoredProcedure;
                    oConexion.Open();

                    using (SqlDataReader dr = oComando.ExecuteReader())
                    {
                        while (dr.Read() && dr.HasRows)
                        {
                            Items.Add(new BEMenuItem
                            {
                                Row = DataUtil.ObjectToInt(dr["i_row"]),
                                Id = DataUtil.ObjectToInt(dr["i_idm"]),

                                Nombre = DataUtil.ObjectToString(dr["s_nom"]),
                                Descripcion = DataUtil.ObjectToString(dr["s_des"]),

                                Controlador = DataUtil.ObjectToString(dr["s_con"]),
                                Metodo = DataUtil.ObjectToString(dr["s_met"]),
                                Parametro = DataUtil.ObjectToString(dr["s_par"]),
                                Url = DataUtil.ObjectToString(dr["s_url"]),

                                Icono = DataUtil.ObjectToString(dr["s_ico"]),

                                IsPopup = new ItemGenerico
                                {
                                    IntValue = DataUtil.ObjectToInt(dr["i_pop"])
                                },
                                IsVisible = new ItemGenerico
                                {
                                    IntValue = DataUtil.ObjectToInt(dr["i_vis"]),
                                },
                                IsGrupo = new ItemGenerico
                                {
                                    IntValue = DataUtil.ObjectToInt(dr["i_grp"])
                                },

                                Orden = DataUtil.ObjectToInt(dr["i_ord"]),
                                Nivel = DataUtil.ObjectToInt(dr["i_nvl"]),

                                Padre = new ItemGenerico
                                {
                                    Id = DataUtil.ObjectToInt(dr["i_idp"])
                                }

                            });
                        }
                    }
                    oComando.Dispose();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return Items;
        }


        /// <summary>
        /// Devuelve todos los items de menu permitidos para el pefil
        /// </summary>
        /// <param name="Id">Id del perfil</param>
        /// <returns></returns>
        public IEnumerable<BEMenuItem> ListarItems_byPerfil(int Id)
        {
            List<BEMenuItem> Items = new List<BEMenuItem>();
            try
            {
                using (SqlConnection oConexion = new SqlConnection(DBConexion))
                {
                    SqlCommand oComando = new SqlCommand(sp_listar_byPerfil, oConexion);
                    oComando.CommandType = CommandType.StoredProcedure;
                    oComando.Parameters.Add("@p_idp", SqlDbType.Int).Value = Id;
                    
                    oConexion.Open();

                    using (SqlDataReader dr = oComando.ExecuteReader())
                    {
                        while (dr.Read() && dr.HasRows)
                        {
                            Items.Add(new BEMenuItem
                            {
                                Id = DataUtil.ObjectToInt(dr["i_mnusid"]),

                                Nombre = DataUtil.ObjectToString(dr["s_mnunom"]),
                                Descripcion = DataUtil.ObjectToString(dr["s_mnudes"]),

                                Controlador = DataUtil.ObjectToString(dr["s_mnucon"]),
                                Metodo = DataUtil.ObjectToString(dr["s_mnumet"]),
                                Parametro = DataUtil.ObjectToString(dr["s_mnupar"]),
                                Url = DataUtil.ObjectToString(dr["s_mnuurl"]),

                                Icono = DataUtil.ObjectToString(dr["s_mnuico"]),
                                IsAuth = new ItemGenerico { IntValue = DataUtil.ObjectToInt(dr["i_mnuaut"]) },
                                Padre = new ItemGenerico { IntValue = DataUtil.ObjectToInt(dr["i_mnupad"]) },

                                IsPopup = new ItemGenerico { IntValue = DataUtil.ObjectToInt(dr["i_mnupop"]) },
                                IsVisible = new ItemGenerico { IntValue = DataUtil.ObjectToInt(dr["i_mnuvis"]) },
                                
                                IsGrupo = new ItemGenerico { IntValue = DataUtil.ObjectToInt(dr["i_mnugrp"]) },

                                Orden = DataUtil.ObjectToInt(dr["i_mnuord"]),
                                Nivel = DataUtil.ObjectToInt(dr["i_mnuniv"])
                            });
                        }
                    }
                    oComando.Dispose();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return Items;
        }


        /// <summary>
        /// Devuelve los datos de un elemento de menu por su Id
        /// </summary>
        /// <param name="Id">Id Item</param>
        /// <returns>BEMenuItem Items</returns>
        public BEMenuItem Listar_byId(int Id)
        {
            BEMenuItem Item = new BEMenuItem();
            try
            {
                using (SqlConnection oConexion = new SqlConnection(DBConexion))
                {
                    SqlCommand oComando = new SqlCommand(sp_listar_byId, oConexion);
                    oComando.Parameters.Add("@p_ido", SqlDbType.Int).Value = Id;
                    oComando.CommandType = CommandType.StoredProcedure;
                    oConexion.Open();

                    using (SqlDataReader dr = oComando.ExecuteReader())
                    {
                        while (dr.Read() && dr.HasRows)
                        {
                            Item.Id = DataUtil.ObjectToInt(dr["i_id"]);

                            Item.Nombre = DataUtil.ObjectToString(dr["s_nom"]);
                            Item.Descripcion = DataUtil.ObjectToString(dr["s_des"]);

                            Item.Controlador = DataUtil.ObjectToString(dr["s_con"]);
                            Item.Metodo = DataUtil.ObjectToString(dr["s_met"]);
                            Item.Parametro = DataUtil.ObjectToString(dr["s_par"]);
                            Item.Url = DataUtil.ObjectToString(dr["s_url"]);

                            Item.Icono = DataUtil.ObjectToString(dr["s_ico"]);
                            Item.Orden = DataUtil.ObjectToInt(dr["i_ord"]);

                            Item.IsPopup = new ItemGenerico
                            {
                                IntValue = DataUtil.ObjectToInt(dr["i_pop"])
                            };
                            Item.IsVisible = new ItemGenerico
                            {
                                IntValue = DataUtil.ObjectToInt(dr["i_vis"])
                            };
                            Item.IsGrupo = new ItemGenerico
                            {
                                IntValue = DataUtil.ObjectToInt(dr["i_grp"])
                            };
                            Item.Padre = new ItemGenerico
                            {
                                IntValue = DataUtil.ObjectToInt(dr["i_idp"])
                            };

                        }
                    }
                    oComando.Dispose();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return Item;
        }


        /// <summary>
        /// Graba o actualiza los datos de un elemento de menu (opcion)
        /// </summary>
        /// <param name="model">modelo</param>
        /// <returns>ResponserData</returns>
        public ResponserData Grabar(BEMenuItem model)
        {
            ResponserData Responser = new ResponserData();
            try
            {
                using (SqlConnection oConexion = new SqlConnection(DBConexion))
                {
                    SqlCommand oComando = new SqlCommand(sp_grabar, oConexion);
                    oComando.CommandType = CommandType.StoredProcedure;

                    oComando.Parameters.Add("@p_ido", SqlDbType.Int).Value = model.Id;
                    oComando.Parameters.Add("@p_idp", SqlDbType.Int).Value = model.Padre.Id;
                    oComando.Parameters.Add("@p_nom", SqlDbType.VarChar, 150).Value = model.Nombre;
                    oComando.Parameters.Add("@p_des", SqlDbType.VarChar, 150).Value = model.Descripcion;

                    oComando.Parameters.Add("@p_con", SqlDbType.VarChar, 80).Value = model.Controlador;
                    oComando.Parameters.Add("@p_met", SqlDbType.VarChar, 80).Value = model.Metodo;
                    oComando.Parameters.Add("@p_par", SqlDbType.VarChar, 30).Value = model.Parametro;
                    oComando.Parameters.Add("@p_url", SqlDbType.VarChar, 150).Value = model.Url;

                    oComando.Parameters.Add("@p_ico", SqlDbType.VarChar, 40).Value = model.Icono;

                    oComando.Parameters.Add("@p_ipo", SqlDbType.Bit).Value = model.IsPopup.IntValue;
                    oComando.Parameters.Add("@p_ivi", SqlDbType.Bit).Value = model.IsVisible.IntValue;
                    oComando.Parameters.Add("@p_igr", SqlDbType.Bit).Value = model.IsGrupo.IntValue;

                    oComando.Parameters.Add("@p_ord", SqlDbType.Int).Value = model.Orden;

                    oComando.Parameters.Add("@p_usr", SqlDbType.VarChar, 12).Value = model.RowAudit.IUsr;
                    oComando.Parameters.Add("@p_ipc", SqlDbType.VarChar, 15).Value = model.RowAudit.IP;
                    oConexion.Open();

                    using (SqlDataReader dr = oComando.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            Responser.Mensaje = DataUtil.ObjectToString(dr["s_msg"]);
                            Responser.Estado = (ResponserEstado)DataUtil.ObjectToInt(dr["i_est"]);
                            Responser.TipoAlerta = (BootstrapAlertType)DataUtil.ObjectToInt(dr["i_btp"]);
                        }
                    }
                    oComando.Dispose();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return Responser;
        }


        /// <summary>
        /// Graba un conjunto de opciones del menú asociados a un perfil
        /// </summary>
        /// <param name="model">BEPerfil</param>
        /// <returns></returns>
        public ResponserData Grabar_byPerfil(BEPerfil model)
        {
            ResponserData Responser = new ResponserData();
            try
            {
                using (SqlConnection oConexion = new SqlConnection(DBConexion))
                {
                    SqlCommand oComando = new SqlCommand(sp_reset_items_byperfil, oConexion);
                    oComando.CommandType = CommandType.StoredProcedure;

                    oComando.Parameters.Add("@p_idp", SqlDbType.Int).Value = model.Id;
                    oComando.Parameters.Add("@p_usr", SqlDbType.VarChar, 12).Value = model.RowAudit.IUsr;
                    oComando.Parameters.Add("@p_ipc", SqlDbType.VarChar, 15).Value = model.RowAudit.IP;
                    oConexion.Open();

                    oComando.ExecuteNonQuery();
                    oComando.Dispose();
                }

                foreach (BEMenuItem opcion in model.OpcionesMenu)
                {
                    this.GrabarOpcion_byPerfil(model.Id, opcion.Id, opcion.RowAudit.IUsr, opcion.RowAudit.IP);
                }

                Responser.Mensaje = "Las opciones fueron asociadas al perfil.";
                Responser.Estado = ResponserEstado.Ok;
                Responser.TipoAlerta = BootstrapAlertType.success;
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return Responser;
        }


        /// <summary>
        /// Inserta/actualiza una determinada opcion del menú según el perfil asociado
        /// </summary>
        /// <param name="IdPerfil">IdPerfil</param>
        /// <param name="IdOpcion">IdOpcion</param>
        /// <param name="Log">Log</param>
        private void GrabarOpcion_byPerfil(int IdPerfil, int IdOpcion, int Usr, string IP)
        {
            try
            {
                using (SqlConnection oConexion = new SqlConnection(DBConexion))
                {
                    SqlCommand oComando = new SqlCommand(sp_grabar_items_byperfil, oConexion);
                    oComando.CommandType = CommandType.StoredProcedure;

                    oComando.Parameters.Add("@p_ido", SqlDbType.Int).Value = IdOpcion;
                    oComando.Parameters.Add("@p_idp", SqlDbType.Int).Value = IdPerfil;
                    oComando.Parameters.Add("@p_usr", SqlDbType.VarChar, 12).Value = Usr;
                    oComando.Parameters.Add("@p_ipc", SqlDbType.VarChar, 15).Value = IP;
                    oConexion.Open();

                    oComando.ExecuteNonQuery();
                    oComando.Dispose();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}
