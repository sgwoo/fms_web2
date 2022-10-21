<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.incom.*"%>
<jsp:useBean id="in_db" scope="page" class="acar.incom.IncomDatabase"/>
<%@ include file="/acar/cookies.jsp" %>


<html>
<head>
<title>FMS</title>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">
<body leftmargin="15">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<%

	int scd_size =  request.getParameter("ip_size")==null?0:AddUtil.parseDigit(request.getParameter("ip_size"));
	
	String idx[]  = request.getParameterValues("idx");
	String tr_date[]  = request.getParameterValues("tr_date");
	String ip_amt[]  = request.getParameterValues("ip_amt");
               
   String firm_nm[] = new String[scd_size];    
   String client_id[] = new String[scd_size];
         
   Hashtable base =	new Hashtable();
   
   	for(int i=0 ; i < scd_size ; i++){
   	       
   	    int pay_amt = ip_amt[i]	==null?0 :AddUtil.parseDigit(ip_amt[i]);
   	    
   	//    System.out.println("pay_amt=" + pay_amt);
   	            	
		base = in_db.getInsideGrt(tr_date[i], pay_amt);
		
   		 firm_nm[i] = String.valueOf(base.get("FIRM_NM"));
     	 client_id[i] = String.valueOf(base.get("CLIENT_ID"));
	  
		if ( !String.valueOf(base.get("FIRM_NM")).equals("null")  ) {
   		//	 System.out.println("idx=" + i + "| tr_branch =" + tr_branch[i] + " |naeyong=" + naeyong[i] + "| jukyo = " + jukyo[i] );  
	  	} 
	}
		
%>

	t_fm = parent.form1;
	
<%	for(int j=0 ; j < scd_size ; j++){  %>
<%    if ( !firm_nm[j].equals("null" ) ) { %>  
				t_fm.firm_nm[<%=j%>].value		= '<%=firm_nm[j] %>';	
				t_fm.client_id[<%=j%>].value 		= '<%=client_id[j]%>';
<%     } %>
 <%  } %>     
	parent.set_init();	
	alert("매칭되었습니다.");	
	
</script>
</body>
</html>
