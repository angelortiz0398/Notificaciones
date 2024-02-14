using System;
using System.Collections;
using System.Collections.Generic;
using System.ComponentModel;
using System.Configuration.Install;
using System.Linq;
using System.Threading.Tasks;

namespace NotificacionesService
{
    [RunInstaller(true)]
    public partial class NotificacionesServiceInstaller1 : System.Configuration.Install.Installer
    {
        public NotificacionesServiceInstaller1()
        {
            InitializeComponent();
        }

        private void serviceInstaller1_AfterInstall(object sender, InstallEventArgs e)
        {

        }

        private void NotificacionesServiceInstaller_AfterInstall(object sender, InstallEventArgs e)
        {

        }
    }
}
