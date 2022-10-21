<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.res_search.*, acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");	
	String car_no = request.getParameter("car_no")==null?"":request.getParameter("car_no");		
	String rent_st = request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");	
	
	String go_url 	= request.getParameter("go_url")==null?"":request.getParameter("go_url");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	Vector conts = rs_db.getAccidCarList(c_id);
	int cont_size = conts.size();
	
	
%>
<html>
<head>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript">
<!--
//-->
</script>
</head>
<body onLoad="self.focus()">
<table border=0 cellspacing=0 cellpadding=0 width=100%>
  <tr>
    <td class=line>            
      <table border=0 cellspacing=1 width=100%>
        <%if(cont_size > 0){
			for(int i = 0 ; i < cont_size ; i++){
				Hashtable sfm = (Hashtable)conts.elementAt(i);%>
				
			<%
				String mng_mode = ""; 
				if(String.valueOf(sfm.get("REG_ID")).equals(ck_acar_id)||String.valueOf(sfm.get("BUS_ID")).equals(ck_acar_id)||nm_db.getWorkAuthUser("전산팀",ck_acar_id)){
					mng_mode = "A";
				}	
			
			%>
				
        <tr> 
          <td width=6% align="center"><%=i+1%></td>
          <td width=12% align="center">                    
		  <%if(gubun.equals("")){%>
		  <%	if(rent_st.equals("3")){//사고대차%>
		  <a href="javascript:parent.SetCarAccid('<%=sfm.get("ACCID_ST2")%>', '<%=sfm.get("CAR_MNG_ID")%>', '<%=sfm.get("ACCID_ID")%>', '<%=sfm.get("SERV_ID")%>', '<%=sfm.get("OFF_NM")%>', '<%=AddUtil.ChangeDate2(String.valueOf(sfm.get("ACCID_DT")))%>' ,'<%=sfm.get("P_CAR_NO")%>' ,'<%=sfm.get("P_CAR_NM")%>' ,'<%=sfm.get("P_NUM")%>' ,'<%=sfm.get("G_INS")%>' ,'<%=sfm.get("G_INS_NM")%>' ,'<%=sfm.get("AGE_SCP")%>')"><%=AddUtil.ChangeDate2(String.valueOf(sfm.get("ACCID_DT")))%></a>
		  <%	}else if(rent_st.equals("8")){%>
		  <a href="javascript:parent.SetCarAccid2('<%=sfm.get("ACCID_ST2")%>', '<%=sfm.get("CAR_MNG_ID")%>', '<%=sfm.get("ACCID_ID")%>', '<%=sfm.get("SERV_ID")%>', '<%=sfm.get("OFF_NM")%>', '<%=AddUtil.ChangeDate2(String.valueOf(sfm.get("ACCID_DT")))%>' ,'<%=c_db.getNameById(String.valueOf(sfm.get("REG_ID")),"USER")%>' ,'<%=sfm.get("ACCID_CONT")%>')"><%=AddUtil.ChangeDate2(String.valueOf(sfm.get("ACCID_DT")))%></a>
		  <%	}%>		  
		  <%}else{%>
		  <%	if(String.valueOf(sfm.get("CNT")).equals("0") || go_url.equals("/fms2/pay_mng/pay_dir_reg.jsp")){%>
		  <a href="javascript:parent.SetCarAccid3('<%=sfm.get("ACCID_ST2")%>', '<%=sfm.get("CAR_MNG_ID")%>', '<%=sfm.get("ACCID_ID")%>', '<%=sfm.get("SERV_ID")%>', '<%=sfm.get("OFF_NM")%>', '<%=AddUtil.ChangeDate2(String.valueOf(sfm.get("ACCID_DT")))%>' ,'<%=c_db.getNameById(String.valueOf(sfm.get("REG_ID")),"USER")%>' ,'<%=sfm.get("ACCID_CONT")%>')"><%=AddUtil.ChangeDate2(String.valueOf(sfm.get("ACCID_DT")))%></a>		  
		  <%	}else{%>
		  <%		if(mng_mode.equals("A")){%>
		  <a href="javascript:parent.SetCarAccid3('<%=sfm.get("ACCID_ST2")%>', '<%=sfm.get("CAR_MNG_ID")%>', '<%=sfm.get("ACCID_ID")%>', '<%=sfm.get("SERV_ID")%>', '<%=sfm.get("OFF_NM")%>', '<%=AddUtil.ChangeDate2(String.valueOf(sfm.get("ACCID_DT")))%>' ,'<%=c_db.getNameById(String.valueOf(sfm.get("REG_ID")),"USER")%>' ,'<%=sfm.get("ACCID_CONT")%>')"><%=AddUtil.ChangeDate2(String.valueOf(sfm.get("ACCID_DT")))%></a>
		  <%		}else{%>
		  <%=AddUtil.ChangeDate2(String.valueOf(sfm.get("ACCID_DT")))%>
		  <%		}%>
		  <%	}%>
		  <%}%>
		  </td>
          <td width=12% align="center"><%=sfm.get("ACCID_ST")%></td>
          <td width=25% align="center"><%=sfm.get("ACCID_ADDR")%></td>
          <td width=45% align="center"><%=sfm.get("ACCID_CONT")%></td>
        </tr>
        <%	}
  		}else{%>        <tr> 
          <td colspan=5 align=center height=25>등록된 데이타가 없습니다.</td>
        </tr>
        <%}%>
      </table>
    </td>
  </tr>
</table>
</body>
</html>