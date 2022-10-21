<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, cust.rent.*"%>
<%@ page import="cust.car.*" %>
<%@ include file="/cust/cookies.jsp" %>

<%
	String member_id = request.getParameter("member_id")==null?"":request.getParameter("member_id");
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String r_site = request.getParameter("r_site")==null?"":request.getParameter("r_site");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	
	String s_yy = request.getParameter("s_yy")==null?"":request.getParameter("s_yy");
	String s_mm = request.getParameter("s_mm")==null?"":request.getParameter("s_mm");
	String s_dd = request.getParameter("s_dd")==null?"":request.getParameter("s_dd");	
	String s_site = request.getParameter("s_site")==null?"":request.getParameter("s_site");
	String s_car_no = request.getParameter("s_car_no")==null?"":request.getParameter("s_car_no");
	String s_car_comp_id = request.getParameter("s_car_comp_id")==null?"":request.getParameter("s_car_comp_id");
	String s_car_cd = request.getParameter("s_car_cd")==null?"":request.getParameter("s_car_cd");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");	
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	CarDatabase car = CarDatabase.getInstance();
%>

<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/cust/include/table.css">
<script language="JavaScript">
<!--

<%if(cmd.equals("3")){	//차량번호 리스트
	Vector conts = car.getCarNo_list(client_id, r_site, s_yy, s_mm, s_dd, s_site);
	int cont_size = conts.size();%>

	te = parent.document.form1.s_car_no;
	te.length = <%= cont_size+1 %>;
	te.options[0].value = '';
	te.options[0].text = '전체';
		
<%	for(int i = 0 ; i < cont_size ; i++){
		RentListBean cont = (RentListBean)conts.elementAt(i);%>				
			te.options[<%=i+1%>].value = '<%=cont.getCar_mng_id()%>';
			te.options[<%=i+1%>].text = '<%=cont.getCar_no()%>';
<%	}

  }else if(cmd.equals("4")){	//영업담당자,관리담당자
  	Vector damdang = car.getDamdang(s_car_no);%>
	
	
<%	for(int i = 0 ; i < damdang.size() ; i++){
		Hashtable dam = (Hashtable)damdang.elementAt(i);%>				
		parent.document.form1.bus_nm<%= i %>.value = '<%= c_db.getNameById((String)dam.get("BUS_ID"),"USER") %>';
		parent.document.form1.mng_nm<%= i %>.value = '<%= c_db.getNameById((String)dam.get("MNG_ID"),"USER") %>';
		parent.document.form1.mng_id<%= i %>.value = '<%= (String)dam.get("MNG_ID") %>';
<%	}	
  }%>
//-->
</script>
</head>
<body>
</body>
</html>
