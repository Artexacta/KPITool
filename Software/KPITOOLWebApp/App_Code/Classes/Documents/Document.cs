using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Artexacta.App.Document
{
    /// <summary>
    /// Summary description for Document
    /// </summary>
    [Serializable]
    public class Document
    {
        private int _documentId;
        private string _storagePath;
        private string _objectType;
        private int _objectId;
        private string _title;

        public Document()
        {
        }

        public Document(int documentId, string storagePath, string objectType, int objectId, string title)
        {
            this._documentId = documentId;
            this._storagePath = storagePath;
            this._objectType = objectType;
            this._objectId = objectId;
            this._title = title;
        }
        public int DocumentId
        {
            get { return this._documentId; }
            set { this._documentId = value; }
        }
        public string StoragePath
        {
            get { return this._storagePath; }
            set { this._storagePath = value; }
        }
        public string ObjectType
        {
            get { return this._objectType; }
            set { this._objectType = value; }
        }
        public int ObjectId
        {
            get { return this._objectId; }
            set { this._objectId = value; }
        }
        public string Title
        {
            get { return this._title; }
            set { this._title = value; }
        }

        public string ObjectTitle
        {
            get
            {
                string result = "";

                //if (this._objectType.ToUpper() == GenericObjects.GenericObject.ObjectType.Product.ToString().ToUpper())
                //{
                //    Product.Product theProduct = Product.BLL.ProductBLL.GetProductDetails(this._objectId);

                //    if (theProduct != null)
                //        result = theProduct.Title;
                //}
                //else if (this._objectType.ToUpper() == GenericObjects.GenericObject.ObjectType.Service.ToString().ToUpper())
                //{
                //    Service.Service theService = Service.BLL.ServiceBLL.GetServiceDetails(this._objectId);
                //    if (theService != null)
                //        result = theService.Title;
                //}

                return result;
            }
        }
    }
}