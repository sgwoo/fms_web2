<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.res_search.*, acar.insur.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	InsDatabase ai_db = InsDatabase.getInstance();	
	
		
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");	
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");	
	String rent_st = request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String car_no = request.getParameter("car_no")==null?"":request.getParameter("car_no");	
	
	String go_url 	= request.getParameter("go_url")==null?"":request.getParameter("go_url");
	
	//차량정보
	Hashtable reserv = rs_db.getCarInfo(c_id);
	car_no= String.valueOf(reserv.get("CAR_NO"));
	
	//보험정보
	String ins_st = ai_db.getInsSt(c_id);
	InsurBean ins = ai_db.getIns(c_id, ins_st);
%>
<html>
<head>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript">
<!--
	function SetCarServ(car_mng_Id, serv_id, off_nm, serv_dt, rep_cont, tot_dist){
		<%if(go_url.equals("/fms2/pay_mng/pay_dir_reg.jsp")){%>		
		var ofm = opener.document.form1;
		var fm = document.form1;		
		ofm.serv_id.value = serv_id;
		ofm.serv_dt.value = serv_dt;	
		ofm.tot_dist.value = tot_dist;			
		ofm.p_cont.value = ofm.p_cont.value+' '+rep_cont ;	
		self.close();				
		<%}else{%>		
		var ofm = opener.document.form1;
		var fm = document.form1;		
		ofm.serv_id.value = serv_id;
		ofm.off_nm.value = off_nm;				
		ofm.sub_c_id.value = car_mng_Id;
		if(fm.rent_st.value == '6')	ofm.serv_dt.value = serv_dt;							
		self.close();		
		<%}%>
	}
//-->
</script>
</head>
<body>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
  <form name="form1" method="post" action="sub_select_2_s.jsp">
    <input type='hidden' name='c_id' value='<%=c_id%>'>
    <input type='hidden' name='rent_st' value='<%=rent_st%>'>
    <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>	
    <input type='hidden' name='user_id' value='<%=user_id%>'>
    <input type='hidden' name='go_url' value='<%=go_url%>'>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>차량번호 : <font color=9bb70e><%=car_no%></font> </span></td>
        <td align="right">
			<%if(!c_id.equals("")){%>
			<a href='cus0401_d_sc_carhis_reg.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&car_mng_id=<%=c_id%>&rent_st=<%=rent_st%>&go_url=<%=go_url%>' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_reg.gif" align="absmiddle" border="0"></a>
			<%}%>
		</td>
        <td width=17>&nbsp;</td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2">
            <table border=0 cellspacing=1 width=100%>
                <tr> 
                    <td class=title width="5%">연번</td>
                    <td class=title width="10%">정비일자</td>
                    <td class=title width="10%">정비구분</td>
                    <td class=title width="20%">정비업체</td>
                    <td class=title width="40%">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;점검내용&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td class=title width="10%">정비금액</td>					
                    <td class=title width="5%">정비</td>										
              </tr>
            </table>
        </td>
        <td width=17>&nbsp;</td>
    </tr>
    <tr> 
        <td colspan="3"><iframe src="sub_select_2_s_in.jsp?c_id=<%=c_id%>&go_url=<%=go_url%>" name="inner_s" width="100%" height="750" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 > 
	    </iframe></td>
    </tr>
</form>
</table>
</body>
</html>