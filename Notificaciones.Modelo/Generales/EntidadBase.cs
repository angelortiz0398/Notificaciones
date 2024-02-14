using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace Notificaciones.Modelo.Generales
{
    public abstract class EntidadBase : IEntidadBase
    {
        [Key]
        public long Id { get; set; }

        public string Trail { get; set; }

        [DataType(DataType.DateTime)]
        [Required]
        [IgnoreDataMember]
        public DateTime FechaCreacion { get; set; }

        [Required]
        [IgnoreDataMember]
        public bool Eliminado { get; set; }

        [NotMapped]
        [IgnoreDataMember]
        public bool EsNuevo => Id.Equals(0L);
    }
}
