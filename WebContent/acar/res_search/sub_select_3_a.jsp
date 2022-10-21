<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.res_search.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");	
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");	
	String rent_st = request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String car_no = request.getParameter("car_no")==null?"":request.getParameter("car_no");	
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");	
	
	String go_url 	= request.getParameter("go_url")==null?"/acar/res_search/sub_select_3_a.jsp":request.getParameter("go_url");
	
	//차량정보
	Hashtable reserv = rs_db.getCarInfo(c_id);
%>
<html>
<head>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript">
<!--
	function SetCarAccid(accid_st, car_mng_id, accid_id, serv_id, off_nm, accid_dt, car_no, car_nm, our_num, ins_nm, ins_mng_nm, age_scp){
		<%if(go_url.equals("/fms2/pay_mng/pay_dir_reg.jsp")){%>
		var ofm = opener.document.form1;
		var fm = document.form1;		
		ofm.accid_id.value = accid_id;
		ofm.accid_dt.value = accid_dt;			
		ofm.accid_st.value = accid_st;			
		self.close();		
		<%}else{%>
		var ofm = opener.document.form1;
		var fm = document.form1;		
		ofm.accid_id.value = accid_id;
		ofm.off_nm.value = off_nm;				
		ofm.sub_c_id.value = car_mng_id;		
		ofm.car_no.value = car_no;		
		ofm.car_nm.value = car_nm;		
		ofm.our_num.value = our_num;		
		ofm.ins_nm.value = ins_nm;						
		ofm.ins_mng_nm.value = ins_mng_nm;		
		self.close();		
		<%}%>
	}

	function SetCarAccid2(accid_st, car_mng_id, accid_id, serv_id, off_nm, accid_dt, accid_mng_nm, accid_cont){
		<%if(go_url.equals("/fms2/pay_mng/pay_dir_reg.jsp")){%>
		var ofm = opener.document.form1;
		var fm = document.form1;		
		ofm.accid_id.value = accid_id;
		ofm.accid_dt.value = accid_dt;	
		ofm.accid_st.value = accid_st;			
		self.close();		
		<%}else{%>
		var ofm = opener.document.form1;
		var fm = document.form1;		
		ofm.accid_id.value = accid_id;
		ofm.off_nm.value = off_nm;				
		ofm.accid_dt.value = accid_dt;		
		ofm.accid_mng_nm.value = accid_mng_nm;		
		ofm.accid_cont.value = accid_cont;								
		self.close();		
		<%}%>
	}
	
	function SetCarAccid3(accid_st, car_mng_id, accid_id, serv_id, off_nm, accid_dt, accid_mng_nm, accid_cont){
		<%if(go_url.equals("/fms2/pay_mng/pay_dir_reg.jsp")){%>
		var ofm = opener.document.form1;
		var fm = document.form1;		
		ofm.accid_id.value = accid_id;
		ofm.accid_dt.value = accid_dt;	
		ofm.accid_st.value = accid_st;			
		self.close();		
		<%}else{%>
		var ofm = opener.document.form1;
		var fm = document.form1;		
		ofm.accid_id.value = accid_id;			
		ofm.off_nm.value = off_nm;										
		self.close();				
		<%}%>
	}	
//-->
</script>
</head>
<body>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
  <form name="form1" method="post" action="sub_select_2_s.jsp">
    <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
    <input type='hidden' name='c_id' value='<%=c_id%>'>
    <input type='hidden' name='rent_st' value='<%=rent_st%>'>
    <input type='hidden' name='user_id' value='<%=user_id%>'>
    <input type='hidden' name='car_no' value='<%=car_no%>'>	
    <input type='hidden' name='gubun' value='<%=gubun%>'>		
    <input type='hidden' name='go_url' value='<%=go_url%>'>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>차량번호 : <font color=9bb70e><%=reserv.get("CAR_NO")%></font></span></td>
        <td align="right">
	    <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
		<%		if(!c_id.equals("")){%>
	    <a href='/acar/accid_reg/accid_reg_frame.jsp?auth_rw=<%=auth_rw%>&c_id=<%=c_id%>&rent_st=<%=rent_st%>&user_id=<%=user_id%>&car_no=<%=car_no%>&gubun=<%=gubun%>&go_url=<%=go_url%>' onMouseOver="window.status=''; return true">
        <img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>
	    <%		}%>
		<%}%>
	    </td>
        <td width=17>&nbsp;</td>
    </tr>
    <tr>
        <td class=line2 colspan="2"></td>
    </tr>
    <tr> 
        <td  class=line colspan="2">
            <table border=0 cellspacing=1 width=100%>
                <tr> 
                    <td class=title width="6%">연번</td>
                    <td class=title width="12%">사고일자</td>
                    <td class=title width="12%">사고구분</td>
                    <td class=title width="25%">사고장소</td>
                    <td class=title width="45%">&nbsp;&nbsp;&nbsp;사고내용&nbsp;&nbsp;&nbsp;</td>
                </tr>
            </table>
        </td>
        <td width=17>&nbsp;</td>
    </tr>
    <tr> 
        <td colspan="3"><iframe src="sub_select_3_a_in.jsp?gubun=<%=gubun%>&c_id=<%=c_id%>&rent_st=<%=rent_st%>&go_url=<%=go_url%>" name="inner_s" width="100%" height="500" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 > 
	    </iframe></td>
    </tr>
</form>
</table>
</body>
</html>