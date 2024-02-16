namespace NotificacionesService
{
    partial class NotificacionesServiceInstaller1
    {
        /// <summary>
        /// Variable del diseñador necesaria.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary> 
        /// Limpiar los recursos que se estén usando.
        /// </summary>
        /// <param name="disposing">true si los recursos administrados se deben desechar; false en caso contrario.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Código generado por el Diseñador de componentes

        /// <summary>
        /// Método necesario para admitir el Diseñador. No se puede modificar
        /// el contenido de este método con el editor de código.
        /// </summary>
        private void InitializeComponent()
        {
            this.NotificacionesServiceInstaller = new System.ServiceProcess.ServiceProcessInstaller();
            this.ServiceInstaller1 = new System.ServiceProcess.ServiceInstaller();
            // 
            // NotificacionesServiceInstaller
            // 
            this.NotificacionesServiceInstaller.Account = System.ServiceProcess.ServiceAccount.LocalSystem;
            this.NotificacionesServiceInstaller.Password = null;
            this.NotificacionesServiceInstaller.Username = null;
            this.NotificacionesServiceInstaller.AfterInstall += new System.Configuration.Install.InstallEventHandler(this.NotificacionesServiceInstaller_AfterInstall);
            // 
            // ServiceInstaller1
            // 
            this.ServiceInstaller1.Description = "Servicio de notificacion para SGD";
            this.ServiceInstaller1.DisplayName = "Servicio de notificacion SGD";
            this.ServiceInstaller1.ServiceName = "NotificacionService";
            this.ServiceInstaller1.StartType = System.ServiceProcess.ServiceStartMode.Automatic;
            this.ServiceInstaller1.AfterInstall += new System.Configuration.Install.InstallEventHandler(this.serviceInstaller1_AfterInstall);
            // 
            // NotificacionesServiceInstaller1
            // 
            this.Installers.AddRange(new System.Configuration.Install.Installer[] {
            this.NotificacionesServiceInstaller,
            this.ServiceInstaller1});

        }

        #endregion

        private System.ServiceProcess.ServiceProcessInstaller NotificacionesServiceInstaller;
        private System.ServiceProcess.ServiceInstaller ServiceInstaller1;
    }
}