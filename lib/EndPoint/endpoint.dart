class APIEndpoint {
  //  static const String _baseEndPoint = "https://ecommerce-renderer.onrender.com/api";
   static const String _baseEndPoint = "http://localhost:3000/api";
   static const String productGetEndPoint = "$_baseEndPoint/products";
   static const String postNewProduct = "$_baseEndPoint/products";
   static const String updateData = "$_baseEndPoint/products";
   static const String getOrdersData = "$_baseEndPoint/userOrders";
   static const String fetchOrderStatus = "$_baseEndPoint/orders/status";
   static const String updateOrderStatus = "$_baseEndPoint/orders";
   static const String getOrderItems = "$_baseEndPoint/orderitems";
   static const String getReviews= "$_baseEndPoint/products";
   static const String getAllReviews = "$_baseEndPoint/products/reviews";
}